-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.AutomaticFrameAdvance = false
ENT.Spawnable = false

Trolleybus_System.TrafficWheelDebug = false

function ENT:SetupDataTables()
	self:NetworkVar("Float",0,"RotationSpeed")
	self:NetworkVar("Float",1,"Rotate")
	self:NetworkVar("Bool",1,"InvertRotation")
	self:NetworkVar("String",0,"Type")
	self:NetworkVar("Entity",0,"Vehicle")
end

function ENT:GetWheelData()
	return Trolleybus_System.WheelTypes[self:GetType()] or select(2,next(Trolleybus_System.WheelTypes))
end

function ENT:GetBodyGroup(group)
	return self:GetDTInt(group)
end

function ENT:CanProperty(ply,property)
	if property=="drive" then return false end
end

hook.Add("PhysgunPickup","Trolleybus_System_PickupWheel",function(ply,ent)
	if ent:GetClass()=="trolleybus_wheel" then return false end
end)