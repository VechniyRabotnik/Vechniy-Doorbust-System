util.AddNetworkString("DoorBust_DoBust")
util.AddNetworkString("DoorBust_Chat")
util.AddNetworkString("DoorBust_SaveMarkers")
util.AddNetworkString("DoorBust_OpenMenu")

local function GetText(key)
    local lang = DoorBustConfig.Language or "ru"
    if DoorBustConfig.Texts[lang] and DoorBustConfig.Texts[lang][key] then
        return DoorBustConfig.Texts[lang][key]
    end
    return DoorBustConfig.Texts["en"][key] or key
end

local function SendChat(ply, color, text)
    net.Start("DoorBust_Chat")
        net.WriteUInt(color.r, 8)
        net.WriteUInt(color.g, 8)
        net.WriteUInt(color.b, 8)
        net.WriteString(text)
    net.Send(ply)
end

hook.Add("PlayerSay", "DoorBust_Command", function(ply, text)
    if text:lower() ~= (DoorBustConfig.Command or "/doorbust"):lower() then return end

    local sid64 = ply:SteamID64()
    local checkName = "DoorBust_check_" .. sid64
    local finishName = "DoorBust_finish_" .. sid64

    if timer.Exists(finishName) then
        SendChat(ply, Color(255, 100, 100), GetText("AlreadyBusting"))
        return ""
    end

    if DoorBustConfig.AllowedJobs and table.Count(DoorBustConfig.AllowedJobs) > 0 then
        if not DoorBustConfig.AllowedJobs[ply:Team()] then
            SendChat(ply, Color(255, 100, 100), GetText("NotAllowed"))
            return ""
        end
    end

    local tr = ply:GetEyeTrace()
    local ent = tr.Entity
    local isDoor = IsValid(ent) and (ent:GetClass() == "func_door" or ent:GetClass() == "prop_door_rotating" or ent:GetNWString("DoorMarker", "") == "SpecialDoor")

    if not isDoor then
        SendChat(ply, Color(255, 100, 100), GetText("NeedLook"))
        return ""
    end

    if ply:GetPos():Distance(ent:GetPos()) > (DoorBustConfig.MaxDistance or 90) then
        SendChat(ply, Color(255, 100, 100), GetText("TooFar"))
        return ""
    end

    net.Start("DoorBust_DoBust")
        net.WriteBool(true)
    net.Send(ply)
    SendChat(ply, Color(100, 200, 100), GetText("BustStart"))

    local duration = DoorBustConfig.BustDuration or 5

    timer.Create(checkName, 0.1, 0, function()
        if not IsValid(ply) or not IsValid(ent) then
            if IsValid(ply) then
                SendChat(ply, Color(255, 100, 100), GetText("DoorGone"))
                net.Start("DoorBust_DoBust") net.WriteBool(false) net.Send(ply)
            end
            timer.Remove(checkName)
            timer.Remove(finishName)
            return
        end
        if ply:GetPos():Distance(ent:GetPos()) > (DoorBustConfig.MaxDistance or 90) then
            SendChat(ply, Color(255, 100, 100), GetText("TooFar"))
            net.Start("DoorBust_DoBust") net.WriteBool(false) net.Send(ply)
            timer.Remove(checkName)
            timer.Remove(finishName)
        end
    end)

    timer.Create(finishName, duration, 1, function()
        if IsValid(ply) and IsValid(ent) then
            ent:Fire("Open")
            SendChat(ply, Color(100, 200, 100), GetText("DoorBroken"))
            net.Start("DoorBust_DoBust") net.WriteBool(false) net.Send(ply)
        end
        timer.Remove(checkName)
        timer.Remove(finishName)
    end)

    return ""
end)

net.Receive("DoorBust_SaveMarkers", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end
    ply:ChatPrint("[VechnDoorBust] Маркеры успешно сохранены!")
end)