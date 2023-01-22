-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.SettingsData = Trolleybus_System.SettingsData or {}

local Settings = Trolleybus_System.SettingsData

function Trolleybus_System.GetPlayerSetting(name)
	local setting = Trolleybus_System.Settings[name]
	if !setting or setting.Type=="ConCommand" then return end
	
	local value = Settings[name]
	if value==nil then
		return setting.DefaultValue
	end

	if setting.Type=="Slider" then
		return math.Clamp(math.Round(tonumber(value) or setting.DefaultValue,setting.Decimals),setting.Min,setting.Max)
	elseif setting.Type=="CheckBox" then
		return value and true or false
	elseif setting.Type=="ComboBox" then
		return math.Clamp(math.Round(tonumber(value) or setting.DefaultValue),1,#setting.Options)
	end
end

net.Receive("Trolleybus_System.PlayerSettings",function(len)
	local str = file.Read("trolleybus_settings.txt")
	if str then
		table.Merge(Settings,util.JSONToTable(str))
	end
	
	for k,v in pairs(Settings) do
		if !Trolleybus_System.Settings[k] or !Trolleybus_System.Settings[k].Network then continue end
	
		net.Start("Trolleybus_System.PlayerSettings")
			net.WriteString(k)
			net.WriteType(v)
		net.SendToServer()
	end
end)
