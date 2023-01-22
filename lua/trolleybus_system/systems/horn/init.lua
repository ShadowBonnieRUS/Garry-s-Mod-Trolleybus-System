-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:Think(dt)
	local ply = self.Trolleybus:GetDriver()
	
	self:SetNWVar("Active",self:ShouldActive())
end

function SYSTEM:ShouldActive()
	local ply = self.Trolleybus:GetDriver()

	return IsValid(ply) and (Trolleybus_System.IsControlButtonDown(ply,"horn") or Trolleybus_System.GetPlayerSetting(ply,"UseExternalButtons") and Trolleybus_System.IsExternalButtonDown(ply,"Horn"))
end

Trolleybus_System.RegisterSystem("Horn",SYSTEM)
SYSTEM = nil