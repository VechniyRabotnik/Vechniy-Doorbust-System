
util.AddNetworkString("DoorBust_DoBust")
util.AddNetworkString("DoorBust_Chat")

local function SendChat(ply, color, text)
    net.Start("DoorBust_Chat")
        net.WriteUInt(color.r, 8)
        net.WriteUInt(color.g, 8)
        net.WriteUInt(color.b, 8)
        net.WriteString(text)
    net.Send(ply)
end


hook.Add("PlayerSay", "DoorBust", function(ply, text)
    if text ~= "/doorbust" then return end
    local allowedJobs = {
        [TEAM_SCP999] = true, 
    }
    
    local sid64 = ply:SteamID64()
    local checkName  = "DoorBust_check_"  .. sid64
    local finishName = "DoorBust_finish_" .. sid64
    if timer.Exists(finishName) then
        return "" 
    end

    if not allowedJobs[ply:Team()] then
        SendChat(ply, Color(255,100,100), "Вам запрещено использовать /doorbust.")
        return ""
    end

    local tr = ply:GetEyeTrace()
    if not (IsValid(tr.Entity) and tr.Entity:GetClass() == "func_door") then
        SendChat(ply, Color(255,100,100), "Нужно смотреть на дверь.")
        return ""
    end

    if ply:GetPos():Distance(tr.Entity:GetPos()) > 90 then
        SendChat(ply, Color(255,100,100), "Вы слишком далеко от двери.")
        return ""
    end

    net.Start("DoorBust_DoBust")
        net.WriteBool(true)
    net.Send(ply)
    SendChat(ply, Color(100,200,100), "Начинаем взлом двери…")

    local duration = 5 

    timer.Create(checkName, 0.1, 0, function()
        if not IsValid(ply) or not IsValid(tr.Entity) then
            if IsValid(ply) then
                SendChat(ply, Color(255,100,100), "Дверь пропала...")
                net.Start("DoorBust_DoBust") net.WriteBool(false) net.Send(ply)
            end
            timer.Remove(checkName)
            timer.Remove(finishName)
            return
        end
        if ply:GetPos():Distance(tr.Entity:GetPos()) > 90 then
            SendChat(ply, Color(255,100,100), "Вы слишком далеко от двери.")
            net.Start("DoorBust_DoBust") net.WriteBool(false) net.Send(ply)
            timer.Remove(checkName)
            timer.Remove(finishName)
        end
    end)

    timer.Create(finishName, duration, 1, function()
        if IsValid(ply) and IsValid(tr.Entity) then
            tr.Entity:Fire("Open")
            SendChat(ply, Color(100,200,100), "Дверь успешно сломана!")
            net.Start("DoorBust_DoBust") net.WriteBool(false) net.Send(ply)
        end
        timer.Remove(checkName)
        timer.Remove(finishName)
    end)

    return ""
end)