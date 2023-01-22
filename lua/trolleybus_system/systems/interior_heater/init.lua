-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:SetVentActive(active)
	self:SetNWVar("VentActive",active)
end

function SYSTEM:SetState(state)
	self:SetNWVar("State",state)
end

Trolleybus_System.RegisterSystem("InteriorHeater",SYSTEM)
SYSTEM = nil