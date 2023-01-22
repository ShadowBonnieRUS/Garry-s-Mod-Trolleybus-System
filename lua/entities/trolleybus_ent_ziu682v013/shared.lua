-- Copyright © Platunov I. M., 2021 All rights reserved

ENT.PrintName = "ZiU 682V 013"
ENT.Category = {"creationtab_category.default","creationtab_category.default.ziu","creationtab_category.default.ziu9"}

Trolleybus_System.WheelTypes["ziu682v013"] = {
	Model = "models/trolleybus/ziu682v/front_wheel.mdl",
	Ang = Angle(0,90,0),
	Radius = 20,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["ziu682v013_rear"] = {
	Model = "models/trolleybus/ziu682v/rear_wheel.mdl",
	Ang = Angle(0,90,0),
	Radius = 20,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/ziu682v/body_1.mdl"
ENT.MotorVentilatorVoltage = 28
ENT.AccBatteryVoltage = 20

ENT.HasPoles = true
ENT.TrolleyPoleLength = 245.3
ENT.TrolleyPolePos = Vector(3.63,0,57.41)
ENT.TrolleyPoleSideDist = 9.48
ENT.TrolleyPoleDownedAngleLeft = Angle(-1,179.9,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-1,-179.9,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-6,179.9,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-6,-179.9,0)

ENT.PassCapacity = 127

ENT.OtherSeats = {
	{
		Type = 1,
		Pos = Vector(185.8,3.39,-26),
		Ang = Angle(0,0,0),
		Camera = Vector(185.8,3.39,35),
	},
}

ENT.InteriorLights = {
	{pos = Vector(-6,0,15),size = 300,style = 0,brightness = 4,color = Color(255,140,32)},
	{pos = Vector(107,0,15),size = 300,style = 0,brightness = 4,color = Color(255,140,32)},
	{pos = Vector(-119,0,15),size = 300,style = 0,brightness = 4,color = Color(255,140,32)},
}

ENT.DriverSeatData = {
	Type = 0,
	Pos = Vector(180,28,-19),
	Ang = Angle(),
}

ENT.DoorsData = {
	["door1"] = {
		model = "models/trolleybus/ziu682v/door_first.mdl",
		pos = Vector(180.34,-45.11,0.5),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		movehandsound = {"trolleybus/ziu682v013/open_door_hand.ogg",200},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
		shouldopen = function(self) return Either(self.OutsideDoorOpen!=nil,self.OutsideDoorOpen,self:IsPriborButtonActive("opendoor1")) end,
	},
	["door2"] = {
		model = "models/trolleybus/ziu682v/door_middle.mdl",
		pos = Vector(23.46,-44.47,1.82),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
		shouldopen = function(self) return self:IsPriborButtonActive("opendoor2") end,
	},
	["door3"] = {
		model = "models/trolleybus/ziu682v/door_last.mdl",
		pos = Vector(-161.52,-44.47,1.82),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
		shouldopen = function(self) return self:IsPriborButtonActive("opendoor3") end,
	},
}

local model_switch = {
	model = "models/trolleybus/ziu682v/toggle.mdl",
	offset_ang = Angle(-90,0,180),
	offset_pos = Vector(-0.15,0,0),
	anim = true,
	sounds = {
		On = {"trolleybus/ziu682v013/switch_on.ogg",100},
		Off = {"trolleybus/ziu682v013/switch_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_switch2 = {
	model = "models/trolleybus/ziu682v/toggle.mdl",
	offset_ang = Angle(0,-90,-90),
	offset_pos = Vector(-0.15,0,0),
	anim = true,
	sounds = {
		On = {"trolleybus/ziu682v013/switch_on.ogg",100},
		Off = {"trolleybus/ziu682v013/switch_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_vu = {
	model = "models/trolleybus/ziu682v/vu22.mdl",
	offset_pos = Vector(0,1.85,-2.4),
	offset_ang = Angle(0,90,0),
	anim = true,
	sounds = {
		On = {"trolleybus/ziu682v013/vu_on.ogg",100},
		Off = {"trolleybus/ziu682v013/vu_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_akb = {
	model = "models/trolleybus/ziu682v/akb_toggle.mdl",
	offset_pos = Vector(-0.3,0,0),
	offset_ang = Angle(0,90,0),
	anim = true,
	sounds = {
		On = {"trolleybus/ziu682v013/akb_on.ogg",100},
		Off = {"trolleybus/ziu682v013/akb_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_trapdoor = {
	model = "models/trolleybus/ziu682v/trapdoor.mdl",
	anim = true,
	offset_ang = Angle(-90,0,0),
	offset_pos = Vector(-1.5,20,-19.7),
	sounds = {
		On = {"trolleybus/ziu682v013/trapdoor_open.ogg",200},
		Off = {"trolleybus/ziu682v013/trapdoor_close.ogg",200},
	},
	maxdrawdistance = 1000,
	speedmult = 0.5,
}

ENT.PanelsData = {
	["switches"] = {
		pos = Vector(205.03,16.11,-0.76),
		ang = Angle(-42.2,-180,0),
		size = {9.5,6.5},
	},
	["prib_bottom"] = {
		pos = Vector(205.06,37.01,1.11),
		ang = Angle(-47.9,-180,0),
		size = {20,3},
	},
	["prib_top"] = {
		pos = Vector(208.88,37.01,4.35),
		ang = Angle(-45.4,-180,0),
		size = {20,5},
	},
	["vu"] = {
		pos = Vector(182.31,45.13,-1.03),
		ang = Angle(0,-90,0),
		size = {18,8},
	},
	["akb_hb"] = {
		pos = Vector(173.71,41.01,0.92),
		ang = Angle(0,-90,0),
		size = {7,12},
	},
	["main_switch"] = {
		pos = Vector(165,37,43),
		ang = Angle(0,0,0),
		size = {8,11},
	},
	["handbrake"] = {
		pos = Vector(178,39.24,-12.15),
		ang = Angle(0,-90,0),
		size = {20,13},
	},
	["polecatchercontrol"] = {
		pos = Vector(194.34,46.07,-11.63),
		ang = Angle(-90,-180,0),
		size = {2,5},
	},
	["pedals"] = {
		pos = Vector(207.29,38.86,-26.58),
		ang = Angle(-90,-180,0),
		size = {20,40},
	},
	["turnsignal"] = {
		pos = Vector(198.47,31.92,1),
		ang = Angle(-75,-180,0),
		size = {3,2},
	},
	["handdooropen"] = {
		pos = Vector(165.24,-44.76,10),
		ang = Angle(0,-90,0),
		size = {30,50},
	},
	["outsidedooropen"] = {
		pos = Vector(204.38,-47.12,-11),
		ang = Angle(0,-90,0),
		size = {1,1},
	},
	["driverdoor"] = {
		pos = Vector(183.52,-8.33,22.97),
		ang = Angle(0,-142,0),
		size = {18,47},
	},
	["trapdoors"] = {
		pos = Vector(109,-20,49),
		ang = Angle(90,0,0),
		size = {40,243},
	},
	["roofladder"] = {
		pos = Vector(-222.21,8.35,41.35),
		ang = Angle(0,-180,0),
		size = {17,60},
	},
	["reverse"] = {
		pos = Vector(167.25,19.95,-22.14),
		ang = Angle(0,-90,0),
		size = {4,4},
	},
	["route_trapdoor"] = {
		pos = Vector(214.86,21.37,43.15),
		ang = Angle(30,-180,0),
		size = {43,5},
	},
	["route_trapdoor_back"] = {
		pos = Vector(-214.6,-5.52,46.14),
		ang = Angle(40,0,0),
		size = {11,4},
	},
}

ENT.ButtonsData = {
	["vu"] = {
		name = "trolleybus.ziu682v013.btns.vu",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {0.74,1.42},
			radius = 0.5,
		},
		toggle = true,
	},
	["compressor"] = {
		name = "trolleybus.ziu682v013.btns.compressor",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {1.58,1.42},
			radius = 0.5,
		},
		toggle = true,
	},
	["buzzer"] = {
		name = "trolleybus.ziu682v013.btns.buzzer",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {2.4,1.42},
			radius = 0.5,
		},
		toggle = true,
	},
	["sequence"] = {
		name = "trolleybus.ziu682v013.btns.sequence",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {4.59,1.42},
			radius = 0.5,
		},
	},
	["profilelights"] = {
		name = "trolleybus.ziu682v013.btns.profilelights",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {5.64,1.42},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabine_heater_vent"] = {
		name = "trolleybus.ziu682v013.btns.cabine_heater_vent",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {6.73,1.42},
			radius = 0.5,
		},
		toggle = true,
	},
	["opendoor1"] = {
		name = "trolleybus.ziu682v013.btns.opendoor1",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {0.74,3.45},
			radius = 0.5,
		},
		hotkey = KEY_1,
		toggle = true,
		func = function(self,on) self.OutsideDoorOpen = nil end,
	},
	["opendoor2"] = {
		name = "trolleybus.ziu682v013.btns.opendoor2",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {1.57,3.45},
			radius = 0.5,
		},
		hotkey = KEY_2,
		toggle = true,
	},
	["opendoor3"] = {
		name = "trolleybus.ziu682v013.btns.opendoor3",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {2.39,3.45},
			radius = 0.5,
		},
		hotkey = KEY_3,
		toggle = true,
	},
	["doorlights"] = {
		name = "trolleybus.ziu682v013.btns.doorlights",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {5.26,3.45},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorlights1"] = {
		name = "trolleybus.ziu682v013.btns.interiorlights1",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {6.29,3.45},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorlights2"] = {
		name = "trolleybus.ziu682v013.btns.interiorlights2",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {7.14,3.45},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabinelight"] = {
		name = "trolleybus.ziu682v013.btns.cabinelight",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {7.93,3.45},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabineheater"] = {
		name = "trolleybus.ziu682v013.btns.cabineheater",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {8.68,3.45},
			radius = 0.5,
		},
		toggle = true,
	},
	["window_washer"] = {
		name = "trolleybus.ziu682v013.btns.window_washer",
		model = model_switch,
		panel = {
			name = "switches",
			pos = {1.57,5.6},
			radius = 0.5,
		},
		toggle = true,
	},
	["emergency"] = {
		name = "trolleybus.ziu682v013.btns.emergency",
		model = {
			model = "models/trolleybus/ziu682v/emergency_button.mdl",
			offset_ang = Angle(90,0,0),
			offset_pos = Vector(0.03,0,0),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "switches",
			pos = {8.03,5.6},
			radius = 0.6,
		},
		hotkey = KEY_B,
		externalhotkey = "Emergency",
		func = function(self,on)
			if on then
				self.EmergencySignal = !self.EmergencySignal
			end
		end,
	},
	["interior_heater"] = {
		name = "trolleybus.ziu682v013.btns.interior_heater",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {0.74,1.83},
			size = {3.7,6},
		},
		toggle = true,
	},
	["motor_ventilator"] = {
		name = "trolleybus.ziu682v013.btns.motor_ventilator",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {4.99,1.83},
			size = {3.7,6},
		},
		toggle = true,
	},
	["motor_ventilator2"] = {
		name = "trolleybus.ziu682v013.btns.motor_ventilator",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {10,1.83},
			size = {3.7,6},
		},
		toggle = true,
	},
	["compressor_high"] = {
		name = "trolleybus.ziu682v013.btns.compressor_high",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {14.16,1.83},
			size = {3.7,6},
		},
		toggle = true,
	},
	["hydrobooster"] = {
		name = "trolleybus.ziu682v013.btns.hydrobooster",
		model = model_akb,
		panel = {
			name = "akb_hb",
			pos = {3.6,3.22},
			radius = 2,
		},
		toggle = true,
	},
	["akb"] = {
		name = "trolleybus.ziu682v013.btns.akb",
		model = model_akb,
		panel = {
			name = "akb_hb",
			pos = {3.6,9.24},
			radius = 2,
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["main_switch"] = {
		name = "trolleybus.ziu682v013.btns.main_switch",
		model = {
			model = "models/trolleybus/ziu682v/av8a.mdl",
			anim = true,
			offset_pos = Vector(0,3.5,-4.5),
			sounds = {
				On = {"trolleybus/ziu682v013/av8a_on.ogg",100},
				Off = {"trolleybus/ziu682v013/av8a_off.ogg",100},
			},
			maxdrawdistance = 200,
		},
		panel = {
			name = "main_switch",
			pos = {0,0},
			size = {8,11},
		},
		toggle = true,
	},
	["handbrake"] = {
		name = "trolleybus.ziu682v013.btns.handbrake",
		model = {
			model = "models/trolleybus/ziu682v/handbrake.mdl",
			anim = true,
			offset_ang = Angle(0,90,0),
			offset_pos = Vector(0,9,-13),
			sounds = {
				On = {"trolleybus/ziu682v013/handbrake_on.ogg",100},
				Off = {"trolleybus/ziu682v013/handbrake_off.ogg",100},
			},
			maxdrawdistance = 200,
			speedmult = 0.5,
		},
		panel = {
			name = "handbrake",
			pos = {0,0},
			size = {20,13},
		},
		toggle = true,
		hotkey = KEY_V,
		externalhotkey = "Handbrake",
		func = function(self,on)
			self:SetHandbrakeActive(on)
			self:GetSystem("Handbrake"):SetActive(on)
		end,
	},
	["poles_removal_active"] = {
		name = "trolleybus.ziu682v013.btns.poles_removal_active",
		model = model_switch2,
		panel = {
			name = "polecatchercontrol",
			pos = {1.34,4.39},
			radius = 0.5,
		},
		toggle = true,
	},
	["handdooropen"] = {
		name = "trolleybus.ziu682v013.btns.handdooropen",
		panel = {
			name = "handdooropen",
			pos = {0,0},
			size = {30,50},
		},
		func = function(self,on)
			if on then
				local opened = self:DoorIsOpened("door1")
				
				if opened then
					self:CloseDoorWithHand("door1")
				else
					self:OpenDoorWithHand("door1")
				end
			end
		end,
	},
	["driverdoor"] = {
		name = "trolleybus.ziu682v013.btns.driverdoor",
		model = {
			model = "models/trolleybus/ziu682v/cabin_door.mdl",
			anim = true,
			offset_ang = Angle(0,142,0),
			offset_pos = Vector(-2.1,9,-25.5),
			sounds = {
				On = {"trolleybus/ziu682v013/cabine_door_open.ogg",200},
				Off = {"trolleybus/ziu682v013/cabine_door_close.ogg",200},
			},
			maxdrawdistance = 500,
			speedmult = 0.5,
		},
		panel = {
			name = "driverdoor",
			pos = {0,0},
			size = {18,47},
		},
		toggle = true,
	},
	["trapdoor1"] = {
		name = "trolleybus.ziu682v013.btns.trapdoor",
		model = model_trapdoor,
		panel = {
			name = "trapdoors",
			pos = {0,1},
			size = {40,18},
		},
		toggle = true,
	},
	["trapdoor2"] = {
		name = "trolleybus.ziu682v013.btns.trapdoor",
		model = model_trapdoor,
		panel = {
			name = "trapdoors",
			pos = {0,169.8},
			size = {40,18},
		},
		toggle = true,
	},
	["trapdoor3"] = {
		name = "trolleybus.ziu682v013.btns.trapdoor",
		model = model_trapdoor,
		panel = {
			name = "trapdoors",
			pos = {0,224.5},
			size = {40,18},
		},
		toggle = true,
	},
	["roofladder"] = {
		name = "trolleybus.ziu682v013.btns.roofladder",
		model = {
			model = "models/trolleybus/ziu682v/rear_footstep.mdl",
			anim = true,
			offset_ang = Angle(0,180,0),
			offset_pos = Vector(2.9,8.5,-16.9),
			sounds = {
				On = {"trolleybus/ziu682v013/ladder_down.ogg",200},
				Off = {"trolleybus/ziu682v013/ladder_up.ogg",200},
			},
			maxdrawdistance = 1000,
			speedmult = 0.5,
		},
		panel = {
			name = "roofladder",
			pos = {0,0},
			size = {17,60},
		},
		toggle = true,
	},
	["route_trapdoor"] = {
		name = "trolleybus.ziu682v013.btns.route_trapdoor",
		model = {
			model = "models/trolleybus/ziu682v/route_trapdoor.mdl",
			anim = true,
			offset_ang = Angle(31,180,0),
			offset_pos = Vector(-0.2,21.5,5.8),
			maxdrawdistance = 1000,
			speedmult = 0.25,
		},
		panel = {
			name = "route_trapdoor",
			pos = {0,0},
			size = {43,5},
		},
		toggle = true,
	},
	["route_trapdoor_back"] = {
		name = "trolleybus.ziu682v013.btns.route_trapdoor_back",
		model = {
			model = "models/trolleybus/ziu682v/route_trapdoor_small.mdl",
			anim = true,
			offset_ang = Angle(-40,0,0),
			offset_pos = Vector(0,5.5,-3.6),
			maxdrawdistance = 1000,
			speedmult = 0.25,
		},
		panel = {
			name = "route_trapdoor_back",
			pos = {0,0},
			size = {11,4},
		},
		toggle = true,
	},
}

local function CreateIndicatorLamp(name,panel,x,y,type,isactive)
	local mdl =
		(type==0 or type==1) and "models/trolleybus/ziu682v/dashboard_lamp.mdl" or
		type==2 and "models/trolleybus/ziu682v/neon_lamp.mdl"
	
	local bg =
		type==0 and "00" or type==1 and "01" or type==2 and ""
	
	local size =
		(type==0 or type==1) and nil or
		type==2 and {1.8,0.9}
	
	local radius = 
		(type==0 or type==1) and 0.4 or
		type==2 and nil
	
	return {
		name = name,
		model = mdl,
		panel = {
			name = panel,
			pos = {x,y},
			radius = radius,
			size = size,
		},
		offset_ang = Angle(-90,0,180),
		offset_pos = type==2 and Vector(0,0.9,-0.45) or nil,
		initialize = function(self,ent)
			ent:SetBodyGroups(bg)
		end,
		think = function(self,ent)
			local skin = isactive(self,ent) and (type==2 or self:GetNWVar("LowPower")) and 1 or 0
			
			if ent:GetSkin()!=skin then ent:SetSkin(skin) end
		end,
		maxdrawdistance = 200,
	}
end

local function CreateVoltAmpMeter(index,name,panel,x,y,type,min,max,getcur)
	ENT.OtherPanelEntsData[index] = {
		name = name,
		model = "models/trolleybus/ziu682v/o-meter_square.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			size = {1.9,2.2},
		},
		offset_ang = Angle(-90,0,180),
		offset_pos = Vector(0,0.95,-1.1),
		initialize = function(self,ent)
			ent:SetBodygroup(1,type==0 and 0 or type==1 and 2 or 4)
		end,
		maxdrawdistance = 200,
	}
	
	Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,-139,function(self,ent)
		return (getcur(self)-min)/(max-min)*-83
	end,"models/trolleybus/ziu682v/hour_arrow.mdl",Angle(90),Vector(0.5,0.95,-1.7),1,nil,1)
