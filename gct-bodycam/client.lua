local QBCore = exports['qb-core']:GetCoreObject()

local BodycamPlayers = {}

local PlayerData = {}
local bodycam = false

local cam
local opencam = false
local targetPed
local closed = false
local targetPedSource = nil

RegisterNetEvent("gct-bodycam:show", function(job, grade, name, src)
    local year, month, day, hour, minute, second = GetLocalTime()

    if bodycam == false then
        bodycam = true
        if tonumber(minute) < 10 then
            minute = '0' .. minute
        end

        if tonumber(second) < 10 then
            second = '0' .. second
        end

        BodycamPlayers[src] = src
        TriggerServerEvent("gct-bodycam:server:setBodycamPlayers", BodycamPlayers)

        SendNUIMessage({
            day = day,
            month = month,
            year = year,
            hour = hour,
            minute = minute,
            second = second,
            pName = name,
            jobGrade = grade,
            open = true,
            jobName = job
        })
    else
        BodycamPlayers[src] = {}
        TriggerServerEvent("gct-bodycam:server:setBodycamPlayers", BodycamPlayers)
        closed = true
        bodycam = false
        SendNUIMessage({
            open = false
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        if bodycam then
            local year, month, day, hour, minute, second = GetLocalTime()

            SendNUIMessage({
                day = day,
                month = month,
                year = year,
                hour = hour,
                minute = minute,
                second = second,
                open = "update"
            })
            Wait(500)
        end
    end
end)

RegisterNetEvent("gct-bodycam:client:setBodycamPlayers", function(PlayerPeds)
    BodycamPlayers = PlayerPeds
end)

RegisterNetEvent("gct-bodycam:close", function(src)
    bodycam = false
    closed = true

    BodycamPlayers[src] = {}
    TriggerServerEvent("gct-bodycam:server:setBodycamPlayers", BodycamPlayers)

    SendNUIMessage({
        open = false
    })
end)

local aktif = false

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo

    for k, v in pairs(Config.Jobs) do
        if PlayerData.job.name == v then -- edit here
            SendNUIMessage({
                open = false
            })
        end
    end    
end)

RegisterNetEvent('gct-bodycam:client:openCamera', function(src)
    ClearFocus()
    ExecuteCommand("e tablet")
    TriggerServerEvent("gct-bodycam:server:cullingRadius", 10000.0, src)
    Wait(2000)

    targetPedSource = src

    local playerId = GetPlayerFromServerId(src)
    targetPed = GetPlayerPed(playerId)

    if targetPed == nil then
        QBCore.Functions.Notify(Config.Language["notify_error"], "error", 3000)
        ExecuteCommand("e c")
        return
    end

    if targetPed == PlayerPedId() then
        QBCore.Functions.Notify(Config.Language["cannot_look_yourself"], "error", 3000)
        ExecuteCommand("e c")
        return
    end

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(targetPed), 0, 0, 0,
        GetGameplayCamFov() * 1.0)

    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)

    local offsetCoords = GetOffsetFromEntityGivenWorldCoords(targetPed, GetCamCoord(cam))
    AttachCamToEntity(cam, targetPed, offsetCoords.x + 0.3, offsetCoords.y + 0.3, offsetCoords.z + 0.3, true)
    SetTimecycleModifier("scanline_cam_cheap")
    SetTimecycleModifierStrength(2.0)
    local entityRot = GetEntityRotation(targetPed, 2)
    SetCamRot(cam, entityRot.x, entityRot.y, entityRot.z, 2)
    opencam = true
    SetFocusEntity(targetPed)

    exports['qb-core']:DrawText(Config.Language["bodycam_exit"])
end)

Citizen.CreateThread(function()
    while true do
        sleep = 2500
        if opencam then
            local entityRot = GetEntityRotation(targetPed, 2)
            SetCamRot(cam, entityRot.x, entityRot.y, entityRot.z, 2)

            DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(1, 37, true) -- disable weapon select
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 30, true) -- disable left/right
            DisableControlAction(0, 31, true) -- disable forward/back
            DisableControlAction(0, 36, true) -- INPUT_DUCK
            DisableControlAction(0, 21, true) -- disable sprint
            DisableControlAction(0, 289, true) -- disable F2
            DisableControlAction(0, 288, true) -- disable F1
            DisableControlAction(0, 170, true) -- disable F3
            DisableControlAction(0, 20, true) -- disable Z
            DisableControlAction(0, 48, true) -- disable Z
            DisableControlAction(0, 19, true) -- disable LEFT ALT
            DisableControlAction(0, 19, true) -- disable LEFT ALT

            if IsControlJustPressed(0, Config.ExitKey) then
                exitCam()
            end

            if closed then
                closed = false
                opencam = false
                exitCam()
            end

            sleep = 1
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('gct-bodycam:client:exitCamera', function(src)
    exitCam()
end)

function exitCam()
    ClearFocus()
    exports['qb-core']:HideText()
    ExecuteCommand("e c")
    TriggerServerEvent("gct-bodycam:server:cullingRadius", 0.0, targetPedSource)
    Wait(2000)
    targetPedSource = nil
    RenderScriptCams(false, false, 0, true, false)
    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(1.0)
    DestroyCam(cam, false)
    SetCamFov(cam, GetGameplayCamFov())
    SetFocusEntity(PlayerPedId())

    targetPed = nil
    cam = nil
    opencam = false
end

RegisterNetEvent("gct-bodycam:client:bodyCamera", function(job)
    openBodyCamMenu(job)
end)

function openBodyCamMenu(job)
    QBCore.Functions.TriggerCallback("gct-bodycam:client:getPlayers", function(players)
        local menu = {{
            header = Config.Language["menu_header"],
            txt = Config.Language["menu_header_txt"].. QBCore.Shared.Jobs[job].label,
            isMenuHeader = true
        }}

        for k, v in pairs(players) do
            menu[#menu + 1] = {
                header = v,
                txt = Config.Language["look_cam"],
                params = {
                    event = "gct-bodycam:client:openCamera",
                    args = k
                }
            }
        end

        menu[#menu + 1] = {
            header = Config.Language["menu_exit"],
            txt = Config.Language["menu_exit_txt"],
            params = {
                event = "qb-menu:client:closeMenu"
            }
        }

        exports['qb-menu']:openMenu(menu)
    end, BodycamPlayers, job)
end

local function createZone()
    for k, v in pairs(Config.LookCam) do
        exports['qb-target']:AddBoxZone(v.job .. '_bodycamcam', v.coords, v.zoneX, v.zoneY, {
            name = v.job .. '_bodycam',
            heading = v.heading,
            minZ = v.minZ,
            maxZ = v.maxZ,
            debugPoly = v.debug
        }, {
            options = {{
                type = "client",
                action = function()
                    openBodyCamMenu(v.job)
                end,
                icon = v.icon,
                label = v.optionLabel,
                job = v.job
            }},
            distance = 3.5
        })
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    createZone()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        createZone()
    end
end)

exports('isCamOpen', function()
    return opencam
end)

exports("getActiveBodycams", function()
    return BodycamPlayers
end)