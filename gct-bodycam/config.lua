Config = {}

Config.Jobs = {
    "police",
    "sheriff"
}

Config.ExitKey = 38 -- E | https://docs.fivem.net/docs/game-references/controls/

Config.LookCam = {
    [1] = {
        coords = vector3(441.28, -996.61, 34.97),
        zoneX = 1.5,
        zoneY = 1.5,
        heading = 180.63505,
        minZ = 33.97,
        maxZ = 35.97,
        debug = false,

        icon = "fa-solid fa-video",
        job = "police",
        optionLabel = "Bodycam Kameralarından Bak"
    }
}

Config.Language = {
    ["menu_header"] = "Vücut Kameraları",
    ["menu_header_txt"] = "Meslek: ", -- Meslek: LSPD
    ["menu_exit"] = "Kapat",
    ["menu_exit_txt"] = "Kamerayı Kapat",

    ["look_cam"] = "Bu kişinin kamerasından bak!",

    ["notify_error"] = "Bir hata oluştu! Lütfen menüye tekrar giriniz!",
    ["cannot_look_yourself"] = "Kendi Kameranıza bakamazsınız!",

    ["bodycam_exit"] = "Kameradan Çıkmak için [E] Tuşuna basınız!"
}