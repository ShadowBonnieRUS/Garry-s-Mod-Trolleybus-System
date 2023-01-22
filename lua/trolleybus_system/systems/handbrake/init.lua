-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.MaxDeceleration = 3000
SYSTEM.MinDeceleration = 1000
SYSTEM.MinDecelerationRotation = 370
SYSTEM.PneumaticAirBrake = nil

function SYSTEM:SetActive(active)
	local activ = self.Active
	self.Active = active

	if active and !activ then
		self:UpdatePneumaticAir()
	end
end

function SYSTEM:UpdatePneumaticAir()
	if self.PneumaticAirBrake then
		self.PneumaticBrakeFraction = self:GetAirFromSystem(self.PneumaticAirBrake)/self.PneumaticAirBrake
	end
end

function SYSTEM:GetAirFromSystem(air)
	return air
end

function SYSTEM:GetWheelsBrake(speed,isdrive)
	if !self.Active then return speed end
	
	local dec = math.Remap(math.Clamp(math.abs(speed),0,self.MinDecelerationRotation),0,self.MinDecelerationRotation,self.MaxDeceleration,self.MinDeceleration)

	if self.PneumaticAirBrake and self.PneumaticBrakeFraction then
		dec = dec*self.PneumaticBrakeFraction
	end
	
	return speed>0 and math.max(0,speed-dec*self.Trolleybus.DeltaTime) or math.min(0,speed+dec*self.Trolleybus.DeltaTime)
end

Trolleybus_System.RegisterSystem("Handbrake",SYSTEM)
SYSTEM = nil