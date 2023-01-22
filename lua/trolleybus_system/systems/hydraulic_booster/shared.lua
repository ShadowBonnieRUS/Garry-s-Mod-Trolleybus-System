-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.MaxPowerAmperage = 5.6

function SYSTEM:GetAmperage()
	return self:GetNWVar("Amperage",0)
end

function SYSTEM:GetPowerFraction()
	return math.Clamp(self:GetAmperage()/self.MaxPowerAmperage,0,1)
end