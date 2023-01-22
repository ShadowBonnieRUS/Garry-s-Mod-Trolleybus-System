-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:Initialize()
	self.Diff = 0
end

function SYSTEM:Think(dt)
	self:SetNWVar("Diff",self.Diff/dt)
	self.Diff = 0
end

function SYSTEM:SetRotation(rotation)
	self.Diff = self.Diff+math.abs(rotation-self:GetRotation())
	self:SetNWVar("Rotation",rotation)
end

function SYSTEM:GetWheelsControl(speed,isdrive)
	if !isdrive then return speed end
	
	return self:GetRotation()
end

function SYSTEM:PostDriveWheelsRotationUpdate(group,data,rotdata)
	self:SetRotation(rotdata.Rotation)
end

Trolleybus_System.RegisterSystem("Reductor",SYSTEM)
SYSTEM = nil