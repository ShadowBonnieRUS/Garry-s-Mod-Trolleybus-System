-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "ZiU 6205"
ENT.Category = {"creationtab_category.default","creationtab_category.default.ziu","creationtab_category.default.ziu10"}

Trolleybus_System.WheelTypes["ziu6205"] = {
	Model = "models/trolleybus/ziu6205/wheel_front.mdl",
	Ang = Angle(0,90,0),
	Radius = 20.3,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["ziu6205_rear"] = {
	Model = "models/trolleybus/ziu6205/wheel_rear.mdl",
	Ang = Angle(0,90,0),
	Radius = 20.3,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/ziu6205/body.mdl"

ENT.HasPoles = false
ENT.PassCapacity = 100
ENT.AccBatteryVoltage = 20

ENT.OtherSeats = {
	{
		Type = 1,
		Pos = Vector(155.4,3.4,-28.08),
		Ang = Angle(0,0,0),
		Camera = Vector(155.4,3.4,32),
	},
}

ENT.InteriorLights = {
	{pos = Vector(38,0,26),size = 300,style = 0,brightness = 3,color = Color(255,140,32)},
	{pos = Vector(-146,0,26),size = 300,style = 0,brightness = 3,color = Color(255,140,32)},
}

ENT.DoorsData = {
	["door1"] = {
		model = "models/trolleybus/ziu6205/door_body_first.mdl",
		pos = Vector(146.68,-45.12,-1.3),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		movehandsound = {"trolleybus/ziu682v013/open_door_hand.ogg",200},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
	},
	["door2"] = {
		model = "models/trolleybus/ziu6205/door_body_second.mdl",
		pos = Vector(-10.21,-44.5,1.55),
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

ENT.DriverSeatData = {
	Type = 0,
	Pos = Vector(145,28,-13),
	Ang = Angle(),
}

ENT.TrailerData1 = {
	class = "trolleybus_ent_ziu6205_trailer",
	pos = Vector(-339.5,0,0),
	ang = Angle(),
	ballsocket = {
		lpos = Vector(-177,0,-29),
		trailerlpos = Vector(120,0,-29),
		plimits = {-10,10},
		ylimits = {-40,40},
		rlimits = {-10,10},
	},
	joint = {
		model = "models/trolleybus/ziu6205/joint.mdl",
		pos = Vector(-177.53,0,2.4),
		ang = Angle(0,180,0),
		bone = "Bone_1",
		trailerpos = Vector(119.94,0,2.4),
		trailerang = Angle(0,0,0),
		trailerbone = "Bone_2",
		creaksound = Sound("trolleybus/ziu6205/joint_creak.ogg"),
	},
}
ENT.TrailerData = ENT.TrailerData1

ENT.TrailerData2 = table.Merge(table.Copy(ENT.TrailerData1),{joint = {model = "models/trolleybus/ziu6205/joint_old.mdl"}})

local model_switch = {
	model = "models/trolleybus/ziu6205/toggle.mdl",
	offset_ang = Angle(0,-90,-90),
	offset_pos = Vector(-0.2,0,0),
	sounds = {
		On = {"trolleybus/ziu6205/switch_on.ogg",100},
		Off = {"trolleybus/ziu6205/switch_off.ogg",100},
	},
	anim = true,
	maxdrawdistance = 200,
}

local model_switch2 = {
	model = "models/trolleybus/ziu6205/toggle.mdl",
	offset_ang = Angle(-90,0,180),
	offset_pos = Vector(-0.2,0,0),
	sounds = {
		On = {"trolleybus/ziu6205/switch_on.ogg",100},
		Off = {"trolleybus/ziu6205/switch_off.ogg",100},
	},
	anim = true,
	maxdrawdistance = 200,
}

local model_vu = {
	model = "models/trolleybus/ziu6205/vu22.mdl",
	offset_pos = Vector(0,1.85,-2.4),
	offset_ang = Angle(0,90,0),
	sounds = {
		On = {"trolleybus/ziu6205/vu_on.ogg",100},
		Off = {"trolleybus/ziu6205/vu_off.ogg",100},
	},
	anim = true,
	maxdrawdistance = 200,
}

local model_akb = {
	model = "models/trolleybus/ziu6205/akb_toggle.mdl",
	offset_pos = Vector(-1,0,0),
	offset_ang = Angle(0,90,0),
	sounds = {
		On = {"trolleybus/ziu6205/akb_on.ogg",100},
		Off = {"trolleybus/ziu6205/akb_off.ogg",100},
	},
	anim = true,
	maxdrawdistance = 200,
}

local model_trapdoor = {
	model = "models/trolleybus/ziu6205/trapdoor.mdl",
	anim = true,
	offset_ang = Angle(-90,0,0),
	offset_pos = Vector(-2,21,-19.4),
	sounds = {
		On = {"trolleybus/ziu6205/trapdoor_open.ogg",200},
		Off = {"trolleybus/ziu6205/trapdoor_close.ogg",200},
	},
	maxdrawdistance = 1000,
	speedmult = 0.5,
}

local model_mainswitch = {
	model = "models/trolleybus/ziu6205/av8a.mdl",
	offset_ang = Angle(0,0,0),
	offset_pos = Vector(0,5,-5),
	sounds = {
		On = {"trolleybus/ziu6205/av8a_on.ogg",100},
		Off = {"trolleybus/ziu6205/av8a_off.ogg",100},
	},
	anim = true,
	maxdrawdistance = 500,
}

local model_wipersbtn = {
	model = "models/trolleybus/ziu6205/square_button.mdl",
	offset_ang = Angle(-90,0,180),
	offset_pos = Vector(-0.3,0.4,-0.5),
	sounds = {
		On = {"trolleybus/tumbler_on.mp3",100},
		Off = {"trolleybus/tumbler_off.mp3",100},
	},
	anim = true,
	maxdrawdistance = 200,
}

ENT.PanelsData = {
	["leftprib"] = {
		pos = Vector(170.57,44.63,5.24),
		ang = Angle(-76.2,-180,0),
		size = {5,15},
	},
	["rightprib"] = {
		pos = Vector(170.27,17.15,5.1),
		ang = Angle(-52.7,-180,0),
		size = {10,4},
	},
	["rightprib2"] = {
		pos = Vector(175.9,17.15,5.3),
		ang = Angle(-90,-180,0),
		size = {10,5},
	},
	["prib"] = {
		pos = Vector(175.82,39.26,5.1),
		ang = Angle(-35.2,-180,0),
		size = {20,7},
	},
	["hydroakb"] = {
		pos = Vector(159.94,40.45,-7.18),
		ang = Angle(0,-90,0),
		size = {4,10},
	},
	["vu"] = {
		pos = Vector(131.86,21.07,23.09),
		ang = Angle(0,0,0),
		size = {17,7},
	},
	["mainswitch"] = {
		pos = Vector(131.44,19.49,43.74),
		ang = Angle(0,0,0),
		size = {25,15},
	},
	["pedals"] = {
		pos = Vector(175,36.46,-21.54),
		ang = Angle(-80.1,-180,0),
		size = {16,10},
	},
	["driverdoor"] = {
		pos = Vector(161.6,-22.96,16.41),
		ang = Angle(0,36,0),
		size = {50,40},
	},
	["handdooropen"] = {
		pos = Vector(131.48,-45.61,32.77),
		ang = Angle(0,-90,0),
		size = {30,75},
	},
	["fronttrapdoor"] = {
		pos = Vector(178.56,21.97,46.42),
		ang = Angle(28.3,-180,0),
		size = {45,11},
	},
	["trapdoors"] = {
		pos = Vector(74,-21,47),
		ang = Angle(90,0,0),
		size = {42,187},
	},
	["turnsignal"] = {
		pos = Vector(166.97,30.62,3.32),
		ang = Angle(-80,-180,-90),
		size = {4,6},
	},
	["headlightshorn"] = {
		pos = Vector(163.99,21.33,2.91),
		ang = Angle(-100,0,-90),
		size = {3,2},
	},
	["reverse"] = {
		pos = Vector(133.33,20.67,-21.25),
		ang = Angle(0,-90,0),
		size = {4,4},
	},
	["polarity"] = {
		pos = Vector(134.78,20.8,-1.19),
		ang = Angle(0,-90,-90),
		size = {4,4},
	},
	["outsidedooropen"] = {
		pos = Vector(170.84,-47.17,-12.91),
		ang = Angle(0,-90,0),
		size = {1,1},
	},
	["handbrake"] = {
		pos = Vector(142.11,37.8,-2.46),
		ang = Angle(0,-90,0),
		size = {15,15},
	},
}

ENT.ButtonsData = {
	["vu"] = {
		name = "trolleybus.ziu6205.btns.vu",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3.43,8.41},
			radius = 0.5,
		},
		toggle = true,
	},
	["compressor"] = {
		name = "trolleybus.ziu6205.btns.compressor",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3.43,7.2},
			radius = 0.5,
		},
		toggle = true,
	},
	["buzzer"] = {
		name = "trolleybus.ziu6205.btns.buzzer",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3.43,5.97},
			radius = 0.5,
		},
		toggle = true,
	},
	["roadtrainlights"] = {
		name = "trolleybus.ziu6205.btns.roadtrainlights",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3.43,4.77},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabineheater1"] = {
		name = "trolleybus.ziu6205.btns.cabineheater1",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3.43,3.62},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabineheater2"] = {
		name = "trolleybus.ziu6205.btns.cabineheater2",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3.43,2.53},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabineheatervent"] = {
		name = "trolleybus.ziu6205.btns.cabineheatervent",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {3.43,1.55},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorlight1"] = {
		name = "trolleybus.ziu6205.btns.interiorlight1",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,9.65},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorlight2"] = {
		name = "trolleybus.ziu6205.btns.interiorlight2",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,8.41},
			radius = 0.5,
		},
		toggle = true,
	},
	["cabinelight"] = {
		name = "trolleybus.ziu6205.btns.cabinelight",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,7.2},
			radius = 0.5,
		},
		toggle = true,
	},
	["profilelightstop"] = {
		name = "trolleybus.ziu6205.btns.profilelightstop",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,5.97},
			radius = 0.5,
		},
		toggle = true,
	},
	["profilelightsbottom"] = {
		name = "trolleybus.ziu6205.btns.profilelightsbottom",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,4.77},
			radius = 0.5,
		},
		toggle = true,
	},
	["doorlights"] = {
		name = "trolleybus.ziu6205.btns.doorlights",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,3.62},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorheater"] = {
		name = "trolleybus.ziu6205.btns.interiorheater",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,2.53},
			radius = 0.5,
		},
		toggle = true,
	},
	["interiorheatervent"] = {
		name = "trolleybus.ziu6205.btns.interiorheatervent",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.54,1.55},
			radius = 0.5,
		},
		toggle = true,
	},
	["akb"] = {
		name = "trolleybus.ziu6205.btns.akb",
		model = model_akb,
		panel = {
			name = "hydroakb",
			pos = {2,7.63},
			radius = 2,
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["hydrobooster"] = {
		name = "trolleybus.ziu6205.btns.hydrobooster",
		model = model_akb,
		panel = {
			name = "hydroakb",
			pos = {2,2.59},
			radius = 2,
		},
		toggle = true,
	},
	["opendoor1"] = {
		name = "trolleybus.ziu6205.btns.opendoor1",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {2.7,2.24},
			radius = 0.5,
		},
		hotkey = KEY_1,
		toggle = true,
		func = function(self,on) if on then self:OpenDoor("door1") else self:CloseDoor("door1") end end,
	},
	["opendoor2"] = {
		name = "trolleybus.ziu6205.btns.opendoor2",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {3.68,2.24},
			radius = 0.5,
		},
		hotkey = KEY_2,
		toggle = true,
		func = function(self,on) if on then self:OpenDoor("door2") else self:CloseDoor("door2") end end,
	},
	["opendoor3"] = {
		name = "trolleybus.ziu6205.btns.opendoor3",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {4.78,2.24},
			radius = 0.5,
		},
		hotkey = KEY_3,
		toggle = true,
		func = function(self,on) if on then self:GetTrailer():OpenDoor("door3") else self:GetTrailer():CloseDoor("door3") end end,
	},
	["opendoor4"] = {
		name = "trolleybus.ziu6205.btns.opendoor4",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {5.81,2.24},
			radius = 0.5,
		},
		hotkey = KEY_4,
		toggle = true,
		func = function(self,on) if on then self:GetTrailer():OpenDoor("door4") else self:GetTrailer():CloseDoor("door4") end end,
	},
	["toggledoors"] = {
		name = "trolleybus.ziu6205.btns.toggledoors",
		model = model_switch2,
		panel = {
			name = "rightprib",
			pos = {1.57,2.24},
			radius = 0.5,
		},
		hotkey = KEY_5,
		func = function(self,on)
			if on then
				if self:DoorIsOpened("door1") then self:CloseDoor("door1") else self:OpenDoor("door1") end
				if self:DoorIsOpened("door2") then self:CloseDoor("door2") else self:OpenDoor("door2") end
				if self:GetTrailer():DoorIsOpened("door3") then self:GetTrailer():CloseDoor("door3") else self:GetTrailer():OpenDoor("door3") end
				if self:GetTrailer():DoorIsOpened("door4") then self:GetTrailer():CloseDoor("door4") else self:GetTrailer():OpenDoor("door4") end
			end
		end
	},
	["emergency"] = {
		name = "trolleybus.ziu6205.btns.emergency",
		model = {
			model = "models/trolleybus/ziu6205/emergency_button.mdl",
			anim = true,
			offset_ang = Angle(90,0,0),
			offset_pos = Vector(0,0,0),
			maxdrawdistance = 200,
			think = function(self,ent)
				ent:SetSkin(self:GetNWVar("LowPower") and self:ButtonIsDown("emergency") and Trolleybus_System.TurnSignalTickActive(self) and 1 or 0)
			end,
		},
		panel = {
			name = "rightprib2",
			pos = {8.3,1.88},
			radius = 0.75,
		},
		hotkey = KEY_B,
		externalhotkey = "Emergency",
		toggle = true,
	},
	["ppn"] = {
		name = "trolleybus.ziu6205.btns.vpn",
		model = {
			model = "models/trolleybus/ziu6205/bpn_button.mdl",
			anim = true,
			offset_ang = Angle(90,0,0),
			offset_pos = Vector(0,0,0),
			maxdrawdistance = 200,
		},
		panel = {
			name = "rightprib2",
			pos = {5.51,1.88},
			radius = 0.75,
		},
		func = function(self,on)
			if on then
				self:SetNWVar("PPNActive",!self:GetNWVar("PPNActive",false))
				self:GetSystem("TISU"):SetTISUBlockActive(self:GetNWVar("PPNActive",false))
			end
		end,
	},
	["trailerakb"] = {
		name = "trolleybus.ziu6205.btns.trailerakb",
		model = model_switch2,
		panel = {
			name = "rightprib2",
			pos = {4.17,3.7},
			radius = 0.5,
		},
		toggle = true,
		func = function(self,on) self:GetTrailer():GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["trailermotorvent"] = {
		name = "trolleybus.ziu6205.btns.trailermotorvent",
		model = model_switch2,
		panel = {
			name = "rightprib2",
			pos = {5.12,3.7},
			radius = 0.5,
		},
		toggle = true,
	},
	["switchpassleft"] = {
		name = "trolleybus.ziu6205.btns.switchpassleft",
		model = model_switch2,
		panel = {
			name = "rightprib2",
			pos = {6.12,3.7},
			radius = 0.5,
		},
		hotkey = KEY_COMMA,
	},
	["switchpassright"] = {
		name = "trolleybus.ziu6205.btns.switchpassright",
		model = model_switch2,
		panel = {
			name = "rightprib2",
			pos = {7.22,3.7},
			radius = 0.5,
		},
		hotkey = KEY_PERIOD,
	},
	["tisudiagnostic"] = {
		name = "trolleybus.ziu6205.btns.tisudiagnostic",
		model = model_switch2,
		panel = {
			name = "rightprib2",
			pos = {8.27,3.7},
			radius = 0.5,
		},
	},
	["motorvent1"] = {
		name = "trolleybus.ziu6205.btns.motorvent1",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {0.5,0},
			size = {3.5,6},
		},
		toggle = true,
	},
	["interiorheaterpower"] = {
		name = "trolleybus.ziu6205.btns.interiorheaterpower",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {4.6,0},
			size = {3.5,6},
		},
		toggle = true,
	},
	["compressorpower"] = {
		name = "trolleybus.ziu6205.btns.compressorpower",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {8.8,0},
			size = {3.5,6},
		},
		toggle = true,
	},
	["motorvent2"] = {
		name = "trolleybus.ziu6205.btns.motorvent2",
		model = model_vu,
		panel = {
			name = "vu",
			pos = {13,0},
			size = {3.5,6},
		},
		toggle = true,
	},
	["mainswitch1"] = {
		name = "trolleybus.ziu6205.btns.mainswitch1",
		model = model_mainswitch,
		panel = {
			name = "mainswitch",
			pos = {14,3.5},
			size = {10,13},
		},
		toggle = true,
	},
	["mainswitch2"] = {
		name = "trolleybus.ziu6205.btns.mainswitch2",
		model = model_mainswitch,
		panel = {
			name = "mainswitch",
			pos = {2,0},
			size = {10,13},
		},
		toggle = true,
	},
	["polecatchers_control"] = {
		name = "trolleybus.ziu6205.btns.polecatchers_control",
		model = model_switch,
		panel = {
			name = "leftprib",
			pos = {1.73,12.47},
			radius = 0.5,
		},
		toggle = true,
	},
	["leftwiper"] = {
		name = "trolleybus.ziu6205.btns.leftwiper",
		model = model_wipersbtn,
		panel = {
			name = "rightprib2",
			pos = {1.1,1.5},
			size = {0.7,1.2},
		},
		toggle = true,
	},
	["rightwiper"] = {
		name = "trolleybus.ziu6205.btns.rightwiper",
		model = model_wipersbtn,
		panel = {
			name = "rightprib2",
			pos = {2.16,1.5},
			size = {0.7,1.2},
		},
		toggle = true,
	},
	["driverdoor"] = {
		name = "trolleybus.ziu6205.btns.driverdoor",
		model = {
			model = "models/trolleybus/ziu6205/cabin_door.mdl",
			offset_ang = Angle(0,0,0),
			offset_pos = Vector(0.5,13,1.7),
			sounds = {
				On = {"trolleybus/ziu6205/cabine_door_open.ogg",200},
				Off = {"trolleybus/ziu6205/cabine_door_close.ogg",200},
			},
			anim = true,
			maxdrawdistance = 1000,
			speedmult = 0.5,
		},
		panel = {
			name = "driverdoor",
			pos = {0,0},
			size = ENT.PanelsData["driverdoor"].size,
		},
		toggle = true,
	},
	["handdooropen"] = {
		name = "trolleybus.ziu6205.btns.handdooropen",
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
	["trapdoor1"] = {
		name = "trolleybus.ziu6205.btns.trapdoor",
		model = model_trapdoor,
		panel = {
			name = "trapdoors",
			pos = {0,0},
			size = {ENT.PanelsData["trapdoors"].size[1],18},
		},
		toggle = true,
	},
	["trapdoor2"] = {
		name = "trolleybus.ziu6205.btns.trapdoor",
		model = model_trapdoor,
		panel = {
			name = "trapdoors",
			pos = {0,169},
			size = {ENT.PanelsData["trapdoors"].size[1],18},
		},
		toggle = true,
	},
	["fronttrapdoor"] = {
		name = "trolleybus.ziu6205.btns.fronttrapdoor",
		model = {
			model = "models/trolleybus/ziu6205/route_trapdoor.mdl",
			anim = true,
			offset_ang = Angle(28,180,0),
			offset_pos = Vector(0.2,21.97,0.3),
			maxdrawdistance = 1000,
			speedmult = 0.25,
		},
		panel = {
			name = "fronttrapdoor",
			pos = {0,0},
			size = ENT.PanelsData["fronttrapdoor"].size,
		},
		toggle = true,
	},
	["handbrake"] = {
		name = "trolleybus.ziu6205.btns.handbrake",
		model = {
			model = "models/trolleybus/ziu6205/handbrake.mdl",
			offset_ang = Angle(0,90,0),
			offset_pos = Vector(0,9,-20),
			sounds = {
				On = {"trolleybus/ziu6205/handbrake_on.ogg",100},
				Off = {"trolleybus/ziu6205/handbrake_off.ogg",100},
			},
			anim = true,
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
		func = function(self,on) self:SetHandbrakeActive(on) self:GetSystem("Handbrake"):SetActive(on) end,
	},
	["headlights"] = {
		name = "trolleybus.ziu6205.btns.headlights",
		model = {
			model = "models/trolleybus/ziu6205/guitar_light_button.mdl",
			offset_ang = Angle(0,100,90),
			offset_pos = Vector(0,1.5,0),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "headlightshorn",
			pos = {0,0},
			size = {ENT.PanelsData["headlightshorn"].size[1],1},
		},
		hotkey = KEY_F,
		toggle = true,
	},
	["horn"] = {
		name = "trolleybus.ziu6205.btns.horn",
		model = {
			model = "models/trolleybus/ziu6205/horn_button.mdl",
			offset_ang = Angle(0,0,90),
			offset_pos = Vector(0,1.5,0),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "headlightshorn",
			pos = {0,1},
			size = {ENT.PanelsData["headlightshorn"].size[1],1},
		},
		hotkey = KEY_T,
		externalhotkey = "Horn",
	},
	["akbvoltmeterchange"] = {
		name = "trolleybus.ziu6205.btns.akbvoltmeterchange",
		model = model_switch,
		panel = {
			name = "prib",
			pos = {3.03,1.84},
			radius = 0.5,
		},
		toggle = true,
	},
	["akbampermeterchange"] = {
		name = "trolleybus.ziu6205.btns.akbampermeterchange",
		model = model_switch,
		panel = {
			name = "prib",
			pos = {5.71,1.84},
			radius = 0.5,
		},
		toggle = true,
	},
	["priborslight"] = {
		name = "trolleybus.ziu6205.btns.priborslight",
		model = {
			model = "models/trolleybus/ziu6205/headlight_twister.mdl",
			offset_ang = Angle(90,0,0),
			offset_pos = Vector(0,0,0),
			anim = true,
			maxdrawdistance = 200,
		},
		panel = {
			name = "rightprib",
			pos = {8.05,1.98},
			radius = 0.75,
		},
		toggle = true,
	},
}

local function CreateIndicatorLamp(name,panel,x,y,type,isactive,downed,trailerakb)
	local mdl =
		(type==0 or type==1) and "models/trolleybus/ziu6205/dashboard_lamp.mdl" or
		type==2 and "models/trolleybus/ziu6205/neon_lamp.mdl"
	
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
			local skin = isactive(self,ent) and (type==2 or Either(trailerakb,IsValid(self:GetTrailer()) and self:GetTrailer():GetNWVar("LowPower"),self:GetNWVar("LowPower"))) and 1 or 0
			
			if ent:GetSkin()!=skin then ent:SetSkin(skin) end
		end,
		maxdrawdistance = 200,
	}
