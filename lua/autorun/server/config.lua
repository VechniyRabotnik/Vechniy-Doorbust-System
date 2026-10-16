DoorBustConfig = DoorBustConfig or {}

DoorBustConfig.Language = "ru" --  "en", "fr", "de", "ru"
DoorBustConfig.Command = "/doorbust"
DoorBustConfig.BustDuration = 5 -- Время взлома в секундах
DoorBustConfig.MaxDistance = 90 -- Максимальная дистанция до двери

DoorBustConfig.AllowedJobs = {}

if TEAM_SCP999 then
    DoorBustConfig.AllowedJobs[TEAM_SCP999] = true
end

DoorBustConfig.Texts = {
    en = {
        DoorBreakSoon = "The door will break soon",
        TooFar = "You are too far from the door. /doorbust canceled.",
        NotAllowed = "You are not allowed to use /doorbust.",
        DoorBroken = "The door is broken!",
        NeedLook = "You need to look at a door.",
        DoorGone = "The door disappeared...",
        BustStart = "Starting to break the door...",
        AlreadyBusting = "You are already breaking a door!",
    },
    fr = {
        DoorBreakSoon = "La porte va bientôt se casser",
        TooFar = "Vous êtes trop loin de la porte. /doorbust annulé.",
        NotAllowed = "Vous n'êtes pas autorisé à utiliser /doorbust.",
        DoorBroken = "La porte est cassée !",
        NeedLook = "Vous devez regarder une porte.",
        DoorGone = "La porte a disparu...",
        BustStart = "Début du crochetage de la porte...",
        AlreadyBusting = "Vous êtes déjà en train de crocheter une porte !",
    },
    de = {
        DoorBreakSoon = "Die Tür wird bald kaputt sein",
        TooFar = "Sie sind zu weit von der Tür entfernt. /doorbust abgebrochen.",
        NotAllowed = "Sie sind nicht berechtigt, /doorbust zu verwenden.",
        DoorBroken = "Die Tür ist kaputt!",
        NeedLook = "Sie müssen eine Tür ansehen.",
        DoorGone = "Die Tür ist verschwunden...",
        BustStart = "Aufbrechen der Tür beginnt...",
        AlreadyBusting = "Siebrechen bereits eine Tür auf!",
    },
    ru = {
        DoorBreakSoon = "Дверь скоро сломается",
        TooFar = "Вы слишком далеко от двери. /doorbust прерван.",
        NotAllowed = "Вы не имеете права использовать /doorbust.",
        DoorBroken = "Дверь успешно сломана!",
        NeedLook = "Нужно смотреть на дверь.",
        DoorGone = "Дверь пропала...",
        BustStart = "Начинаем взлом двери…",
        AlreadyBusting = "Вы уже взламываете дверь!",
    },
}

print("[VechnDoorBust] Config loaded successfully.")