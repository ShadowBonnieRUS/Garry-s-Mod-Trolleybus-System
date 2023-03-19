-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "AKSM 321"
ENT.Category = {"creationtab_category.default","creationtab_category.default.aksm","creationtab_category.default.aksm321"}

Trolleybus_System.WheelTypes["aksm321"] = {
	Model = "models/trolleybus/aksm321/wheel.mdl",
	Ang = Angle(0,-90,0),
	Radius = 19.6,
	RotateAxis = Angle(1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["aksm321_rear"] = {
	Model = "models/trolleybus/aksm321/wheel2.mdl",
	Ang = Angle(0,-90,0),
	Radius = 19.6,
	RotateAxis = Angle(1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/aksm321/body.mdl"
ENT.HasPoles = true
ENT.TrolleyPoleLength = 262.5
ENT.TrolleyPolePos = Vector(3.56,0,65.2)
ENT.TrolleyPoleSideDist = 8.9
ENT.TrolleyPoleDownedAngleLeft = Angle(-2,179.8,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-2,-179.8,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-6,179,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-6,-179,0)

ENT.PassCapacity = 115

ENT.OtherSeats = {
	{
		Type = 1,
		Pos = Vector(205,-20,-36),
		Ang = Angle(0,0,0),
		Camera = Vector(205,-20,22),
	},
}

ENT.InteriorLights = {
	{pos = Vector(0,0,24),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(-130,0,24),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(130,0,24),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
}

ENT.DoorsData = {
	["door1"] = {
		model = "models/trolleybus/aksm321/door1.mdl",
		pos = Vector(195,-50.5,0.2),
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
		model = "models/trolleybus/aksm321/door2.mdl",
		pos = Vector(195,-50.5,0.2),
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
		model = "models/trolleybus/aksm321/door3.mdl",
		pos = Vector(-1.5,-50.5,0.2),
		ang = Angle(0,0),
		opensoundstart = {"trolleybus/door_aksm321_start_open.ogg",500},
		opensoundend = {"trolleybus/door_aksm321_end.ogg",500},
		movesound = {"trolleybus/door_aksm321_move.ogg",500},
		closesoundstart = {"trolleybus/door_aksm321_start_close.ogg",500},
		closesoundend = {"trolleybus/door_aksm321_end.ogg",500},
		poseparameter = "state",
		speedmult = 1,
	},
	["door4"] = {
		model = "models/trolleybus/aksm321/door4.mdl",
		pos = Vector(-169.2,-50.5,0.2),
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
	Pos = Vector(187,30,-30),
	Ang = Angle(),
}

local btnmodel = {
	model = "models/trolleybus/aksm321/btn1.mdl",
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
	model = "models/trolleybus/aksm321/btn1.mdl",
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
	model = "models/trolleybus/aksm321/btn2.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(90,0,0),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel = {
	model = "models/trolleybus/aksm321/doorbtn_left.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel2 = {
	model = "models/trolleybus/aksm321/doorbtn_right.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local avmodel = {
	model = "models/trolleybus/aksm321/av.mdl",
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
		name = "trolleybus.aksm321.btns.key",
		model = {
			model = "models/trolleybus/aksm321/key.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "key",
			pos = {1.12,0.71},
			radius = 1,
		},
		toggle = true,
	},
	["handbrake"] = {
		name = "trolleybus.aksm321.btns.handbrake",
		model = {
			model = "models/trolleybus/aksm321/handbrake.mdl",
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
			pos = {1.63,1.95},
			radius = 2,
		},
		toggle = true,
		hotkey = KEY_V,
		externalhotkey = "Handbrake",
		func = function(self,on) self:SetHandbrakeActive(on) end,
	},
	["reverse_up"] = {
		name = "trolleybus.aksm321.btns.reverse_up",
		model = btnmodel2,
		panel = {
			name = "prib",
			pos = {10.15,9.33},
			radius = 0.5,
		},
		hotkey = KEY_0,
		func = function(self,on) if on and self:GetReverseState()<1 then self:ChangeReverse(self:GetReverseState()+1) end end,
	},
	["reverse_down"] = {
		name = "trolleybus.aksm321.btns.reverse_down",
		model = btnmodel2,
		panel = {
			name = "prib",
			pos = {11.13,9.34},
			radius = 0.5,
		},
		hotkey = KEY_9,
		func = function(self,on) if on and self:GetReverseState()>-1 then self:ChangeReverse(self:GetReverseState()-1) end end,
	},
	["informator_play"] = {
		name = "trolleybus.aksm321.btns.informator_play",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.69,1.56},
			radius = 0.5,
		},
		func = function(self,on) self:ToggleButton("Agit-132_Button1",on) end,
	},
	["informator_next"] = {
		name = "trolleybus.aksm321.btns.informator_next",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.66,2.63},
			radius = 0.5,
		},
		func = function(self,on) self:ToggleButton("Agit-132_Button3",on) end,
	},
	["stop_with_opened_doors"] = {
		name = "trolleybus.aksm321.btns.stop_with_opened_doors",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.88,16.35},
			radius = 0.7,
		},
		toggle = true,
	},
	["emergencyoff"] = {
		name = "trolleybus.aksm321.btns.emergencyoff",
		model = btnmodel2,
		panel = {
			name = "leftprib2",
			pos = {1.33,19.04},
			radius = 0.5,
		},
		func = function(self,on)
			if on then
				self:ToggleButton("550v",false)
				self:ToggleButton("compressor",false)
				self:ToggleButton("hydraulic_booster",false)
				self:ToggleButton("unknown1",false)
				self:ToggleButton("polelights",false)
				self:ToggleButton("headlights",false)
				self:ToggleButton("profilelights",false)
				self:ToggleButton("airflow",false)
				self:ToggleButton("buzzer",false)
				self:ToggleButton("interiorlight",false)
				self:ToggleButton("schedulelight",false)
				self:ToggleButton("mirrorheat",false)
				self:ToggleButton("cabinelight",false)
				self:ToggleButton("interiorheater",false)
				self:ToggleButton("intheatervent",false)
				self:ToggleButton("cabineheat",false)
				self:ToggleButton("sequence",false)
				self:ToggleButton("converter",false)
				self:ToggleButton("pneumaticpolecatchers",false)
				self:ToggleButton("kneeling",false)
				self:ToggleButton("electricbrake",false)
				self:ToggleButton("cabinevent",false)
				self:ToggleButton("unknown4",false)
				self:ToggleButton("unknown6",false)
			end
		end,
	},
	["hydraulic_booster"] = {
		name = "trolleybus.aksm321.btns.hydraulic_booster",
		model = btnmodel,
		panel = {
			name = "prib",
			pos = {14.06,9.13},
			radius = 0.7,
		},
		toggle = true,
	},
	["kneeling"] = {
		name = "trolleybus.aksm321.btns.kneeling",
		model = btnmodel,
		panel = {
			name = "prib",
			pos = {13.07,9.17},
			radius = 0.7,
		},
		toggle = true,
	},
	["unknown1"] = {
		name = "trolleybus.aksm321.btns.unknown1",
		model = btnmodel,
		panel = {
			name = "prib",
			pos = {12.09,9.16},
			radius = 0.7,
		},
		toggle = true,
	},
	["unknown2"] = {
		name = "trolleybus.aksm321.btns.unknown2",
		model = btnmodel2,
		panel = {
			name = "prib",
			pos = {3.96,9.37},
			radius = 0.7,
		},
	},
	["electricbrake"] = {
		name = "trolleybus.aksm321.btns.electricbrake",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.61,4.77},
			radius = 0.7,
		},
		toggle = true,
	},
	["polelights"] = {
		name = "trolleybus.aksm321.btns.polelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {2.34,7.89},
			radius = 0.7,
		},
		toggle = true,
	},
	["profilelights"] = {
		name = "trolleybus.aksm321.btns.profilelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {1.13,7.78},
			radius = 0.7,
		},
		toggle = true,
	},
	["headlights"] = {
		name = "trolleybus.aksm321.btns.headlights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {4.72,7.99},
			radius = 0.7,
		},
		toggle = true,
		hotkey = KEY_F,
	},
	["airflow"] = {
		name = "trolleybus.aksm321.btns.airflow",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {3.52,7.94},
			radius = 0.7,
		},
		toggle = true,
	},
	["buzzer"] = {
		name = "trolleybus.aksm321.btns.buzzer",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.65,12.59},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinevent"] = {
		name = "trolleybus.aksm321.btns.cabinevent",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {1.09,14.5},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorlight"] = {
		name = "trolleybus.aksm321.btns.interiorlight",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {9.71,5.26},
			radius = 0.7,
		},
		toggle = true,
	},
	["pneumaticpolecatchers"] = {
		name = "trolleybus.aksm321.btns.pneumaticpolecatchers",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.65,14.5},
			radius = 0.7,
		},
		toggle = true,
	},
	["schedulelight"] = {
		name = "trolleybus.aksm321.btns.schedulelight",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {1.29,3.95},
			radius = 0.7,
		},
		toggle = true,
	},
	["550v"] = {
		name = "trolleybus.aksm321.btns.550v",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {7.34,5.2},
			radius = 0.7,
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["mirrorheat"] = {
		name = "trolleybus.aksm321.btns.mirrorheat",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {8.53,5.2},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinelight"] = {
		name = "trolleybus.aksm321.btns.cabinelight",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {1.08,12.59},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorheater"] = {
		name = "trolleybus.aksm321.btns.interiorheater",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {12,5.27},
			radius = 0.7,
		},
		toggle = true,
	},
	["intheatervent"] = {
		name = "trolleybus.aksm321.btns.intheatervent",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {10.85,5.25},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabineheat"] = {
		name = "trolleybus.aksm321.btns.cabineheat",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.9,7.2},
			radius = 0.7,
		},
		toggle = true,
	},
	["doorbtn1"] = {
		name = "trolleybus.aksm321.btns.doorbtn1",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.67,2.11},
			radius = 0.5,
		},
		hotkey = KEY_3,
		func = function(self,on) if on then self:OpenDoor("door1") end end,
	},
	["doorbtn2"] = {
		name = "trolleybus.aksm321.btns.doorbtn2",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.67,3.06},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door2") end end,
	},
	["doorbtn3"] = {
		name = "trolleybus.aksm321.btns.doorbtn3",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.67,4.02},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door3") end end,
	},
	["doorbtn4"] = {
		name = "trolleybus.aksm321.btns.doorbtn4",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.67,5},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door4") end end,
	},
	["doorbtn5"] = {
		name = "trolleybus.aksm321.btns.doorbtn5",
		model = {
			model = "models/trolleybus/aksm321/doorbtn_open.mdl",
			poseparameter = "state",
			maxdrawdistance = 200,
			offset_ang = Angle(-90,0,180),
		},
		panel = {
			name = "doorsprib",
			pos = {2,1.71},
			radius = 1.2,
		},
		hotkey = KEY_1,
		func = function(self,on)
			if on then
				self:OpenDoor("door2")
				self:OpenDoor("door3")
				self:OpenDoor("door4")
			end
		end,
	},
	["doorbtn6"] = {
		name = "trolleybus.aksm321.btns.doorbtn6",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.72,2.11},
			radius = 0.5,
		},
		hotkey = KEY_4,
		func = function(self,on) if on then self:CloseDoor("door1") end end,
	},
	["doorbtn7"] = {
		name = "trolleybus.aksm321.btns.doorbtn7",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.72,3.06},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door2") end end,
	},
	["doorbtn8"] = {
		name = "trolleybus.aksm321.btns.doorbtn8",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.72,4.02},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door3") end end,
	},
	["doorbtn9"] = {
		name = "trolleybus.aksm321.btns.doorbtn9",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.72,5},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door4") end end,
	},
	["doorbtn10"] = {
		name = "trolleybus.aksm321.btns.doorbtn10",
		model = {
			model = "models/trolleybus/aksm321/doorbtn_close.mdl",
			poseparameter = "state",
			maxdrawdistance = 200,
			offset_ang = Angle(-90,0,180),
		},
		panel = {
			name = "doorsprib",
			pos = {4.5,1.71},
			radius = 1.2,
		},
		hotkey = KEY_2,
		func = function(self,on)
			if on then
				self:CloseDoor("door2")
				self:CloseDoor("door3")
				self:CloseDoor("door4")
			end
		end,
	},
	["emergency"] = {
		name = "trolleybus.aksm321.btns.emergency",
		model = {
			model = "models/trolleybus/aksm321/emergency.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "prib",
			pos = {1.33,9.35},
			radius = 0.5,
		},
		hotkey = KEY_B,
		externalhotkey = "Emergency",
		func = function(self,on) if on then self.EmergencySignal = !self.EmergencySignal end end,
	},
	["unknown4"] = {
		name = "trolleybus.aksm321.btns.unknown4",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {3.7,6.56},
			radius = 2,
		},
		toggle = true,
	},
	["converter"] = {
		name = "trolleybus.aksm321.btns.converter",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.34,10.92},
			radius = 2,
		},
		toggle = true,
	},
	["unknown6"] = {
		name = "trolleybus.aksm321.btns.unknown6",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {20.97,10.94},
			radius = 2,
		},
		toggle = true,
	},
	["sequence"] = {
		name = "trolleybus.aksm321.btns.sequence",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.34,3.85},
			radius = 2,
		},
		toggle = true,
	},
	["compressor"] = {
		name = "trolleybus.aksm321.btns.compressor",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {20.97,3.84},
			radius = 2,
		},
		toggle = true,
	},
	["horn"] = {
		name = "trolleybus.aksm321.btns.horn",
		model = {
			model = "models/trolleybus/aksm321/hornbtn.mdl",
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
		name = "trolleybus.aksm321.btns.door1toggleoutside",
		model = btnmodel2,
		panel = {
			name = "door1toggleoutside",
			pos = {0.5,0.5},
			radius = 0.5,
		},
		func = function(self,on)
			if on then
				if self:DoorIsOpened("door1") then
					self:CloseDoor("door1")
				else
					self:OpenDoor("door1")
				end
			end
		end,
	},
	["door1manual"] = {
		name = "trolleybus.aksm321.btns.door1manual",
		panel = {
			name = "door1manual",
			pos = {0,0},
			size = {25,80},
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
		name = "trolleybus.aksm321.btns.doorlights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {1.2,5.87},
			radius = 0.7,
		},
		toggle = true,
	},
}

