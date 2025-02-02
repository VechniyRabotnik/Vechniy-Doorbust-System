include("autorun/server/config.lua")

surface.CreateFont("VechnFont.28", {
    font = "Arial", 
    size = 28,
    weight = 500,
    antialias = true,
})

local receivethis = false

local MainTime = 5
local MainTimeEnd = 0

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
        
        draw.DrawText( DoorBustConfig.Texts[DoorBustConfig.Language].DoorBreakSoon, "VechnFont.28", x + 20, y - 40, color_white, TEXT_ALIGN_CENTER )
        draw.DrawText( math.ceil(timeRemaining), "VechnFont.28", x + 30, y + 20, color_green, TEXT_ALIGN_CENTER )
        
        if timeRemaining <= 0 then
            MainTimeEnd = 0
        end
    else 
        MainTimeEnd = 0
    end
end

hook.Add("HUDPaint", "VechniyDoorbust", SetHudTimer)

function netReceive()
    receivethis = net.ReadBool()
end

hook.Add("InitPostEntity", "DoorBust_Init", function()
    net.Receive = netReceive
end)