-- Copyright © Platunov I. M., 2020 All rights reserved

if SERVER then
	AddCSLuaFile("trolleybus_system/tools/trolleytrafficeditor/cl_init.lua")
	AddCSLuaFile("trolleybus_system/tools/trolleytrafficeditor/shared.lua")
	include("trolleybus_system/tools/trolleytrafficeditor/init.lua")
else
	include("trolleybus_system/tools/trolleytrafficeditor/cl_init.lua")
end

include("trolleybus_system/tools/trolleytrafficeditor/shared.lua")