end

local function CreateVoltAmpMeter(index,name,panel,x,y,min,max,getcur)	
	Trolleybus_System.BuildDialGauge(ENT,index,name,panel,x,y,1.2,-130,function(self,ent)
		return (getcur(self)-min)/(max-min)*-100
	end,"models/trolleybus/ziu6205/small_arrow.mdl",nil,Vector(0.2,0,-0.4),nil,nil,1)
end

local function CreateManometer(index,name,panel,x,y,type)
	ENT.OtherPanelEntsData[index] = {
		name = name,
		model = type==1 and "models/trolleybus/ziu6205/speedometer.mdl" or "models/trolleybus/ziu6205/manometer.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = type==1 and 2 or 1,
		},
		offset_ang = Angle(0,90,90),
		think = function(self,ent)
			local skin = self:GetNWVar("PribLights") and 1 or 0
			
			if ent.skin!=skin then
				ent.skin = skin
				ent:SetSkin(skin)
			end
		end,
		maxdrawdistance = 200,
	}
	
	if type==0 or type==2 then
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,120,function(self,ent)
			return !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(type==2 and 2 or 1)/1000*-255
		end,"models/trolleybus/ziu6205/arrow.mdl",nil,Vector(0.15))
		
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow2","",panel,x,y,0,120,function(self,ent)
			return !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(type==2 and 2 or 1)/1000*-255
		end,"models/trolleybus/ziu6205/arrow.mdl",nil,Vector(0.17),nil,nil,nil,"1")
	elseif type==1 then
		Trolleybus_System.BuildDialGauge(ENT,index.."_arrow","",panel,x,y,0,-159,function(self,ent)
			return !self.SystemsLoaded and 0 or math.abs(self:GetSystem("Engine"):GetMoveSpeed())*-2.35
		end,"models/trolleybus/ziu6205/speedometer_arrow.mdl",nil,Vector(0.45))
	end
