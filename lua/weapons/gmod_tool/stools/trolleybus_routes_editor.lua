-- Copyright © Platunov I. M., 2021 All rights reserved

if SERVER then
	AddCSLuaFile("trolleybus_system/tools/trolleybus_routes_editor/cl_init.lua")
	AddCSLuaFile("trolleybus_system/tools/trolleybus_routes_editor/shared.lua")
	include("trolleybus_system/tools/trolleybus_routes_editor/init.lua")
else
	include("trolleybus_system/tools/trolleybus_routes_editor/cl_init.lua")
end

include("trolleybus_system/tools/trolleybus_routes_editor/shared.lua")