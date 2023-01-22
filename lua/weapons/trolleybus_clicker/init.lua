-- Copyright © Platunov I. M., 2020 All rights reserved

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Initialize()
	self:SetReverse(true)
	self.IsReverseOwner = true
end

function SWEP:Think()
	local ply = IsValid(self.Owner) and self.Owner:IsPlayer() and self.Owner

	if ply and self.IsReverseOwner and self:GetReverse() then
		local number = Trolleybus_System.GetPlayerSetting(ply,"ReverseNumber")
		
		if number!=self:GetReverseNumber() then
			self:SetReverseNumber(number)
		end
	end
	
	local hold = self:GetNameplateState() and "slam" or self.HoldTypeChange and CurTime()<self.HoldTypeChange and "pistol" or "normal"
	if hold!=self:GetHoldType() then
		self:SetHoldType(hold)
	end
end

function SWEP:PrimaryAttack()
	self.HoldTypeChange = CurTime()+0.3
end

function SWEP:SecondaryAttack()
	self:SetNameplateState(!self:GetNameplateState())
end
