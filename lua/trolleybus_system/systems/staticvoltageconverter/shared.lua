-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.Voltage = 27.5

function SYSTEM:GetVoltage()
	return self:IsActive() and self.Voltage or 0
end

function SYSTEM:IsActive()
	return self:GetNWVar("Active",false)
end

function SYSTEM:GetLowVoltage()
	if self:IsActive() then
		return self:GetVoltage()
	end
end