end

local function CreateManometer(index,name,panel,x,y,type)
	local bg = (type==0 or type==3) and 0 or type==1 and 2 or 4
	local bglight = (type==0 or type==3) and 1 or type==1 and 3 or 5
	
	ENT.OtherPanelEntsData[index] = {
		name = name,
		model = "models/trolleybus/ziu682v/o-meter.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = 2,
		},
		offset_ang = Angle(-90,0,180),
		think = function(self,ent)
			local bg = self:GetNWVar("PribLights",false) and bglight or bg
			
			if ent.bg!=bg then
				ent.bg = bg
				ent:SetBodygroup(1,bg)
			end
		end,
		maxdrawdistance = 200,
	}
	
	if type==0 or type==3 then
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,180,function(self,ent)
			return !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(type==3 and 2 or 1)/1000*-180
		end,"models/trolleybus/ziu682v/manometers_arrow.mdl",Angle(90),Vector(0.35,0,0.17),1)
		
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow2","",panel,x,y,0,180,function(self,ent)
			return !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(type==3 and 2 or 1)/1000*180
		end,"models/trolleybus/ziu682v/manometers_arrow.mdl",Angle(90),Vector(0.35,0,-0.13),1)
	elseif type==1 then
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,-90-97,function(self,ent)
			return !self.SystemsLoaded and 0 or math.abs(self:GetSystem("Engine"):GetMoveSpeed())*-2.27
		end,"models/trolleybus/ziu682v/speedometer_arrow.mdl",Angle(90),Vector(0.35,0,0),1)
	elseif type==2 then
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,90,function(self,ent)
			local date = os.date("*t")
			return (date.min+date.sec/60)/60*-360
		end,"models/trolleybus/ziu682v/manometers_arrow.mdl",Angle(90),Vector(0.4,0,0),1)
		
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow2","",panel,x,y,0,-180,function(self,ent)
			local date = os.date("*t")
			return (date.hour+date.min/60)/12*-360
		end,"models/trolleybus/ziu682v/hour_arrow.mdl",Angle(90),Vector(0.35,0,0),1)
	end
