
include("config.lua")

if SERVER then
    AddCSLuaFile("config.lua")
end

util.AddNetworkString("DoorBust_DoBust")
util.AddNetworkString("DoorBust_SaveMarkers")

local GetActive = false

local function DoorBust(ply, text)
    if text == DoorBustConfig.Command then
        if not GetActive then
            GetActive = true
            
            if DoorBustConfig.AllowedJobs[ply:Team()] then
                local plyPos = ply:GetPos()
                
                local tr = ply:GetEyeTrace()
                if IsValid(tr.Entity) and tr.Entity:GetClass() == "func_door" then
                    local distance = plyPos:Distance(tr.Entity:GetPos())
                    
                    if distance > 90 then
                        ply:ChatPrint(DoorBustConfig.Texts[DoorBustConfig.Language].TooFar)
                        net.Start("DoorBust_DoBust")
                        net.WriteBool(false)
                        net.Send(ply)
                        GetActive = false
                        return
                    end
                    
                    local timerDuration = 5
                    
                    net.Start("DoorBust_DoBust")
                    net.WriteBool(true)
                    net.Send(ply)
                    
                    local entPos = ply:GetPos()
                    local doorPos = tr.Entity:GetPos()
                    
                    if entPos:Distance(doorPos) > 90 then
                        ply:ChatPrint(DoorBustConfig.Texts[DoorBustConfig.Language].TooFar)
                        net.Start("DoorBust_DoBust")
                        net.WriteBool(false)
                        net.Send(ply)
                        GetActive = false
                        return
                    end
                    
                    timer.Simple(timerDuration, function()
                        tr.Entity:Fire("Open")
                        
                        ply:ChatPrint(DoorBustConfig.Texts[DoorBustConfig.Language].DoorBroken)
                        
                        hook.Call( "OnDoorBroken", "DoorbustListening", ply)
                        
                        net.Start("DoorBust_DoBust")
                        net.WriteBool(false)
                        net.Send(ply)
                        
                        GetActive = false
                    end)
                else
                    ply:ChatPrint(DoorBustConfig.Texts[DoorBustConfig.Language].NotAllowed)
                end
            else
                ply:ChatPrint(DoorBustConfig.Texts[DoorBustConfig.Language].NotAllowed)
            end
        end
        return ""
    end
end

hook.Add("PlayerSay", "DoorBust", DoorBust)

hook.Add("OnDoorBroken", "DoorbustListening", function(ply)

end)
