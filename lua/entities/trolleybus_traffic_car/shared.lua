-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "Trolleybus Traffic Car"
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = false

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"VehicleClass")
	self:NetworkVar("Int",0,"TurnSignal")
	self:NetworkVar("Float",1,"Turn")
	
	if SERVER then
		self:SetupDataTablesSV()
	end
end

function ENT:GetMoveSpeed()
	return WorldToLocal(self:GetVelocity(),angle_zero,vector_origin,self:GetAngles()).x
end

function ENT:GetVehicleData(class)
	return Trolleybus_System.TrafficVehiclesTypes[class or self:GetVehicleClass()]
end