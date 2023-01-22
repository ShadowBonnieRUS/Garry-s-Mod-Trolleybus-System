-- Copyright © Platunov I. M., 2021 All rights reserved

ENT.PrintName = "AKSM 101 PS"
ENT.Category = {"creationtab_category.default","creationtab_category.default.aksm","creationtab_category.default.aksm101"}

Trolleybus_System.WheelTypes["aksm101ps"] = {
	Model = "models/trolleybus/aksm101ps/wheel_front.mdl",
	Ang = Angle(0,90,0),
	Radius = 20,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["aksm101ps_rear"] = {
	Model = "models/trolleybus/aksm101ps/wheel_rear.mdl",
	Ang = Angle(0,90,0),
	Radius = 20,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/aksm101ps/part_body.mdl"
ENT.StaticConverterVoltage = 28
ENT.AccBatteryVoltage = 20

ENT.HasPoles = true
ENT.TrolleyPoleLength = 245.5
ENT.TrolleyPolePos = Vector(3.63,0,57.41)
ENT.TrolleyPoleSideDist = 9.48
ENT.TrolleyPoleDownedAngleLeft = Angle(-1,179.9,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-1,-179.9,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-6,179.9,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-6,-179.9,0)

ENT.PassCapacity = 114

ENT.OtherSeats = {
	{
		Type = 1,
		Pos = Vector(185.8,3.39,-26),
		Ang = Angle(0,0,0),
		Camera = Vector(185.8,3.39,33),
	},
}

ENT.InteriorLights = {
	{pos = Vector(-6,0,15),size = 300,style = 0,brightness = 4,color = Color(255,140,32)},
	{pos = Vector(107,0,15),size = 300,style = 0,brightness = 4,color = Color(255,140,32)},
	{pos = Vector(-119,0,15),size = 300,style = 0,brightness = 4,color = Color(255,140,32)},
}

ENT.DriverSeatData = {
	Type = 0,
	Pos = Vector(180,28,-12),
	Ang = Angle(),
}

ENT.DoorsData = {
	["door1"] = {
		model = "models/trolleybus/aksm101ps/door_first.mdl",
		pos = Vector(180.33,-45.13,1.59),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		movehandsound = {"trolleybus/aksm101ps/open_door_hand.ogg",200},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
	},
	["door2"] = {
		model = "models/trolleybus/aksm101ps/door_middle.mdl",
		pos = Vector(23.32,-45.43,1.67),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
	},
	["door3"] = {
		model = "models/trolleybus/aksm101ps/door_last.mdl",
		pos = Vector(-161.89,-45.62,1.67),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
	},
}

ENT.PanelsData = {
	["rightprib"] = {
		pos = Vector(203.8,17.05,6.74),
		ang = Angle(-53.2,-180,0),
		size = {10,4},
	},
	["rightprib2"] = {
		pos = Vector(209.31,17.12,7.02),
		ang = Angle(-90,-180,0),
		size = {10,4},
	},
	["prib"] = {
		pos = Vector(209.32,37.94,6.56),
		ang = Angle(-35,-180,0),
		size = {20,7},
	},
	["leftprib"] = {
		pos = Vector(204.25,44.19,7.04),
		ang = Angle(-76.4,-180,0),
		size = {4,13},
	},
	["avs"] = {
		pos = Vector(165.51,25.57,24.9),
		ang = Angle(0,0,0),
		size = {12,6},
	},
	["main_switch"] = {
		pos = Vector(166.07,34.97,42.58),
		ang = Angle(0,0,0),
		size = {10,12},
	},
	["akb_hydro"] = {
		pos = Vector(191.9,41.03,-5.92),
		ang = Angle(0,-90,0),
		size = {4,10},
	},
	["pedals"] = {
		pos = Vector(208.83,36.4,-19.81),
		ang = Angle(-80,-180,0),
		size = {17,10},
	},
	["driverdoor"] = {
		pos = Vector(195.09,-22.15,18.01),
		ang = Angle(0,38,0),
		size = {36,40},
	},
	["handdooropen"] = {
		pos = Vector(164.78,-45.96,1.12),
		ang = Angle(0,-90,0),
		size = {30,40},
	},
	["dooroutsideopen"] = {
		pos = Vector(204.34,-47.27,-11.22),
		ang = Angle(0,-90,0),
		size = {1,1},
	},
	["handbrake"] = {
		pos = Vector(176.8,16.42,-5.15),
		ang = Angle(0,-135,0),
		size = {8,20},
	},
	["trapdoors"] = {
		pos = Vector(-60.75,-20.92,48.68),
		ang = Angle(90,0,0),
		size = {42,74},
	},
	["ladder"] = {
		pos = Vector(-223.06,9.96,40.37),
		ang = Angle(0,-180,0),
		size = {20,50},
	},
	["turnsignal"] = {
		pos = Vector(202.25,30.58,5.34),
		ang = Angle(-80,-180,-90),
		size = {3,6},
	},
	["trapdoor_front"] = {
		pos = Vector(212.04,24.85,48.32),
		ang = Angle(0,-180,0),
		size = {50,10},
	},
	["reverse"] = {
		pos = Vector(167.25,19.95,-18.14),
		ang = Angle(0,-90,0),
		size = {4,4},
	},
	["guitar"] = {
		pos = Vector(202.17,21.27,5.1),
		ang = Angle(-80,-180,0),
		size = {2,2},
	},
}

local model_switch = {
	model = "models/trolleybus/aksm101ps/toggle.mdl",
	offset_ang = Angle(180,90,90),
	offset_pos = Vector(-0.22,0,0),
	anim = true,
	sounds = {
		On = {"trolleybus/aksm101ps/switch_on.ogg",100},
		Off = {"trolleybus/aksm101ps/switch_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_switch2 = {
	model = "models/trolleybus/aksm101ps/toggle.mdl",
	offset_ang = Angle(-90,90,90),
	offset_pos = Vector(-0.22,0,0),
	anim = true,
	sounds = {
		On = {"trolleybus/aksm101ps/switch_on.ogg",100},
		Off = {"trolleybus/aksm101ps/switch_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_vu = {
	model = "models/trolleybus/aksm101ps/vu22.mdl",
	offset_pos = Vector(0,1.85,-2.5),
	offset_ang = Angle(0,90,0),
	anim = true,
	sounds = {
		On = {"trolleybus/aksm101ps/vu_on.ogg",100},
		Off = {"trolleybus/aksm101ps/vu_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_akb = {
	model = "models/trolleybus/ziu682v/akb_toggle.mdl",
	offset_pos = Vector(-0.5,0,0),
	offset_ang = Angle(0,90,0),
	anim = true,
	sounds = {
		On = {"trolleybus/ziu682v013/akb_on.ogg",100},
		Off = {"trolleybus/ziu682v013/akb_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local model_trapdoor = {
	model = "models/trolleybus/aksm101ps/trapdoor.mdl",
	offset_ang = Angle(-90,0,0),
	offset_pos = Vector(-2.7,ENT.PanelsData["trapdoors"].size[1]/2,-19/2),
	anim = true,
	sounds = {
		On = {"trolleybus/aksm101ps/trapdoor_open.ogg",200},
		Off = {"trolleybus/aksm101ps/trapdoor_close.ogg",200},
	},
	maxdrawdistance = 1000,
	speedmult = 0.5,
}

local model_wipersbtn = {
	model = "models/trolleybus/aksm101ps/square_button.mdl",
	offset_pos = Vector(-0.3,0.4,-0.65),
	offset_ang = Angle(-90,90,90),
	anim = true,
	sounds = {
		On = {"trolleybus/tumbler_on.mp3",100},
		Off = {"trolleybus/tumbler_off.mp3",100},
	},
	maxdrawdistance = 200,
}

ENT.ButtonsData = {
	["vu"] = {
		name = "trolleybus.aksm101ps.btns.vu",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,9.67},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorlight2"] = {
		name = "trolleybus.aksm101ps.btns.interiorlight2",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,9.67},
			radius = 0.5,
		},
		toggle = true,
	},
	["compressor"] = {
		name = "trolleybus.aksm101ps.btns.compressor",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,8.4},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorlight1"] = {
		name = "trolleybus.aksm101ps.btns.interiorlight1",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,8.4},
			radius = 0.5,
		},
		toggle = true,
	},
	["buzzer"] = {
		name = "trolleybus.aksm101ps.btns.buzzer",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,7.31},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabinelight"] = {
		name = "trolleybus.aksm101ps.btns.cabinelight",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,7.31},
			radius = 0.5,
		},
		toggle = true,
	},
	["sequence"] = {
		name = "trolleybus.aksm101ps.btns.sequence",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,5.95},
			radius = 0.5,
		},
	},
	["profilelights"] = {
		name = "trolleybus.aksm101ps.btns.profilelights",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,5.95},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabineheater1"] = {
		name = "trolleybus.aksm101ps.btns.cabineheater1",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,4.77},
			radius = 0.5,
		},
		toggle = true,
	},
	["doorlights"] = {
		name = "trolleybus.aksm101ps.btns.doorlights",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1,4.77},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabineheater2"] = {
		name = "trolleybus.aksm101ps.btns.cabineheater2",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,3.68},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorheater2"] = {
		name = "trolleybus.aksm101ps.btns.interiorheater2",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,3.68},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabinevent"] = {
		name = "trolleybus.aksm101ps.btns.cabinevent",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,2.67},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorvent2"] = {
		name = "trolleybus.aksm101ps.btns.interiorvent2",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,2.67},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorvent1"] = {
		name = "trolleybus.aksm101ps.btns.interiorvent1",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3,1.61},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorheater1"] = {
		name = "trolleybus.aksm101ps.btns.interiorheater1",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,1.61},
			radius = 0.5,
		},
		toggle = true,
	},
	["polecatchers_control"] = {
		name = "trolleybus.aksm101ps.btns.polecatchers_control",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.07,12.43},
			radius = 0.5,
		},
		toggle = true,
	},
	["opendoor1"] = {
		name = "trolleybus.aksm101ps.btns.opendoor1",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {2.92,1.96},
			radius = 0.5,
		},
		hotkey = KEY_1,
		func = function(self,on) if on then if self:DoorIsOpened("door1") then self:CloseDoor("door1") else self:OpenDoor("door1") end end end,
	},
	["opendoor2"] = {
		name = "trolleybus.aksm101ps.btns.opendoor2",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {1.92,1.96},
			radius = 0.5,
		},
		hotkey = KEY_2,
		func = function(self,on) if on then if self:DoorIsOpened("door2") then self:CloseDoor("door2") else self:OpenDoor("door2") end end end,
	},
	["opendoor3"] = {
		name = "trolleybus.aksm101ps.btns.opendoor3",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {0.88,1.96},
			radius = 0.5,
		},
		hotkey = KEY_3,
		func = function(self,on) if on then if self:DoorIsOpened("door3") then self:CloseDoor("door3") else self:OpenDoor("door3") end end end,
	},
	["opendoors"] = {
		name = "trolleybus.aksm101ps.btns.opendoors",
		model = {
			model = "models/trolleybus/aksm101ps/door_button.mdl",
			offset_ang = Angle(0,90,90),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "rightprib",
			pos = {4.78,0.75},
			radius = 1,
		},
		hotkey = KEY_4,
		func = function(self,on) if on then self:OpenDoor("door2") self:OpenDoor("door3") end end,
	},
	["closedoors"] = {
		name = "trolleybus.aksm101ps.btns.closedoors",
		model = {
			model = "models/trolleybus/aksm101ps/door_button.mdl",
			offset_ang = Angle(0,90,90),
			anim = true,
			maxdrawdistance = 200,
			initialize = function(self,ent) ent:SetBodygroup(0,1) end,
		},
		panel = {
			name = "rightprib",
			pos = {7.09,0.75},
			radius = 1,
		},
		hotkey = KEY_5,
		func = function(self,on) if on then self:CloseDoor("door2") self:CloseDoor("door3") end end,
	},
	["voltageconverter"] = {
		name = "trolleybus.aksm101ps.btns.voltageconverter",
		model = model_vu,
		panel = {
			name = "avs",
			pos = {0,0},
			size = {3.7,6},
		},
		toggle = true,
	},
	["compressor_high"] = {
		name = "trolleybus.aksm101ps.btns.compressor_high",
		model = model_vu,
		panel = {
			name = "avs",
			pos = {4.21,0},
			size = {3.7,6},
		},
		toggle = true,
	},
	["interior_heater_power_voltageconverter"] = {
		name = "trolleybus.aksm101ps.btns.interior_heater_power_voltageconverter",
		model = model_vu,
		panel = {
			name = "avs",
			pos = {8.33,0},
			size = {3.7,6},
		},
		toggle = true,
	},
	["wipers_left"] = {
		name = "trolleybus.aksm101ps.btns.wipers_left",
		model = model_wipersbtn,
		panel = {
			name = "rightprib2",
			pos = {1.26,1.1},
			size = {0.75,1.3},
		},
		toggle = true,
	},
	["wipers_right"] = {
		name = "trolleybus.aksm101ps.btns.wipers_right",
		model = model_wipersbtn,
		panel = {
			name = "rightprib2",
			pos = {2.21,1.1},
			size = {0.75,1.3},
		},
		toggle = true,
	},
	["window_washer"] = {
		name = "trolleybus.aksm101ps.btns.window_washer",
		model = model_switch2,
		panel = {
			name = "rightprib2",
			pos = {4.68,2.09},
			radius = 0.5,
		},
		toggle = true,
	},
	["priborslight"] = {
		name = "trolleybus.aksm101ps.btns.priborslight",
		model = {
			model = "models/trolleybus/aksm101ps/headlight_twister.mdl",
			offset_ang = Angle(90,0,0),
			offset_pos = Vector(0,0,0),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "rightprib2",
			pos = {7.12,2.18},
			radius = 0.75,
		},
		toggle = true,
	},
	["emergency"] = {
		name = "trolleybus.aksm101ps.btns.emergency",
		model = {
			model = "models/trolleybus/aksm101ps/emergency_button.mdl",
			offset_ang = Angle(90,0,0),
			offset_pos = Vector(0.03,0,0),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "rightprib",
			pos = {8.83,1.77},
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
	["headlights"] = {
		name = "trolleybus.aksm101ps.btns.headlights",
		model = {
			model = "models/trolleybus/aksm101ps/guitar_light_button.mdl",
			offset_ang = Angle(-100,0,180),
			offset_pos = Vector(0,0,-0.9),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "guitar",
			pos = {0,0},
			size = {1,2},
		},
		hotkey = KEY_F,
		toggle = true,
	},
	["horn"] = {
		name = "trolleybus.aksm101ps.btns.horn",
		model = {
			model = "models/trolleybus/aksm101ps/horn_button.mdl",
			offset_ang = Angle(0,180,0),
			offset_pos = Vector(0,0.1,-0.9),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "guitar",
			pos = {1,0},
			size = {1,2},
		},
		hotkey = KEY_T,
		externalhotkey = "Horn",
	},
	["main_switch"] = {
		name = "trolleybus.aksm101ps.btns.main_switch",
		model = {
			model = "models/trolleybus/aksm101ps/av8a.mdl",
			anim = true,
			offset_pos = Vector(0,5.5,-4.5),
			sounds = {
				On = {"trolleybus/aksm101ps/av8a_on.ogg",100},
				Off = {"trolleybus/aksm101ps/av8a_off.ogg",100},
			},
			maxdrawdistance = 200,
		},
		panel = {
			name = "main_switch",
			pos = {0,0},
			size = ENT.PanelsData["main_switch"].size,
		},
		toggle = true,
	},
	["hydrobooster"] = {
		name = "trolleybus.aksm101ps.btns.hydrobooster",
		model = model_akb,
		panel = {
			name = "akb_hydro",
			pos = {1.99,2.55},
			radius = 2,
		},
		toggle = true,
	},
	["akb"] = {
		name = "trolleybus.aksm101ps.btns.akb",
		model = model_akb,
		panel = {
			name = "akb_hydro",
			pos = {2.01,7.52},
			radius = 2,
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["handdooropen"] = {
		name = "trolleybus.aksm101ps.btns.handdooropen",
		panel = {
			name = "handdooropen",
			pos = {0,0},
			size = ENT.PanelsData["handdooropen"].size,
		},
		func = function(self,on)
			if on and !self:CanDoorsMove("door1") then
				local opened = self:DoorIsOpened("door1")
				
				if opened then
					self:CloseDoorWithHand("door1")
				else
					self:OpenDoorWithHand("door1")
				end
			end
		end,
	},
	["handbrake"] = {
		name = "trolleybus.aksm101ps.btns.handbrake",
		model = {
			model = "models/trolleybus/aksm101ps/pneumatic_brake.mdl",
			anim = true,
			offset_ang = Angle(0,135,0),
			offset_pos = Vector(0.5,4,-21.5),
			sounds = {
				On = {"trolleybus/aksm101ps/handbrake_on.ogg",100},
				Off = {"trolleybus/aksm101ps/handbrake_off.ogg",100},
			},
			maxdrawdistance = 200,
			speedmult = 0.5,
		},
		panel = {
			name = "handbrake",
			pos = {0,0},
			size = ENT.PanelsData["handbrake"].size,
		},
		toggle = true,
		hotkey = KEY_V,
		externalhotkey = "Handbrake",
		func = function(self,on)
			self:SetHandbrakeActive(on)
			self:GetSystem("Handbrake"):SetActive(on)
		end,
	},
	["driverdoor"] = {
		name = "trolleybus.aksm101ps.btns.driverdoor",
		model = {
			model = "models/trolleybus/aksm101ps/cabin_door.mdl",
			anim = true,
			offset_ang = Angle(0,-38,0),
			offset_pos = Vector(1.3,9,-20.5),
			sounds = {
				On = {"trolleybus/aksm101ps/cabine_door_open.ogg",200},
				Off = {"trolleybus/aksm101ps/cabine_door_close.ogg",200},
			},
			maxdrawdistance = 500,
			speedmult = 0.5,
		},
		panel = {
			name = "driverdoor",
			pos = {0,0},
			size = ENT.PanelsData["driverdoor"].size,
		},
		toggle = true,
	},
	["ladder"] = {
		name = "trolleybus.aksm101ps.btns.ladder",
		model = {
			model = "models/trolleybus/aksm101ps/rear_footstep.mdl",
			anim = true,
			offset_ang = Angle(0,180,0),
			offset_pos = Vector(2.8,10,-30),
			sounds = {
				On = {"trolleybus/aksm101ps/ladder_down.ogg",200},
				Off = {"trolleybus/aksm101ps/ladder_up.ogg",200},
			},
			maxdrawdistance = 1000,
			speedmult = 0.5,
		},
		panel = {
			name = "ladder",
			pos = {0,0},
			size = ENT.PanelsData["ladder"].size,
		},
		toggle = true,
	},
	["trapdoor1"] = {
		name = "trolleybus.aksm101ps.btns.trapdoor",
		model = model_trapdoor,
		panel = {
			name = "trapdoors",
			pos = {0,0},
			size = {ENT.PanelsData["trapdoors"].size[1],19},
		},
		toggle = true,
	},
	["trapdoor2"] = {
		name = "trolleybus.aksm101ps.btns.trapdoor",
		model = model_trapdoor,
		panel = {
			name = "trapdoors",
			pos = {0,54.5},
			size = {ENT.PanelsData["trapdoors"].size[1],19},
		},
		toggle = true,
	},
	["trapdoor_front"] = {
		name = "trolleybus.aksm101ps.btns.trapdoor_front",
		model = {
			model = "models/trolleybus/aksm101ps/route_trapdoor.mdl",
			anim = true,
			offset_ang = Angle(0,180,0),
			offset_pos = Vector(0,25,-9.6),
			maxdrawdistance = 500,
			speedmult = 0.25,
		},
		panel = {
			name = "trapdoor_front",
			pos = {0,0},
			size = ENT.PanelsData["trapdoor_front"].size,
		},
		toggle = true,
	},
}

local function CreatePedal(panel,x,y,brake)
	return {
		name = "",
		model = "models/trolleybus/aksm101ps/pedal.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = 0,
		},
		offset_ang = Angle(brake and -96 or -84,90,90),
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

local function CreateIndicatorLamp(name,panel,x,y,type,isactive,downed)
	local mdl =
		(type==0 or type==1) and "models/trolleybus/aksm101ps/dashboard_lamp.mdl" or
		type==2 and "models/trolleybus/aksm101ps/neon_lamp.mdl"
	
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
		offset_pos = type==2 and Vector(0,0.9,-0.45) or downed and Vector(-0.15,0,0) or nil,
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
		model = "models/trolleybus/aksm101ps/o-meter_square.mdl",
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
	end,"models/trolleybus/aksm101ps/manometer_arrow.mdl",Angle(90),Vector(0.5,0.95,-1.7),1,nil,1)
end

local function CreateManometer(index,name,panel,x,y,type)
	ENT.OtherPanelEntsData[index] = {
		name = name,
		model = "models/trolleybus/aksm101ps/o-meter.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = 2,
		},
		offset_ang = Angle(-90,0,180),
		think = type==1 and function(self,ent)
			local bg = self:ButtonIsDown("priborslight") and self:GetProfileLights() and 2 or 1
			
			if ent.bg!=bg then
				ent.bg = bg
				ent:SetBodygroup(1,bg)
			end
		end,
		maxdrawdistance = 200,
	}
	
	if type==0 or type==2 then
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,-42,function(self,ent)
			return !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(type==2 and 2 or 1)/1000*87
		end,"models/trolleybus/aksm101ps/manometer_arrow.mdl",Angle(90),Vector(0.35,0,1),1)
		
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow2","",panel,x,y,0,180+55,function(self,ent)
			return !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(type==2 and 2 or 1)/1000*-105
		end,"models/trolleybus/aksm101ps/manometer_arrow.mdl",Angle(90),Vector(0.35,0,-1.1),1)
	elseif type==1 then
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,-90-97,function(self,ent)
			return !self.SystemsLoaded and 0 or math.abs(self:GetSystem("Engine"):GetMoveSpeed())*-2.27
		end,"models/trolleybus/aksm101ps/speedometer_arrow.mdl",Angle(90),Vector(0.35,0,0),1)
	end