end

local function CreatePedal(panel,x,y,brake)
	return {
		name = "",
		model = brake and "models/trolleybus/ziu682v/left_pedal.mdl" or "models/trolleybus/ziu682v/right_pedal.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = 0,
		},
		offset_ang = Angle(-90,0,180),
		maxdrawdistance = 200,
		initialize = function(self,ent)
			ent.SetupPos = function(ent)
				local state
				
				if brake then
					state = self:GetBrakePedal()<=2 and self:GetBrakePedal()/4 or 0.5+(self:GetBrakePedal()-2)/2
				else
					state = self:GetStartPedal()/4
				end
				
				ent.MoveState = ent.MoveState or state
				ent.MoveState = ent.MoveState>state and math.max(state,ent.MoveState-self.DeltaTime*5) or math.min(state,ent.MoveState+self.DeltaTime*5)
				
				ent:SetCycle(ent.MoveState)
			end
			
			ent:SetupPos()
		end,
		think = function(self,ent)
			ent:SetupPos()
		end,
	}
end

ENT.OtherPanelEntsData = {
	["door1opened"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.door1opened","prib_bottom",16.69,1.31,1,function(self,ent)
		return self:DoorIsOpened("door1",true)
	end),
	["door2opened"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.door2opened","prib_bottom",17.81,1.31,1,function(self,ent)
		return self:DoorIsOpened("door2",true)
	end),
	["door3opened"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.door3opened","prib_bottom",18.89,1.31,1,function(self,ent)
		return self:DoorIsOpened("door3",true)
	end),
	["powerlamp"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.powerlamp","prib_bottom",13.5,0.83,2,function(self,ent)
		return self:GetNWVar("PowerLamp",false)
	end),
	["rkpos15"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.rkpos15","prib_bottom",9.67,1.32,0,function(self,ent)
		return self.SystemsLoaded and self:GetSystem("RKSU"):GetPosition()>=15
	end),
	["rkpos17"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.rkpos17","prib_bottom",10.76,1.32,0,function(self,ent)
		return self.SystemsLoaded and self:GetSystem("RKSU"):GetPosition()>=17
	end),
	["rkpos18"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.rkpos18","prib_bottom",11.82,1.32,0,function(self,ent)
		return self.SystemsLoaded and self:GetSystem("RKSU"):GetPosition()>=18
	end),
	["turnlightlamp"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.turnlightlamp","prib_top",9.09,0.65,1,function(self,ent)
		return (self:GetTurnSignal()!=0 or self:GetEmergencySignal()) and Trolleybus_System.TurnSignalTickActive(self)
	end),
	["startpedal"] = CreatePedal("pedals",2.49,2.25,true),
	["brakepedal"] = CreatePedal("pedals",18.65,2.36,false),
	["leftpoleremovallamp"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.leftpoleremovallamp","polecatchercontrol",0.67,1.47,0,function(self,ent)
		return self:GetNWVar("PoleCatchingLeft")
	end),
	["rightpoleremovallamp"] = CreateIndicatorLamp("trolleybus.ziu682v013.lamps.rightpoleremovallamp","polecatchercontrol",1.59,1.47,0,function(self,ent)
		return self:GetNWVar("PoleCatchingRight")
	end),
	["reverserbox"] = {
		name = "",
		model = "models/trolleybus/ziu682v/reversorbox.mdl",
		panel = {
			name = "pedals",
			pos = {12.3,38},
			radius = 0,
		},
		offset_pos = Vector(0,0,0),
		offset_ang = Angle(-90,180,0),
		initialize = function(self,ent)
			ent.SetupPos = function(ent)
				local state = self:GetReverseState()==-1 and 0 or self:GetReverseState()==0 and 0.5 or 1
				
				ent.MoveState = ent.MoveState or state
				ent.MoveState = ent.MoveState>state and math.max(state,ent.MoveState-self.DeltaTime*5) or math.min(state,ent.MoveState+self.DeltaTime*5)
				
				ent:SetCycle(ent.MoveState)
			end
			
			ent:SetupPos()
		end,
		think = function(self,ent)
			ent:SetupPos()
		end,
		maxdrawdistance = 200,
	},
}

