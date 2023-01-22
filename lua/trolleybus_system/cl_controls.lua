-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.Controls = Trolleybus_System.Controls or table.Copy(Trolleybus_System.DefaultControls)

function Trolleybus_System.IsControlButtonDown(button,troll)
	if troll then
		local key = Trolleybus_System.GetHotkeyButtons(troll,button)
		return key and Trolleybus_System.IsButtonsDown(key) or false
	end
	
	local t = Trolleybus_System.Controls
	
	return t.Controls[button] and Trolleybus_System.IsButtonsDown(t.Controls[button]) or false
end

function Trolleybus_System.TrollButtonToPlayerControlKey(troll,button)
	local t = Trolleybus_System.Controls
	local class = troll:GetClass()
	
	return t.Trolleybuses[class] and t.Trolleybuses[class][button] or troll.m_ButtonsData[button].hotkey
end

function Trolleybus_System.SystemButtonToPlayerControlKey(system,button)
	local t = Trolleybus_System.Controls
	
	return t.Systems[system] and t.Systems[system][button] or Trolleybus_System.Systems[system].ButtonsHotKeys[button].hotkey
end

function Trolleybus_System.GetHotkeyButtons(troll,button)
	local dt = troll.m_ButtonsData[button]
	if !dt.hotkey then return end

	if dt.hotkey_system then
		return Trolleybus_System.SystemButtonToPlayerControlKey(dt.hotkey_system,button)
	else
		return Trolleybus_System.TrollButtonToPlayerControlKey(troll,button)
	end
end

net.Receive("Trolleybus_System_ClientControls",function(len)
	local str = file.Read("trolleybus_controls.txt")
	if str then
		table.Merge(Trolleybus_System.Controls,util.JSONToTable(str))
	end
	
	net.Start("Trolleybus_System_ClientControls")
		net.WriteTable(Trolleybus_System.Controls)
	net.SendToServer()
end)
