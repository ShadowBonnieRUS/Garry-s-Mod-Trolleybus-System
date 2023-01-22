-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:SetAmperage(volt)
	self:SetNWVar("Amperage",volt)
end

function SYSTEM:GetSteerBoosterPowerFraction()
	if self:GetAmperage()>0 then
		return self:GetPowerFraction()
	end
end

Trolleybus_System.RegisterSystem("HydraulicBooster",SYSTEM)
SYSTEM = nil