-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "AKSM 333"
ENT.Category = {"creationtab_category.default","creationtab_category.default.aksm","creationtab_category.default.aksm333"}

Trolleybus_System.WheelTypes["aksm333"] = {
	Model = "models/trolleybus/aksm333/wheel.mdl",
	Ang = Angle(0,-90,0),
	Radius = 19.5,
	RotateAxis = Angle(1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["aksm333_rear"] = {
	Model = "models/trolleybus/aksm333/wheel2.mdl",
	Ang = Angle(0,-90,0),
	Radius = 19.5,
	RotateAxis = Angle(1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/aksm333/body.mdl"
ENT.HasPoles = false

ENT.PassCapacity = 100

ENT.OtherSeats = {
	{
		Type = 1,
		Pos = Vector(320,-18,-36),
		Ang = Angle(0,0,0),
		Camera = Vector(320,-18,22),
	},
}

ENT.InteriorLights = {
	{pos = Vector(197,0,30),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(38,0,30),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
}

ENT.DoorsData = {
	["door1"] = {
		model = "models/trolleybus/aksm333/door1.mdl",
		pos = Vector(310,-50.7,0),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_aksm321_start_open.ogg",500},
		opensoundend = {"trolleybus/door_aksm321_end.ogg",500},
		movesound = {"trolleybus/door_aksm321_move.ogg",500},
		closesoundstart = {"trolleybus/door_aksm321_start_close.ogg",500},
		closesoundend = {"trolleybus/door_aksm321_end.ogg",500},
		poseparameter = "state",
		speedmult = 1,
		nopass = true,
	},
	["door2"] = {
		model = "models/trolleybus/aksm333/door2.mdl",
		pos = Vector(310,-50.7,0),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_aksm321_start_open.ogg",500},
		opensoundend = {"trolleybus/door_aksm321_end.ogg",500},
		movesound = {"trolleybus/door_aksm321_move.ogg",500},
		closesoundstart = {"trolleybus/door_aksm321_start_close.ogg",500},
		closesoundend = {"trolleybus/door_aksm321_end.ogg",500},
		poseparameter = "state",
		speedmult = 1,
	},
	["door3"] = {
		model = "models/trolleybus/aksm333/door3.mdl",
		pos = Vector(113.61,-50.7,0),
		ang = Angle(0,0),
		opensoundstart = {"trolleybus/door_aksm321_start_open.ogg",500},
		opensoundend = {"trolleybus/door_aksm321_end.ogg",500},
		movesound = {"trolleybus/door_aksm321_move.ogg",500},
		closesoundstart = {"trolleybus/door_aksm321_start_close.ogg",500},
		closesoundend = {"trolleybus/door_aksm321_end.ogg",500},
		poseparameter = "state",
		speedmult = 1,
	},
}

ENT.DriverSeatData = {
	Type = 0,
	Pos = Vector(302,30.5,-29),
	Ang = Angle(),
}

ENT.TrailerData = {
	class = "trolleybus_ent_aksm333_trailer",
	pos = Vector(0,0,0),
	ang = Angle(),
	ballsocket = {
		lpos = Vector(-28,0,-47),
		trailerlpos = Vector(-89,0,-47),
		plimits = {-10,10},
		ylimits = {-40,40},
		rlimits = {-10,10},
	},
	joint = {
		model = "models/trolleybus/aksm333/joint.mdl",
		modelpos = Vector(0,0,0),
		pos = Vector(-27.9,0,0),
		ang = Angle(0,180,0),
		bone = "Bone001",
		trailerpos = Vector(-88.7,0,0),
		trailerang = Angle(0,180,0),
		trailerbone = "Bone002",
	},
}

local btnmodel = {
	model = "models/trolleybus/aksm333/btn1.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	sounds = {
		On = {"trolleybus/tumbler_aksm321_on.ogg",100},
		Off = {"trolleybus/tumbler_aksm321_off.ogg",100},
	},
	poseparameter = "state",
	maxdrawdistance = 200,
}

local btnmodel_ang = {
	model = "models/trolleybus/aksm333/btn1.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(180,90,90),
	sounds = {
		On = {"trolleybus/tumbler_aksm321_on.ogg",100},
		Off = {"trolleybus/tumbler_aksm321_off.ogg",100},
	},
	poseparameter = "state",
	maxdrawdistance = 200,
}

local btnmodel2 = {
	model = "models/trolleybus/aksm333/btn2.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(90,0,0),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel = {
	model = "models/trolleybus/aksm333/doorbtn_left.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel2 = {
	model = "models/trolleybus/aksm333/doorbtn_right.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local avmodel = {
	model = "models/trolleybus/aksm333/av.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(90,0,0),
	poseparameter = "state",
	sounds = {
		On = {"trolleybus/paketnik_on.ogg",100},
		Off = {"trolleybus/paketnik_off.ogg",100},
	},
	maxdrawdistance = 200,
}

ENT.ButtonsData = {
	["key"] = {
		name = "trolleybus.aksm333.btns.key",
		model = {
			model = "models/trolleybus/aksm333/key.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "key",
			pos = {0.91,1.01},
			radius = 1,
		},
		toggle = true,
	},
	["handbrake"] = {
		name = "trolleybus.aksm333.btns.handbrake",
		model = {
			model = "models/trolleybus/aksm333/handbrake.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(-90,180,0),
			poseparameter = "state",
			sounds = {
				On = {"trolleybus/pneumatic_brake_on.ogg",100},
				Off = {"trolleybus/pneumatic_brake_off.ogg",100},
			},
			maxdrawdistance = 200,
		},
		panel = {
			name = "leftprib2",
			pos = {1.53,2.08},
			radius = 2,
		},
		toggle = true,
		hotkey = KEY_V,
		externalhotkey = "Handbrake",
		func = function(self,on) self:SetHandbrakeActive(on) end,
	},
	["reverse_up"] = {
		name = "trolleybus.aksm333.btns.reverse_up",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {0.65,1.37},
			radius = 0.5,
		},
		hotkey = KEY_0,
		func = function(self,on) if on and self:GetReverseState()<1 then self:ChangeReverse(self:GetReverseState()+1) end end,
	},
	["reverse_down"] = {
		name = "trolleybus.aksm333.btns.reverse_down",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.95,1.36},
			radius = 0.5,
		},
		hotkey = KEY_9,
		func = function(self,on) if on and self:GetReverseState()>-1 then self:ChangeReverse(self:GetReverseState()-1) end end,
	},
	["electricbrake"] = {
		name = "trolleybus.aksm333.btns.electricbrake",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {2.01,5.07},
			radius = 0.5,
		},
		toggle = true,
	},
	["informator_play"] = {
		name = "trolleybus.aksm333.btns.informator_play",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {2,6.86},
			radius = 0.5,
		},
		func = function(self,on) self:ToggleButton("Agit-132_Button1",on) end,
	},
	["emergencyoff"] = {
		name = "trolleybus.aksm333.btns.emergencyoff",
		model = btnmodel2,
		panel = {
			name = "leftprib2",
			pos = {1.23,19.08},
			radius = 0.5,
		},
		func = function(self,on)
			if on then
				self:ToggleButton("electricbrake",false)
				self:ToggleButton("550v",false)
				self:ToggleButton("compressor",false)
				self:ToggleButton("hydraulic_booster",false)
				self:ToggleButton("kneeling",false)
				self:ToggleButton("polelights",false)
				self:ToggleButton("headlights",false)
				self:ToggleButton("profilelights",false)
				self:ToggleButton("airflow",false)
				self:ToggleButton("buzzer",false)
				self:ToggleButton("cabinevent",false)
				self:ToggleButton("interiorlight",false)
				self:ToggleButton("schedulelight",false)
				self:ToggleButton("mirrorheat",false)
				self:ToggleButton("cabinelight",false)
				self:ToggleButton("interiorheater",false)
				self:ToggleButton("intheatervent",false)
				self:ToggleButton("cabineheat",false)
				self:ToggleButton("sequence",false)
				self:ToggleButton("converter",false)
				self:ToggleButton("unknown4",false)
				self:ToggleButton("unknown6",false)
				self:ToggleButton("pneumaticpolecatchers",false)
				self:ToggleButton("stop_with_opened_doors",false)
			end
		end,
	},
	["hydraulic_booster"] = {
		name = "trolleybus.aksm333.btns.hydraulic_booster",
		model = btnmodel,
		panel = {
			name = "rightprib",
			pos = {0.62,3.17},
			radius = 0.7,
		},
		toggle = true,
	},
	["kneeling"] = {
		name = "trolleybus.aksm333.btns.kneeling",
		model = btnmodel,
		panel = {
			name = "rightprib",
			pos = {2,3.12},
			radius = 0.7,
		},
		toggle = true,
	},
	["polelights"] = {
		name = "trolleybus.aksm333.btns.polelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {2.93,5.53},
			radius = 0.7,
		},
		toggle = true,
	},
	["profilelights"] = {
		name = "trolleybus.aksm333.btns.profilelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {5.87,5.58},
			radius = 0.7,
		},
		toggle = true,
	},
	["headlights"] = {
		name = "trolleybus.aksm333.btns.headlights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {3.92,5.57},
			radius = 0.7,
		},
		toggle = true,
		hotkey = KEY_F,
	},
	["airflow"] = {
		name = "trolleybus.aksm333.btns.airflow",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {1.97,5.53},
			radius = 0.7,
		},
		toggle = true,
	},
	["buzzer"] = {
		name = "trolleybus.aksm333.btns.buzzer",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.81,7.23},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinevent"] = {
		name = "trolleybus.aksm333.btns.cabinevent",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {1,14.51},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorlight"] = {
		name = "trolleybus.aksm333.btns.interiorlight",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {1,12.6},
			radius = 0.7,
		},
		toggle = true,
	},
	["pneumaticpolecatchers"] = {
		name = "trolleybus.aksm333.btns.pneumaticpolecatchers",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.57,14.53},
			radius = 0.7,
		},
		toggle = true,
	},
	["stop_with_opened_doors"] = {
		name = "trolleybus.aksm333.btns.stop_with_opened_doors",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.8,16.36},
			radius = 0.7,
		},
		toggle = true,
	},
	["schedulelight"] = {
		name = "trolleybus.aksm333.btns.schedulelight",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {4.89,5.56},
			radius = 0.7,
		},
		toggle = true,
	},
	["550v"] = {
		name = "trolleybus.aksm333.btns.550v",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {7.44,5.3},
			radius = 0.7,
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["mirrorheat"] = {
		name = "trolleybus.aksm333.btns.mirrorheat",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {8.61,5.32},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinelight"] = {
		name = "trolleybus.aksm333.btns.cabinelight",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {9.82,5.37},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorheater"] = {
		name = "trolleybus.aksm333.btns.interiorheater",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {10.94,5.38},
			radius = 0.7,
		},
		toggle = true,
	},
	["intheatervent"] = {
		name = "trolleybus.aksm333.btns.intheatervent",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {12.14,5.33},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabineheat"] = {
		name = "trolleybus.aksm333.btns.cabineheat",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.56,12.66},
			radius = 0.7,
		},
		toggle = true,
	},
	["doorbtn1"] = {
		name = "trolleybus.aksm333.btns.doorbtn1",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {3.58,1.68},
			radius = 0.5,
		},
		hotkey = KEY_3,
		func = function(self,on) if on then self:OpenDoor("door1") end end,
	},
	["doorbtn2"] = {
		name = "trolleybus.aksm333.btns.doorbtn2",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {3.55,2.66},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door2") end end,
	},
	["doorbtn3"] = {
		name = "trolleybus.aksm333.btns.doorbtn3",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {3.51,3.7},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door3") end end,
	},
	["doorbtn4"] = {
		name = "trolleybus.aksm333.btns.doorbtn4",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {3.5,4.64},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():OpenDoor("door4") end end,
	},
	["doorbtn5"] = {
		name = "trolleybus.aksm333.btns.doorbtn5",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {3.47,5.7},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():OpenDoor("door5") end end,
	},
	["doorbtn6"] = {
		name = "trolleybus.aksm333.btns.doorbtn6",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {3.53,7.31},
			radius = 0.5,
		},
		hotkey = KEY_1,
		func = function(self,on)
			if on then
				self:OpenDoor("door2")
				self:OpenDoor("door3")
				self:GetTrailer():OpenDoor("door4")
				self:GetTrailer():OpenDoor("door5")
			end
		end,
	},
	["doorbtn7"] = {
		name = "trolleybus.aksm333.btns.doorbtn7",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {4.66,1.68},
			radius = 0.5,
		},
		hotkey = KEY_4,
		func = function(self,on) if on then self:CloseDoor("door1") end end,
	},
	["doorbtn8"] = {
		name = "trolleybus.aksm333.btns.doorbtn8",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {4.67,2.68},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door2") end end,
	},
	["doorbtn9"] = {
		name = "trolleybus.aksm333.btns.doorbtn9",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {4.68,3.67},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door3") end end,
	},
	["doorbtn10"] = {
		name = "trolleybus.aksm333.btns.doorbtn10",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {4.67,4.69},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():CloseDoor("door4") end end,
	},
	["doorbtn11"] = {
		name = "trolleybus.aksm333.btns.doorbtn11",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {4.69,5.72},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():CloseDoor("door5") end end,
	},
	["doorbtn12"] = {
		name = "trolleybus.aksm333.btns.doorbtn12",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {4.68,7.32},
			radius = 0.5,
		},
		hotkey = KEY_2,
		func = function(self,on)
			if on then
				self:CloseDoor("door2")
				self:CloseDoor("door3")
				self:GetTrailer():CloseDoor("door4")
				self:GetTrailer():CloseDoor("door5")
			end
		end,
	},
	["emergency"] = {
		name = "trolleybus.aksm333.btns.emergency",
		model = {
			model = "models/trolleybus/aksm333/emergency.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "leftprib",
			pos = {6.2,0.95},
			radius = 0.5,
		},
		hotkey = KEY_B,
		externalhotkey = "Emergency",
		func = function(self,on) if on then self.EmergencySignal = !self.EmergencySignal end end,
	},
	["unknown4"] = {
		name = "trolleybus.aksm333.btns.unknown4",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {1.41,4.21},
			radius = 2,
		},
		toggle = true,
	},
	["converter"] = {
		name = "trolleybus.aksm333.btns.converter",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {16.07,8.69},
			radius = 2,
		},
		toggle = true,
	},
	["unknown6"] = {
		name = "trolleybus.aksm333.btns.unknown6",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.66,8.69},
			radius = 2,
		},
		toggle = true,
	},
	["sequence"] = {
		name = "trolleybus.aksm333.btns.sequence",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {16.05,1.67},
			radius = 2,
		},
		toggle = true,
	},
	["compressor"] = {
		name = "trolleybus.aksm333.btns.compressor",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.68,1.65},
			radius = 2,
		},
		toggle = true,
	},
	["horn"] = {
		name = "trolleybus.aksm333.btns.horn",
		model = {
			model = "models/trolleybus/aksm333/hornbtn.mdl",
			poseparameter = "state",
			maxdrawdistance = 200,
			initialize = function(self,ent)
				local guitar = self.OtherPanelEnts["guitar_left"] and self.OtherPanelEnts["guitar_left"].Ent
		
				if guitar then
					ent:SetParent(guitar)
					ent:AddEffects(EF_BONEMERGE)
				end
			end,
		},
		panel = {
			name = "guitar_left",
			pos = {0,0},
			size = {4,2},
		},
		hotkey = KEY_T,
		externalhotkey = "Horn",
	},
	["door1toggleoutside"] = {
		name = "trolleybus.aksm333.btns.door1toggleoutside",
		model = btnmodel2,
		panel = {
			name = "door1toggleoutside",
			pos = {0.5,0.5},
			radius = 0.5,
		},
		func = function(self,on) if on then if self:DoorIsOpened("door1") then self:CloseDoor("door1") else self:OpenDoor("door1") end end end,
	},
	["door1manual"] = {
		name = "trolleybus.aksm333.btns.door1manual",
		panel = {
			name = "door1manual",
			pos = {0,0},
			size = {26,75},
		},
		func = function(self,on)
			if !on or self:CanDoorsMove("door1") then return end
			
			if self:DoorIsOpened("door1") then
				self:CloseDoorWithHand("door1")
			else
				self:OpenDoorWithHand("door1")
			end
		end,
	},
}

