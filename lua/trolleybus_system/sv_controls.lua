-- Copyright © Platunov I. M., 2020 All rights reserved

util.AddNetworkString("Trolleybus_System_ClientControls")

Trolleybus_System.PlayerControls = Trolleybus_System.PlayerControls or {}

function Trolleybus_System.IsControlButtonDown(ply,button,troll)
	local t = Trolleybus_System.PlayerControls[ply]
	if !t then return false end
	
	if troll then
		local key = Trolleybus_System.GetHotkeyButtons(ply,troll,button)
		return key and Trolleybus_System.IsButtonsDown(ply,key) or false
	end
	
	return t.Controls[button] and Trolleybus_System.IsButtonsDown(ply,t.Controls[button]) or false
end

function Trolleybus_System.TrollButtonToPlayerControlKey(ply,troll,button)
	local def = troll.m_ButtonsData[button].hotkey
	
	local t = Trolleybus_System.PlayerControls[ply] and Trolleybus_System.PlayerControls[ply].Trolleybuses
	if !t then return def end
	
	local class = troll:GetClass()
	
	return t[class] and t[class][button] or def
end

function Trolleybus_System.SystemButtonToPlayerControlKey(ply,system,button)
	local def = Trolleybus_System.Systems[system].ButtonsHotKeys[button].hotkey
	local t = Trolleybus_System.PlayerControls[ply] and Trolleybus_System.PlayerControls[ply].Systems
	
	return t and t[system] and t[system][button] or def
end

function Trolleybus_System.GetHotkeyButtons(ply,troll,button)
	local dt = troll.m_ButtonsData[button]
	if !dt.hotkey then return end

	if dt.hotkey_system then
		return Trolleybus_System.SystemButtonToPlayerControlKey(ply,dt.hotkey_system,button)
	else
		return Trolleybus_System.TrollButtonToPlayerControlKey(ply,troll,button)
	end
end

net.Receive("Trolleybus_System_ClientControls",function(len,ply)
	local t = net.ReadTable()
	
	if istable(t.Controls) then
		Trolleybus_System.PlayerControls[ply] = t
	end
end)

hook.Add("PlayerInitialSpawn","Trolleybus_System_Controls",function(ply)
	net.Start("Trolleybus_System_ClientControls")
	net.Send(ply)
end)

hook.Add("PlayerDisconnected","Trolleybus_System_Controls",function(ply)
	Trolleybus_System.PlayerControls[ply] = nil
end)