end

local function CreatePedal(panel,x,y,brake)
	return {
		name = "",
		model = "models/trolleybus/ziu6205/pedal.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = 0,
		},
		offset_ang = Angle(-90+(brake and -7 or 7),90,90),
		offset_pos = Vector(0,0,2),
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
	["startpedal"] = CreatePedal("pedals",14.3,5.12,false),
	["brakepedal"] = CreatePedal("pedals",1.9,5.25,true),
	["powerlamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.powerlamp","prib",10.7,5.26,2,function(self,ent)
		return self:GetNWVar("PowerLamp",false)
	end),
	["door1opened"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.door1opened","rightprib",2.67,1.04,1,function(self,ent)
		return self:DoorIsOpened("door1",true)
	end),
	["door2opened"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.door2opened","rightprib",3.69,1.04,1,function(self,ent)
		return self:DoorIsOpened("door2",true)
	end),
	["door3opened"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.door3opened","rightprib",4.75,1.04,1,function(self,ent)
		return IsValid(self:GetTrailer()) and self:GetTrailer():DoorIsOpened("door3",true)
	end),
	["door4opened"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.door4opened","rightprib",5.81,1.04,1,function(self,ent)
		return IsValid(self:GetTrailer()) and self:GetTrailer():DoorIsOpened("door4",true)
	end),
	["handbrakelamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.handbrakelamp","prib",14.19,1.68,0,function(self,ent)
		return self:GetHandbrakeActive()
	end,true),
	["turnlightlamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.turnlightlamp","prib",15.11,1.68,1,function(self,ent)
		return (self:GetTurnSignal()!=0 or self:GetEmergencySignal()) and Trolleybus_System.TurnSignalTickActive(self)
	end,true),
	["lowairlamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.lowairlamp","prib",16.01,1.68,0,function(self,ent)
		return self.SystemsLoaded and (self:GetSystem("Pneumatic"):GetAir(1)<400 or self:GetSystem("Pneumatic"):GetAir(2)<400)
	end,true),
	["ppnactivelamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.ppnactivelamp","prib",2.49,6.07,1,function(self,ent)
		return self:GetNWVar("PPNActiveLamp",false)
	end,true),
	["vpnactivelamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.vpnactivelamp","prib",3.52,6.07,1,function(self,ent)
		return self:GetNWVar("PPNActiveLamp",false)
	end,true),
	["start23lamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.start23lamp","prib",5.39,6.07,0,function(self,ent)
		return self:GetStartPedal()>1
	end,true),
	["noeleclamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.noeleclamp","prib",6.33,6.07,0,function(self,ent)
		return self:GetHighVoltage()<350 or self:GetPowerFromCN()<=0
	end,true),
	["diagfaillamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.diagfaillamp","prib",7.33,6.07,0,function(self,ent)
		return false
	end,true),
	["accmainlamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.accmainlamp","prib",8.26,1.68,0,function(self,ent)
		return self.SystemsLoaded and self:GetSystem("AccumulatorBattery"):IsActive()
	end,true),
	["acctrailerlamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.acctrailerlamp","prib",9.18,1.68,0,function(self,ent)
		self = self:GetTrailer()
		return IsValid(self) and self.SystemsLoaded and self:GetSystem("AccumulatorBattery"):IsActive()
	end,true,true),
	["leftpoleremovallamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.leftpoleremovallamp","leftprib",2.74,11.56,0,function(self,ent)
		return self:GetNWVar("PoleCatchingLeft")
	end),
	["rightpoleremovallamp"] = CreateIndicatorLamp("trolleybus.ziu6205.lamps.rightpoleremovallamp","leftprib",3.74,11.56,0,function(self,ent)
		return self:GetNWVar("PoleCatchingRight")
	end),
}