end

ENT.OtherPanelEntsData = {
	["door1opened"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.door1opened","rightprib",2.97,0.84,1,function(self,ent)
		return self:DoorIsOpened("door1",true)
	end),
	["door2opened"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.door2opened","rightprib",1.92,0.84,1,function(self,ent)
		return self:DoorIsOpened("door2",true)
	end),
	["door3opened"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.door3opened","rightprib",0.93,0.84,1,function(self,ent)
		return self:DoorIsOpened("door3",true)
	end),
	["powerlamp"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.powerlamp","prib",3.35,1.05,2,function(self,ent)
		return self:GetHighVoltage()>0
	end),
	["rkpos15"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.rkpos15","prib",11.35,5.68,0,function(self,ent)
		return self.SystemsLoaded and self:GetSystem("RKSU"):GetPosition()>=15
	end,true),
	["rkpos17"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.rkpos17","prib",12.33,5.68,0,function(self,ent)
		return self.SystemsLoaded and self:GetSystem("RKSU"):GetPosition()>=17
	end,true),
	["rkpos18"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.rkpos18","prib",13.31,5.68,0,function(self,ent)
		return self.SystemsLoaded and self:GetSystem("RKSU"):GetPosition()>=18
	end,true),
	["turnlightlamp"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.turnlightlamp","prib",17.16,1.28,1,function(self,ent)
		return (self:GetTurnSignal()!=0 or self:GetEmergencySignal()) and Trolleybus_System.TurnSignalTickActive(self)
	end,true),
	["handbrakelamp"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.handbrakelamp","prib",16.29,1.28,0,function(self,ent)
		return self:GetHandbrakeActive()
	end,true),
	["lowairlamp"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.lowairlamp","prib",18.08,1.28,0,function(self,ent)
		return self.SystemsLoaded and (self:GetSystem("Pneumatic"):GetAir(1)<400 or self:GetSystem("Pneumatic"):GetAir(2)<400)
	end,true),
	["leftpoleremovallamp"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.leftpoleremovallamp","leftprib",2.32,11.58,0,function(self,ent)
		return self:GetNWVar("PoleCatchingLeft")
	end),
	["rightpoleremovallamp"] = CreateIndicatorLamp("trolleybus.aksm101ps.lamps.rightpoleremovallamp","leftprib",3.33,11.58,0,function(self,ent)
		return self:GetNWVar("PoleCatchingRight")
	end),
	["startpedal"] = CreatePedal("pedals",14.3,3.3,false),
	["brakepedal"] = CreatePedal("pedals",1.9,3.3,true),
	["reverserbox"] = {
		name = "",
		model = "models/trolleybus/aksm101ps/reversorbox.mdl",
		panel = {
			name = "reverse",
			pos = {0,0},
			radius = 0,
		},
		offset_pos = Vector(-6.5,2,-4.4),
		offset_ang = Angle(0,90,0),
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

CreateVoltAmpMeter("akbvoltmeter","trolleybus.aksm101ps.arrows.akbvoltmeter","prib",0.68,0.15,1,0,50,function(self)
	return self:GetNWVar("LowVoltage",0)
end)
CreateVoltAmpMeter("akbampmeter","trolleybus.aksm101ps.arrows.akbampmeter","prib",0.67,3.15,0,-100,100,function(self)
	return !self.SystemsLoaded and 0 or -self:GetSystem("AccumulatorBattery"):GetLastAmperage()
end)
CreateVoltAmpMeter("engineampmeter","trolleybus.aksm101ps.arrows.engineampmeter","prib",3.2,2.72,2,-500,500,function(self)
	return !self.SystemsLoaded and 0 or -self:GetSystem("Engine"):GetAmperage()
end)

CreateManometer("speedometer","trolleybus.aksm101ps.arrows.speedometer","prib",17.2,4.14,1)
CreateManometer("manometer1","trolleybus.aksm101ps.arrows.manometer","prib",7.88,2.05,0)
CreateManometer("manometer2","trolleybus.aksm101ps.arrows.manometer","prib",12.38,2.05,2)

Trolleybus_System.BuildMultiButton(ENT,"poles_removal","leftprib","trolleybus.aksm101ps.btns.poles_removal_left","trolleybus.aksm101ps.btns.poles_removal_right",
model_switch,2.5,11.93,1,1,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,nil,nil,true,KEY_LBRACKET,KEY_RBRACKET)

Trolleybus_System.BuildMultiButton(ENT,"outsidedooropen","dooroutsideopen","trolleybus.aksm101ps.btns.outsidedooropen_left","trolleybus.aksm101ps.btns.outsidedooropen_right",
model_switch,0,0,1,1,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,function(self,on,state)
	if state==-1 then self:OpenDoor("door1") elseif state==1 then self:CloseDoor("door1") end
end,true,true)

Trolleybus_System.BuildMultiButton(ENT,"turnsignal","turnsignal","trolleybus.aksm101ps.btns.turnsignal_right","trolleybus.aksm101ps.btns.turnsignal_left",{
	model = "models/trolleybus/aksm101ps/guitar_turnsignal_lever.mdl",
	offset_ang = Angle(180,90,90),
	offset_pos = Vector(0,0,3),
	anim = true,
	maxdrawdistance = 200,
},0,0,3,6,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,nil,nil,false,KEY_H,KEY_G,nil,nil,"RightTurnSignal","LeftTurnSignal")

Trolleybus_System.BuildReverseButton(ENT,"reverse","reverse","trolleybus.aksm101ps.btns.reverse_left","trolleybus.aksm101ps.btns.reverse","trolleybus.aksm101ps.btns.reverse_right",{
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

Trolleybus_System.BuildMovingMirror(ENT,"mirror_left",Vector(193.34,45.62,21.47),Angle(0,-90,0),10,10,"models/trolleybus/aksm101ps/mirror_bracket.mdl",Vector(212.6,47.43,23.37),Angle(0,0,0.5),"Bone","Bone.001",Vector(-1.95,0.05,0.15),Angle(-0.1,181,0),5,9.5,false,true,0,90,-45,45,0,0,-15,15,mirror1verts,50,-35)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_right",Vector(215,-23.93,16),Angle(0,-180,0),10,10,"models/trolleybus/aksm101ps/mirror_bracket.mdl",Vector(212.6,-47.33,26.89),Angle(0,0,-1.5),"Bone","Bone.001",Vector(-2,0.05,0.15),Angle(-0.1,181,0),5,9.5,false,true,-90,0,-45,45,0,0,-15,15,mirror1verts,-40,10)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_middle",Vector(217.02,-5.65,18.33),Angle(0,-180,0),10,10,"models/trolleybus/aksm101ps/mirror_bracket_inside.mdl",Vector(213.47,-27,37.66),Angle(0,0,0),"Bone","Bone.001",Vector(-1.8,0,-0.9),Angle(0,180,0),13.5,6,false,true,0,0,-30,0,0,0,-20,20,mirror2verts,0,-30,0,-9)

function ENT:LoadSystems()
	self:LoadSystem("AccumulatorBattery",{Voltage = self.AccBatteryVoltage})
	self:LoadSystem("StaticVoltageConverter")
	self:LoadSystem("Pneumatic",{
		MotorCompressorSpeed = 30,
		MotorCompressorSounds = {
			StartSounds = Sound("trolleybus/aksm101ps/compressor_on_outside.ogg"),
			LoopSound = Sound("trolleybus/aksm101ps/compressor_outside.ogg"),
			EndSounds = Sound("trolleybus/aksm101ps/compressor_off_outside.ogg"),
			SndVolume = 0.75,
			
			InsideStartSounds = Sound("trolleybus/aksm101ps/compressor_on_inside.ogg"),
			InsideLoopSound = Sound("trolleybus/aksm101ps/compressor_inside.ogg"),
			InsideEndSounds = Sound("trolleybus/aksm101ps/compressor_off_inside.ogg"),
			InsideSndVolume = 0.75,
			
			SoundPos = Vector(-30,36,-34),
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
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				DefaultAir = 800,
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
	self:LoadSystem("Horn",{
		SoundPos = Vector(220,-1,-19),
		
		ShouldActive = function(sys) return self:ButtonIsDown("horn") end,
	})
	self:LoadSystem("IR-2002",{
		Pos = Vector(208.17,-4.64,-0.56),
		Ang = Angle(0,-180,0),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(198,11,-20),
	})
	self:LoadSystem("Handbrake",{
		PneumaticAirBrake = 50,
		GetAirFromSystem = function(s,air)
			local nair = math.min(self:GetSystem("Pneumatic"):GetAir(3),air)
			self:GetSystem("Pneumatic"):SetAir(3,self:GetSystem("Pneumatic"):GetAir(3)-nair)

			return nair
		end,
	})
	self:LoadSystem("Nameplates",{
		Types = {
			["default"] = {
				type = 0,
				width = 36,
				height = 8,
				model = {
					model = "models/trolleybus/routeplate.mdl",
					offset_pos = Vector(-0.25,18,-9),
					offset_ang = Angle(),
				},
				nfont = "Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.NameplateNumber",
				font = "Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.Nameplate",
				drawscale = 10,
			},
			["default2"] = {
				type = 1,
				width = 36,
				height = 8,
				model = {
					model = "models/trolleybus/routeplate.mdl",
					offset_pos = Vector(-0.25,18,-9),
					offset_ang = Angle(),
				},
				nfont = "Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.NameplateNumber",
				font = "Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.Nameplate",
				drawscale = 10,
			},
			["small"] = {
				type = 2,
				width = 11,
				height = 7,
				model = {
					model = "models/trolleybus/aksm101ps/routeplate_medium.mdl",
					offset_pos = Vector(-0.25,5.5,-7),
					offset_ang = Angle(),
					bg = "1",
				},
				nfont = "Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.RearNumber",
				drawscale = 8,
			},
		},
		Positions = {
			{
				pos = Vector(220.1,-18,47.43),
				ang = Angle(0,0,0),
				type = "default",
				shouldbeactive = function(sys,self) return self:ButtonIsDown("trapdoor_front") end,
				think = function(sys,self,ent) ent:SetSkin(self:GetScheduleLight()>0 and 1 or 0) end,
			},
			{
				pos = Vector(213.6,-39.5,9.1),
				ang = Angle(-3,0,0),
				type = "default2",
			},
			{
				pos = Vector(-107.4,-45.8,14.2),
				ang = Angle(-2,-90,0),
				type = "default",
			},
			{
				pos = Vector(-213.1,-18.5,11),
				ang = Angle(-2,-180,0),
				type = "small",
			},
		},
	})
end

ENT.SpawnSettings = {
	{
		alias = "pressure",
		type = "Slider",
		name = "trolleybus.aksm101ps.settings.pressure",
		min = 0,
		max = 8,
		default = 0,
		preview = {"trolleybus/spawnsettings_previews/aksm101ps/pressure",0,8},
	},
	{
		alias = "mainswitchdisabling",
		type = "CheckBox",
		name = "trolleybus.aksm101ps.settings.mainswitchdisabling",
		nopreview = true,
		default = true,
	},
	{
		alias = "moldings",
		type = "ComboBox",
		name = "trolleybus.aksm101ps.settings.moldings",
		default = 1,
		choices = {
			{name = "trolleybus.aksm101ps.settings.moldings.up_down",preview = "trolleybus/spawnsettings_previews/aksm101ps/moldings1.png"},
			{name = "trolleybus.aksm101ps.settings.moldings.up",preview = "trolleybus/spawnsettings_previews/aksm101ps/moldings2.png"},
			{name = "trolleybus.aksm101ps.settings.moldings.down",preview = "trolleybus/spawnsettings_previews/aksm101ps/moldings3.png"},
			{name = "trolleybus.aksm101ps.settings.moldings.none",preview = "trolleybus/spawnsettings_previews/aksm101ps/moldings4.png"},
		},
		setup = function(self,value)
			if SERVER then
				self:SetBodygroup(4,(value==1 or value==2) and 1 or 0)
				self:SetBodygroup(5,(value==1 or value==3) and 1 or 0)
			end
		end,
		unload = function(self,value)
			if SERVER then
				self:SetBodygroup(4,0)
				self:SetBodygroup(5,0)
			end
		end,
	},
	{
		alias = "logo",
		type = "CheckBox",
		name = "trolleybus.aksm101ps.settings.logo",
		default = true,
		preview_on = "trolleybus/spawnsettings_previews/aksm101ps/logo1.png",
		preview_off = "trolleybus/spawnsettings_previews/aksm101ps/logo2.png",
		setup = function(self,value)
			if SERVER then
				self:SetBodygroup(6,value and 1 or 0)
			end
		end,
		unload = function(self,value)
			if SERVER then
				self:SetBodygroup(6,0)
			end
		end,
	},
	{
		alias = "reductor",
		type = "ComboBox",
		name = "trolleybus.aksm101ps.settings.reductor",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm101ps.settings.reductor.raba018",preview = "trolleybus/spawnsettings_previews/aksm101ps/raba018.wav"},
			{name = "trolleybus.aksm101ps.settings.reductor.raba31877",preview = "trolleybus/spawnsettings_previews/aksm101ps/raba31877.wav"},
			{name = "trolleybus.aksm101ps.settings.reductor.raba318772",preview = "trolleybus/spawnsettings_previews/aksm101ps/raba318772.wav"},
			{name = "trolleybus.aksm101ps.settings.reductor.mzkt",preview = "trolleybus/spawnsettings_previews/aksm101ps/mzkt.wav"},
		},
		setup = function(self,value)
			local function Volume(self,ent)
				return !ent.SystemsLoaded and 0 or math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/300,0.1,1)
			end
		
			self:LoadSystem("Reductor",{
				SoundConfig = value==1 and {
					{sound = Sound("trolleybus/aksm101ps/reductor/raba_018_81/reductor.ogg"),pratemp = 1/1000,pratestart = 0,volume = Volume},
					{sound = Sound("trolleybus/aksm101ps/reductor/raba_018_81/background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
				} or value==2 and {
					{sound = Sound("trolleybus/aksm101ps/reductor/raba_318_77/reductor.ogg"),pratemp = 1/900,pratestart = 0,volume = Volume},
					{sound = Sound("trolleybus/aksm101ps/reductor/raba_318_77/background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
				} or value==3 and {
					{sound = Sound("trolleybus/aksm101ps/reductor/raba_318_77_2/reductor.ogg"),pratemp = 1/900,pratestart = 0,volume = Volume},
					{sound = Sound("trolleybus/aksm101ps/reductor/raba_318_77_2/background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
				} or {
					{sound = Sound("trolleybus/aksm101ps/reductor/mzkt/reductor.ogg"),pratemp = 1/900,pratestart = 0,volume = Volume},
					{sound = Sound("trolleybus/aksm101ps/reductor/mzkt/background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
				},
				
				SoundPos = Vector(-91,1,-35),
			})
			
			if SERVER then
				for k,v in ipairs(self.Wheels) do
					if !v.Drive then continue end
					
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(1,value==1 and 0 or (value==2 or value==3) and 1 or 2)
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
		name = "trolleybus.aksm101ps.settings.engine",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm101ps.settings.engine.dk213",preview = "trolleybus/spawnsettings_previews/aksm101ps/dk213.wav"},
			{name = "trolleybus.aksm101ps.settings.engine.dk210",preview = "trolleybus/spawnsettings_previews/aksm101ps/dk210.wav"},
		},
		setup = function(self,value)
			local sndcfg = value==1 and {
				{sound = Sound("trolleybus/aksm101ps/engine_dk213.ogg"),startspd = 600,fadein = 1000,pratemp = 1/1200,pratestart = 1,volume = 1},
			} or {
				{sound = Sound("trolleybus/aksm101ps/engine_dk210.ogg"),startspd = 500,fadein = 1000,pratemp = 1/1100,pratestart = 1,volume = 1.5},
			}
			
			self:LoadSystem("Engine",{
				SoundConfig = sndcfg,
				SoundPos = Vector(-27,-0,-38),
		
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
		name = "trolleybus.aksm101ps.settings.contactors",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm101ps.settings.contactors.type1",preview = "trolleybus/spawnsettings_previews/aksm101ps/contactors1.wav"},
			{name = "trolleybus.aksm101ps.settings.contactors.type2",preview = "trolleybus/spawnsettings_previews/aksm101ps/contactors2.wav"},
			{name = "trolleybus.aksm101ps.settings.contactors.type3",preview = "trolleybus/spawnsettings_previews/aksm101ps/contactors3.wav"},
			{name = "trolleybus.aksm101ps.settings.contactors.type4",preview = "trolleybus/spawnsettings_previews/aksm101ps/contactors4.wav"},
		},
		setup = function(self,value)
			self:LoadSystem("RKSU",{
				ContactorSoundPos = Vector(205,-14,-3),
				ContactorSoundVolume = 1,
				ContactorSounds = value==1 and {
					LK123 = {Sound("trolleybus/aksm101ps/contactors/1/lk123_on.ogg"),Sound("trolleybus/aksm101ps/contactors/1/lk123_off.ogg")},
					R = {Sound("trolleybus/aksm101ps/contactors/1/r_on.ogg")},
					T = {Sound("trolleybus/aksm101ps/contactors/1/t_on.ogg"),Sound("trolleybus/aksm101ps/contactors/1/t_off.ogg")},
				} or value==2 and {
					LK123 = {Sound("trolleybus/aksm101ps/contactors/2/lk123_on.ogg"),Sound("trolleybus/aksm101ps/contactors/2/lk123_off.ogg")},
					R = {Sound("trolleybus/aksm101ps/contactors/2/r_on.ogg")},
					T = {Sound("trolleybus/aksm101ps/contactors/2/t_on.ogg"),Sound("trolleybus/aksm101ps/contactors/2/t_off.ogg")},
				} or value==3 and {
					LK123 = {Sound("trolleybus/aksm101ps/contactors/3/lk123_on.ogg"),Sound("trolleybus/aksm101ps/contactors/3/lk123_off.ogg")},
					R = {Sound("trolleybus/aksm101ps/contactors/3/r_on.ogg")},
					T = {Sound("trolleybus/aksm101ps/contactors/3/t_on.ogg"),Sound("trolleybus/aksm101ps/contactors/3/t_off.ogg")},
				} or {
					LK123 = {Sound("trolleybus/aksm101ps/contactors/4/lk123_on.ogg"),Sound("trolleybus/aksm101ps/contactors/4/lk123_off.ogg")},
					R = {Sound("trolleybus/aksm101ps/contactors/4/r_on.ogg")},
					T = {Sound("trolleybus/aksm101ps/contactors/4/t_on.ogg"),Sound("trolleybus/aksm101ps/contactors/4/t_off.ogg")},
				},
				
				RCSoundPos = Vector(111,-0,56),
				RCSounds = {
					StartSoundsCool = Sound("trolleybus/aksm101ps/grk_up_start.ogg"),
					LoopSoundCool = Sound("trolleybus/aksm101ps/grk_up_loop.ogg"),
					StopSoundsCool = Sound("trolleybus/aksm101ps/grk_stop.ogg"),
					
					StartSoundsUncool = {},
					LoopSoundUncool = Sound("trolleybus/aksm101ps/grk_sbros_loop.ogg"),
					StopSoundsUncool = Sound("trolleybus/aksm101ps/grk_stop.ogg"),
				},
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("RKSU")
		end,
	},
	{
		alias = "buzzer",
		type = "ComboBox",
		name = "trolleybus.aksm101ps.settings.buzzer",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm101ps.settings.buzzer.type1",preview = "trolleybus/spawnsettings_previews/aksm101ps/buzzer1.wav"},
			{name = "trolleybus.aksm101ps.settings.buzzer.type2",preview = "trolleybus/spawnsettings_previews/aksm101ps/buzzer2.wav"},
		},
		setup = function(self,value)
			self:LoadSystem("Buzzer",{
				SoundPos = Vector(207,28,0),
				
				LoopSound = value==1 and Sound("trolleybus/aksm101ps/buzzer/1/buzzer.ogg") or Sound("trolleybus/aksm101ps/buzzer/2/buzzer.ogg"),
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("Buzzer")
		end,
	},
	{
		alias = "hydrobooster",
		type = "ComboBox",
		name = "trolleybus.aksm101ps.settings.hydrobooster",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm101ps.settings.hydrobooster.type1",preview = "trolleybus/spawnsettings_previews/aksm101ps/hydrobooster1.wav"},
			{name = "trolleybus.aksm101ps.settings.hydrobooster.type2",preview = "trolleybus/spawnsettings_previews/aksm101ps/hydrobooster2.wav"},
			{name = "trolleybus.aksm101ps.settings.hydrobooster.type3",preview = "trolleybus/spawnsettings_previews/aksm101ps/hydrobooster3.wav"},
		},
		setup = function(self,value)
			self:LoadSystem("HydraulicBooster",{
				SoundPos = Vector(178,42,-32),
				
				StartSounds =
					value==1 and Sound("trolleybus/aksm101ps/hydrobooster/1/on.ogg") or
					value==2 and Sound("trolleybus/aksm101ps/hydrobooster/2/on.ogg") or
					Sound("trolleybus/aksm101ps/hydrobooster/3/on.ogg"),
				
				LoopSound =
					value==1 and Sound("trolleybus/aksm101ps/hydrobooster/1/loop.ogg") or
					value==2 and Sound("trolleybus/aksm101ps/hydrobooster/2/loop.ogg") or
					Sound("trolleybus/aksm101ps/hydrobooster/3/loop.ogg"),
				
				StopSounds =
					value==1 and Sound("trolleybus/aksm101ps/hydrobooster/1/off.ogg") or
					value==2 and Sound("trolleybus/aksm101ps/hydrobooster/2/off.ogg") or
					Sound("trolleybus/aksm101ps/hydrobooster/3/off.ogg"),
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("HydraulicBooster")
		end,
	},
	{
		alias = "steer",
		type = "ComboBox",
		name = "trolleybus.aksm101ps.settings.steer",
		default = 1,
		choices = {
			{name = "trolleybus.aksm101ps.settings.steer.type1",preview = "trolleybus/spawnsettings_previews/aksm101ps/steer1.png"},
			{name = "trolleybus.aksm101ps.settings.steer.type2",preview = "trolleybus/spawnsettings_previews/aksm101ps/steer2.png"},
		},
		setup = function(self,value)
			if CLIENT then
				self.SteerData = value==1 and self.SteerData1 or self.SteerData2
			end
		end,
		unload = function(self,value)
			if CLIENT then
				self.SteerData = self.SteerData1
			end
		end,
	},
	{
		alias = "wedge",
		type = "ComboBox",
		name = "trolleybus.aksm101ps.settings.wedge",
		default = 2,
		choices = {
			{name = "trolleybus.aksm101ps.settings.wedge.type1",preview = "trolleybus/spawnsettings_previews/aksm101ps/wedge1.png"},
			{name = "trolleybus.aksm101ps.settings.wedge.type2",preview = "trolleybus/spawnsettings_previews/aksm101ps/wedge2.png"},
		},
		setup = function(self,value)
			if SERVER then
				for k,v in ipairs(self.Wheels) do
					if v.Drive then continue end
					
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(1,value==2 and 1 or 0)
					end
				end
			end
		end,
		unload = function(self,value)
			if SERVER then
				for k,v in ipairs(self.Wheels) do
					if v.Drive then continue end
					
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(1,0)
					end
				end
			end
		end,
	},
	Trolleybus_System.BuildSkinSpawnSetting("aksm101ps","trolleybus.aksm101ps.settings.skins"),
}