ENT.PanelsData = {
	["key"] = {
		pos = Vector(323.36,31.37,-15.9),
		ang = Angle(-70,-180,0),
		size = {2,2},
	},
	["rightprib"] = {
		pos = Vector(335.64,22.01,-5.14),
		ang = Angle(-51.6,167,9.3),
		size = {6,8},
	},
	["leftprib"] = {
		pos = Vector(334.51,45.95,-4.8),
		ang = Angle(-51.1,-168.1,-7.7),
		size = {7,7},
	},
	["prib"] = {
		pos = Vector(335.75,38.27,-5.33),
		ang = Angle(-46.7,-180,-0.1),
		size = {15,7},
	},
	["leftprib2"] = {
		pos = Vector(321.8,48.95,-17.62),
		ang = Angle(-90,-180,0),
		size = {4,20},
	},
	["avs"] = {
		pos = Vector(281.83,25.3,31),
		ang = Angle(0,3.6,0),
		size = {20,11},
	},
	["ups"] = {
		pos = Vector(311.55,39.61,44.9),
		ang = Angle(23.1,-90,0),
		size = {13,7},
	},
	["pedals"] = {
		pos = Vector(337.4,41.49,-35.95),
		ang = Angle(-90,-180,0),
		size = {22,10},
	},
	["guitar_left"] = {
		pos = Vector(323.13,41.07,-13.73),
		ang = Angle(-110,0,-90),
		size = {4,6},
	},
	["guitar_right"] = {
		pos = Vector(323.13,25.98,-13.73),
		ang = Angle(-110,0,-90),
		size = {4,6},
	},
	["door1toggleoutside"] = {
		pos = Vector(338.91,-51.09,-19.5),
		ang = Angle(0,-90,0),
		size = {1,1},
	},
	["door1manual"] = {
		pos = Vector(310.14,-50.25,31.09),
		ang = Angle(0,-90,0),
		size = {26,75},
	},
}

