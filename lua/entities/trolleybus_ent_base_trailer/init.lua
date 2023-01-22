-- Copyright © Platunov I. M., 2022 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:IsWheelsFullStop()
	return self:GetTrolleybus():GetHandbrakeActive()
end

function ENT:SetupControls()
    self:SetRearLights(self:GetTrolleybus():GetRearLights())
end