CreateVoltAmpMeter("akbvoltmeter","trolleybus.ziu6205.arrows.akbvoltmeter","prib",3.08,3.71,0,50,function(self)
	local bus = self:ButtonIsDown("akbvoltmeterchange") and self:GetTrailer() or self
	return IsValid(bus) and bus:GetNWVar("LowVoltage") or 0
end)
CreateVoltAmpMeter("akbampermeter","trolleybus.ziu6205.arrows.akbampermeter","prib",5.72,3.71,-100,100,function(self)
	local bus = self:ButtonIsDown("akbampermeterchange") and self:GetTrailer() or self
	return IsValid(bus) and bus.SystemsLoaded and -bus:GetSystem("AccumulatorBattery"):GetLastAmperage() or 0
end)
CreateVoltAmpMeter("engineampermeter","trolleybus.ziu6205.arrows.engineampermeter","prib",8.8,3.71,-500,500,function(self)
	return !self.SystemsLoaded and 0 or -self:GetSystem("Engine"):GetAmperage()
end)

CreateManometer("manometer1","trolleybus.ziu6205.arrows.manometer","prib",11.56,2.05,0)
CreateManometer("manometer2","trolleybus.ziu6205.arrows.manometer","prib",18.91,2.05,2)
CreateManometer("speedometer","trolleybus.ziu6205.arrows.speedometer","prib",15.29,4.63,1)