local function IndicatorLamp(name,panel,x,y,type,check)
	local off = type
	local on = type+13

	return {
		name = name,
		model = "models/trolleybus/aksm333/indicatorlamp.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = 0.5,
		},
		maxdrawdistance = 200,
		offset_ang = Angle(-90,0,180),
		think = function(self,ent)
			ent:SetSkin(self:GetNWVar("LowPower") and check(self) and on or off)
		end,
	}
end

ENT.OtherPanelEntsData = {
	["startpedal"] = {
		name = "",
		model = "models/trolleybus/aksm333/pedal.mdl",
		panel = {
			name = "pedals",
			pos = {16.71,5.3},
			radius = 0,
		},
		offset_pos = Vector(0.2,0,-2),
		offset_ang = Angle(-90,0,180),
		initialize = function(self,ent)
			ent.State = self:GetStartPedal()
			
			ent:SetPoseParameter("state",ent.State)
		end,
		think = function(self,ent)
			local state = self:GetStartPedal()
			
			if ent.State!=state then
				if ent.State<state then
					ent.State = math.min(state,ent.State+self.DeltaTime*5)
				else
					ent.State = math.max(state,ent.State-self.DeltaTime*5)
				end
				
				ent:SetPoseParameter("state",ent.State)
			end
		end,
		maxdrawdistance = 200,
	},
	["brakepedal"] = {
		name = "",
		model = "models/trolleybus/aksm333/pedal.mdl",
		panel = {
			name = "pedals",
			pos = {5.28,5.3},
			radius = 0,
		},
		offset_pos = Vector(0.2,0,-2),
		offset_ang = Angle(-90,0,180),
		initialize = function(self,ent)
			ent.State = self:GetBrakePedal()
			
			ent:SetPoseParameter("state",ent.State)
		end,
		think = function(self,ent)
			local state = self:GetBrakePedal()
			
			if ent.State!=state then
				if ent.State<state then
					ent.State = math.min(state,ent.State+self.DeltaTime*5)
				else
					ent.State = math.max(state,ent.State-self.DeltaTime*5)
				end
				
				ent:SetPoseParameter("state",ent.State)
			end
		end,
		maxdrawdistance = 200,
	},
	["indicatorlamp_battery"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.accbattery","prib",1.64,0.61,0,function(self)
		return false
	end),
	["indicatorlamp_brake"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.brake","prib",2.64,0.61,1,function(self)
		return self:GetRearLights()==1
	end),
	["indicatorlamp_mirrorheat"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.mirrorheat","prib",3.64,0.61,2,function(self)
		return self:ButtonIsDown("mirrorheat")
	end),
	["indicatorlamp_doors"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.doors","prib",4.64,0.61,3,function(self)
		return self:DoorsIsOpened()
	end),
	["indicatorlamp_profilelights"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.profilelights","prib",5.64,0.61,4,function(self)
		return self:GetProfileLights()>0
	end),
	["indicatorlamp_headlights"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.headlights","prib",6.64,0.61,5,function(self)
		return self:GetHeadLights()>0
	end),
	["indicatorlamp_turnsignal"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.turnsignal","prib",7.64,0.61,6,function(self)
		return self:GetTurnSignal()!=0 and Trolleybus_System.TurnSignalTickActive(self)
	end),
	["indicatorlamp_emergency"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.emergency","prib",8.64,0.61,7,function(self)
		return self:GetEmergencySignal()
	end),
	["indicatorlamp_lowair1"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.lowair1","prib",9.64,0.61,8,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<125 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair2"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.lowair2","prib",10.64,0.61,9,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<250 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair3"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.lowair3","prib",11.64,0.61,10,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<375 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair4"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.lowair4","prib",12.64,0.61,11,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<500 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_handbrake"] = IndicatorLamp("trolleybus.aksm333.indicatorlamps.handbrake","prib",13.64,0.61,12,function(self)
		return self:GetHandbrakeActive()
	end),
}

