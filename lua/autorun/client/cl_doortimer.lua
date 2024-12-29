local Config = include("config.lua") 
local texts = Config.Texts[Config.Language]

--local function UpdateTexts()
--    texts = Config.Texts[Config.Language] or Config.Texts["en"] 
--end

--UpdateTexts()

if CLIENT then
    local receivethis = false
    local MainTime = 5
    local MainTimeEnd = 0

    surface.CreateFont("VechnFont.28", {
        font = "Arial", 
        size = 28,
        weight = 500,
        antialias = true,
    })

    net.Receive("DoorBust_DoBust", function()
        receivethis = net.ReadBool()
    end)

    function SetHudTimer()
        if receivethis then
            local plyr = LocalPlayer()
            if not IsValid(plyr) or not plyr:Alive() then return end
            
            if MainTimeEnd == 0 then
                MainTimeEnd = CurTime() + MainTime
            end
    
            local x = ScrW() / 2 
            local y = ScrH() / 2
            local timeRemaining = math.max(MainTimeEnd - CurTime(), 0)
    
            draw.DrawText(texts.DoorBustActive, "VechnFont.28", x, y - 40, color_white, TEXT_ALIGN_CENTER)
            draw.DrawText(math.ceil(timeRemaining), "VechnFont.28", x, y + 20, color_green, TEXT_ALIGN_CENTER)
    
            if timeRemaining <= 0 then
                MainTimeEnd = 0
            end
        else 
            MainTimeEnd = 0
        end
    end

    hook.Add("HUDPaint", "VechniyDoorbust", SetHudTimer)
end