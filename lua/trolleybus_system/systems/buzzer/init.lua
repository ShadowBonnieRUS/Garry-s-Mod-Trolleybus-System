-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:SetActive(active)
	self:SetNWVar("Active",active)
end

Trolleybus_System.RegisterSystem("Buzzer",SYSTEM)
SYSTEM = nil