Trolleybus_System.BuildMultiButton(ENT,"guitar_left","guitar_left","trolleybus.aksm333.btns.turnleft","trolleybus.aksm333.btns.turnright",{
	model = "models/trolleybus/aksm333/guitar_left.mdl",
	offset_ang = Angle(0,90,90),
	offset_pos = Vector(0,0,-3),
	poseparameter = "state",
	maxdrawdistance = 200,
	initialize = function(self,ent)
		local btn = self.Buttons["horn"] and self.Buttons["horn"].Ent
		
		if btn then
			btn:SetParent(ent)
			btn:AddEffects(EF_BONEMERGE)
		end
	end,
},0,2,4,4,function(self,ent,state) return state==-1 and 0 or state==1 and 1 or 0.5 end,nil,nil,nil,KEY_G,KEY_H,nil,nil,"LeftTurnSignal","RightTurnSignal")

Trolleybus_System.BuildMultiButton(ENT,"guitar_right","guitar_right","trolleybus.aksm333.btns.wipers1","trolleybus.aksm333.btns.wipers2",{
	model = "models/trolleybus/aksm333/guitar_right.mdl",
	offset_ang = Angle(0,90,90),
	offset_pos = Vector(0,0,4),
	poseparameter = "state",
	maxdrawdistance = 200,
},0,0,4,6,function(self,ent,state) return state==-1 and 0 or state==1 and 1 or 0.5 end)

