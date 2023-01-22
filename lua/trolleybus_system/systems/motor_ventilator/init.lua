-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:Think(dt)
	if !self.Circuit then return end

	if self:IsActive() then
		self.Circuit:Update(self.Voltage)
	end
end

function SYSTEM:SetCircuit(circuit)
	self.Circuit = circuit
end

function SYSTEM:SetActive(active)
	self:SetNWVar("Active",active)
end

function SYSTEM:GetVoltage()
	return self:IsActive() and self.Voltage or 0
end

Trolleybus_System.RegisterSystem("MotorVentilator",SYSTEM)
SYSTEM = nil