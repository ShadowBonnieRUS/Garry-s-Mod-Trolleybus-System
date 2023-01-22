-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.Voltage = 24

function SYSTEM:GetLastAmperage()
	return self:GetNWVar("LastAmperage",0)
end

function SYSTEM:GetLastVoltage()
	return self:GetNWVar("LastVoltage",0)
end

function SYSTEM:IsActive()
	return self:GetNWVar("Active",false)
end

function SYSTEM:GetLowVoltage()
	if !self:GetNWVar("Charging") and self:GetLastVoltage()>0 then
		return self:GetLastVoltage()
	end
end