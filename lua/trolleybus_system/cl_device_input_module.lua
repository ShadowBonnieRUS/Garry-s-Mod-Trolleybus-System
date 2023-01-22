-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.DeviceInputData = Trolleybus_System.DeviceInputData or {}
Trolleybus_System.DeviceInputModule = Trolleybus_System.DeviceInputModule or {}

local Settings = util.JSONToTable(file.Read("trolleybussystem_deviceinput.txt","DATA") or "[]") or {}

local function PushSettingsButtons()
	if Settings.Buttons then
		local device = Trolleybus_System._DeviceInputModule.GetDeviceByGUID(Settings.Buttons)
		Trolleybus_System.DeviceInputData.ButtonsDevice = device
		
		local objects = device and device:GetButtons()
		
		for k,v in pairs(Trolleybus_System.ExternalButtons) do
			Trolleybus_System.DeviceInputData["ButtonsObject_"..k] = objects and Settings["Buttons_"..k] and objects[Settings["Buttons_"..k]] or nil
		end
	end
end

function Trolleybus_System.DeviceInputModule.PushSettingsData()
	table.Empty(Trolleybus_System.DeviceInputData)
	
	if Settings.Steer then
		local device = Trolleybus_System._DeviceInputModule.GetDeviceByGUID(Settings.Steer)
		Trolleybus_System.DeviceInputData.SteerDevice = device
		
		if device and Settings.SteerObject then
			Trolleybus_System.DeviceInputData.SteerObject = device:GetAxles()[Settings.SteerObject]
		end
	end
	
	if Settings.StartPedal then
		local device = Trolleybus_System._DeviceInputModule.GetDeviceByGUID(Settings.StartPedal)
		Trolleybus_System.DeviceInputData.StartPedalDevice = device
		
		if device and Settings.StartPedalObject then
			Trolleybus_System.DeviceInputData.StartPedalObject = device:GetAxles()[Settings.StartPedalObject]
		end
	end
	
	if Settings.BrakePedal then
		local device = Trolleybus_System._DeviceInputModule.GetDeviceByGUID(Settings.BrakePedal)
		Trolleybus_System.DeviceInputData.BrakePedalDevice = device
		
		if device and Settings.BrakePedalObject then
			Trolleybus_System.DeviceInputData.BrakePedalObject = device:GetAxles()[Settings.BrakePedalObject]
		end
	end
	
	PushSettingsButtons()
end

function Trolleybus_System.DeviceInputModule.GetDevices()
	return Trolleybus_System._DeviceInputModule.GetDevices()
end

function Trolleybus_System.DeviceInputModule.LoadModule()
	if Trolleybus_System._DeviceInputModule then return true end
	if !Trolleybus_System.DeviceInputModule.HasModule() then return false,"Module not found!" end
	
	local s,e = pcall(require,"trolleybus_input_device")
	if s then return true end
	
	return false,e
end

function Trolleybus_System.DeviceInputModule.HasModule()
	local prefixos = jit.os=="Windows" and "win" or jit.os=="Linux" and "linux" or jit.os=="OSX" and "osx"
	if !prefixos then return false end
	
	local prefixarch = prefixos=="osx" and "" or jit.arch=="x86" and (prefixos=="win" and "32" or "") or jit.arch=="x64" and "64"
	if !prefixarch then return false end
	
	local filename = "gmcl_trolleybus_input_device_"..prefixos..prefixarch
	
	return file.Exists("lua/bin/"..filename..".dll","GAME")
end

function Trolleybus_System.DeviceInputModule.ModuleLoaded()
	return tobool(Trolleybus_System._DeviceInputModule)
end

function Trolleybus_System.DeviceInputModule.UpdateDevices()
	Trolleybus_System._DeviceInputModule.LoadDevices()
	Trolleybus_System.DeviceInputModule.PushSettingsData()
end

function Trolleybus_System.DeviceInputModule.GetDeviceByGUID(guid)
	return Trolleybus_System._DeviceInputModule.GetDeviceByGUID(guid)
end

function Trolleybus_System.DeviceInputModule.GetSettings()
	return Settings
end

function Trolleybus_System.DeviceInputModule.SaveSettings()
	file.Write("trolleybussystem_deviceinput.txt",util.TableToJSON(Settings))
end

Trolleybus_System.DeviceInputModule.LoadModule()

if Trolleybus_System.DeviceInputModule.ModuleLoaded() then
	Trolleybus_System.DeviceInputModule.UpdateDevices()
end

local time = CurTime()
hook.Add("Think","Trolleybus_System_DeviceInputModule",function()
	local usesteer = Trolleybus_System.GetPlayerSetting("UseExternalSteer")
	local usepedals = Trolleybus_System.GetPlayerSetting("UseExternalPedals")
	local usebuttons = Trolleybus_System.GetPlayerSetting("UseExternalButtons")

	if !usesteer and !usepedals and !usebuttons then return end

	if CurTime()-time<0.05 then return end
	time = CurTime()
	
	local ply = LocalPlayer()
	
	if Trolleybus_System.PlayerInDriverPlace(nil,ply) then
		local steer = Trolleybus_System.DeviceInputData.SteerObject
		local startpedal = Trolleybus_System.DeviceInputData.StartPedalObject
		local brakepedal = Trolleybus_System.DeviceInputData.BrakePedalObject
		
		net.Start("Trolleybus_System.DeviceInputData",true)
			if usesteer and steer and steer:IsValid() and Settings.SteerMin and Settings.SteerMax then				
				net.WriteBool(true)
				net.WriteFloat(-math.Clamp(math.Remap(steer:GetState(),Settings.SteerMin,Settings.SteerMax,-1,1),-1,1))
			else
				net.WriteBool(false)
			end
			
			if usepedals and startpedal and startpedal:IsValid() and Settings.StartPedalMin and Settings.StartPedalMax then
				net.WriteBool(true)
				net.WriteFloat(math.Clamp(math.Remap(startpedal:GetState(),Settings.StartPedalMin,Settings.StartPedalMax,0,1),0,1))
			else
				net.WriteBool(false)
			end
			
			if usepedals and brakepedal and brakepedal:IsValid() and Settings.BrakePedalMin and Settings.BrakePedalMax then
				net.WriteBool(true)
				net.WriteFloat(math.Clamp(math.Remap(brakepedal:GetState(),Settings.BrakePedalMin,Settings.BrakePedalMax,0,1),0,1))
			else
				net.WriteBool(false)
			end
			
			if usebuttons then
				local btns = 0
				
				for k,v in pairs(Trolleybus_System.ExternalButtons) do
					local obj = Trolleybus_System.DeviceInputData["ButtonsObject_"..k]
					
					if obj and obj:IsValid() and obj:GetButtonState() then
						btns = bit.bor(btns,v)
					end
				end
			
				net.WriteBool(true)
				net.WriteUInt(btns,8)
			else
				net.WriteBool(false)
			end
			
		net.SendToServer()
	end
end)