Trolleybus_System.BuildMultiButton(ENT,"poles_removal","leftprib","trolleybus.ziu6205.btns.poles_removal_left","trolleybus.ziu6205.btns.poles_removal_right",
model_switch,2.85,11.97,1,1,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,nil,nil,true,KEY_LBRACKET,KEY_RBRACKET)

Trolleybus_System.BuildMultiButton(ENT,"outsidedooropen","outsidedooropen","trolleybus.ziu6205.btns.outsidedooropen_left","trolleybus.ziu6205.btns.outsidedooropen_right",
model_switch,0,0,1,1,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,function(self,on,state)
	if state==-1 then self:OpenDoor("door1") elseif state==1 then self:CloseDoor("door1") end
end,true,true)

Trolleybus_System.BuildMultiButton(ENT,"turnsignal","turnsignal","trolleybus.ziu6205.btns.turnsignal_right","trolleybus.ziu6205.btns.turnsignal_left",{
	model = "models/trolleybus/ziu6205/guitar_turnsignal_lever.mdl",
	offset_ang = Angle(180,90,90),
	offset_pos = Vector(0,0,3),
	anim = true,
	maxdrawdistance = 200,
},0,0,4,6,function(self,ent,state) return state==-1 and 1 or state==0 and 0.5 or 0 end,nil,nil,false,KEY_H,KEY_G,nil,nil,"RightTurnSignal","LeftTurnSignal")