CreateVoltAmpMeter("akbvoltmeter","trolleybus.ziu682v013.arrows.akbvoltmeter","prib_bottom",5.52,0.4,1,0,50,function(self)
	return self:GetNWVar("LowVoltage",0)
end)
CreateVoltAmpMeter("akbampmeter","trolleybus.ziu682v013.arrows.akbampmeter","prib_bottom",2.79,0.4,0,-100,100,function(self)
	return !self.SystemsLoaded and 0 or -self:GetSystem("AccumulatorBattery"):GetLastAmperage()
end)
CreateVoltAmpMeter("engineampmeter","trolleybus.ziu682v013.arrows.engineampmeter","prib_bottom",0.05,0.4,2,-500,500,function(self)
	return !self.SystemsLoaded and 0 or -self:GetSystem("Engine"):GetAmperage()
end)

CreateManometer("clocks","trolleybus.ziu682v013.arrows.clocks","prib_top",16.38,2.53,2)
CreateManometer("speedometer","trolleybus.ziu682v013.arrows.speedometer","prib_top",11.43,2.53,1)
CreateManometer("manometer1","trolleybus.ziu682v013.arrows.manometer","prib_top",6.4,2.53,0)
CreateManometer("manometer2","trolleybus.ziu682v013.arrows.manometer","prib_top",1.94,2.53,3)

