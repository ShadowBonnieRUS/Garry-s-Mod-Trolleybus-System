-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:SetActive(active)
	self:SetNWVar("Active",active)
end

function SYSTEM:Think(dt)
	if self.Circuit and self:IsActive() then
		self.Circuit:Update(self:GetVoltage())
	end
end

function SYSTEM:SetCircuit(circuit)
	self.Circuit = circuit
end

Trolleybus_System.RegisterSystem("StaticVoltageConverter",SYSTEM)
SYSTEM = nil