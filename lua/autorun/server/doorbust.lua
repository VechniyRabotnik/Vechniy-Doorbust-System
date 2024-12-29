local Config = include("config.lua")
local texts = Config.Texts[Config.Language]
local allowedJobs = Config.AllowedJobs

util.AddNetworkString("DoorBust_DoBust")
util.AddNetworkString("DoorBust_Timer")

local GetActive = false

local function DoorBust(ply, text)
    if text == Config.Command then
        if GetActive then return end
        
        if allowedJobs[ply:Team()] then
            if not IsValid(ply) or not ply:IsPlayer() then return end
            local tr = ply:GetEyeTrace()
            if IsValid(tr.Entity) and tr.Entity:GetClass() == "func_door" then
                local timerDuration = 5
                net.Start("DoorBust_DoBust")
                net.WriteBool(true)
                net.Send(ply)
                net.Start('DoorBust_Timer')
                net.WriteFloat(timerDuration)
                net.Send(ply)

                local distancenew = ply:GetPos():Distance(tr.Entity:GetPos())
                if distancenew > 90 then
                    ply:ChatPrint(texts.TooFar)
                    net.Start("DoorBust_DoBust")
                    net.WriteBool(false)
                    net.Send(ply)
                    return
                end

                GetActive = true

                timer.Simple(timerDuration, function()
                    if IsValid(tr.Entity) and tr.Entity:IsValid() then
                        local distance = ply:GetPos():Distance(tr.Entity:GetPos())
                        if distance > 90 then
                            ply:ChatPrint(texts.TooFar)
                            net.Start("DoorBust_DoBust")
                            net.WriteBool(false)
                            net.Send(ply)
                            GetActive = false
                            return
                        end

                        tr.Entity:Fire("Open")
                        net.Start("DoorBust_DoBust")
                        net.WriteBool(false)
                        net.Send(ply)
                        GetActive = false
                    end
                end)
            end
        else
            ply:ChatPrint(texts.InvalidJob)
        end
        return ""
    end
end
hook.Add("PlayerSay", "DoorBust", DoorBust)