-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.MaxCharge = 70

function SYSTEM:Initialize()
	self.Charge = self.MaxCharge
	self.CircuitUsage = true
end

function SYSTEM:SetCircuit(circuit)
	self.Circuit = circuit
end

function SYSTEM:GetCircuit()
	return self.Circuit
end

function SYSTEM:Think(dt)
	if !self.Circuit then
		self:SetNWVar("LastAmperage",0)
		self:SetNWVar("LastVoltage",self.Charge/self.MaxCharge*self.Voltage)

		return
	end

	local amp = 0

	if self.Charging then
		local charging = math.abs(self.Charging)
		self.Charge = math.min(self.MaxCharge,self.Charge+charging*dt/3600)

		amp = -charging
	end

	if self.CircuitUsage then
		self.Circuit:Update(self:IsActive() and self.Charge/self.MaxCharge*self.Voltage or 0)
	end

	local camp = self.CircuitUsage and self:IsActive() and self.Circuit:GetAmperage() or 0
	self.Charge = math.max(0,self.Charge-camp*dt/3600)
	
	amp = amp+camp

	self:SetNWVar("LastAmperage",amp)
	self:SetNWVar("LastVoltage",self.CircuitUsage and self:IsActive() and self.Circuit:GetVoltage() or self.Charge/self.MaxCharge*self.Voltage)
end

function SYSTEM:SetActive(active)
	self:SetNWVar("Active",active)
end

function SYSTEM:SetCircuitUsageDisabled(disabled)
	self.CircuitUsage = !disabled
end

function SYSTEM:SetCharging(amp)
	self.Charging = amp
	self:SetNWVar("Charging",amp and true or false)
end

function SYSTEM:GetCharging()
	return self.Charging
end

function SYSTEM:GetChargePercent()
	return self.Charge/self.MaxCharge
end

Trolleybus_System.RegisterSystem("AccumulatorBattery",SYSTEM)
SYSTEM = nil