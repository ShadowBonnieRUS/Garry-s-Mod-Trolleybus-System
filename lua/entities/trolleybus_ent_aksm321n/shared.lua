-- Copyright © Platunov I. M., 2021 All rights reserved

ENT.PrintName = "AKSM 321 New"
ENT.Category = {"creationtab_category.default","creationtab_category.default.aksm","creationtab_category.default.aksm321"}

Trolleybus_System.WheelTypes["aksm321n"] = {
	Model = "models/trolleybus/aksm321n/wheel.mdl",
	Ang = Angle(0,90,0),
	Radius = 19.6,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["aksm321n_rear"] = {
	Model = "models/trolleybus/aksm321n/wheel2.mdl",
	Ang = Angle(0,90,0),
	Radius = 19.6,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/aksm321n/body.mdl"
ENT.HasPoles = true
ENT.TrolleyPoleLength = 262.5
ENT.TrolleyPolePos = Vector(3.56,0,60.6)
ENT.TrolleyPoleSideDist = 8.9
ENT.TrolleyPoleDownedAngleLeft = Angle(-2,179.8,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-2,-179.8,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-6,179,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-6,-179,0)

ENT.PassCapacity = 115

ENT.OtherSeats = {
	{
		Type = 1,
		Pos = Vector(205,-20,-40.5),
		Ang = Angle(0,0,0),
		Camera = Vector(205,-20,17.5),
	},
}

ENT.InteriorLights = {
	{pos = Vector(0,0,18),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(-130,0,18),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(130,0,18),size = 300,style = 0,brightness = 3,color = Color(255,255,255)},
}

ENT.DoorsData = {
	["door1"] = {
		model = "models/trolleybus/aksm321n/door1.mdl",
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
		model = "models/trolleybus/aksm321n/door2.mdl",
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
		model = "models/trolleybus/aksm321n/door3.mdl",
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
		model = "models/trolleybus/aksm321n/door4.mdl",
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
	Pos = Vector(187,30,-35),
	Ang = Angle(),
}

local btnmodel = {
	model = "models/trolleybus/aksm321n/btn1.mdl",
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
	model = "models/trolleybus/aksm321n/btn1.mdl",
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
	model = "models/trolleybus/aksm321n/btn2.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(90,0,0),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel = {
	model = "models/trolleybus/aksm321n/doorbtn_left.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local doorbtnmodel2 = {
	model = "models/trolleybus/aksm321n/doorbtn_right.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,0,180),
	poseparameter = "state",
	maxdrawdistance = 200,
}

local avmodel = {
	model = "models/trolleybus/aksm321n/av.mdl",
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
		name = "trolleybus.aksm321n.btns.key",
		model = {
			model = "models/trolleybus/aksm321n/key.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "key",
			pos = {0.98,0.92},
			radius = 1,
		},
		toggle = true,
	},
	["handbrake"] = {
		name = "trolleybus.aksm321n.btns.handbrake",
		model = {
			model = "models/trolleybus/aksm321n/handbrake.mdl",
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
			pos = {1.59,2.16},
			radius = 2,
		},
		toggle = true,
		hotkey = KEY_V,
		externalhotkey = "Handbrake",
		func = function(self,on) self:SetHandbrakeActive(on) end,
	},
	["reverse_up"] = {
		name = "trolleybus.aksm321n.btns.reverse_up",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {1.25,1.45},
			radius = 0.5,
		},
		hotkey = KEY_0,
		func = function(self,on) if on and self:GetReverseState()<1 then self:ChangeReverse(self:GetReverseState()+1) end end,
	},
	["reverse_down"] = {
		name = "trolleybus.aksm321n.btns.reverse_down",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {2.55,1.41},
			radius = 0.5,
		},
		hotkey = KEY_9,
		func = function(self,on) if on and self:GetReverseState()>-1 then self:ChangeReverse(self:GetReverseState()-1) end end,
	},
	["informator_play"] = {
		name = "trolleybus.aksm321n.btns.informator_play",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {2.59,6.93},
			radius = 0.5,
		},
		func = function(self,on) self:ToggleButton("Agit-132_Button1",on) end,
	},
	["stop_with_opened_doors"] = {
		name = "trolleybus.aksm321n.btns.stop_with_opened_doors",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.83,16.37},
			radius = 0.7,
		},
		toggle = true,
	},
	["emergencyoff"] = {
		name = "trolleybus.aksm321n.btns.emergencyoff",
		model = btnmodel2,
		panel = {
			name = "leftprib2",
			pos = {1.28,19.1},
			radius = 0.5,
		},
		func = function(self,on)
			if on then
				self:ToggleButton("550v",false)
				self:ToggleButton("compressor",false)
				self:ToggleButton("hydraulic_booster",false)
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
		name = "trolleybus.aksm321n.btns.hydraulic_booster",
		model = btnmodel,
		panel = {
			name = "rightprib",
			pos = {1.24,3.17},
			radius = 0.7,
		},
		toggle = true,
	},
	["kneeling"] = {
		name = "trolleybus.aksm321n.btns.kneeling",
		model = btnmodel,
		panel = {
			name = "rightprib",
			pos = {2.6,3.18},
			radius = 0.7,
		},
		toggle = true,
	},
	["electricbrake"] = {
		name = "trolleybus.aksm321n.btns.electricbrake",
		model = btnmodel2,
		panel = {
			name = "rightprib",
			pos = {2.6,5.15},
			radius = 0.7,
		},
		toggle = true,
	},
	["polelights"] = {
		name = "trolleybus.aksm321n.btns.polelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {3.4,5.83},
			radius = 0.7,
		},
		toggle = true,
	},
	["profilelights"] = {
		name = "trolleybus.aksm321n.btns.profilelights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {6.33,5.8},
			radius = 0.7,
		},
		toggle = true,
	},
	["headlights"] = {
		name = "trolleybus.aksm321n.btns.headlights",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {4.38,5.78},
			radius = 0.7,
		},
		toggle = true,
		hotkey = KEY_F,
	},
	["airflow"] = {
		name = "trolleybus.aksm321n.btns.airflow",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {2.42,5.82},
			radius = 0.7,
		},
		toggle = true,
	},
	["buzzer"] = {
		name = "trolleybus.aksm321n.btns.buzzer",
		model = btnmodel_ang,
		panel = {
			name = "leftprib2",
			pos = {1.84,7.23},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinevent"] = {
		name = "trolleybus.aksm321n.btns.cabinevent",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {1.04,14.53},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorlight"] = {
		name = "trolleybus.aksm321n.btns.interiorlight",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {1.05,12.66},
			radius = 0.7,
		},
		toggle = true,
	},
	["pneumaticpolecatchers"] = {
		name = "trolleybus.aksm321n.btns.pneumaticpolecatchers",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.62,14.51},
			radius = 0.7,
		},
		toggle = true,
	},
	["schedulelight"] = {
		name = "trolleybus.aksm321n.btns.schedulelight",
		model = btnmodel,
		panel = {
			name = "leftprib",
			pos = {5.35,5.79},
			radius = 0.7,
		},
		toggle = true,
	},
	["550v"] = {
		name = "trolleybus.aksm321n.btns.550v",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {7.45,4.9},
			radius = 0.7,
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["mirrorheat"] = {
		name = "trolleybus.aksm321n.btns.mirrorheat",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {8.64,4.9},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabinelight"] = {
		name = "trolleybus.aksm321n.btns.cabinelight",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {9.84,4.96},
			radius = 0.7,
		},
		toggle = true,
	},
	["interiorheater"] = {
		name = "trolleybus.aksm321n.btns.interiorheater",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {10.96,4.95},
			radius = 0.7,
		},
		toggle = true,
	},
	["intheatervent"] = {
		name = "trolleybus.aksm321n.btns.intheatervent",
		model = btnmodel,
		panel = {
			name = "ups",
			pos = {12.14,4.97},
			radius = 0.7,
		},
		toggle = true,
	},
	["cabineheat"] = {
		name = "trolleybus.aksm321n.btns.cabineheat",
		model = btnmodel,
		panel = {
			name = "leftprib2",
			pos = {2.62,12.65},
			radius = 0.7,
		},
		toggle = true,
	},
	["doorbtn1"] = {
		name = "trolleybus.aksm321n.btns.doorbtn1",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.16,2.7},
			radius = 0.5,
		},
		hotkey = KEY_3,
		func = function(self,on) if on then self:OpenDoor("door1") end end,
	},
	["doorbtn2"] = {
		name = "trolleybus.aksm321n.btns.doorbtn2",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.16,3.74},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door2") end end,
	},
	["doorbtn3"] = {
		name = "trolleybus.aksm321n.btns.doorbtn3",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.16,4.77},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door3") end end,
	},
	["doorbtn4"] = {
		name = "trolleybus.aksm321n.btns.doorbtn4",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.16,5.76},
			radius = 0.5,
		},
		func = function(self,on) if on then self:OpenDoor("door4") end end,
	},
	["doorbtn5"] = {
		name = "trolleybus.aksm321n.btns.doorbtn5",
		model = doorbtnmodel,
		panel = {
			name = "rightprib",
			pos = {4.16,7.37},
			radius = 0.5,
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
		name = "trolleybus.aksm321n.btns.doorbtn6",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.18,2.7},
			radius = 0.5,
		},
		hotkey = KEY_4,
		func = function(self,on) if on then self:CloseDoor("door1") end end,
	},
	["doorbtn7"] = {
		name = "trolleybus.aksm321n.btns.doorbtn7",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.18,3.74},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door2") end end,
	},
	["doorbtn8"] = {
		name = "trolleybus.aksm321n.btns.doorbtn8",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.18,4.77},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door3") end end,
	},
	["doorbtn9"] = {
		name = "trolleybus.aksm321n.btns.doorbtn9",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.18,5.76},
			radius = 0.5,
		},
		func = function(self,on) if on then self:CloseDoor("door4") end end,
	},
	["doorbtn10"] = {
		name = "trolleybus.aksm321n.btns.doorbtn10",
		model = doorbtnmodel2,
		panel = {
			name = "rightprib",
			pos = {5.18,7.37},
			radius = 0.5,
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
		name = "trolleybus.aksm321n.btns.emergency",
		model = {
			model = "models/trolleybus/aksm321n/emergency.mdl",
			offset_pos = Vector(0,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "leftprib",
			pos = {6.59,1.16},
			radius = 0.5,
		},
		hotkey = KEY_B,
		externalhotkey = "Emergency",
		func = function(self,on) if on then self.EmergencySignal = !self.EmergencySignal end end,
	},
	["unknown4"] = {
		name = "trolleybus.aksm321n.btns.unknown4",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {1.4,4.79},
			radius = 2,
		},
		toggle = true,
	},
	["converter"] = {
		name = "trolleybus.aksm321n.btns.converter",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {16.06,9.24},
			radius = 2,
		},
		toggle = true,
	},
	["unknown6"] = {
		name = "trolleybus.aksm321n.btns.unknown6",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.66,9.26},
			radius = 2,
		},
		toggle = true,
	},
	["sequence"] = {
		name = "trolleybus.aksm321n.btns.sequence",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {16.05,2.26},
			radius = 2,
		},
		toggle = true,
	},
	["compressor"] = {
		name = "trolleybus.aksm321n.btns.compressor",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {18.66,2.28},
			radius = 2,
		},
		toggle = true,
	},
	["horn"] = {
		name = "trolleybus.aksm321n.btns.horn",
		model = {
			model = "models/trolleybus/aksm321n/hornbtn.mdl",
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
		name = "trolleybus.aksm321n.btns.door1toggleoutside",
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
		name = "trolleybus.aksm321n.btns.door1manual",
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
}

ENT.PanelsData = {
	["key"] = {
		pos = Vector(208.24,31.47,-20.77),
		ang = Angle(-70,-180,0),
		size = {2,2},
	},
	["rightprib"] = {
		pos = Vector(220.65,22.63,-10),
		ang = Angle(-51,166.8,9.4),
		size = {7,8},
	},
	["leftprib"] = {
		pos = Vector(219.67,46.34,-9.42),
		ang = Angle(-51.6,-167.5,-9.2),
		size = {7,7},
	},
	["prib"] = {
		pos = Vector(220.63,38.29,-10.19),
		ang = Angle(-46.2,-180,0),
		size = {15,7},
	},
	["leftprib2"] = {
		pos = Vector(206.72,49.04,-22.45),
		ang = Angle(-90,-180,0),
		size = {4,20},
	},
	["avs"] = {
		pos = Vector(166.8,25.34,26.75),
		ang = Angle(0,3.7,0),
		size = {20,14},
	},
	["ups"] = {
		pos = Vector(196.43,39.78,39.67),
		ang = Angle(23.4,-90,0),
		size = {13,6},
	},
	["pedals"] = {
		pos = Vector(222.65,41.69,-40.8),
		ang = Angle(-90,-180,0),
		size = {23,15},
	},
	["guitar_left"] = {
		pos = Vector(208,41.07,-18.5),
		ang = Angle(-110,0,-90),
		size = {4,6},
	},
	["guitar_right"] = {
		pos = Vector(208,26,-18.5),
		ang = Angle(-110,0,-90),
		size = {4,6},
	},
	["door1toggleoutside"] = {
		pos = Vector(224.09,-50.94,-24.32),
		ang = Angle(0,-90,0),
		size = {1,1},
	},
	["door1manual"] = {
		pos = Vector(195.42,-50.8,28.4),
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
		model = "models/trolleybus/aksm321n/indicatorlamp.mdl",
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
		model = "models/trolleybus/aksm321n/pedal.mdl",
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
		model = "models/trolleybus/aksm321n/pedal.mdl",
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
	["indicatorlamp_battery"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.accbattery","prib",1.64,0.56,0,function(self)
		return false
	end),
	["indicatorlamp_brake"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.brake","prib",2.64,0.56,1,function(self)
		return self:GetRearLights()==1
	end),
	["indicatorlamp_mirrorheat"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.mirrorheat","prib",3.64,0.56,2,function(self)
		return self:ButtonIsDown("mirrorheat")
	end),
	["indicatorlamp_doors"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.doors","prib",4.64,0.56,3,function(self)
		return self:DoorsIsOpened()
	end),
	["indicatorlamp_profilelights"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.profilelights","prib",5.64,0.56,4,function(self)
		return self:GetProfileLights()>0
	end),
	["indicatorlamp_headlights"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.headlights","prib",6.64,0.56,5,function(self)
		return self:GetHeadLights()>0
	end),
	["indicatorlamp_turnsignal"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.turnsignal","prib",7.64,0.56,6,function(self)
		return self:GetTurnSignal()!=0 and Trolleybus_System.TurnSignalTickActive(self)
	end),
	["indicatorlamp_emergency"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.emergency","prib",8.64,0.56,7,function(self)
		return self:GetEmergencySignal()
	end),
	["indicatorlamp_lowair1"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.lowair1","prib",9.64,0.56,8,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<125 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair2"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.lowair2","prib",10.64,0.56,9,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<250 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair3"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.lowair3","prib",11.64,0.56,10,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<375 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_lowair4"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.lowair4","prib",12.64,0.56,11,function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<500 and CurTime()%0.66>0.33
	end),
	["indicatorlamp_handbrake"] = IndicatorLamp("trolleybus.aksm321n.indicatorlamps.handbrake","prib",13.64,0.56,12,function(self)
		return self:GetHandbrakeActive()
	end),
}

Trolleybus_System.BuildMultiButton(ENT,"guitar_left","guitar_left","trolleybus.aksm321n.btns.turnleft","trolleybus.aksm321n.btns.turnright",{
	model = "models/trolleybus/aksm321n/guitar_left.mdl",
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

Trolleybus_System.BuildMultiButton(ENT,"guitar_right","guitar_right","trolleybus.aksm321n.btns.wipers1","trolleybus.aksm321n.btns.wipers2",{
	model = "models/trolleybus/aksm321n/guitar_right.mdl",
	offset_ang = Angle(0,90,90),
	offset_pos = Vector(0,0,4),
	poseparameter = "state",
	maxdrawdistance = 200,
},0,0,4,6,function(self,ent,state) return state==-1 and 0 or state==1 and 1 or 0.5 end)

Trolleybus_System.BuildNameplatePanel(ENT,"nameplate_front",Vector(229.13,-33.52,41.32),Angle(0,0,0),67,9,2,"Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Number","Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Name",8,Color(255,155,0),true)
Trolleybus_System.BuildNameplatePanel(ENT,"nameplate_right",Vector(-136.06,-50.19,42.99),Angle(-4.1,-90,0),60,8,2,"Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Number","Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Name",10,Color(255,155,0),true)
Trolleybus_System.BuildNameplatePanel(ENT,"nameplate_rear",Vector(-235.47,-30.91,42.04),Angle(-4.6,-180,0),13,7,0,"Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.RearNumber",nil,nil,Color(255,155,0),true)
	
Trolleybus_System.BuildInteriorNameplate(ENT,"int_nameplate",Vector(142.7,14.53,40.6),Angle(0,-180,-1.9),42.7,3,function(self)
	if !self:GetNWVar("LowPower") then return end
	
	return self.SystemsLoaded and self:GetSystem("Agit-132"):GetStopText(true)
end,"Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Integral",200,Color(255,155,0),10)

Trolleybus_System.BuildDialGauge(ENT,"speedometer","trolleybus.aksm321n.dialgauge.speedometer","prib",7.65,4.06,2.7,-77,function(self,ent)
	return !self.SystemsLoaded and 0 or -(math.abs(self:GetSystem("Engine"):GetMoveSpeed())-20)*2.15
end,"models/trolleybus/aksm321n/speedarrow.mdl",nil,Vector(0.2,0,0))

Trolleybus_System.BuildDialGauge(ENT,"akbvoltage","trolleybus.aksm321n.dialgauge.akbvoltage","leftprib",1.74,3.16,1.4,60,function(self,ent)
	local voltage = self:GetNWVar("LowVoltage",0)

	return voltage<12 and -voltage*1.5 or voltage<14 and -18-(voltage-12)*22 or -18-44-(voltage-14)*10
end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.2,0.23,-0.58))

/*Trolleybus_System.BuildMultiScreen(ENT,"screen","screen",0,0,400,300,3/400,function(self,data,x,y,w,h,hovered,cx,cy)
	local utils = Trolleybus_System.MultiScreenUtils

	surface.SetDrawColor(0,255,255)
	surface.DrawRect(x,y,w,h)
	
	if hovered and utils.InBounds2(0,0,200,200,cx,cy) then
		surface.SetDrawColor(255,0,0)
	else
		surface.SetDrawColor(255,255,0)
	end
	
	surface.DrawRect(x,y,200,200)
end,function(self,data,x,y,w,h)
	local utils = Trolleybus_System.MultiScreenUtils

	if utils.InBounds2(0,0,200,200,x,y) then
		return "TestBox"
	end
end,function(self,data,ply,x,y,w,h)
	local utils = Trolleybus_System.MultiScreenUtils

	if utils.InBounds2(0,0,200,200,x,y) then
		return print("TestBoxActivated")
	end
end,think,think_sv)*/

Trolleybus_System.BuildMovingMirror(ENT,"left_mirror",Vector(208.61,49.67,8.67),Angle(0,-90,0),10,10,"models/trolleybus/aksm321n/mirror_left.mdl",Vector(225.09,51.52,16.89),Angle(0,0,0),"Bone001","Bone002",Vector(-2,1.4,-0.3),Angle(-1,-178,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,10,3,0,-5)
Trolleybus_System.BuildMovingMirror(ENT,"middle_mirror",Vector(225.52,17.97,19.87),Angle(0,-180,0),10,10,"models/trolleybus/aksm321n/mirror_middle.mdl",Vector(220.07,0.23,28.26),Angle(0,0,0),"Bone001","Bone002",Vector(-1.72,0,0.3),Angle(0,-180,0),11.5,7,true,false,-35,35,-35,35,-20,10,-20,10,nil,-20,-0,-15)
Trolleybus_System.BuildMovingMirror(ENT,"right_mirror",Vector(225,-26,2),Angle(0,-180,0),10,10,"models/trolleybus/aksm321n/mirror_right.mdl",Vector(224.35,-51.94,19.7),Angle(0,0,0),"Bone001","Bone002",Vector(-2,-1.4,-0.7),Angle(2,179,-1),6.7,15,false,true,-45,45,-45,45,-10,10,-10,10,nil,-22,-2,0,-2)

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
		name = "trolleybus.aksm321n.settings.pressure",
		min = 0,
		max = 8,
		default = 0,
		preview = {"trolleybus/spawnsettings_previews/aksm321n/pressure",0,8},
	},
	{
		alias = "seats",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.seats",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321n.settings.seats.type1",preview = "trolleybus/spawnsettings_previews/aksm321n/seats1.png"},
			{name = "trolleybus.aksm321n.settings.seats.type2",preview = "trolleybus/spawnsettings_previews/aksm321n/seats2.png"},
			{name = "trolleybus.aksm321n.settings.seats.type3",preview = "trolleybus/spawnsettings_previews/aksm321n/seats3.png"},
		},
	},
	{
		alias = "handrail_windows",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.handrail_windows",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321n.settings.handrail_windows.type1",preview = "trolleybus/spawnsettings_previews/aksm321n/handrail_windows1.png"},
			{name = "trolleybus.aksm321n.settings.handrail_windows.type2",preview = "trolleybus/spawnsettings_previews/aksm321n/handrail_windows2.png"},
		},
	},
	{
		alias = "ceiling",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.ceiling",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321n.settings.ceiling.type1",preview = "trolleybus/spawnsettings_previews/aksm321n/ceiling1.png"},
			{name = "trolleybus.aksm321n.settings.ceiling.type2",preview = "trolleybus/spawnsettings_previews/aksm321n/ceiling2.png"},
		},
	},
	{
		alias = "integral_color",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.integral_color",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321n.settings.integral_color.type1",preview = "trolleybus/spawnsettings_previews/aksm321n/integral_color1.png"},
			{name = "trolleybus.aksm321n.settings.integral_color.type2",preview = "trolleybus/spawnsettings_previews/aksm321n/integral_color2.png"},
		},
	},
	{
		alias = "manometers",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.manometers",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321n.settings.manometers.type1",preview = "trolleybus/spawnsettings_previews/aksm321n/manometers1.png"},
			{name = "trolleybus.aksm321n.settings.manometers.type2",preview = "trolleybus/spawnsettings_previews/aksm321n/manometers2.png"},
		},
		setup = function(self,value)
			if value==1 then
				local clear1 = Trolleybus_System.BuildDialGauge(self,"linepressure1","trolleybus.aksm321n.dialgauge.pressure","prib",2.7,4.24,1.8,132,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(1)/100

					return air*9
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.02,0,1.3))

				local clear2 = Trolleybus_System.BuildDialGauge(self,"cylinderpressure1","","prib",2.7,4.24,0,55,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(1)/100

					return -air*11
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.04,0,-0.9))

				local clear3 = Trolleybus_System.BuildDialGauge(self,"linepressure2","trolleybus.aksm321n.dialgauge.pressure","prib",12.6,4.23,1.8,132,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(2)/100

					return air*9
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.02,0,1.2))

				local clear4 = Trolleybus_System.BuildDialGauge(self,"cylinderpressure2","","prib",12.6,4.23,0,55,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(2)/100

					return -air*11
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.04,0,-1))
				
				self.ManometersUnload = function() clear1() clear2() clear3() clear4() end
			else
				local clear1 = Trolleybus_System.BuildDialGauge(self,"linepressure1","trolleybus.aksm321n.dialgauge.linepressure","prib",2.17,2.8,1.3,35,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(1)/100

					return air<4 and -air*5.5 or -22-(air-4)*9.2
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))

				local clear2 = Trolleybus_System.BuildDialGauge(self,"linepressure2","trolleybus.aksm321n.dialgauge.linepressure","prib",13.12,2.77,1.3,35,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetAir(2)/100

					return air<4 and -air*5.5 or -22-(air-4)*9.2
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))

				local clear3 = Trolleybus_System.BuildDialGauge(self,"cylinderpressure1","trolleybus.aksm321n.dialgauge.cylinderpressure","prib",3.5,5.65,1.3,35,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(1)/100

					return air<4 and -air*5.5 or -22-(air-4)*9.2
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))

				local clear4 = Trolleybus_System.BuildDialGauge(self,"cylinderpressure2","trolleybus.aksm321n.dialgauge.cylinderpressure","prib",11.8,5.63,1.3,35,function(self,ent)
					local air = !self.SystemsLoaded and 0 or self:GetSystem("Pneumatic"):GetBrakePressure(2)/100

					return air<4 and -air*5.5 or -22-(air-4)*9.2
				end,"models/trolleybus/aksm321n/manometerarrow.mdl",nil,Vector(0.15,0,-0.58))
				
				self.ManometersUnload = function() clear1() clear2() clear3() clear4() end
			end
		end,
		unload = function(self,value)
			if self.ManometersUnload then self.ManometersUnload() self.ManometersUnload = nil end
		end,
	},
	{
		alias = "wnddet",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.wnddet",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321n.settings.wnddet.type1",preview = "trolleybus/spawnsettings_previews/aksm321n/wnddet1.png"},
			{name = "trolleybus.aksm321n.settings.wnddet.type2",preview = "trolleybus/spawnsettings_previews/aksm321n/wnddet2.png"},
		},
	},
	{
		alias = "lamps",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.lamps",
		default = 1,
		choices = {
			{name = "trolleybus.aksm321n.settings.lamps.type1",preview = "trolleybus/spawnsettings_previews/aksm321n/lamps1.png"},
			{name = "trolleybus.aksm321n.settings.lamps.type2",preview = "trolleybus/spawnsettings_previews/aksm321n/lamps2.png"},
		},
	},
	{
		alias = "engine",
		type = "ComboBox",
		name = "trolleybus.aksm321n.settings.engine",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.aksm321n.settings.engine.atcd",preview = "trolleybus/spawnsettings_previews/aksm321n/atcd.wav"},
			{name = "trolleybus.aksm321n.settings.engine.dta",preview = "trolleybus/spawnsettings_previews/aksm321n/dta.wav"},
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
	Trolleybus_System.BuildSkinSpawnSetting("aksm321n","trolleybus.aksm321n.settings.skins"),
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
			self:GetSystem("Pneumatic"):SetAir(self:GetSystem("Pneumatic"):GetAir(3)-nair)

			return nair
		end,
	})
	self:LoadSystem("TRSU",{
		SoundName = "trolleybus/trsu_aksm321.ogg",
	})
	self:LoadSystem("HydraulicBooster",{
		MaxPowerAmperage = 2.8,
		
		SoundPos = Vector(107.89,33.87,-44.08),
		
		StartSounds = "trolleybus/hydrobooster_aksm321_start.ogg",
		LoopSound = "trolleybus/hydrobooster_aksm321_loop.ogg",
		StopSounds = "trolleybus/hydrobooster_aksm321_stop.ogg",
		SoundDistance = 750,
		SoundVolume = 1,
	})
	self:LoadSystem("Agit-132",{
		Pos = Vector(213.5,11,-20.5),
		Ang = Angle(0,-180,0),
		PlayPos = Vector(20,-0,36),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(171.14,29.96,-35.92),
	})
	self:LoadSystem("Horn",{
		SoundPos = Vector(232.66,0,-36.6),
		ShouldActive = function(sys) return self:ButtonIsDown("horn") end,
	})
	self:LoadSystem("Reductor",{
		SoundConfig = {
			{sound = "trolleybus/reductor_aksm_zf.ogg",startspd = 0,pratestart = 0,pratemp = 0.001,volume = Volume},
		},
	})
	self:LoadSystem("Buzzer",{
		LoopSound = Sound("trolleybus/buzzer_aksm321.ogg"),
		SoundPos = Vector(216.41,30.86,-21.4),
	})
end

function ENT:DoorsIsOpened()
	return self:DoorIsOpened("door2",true) or self:DoorIsOpened("door3",true) or self:DoorIsOpened("door4",true)
end