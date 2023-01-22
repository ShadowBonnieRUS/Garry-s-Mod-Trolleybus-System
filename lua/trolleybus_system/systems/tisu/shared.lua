-- Copyright © Platunov I. M., 2021 All rights reserved

if !SYSTEM then return end

function SYSTEM:IsEngineAsGenerator()
	return self:GetNWVar("EngineAsGenerator",false)
end

function SYSTEM:GetEngineAmperage()
	return self:GetNWVar("EngineAmperage",0)
end

function SYSTEM:GetEngineRotation()
	return self:GetNWVar("EngineRotation",0)
end