local function SetupNameplates(self,color)
	Trolleybus_System.BuildNameplatePanel(self,"nameplate_front",Vector(344.3,-33.64,46.08),Angle(0,0,0),67,9,2,"Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.RouteNumber","Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.Route",8,color,true)
	
	Trolleybus_System.BuildInteriorNameplate(self,"int_nameplate",Vector(257.7,14.51,45.35),Angle(0,-180,-2),42.7,2.7,function(self)
		if !self:GetNWVar("LowPower") then return end
		
		return self.SystemsLoaded and self:GetSystem("Agit-132"):GetStopText(true)
	end,"Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.Integral",200,color,10)
end
SetupNameplates(ENT,Color(255,155,0))

Trolleybus_System.BuildDialGauge(ENT,"speedometer","trolleybus.aksm333.dialgauge.speedometer","prib",7.66,4.07,2.5,-77,function(self,ent)
	return !self.SystemsLoaded and 0 or -(math.abs(self:GetSystem("Engine"):GetMoveSpeed())-20)*2.15
end,"models/trolleybus/aksm333/speedometer.mdl",nil,Vector(0.15,0,0))

Trolleybus_System.BuildDialGauge(ENT,"linepressure1","trolleybus.aksm333.dialgauge.linepressure","prib",2.17,2.8,1.3,35,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(1)/100

	return air<4 and -air*5.5 or -22-(air-4)*9.2
end,"models/trolleybus/aksm333/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))

Trolleybus_System.BuildDialGauge(ENT,"linepressure2","trolleybus.aksm333.dialgauge.linepressure","prib",13.12,2.77,1.3,35,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(2)/100

	return air<4 and -air*5.5 or -22-(air-4)*9.2
end,"models/trolleybus/aksm333/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))

Trolleybus_System.BuildDialGauge(ENT,"cylinderpressure1","trolleybus.aksm333.dialgauge.cylinderpressure","prib",3.5,5.65,1.3,35,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(1)/100

	return air<4 and -air*5.5 or -22-(air-4)*9.2
end,"models/trolleybus/aksm333/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))

Trolleybus_System.BuildDialGauge(ENT,"cylinderpressure2","trolleybus.aksm333.dialgauge.cylinderpressure","prib",11.8,5.63,1.3,35,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(2)/100

	return air<4 and -air*5.5 or -22-(air-4)*9.2
end,"models/trolleybus/aksm333/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))

Trolleybus_System.BuildDialGauge(ENT,"akbvoltage","trolleybus.aksm333.dialgauge.akbvoltage","leftprib",1.33,2.84,1.3,55,function(self,ent)
	local voltage = self:GetNWVar("LowVoltage",0)
	
	return voltage<12 and -voltage*1.4 or voltage<14 and -12*1.4-(voltage-12)*22 or -12*1.4-2*22-(voltage-14)*10
end,"models/trolleybus/aksm333/manometerarrow.mdl",nil,Vector(0.15,0.2,-0.58))

Trolleybus_System.BuildMovingMirror(ENT,"left_mirror",Vector(322.93,50.21,15.88),Angle(0,-90,0),10,10,"models/trolleybus/aksm333/mirror_left.mdl",Vector(340.24,51.3,22.11),Angle(0,0,0),"Bone001","Bone002",Vector(-2,1.5,-3.6),Angle(-1,-179,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,10,3,0,-5)
Trolleybus_System.BuildMovingMirror(ENT,"middle_mirror",Vector(338.55,10.33,17.59),Angle(0,-180,0),10,10,"models/trolleybus/aksm333/mirror_middle.mdl",Vector(335.29,0.11,33.84),Angle(0,0,0),"Bone001","Bone002",Vector(-1.8,0,0.3),Angle(0,-180,0),11.5,6,true,false,-35,35,-35,35,-20,10,-20,10,nil,-20,-0,-15)
Trolleybus_System.BuildMovingMirror(ENT,"right_mirror",Vector(345.58,-29.99,13.91),Angle(0,-180,0),10,10,"models/trolleybus/aksm333/mirror_right.mdl",Vector(339.47,-52.21,24.76),Angle(0,0,0),"Bone001","Bone002",Vector(-2.1,-1.5,-0.7),Angle(2,176,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,-22,-10,0,-2)

local function Volume(self,ent)
	return math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/500,0.3,1)*0.5
end

local function Volume2(self,ent)
	return math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/500,0.3,1)*1
end

ENT.SpawnSettings = {
	{
		alias = "pressure",
		type = "Slider",
		name = "trolleybus.aksm333.settings.pressure",
		min = 0,
		max = 8,
		default = 0,
		preview = {"trolleybus/spawnsettings_previews/aksm333/pressure",0,8},
	},
	{
		alias = "lamps",
		type = "ComboBox",
		name = "trolleybus.aksm333.settings.lamps",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333.settings.lamps.type1",preview = "trolleybus/spawnsettings_previews/aksm333/lamps1.png"},
			{name = "trolleybus.aksm333.settings.lamps.type2",preview = "trolleybus/spawnsettings_previews/aksm333/lamps2.png"},
		},
	},
	{
		alias = "seats",
		type = "ComboBox",
		name = "trolleybus.aksm333.settings.seats",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333.settings.seats.type1",preview = "trolleybus/spawnsettings_previews/aksm333/seats1.png"},
			{name = "trolleybus.aksm333.settings.seats.type2",preview = "trolleybus/spawnsettings_previews/aksm333/seats2.png"},
		},
	},
	{
		alias = "wnddet",
		type = "ComboBox",
		name = "trolleybus.aksm333.settings.wnddet",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333.settings.wnddet.type1",preview = "trolleybus/spawnsettings_previews/aksm333/wnddet1.png"},
			{name = "trolleybus.aksm333.settings.wnddet.type2",preview = "trolleybus/spawnsettings_previews/aksm333/wnddet2.png"},
			{name = "trolleybus.aksm333.settings.wnddet.type3",preview = "trolleybus/spawnsettings_previews/aksm333/wnddet3.png"},
		},
	},
	{
		alias = "routecolor",
		type = "ComboBox",
		name = "trolleybus.aksm333.settings.routecolor",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333.settings.routecolor.type1",preview = "trolleybus/spawnsettings_previews/aksm333/routecolor1.png"},
			{name = "trolleybus.aksm333.settings.routecolor.type2",preview = "trolleybus/spawnsettings_previews/aksm333/routecolor2.png"},
		},
		setup = function(self,value)
			if value==2 then
				local color = Color(120,200,0)
			
				if self.IsTrailer then
					self:_SetupNameplates(color)
				else
					SetupNameplates(self,color)
				end
			end
		end,
		unload = function(self,value)
			if value==2 then
				local color = Color(255,155,0)
			
				if self.IsTrailer then
					self:_SetupNameplates(color)
				else
					SetupNameplates(self,color)
				end
			end
		end,
	},
	{
		alias = "speakers",
		type = "CheckBox",
		name = "trolleybus.aksm333.settings.speakers",
		default = false,
		preview_off = "trolleybus/spawnsettings_previews/aksm333/speakers1.png",
		preview_on = "trolleybus/spawnsettings_previews/aksm333/speakers2.png",
	},
	{
		alias = "emblem",
		type = "CheckBox",
		name = "trolleybus.aksm333.settings.emblem",
		default = false,
		preview_off = "trolleybus/spawnsettings_previews/aksm333/emblem1.png",
		preview_on = "trolleybus/spawnsettings_previews/aksm333/emblem2.png",
	},
	{
		alias = "engine",
		type = "ComboBox",
		name = "trolleybus.aksm333.settings.engine",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm333.settings.engine.atcd",preview = "trolleybus/spawnsettings_previews/aksm333/atcd.wav"},
			{name = "trolleybus.aksm333.settings.engine.dta",preview = "trolleybus/spawnsettings_previews/aksm333/dta.wav"},
		},
		setup = function(self,value)
			if self.IsTrailer then return end
			
			self:LoadSystem("Engine",{
				RotationAmperageAcceleration = 360*1.8/120,
				ResistanceRotationDeceleration = 0.003,

				GeneratorRotationPenalty = 0,
				GeneratorRotationAmperage = 360*3.44/200,
				GeneratorAmperageDeceleration = 360*7/200,
				
				WheelRadius = 19.5,
				
				SoundConfig = value==1 and {
					{sound = "trolleybus/engine_aksm_atcd.ogg",startspd = 0,pratestart = 0,pratemp = 0.003,volume = Volume2,endspd = 650,fadeout = 500},
					{sound = "trolleybus/engine_aksm_atcd2.ogg",startspd = 150,fadein = 500,pratestart = 0.3,pratemp = 0.001,volume = Volume2},
				} or {
					{sound = "trolleybus/engine_aksm_dta.ogg",startspd = 0,fadein = 1500,pratestart = 0,pratemp = 0.0007,volume = 3},
				},
			})
		end,
		unload = function(self,value)
			if self.IsTrailer then return end
			
			self:UnloadSystem("Engine")
		end,
	},
	Trolleybus_System.BuildSkinSpawnSetting("aksm333","trolleybus.aksm333.settings.skins"),
}

