-- Copyright © Platunov I. M., 2020 All rights reserved

util.AddNetworkString("Trolleybus_System.PlayerSettings")
util.AddNetworkString("Trolleybus_System.AdminSettings")

Trolleybus_System.PlayerSettings = Trolleybus_System.PlayerSettings or {}

function Trolleybus_System.GetPlayerSetting(ply,name)
	local setting = Trolleybus_System.Settings[name] 
	if !setting or setting.Type=="ConCommand" then return end
	
	local data = Trolleybus_System.PlayerSettings[ply]
	local value = data and data[name]
	
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

function Trolleybus_System.GetAdminSetting(name)
	local setting = Trolleybus_System.AdminSettings[name]
	if !setting or setting.Type=="ConCommand" then return end

	local var = GetConVar(name)
	
	if var then
		return var[setting.Getter](var)
	end
end

function Trolleybus_System:TrolleybusSystem_HasAccessToAdminSettings(ply)
	return ply:IsSuperAdmin()
end

hook.Add("PlayerInitialSpawn","Trolleybus_System.PlayerSettings",function(ply)
	net.Start("Trolleybus_System.PlayerSettings")
	net.Send(ply)
	
	Trolleybus_System.PlayerSettings[ply] = {}
end)

hook.Add("PlayerDisconnected","Trolleybus_System.PlayerSettings",function(ply)
	Trolleybus_System.PlayerSettings[ply] = nil
end)

hook.Add("Initialize","Trolleybus_System.AdminSettings",function(ply)
	for k,v in pairs(Trolleybus_System.AdminSettings) do
		if v.Type=="ConCommand" then continue end
		
		CreateConVar(k,v.DefaultValue,FCVAR_ARCHIVE,"See: Spawn Menu -> Utility -> Trolleybus System -> Settings (Admin)",v.Min,v.Max)
	end
end)

net.Receive("Trolleybus_System.PlayerSettings",function(len,ply)
	local name = net.ReadString()
	local value = net.ReadType()
	
	if !Trolleybus_System.Settings[name] or !Trolleybus_System.Settings[name].Network then return end

	Trolleybus_System.PlayerSettings[ply][name] = value
end)

net.Receive("Trolleybus_System.AdminSettings",function(len,ply)
	if Trolleybus_System.RunEvent("HasAccessToAdminSettings",ply) then
		if net.ReadBool() then
			local values = net.ReadTable()
			
			for k,v in pairs(values) do
				local setting = Trolleybus_System.AdminSettings[k]
				if !setting or setting.Type=="ConCommand" then continue end
			
				local var = GetConVar(k)
				
				if var and var[setting.Getter](var)!=v then
					var[setting.Setter](var,v)
					
					print("Trolleybus_System ("..os.date("%d/%m/%Y %H:%M:%S").."): Admin Setting changed: '"..k.."', to value '"..tostring(v).."', by '"..ply:Nick().." ("..ply:SteamID()..")'.")

					Trolleybus_System.RunEvent("OnAdminSettingChange",k,ply,v)
				end
			end
		end
		
		local values = {}
		for k,v in pairs(Trolleybus_System.AdminSettings) do
			if v.Type=="ConCommand" then continue end
		
			local var = GetConVar(k)
			
			if var then
				values[k] = var[v.Getter](var)
			end
		end
		
		net.Start("Trolleybus_System.AdminSettings")
			net.WriteBool(true)
			net.WriteTable(values)
		net.Send(ply)
	else
		net.Start("Trolleybus_System.AdminSettings")
			net.WriteBool(false)
		net.Send(ply)
	end
end)