Trolleybus_System.BuildReverseButton(ENT,"reverse","reverse","trolleybus.ziu6205.btns.reverse_left","trolleybus.ziu6205.btns.reverse","trolleybus.ziu6205.btns.reverse_right",{
	offset_ang = Angle(90,0,0),
	offset_pos = Vector(0,0,0),
	poseparameter = "state",
	sounds = {"trolleybus/reverse_switch.mp3",100,0.5},
	maxdrawdistance = 200,
},0,0,4,4,KEY_9,{KEY_LSHIFT,KEY_0},KEY_0)

Trolleybus_System.BuildReverseButton(ENT,"polarity","polarity","trolleybus.ziu6205.btns.polarity_left","trolleybus.ziu6205.btns.polarity","trolleybus.ziu6205.btns.polarity_right",{
	offset_ang = Angle(90,0,0),
	offset_pos = Vector(0,0,0),
	poseparameter = "state",
	sounds = {"trolleybus/reverse_switch.mp3",100,0.5},
	maxdrawdistance = 200,
},0,0,4,4,KEY_8,{KEY_LSHIFT,KEY_8},KEY_7,function(self,state)
	self:GetTrailer():SetPolesPolarityInversion(state==1)
	
	return true
end)

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

Trolleybus_System.BuildMovingMirror(ENT,"mirror_left",Vector(161.86,45.21,17.98),Angle(0,-90,0),10,10,"models/trolleybus/ziu6205/mirror_bracket.mdl",Vector(178.97,47.28,21.59),Angle(-2,0,1),"Bone","Bone.001",Vector(-1.9,0.05,0.15),Angle(0,180,0),5,9.5,false,true,0,160,-90,0,0,0,-15,15,mirror1verts,40,-27,0,4)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_right",Vector(182.19,-21.33,12.18),Angle(0,-180,0),10,10,"models/trolleybus/ziu6205/mirror_bracket.mdl",Vector(178.88,-47.36,25.06),Angle(0,0,-1),"Bone","Bone.001",Vector(-1.9,0.05,0.15),Angle(0,180,0),5,9.5,false,true,-160,0,0,90,0,0,-15,15,mirror1verts,-40,15,0,0)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_middle",Vector(186.01,-2.95,21.54),Angle(0,-180,0),10,10,"models/trolleybus/ziu6205/mirror_bracket_inside.mdl",Vector(179.35,-26.78,35.68),Angle(0,0,0),"Bone","Bone.001",Vector(-1.6,0,-0.8),Angle(0,180,0),13.5,6,false,true,0,0,-30,0,0,0,-20,20,mirror2verts,0,-28,0,-5)

