-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

function SYSTEM:IsVentActive()
	return self:GetNWVar("VentActive",false)
end

function SYSTEM:GetState()
	return self:GetNWVar("State",0)
end