ENT.PanelsData = {
	["key"] = {
		pos = Vector(208.07,31.59,-16.23),
		ang = Angle(-72,-180,0),
		size = {2,2},
	},
	["rightprib"] = {
		pos = Vector(218.6,20.09,-9.56),
		ang = Angle(-54.4,166.2,-4.1),
		size = {7,6},
	},
	["doorsprib"] = {
		pos = Vector(220.99,18.71,-8.1),
		ang = Angle(-54.9,167.2,-4.1),
		size = {6,3},
	},
	["leftprib"] = {
		pos = Vector(218.78,48.6,-8.26),
		ang = Angle(-56,-164.6,8.5),
		size = {6,9},
	},
	["prib"] = {
		pos = Vector(222.1,38.3,-7.21),
		ang = Angle(-53.7,-179.9,-0.2),
		size = {15,10},
	},
	["leftprib2"] = {
		pos = Vector(206.67,49.07,-17.82),
		ang = Angle(-90,170,10),
		size = {4,20},
	},
	["avs"] = {
		pos = Vector(166.93,23.04,33),
		ang = Angle(179.9,-176.3,-180),
		size = {23,14},
	},
	["ups"] = {
		pos = Vector(196.56,39.68,44.59),
		ang = Angle(156.7,89.6,179.9),
		size = {13,6},
	},
	["pedals"] = {
		pos = Vector(222,42,-36.18),
		ang = Angle(-90,-180,0),
		size = {23,15},
	},
	["guitar_left"] = {
		pos = Vector(208,41.07,-13.92),
		ang = Angle(-107.8,0,-90),
		size = {4,6},
	},
	["guitar_right"] = {
		pos = Vector(208,26,-14),
		ang = Angle(-110,0,-90),
		size = {4,6},
	},
	["door1toggleoutside"] = {
		pos = Vector(224.37,-50.92,-19.5),
		ang = Angle(0,-90,0),
		size = {1,1},
	},
	["door1manual"] = {
		pos = Vector(195.84,-50.45,31.68),
		ang = Angle(0,-90,0),
		size = {25,80},
	},
	/*["screen"] = {
		pos = Vector(187.4,40.3,17.3),
		ang = Angle(0,3,0),
		size = {3,2.26},
	}*/
}

