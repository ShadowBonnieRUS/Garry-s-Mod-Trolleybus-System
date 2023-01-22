-- Copyright © Platunov I. M., 2020 All rights reserved

if SERVER then
	AddCSLuaFile("trolleybus_system/tools/trolleyinformatoreditor/cl_init.lua")
	AddCSLuaFile("trolleybus_system/tools/trolleyinformatoreditor/shared.lua")
	include("trolleybus_system/tools/trolleyinformatoreditor/init.lua")
else
	include("trolleybus_system/tools/trolleyinformatoreditor/cl_init.lua")
end

include("trolleybus_system/tools/trolleyinformatoreditor/shared.lua")