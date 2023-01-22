-- Copyright © Platunov I. M., 2020 All rights reserved

AddCSLuaFile("traffic_vehicles.lua")
AddCSLuaFile("trafficlight_types.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_util.lua")
AddCSLuaFile("util.lua")
AddCSLuaFile("creationtab.lua")
AddCSLuaFile("spawnsettings.lua")
AddCSLuaFile("cl_bass_sounds.lua")
AddCSLuaFile("commands.lua")
AddCSLuaFile("language.lua")
AddCSLuaFile("cl_controls.lua")
AddCSLuaFile("cl_settings.lua")
AddCSLuaFile("systems.lua")
AddCSLuaFile("cl_network_vars.lua")
AddCSLuaFile("network_vars.lua")
AddCSLuaFile("skins.lua")
AddCSLuaFile("mirrors.lua")
AddCSLuaFile("cl_device_input_module.lua")
AddCSLuaFile("gui.lua")
AddCSLuaFile("cl_settings_gui.lua")
AddCSLuaFile("contactnetwork.lua")
AddCSLuaFile("cl_contactnetwork.lua")
AddCSLuaFile("routes.lua")
AddCSLuaFile("cl_routes.lua")

if CLIENT then
	include("language.lua")
end

include("traffic_vehicles.lua")
include("trafficlight_types.lua")
include("shared.lua")
include("util.lua")
include("systems.lua")
include("network_vars.lua")
include("skins.lua")
include("contactnetwork.lua")
include("routes.lua")

if SERVER then
	include("sv_util.lua")
	include("init.lua")
	include("traffic_spawn.lua")
	include("sv_bass_sounds.lua")
	include("sv_network_vars.lua")
	include("sv_controls.lua")
	include("sv_device_input_module.lua")
	include("sv_settings.lua")
	include("sv_contactnetwork.lua")
	include("sv_routes.lua")
else
	include("cl_util.lua")
	include("cl_init.lua")
	include("cl_controls.lua")
	include("cl_bass_sounds.lua")
	include("cl_network_vars.lua")
	include("creationtab.lua")
	include("spawnsettings.lua")
	include("mirrors.lua")
	include("cl_device_input_module.lua")
	include("cl_settings.lua")
	include("gui.lua")
	include("cl_settings_gui.lua")
	include("cl_contactnetwork.lua")
	include("cl_routes.lua")
end

if ulx and ulx.command then
	include("commands.lua")
else
	timer.Simple(0,function()
		if !ulx then return end
		
		include("trolleybus_system/commands.lua")
	end)
end