function ENT:LoadSystems()
	self:LoadSystem("AccumulatorBattery",{
		Voltage = self.AccBatteryVoltage,
	})
	self:LoadSystem("Pneumatic",{
		MotorCompressorSpeed = 30,
		MotorCompressorSounds = {
			StartSounds = Sound("trolleybus/ziu6205/compressor_on_outside.ogg"),
			LoopSound = Sound("trolleybus/ziu6205/compressor_outside.ogg"),
			EndSounds = Sound("trolleybus/ziu6205/compressor_off_outside.ogg"),
			SndVolume = 0.75,
			
			InsideStartSounds = Sound("trolleybus/ziu6205/compressor_on_inside.ogg"),
			InsideLoopSound = Sound("trolleybus/ziu6205/compressor_inside.ogg"),
			InsideEndSounds = Sound("trolleybus/ziu6205/compressor_off_inside.ogg"),
			InsideSndVolume = 0.75,
			
			SoundPos = Vector(-65,34,-38),
		},
		
		Receivers = {
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				PneumaticDoors = {["door1"] = {400,600,1.5},["door2"] = {400,600,1.5},["door3"] = {400,600,1.5},["door4"] = {400,600,1.5}},
				DefaultAir = self:GetSpawnSetting("pressure")*100,
			},
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				PneumaticDoors = {["door1"] = {400,600,1.5},["door2"] = {400,600,1.5},["door3"] = {400,600,1.5},["door4"] = {400,600,1.5}},
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
	self:LoadSystem("Handbrake")
	self:LoadSystem("Horn",{
		SoundPos = Vector(181,0,-15),
		
		ShouldActive = function(sys) return self:ButtonIsDown("horn") end,
	})
	self:LoadSystem("MotorVentilator",{
		SoundPos = Vector(-13.39,30.91,-36.16),
		SoundDistance = 1000,
	})
	self:LoadSystem("IR-2002",{
		Pos = Vector(174.45,-4.94,-2.28),
		Ang = Angle(0,-180,0),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(170.69,11.29,-24.46),
		
		StartSounds = Sound("trolleybus/ziu6205/heaters/vent_cab_on.ogg"),
		LoopSound = Sound("trolleybus/ziu6205/heaters/vent_cab_loop.ogg"),
		EndSounds = Sound("trolleybus/ziu6205/heaters/vent_cab_off.ogg"),
		
		HeaterOnSound = Sound("trolleybus/ziu6205/heaters/heater_cab_on.ogg"),
		HeaterOffSound = Sound("trolleybus/ziu6205/heaters/heater_cab_off.ogg"),
	})
	self:LoadSystem("InteriorHeater",{
		SoundPos = Vector(-63.98,-27.06,-22.87),
		
		StartSounds = Sound("trolleybus/ziu6205/heaters/rear_interior_heater_on.ogg"),
		LoopSound = Sound("trolleybus/ziu6205/heaters/rear_interior_heater.ogg"),
		EndSounds = Sound("trolleybus/ziu6205/heaters/rear_interior_heater_off.ogg"),
	})
	self:LoadSystem("Engine",{
		SoundConfig = {
			{sound = Sound("trolleybus/ziu6205/engine_dk211bm.ogg"),startspd = 600,fadein = 1000,pratemp = 1/1200,pratestart = 1,volume = 1},
		},
		SoundPos = Vector(-61.48,-0.43,-41.22),

		RotationAmperageAcceleration = 120*1.5/75,
		WheelRadius = 20.3,
	})
	self:LoadSystem("HydraulicBooster",{
		SoundPos = Vector(178,42,-32),
		
		StartSounds = Sound("trolleybus/ziu6205/hydrobooster/on.ogg"),
		LoopSound = Sound("trolleybus/ziu6205/hydrobooster/loop.ogg"),
		StopSounds = Sound("trolleybus/ziu6205/hydrobooster/off.ogg"),
	})
	self:LoadSystem("TISU",{
		ContactorSounds = {
			LK = {"trolleybus/ziu6205/contactors/pusk_on.ogg","trolleybus/ziu6205/contactors/pusk_off.ogg"},
			T = {"trolleybus/ziu6205/contactors/stop_on.ogg","trolleybus/ziu6205/contactors/stop_off.ogg"},
		},
		ContactorSoundPos = Vector(173.44,-17.65,-10.82),
		ContactorSoundVolume = 1,
		
		SoundName = "trolleybus/ziu6205/tisu.ogg",
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
				nfont = "Trolleybus_System.Trolleybus.ZiU6205.RouteDisplay.NameplateNumber",
				font = "Trolleybus_System.Trolleybus.ZiU6205.RouteDisplay.Nameplate",
				drawscale = 10,
			},
		},
		Positions = {
			{
				pos = Vector(186,-18,45),
				ang = Angle(0,0,0),
				type = "default",
				shouldbeactive = function(sys,self) return self:ButtonIsDown("fronttrapdoor") end,
				think = function(sys,self,ent) ent:SetSkin(self:GetScheduleLight()>0 and 1 or 0) end,
			},
			{
				pos = Vector(-145,-46.39,12),
				ang = Angle(-2,-90,0),
				type = "default",
			},
		},
	})
end

