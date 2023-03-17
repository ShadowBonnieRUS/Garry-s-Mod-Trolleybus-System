-- Copyright © Platunov I. M., 2020 All rights reserved

local L = SERVER and function() end or Trolleybus_System.GetLanguagePhrase

Trolleybus_System.TrafficTracks = Trolleybus_System.TrafficTracks or {}
Trolleybus_System.Informators = Trolleybus_System.Informators or {}
Trolleybus_System.TrafficVehiclesTypes = Trolleybus_System.TrafficVehiclesTypes or {}
Trolleybus_System.WheelTypes = Trolleybus_System.WheelTypes or {}
Trolleybus_System.TrafficLightLenses = Trolleybus_System.TrafficLightLenses or {}
Trolleybus_System.TrafficLightLenseIDs = Trolleybus_System.TrafficLightLenseIDs or {}
Trolleybus_System.TrafficLightTypes = Trolleybus_System.TrafficLightTypes or {}
Trolleybus_System.TracksPowerDisabled = Trolleybus_System.TracksPowerDisabled or {}

Trolleybus_System.MaxTrolleybusPolesUpAng = -50
Trolleybus_System.UnitsPerMeter = 37.777

Trolleybus_System.VERSION = "Beta 1.1"

Trolleybus_System.DefaultMaps = {
	gm_sumy_reborn = true,
}

Trolleybus_System.DefaultControls = {
	Controls = {
		acceleration = KEY_W,
		deceleration = KEY_S,
		steerleft = KEY_A,
		steerright = KEY_D,
		steerreturn = KEY_SPACE,
		faststeer = KEY_LSHIFT,
		drop = KEY_LALT,
		horn = KEY_T,
		mousesteer = MOUSE_RIGHT,
		viewmove = KEY_RSHIFT,
		viewmovereset = KEY_RCONTROL,
		handbrake = KEY_V,
		reverseforward = KEY_0,
		reversebackward = KEY_9,
		fullbrake = KEY_BACKSPACE,
	},
	Trolleybuses = {},
	Systems = {},
}

Trolleybus_System.ExternalButtons = {
	LeftTurnSignal	= 0x00001,
	RightTurnSignal	= 0x00002,
	Emergency		= 0x00004,
	Handbrake		= 0x00008,
	Horn			= 0x00010,
}