Trolleybus_System.BuildMultiButton(ENT,"headlights_priblights","switches","trolleybus.ziu682v013.btns.headlights_priblights_left","trolleybus.ziu682v013.btns.headlights_priblights_right",{
	model = "models/trolleybus/ziu682v/headlight_twister.mdl",
	offset_ang = Angle(0,90,90),
	offset_pos = Vector(0,0,0),
	anim = true,
	maxdrawdistance = 200,
},7.73,0.92,1,1,function(self,ent,state) return state==0 and 0 or state==1 and 0.5 or 1 end,function(self,on,state) end,true,nil,nil,nil,0,2)

Trolleybus_System.BuildMultiButton(ENT,"wipers_left","prib_top","trolleybus.ziu682v013.btns.wipers_left_left","trolleybus.ziu682v013.btns.wipers_left_right",{
	model = "models/trolleybus/ziu682v/wipers_twister.mdl",
	offset_ang = Angle(90,0,0),
	offset_pos = Vector(0,0,0),
	anim = true,
	maxdrawdistance = 200,
},3.67,0.25,1,1,function(self,ent,state) return state==-1 and 0 or state==0 and 0.5 or 1 end,function(self,on,state)
	self:SetNWVar("WipersLeftState",state==1 and 1 or state==-1 and 2 or 0)
end,true)

Trolleybus_System.BuildMultiButton(ENT,"wipers_right","prib_top","trolleybus.ziu682v013.btns.wipers_right_left","trolleybus.ziu682v013.btns.wipers_right_right",{
	model = "models/trolleybus/ziu682v/wipers_twister.mdl",
	offset_ang = Angle(90,0,0),
	offset_pos = Vector(0,0,0),
	anim = true,
	maxdrawdistance = 200,
},13.41,0.25,1,1,function(self,ent,state) return state==-1 and 0 or state==0 and 0.5 or 1 end,function(self,on,state)
	self:SetNWVar("WipersRightState",state==1 and 1 or state==-1 and 2 or 0)
end,true)

Trolleybus_System.BuildMultiButton(ENT,"poles_removal","polecatchercontrol","trolleybus.ziu682v013.btns.poles_removal_left","trolleybus.ziu682v013.btns.poles_removal_right",
model_switch2,0.86,2.89,1,1,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,nil,nil,true,KEY_LBRACKET,KEY_RBRACKET)

Trolleybus_System.BuildMultiButton(ENT,"turnsignal","turnsignal","trolleybus.ziu682v013.btns.turnsignal_right","trolleybus.ziu682v013.btns.turnsignal_left",{
	model = "models/trolleybus/ziu682v/blinker.mdl",
	offset_ang = Angle(-90,180,0),
	offset_pos = Vector(0,1.7,0),
	anim = true,
	maxdrawdistance = 200,
},0,0,3,2,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,nil,nil,false,KEY_H,KEY_G,nil,nil,"RightTurnSignal","LeftTurnSignal",true)

