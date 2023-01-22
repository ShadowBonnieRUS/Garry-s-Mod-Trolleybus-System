-- Copyright © Platunov I. M., 2020 All rights reserved

util.AddNetworkString("Trolleybus_System.DeviceInputData")

function Trolleybus_System.IsExternalButtonDown(ply,button)
	local buttons = ply.TrolleybusDeviceInputData_buttons
	if !buttons then return false end

	local value = Trolleybus_System.ExternalButtons[button]
	if !value then return false end

	return bit.band(buttons,value)==value
end

hook.Add("PlayerPostThink","Trolleybus_System_DeviceInputModule",function(ply)
	local drive
	
	if ply.TrolleybusDeviceInputData_steer then
		local usesteer = Trolleybus_System.GetPlayerSetting(ply,"UseExternalSteer")
		
		if usesteer then
			drive = Trolleybus_System.PlayerInDriverPlace(nil,ply)
			
			if !drive then
				ply.TrolleybusDeviceInputData_steer = nil
			end
		else
			ply.TrolleybusDeviceInputData_steer = nil
		end
	end
	
	if ply.TrolleybusDeviceInputData_startpedal or ply.TrolleybusDeviceInputData_brakepedal then
		local usesteer = Trolleybus_System.GetPlayerSetting(ply,"UseExternalPedals")
		
		if usesteer then
			if drive==nil then
				drive = Trolleybus_System.PlayerInDriverPlace(nil,ply)
			end
			
			if !drive then
				ply.TrolleybusDeviceInputData_startpedal = nil
				ply.TrolleybusDeviceInputData_brakepedal = nil
			end
		else
			ply.TrolleybusDeviceInputData_startpedal = nil
			ply.TrolleybusDeviceInputData_brakepedal = nil
		end
	end
	
	if ply.TrolleybusDeviceInputData_buttons then
		local usebuttons = Trolleybus_System.GetPlayerSetting(ply,"UseExternalButtons")
		
		if usebuttons then
			if drive==nil then
				drive = Trolleybus_System.PlayerInDriverPlace(nil,ply)
			end
			
			if !drive then
				ply.TrolleybusDeviceInputData_buttons = nil
			end
		else
			ply.TrolleybusDeviceInputData_buttons = nil
		end
	end
end)

local function ButtonStateChanged(ply,bus,button,state)
	if state then
		for k,v in pairs(bus.Buttons) do
			if v.Cfg.externalhotkey==button then
				bus:TryPressButtonBy(ply,k,8)
			end
		end
	end
end

net.Receive("Trolleybus_System.DeviceInputData",function(len,ply)
	local usesteer = Trolleybus_System.GetPlayerSetting(ply,"UseExternalSteer")
	local usepedals = Trolleybus_System.GetPlayerSetting(ply,"UseExternalPedals")
	local usebuttons = Trolleybus_System.GetPlayerSetting(ply,"UseExternalButtons")

	if !usesteer and !usepedals and !usebuttons then return end
	if !Trolleybus_System.PlayerInDriverPlace(nil,ply) then return end
	
	local steer = net.ReadBool() and net.ReadFloat()
	local startpedal = net.ReadBool() and net.ReadFloat()
	local brakepedal = net.ReadBool() and net.ReadFloat()
	local buttons = net.ReadBool() and net.ReadUInt(8)
	
	if usesteer then
		if steer then
			ply.TrolleybusDeviceInputData_steer = steer
		end
	else
		ply.TrolleybusDeviceInputData_steer = nil
	end
	
	if usepedals then
		if startpedal then
			ply.TrolleybusDeviceInputData_startpedal = startpedal
		end
	else
		ply.TrolleybusDeviceInputData_startpedal = nil
	end
	
	if usepedals then
		if brakepedal then
			ply.TrolleybusDeviceInputData_brakepedal = brakepedal
		end
	else
		ply.TrolleybusDeviceInputData_brakepedal = nil
	end
	
	if usebuttons then
		if buttons then
			local prev = ply.TrolleybusDeviceInputData_buttons or 0
			ply.TrolleybusDeviceInputData_buttons = buttons
			
			if prev!=buttons then
				local bus = Trolleybus_System.GetSeatTrolleybus(ply:GetVehicle())
				
				for k,v in pairs(Trolleybus_System.ExternalButtons) do
					local pressed = Trolleybus_System.IsExternalButtonDown(ply,k)
					if pressed==(bit.band(prev,v)==v) then continue end
				
					ButtonStateChanged(ply,bus,k,pressed)
				end
			end
		end
	else
		ply.TrolleybusDeviceInputData_buttons = nil
	end
end)