-- Copyright © Platunov I. M., 2020 All rights reserved

SWEP.PrintName = "Trolleybus buttons manipulator"
SWEP.Author = "Shadow Bonnie (RUS)"

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.ViewModel = "models/trolleybus/reverse/reverse_vm.mdl"
SWEP.WorldModel = "models/trolleybus/reverse/reverse_wm.mdl"
SWEP.ViewModelNameplate = "models/trolleybus/routeplate_short_vm.mdl"
SWEP.WorldModelNameplate = "models/trolleybus/routeplate_short_wm.mdl"

SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Reverse")
	self:NetworkVar("Bool",1,"NameplateState")
	self:NetworkVar("Int",0,"ReverseNumber")
	self:NetworkVar("Int",1,"ReverseType")
	
	if SERVER then
		self:NetworkVarNotify("NameplateState",function(ent,name,old,new)
			self:SetupWeaponModels(new)
		end)
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:Deploy()
	self:SetupWeaponModels()
	
	return true
end

function SWEP:SetupWeaponModels(nameplate)
	if nameplate==nil then nameplate = self:GetNameplateState() end
	
	local vm = self:GetOwner():GetViewModel(0)
	if IsValid(vm) then
		vm:SetWeaponModel(nameplate and self.ViewModelNameplate or self.ViewModel,self)
	end
	
	self:SetModel(nameplate and self.WorldModelNameplate or self.WorldModel)
end

function SWEP:GetTrolleybus()
	local ply = self:GetOwner()
	local tr = ply:GetEyeTrace()
	
	if tr.Hit and tr.Entity.IsTrolleybus then
		local d = tr.Entity:WorldSpaceCenter():Distance(Trolleybus_System.EyePos(ply))
		
		if d<tr.Entity:BoundingRadius()+128 then
			return tr.Entity,d
		end
	end
	
	local bus,dist

	for k,v in pairs(ents.FindByClass("trolleybus_ent_*")) do
		local d = v:WorldSpaceCenter():Distance(Trolleybus_System.EyePos(self:GetOwner()))
		
		if d<v:BoundingRadius()+128 then
			if !dist or d<dist then
				bus,dist = v,d
			end
		end
	end
	
	return bus,dist
end