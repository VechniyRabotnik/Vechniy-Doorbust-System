SWEP.PrintName = "Конфигуратор дверей"
SWEP.Author = "VechniyRabotnik"
SWEP.Category = "Vechn_DoorBust"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = "models/weapons/v_357_dx7.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

function SWEP:Initialize()
    self:SetSkin(12)
end

function SWEP:PrimaryAttack()
    if CLIENT then return end

    local ply = self.Owner
    if not IsValid(ply) or not ply:Alive() then return end

    self:SetNextPrimaryFire(CurTime() + 1)

    local tr = ply:GetEyeTrace()
    local ent = tr.Entity

    if not IsValid(ent) then return end

    ent:SetNWString("DoorMarker", "SpecialDoor")

    ply:ChatPrint("[VechnDoorBust] Установлен маркер дверей на объект: " .. ent:GetClass())
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    local ply = self.Owner
    local tr = ply:GetEyeTrace().Entity
    if IsValid(tr) then
        ply:ChatPrint("[VechnDoorBust] Класс: " .. tr:GetClass() .. " | Маркер: " .. tostring(tr:GetNWString("DoorMarker", "None")))
    else
        ply:ChatPrint("[VechnDoorBust] Смотрите на объект!")
    end
end

function SWEP:Reload()
    if SERVER then
        if not self.NextReload or CurTime() > self.NextReload then
            self.NextReload = CurTime() + 2
            net.Start("DoorBust_OpenMenu")
            net.Send(self.Owner)
        end
    end
    return false
end

if CLIENT then
    net.Receive("DoorBust_OpenMenu", function()
        local frameDoor = vgui.Create("DFrame")
        frameDoor:SetSize(220, 110)
        frameDoor:Center()
        frameDoor:SetTitle("VechnDoor Marker Menu")
        frameDoor:SetVisible(true)
        frameDoor:SetDraggable(true)
        frameDoor:ShowCloseButton(true)
        frameDoor:MakePopup()

        local button = vgui.Create("DButton", frameDoor)
        button:SetText("Save Markers")
        button:SetPos(20, 45)
        button:SetSize(180, 35)
        button.DoClick = function()
            net.Start("DoorBust_SaveMarkers")
            net.SendToServer()
            frameDoor:Close()
        end
    end)
end