-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.Sound = nil
SYSTEM.WheelRadius = 27

function SYSTEM:GetAmperage()
	return self:GetNWVar("Amperage",0)
end

function SYSTEM:GetRotation()
	return self:GetNWVar("Rotation",0)
end

function SYSTEM:GetMoveSpeed()
	return self.Trolleybus:UPSToKPH(self:GetRotation()/360*(2*math.pi*self.WheelRadius))
end