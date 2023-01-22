-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.Receivers = {}
SYSTEM.BrakeChambers = {}

function SYSTEM:GetAir(receiver)
	if self.Receivers[receiver] then
		return self:GetNWVar("Air"..receiver,self.Receivers[receiver].DefaultAir or 0)
	end
end

function SYSTEM:GetBrake(chamber)
	if self.BrakeChambers[chamber] then
		return self:GetNWVar("Brake"..chamber,0)
	end
end

function SYSTEM:GetBrakePressure(chamber)
	local data = self.BrakeChambers[chamber]

	if data then
		return self:GetBrake(chamber)/data.Size*self:GetAir(data.BrakeReceiver)
	end
end

function SYSTEM:IsMotorCompressorActive()
	return self:GetNWVar("MCActive",false)
end