Trolleybus_System.Settings = {
	TrolleybusDrawDistance = {
		Order = 1,
		Network = true,
		DefaultValue = 5000,
		Type = "Slider",
		Min = 1000,
		Max = 32000,
		Decimals = 0,
	},
	TrolleybusStopDrawDistance = {
		Order = 2,
		Network = true,
		DefaultValue = 5000,
		Type = "Slider",
		Min = 1000,
		Max = 32000,
		Decimals = 0,
	},
	TrafficDrawDistance = {
		Order = 3,
		Network = true,
		DefaultValue = 5000,
		Type = "Slider",
		Min = 1000,
		Max = 32000,
		Decimals = 0,
	},
	TrafficLightDrawDistance = {
		Order = 4,
		Network = true,
		DefaultValue = 5000,
		Type = "Slider",
		Min = 1000,
		Max = 32000,
		Decimals = 0,
	},
	TrolleybusDetailsDrawDistance = {
		Order = 5,
		Network = false,
		DefaultValue = 3000,
		Type = "Slider",
		Min = 500,
		Max = 16000,
		Decimals = 0,
	},
	TrafficDetailsDrawDistance = {
		Order = 6,
		Network = false,
		DefaultValue = 2000,
		Type = "Slider",
		Min = 500,
		Max = 16000,
		Decimals = 0,
	},
	PassengersDrawDistance = {
		Order = 7,
		Network = false,
		DefaultValue = 2000,
		Type = "Slider",
		Min = 500,
		Max = 16000,
		Decimals = 0,
	},
	CNObjectsDrawDistance = {
		Order = 8,
		Network = false,
		DefaultValue = 3000,
		Type = "Slider",
		Min = 500,
		Max = 16000,
		Decimals = 0,
	},
	TrolleybusMaxPassengers = {
		Order = 9,
		Network = false,
		DefaultValue = 500,
		Type = "Slider",
		Min = 0,
		Max = 200,
		Decimals = 0,
	},
	SteerMouseSensitivityMult = {
		Order = 10,
		Network = false,
		DefaultValue = 25,
		Type = "Slider",
		Min = 0,
		Max = 100,
		Decimals = 0,
	},
	SteerTransparent = {
		Order = 11,
		Network = false,
		DefaultValue = false,
		Type = "CheckBox",
	},
	ViewMoveSpeed = {
		Order = 12,
		Network = false,
		DefaultValue = 15,
		Type = "Slider",
		Min = 5,
		Max = 100,
		Decimals = 0,
	},
	DebugMode = {
		Order = 13,
		Network = false,
		DefaultValue = false,
		Type = "CheckBox",
	},
	MirrorView = {
		Order = 14,
		Network = false,
		DefaultValue = false,
		Type = "CheckBox",
	},
	RenderMirrors = {
		Order = 15,
		Network = false,
		DefaultValue = 1,
		Options = {
			L"settings.system.user.client.rendermirrors.disabled",
			L"settings.system.user.client.rendermirrors.enabledself",
			L"settings.system.user.client.rendermirrors.enabled",nil
		},
		Type = "ComboBox",
	},
	MirrorsUpdateTime = {
		Order = 16,
		Network = false,
		DefaultValue = 250,
		Type = "Slider",
		Min = 0,
		Max = 1000,
		Decimals = 0,
	},
	RouteDisplayEnabled = {
		Order = 17,
		Network = false,
		DefaultValue = true,
		Type = "CheckBox",
	},
	DrawHUDInfo = {
		Order = 18,
		Network = false,
		DefaultValue = true,
		Type = "CheckBox",
	},
	DisableHeadlights = {
		Order = 19,
		Network = false,
		DefaultValue = false,
		Type = "CheckBox",
	},
	OptimizedCabineLight = {
		Order = 20,
		Network = false,
		DefaultValue = false,
		Type = "CheckBox",
	},
	HeadMovingFromAcceleration = {
		Order = 21,
		Network = false,
		DefaultValue = true,
		Type = "CheckBox",
	},
	ExpelPassengers = {
		Order = 22,
		Network = false,
		DefaultValue = nil,
		Command = "trolleybus_expel_passengers",
		Type = "ConCommand",
	},
	FlushBortSkins = {
		Order = 23,
		Network = false,
		DefaultValue = nil,
		Command = "trolleybus_flushbortskins",
		Type = "ConCommand",
	},
	ReverseNumber = {
		Order = 24,
		Network = true,
		DefaultValue = 0,
		Type = "Slider",
		Min = 0,
		Max = 999,
		Decimals = 0,
	},
	EnableBortNumbers = {
		Order = 25,
		Network = false,
		DefaultValue = false,
		Type = "CheckBox",
	},
	BortNumber = {
		Order = 26,
		Network = true,
		DefaultValue = 1000,
		Type = "Slider",
		Min = 1,
		Max = 9999,
		Decimals = 0,
	},
	UseExternalSteer = {
		Order = 27,
		Network = true,
		DefaultValue = false,
		Type = "CheckBox",
	},
	UseExternalPedals = {
		Order = 28,
		Network = true,
		DefaultValue = false,
		Type = "CheckBox",
	},
	UseExternalButtons = {
		Order = 29,
		Network = true,
		DefaultValue = false,
		Type = "CheckBox",
	},
}