local function IndicatorLamp(name,panel,x,y,type,check)
	local off = type
	local on = type+13

	return {
		name = name,
		model = "models/trolleybus/aksm321/indicatorlamp.mdl",
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
		model = "models/trolleybus/aksm321/pedal.mdl",
		panel = {
			name = "pedals",
			pos = {16.92,6.51},
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
		model = "models/trolleybus/aksm321/pedal.mdl",
		panel = {
			name = "pedals",
			pos = {5.86,6.51},
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
	["indicatorlamp_battery"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.accbattery","prib",1.64,2.89,0,function(self)
		return false
	end),
	["indicatorlamp_brake"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.brake","prib",2.64,2.89,1,function(self)
		return self:GetRearLights()==1
	end),
	["indicatorlamp_mirrorheat"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.mirrorheat","prib",3.64,2.89,2,function(self)
		return self:ButtonIsDown("mirrorheat")
	end),
	["indicatorlamp_doors"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.doors","prib",4.64,2.89,3,function(self)
		return self:DoorsIsOpened()
	end),
	["indicatorlamp_profilelights"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.profilelights","prib",5.64,2.89,4,function(self)
		return self:GetProfileLights()>0
	end),
	["indicatorlamp_headlights"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.headlights","prib",6.64,2.89,5,function(self)
		return self:GetHeadLights()>0
	end),
	["indicatorlamp_turnsignal"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.turnsignal","prib",7.64,2.89,6,function(self)
		return self:GetTurnSignal()!=0 and Trolleybus_System.TurnSignalTickActive(self)
	end),
	["indicatorlamp_emergency"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.emergency","prib",8.64,2.89,7,function(self)
		return self:GetEmergencySignal()
	end),
	["indicatorlamp_lowair1"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.lowair1","prib",9.64,2.89,8,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<125 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair2"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.lowair2","prib",10.64,2.89,9,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<250 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair3"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.lowair3","prib",11.64,2.89,10,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<375 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair4"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.lowair4","prib",12.64,2.89,11,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<500 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_handbrake"] = IndicatorLamp("trolleybus.aksm321.indicatorlamps.handbrake","prib",13.64,2.89,12,function(self)
		return self:GetHandbrakeActive()
	end),
}

Trolleybus_System.BuildMultiButton(ENT,"guitar_left","guitar_left","trolleybus.aksm321.btns.turnleft","trolleybus.aksm321.btns.turnright",{
	model = "models/trolleybus/aksm321/guitar_left.mdl",
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

Trolleybus_System.BuildMultiButton(ENT,"guitar_right","guitar_right","trolleybus.aksm321.btns.wipers1","trolleybus.aksm321.btns.wipers2",{
	model = "models/trolleybus/aksm321/guitar_right.mdl",
	offset_ang = Angle(0,90,90),
	offset_pos = Vector(0,0,4),
	poseparameter = "state",
	maxdrawdistance = 200,
},0,0,4,6,function(self,ent,state) return state==-1 and 0 or state==1 and 1 or 0.5 end)

Trolleybus_System.BuildMultiButton(ENT,"driverseat_heater","leftprib","trolleybus.aksm321.btns.driverseatheater_left","trolleybus.aksm321.btns.driverseatheater_right",{
	model = "models/trolleybus/aksm321/btn3.mdl",
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
},3.17,4.56,1.3,1.5,function(self,ent,state) return state/6 end,nil,nil,false,nil,nil,0,6)

local function SetupNameplates(self,color)
	local clear1 = Trolleybus_System.BuildNameplatePanel(self,"nameplate_front",Vector(228.86,-33.49,45.84),Angle(0,0,0),67,9,2,"Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Number","Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Name",8,color,true)
	local clear2 = Trolleybus_System.BuildNameplatePanel(self,"nameplate_right",Vector(-136.17,-50.23,47.52),Angle(-5,-90,0),60,8,2,"Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Number","Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Name",10,color,true)
	local clear3 = Trolleybus_System.BuildNameplatePanel(self,"nameplate_rear",Vector(-235.4,-30.53,47.12),Angle(-4.3,180,0),13,7,0,"Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.RearNumber",nil,nil,color,true)
	
	local clear4 = Trolleybus_System.BuildInteriorNameplate(self,"int_nameplate",Vector(142.62,14.53,45.16),Angle(0,-180,-1.8),42.7,3,function(self)
		if !self:GetNWVar("LowPower") then return end
		
		return self.SystemsLoaded and self:GetSystem("Agit-132"):GetStopText(true)
	end,"Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Integral",200,color,10)
	
	return function() clear1() clear2() clear3() clear4() end
end

Trolleybus_System.BuildDialGauge(ENT,"speedometer","trolleybus.aksm321.dialgauge.speedometer","prib",7.71,6.49,2.7,-77,function(self,ent)
	return !self.SystemsLoaded and 0 or -(math.abs(self:GetSystem("Engine"):GetMoveSpeed())-20)*2.15
end,"models/trolleybus/aksm321/speedometer.mdl",nil,Vector(0.55,0,0))

Trolleybus_System.BuildDialGauge(ENT,"akbvoltage","trolleybus.aksm321.dialgauge.akbvoltage","leftprib",3.75,2.95,1.4,40,function(self,ent)
	local voltage = self:GetNWVar("LowVoltage",0)

	return voltage<12 and -voltage*1.5 or voltage<14 and -18-(voltage-12)*22 or -18-44-(voltage-14)*10
end,"models/trolleybus/aksm321/manometerarrow.mdl",nil,Vector(0.2,0,-0.58))

Trolleybus_System.BuildDialGauge(ENT,"linepressure1","trolleybus.aksm321.dialgauge.pressure","prib",2.79,6.21,1.8,132,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(1)/100

	return air*9
end,"models/trolleybus/aksm321/manometerarrow.mdl",nil,Vector(0,0,1.3))

Trolleybus_System.BuildDialGauge(ENT,"cylinderpressure1","","prib",2.79,6.21,0,55,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(1)/100

	return -air*11
end,"models/trolleybus/aksm321/manometerarrow.mdl",nil,Vector(0,0,-0.9))

Trolleybus_System.BuildDialGauge(ENT,"linepressure2","trolleybus.aksm321.dialgauge.pressure","prib",12.68,6.08,1.8,132,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(2)/100

	return air*9
end,"models/trolleybus/aksm321/manometerarrow.mdl",nil,Vector(0,0,1.2))

Trolleybus_System.BuildDialGauge(ENT,"cylinderpressure2","","prib",12.68,6.08,0,55,function(self,ent)
	local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(2)/100

	return -air*11
end,"models/trolleybus/aksm321/manometerarrow.mdl",nil,Vector(0,0,-1))

Trolleybus_System.BuildMovingMirror(ENT,"left_mirror",Vector(208.61,49.67,13.67),Angle(0,-90,0),10,10,"models/trolleybus/aksm321/mirror_left.mdl",Vector(225.03,51.41,21.39),Angle(0,0,0),"Bone003","Bone004",Vector(-2,1.5,-0.3),Angle(-1,-179,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,10,3,0,-5)
Trolleybus_System.BuildMovingMirror(ENT,"middle_mirror",Vector(225.52,17.97,24.87),Angle(0,-180,0),10,10,"models/trolleybus/aksm321/mirror_middle.mdl",Vector(220.13,0.15,32.88),Angle(0,0,0),"Bone001","Bone002",Vector(-1.8,0,0.3),Angle(0,-180,0),11.5,6,true,false,-35,35,-35,35,-20,10,-20,10,nil,-20,-0,-15)
Trolleybus_System.BuildMovingMirror(ENT,"right_mirror",Vector(225,-26,7),Angle(0,-180,0),10,10,"models/trolleybus/aksm321/mirror_right.mdl",Vector(224.31,-51.86,24.72),Angle(0,0,0),"Bone001","Bone002",Vector(-2.2,-1,-0.7),Angle(2,168,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,-22,8,0,-2)

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
		name = "trolleybus.aksm321.settings.pressure",
		min = 0,
		max = 8,
		default = 0,
		preview = {"trolleybus/spawnsettings_previews/aksm321/pressure",0,8},
	},
	{
		alias = "seats",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.seats",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.seats.type1",preview = "trolleybus/spawnsettings_previews/aksm321/seats1.png"},
			{name = "trolleybus.aksm321.settings.seats.type2",preview = "trolleybus/spawnsettings_previews/aksm321/seats2.png"},
			{name = "trolleybus.aksm321.settings.seats.type3",preview = "trolleybus/spawnsettings_previews/aksm321/seats3.png"},
			{name = "trolleybus.aksm321.settings.seats.type4",preview = "trolleybus/spawnsettings_previews/aksm321/seats4.png"},
		},
	},
	{
		alias = "handrails",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.handrails",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.handrails.type1",preview = "trolleybus/spawnsettings_previews/aksm321/handrails1.png"},
			{name = "trolleybus.aksm321.settings.handrails.type2",preview = "trolleybus/spawnsettings_previews/aksm321/handrails2.png"},
		},
	},
	{
		alias = "catchers",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.catchers",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.catchers.type1",preview = "trolleybus/spawnsettings_previews/aksm321/catchers1.png"},
			{name = "trolleybus.aksm321.settings.catchers.type2",preview = "trolleybus/spawnsettings_previews/aksm321/catchers2.png"},
		},
	},
	{
		alias = "arcs",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.arcs",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.arcs.type1",preview = "trolleybus/spawnsettings_previews/aksm321/arcs1.png"},
			{name = "trolleybus.aksm321.settings.arcs.type2",preview = "trolleybus/spawnsettings_previews/aksm321/arcs2.png"},
			{name = "trolleybus.aksm321.settings.arcs.type3",preview = "trolleybus/spawnsettings_previews/aksm321/arcs3.png"},
		},
	},
	{
		alias = "cells",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.cells",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.cells.type1",preview = "trolleybus/spawnsettings_previews/aksm321/cells1.png"},
			{name = "trolleybus.aksm321.settings.cells.type2",preview = "trolleybus/spawnsettings_previews/aksm321/cells2.png"},
		},
	},
	{
		alias = "bodydop",
		type = "CheckBox",
		name = "trolleybus.aksm321.settings.bodydop",
		default = false,
		preview_off = "trolleybus/spawnsettings_previews/aksm321/bodydop1.png",
		preview_on = "trolleybus/spawnsettings_previews/aksm321/bodydop2.png",
	},
	{
		alias = "ee_casing",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.ee_casing",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.ee_casing.type1",preview = "trolleybus/spawnsettings_previews/aksm321/eecasing1.png"},
			{name = "trolleybus.aksm321.settings.ee_casing.type2",preview = "trolleybus/spawnsettings_previews/aksm321/eecasing2.png"},
		},
	},
	{
		alias = "head",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.head",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.head.type1",preview = "trolleybus/spawnsettings_previews/aksm321/head1.png"},
			{name = "trolleybus.aksm321.settings.head.type2",preview = "trolleybus/spawnsettings_previews/aksm321/head2.png"},
		},
		setup = function(self,value)
			if SERVER then return end
			
			self.TurnSignalLeft = value==2 and self.TurnSignalLeft1 or self.TurnSignalLeft2
			self.TurnSignalRight = value==2 and self.TurnSignalRight1 or self.TurnSignalRight2
			self.HeadLights = value==2 and self.HeadLights1 or self.HeadLights2
			self.ProfileLights = value==2 and self.ProfileLights1 or self.ProfileLights2
		end,
		unload = function(self,value)
			if SERVER then return end
			
			self.TurnSignalLeft = self.TurnSignalLeft1
			self.TurnSignalRight = self.TurnSignalRight1
			self.HeadLights = self.HeadLights1
			self.ProfileLights = self.ProfileLights1
		end
	},
	{
		alias = "intmolding",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.intmolding",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.intmolding.type1",preview = "trolleybus/spawnsettings_previews/aksm321/intmolding1.png"},
			{name = "trolleybus.aksm321.settings.intmolding.type2",preview = "trolleybus/spawnsettings_previews/aksm321/intmolding2.png"},
		},
	},
	{
		alias = "ramp",
		type = "CheckBox",
		name = "trolleybus.aksm321.settings.ramp",
		default = false,
		preview_off = "trolleybus/spawnsettings_previews/aksm321/ramp1.png",
		preview_on = "trolleybus/spawnsettings_previews/aksm321/ramp2.png",
	},
	{
		alias = "rubbers",
		type = "CheckBox",
		name = "trolleybus.aksm321.settings.rubbers",
		default = false,
		preview_off = "trolleybus/spawnsettings_previews/aksm321/rubbers1.png",
		preview_on = "trolleybus/spawnsettings_previews/aksm321/rubbers2.png",
	},
	{
		alias = "wheelchairback",
		type = "CheckBox",
		name = "trolleybus.aksm321.settings.wheelchairback",
		default = false,
		preview_off = "trolleybus/spawnsettings_previews/aksm321/wheelchairback1.png",
		preview_on = "trolleybus/spawnsettings_previews/aksm321/wheelchairback2.png",
	},
	{
		alias = "lamps",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.lamps",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.lamps.type1",preview = "trolleybus/spawnsettings_previews/aksm321/lamps1.png"},
			{name = "trolleybus.aksm321.settings.lamps.type2",preview = "trolleybus/spawnsettings_previews/aksm321/lamps2.png"},
		},
	},
	{
		alias = "windows",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.windows",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.windows.type1",preview = "trolleybus/spawnsettings_previews/aksm321/windows1.png"},
			{name = "trolleybus.aksm321.settings.windows.type2",preview = "trolleybus/spawnsettings_previews/aksm321/windows2.png"},
		},
	},
	{
		alias = "nameplatecolor",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.nameplatecolor",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321.settings.nameplatecolor.type1",preview = "trolleybus/spawnsettings_previews/aksm321/routecolor1.png"},
			{name = "trolleybus.aksm321.settings.nameplatecolor.type2",preview = "trolleybus/spawnsettings_previews/aksm321/routecolor2.png"},
		},
		setup = function(self,value)
			self.NameplatesUnload = SetupNameplates(self,value==1 and Color(120,200,0) or Color(255,155,0))
		end,
		unload = function(self,value)
			if self.NameplatesUnload then self.NameplatesUnload() self.NameplatesUnload = nil end
		end,
	},
	{
		alias = "engine",
		type = "ComboBox",
		name = "trolleybus.aksm321.settings.engine",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm321.settings.engine.atcd",preview = "trolleybus/spawnsettings_previews/aksm321/atcd.wav"},
			{name = "trolleybus.aksm321.settings.engine.dta",preview = "trolleybus/spawnsettings_previews/aksm321/dta.wav"},
		},
		setup = function(self,value)
			self:LoadSystem("Engine",{
				RotationAmperageAcceleration = 360*1.5/120,
				ResistanceRotationDeceleration = 0.003,

				GeneratorRotationPenalty = 0,
				GeneratorRotationAmperage = 360*3.44/200,
				GeneratorAmperageDeceleration = 360*7/200,
				
				WheelRadius = 19.6,
				
				SoundConfig = value==1 and {
					{sound = "trolleybus/engine_aksm_atcd.ogg",startspd = 0,pratestart = 0,pratemp = 0.003,volume = Volume2,endspd = 650,fadeout = 500},
					{sound = "trolleybus/engine_aksm_atcd2.ogg",startspd = 150,fadein = 500,pratestart = 0.3,pratemp = 0.001,volume = Volume2},
				} or {
					{sound = "trolleybus/engine_aksm_dta.ogg",startspd = 0,fadein = 1500,pratestart = 0,pratemp = 0.0007,volume = 3},
				},
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("Engine")
		end,
	},
	Trolleybus_System.BuildSkinSpawnSetting("aksm321","trolleybus.aksm321.settings.skins"),
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
				PneumaticDoors = {["door1"] = {400,600,0.75},["door2"] = {400,600,0.75},["door3"] = {400,600,1.5},["door4"] = {400,600,1.5}},
				DefaultAir = self:GetSpawnSetting("pressure")*100,
			},
			{
				Size = 1000,
				MCStart = 650,
				MCStop = 800,
				PneumaticDoors = {["door1"] = {400,600,0.75},["door2"] = {400,600,0.75},["door3"] = {400,600,1.5},["door4"] = {400,600,1.5}},
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
			return self:IsPriborButtonActive("stop_with_opened_doors") and self:DoorsIsOpened() and 1
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
		
		SoundPos = Vector(108.12,31.09,-39.98),
		
		StartSounds = "trolleybus/hydrobooster_aksm321_start.ogg",
		LoopSound = "trolleybus/hydrobooster_aksm321_loop.ogg",
		StopSounds = "trolleybus/hydrobooster_aksm321_stop.ogg",
		SoundDistance = 750,
		SoundVolume = 1,
	})
	self:LoadSystem("Agit-132",{
		Pos = Vector(213,11,-16),
		Ang = Angle(0,-180,0),
		PlayPos = Vector(20,-0,36),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(171,30,-31.12),
	})
	self:LoadSystem("Horn",{
		SoundPos = Vector(233,0,-30),
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
		SoundPos = Vector(216,30.67,-15),
	})
end

function ENT:DoorsIsOpened()
	return self:DoorIsOpened("door2",true) or self:DoorIsOpened("door3",true) or self:DoorIsOpened("door4",true)
end