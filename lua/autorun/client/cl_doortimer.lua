if CLIENT then


    local isWaiting = false
    local endTime   = 0
    local MainTime  = 5

    net.Receive("DoorBust_DoBust", function()
        isWaiting = net.ReadBool()
        if isWaiting then
            endTime = CurTime() + MainTime
        else
            endTime = 0
        end
    end)

    net.Receive("DoorBust_Chat", function()
        local r = net.ReadUInt(8)
        local g = net.ReadUInt(8)
        local b = net.ReadUInt(8)
        local msg = net.ReadString()
        chat.AddText(
            Color(40,130,255), "[DoorBust] ",
            Color(r,g,b), msg
        )
    end)

    hook.Add("HUDPaint", "DoorBustHUD", function()
        if not isWaiting then return end

        local bgColor      = Color(20, 20, 20, 140)
        local barBgColor   = Color(20, 20, 20, 100)
        local barFillColor = Color(100, 200, 100, 200)

        local panelW, panelH = 300, 100
        local x = (ScrW() - panelW) / 2
        local y = (ScrH() - panelH) / 2

        draw.RoundedBox(8, x, y, panelW, panelH, bgColor)

        local timeLeft = math.max(endTime - CurTime(), 0)
        local secs     = math.ceil(timeLeft)

        draw.SimpleText(
            secs, "font.40",
            x + panelW/2, y + panelH/2 - 10,
            barFillColor,
            TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
        )

        local progress = (MainTime - timeLeft) / MainTime
        local barW, barH = panelW - 40, 8
        local barX, barY = x + 20, y + panelH - 25

        draw.RoundedBox(4, barX, barY, barW, barH, barBgColor)
        draw.RoundedBox(4, barX, barY, barW * progress, barH, barFillColor)

        if timeLeft <= 0 then
            isWaiting = false
        end
    end)
end