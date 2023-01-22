-- Copyright © Platunov I. M., 2021 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:SetRoute(nameplate,route)
	self:SetNWVar("Routes."..nameplate,route)
end

Trolleybus_System.RegisterSystem("Nameplates",SYSTEM)
SYSTEM = nil