Trolleybus_System.BuildMultiButton(ENT,"outsidedooropen","outsidedooropen","trolleybus.ziu682v013.btns.outsidedooropen_left","trolleybus.ziu682v013.btns.outsidedooropen_right",
model_switch2,0,0,1,1,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,function(self,on,state)
	if state!=0 then self.OutsideDoorOpen = state==-1 end
end,true,true)

Trolleybus_System.BuildReverseButton(ENT,"reverse","reverse","trolleybus.ziu682v013.btns.reverse_left","trolleybus.ziu682v013.btns.reverse","trolleybus.ziu682v013.btns.reverse_right",{
	offset_ang = Angle(90,0,0),
	offset_pos = Vector(0,0,0),
	poseparameter = "state",
	sounds = {"trolleybus/reverse_switch.mp3",100,0.5},
	maxdrawdistance = 200,
},0,0,4,4,KEY_9,{KEY_LSHIFT,KEY_0},KEY_0)

local mirror1verts = {
	{x = -2.008502,y = -4.761836},
	{x = -1.18093,y = -4.890398},
	{x = 1.311406,y = -4.879542},
	{x = 2.141617,y = -4.743761},
	{x = 2.439255,y = -4.583863},
	{x = 2.825903,y = -4.049735},
	{x = 2.969584,y = -3.218353},
	{x = 3.125279,y = -1.673213},
	{x = 3.129827,y = 1.638531},
	{x = 2.940248,y = 3.559787},
	{x = 2.789361,y = 4.393667},
	{x = 2.398119,y = 4.92063},
	{x = 1.634218,y = 5.170304},
	{x = -0.340933,y = 5.199464},
	{x = -1.586938,y = 5.156275},
	{x = -2.352427,y = 4.89994},
	{x = -2.74671,y = 4.380914},
	{x = -2.882755,y = 3.534424},
	{x = -3.055701,y = 1.611589},
	{x = -3.033761,y = -1.715103},
	{x = -2.795141,y = -3.621081},
	{x = -2.70997,y = -4.107799},
	{x = -2.311291,y = -4.604556},
}

local mirror2verts = {
	{x = -7.4804,y = -2.025294},
	{x = -7.091438,y = -2.890066},
	{x = -6.124702,y = -3.290359},
	{x = -2.420132,y = -3.547147},
	{x = 2.421111,y = -3.520713},
	{x = 6.125682,y = -3.222383},
	{x = 7.084867,y = -2.814545},
	{x = 7.466274,y = -1.94221},
	{x = 7.439842,y = 1.883203},
	{x = 7.05088,y = 2.815951},
	{x = 6.084142,y = 3.212464},
	{x = 2.379573,y = 3.503239},
	{x = -2.461673,y = 3.480586},
	{x = -6.162464,y = 3.148268},
	{x = -7.125427,y = 2.736649},
	{x = -7.503059,y = 1.8039},
}

Trolleybus_System.BuildMovingMirror(ENT,"mirror_left",Vector(193.34,45.62,21.47),Angle(0,-90,0),10,10,"models/trolleybus/ziu682v/mirror_bracket.mdl",Vector(213.2,47.43,23.37),Angle(0,0,1.8),"Bone001","Bone002",Vector(-1.92,0.05,0.15),Angle(-0.5,180.2,0),5,9.5,false,true,0,90,-45,45,0,0,-15,15,mirror1verts,50,-35)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_right",Vector(215,-23.93,16),Angle(0,-180,0),10,10,"models/trolleybus/ziu682v/mirror_bracket.mdl",Vector(213.02,-47.15,26.89),Angle(-1.8,0,-1.4),"Bone001","Bone002",Vector(-1.96,0.05,0.15),Angle(-0.5,180.2,0),5,9.5,false,true,-90,0,-45,45,0,0,-15,15,mirror1verts,-40,12)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_middle",Vector(217.02,-5.65,18.33),Angle(0,-180,0),10,10,"models/trolleybus/ziu682v/mirror_bracket_inside.mdl",Vector(213.47,-27,37.66),Angle(0,0,0),"Bone001","Bone002",Vector(-1.7,0,-0.8),Angle(0,180,0),13.5,6,false,true,0,0,-29,0,0,0,-20,20,mirror2verts,0,-29,0,-11)