Trolleybus_System.AdminSettings = {
	trolleybus_control_without_wires = {
		Order = 1,
		DefaultValue = 0,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_poles_cross_check = {
		Order = 2,
		DefaultValue = 1,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_poles_speed_check = {
		Order = 3,
		DefaultValue = 1,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_poles_electric_arc_check = {
		Order = 4,
		DefaultValue = 1,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_max_trolleybuses = {
		Order = 5,
		DefaultValue = 15,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 100,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_stop_route_check = {
		Order = 6,
		DefaultValue = 1,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_spawn_notify = {
		Order = 7,
		DefaultValue = 1,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_traffic_enable = {
		Order = 8,
		DefaultValue = 0,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_traffic_updaterate = {
		Order = 9,
		DefaultValue = 60,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 300,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_traffic_distancemax = {
		Order = 10,
		DefaultValue = 5000,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 32000,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_traffic_distancemin = {
		Order = 11,
		DefaultValue = 2000,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 32000,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_traffic_limit = {
		Order = 12,
		DefaultValue = 100,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 1000,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_traffic_player_limit = {
		Order = 13,
		DefaultValue = 10,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 100,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_traffic_spawns_per_second = {
		Order = 14,
		DefaultValue = 2,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 10,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_contact_network_voltage = {
		Order = 15,
		DefaultValue = 550,
		Type = "Slider",
		Decimals = 0,
		Min = 0,
		Max = 1000,
		Setter = "SetInt",
		Getter = "GetInt",
	},
	trolleybus_remove_reverse = {
		Order = 16,
		DefaultValue = 0,
		Type = "CheckBox",
		Setter = "SetBool",
		Getter = "GetBool",
	},
	trolleybus_reload_data = {
		Order = 17,
		Type = "ConCommand",
		Command = "trolleybus_reload_data",
	},
}

function Trolleybus_System.GetTrafficTracks()
	return Trolleybus_System.TrafficTracks
end

function Trolleybus_System.GetInformators()
	return Trolleybus_System.Informators
end

function Trolleybus_System.AddTrafficLightLense(name,data)
	if Trolleybus_System.TrafficLightLenses[name] then
		data.ID = Trolleybus_System.TrafficLightLenses[name].ID
	else
		data.ID = table.insert(Trolleybus_System.TrafficLightLenseIDs,name)
	end
	
	Trolleybus_System.TrafficLightLenses[name] = data
end

function Trolleybus_System.PlayerInDriverPlace(self,ply)
	if self then
		return self.IsTrolleybus and ply:InVehicle() and self:GetDriverSeat()==ply:GetVehicle()
	end
	
	if ply:InVehicle() then
		local veh = Trolleybus_System.GetSeatTrolleybus(ply:GetVehicle())
		
		return IsValid(veh) and veh.IsTrolleybus and veh:GetDriverSeat()==ply:GetVehicle()
	end
	
	return false
end

function Trolleybus_System.CanPressButtons(self,ply)
	if !ply:InVehicle() then
		return self and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()=="trolleybus_clicker" and self:WorldSpaceCenter():Distance(Trolleybus_System.EyePos(ply))<=self:BoundingRadius()+128 and hook.Run("PlayerUse",ply,self)!=false
	end
	
	local veh = ply:GetVehicle()
	
	if !Trolleybus_System.NetworkSystem.GetNWVar(veh,"CanPressTrolleyButtons",false) then return false end

	local bus = Trolleybus_System.GetSeatTrolleybus(veh)
	
	if self then
		return bus==self
	end
	
	return IsValid(bus) and bus.IsTrolleybus
end

function Trolleybus_System.ToolsDisallowed(ply,tool,nowarning)
	if !Trolleybus_System.DefaultMaps[game.GetMap()] or Trolleybus_System.IsEditingDefaultMapsAllowed() then return false end
	
	if
		!tool or
		tool=="trolleybus_cn_editor" or
		tool=="trolleybus_routes_editor" or
		tool=="trolleyinformatoreditor" or
		tool=="trolleytrafficeditor" or
		tool=="trolleytrafficlighteditor"
	then
		if SERVER and !nowarning then
			Trolleybus_System.PlayerMessage(ply,1,"%s","#tool_disallowed")
			ply:SendLua('surface.PlaySound("buttons/button10.wav")')
		end
	
		return true
	end
end

function Trolleybus_System.TurnSignalTickActive(self)
	return (RealTime()-self:GetCreationTime())%0.66>0.33
end

function Trolleybus_System.IsEditingDefaultMapsAllowed()
	return Trolleybus_System.RunEvent("AllowEditingDefaultMaps") and true or false
end

function Trolleybus_System:TrolleybusSystem_AllowEditingDefaultMaps()
	return game.SinglePlayer()
end

function Trolleybus_System.RunEvent(event,...)
	return hook.Call("TrolleybusSystem_"..event,Trolleybus_System,...)
end

function Trolleybus_System.RunChangeEvent(event,oldvalue,value,...)
	if oldvalue!=value then
		Trolleybus_System.RunEvent(event.."Changed",value,...)
	end
end

hook.Add("Initialize","TrolleybusSystem_Register",function()
	Trolleybus_System.RunEvent("RegisterTrafficVehicles",Trolleybus_System.TrafficVehiclesTypes,Trolleybus_System.WheelTypes)
	Trolleybus_System.RunEvent("RegisterTrafficLightTypes",Trolleybus_System.TrafficLightTypes,Trolleybus_System.AddTrafficLightLense)
end)

hook.Add("CanTool","TrolleybusSystem",function(ply,tr,tool)
	if Trolleybus_System.ToolsDisallowed(ply,tool) then return false end
end)

hook.Add("CalcMainActivity","TrolleybusSystem",function(ply,vel)
	if ply:InVehicle() and (!ply:GetAllowWeaponsInVehicle() or !IsValid(ply:GetActiveWeapon())) then
		local seat = ply:GetVehicle()
		local seattype = Trolleybus_System.NetworkSystem.GetNWVar(seat,"SeatType")
	
		if seattype==1 then
			ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
			
			return ACT_HL2MP_IDLE,ply:LookupSequence("idle_all_01")
		end
	end
end)