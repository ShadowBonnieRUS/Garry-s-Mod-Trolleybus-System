-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

function SYSTEM:GetLastDifference()
	return self:GetNWVar("Diff",0)
end

function SYSTEM:GetRotation()
	return self:GetNWVar("Rotation",0)
end