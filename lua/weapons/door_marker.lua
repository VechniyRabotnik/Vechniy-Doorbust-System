SWEP.PrintName = "DoorMaker" 
SWEP.Author = "VechniyRabotnik" 
SWEP.Category = "Vechn_Doorbust"

SWEP.Spawnable              = true
SWEP.AdminOnly              = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

SWEP.Weight	                = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

SWEP.Slot			        = 0
SWEP.SlotPos			    = 1
SWEP.DrawAmmo			    = false
SWEP.DrawCrosshair		    = true

SWEP.ViewModel = "models/weapons/v_357_dx7.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

local Config = include("config.lua")
local texts = Config.Texts[Config.Language]

function SWEP:Initialize()
	self:SetSkin(12)
end

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local ply = self.Owner
    if not IsValid(ply) or not ply:Alive() then return end

    self.Weapon:SetNextPrimaryFire(CurTime() + 1)

    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) or ent:GetClass() ~= "func_door" then return end
    
    ent:SetNWString("DoorMarker", "SpecialDoor")

    if SERVER then
        ply:ChatPrint(texts.DoorMarkerSet .. ent:GetNWString("DoorMarker", ""))
    end
end

function SWEP:SecondaryAttack()
    local ply = self.Owner
    local tr = ply:GetEyeTrace().Entity

    if SERVER then
        if IsValid(tr) then
            local marker = tr:GetNWString("DoorMarker", "")
            ply:ChatPrint(texts.GetClass .. marker)
        else
            --ply:ChatPrint("На что-то не смотришь.")
        end
    end
end

function MainMenu_Edit()
    if CLIENT then
        local frameDoor = vgui.Create("DFrame")
        frameDoor:SetSize(200, 100)
        frameDoor:Center()
        frameDoor:SetTitle("Door Marker Menu")
        frameDoor:SetVisible(true)
        frameDoor:SetDraggable(false)
        frameDoor:ShowCloseButton(true)
        frameDoor:MakePopup()

        local button = vgui.Create("DButton", frameDoor)
        button:SetText("Save Markers")
        button:SetPos(10, 30)
        button:SetSize(180, 25)
        button.DoClick = function()
            if SERVER then
            net.Start("DoorBust_SaveMarkers")
            net.SendToServer()
            end
        end
    end
end

local delay = 0

function SWEP:Reload()
    if CurTime() < delay then return end
    MainMenu_Edit()
    delay = CurTime() + 3
end