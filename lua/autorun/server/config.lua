
DoorBustConfig = DoorBustConfig or {}

DoorBustConfig.Language = "ru" --  "en", "fr", "de", "ru"
DoorBustConfig.Command = "/doorbust"
DoorBustConfig.AllowedJobs = {
    [TEAM_CITIZEN] = true,
}

-- Тексты на разных языках
DoorBustConfig.Texts = {
    en = {
        DoorBreakSoon = "The door will break soon",
        TooFar = "You are too far from the door. /doorbust canceled.",
        NotAllowed = "You are not allowed to use /doorbust.",
        DoorBroken = "The door is broken",
    },
    fr = {
        DoorBreakSoon = "La porte va bientôt se casser",
        TooFar = "Vous êtes trop loin de la porte. /doorbust annulé.",
        NotAllowed = "Vous n'êtes pas autorisé à utiliser /doorbust.",
        DoorBroken = "La porte est cassée",
    },
    de = {
        DoorBreaksoon = "Die Tür wird bald kaputt sein",
        TooFar = "Sie sind zu weit von der Tür entfernt. /doorbust abgebrochen.",
        NotAllowed = "Sie sind nicht berechtigt, /doorbust zu verwenden.",
        DoorBroken = "Die Tür ist kaputt",
    },
    ru = {
        DoorBreakSoon = "Дверь скоро сломается",
        TooFar = "Вы слишком далеко от двери. /doorbust прерван.",
        NotAllowed = "Вы не имеете права использовать /doorbust.",
        DoorBroken = "Дверь сломана",
    },
}

DoorBustConfig.RealoadDelay = 0

print("DoorBustConfig загружен успешно.")