function ENT:LoadSystems()
	self:LoadSystem("AccumulatorBattery",{Voltage = self.AccBatteryVoltage})
	self:LoadSystem("Pneumatic",{
		MotorCompressorSpeed = 30,
		MotorCompressorSounds = {
			StartSounds = Sound("trolleybus/ziu682v013/compressor_on_outside.ogg"),
			LoopSound = Sound("trolleybus/ziu682v013/compressor_outside.ogg"),
			EndSounds = Sound("trolleybus/ziu682v013/compressor_off_outside.ogg"),
			SndVolume = 0.75,
			
			InsideStartSounds = Sound("trolleybus/ziu682v013/compressor_on_inside.ogg"),
			InsideLoopSound = Sound("trolleybus/ziu682v013/compressor_inside.ogg"),
			InsideEndSounds = Sound("trolleybus/ziu682v013/compressor_off_inside.ogg"),
			InsideSndVolume = 0.75,
			
			SoundPos = Vector(-32.57,37.41,-35.89),
		},
		Receivers = {
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				PneumaticDoors = {["door1"] = {400,600,1.5},["door2"] = {400,600,1.5},["door3"] = {400,600,1.5}},
				DefaultAir = self:GetSpawnSetting("pressure")*100,
			},
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				PneumaticDoors = {["door1"] = {400,600,1.5},["door2"] = {400,600,1.5},["door3"] = {400,600,1.5}},
				DefaultAir = self:GetSpawnSetting("pressure")*100,
			},
		},
		BrakeChambers = {
			{
				Size = 50,
				DriveWheelsBrake = false,
				BrakeReceiver = 1,
				BrakeDeceleration = 1000,
			},
			{
				Size = 50,
				DriveWheelsBrake = true,
				BrakeReceiver = 2,
				BrakeDeceleration = 1000,
			},
		},
	})
	self:LoadSystem("MotorVentilator",{
		/*StartSounds = Sound("trolleybus/ziu682v013/motor_ventilator_on_outside.ogg"),
		InsideStartSounds = Sound("trolleybus/ziu682v013/motor_ventilator_on_inside.ogg"),
		LoopSound = Sound("trolleybus/ziu682v013/motor_ventilator_outside.ogg"),
		InsideLoopSound = Sound("trolleybus/ziu682v013/motor_ventilator_inside.ogg"),
		StopSounds = Sound("trolleybus/ziu682v013/motor_ventilator_off_outside.ogg"),
		InsideStopSounds = Sound("trolleybus/ziu682v013/motor_ventilator_off_inside.ogg"),*/
		
		SoundPos = Vector(35.87,27.29,-31.67),
		SoundDistance = 1000,
	})
	self:LoadSystem("Horn",{
		SoundPos = Vector(219,0,-19),
	})
	self:LoadSystem("IR-2002",{
		Pos = Vector(212.04,7.15,-0.35),
		Ang = Angle(0,-180,0),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(205.9,11,-22),
	})
	self:LoadSystem("Handbrake")
	self:LoadSystem("Buzzer",{
		SoundPos = Vector(177,44,-16.07),
		
		LoopSound = Sound("trolleybus/ziu682v013/buzzer.ogg"),
		StopSounds = Sound("trolleybus/ziu682v013/buzzer_off.ogg"),
	})
	self:LoadSystem("HydraulicBooster",{
		SoundPos = Vector(174.56,40.55,-31.29),
	})
	self:LoadSystem("Nameplates",{
		Types = {
			["default"] = {
				type = 0,
				width = 36,
				height = 8,
				model = {
					model = "models/trolleybus/ziu682v/routeplate.mdl",
					offset_pos = Vector(-0.25,18,-9),
					offset_ang = Angle(),
				},
				nfont = "Trolleybus_System.Trolleybus.ZiU682V013.RouteDisplay.NameplateNumber",
				font = "Trolleybus_System.Trolleybus.ZiU682V013.RouteDisplay.Nameplate",
				drawscale = 10,
			},
			["small"] = {
				type = 2,
				width = 8,
				height = 5,
				model = {
					model = "models/trolleybus/ziu682v/routeplate.mdl",
					offset_pos = Vector(-0.25,4,-5.1),
					offset_ang = Angle(),
					bg = "1",
				},
				nfont = "Trolleybus_System.Trolleybus.ZiU682V013.RouteDisplay.RearNumber",
				drawscale = 10,
			},
		},
		Positions = {
			{
				pos = Vector(220.1,-18,47.43),
				ang = Angle(0,0,0),
				type = "default",
				shouldbeactive = function(sys,self) return self:ButtonIsDown("route_trapdoor") end,
				think = function(sys,self,ent) ent:SetSkin(self:GetScheduleLight()>0 and 1 or 0) end,
			},
			{
				pos = Vector(214,-41.09,5),
				ang = Angle(0,0,0),
				type = "small",
			},
			{
				pos = Vector(-112.9,-46.4,14.2),
				ang = Angle(0,-90,0),
				type = "default",
			},
			{
				pos = Vector(-220.35,4.06,48.99),
				ang = Angle(0,-180,0),
				type = "small",
				shouldbeactive = function(sys,self) return self:ButtonIsDown("route_trapdoor_back") end,
				think = function(sys,self,ent) ent:SetSkin(self:GetScheduleLight()>0 and 1 or 0) end,
			},
		},
	})
end

