-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "AKSM 333 Old"
ENT.Category = {"creationtab_category.default","creationtab_category.default.aksm","creationtab_category.default.aksm333"}

Trolleybus_System.WheelTypes["aksm333o"] = {
	Model = "models/trolleybus/aksm333o/wheel.mdl",
	Ang = Angle(0,90,0),
	Radius = 19.5,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["aksm333o_rear"] = {
	Model = "models/trolleybus/aksm333o/wheel2.mdl",
	Ang = Angle(0,90,0),
	Radius = 19.5,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/aksm333o/body.mdl"
ENT.HasPoles = false

ENT.PassCapacity = 100

ENT.OtherSeats = {
	{
		Type = 1,
		Pos = Vector(315,-18,-36),
		Ang = Angle(0,0,0),
		Camera = Vector(315,-18,22),
	},
}

ENT.InteriorLights = {
	{pos = Vector(185.46,0,28),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(9.75,0,28),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
}

ENT.DoorsData = {
	["door1"] = {
		model = "models/trolleybus/aksm333o/door1.mdl",
		pos = Vector(305.35,-50.63,0),
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
		model = "models/trolleybus/aksm333o/door2.mdl",
		pos = Vector(305.35,-50.63,0),
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
		model = "models/trolleybus/aksm333o/door3.mdl",
		pos = Vector(138.98,-50.52,0),
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
	Pos = Vector(297,30.5,-32),
	Ang = Angle(),
}

ENT.TrailerData = {
	class = "trolleybus_ent_aksm333o_trailer",
	pos = Vector(0,0,0),
	ang = Angle(),
	ballsocket = {
		lpos = Vector(-30,0,-50),
		trailerlpos = Vector(-93,0,-50),
		plimits = {-10,10},
		ylimits = {-40,40},
		rlimits = {-10,10},
	},
	joint = {
		model = "models/trolleybus/aksm333o/joint.mdl",
		modelpos = Vector(0,0,0),
		pos = Vector(-32.7,0,0),
		ang = Angle(0,0,0),
		bone = "Bone001",
		trailerpos = Vector(-93.5,0,0),
		trailerang = Angle(0,0,0),
		trailerbone = "Bone002",
	},
}

local btnmodel = {
	model = "models/trolleybus/aksm333o/btn1.mdl",
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
	model = "models/trolleybus/aksm333o/btn1.mdl",
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
	model = "models/trolleybus/aksm333o/btn2.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(90,0,0),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel = {
	model = "models/trolleybus/aksm333o/doorbtn1.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel2 = {
	model = "models/trolleybus/aksm333o/doorbtn2.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local avmodel = {
	model = "models/trolleybus/aksm333o/av.mdl",
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
		name = "trolleybus.aksm333o.btns.key",
		model = {
			model = "models/trolleybus/aksm333o/key.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "key",
			pos = {1.01,0.94},
			radius = 1,
		},
		toggle = true,
	},
	["handbrake"] = {
		name = "trolleybus.aksm333o.btns.handbrake",
		model = {
			model = "models/trolleybus/aksm333o/handbrake.mdl",
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
			pos = {1.49,2.03},
			radius = 2,
		},
		toggle = true,
		hotkey = KEY_V,
		externalhotkey = "Handbrake",
		func = function(self,on) self:SetHandbrakeActive(on) end,
	},
	["reverse_up"] = {
		name = "trolleybus.aksm333o.btns.reverse_up",
		model = btnmodel2,
		panel = {
			name = "prib",
			pos = {10.4,9.42},
			radius = 0.5,
		},
		hotkey = KEY_0,
		func = function(self,on) if on and self:GetReverseState()<1 then self:ChangeReverse(self:GetReverseState()+1) end end,
	},
	["reverse_down"] = {
		name = "trolleybus.aksm333o.btns.reverse_down",
		model = btnmodel2,
		panel = {
			name = "prib",
			pos = {11.38,9.43},
			radius = 0.5,
		},
		hotkey = KEY_9,
		func = function(self,on) if on and self:GetReverseState()>-1 then self:ChangeReverse(self:GetReverseState()-1) end end,
	},
	["unknown1"] = {
		name = "trolleybus.aksm333o.btns.unknown1",
		model = btnmodel,
		panel = {
			name = "prib",
			pos = {12.35,9.21},
			radius = 0.7,
		},
		toggle = true,
	},
	["unknown2"] = {
		name = "trolleybus.aksm333o.btns.unknown2",
		model = btnmodel2,
		panel = {
			name = "prib",
			pos = {4.25,9.46},
			radius = 0.7,
		},
	},
	["electricbrake"] = {
		name = "trolleybus.aksm333o.btns.electricbrake",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.6,4.8},
			radius = 0.5,
		},
		toggle = true,
	},
	["informator_play"] = {
		name = "trolleybus.aksm333o.btns.informator_play",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.68,1.6},
			radius = 0.5,
		},
		func = function(self,on) self:ToggleButton("Agit-132_Button1",on) end,
	},
	["informator_next"] = {
		name = "trolleybus.aksm333o.btns.informator_next",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.65,2.66},
			radius = 0.5,
		},
		func = function(self,on) self:ToggleButton("Agit-132_Button3",on) end,
	},
	["emergencyoff"] = {
		name = "trolleybus.aksm333o.btns.emergencyoff",
		model = btnmodel2,
		panel = {
			name = "leftprib2",
			pos = {1.19,19.12},
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
		name = "trolleybus.aksm333o.btns.hydraulic_booster",
		model = btnmodel,
		panel = {
			name = "prib",
			pos = {14.29,9.2},
			radius = 0.7,
		},
		toggle = true,
	},
	["kneeling"] = {
		name = "trolleybus.aksm333o.btns.kneeling",
		model = btnmodel,
		panel = {
			name = "prib",
			pos = {13.31,9.22},
			radius = 0.7,
		},
		toggle = true,
	},
	["polelights"] = {
		name = "trolleybus.aksm333o.btns.polelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {2.37,7.42},
			radius = 0.7,
		},
		toggle = true,
	},
	["profilelights"] = {
		name = "trolleybus.aksm333o.btns.profilelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {1.15,7.44},
			radius = 0.7,
		},
		toggle = true,
	},
	["headlights"] = {
		name = "trolleybus.aksm333o.btns.headlights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {4.87,7.45},
			radius = 0.7,
		},
		toggle = true,
		hotkey = KEY_F,
	},
	["airflow"] = {
		name = "trolleybus.aksm333o.btns.airflow",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {3.63,7.43},
			radius = 0.7,
		},
		toggle = true,
	},
	["buzzer"] = {
		name = "trolleybus.aksm333o.btns.buzzer",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.52,12.71},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinevent"] = {
		name = "trolleybus.aksm333o.btns.cabinevent",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {0.96,14.56},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorlight"] = {
		name = "trolleybus.aksm333o.btns.interiorlight",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {9.84,5.29},
			radius = 0.7,
		},
		toggle = true,
	},
	["pneumaticpolecatchers"] = {
		name = "trolleybus.aksm333o.btns.pneumaticpolecatchers",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.52,14.57},
			radius = 0.7,
		},
		toggle = true,
	},
	["stop_with_opened_doors"] = {
		name = "trolleybus.aksm333o.btns.stop_with_opened_doors",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.75,16.41},
			radius = 0.7,
		},
		toggle = true,
	},
	["schedulelight"] = {
		name = "trolleybus.aksm333o.btns.schedulelight",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {1.2,3.88},
			radius = 0.7,
		},
		toggle = true,
	},
	["550v"] = {
		name = "trolleybus.aksm333o.btns.550v",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {7.44,5.25},
			radius = 0.7,
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["mirrorheat"] = {
		name = "trolleybus.aksm333o.btns.mirrorheat",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {8.61,5.26},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinelight"] = {
		name = "trolleybus.aksm333o.btns.cabinelight",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {0.95,12.67},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorheater"] = {
		name = "trolleybus.aksm333o.btns.interiorheater",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {12.14,5.34},
			radius = 0.7,
		},
		toggle = true,
	},
	["intheatervent"] = {
		name = "trolleybus.aksm333o.btns.intheatervent",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {10.95,5.29},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabineheat"] = {
		name = "trolleybus.aksm333o.btns.cabineheat",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.77,7.28},
			radius = 0.7,
		},
		toggle = true,
	},
	["doorbtn1"] = {
		name = "trolleybus.aksm333o.btns.doorbtn1",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.7,1.19},
			radius = 0.5,
		},
		hotkey = KEY_3,
		func = function(self,on) if on then self:OpenDoor("door1") end end,
	},
	["doorbtn2"] = {
		name = "trolleybus.aksm333o.btns.doorbtn2",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.7,2.16},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door2") end end,
	},
	["doorbtn3"] = {
		name = "trolleybus.aksm333o.btns.doorbtn3",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.7,3.05},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door3") end end,
	},
	["doorbtn4"] = {
		name = "trolleybus.aksm333o.btns.doorbtn4",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.7,4.07},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():OpenDoor("door4") end end,
	},
	["doorbtn5"] = {
		name = "trolleybus.aksm333o.btns.doorbtn5",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.7,5.07},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():OpenDoor("door5") end end,
	},
	["doorbtn6"] = {
		name = "trolleybus.aksm333o.btns.doorbtn6",
		model = {
			model = "models/trolleybus/aksm333o/doorbtn_open.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(-90,0,180),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "doorsprib",
			pos = {2.46,1.6},
			radius = 1.25,
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
		name = "trolleybus.aksm333o.btns.doorbtn7",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.7,1.19},
			radius = 0.5,
		},
		hotkey = KEY_4,
		func = function(self,on) if on then self:CloseDoor("door1") end end,
	},
	["doorbtn8"] = {
		name = "trolleybus.aksm333o.btns.doorbtn8",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.7,2.16},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door2") end end,
	},
	["doorbtn9"] = {
		name = "trolleybus.aksm333o.btns.doorbtn9",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.7,3.05},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door3") end end,
	},
	["doorbtn10"] = {
		name = "trolleybus.aksm333o.btns.doorbtn10",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.7,4.07},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():CloseDoor("door4") end end,
	},
	["doorbtn11"] = {
		name = "trolleybus.aksm333o.btns.doorbtn11",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.7,5.07},
			radius = 0.5,
		},
		func = function(self,on) if on then self:GetTrailer():CloseDoor("door5") end end,
	},
	["doorbtn12"] = {
		name = "trolleybus.aksm333o.btns.doorbtn12",
		model = {
			model = "models/trolleybus/aksm333o/doorbtn_close.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(-90,0,180),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "doorsprib",
			pos = {5.08,1.6},
			radius = 1.25,
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
		name = "trolleybus.aksm333o.btns.emergency",
		model = {
			model = "models/trolleybus/aksm333o/emergency.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "prib",
			pos = {1.57,9.38},
			radius = 0.5,
		},
		hotkey = KEY_B,
		externalhotkey = "Emergency",
		func = function(self,on) if on then self.EmergencySignal = !self.EmergencySignal end end,
	},
	["unknown4"] = {
		name = "trolleybus.aksm333o.btns.unknown4",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {1.29,4.37},
			radius = 2,
		},
		toggle = true,
	},
	["converter"] = {
		name = "trolleybus.aksm333o.btns.converter",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {15.98,8.9},
			radius = 2,
		},
		toggle = true,
	},
	["unknown6"] = {
		name = "trolleybus.aksm333o.btns.unknown6",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.58,8.96},
			radius = 2,
		},
		toggle = true,
	},
	["sequence"] = {
		name = "trolleybus.aksm333o.btns.sequence",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {15.98,1.92},
			radius = 2,
		},
		toggle = true,
	},
	["compressor"] = {
		name = "trolleybus.aksm333o.btns.compressor",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.59,1.91},
			radius = 2,
		},
		toggle = true,
	},
	["horn"] = {
		name = "trolleybus.aksm333o.btns.horn",
		model = {
			model = "models/trolleybus/aksm333o/hornbtn.mdl",
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
		name = "trolleybus.aksm333o.btns.door1toggleoutside",
		model = btnmodel2,
		panel = {
			name = "door1toggleoutside",
			pos = {0.5,0.5},
			radius = 0.5,
		},
		func = function(self,on) if on then if self:DoorIsOpened("door1") then self:CloseDoor("door1") else self:OpenDoor("door1") end end end,
	},
	["door1manual"] = {
		name = "trolleybus.aksm333o.btns.door1manual",
		panel = {
			name = "door1manual",
			pos = {0,0},
			size = {25,75},
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
	["doorlights"] = {
		name = "trolleybus.aksm333o.btns.doorlights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {1.15,5.66},
			radius = 0.7,
		},
		toggle = true,
	},
}

ENT.PanelsData = {
	["key"] = {
		pos = Vector(318.54,31.49,-18.06),
		ang = Angle(-70,-180,0),
		size = {2,2},
	},
	["rightprib"] = {
		pos = Vector(328.9,20.08,-11.51),
		ang = Angle(-54.8,166.5,-4.5),
		size = {7,6},
	},
	["doorsprib"] = {
		pos = Vector(331.5,19.02,-9.91),
		ang = Angle(-54.8,167.3,-5.7),
		size = {7,3},
	},
	["leftprib"] = {
		pos = Vector(329.04,48.52,-10.2),
		ang = Angle(-56.2,-164.3,7.4),
		size = {6,9},
	},
	["prib"] = {
		pos = Vector(332.41,38.57,-9.13),
		ang = Angle(-53.6,-180,0),
		size = {15,10},
	},
	["leftprib2"] = {
		pos = Vector(317.02,48.95,-19.76),
		ang = Angle(-90,-180,0),
		size = {4,20},
	},
	["avs"] = {
		pos = Vector(277.07,25.42,29.06),
		ang = Angle(0,3.7,0),
		size = {20,11},
	},
	["ups"] = {
		pos = Vector(306.72,39.65,42.71),
		ang = Angle(23.3,-90,0),
		size = {13,7},
	},
	["pedals"] = {
		pos = Vector(331,41.61,-37.71),
		ang = Angle(-90,-180,0),
		size = {22,10},
	},
	["guitar_left"] = {
		pos = Vector(318.24,41.04,-15.88),
		ang = Angle(-110,0,-90),
		size = {4,6},
	},
	["guitar_right"] = {
		pos = Vector(318.24,26,-15.88),
		ang = Angle(-110,0,-90),
		size = {4,6},
	},
	["door1toggleoutside"] = {
		pos = Vector(334.41,-50.92,-21.75),
		ang = Angle(0,-90,0),
		size = {1,1},
	},
	["door1manual"] = {
		pos = Vector(307.92,-51.15,30.49),
		ang = Angle(0,-90,0),
		size = {25,75},
	},
}

local function IndicatorLamp(name,panel,x,y,type,check)
	local off = type
	local on = type+13

	return {
		name = name,
		model = "models/trolleybus/aksm333o/indicatorlamp.mdl",
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
		model = "models/trolleybus/aksm333o/pedal.mdl",
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
		model = "models/trolleybus/aksm333o/pedal.mdl",
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
	["indicatorlamp_battery"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.accbattery","prib",2,2.97,0,function(self)
		return false
	end),
	["indicatorlamp_brake"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.brake","prib",3,2.97,1,function(self)
		return self:GetRearLights()==1
	end),
	["indicatorlamp_mirrorheat"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.mirrorheat","prib",4,2.97,2,function(self)
		return self:ButtonIsDown("mirrorheat")
	end),
	["indicatorlamp_doors"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.doors","prib",5,2.97,3,function(self)
		return self:DoorsIsOpened()
	end),
	["indicatorlamp_profilelights"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.profilelights","prib",6,2.97,4,function(self)
		return self:GetProfileLights()>0
	end),
	["indicatorlamp_headlights"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.headlights","prib",7,2.97,5,function(self)
		return self:GetHeadLights()>0
	end),
	["indicatorlamp_turnsignal"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.turnsignal","prib",8,2.97,6,function(self)
		return self:GetTurnSignal()!=0 and Trolleybus_System.TurnSignalTickActive(self)
	end),
	["indicatorlamp_emergency"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.emergency","prib",9,2.97,7,function(self)
		return self:GetEmergencySignal()
	end),
	["indicatorlamp_lowair1"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.lowair1","prib",10,2.97,8,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<125 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair2"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.lowair2","prib",11,2.97,9,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<250 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair3"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.lowair3","prib",12,2.97,10,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<375 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair4"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.lowair4","prib",13,2.97,11,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<500 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_handbrake"] = IndicatorLamp("trolleybus.aksm333o.indicatorlamps.handbrake","prib",14,2.97,12,function(self)
		return self:GetHandbrakeActive()
	end),
}

Trolleybus_System.BuildMultiButton(ENT,"guitar_left","guitar_left","trolleybus.aksm333o.btns.turnleft","trolleybus.aksm333o.btns.turnright",{
	model = "models/trolleybus/aksm333o/guitar_left.mdl",
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

Trolleybus_System.BuildMultiButton(ENT,"guitar_right","guitar_right","trolleybus.aksm333o.btns.wipers1","trolleybus.aksm333o.btns.wipers2",{
	model = "models/trolleybus/aksm333o/guitar_right.mdl",
	offset_ang = Angle(0,90,90),
	offset_pos = Vector(0,0,4),
	poseparameter = "state",
	maxdrawdistance = 200,
},0,0,4,6,function(self,ent,state) return state==-1 and 0 or state==1 and 1 or 0.5 end)

Trolleybus_System.BuildMultiButton(ENT,"driverseat_heater","leftprib","trolleybus.aksm333o.btns.driverseatheater_left","trolleybus.aksm333o.btns.driverseatheater_right",{
	model = "models/trolleybus/aksm333o/btn3.mdl",
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
},3.15,4.52,1.3,1.5,function(self,ent,state) return state/6 end,nil,nil,false,nil,nil,0,6)

local function SetupNameplates(self,color)
	local clear1 = Trolleybus_System.BuildNameplatePanel(self,"nameplate_front",Vector(339.51,-33.66,43.94),Angle(0,0,0),67.3,9,2,"Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.RouteNumber","Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.Route",8,color,true)
	
	local clear2 = Trolleybus_System.BuildInteriorNameplate(self,"int_nameplate",Vector(253.02,16.2,43.82),Angle(0,-180,0),42.9,2.9,function(self)
		if !self:GetNWVar("LowPower") then return end
		
		return self.SystemsLoaded and self:GetSystem("Agit-132"):GetStopText(true)
	end,"Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.Integral",200,color,10)
	
	return function() clear1() clear2() end
end

Trolleybus_System.BuildDialGauge(ENT,"speedometer","trolleybus.aksm333o.dialgauge.speedometer","prib",7.96,6.54,2.5,-77,function(self,ent)
	return !self.SystemsLoaded and 0 or -(math.abs(self:GetSystem("Engine"):GetMoveSpeed())-20)*2.15
end,"models/trolleybus/aksm333o/speedometer.mdl",nil,Vector(0.6,0,0))

Trolleybus_System.BuildDialGauge(ENT,"linepressure1","trolleybus.aksm333o.dialgauge.pressure","prib",3.01,6.22,1.8,132,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(1)/100

	return air*9
end,"models/trolleybus/aksm333o/manometerarrow.mdl",nil,Vector(0.01,0,1.3))

Trolleybus_System.BuildDialGauge(ENT,"cylinderpressure1","","prib",3.01,6.22,0,55,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(1)/100

	return -air*11
end,"models/trolleybus/aksm333o/manometerarrow.mdl",nil,Vector(0.02,0,-0.9))

Trolleybus_System.BuildDialGauge(ENT,"linepressure2","trolleybus.aksm333o.dialgauge.pressure","prib",12.91,6.2,1.8,132,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(2)/100

	return air*9
end,"models/trolleybus/aksm333o/manometerarrow.mdl",nil,Vector(0.01,0,1.2))

Trolleybus_System.BuildDialGauge(ENT,"cylinderpressure2","","prib",12.91,6.2,0,55,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(2)/100

	return -air*11
end,"models/trolleybus/aksm333o/manometerarrow.mdl",nil,Vector(0.02,0,-1))

Trolleybus_System.BuildDialGauge(ENT,"akbvoltage","trolleybus.aksm333o.dialgauge.akbvoltage","leftprib",3.72,2.82,1.3,45,function(self,ent)
	local voltage = self:GetNWVar("LowVoltage",0)
	
	return voltage<12 and -voltage*1.4 or voltage<14 and -12*1.4-(voltage-12)*22 or -12*1.4-2*22-(voltage-14)*10
end,"models/trolleybus/aksm333o/manometerarrow.mdl",nil,Vector(0.17,0.1,-0.58))

Trolleybus_System.BuildMovingMirror(ENT,"left_mirror",Vector(319.94,49.89,12.95),Angle(0,-90,0),10,10,"models/trolleybus/aksm333o/mirror_left.mdl",Vector(335.35,51.43,19.71),Angle(0,0,0),"Bone001","Bone002",Vector(-1.8,1.5,-0.3),Angle(-1,179,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,10,3,0,-5)
Trolleybus_System.BuildMovingMirror(ENT,"middle_mirror",Vector(334.47,11.76,14.12),Angle(0,-180,0),10,10,"models/trolleybus/aksm333o/mirror_middle.mdl",Vector(330.42,0.2,30.79),Angle(0,0,0),"Bone001","Bone002",Vector(-1.72,0,0.3),Angle(0,-180,0),12,7,true,false,-35,35,-35,35,-20,10,-20,10,nil,-20,-0,-15)
Trolleybus_System.BuildMovingMirror(ENT,"right_mirror",Vector(342.52,-29.16,9.22),Angle(0,-180,0),10,10,"models/trolleybus/aksm333o/mirror_right.mdl",Vector(334.62,-52.05,22.71),Angle(0,0,0),"Bone001","Bone002",Vector(-2,-1.5,-0.7),Angle(2,179,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,-22,-2,0,-2)

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
		name = "trolleybus.aksm333o.settings.pressure",
		preview = {"trolleybus/spawnsettings_previews/aksm333o/pressure",0,8},
		min = 0,
		max = 8,
		default = 0,
	},
	{
		alias = "catchers",
		type = "ComboBox",
		name = "trolleybus.aksm333o.settings.catchers",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333o.settings.catchers.type1",preview = "trolleybus/spawnsettings_previews/aksm333o/catchers1.png"},
			{name = "trolleybus.aksm333o.settings.catchers.type2",preview = "trolleybus/spawnsettings_previews/aksm333o/catchers2.png"},
		},
		setup = function(self,value)
			if CLIENT then return end
			
			if self.IsTrailer then self:SetBodygroup(2,value-1) end
		end,
		unload = function(self,value)
			if CLIENT then return end
			
			if self.IsTrailer then self:SetBodygroup(2,0) end
		end,
	},
	{
		alias = "intcap",
		type = "ComboBox",
		name = "trolleybus.aksm333o.settings.int_cap",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333o.settings.int_cap.type1",preview = "trolleybus/spawnsettings_previews/aksm333o/intcap1.png"},
			{name = "trolleybus.aksm333o.settings.int_cap.type2",preview = "trolleybus/spawnsettings_previews/aksm333o/intcap2.png"},
		},
		setup = function(self,value)
			if CLIENT then return end
			
			if self.IsTrailer then self:SetBodygroup(4,value-1) end
		end,
		unload = function(self,value)
			if CLIENT then return end
			
			if self.IsTrailer then self:SetBodygroup(4,0) end
		end,
	},
	{
		alias = "handrails_part",
		type = "CheckBox",
		name = "trolleybus.aksm333o.settings.handrails_part",
		default = true,
		preview_on = "trolleybus/spawnsettings_previews/aksm333o/handrailspart1.png",
		preview_off = "trolleybus/spawnsettings_previews/aksm333o/handrailspart2.png",
		setup = function(self,value)
			if CLIENT then return end
			
			if self.IsTrailer then self:SetBodygroup(3,value and 0 or 1) end
		end,
		unload = function(self,value)
			if CLIENT then return end
			
			if self.IsTrailer then self:SetBodygroup(3,0) end
		end,
	},
	{
		alias = "seats",
		type = "ComboBox",
		name = "trolleybus.aksm333o.settings.seats",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333o.settings.seats.type1",preview = "trolleybus/spawnsettings_previews/aksm333o/seats1.png"},
			{name = "trolleybus.aksm333o.settings.seats.type2",preview = "trolleybus/spawnsettings_previews/aksm333o/seats2.png"},
			{name = "trolleybus.aksm333o.settings.seats.type3",preview = "trolleybus/spawnsettings_previews/aksm333o/seats3.png"},
		},
	},
	{
		alias = "wnddet",
		type = "ComboBox",
		name = "trolleybus.aksm333o.settings.wnddet",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333o.settings.wnddet.type1",preview = "trolleybus/spawnsettings_previews/aksm333o/wnddet1.png"},
			{name = "trolleybus.aksm333o.settings.wnddet.type2",preview = "trolleybus/spawnsettings_previews/aksm333o/wnddet2.png"},
		},
		setup = function(self,value)
			if CLIENT then return end
			
			self:SetBodygroup(self.IsTrailer and 5 or 4,value-1)
		end,
		unload = function(self,value)
			if CLIENT then return end
			
			self:SetBodygroup(self.IsTrailer and 5 or 4,0)
		end,
	},
	{
		alias = "head",
		type = "ComboBox",
		name = "trolleybus.aksm333o.settings.head",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333o.settings.head.type1",preview = "trolleybus/spawnsettings_previews/aksm333o/head1.png"},
			{name = "trolleybus.aksm333o.settings.head.type2",preview = "trolleybus/spawnsettings_previews/aksm333o/head2.png"},
		},
		setup = function(self,value)
			if self.IsTrailer then return end
			
			if SERVER then
				self:SetBodygroup(5,value-1)
				self:SetBodygroup(2,value==1 and 1 or 0)
			else
				self.HeadLights = value==1 and self.HeadLights1 or self.HeadLights2
				self.TurnSignalLeft = value==1 and self.TurnSignalLeft1 or self.TurnSignalLeft2
				self.TurnSignalRight = value==1 and self.TurnSignalRight1 or self.TurnSignalRight2
				self.ProfileLights = value==1 and self.ProfileLights1 or self.ProfileLights2
			end
		end,
		unload = function(self,value)
			if self.IsTrailer then return end
			
			if SERVER then
				self:SetBodygroup(5,0)
				self:SetBodygroup(2,0)
			else
				self.HeadLights = self.HeadLights1
				self.TurnSignalLeft = self.TurnSignalLeft1
				self.TurnSignalRight = self.TurnSignalRight1
				self.ProfileLights = self.ProfileLights1
			end
		end,
	},
	{
		alias = "routecolor",
		type = "ComboBox",
		name = "trolleybus.aksm333o.settings.routecolor",
		default = 1,
		choices = {
			{name = "trolleybus.aksm333o.settings.routecolor.type1",preview = "trolleybus/spawnsettings_previews/aksm333o/routecolor1.png"},
			{name = "trolleybus.aksm333o.settings.routecolor.type2",preview = "trolleybus/spawnsettings_previews/aksm333o/routecolor2.png"},
		},
		setup = function(self,value)
			local color = value==2 and Color(120,200,0) or Color(255,155,0)
			
			self.NameplatesUnload = self.IsTrailer and self:_SetupNameplates(color) or SetupNameplates(self,color)
		end,
		unload = function(self,value)
			if self.NameplatesUnload then self.NameplatesUnload() self.NameplatesUnload = nil end
		end,
	},
	{
		alias = "engine",
		type = "ComboBox",
		name = "trolleybus.aksm333o.settings.engine",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm333o.settings.engine.atcd",preview = "trolleybus/spawnsettings_previews/aksm333o/atcd.wav"},
			{name = "trolleybus.aksm333o.settings.engine.dta",preview = "trolleybus/spawnsettings_previews/aksm333o/dta.wav"},
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
	Trolleybus_System.BuildSkinSpawnSetting("aksm333o","trolleybus.aksm333o.settings.skins"),
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
		
		SoundPos = Vector(216.15,34.62,-41.86),
		
		StartSounds = "trolleybus/hydrobooster_aksm321_start.ogg",
		LoopSound = "trolleybus/hydrobooster_aksm321_loop.ogg",
		StopSounds = "trolleybus/hydrobooster_aksm321_stop.ogg",
		SoundDistance = 750,
		SoundVolume = 1,
	})
	self:LoadSystem("Agit-132",{
		Pos = Vector(323.8,10.69,-17.65),
		Ang = Angle(0,180,0),
		PlayPos = Vector(137.52,0,34.24),
		TrailerPlayPos = Vector(-215.53,0,33.24),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(281.73,29.52,-33.02),
	})
	self:LoadSystem("Horn",{
		SoundPos = Vector(339.74,-0.1,-35.61),
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
		SoundPos = Vector(325.87,30.07,-18.38),
	})
end

function ENT:DoorsIsOpened()
	local tr = IsValid(self:GetTrailer()) and self:GetTrailer()
	
	return self:DoorIsOpened("door2",true) or self:DoorIsOpened("door3",true) or tr and (tr:DoorIsOpened("door4",true) or tr:DoorIsOpened("door5",true))
end