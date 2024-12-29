/* */

local Config = {}
-- Команда/Сommand
Config.Command = "/doorbust"
-- Установите нужный язык / Set the desired language
Config.Language = "en"

Config.Texts = {
    ru = {
        DoorBustActive = "Дверь скоро сломается",
        TooFar = "Вы слишком далеко от двери. /doorbust прерван",
        InvalidJob = "Установи нужную профессию",
        DoorMarkerSet = "Установлена штука: ",
        GetClass = "GetClass: ",
    },
    en = {
        DoorBustActive = "The door will be broken soon",
        TooFar = "You are too far from the door. /doorbust canceled",
        InvalidJob = "You are not the right profession",
        DoorMarkerSet = "Marker set: ",
        GetClass = "GetClass: ",
    },
    ["fr"] = {
        DoorBustActive = "La porte va bientôt se briser",
        TooFar = "Vous êtes trop loin de la porte. / doorbust",
        InvalidJob = "Définir la profession souhaitée",
        DoorMarkerSet = "Pièce installée: ",
        GetClass = "GetClass: ",
    },
    ["de"] = {
        DoorBustActive = "Die Tür wird bald brechen",
        TooFar = "Sie sind zu weit von der Tür entfernt. /doorbust unterbrochen",
        InvalidJob = "Stellen Sie den gewünschten Beruf ein",
        DoorMarkerSet = "Stück installiert: ",
        GetClass = "GetClass: ",
    }
}

Config.AllowedJobs = {
    [TEAM_CITIZEN] = true,
    -- [TEAM_SCP173] = true,
    -- [TEAM_SCP076] = true,
}

return Config