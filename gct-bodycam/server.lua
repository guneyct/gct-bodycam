local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('sove:item', function(source, cb, item)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local qtty = xPlayer.Functions.GetItemByName(item).amount
    cb(qtty)
end)

function getIdentity(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    return {
        firstname = xPlayer.PlayerData.charinfo.firstname,
        lastname = xPlayer.PlayerData.charinfo.lastname
    }
end

RegisterNetEvent("gct-bodycam:server:openMenu", function(PlayerJob)
    TriggerClientEvent("gct-bodycam:client:bodyCamera", source, PlayerJob)
end)

RegisterNetEvent("gct-bodycam:server:openPlayerCam", function(playerData)
    local src = source
    local TargetPlayer = QBCore.Functions.GetPlayerByCitizenId(playerData.identifier)
    TriggerClientEvent("gct-bodycam:client:openCamera", src, TargetPlayer.PlayerData.source)
end)

RegisterNetEvent("gct-bodycam:server:setBodycamPlayers", function(PlayerPeds)
    TriggerClientEvent("gct-bodycam:client:setBodycamPlayers", -1, PlayerPeds)
end)

RegisterNetEvent("gct-bodycam:server:cullingRadius", function(radius, src)
    local ped = GetPlayerPed(src)
    if ped then
        SetEntityDistanceCullingRadius(ped, radius)
    end
end)

QBCore.Functions.CreateCallback("gct-bodycam:client:getPlayers", function(source, cb, BodycamPlayers, job)
    local data = {}
    for k, v in pairs(BodycamPlayers) do
        if v ~= nil or v ~= "" then
            local Player = QBCore.Functions.GetPlayer(k)
            if Player.PlayerData.job.name == job and k ~= source then
                data[k] = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
            end
        end
    end

    cb(data)
end)

QBCore.Functions.CreateUseableItem('bodycam', function(source)
    local Player = QBCore.Functions.GetPlayer(source)

    for k, v in pairs(Config.Jobs) do
        if Player.PlayerData.job.name == v then
            TriggerClientEvent('gct-bodycam:show', source, Player.PlayerData.job.name, Player.PlayerData.job.grade.name,
                Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                Player.PlayerData.source)
        end
    end
end)