function ENT:LoadSystems()
	self:LoadSystem("AccumulatorBattery",{Voltage = 12})
	self:LoadSystem("StaticVoltageConverter",{Voltage = 14})
	self:LoadSystem("Pneumatic",{
		BrakePedalStart = 0.5,
		BrakePedalEnd = 1,
		
		MotorCompressorSpeed = 40,
		MotorCompressorSounds = {
			StartSounds = Sound("trolleybus/compress2_start.ogg"),
			LoopSound = Sound("trolleybus/compress2_loop.ogg"),
			EndSounds = Sound("trolleybus/compress2_end.ogg"),
		},

		Receivers = {
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				PneumaticDoors = {["door1"] = {400,600,0.75},["door2"] = {400,600,0.75},["door3"] = {400,600,1.5},["door4"] = {400,600,1.5},["door5"] = {400,600,1.5}},
				DefaultAir = self:GetSpawnSetting("pressure")*100,
			},
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				PneumaticDoors = {["door1"] = {400,600,0.75},["door2"] = {400,600,0.75},["door3"] = {400,600,1.5},["door4"] = {400,600,1.5},["door5"] = {400,600,1.5}},
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
		
		GetBrakeControlFraction = function(sys)
			return self:ButtonIsDown("stop_with_opened_doors") and self:DoorsIsOpened() and 1
		end,
	})
	self:LoadSystem("Handbrake",{
		MaxDeceleration = 5000,
		PneumaticAirBrake = 50,
		GetAirFromSystem = function(s,air)
			local nair = math.min(self:GetSystem("Pneumatic"):GetAir(3),air)
			self:GetSystem("Pneumatic"):SetAir(3,self:GetSystem("Pneumatic"):GetAir(3)-nair)

			return nair
		end,
	})
	self:LoadSystem("TRSU",{
		SoundName = "trolleybus/trsu_aksm321.ogg",
	})
	self:LoadSystem("HydraulicBooster",{
		MaxPowerAmperage = 2.8,
		
		SoundPos = Vector(222.5,31.26,-38.53),
		
		StartSounds = "trolleybus/hydrobooster_aksm321_start.ogg",
		LoopSound = "trolleybus/hydrobooster_aksm321_loop.ogg",
		StopSounds = "trolleybus/hydrobooster_aksm321_stop.ogg",
		SoundDistance = 750,
		SoundVolume = 1,
	})
	self:LoadSystem("Agit-132",{
		Pos = Vector(328.48,10.69,-15.65),
		Ang = Angle(0,180,0),
		PlayPos = Vector(137.52,0,34.24),
		TrailerPlayPos = Vector(-215.53,0,33.24),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(285.33,30.06,-29.51),
	})
	self:LoadSystem("Horn",{
		SoundPos = Vector(345.22,2.34,-36.03),
		ShouldActive = function(sys)
			return self:ButtonIsDown("horn")
		end,
	})
	self:LoadSystem("Reductor",{
		SoundConfig = {
			{sound = "trolleybus/reductor_aksm_zf.ogg",startspd = 0,pratestart = 0,pratemp = 0.001,volume = Volume},
		},
	})
	self:LoadSystem("Buzzer",{
		LoopSound = Sound("trolleybus/buzzer_aksm321.ogg"),
		SoundPos = Vector(330.26,30.87,-15.97),
	})
end

function ENT:DoorsIsOpened()
	local tr = IsValid(self:GetTrailer()) and self:GetTrailer()
	
	return self:DoorIsOpened("door2",true) or self:DoorIsOpened("door3",true) or tr and (tr:DoorIsOpened("door4",true) or tr:DoorIsOpened("door5",true))
end