ENT.SpawnSettings = {
	{
		alias = "pressure",
		type = "Slider",
		name = "trolleybus.ziu682v013.settings.pressure",
		min = 0,
		max = 8,
		default = 0,
		preview = {"trolleybus/spawnsettings_previews/ziu682v013/pressure",0,8},
	},
	{
		alias = "mainswitchdisabling",
		type = "CheckBox",
		name = "trolleybus.ziu682v013.settings.mainswitchdisabling",
		nopreview = true,
		default = true,
	},
	{
		alias = "moldings",
		type = "ComboBox",
		name = "trolleybus.ziu682v013.settings.moldings",
		default = 1,
		choices = {
			{name = "trolleybus.ziu682v013.settings.moldings.up_down",preview = "trolleybus/spawnsettings_previews/ziu682v013/moldings1.png"},
			{name = "trolleybus.ziu682v013.settings.moldings.up",preview = "trolleybus/spawnsettings_previews/ziu682v013/moldings2.png"},
			{name = "trolleybus.ziu682v013.settings.moldings.down",preview = "trolleybus/spawnsettings_previews/ziu682v013/moldings3.png"},
			{name = "trolleybus.ziu682v013.settings.moldings.none",preview = "trolleybus/spawnsettings_previews/ziu682v013/moldings4.png"},
		},
		setup = function(self,value)
			if SERVER then
				self:SetBodygroup(2,(value==1 or value==2) and 1 or 0)
				self:SetBodygroup(3,(value==1 or value==3) and 1 or 0)
			end
		end,
		unload = function(self,value)
			if SERVER then
				self:SetBodygroup(2,0)
				self:SetBodygroup(3,0)
			end
		end,
	},
	{
		alias = "logo",
		type = "CheckBox",
		name = "trolleybus.ziu682v013.settings.logo",
		default = true,
		preview_on = "trolleybus/spawnsettings_previews/ziu682v013/logo1.png",
		preview_off = "trolleybus/spawnsettings_previews/ziu682v013/logo2.png",
		setup = function(self,value)
			if SERVER then
				self:SetBodygroup(1,value and 1 or 0)
			end
		end,
		unload = function(self,value)
			if SERVER then
				self:SetBodygroup(1,0)
			end
		end,
	},
	{
		alias = "reductor",
		type = "ComboBox",
		name = "trolleybus.ziu682v013.settings.reductor",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.ziu682v013.settings.reductor.raba118",preview = "trolleybus/spawnsettings_previews/ziu682v013/raba118dk213a.wav"},
			{name = "trolleybus.ziu682v013.settings.reductor.raba018",preview = "trolleybus/spawnsettings_previews/ziu682v013/raba018dk213a.wav"},
		},
		setup = function(self,value)
			local sndcfg = value==1 and {
				{sound = Sound("trolleybus/ziu682v013/reductor_raba.ogg"),pratemp = 1/900,pratestart = 0,volume = function(self,ent)
					return !ent.SystemsLoaded and 0 or math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/300,0.1,1)
				end},
				{sound = Sound("trolleybus/ziu682v013/reductor_raba_background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
			} or {
				{sound = Sound("trolleybus/ziu682v013/reductor_raba018.ogg"),pratemp = 1/1000,pratestart = 0,volume = function(self,ent)
					return !ent.SystemsLoaded and 0 or math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/300,0.1,1)
				end},
				{sound = Sound("trolleybus/ziu682v013/reductor_raba_background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
			}
		
			self:LoadSystem("Reductor",{
				SoundConfig = sndcfg,
				
				SoundPos = Vector(-92.06,0.97,-38.53),
			})
			
			if SERVER then
				for k,v in ipairs(self.Wheels) do
					if !v.Drive then continue end
					
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(1,value==1 and 2 or 1)
					end
				end
			end
		end,
		unload = function(self,value)
			self:UnloadSystem("Reductor")
			
			if SERVER then
				for k,v in ipairs(self.Wheels) do
					if !v.Drive then continue end
					
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(1,0)
					end
				end
			end
		end,
	},
	{
		alias = "engine",
		type = "ComboBox",
		name = "trolleybus.ziu682v013.settings.engine",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.ziu682v013.settings.engine.dk213",preview = "trolleybus/spawnsettings_previews/ziu682v013/raba118dk213a.wav"},
			{name = "trolleybus.ziu682v013.settings.engine.dk210",preview = "trolleybus/spawnsettings_previews/ziu682v013/raba118dk210a3.wav"},
		},
		setup = function(self,value)
			local sndcfg = value==1 and {
				{sound = Sound("trolleybus/ziu682v013/engine_dk213.ogg"),startspd = 600,fadein = 1000,pratemp = 1/1200,pratestart = 1,volume = 1},
			} or {
				{sound = Sound("trolleybus/ziu682v013/engine_dk210.ogg"),startspd = 500,fadein = 1000,pratemp = 1/1100,pratestart = 1,volume = 1.5},
			}
			
			self:LoadSystem("Engine",{
				SoundConfig = sndcfg,
				SoundPos = Vector(-27.72,0.31,-38.2),
				
				WheelRadius = 20,
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("Engine")
		end,
	},
	{
		alias = "contactors",
		type = "ComboBox",
		name = "trolleybus.ziu682v013.settings.contactors",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.ziu682v013.settings.contactors.type1",preview = "trolleybus/spawnsettings_previews/ziu682v013/contactors1.wav"},
			{name = "trolleybus.ziu682v013.settings.contactors.type2",preview = "trolleybus/spawnsettings_previews/ziu682v013/contactors2.wav"},
			{name = "trolleybus.ziu682v013.settings.contactors.type3",preview = "trolleybus/spawnsettings_previews/ziu682v013/contactors3.wav"},
		},
		setup = function(self,value)
			local contactors = value==1 and {
				LK123 = {Sound("trolleybus/ziu682v013/contactor_lk123_on.ogg"),Sound("trolleybus/ziu682v013/contactor_lk123_off.ogg")},
				R = {Sound("trolleybus/ziu682v013/contactor_r_on.ogg")},
				T = {Sound("trolleybus/ziu682v013/contactor_t_on.ogg"),Sound("trolleybus/ziu682v013/contactor_t_off.ogg")},
			} or value==2 and {
				LK123 = {Sound("trolleybus/ziu682v013/contactor_lk123_on_2.ogg"),Sound("trolleybus/ziu682v013/contactor_lk123_off_2.ogg")},
				R = {Sound("trolleybus/ziu682v013/contactor_r_on.ogg")},
				T = {Sound("trolleybus/ziu682v013/contactor_t_on_2.ogg"),Sound("trolleybus/ziu682v013/contactor_t_off_2.ogg")},
			} or {
				LK123 = {Sound("trolleybus/ziu682v013/contactor_lk123_on_3.ogg"),Sound("trolleybus/ziu682v013/contactor_lk123_off_3.ogg")},
				R = {Sound("trolleybus/ziu682v013/contactor_r_on_3.ogg")},
				T = {Sound("trolleybus/ziu682v013/contactor_t_on_3.ogg"),Sound("trolleybus/ziu682v013/contactor_t_off_3.ogg")},
			}
			
			self:LoadSystem("RKSU",{
				ContactorSoundPos = Vector(206,-17,-4),
				ContactorSoundVolume = value==2 and 1 or nil,
				ContactorSounds = contactors,
				
				RCSoundPos = Vector(90.81,35.63,-34.25),
				RCSounds = {
					StartSoundsCool = Sound("trolleybus/ziu682v013/grk_up_start.ogg"),
					LoopSoundCool = Sound("trolleybus/ziu682v013/grk_up_loop.ogg"),
					StopSoundsCool = Sound("trolleybus/ziu682v013/grk_stop.ogg"),
					
					StartSoundsUncool = {},
					LoopSoundUncool = Sound("trolleybus/ziu682v013/grk_sbros_loop.ogg"),
					StopSoundsUncool = Sound("trolleybus/ziu682v013/grk_stop.ogg"),
				},
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("RKSU")
		end,
	},
	Trolleybus_System.BuildSkinSpawnSetting("ziu682v013","trolleybus.ziu682v013.settings.skins"),
}