ENT.SpawnSettings = {
	{
		alias = "pressure",
		type = "Slider",
		name = "trolleybus.ziu6205.settings.pressure",
		min = 0,
		max = 8,
		default = 0,
		preview = {"trolleybus/spawnsettings_previews/ziu6205/pressure",0,8},
	},
	{
		alias = "mainswitchdisabling",
		type = "CheckBox",
		name = "trolleybus.ziu6205.settings.mainswitchdisabling",
		nopreview = true,
		default = true,
	},
	{
		alias = "moldings",
		type = "ComboBox",
		name = "trolleybus.ziu6205.settings.moldings",
		default = 1,
		choices = {
			{name = "trolleybus.ziu6205.settings.moldings.up_down",preview = "trolleybus/spawnsettings_previews/ziu6205/moldings1.png"},
			{name = "trolleybus.ziu6205.settings.moldings.up",preview = "trolleybus/spawnsettings_previews/ziu6205/moldings2.png"},
			{name = "trolleybus.ziu6205.settings.moldings.down",preview = "trolleybus/spawnsettings_previews/ziu6205/moldings3.png"},
			{name = "trolleybus.ziu6205.settings.moldings.none",preview = "trolleybus/spawnsettings_previews/ziu6205/moldings4.png"},
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
		alias = "reflectors",
		type = "CheckBox",
		name = "trolleybus.ziu6205.settings.reflectors",
		default = true,
		preview_on = "trolleybus/spawnsettings_previews/ziu6205/reflectors1.png",
		preview_off = "trolleybus/spawnsettings_previews/ziu6205/reflectors2.png",
		setup = function(self,value)
			if SERVER then
				self:SetBodygroup(4,value and 1 or 0)
			end
		end,
		unload = function(self,value)
			if SERVER then
				self:SetBodygroup(4,0)
			end
		end,
	},
	{
		alias = "logo",
		type = "CheckBox",
		name = "trolleybus.ziu6205.settings.logo",
		default = true,
		preview_on = "trolleybus/spawnsettings_previews/ziu6205/logo1.png",
		preview_off = "trolleybus/spawnsettings_previews/ziu6205/logo2.png",
		setup = function(self,value)
			if SERVER and !self.IsTrailer then
				self:SetBodygroup(5,value and 1 or 0)
			end
		end,
		unload = function(self,value)
			if SERVER and !self.IsTrailer then
				self:SetBodygroup(5,0)
			end
		end,
	},
	{
		alias = "grid",
		type = "CheckBox",
		name = "trolleybus.ziu6205.settings.grid",
		default = true,
		preview_on = "trolleybus/spawnsettings_previews/ziu6205/grid1.png",
		preview_off = "trolleybus/spawnsettings_previews/ziu6205/grid2.png",
		setup = function(self,value)
			if SERVER and !self.IsTrailer then
				self:SetBodygroup(6,value and 1 or 0)
			end
		end,
		unload = function(self,value)
			if SERVER and !self.IsTrailer then
				self:SetBodygroup(6,0)
			end
		end,
	},
	{
		alias = "wornoutjoint",
		type = "CheckBox",
		name = "trolleybus.ziu6205.settings.wornoutjoint",
		default = true,
		preview_on = "trolleybus/spawnsettings_previews/ziu6205/wornoutjoint1.png",
		preview_off = "trolleybus/spawnsettings_previews/ziu6205/wornoutjoint2.png",
		setup = function(self,value)
			if CLIENT and !self.IsTrailer then
				self.TrailerData = value and self.TrailerData2 or self.TrailerData1
			end
		end,
		unload = function(self,value)
			if CLIENT and !self.IsTrailer then
				self.TrailerData = self.TrailerData1
			end
		end,
	},
	{
		alias = "reductor",
		type = "ComboBox",
		name = "trolleybus.ziu6205.settings.reductor",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.ziu6205.settings.reductor.raba01881",preview = "trolleybus/spawnsettings_previews/ziu6205/raba01881.wav"},
			{name = "trolleybus.ziu6205.settings.reductor.raba31877",preview = "trolleybus/spawnsettings_previews/ziu6205/raba31877.wav"},
			{name = "trolleybus.ziu6205.settings.reductor.iztm",preview = "trolleybus/spawnsettings_previews/ziu6205/iztm.wav"},
		},
		setup = function(self,value)
			if self.IsTrailer then return end
			
			local function Volume(self,ent)
				return !ent.SystemsLoaded and 0 or math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/300,0.1,1)
			end
			
			self:LoadSystem("Reductor",{
				SoundConfig = value==1 and {
					{sound = Sound("trolleybus/ziu6205/rear_axle/raba_018_81/reductor.ogg"),pratemp = 1/900,pratestart = 0,volume = Volume},
					{sound = Sound("trolleybus/ziu6205/rear_axle/raba_018_81/background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
				} or value==2 and {
					{sound = Sound("trolleybus/ziu6205/rear_axle/raba_318_77/reductor.ogg"),pratemp = 1/900,pratestart = 0,volume = Volume},
					{sound = Sound("trolleybus/ziu6205/rear_axle/raba_318_77/background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
				} or {
					{sound = Sound("trolleybus/ziu6205/rear_axle/iztm/reductor.ogg"),pratemp = 1/900,pratestart = 0,volume = Volume},
					{sound = Sound("trolleybus/ziu6205/rear_axle/iztm/background.ogg"),pratemp = 1/800,pratestart = 0,volume = 0.6},
				},
				
				SoundPos = Vector(-125.17,1.29,-41.18),
			})
			
			if SERVER then
				for k,v in ipairs(self.Wheels) do
					if !v.Drive then continue end
					
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(1,value==1 and 0 or value==2 and 1 or value==3 and 2)
					end
				end
			end
		end,
		unload = function(self,value)
			if self.IsTrailer then return end
			
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
		alias = "buzzer",
		type = "ComboBox",
		name = "trolleybus.ziu6205.settings.buzzer",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.ziu6205.settings.buzzer.type1",preview = "trolleybus/spawnsettings_previews/ziu6205/buzzer1.wav"},
			{name = "trolleybus.ziu6205.settings.buzzer.type2",preview = "trolleybus/spawnsettings_previews/ziu6205/buzzer2.wav"},
			{name = "trolleybus.ziu6205.settings.buzzer.type3",preview = "trolleybus/spawnsettings_previews/ziu6205/buzzer3.wav"},
		},
		setup = function(self,value)
			self:LoadSystem("Buzzer",{
				SoundPos = Vector(176.82,28.24,-0.28),
				
				LoopSound = Sound("trolleybus/ziu6205/buzzer/"..value..".ogg"),
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("Buzzer")
		end,
	},
	Trolleybus_System.BuildSkinSpawnSetting("ziu6205","trolleybus.ziu6205.settings.skins"),
}