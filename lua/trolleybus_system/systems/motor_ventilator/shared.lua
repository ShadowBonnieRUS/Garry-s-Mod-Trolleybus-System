-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.Voltage = 28

function SYSTEM:IsActive()
	return self:GetNWVar("Active",false)
end

function SYSTEM:GetLowVoltage()
	if self:IsActive() then
		return self.Voltage
	end
end