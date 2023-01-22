-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "TrolZa-5265"
ENT.Category = {"creationtab_category.default","creationtab_category.default.trolza"}

Trolleybus_System.WheelTypes["trolza5265"] = {
	Model = "models/trolleybus/trolza5265/wheel_front.mdl",
	Ang = Angle(0,90,0),
	Radius = 18,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

Trolleybus_System.WheelTypes["trolza5265_rear"] = {
	Model = "models/trolleybus/trolza5265/wheel_rear.mdl",
	Ang = Angle(0,90,0),
	Radius = 18,
	RotateAxis = Angle(-1,0,0),
	TurnAxis = Angle(0,1,0),
}

ENT.Model = "models/trolleybus/trolza5265/body.mdl"
ENT.HasPoles = true
ENT.TrolleyPoleLength = 229
ENT.TrolleyPolePos = Vector(-10.96,0.73,63.34)
ENT.TrolleyPoleSideDist = 10.88
ENT.TrolleyPoleDownedAngleLeft = Angle(-1.9,180.8,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-1.9,179.7,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-3,180.8,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-3,179.7,0)

ENT.PassCapacity = 100

ENT.OtherSeats = {}

ENT.InteriorLights = {
	{pos = Vector(-121,0,17),size = 200,brightness = 2,style = 0,color = Color(255,255,255)},
	{pos = Vector(0,0,17),size = 200,brightness = 2,style = 0,color = Color(255,255,255)},
	{pos = Vector(118,0,17),size = 200,brightness = 2,style = 0,color = Color(255,255,255)},
}

ENT.DoorsData = {
	["door11"] = {
		model = "models/trolleybus/trolza5265/first_door_1.mdl",
		pos = Vector(181.01,-45.26,-4.58),
		ang = Angle(),
		opensoundstart = {"trolleybus/trolza5265/doors/door_open_start.ogg",500,0.75},
		opensoundend = {"trolleybus/trolza5265/doors/door_open_end.ogg",500,0.75},
		movesound = {"trolleybus/trolza5265/doors/door_move.ogg",500,0.75},
		closesoundstart = {"trolleybus/trolza5265/doors/door_close_start.ogg",500,0.75},
		closesoundend = {"trolleybus/trolza5265/doors/door_close_end.ogg",500,0.75},
		anim = true,
		speedmult = 0.6,
	},
	["door12"] = {
		model = "models/trolleybus/trolza5265/first_door_2.mdl",
		pos = Vector(153.61,-45.38,-4.58),
		ang = Angle(),
		opensoundstart = {"trolleybus/trolza5265/doors/door_open_start.ogg",500,0.75},
		opensoundend = {"trolleybus/trolza5265/doors/door_open_end.ogg",500,0.75},
		movesound = {"trolleybus/trolza5265/doors/door_move.ogg",500,0.75},
		closesoundstart = {"trolleybus/trolza5265/doors/door_close_start.ogg",500,0.75},
		closesoundend = {"trolleybus/trolza5265/doors/door_close_end.ogg",500,0.75},
		anim = true,
		speedmult = 0.5,
	},
	["door21"] = {
		model = "models/trolleybus/trolza5265/second_door_1.mdl",
		pos = Vector(13.66,-45.38,-4),
		ang = Angle(),
		opensoundstart = {"trolleybus/trolza5265/doors/door_open_start.ogg",500,0.75},
		opensoundend = {"trolleybus/trolza5265/doors/door_open_end.ogg",500,0.75},
		movesound = {"trolleybus/trolza5265/doors/door_move.ogg",500,0.75},
		closesoundstart = {"trolleybus/trolza5265/doors/door_close_start.ogg",500,0.75},
		closesoundend = {"trolleybus/trolza5265/doors/door_close_end.ogg",500,0.75},
		anim = true,
		speedmult = 0.4,
	},
	["door22"] = {
		model = "models/trolleybus/trolza5265/second_door_2.mdl",
		pos = Vector(-13.72,-45.38,-4),
		ang = Angle(),
		opensoundstart = {"trolleybus/trolza5265/doors/door_open_start.ogg",500,0.75},
		opensoundend = {"trolleybus/trolza5265/doors/door_open_end.ogg",500,0.75},
		movesound = {"trolleybus/trolza5265/doors/door_move.ogg",500,0.75},
		closesoundstart = {"trolleybus/trolza5265/doors/door_close_start.ogg",500,0.75},
		closesoundend = {"trolleybus/trolza5265/doors/door_close_end.ogg",500,0.75},
		anim = true,
		speedmult = 0.5,
	},
	["door31"] = {
		model = "models/trolleybus/trolza5265/third_door_1.mdl",
		pos = Vector(-159.98,-45.38,-4),
		ang = Angle(),
		opensoundstart = {"trolleybus/trolza5265/doors/door_open_start.ogg",500,0.75},
		opensoundend = {"trolleybus/trolza5265/doors/door_open_end.ogg",500,0.75},
		movesound = {"trolleybus/trolza5265/doors/door_move.ogg",500,0.75},
		closesoundstart = {"trolleybus/trolza5265/doors/door_close_start.ogg",500,0.75},
		closesoundend = {"trolleybus/trolza5265/doors/door_close_end.ogg",500,0.75},
		anim = true,
		speedmult = 0.6,
	},
	["door32"] = {
		model = "models/trolleybus/trolza5265/third_door_2.mdl",
		pos = Vector(-187.44,-45.38,-4),
		ang = Angle(),
		opensoundstart = {"trolleybus/trolza5265/doors/door_open_start.ogg",500,0.75},
		opensoundend = {"trolleybus/trolza5265/doors/door_open_end.ogg",500,0.75},
		movesound = {"trolleybus/trolza5265/doors/door_move.ogg",500,0.75},
		closesoundstart = {"trolleybus/trolza5265/doors/door_close_start.ogg",500,0.75},
		closesoundend = {"trolleybus/trolza5265/doors/door_close_end.ogg",500,0.75},
		anim = true,
		speedmult = 0.5,
	},
}

ENT.DriverSeatData = {
	Type = 0,
	Pos = Vector(168,26,-26),
	Ang = Angle(),
}

ENT.PanelsData = {
	["handbrake"] = {
		pos = Vector(196.6,42.84,-5.38),
		ang = Angle(-84.8,-179.3,0),
		size = {2,4},
	},
	["leftprib"] = {
		pos = Vector(163.79,43.68,-10.01),
		ang = Angle(-90,-90,0),
		size = {23,5},
	},
	["rightprib"] = {
		pos = Vector(201.87,12.89,-5.63),
		ang = Angle(-71.1,164.9,0),
		size = {6,5},
	},
	["pedals"] = {
		pos = Vector(210.22,30.85,-31.88),
		ang = Angle(-79.2,-180,0),
		size = {12,11},
	},
	["emerg"] = {
		pos = Vector(200.34,21.52,-9.08),
		ang = Angle(-44.3,-180,0),
		size = {4,2},
	},
	["indicators"] = {
		pos = Vector(206.42,23.57,-3.94),
		ang = Angle(-45.2,179.9,0),
		size = {4,6},
	},
	["key"] = {
		pos = Vector(194.36,25.8,-12.95),
		ang = Angle(-59.9,179.9,0),
		size = {2,2},
	},
	["polecatcherscontrol"] = {
		pos = Vector(192.64,40.29,-5.64),
		ang = Angle(-85,-179.9,89.9),
		size = {4,2},
	},
	["driverdoor"] = {
		pos = Vector(172.5,7.96,35.23),
		ang = Angle(0,-141.8,0),
		size = {20,70},
	},
	["doors"] = {
		pos = Vector(-207.74,-46.86,32.5),
		ang = Angle(0,-90,0),
		size = {400,70},
	},
	["ladder"] = {
		pos = Vector(-222.33,9.96,43.48),
		ang = Angle(0,-180,0),
		size = {20,70},
	},
	["leftguitar"] = {
		pos = Vector(193.85,32.16,-7.7),
		ang = Angle(-63.1,-180,90),
		size = {2,4},
	},
	["rightguitar"] = {
		pos = Vector(195.63,17.18,-6.78),
		ang = Angle(-63.1,-180,-90),
		size = {2,4},
	},
	["polecatcherspower"] = {
		pos = Vector(200.45,31.66,-8.94),
		ang = Angle(-44,-180,0),
		size = {1,1},
	},
	["avs"] = {
		pos = Vector(150.1,14.87,44.42),
		ang = Angle(0,0,0),
		size = {16,3},
	},
	["heaterindicators"] = {
		pos = Vector(191.34,43.68,-7.4),
		ang = Angle(-25.7,-180,0),
		size = {5,2},
	},
	["opendooroutside"] = {
		pos = Vector(204.81,-46.68,-25.84),
		ang = Angle(-1,-88.1,0),
		size = {2,2},
	},
}

local btnmodel1 = {
	model = "models/trolleybus/trolza5265/button.mdl",
	offset_pos = Vector(0,0.54,-0.8),
	offset_ang = Angle(-90,180,0),
	poseparameter = "state",
	poseparamstart = -1,
	poseparamend = 1,
	sounds = {
		On = {"trolleybus/trolza5265/button_on.ogg",100},
		Off = {"trolleybus/trolza5265/button_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local btnmodel1mb = {
	model = "models/trolleybus/trolza5265/button.mdl",
	offset_ang = Angle(-90,180,0),
	poseparameter = "state",
	poseparamstart = -1,
	poseparamend = 1,
	sounds = {
		On = {"trolleybus/trolza5265/button_on.ogg",100},
		Off = {"trolleybus/trolza5265/button_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local emergbtnmodel = {
	model = "models/trolleybus/trolza5265/emergency_button.mdl",
	offset_ang = Angle(-90,180,0),
	poseparameter = "state",
	sounds = {
		On = {"trolleybus/trolza5265/button_on.ogg",100},
		Off = {"trolleybus/trolza5265/button_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local avmodel = {
	model = "models/trolleybus/trolza5265/avtomat.mdl",
	offset_pos = Vector(0,0,0),
	offset_ang = Angle(-90,180,0),
	poseparameter = "state",
	sounds = {
		On = {"trolleybus/trolza5265/avtomat_on.ogg",100},
		Off = {"trolleybus/trolza5265/avtomat_off.ogg",100},
	},
	maxdrawdistance = 200,
}

local emergdooropenmodel = {
	model = "models/trolleybus/trolza5265/emergerncy_door_open_button.mdl",
	offset_pos = Vector(0.15,0,0),
	offset_ang = Angle(-90,180,0),
	poseparameter = "state",
	maxdrawdistance = 200,
}

ENT.ButtonsData = {
	["handbrake"] = {
		name = "trolleybus.trolza5265.btns.handbrake",
		model = {
			model = "models/trolleybus/trolza5265/pneumatic_brake.mdl",
			offset_pos = Vector(0,ENT.PanelsData["handbrake"].size[1]/2,-ENT.PanelsData["handbrake"].size[2]/2),
			offset_ang = Angle(-90,180,0),
			poseparameter = "state",
			sounds = {
				On = {"trolleybus/trolza5265/parking_brake_on.ogg",100},
				Off = {"trolleybus/trolza5265/parking_brake_off.ogg",100},
			},
			maxdrawdistance = 200,
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
	["emerglight"] = {
		name = "trolleybus.trolza5265.btns.emerglight",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {0.3,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["intlight"] = {
		name = "trolleybus.trolza5265.btns.intlight",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {1.62,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["intlight2"] = {
		name = "trolleybus.trolza5265.btns.intlight2",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {2.91,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["cablight"] = {
		name = "trolleybus.trolza5265.btns.cablight",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {4.19,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["fogheadlights"] = {
		name = "trolleybus.trolza5265.btns.fogheadlights",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {5.41,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["headlights"] = {
		name = "trolleybus.trolza5265.btns.headlights",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {6.68,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
		hotkey = KEY_F,
	},
	["profilelights"] = {
		name = "trolleybus.trolza5265.btns.profilelights",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {7.94,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["conditioner"] = {
		name = "trolleybus.trolza5265.btns.conditioner",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {0.3,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["doorlights"] = {
		name = "trolleybus.trolza5265.btns.doorlights",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {1.62,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["absdiagnostic"] = {
		name = "trolleybus.trolza5265.btns.absdiagnostic",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {2.91,2.85},
			size = {1.1,1.6},
		},
	},
	["converter"] = {
		name = "trolleybus.trolza5265.btns.converter",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {4.19,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["accumulator"] = {
		name = "trolleybus.trolza5265.btns.accumulator",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {5.41,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
		func = function(self,on) self:GetSystem("AccumulatorBattery"):SetActive(on) end,
	},
	["compressor"] = {
		name = "trolleybus.trolza5265.btns.compressor",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {6.68,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["hydrobooster"] = {
		name = "trolleybus.trolza5265.btns.hydrobooster",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {7.94,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["cabheatervent"] = {
		name = "trolleybus.trolza5265.btns.cabheatervent",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {13.71,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["cabheater"] = {
		name = "trolleybus.trolza5265.btns.cabheater",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {15,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["cabheater2"] = {
		name = "trolleybus.trolza5265.btns.cabheater2",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {16.28,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["intheater"] = {
		name = "trolleybus.trolza5265.btns.intheater",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {17.57,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["intheater2"] = {
		name = "trolleybus.trolza5265.btns.intheater2",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {18.77,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["intheater3"] = {
		name = "trolleybus.trolza5265.btns.intheater3",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {20.04,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["intheater4"] = {
		name = "trolleybus.trolza5265.btns.intheater4",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {21.31,0.22},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["mirrorheat"] = {
		name = "trolleybus.trolza5265.btns.mirrorheat",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {13.71,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["informator"] = {
		name = "trolleybus.trolza5265.btns.informator",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {15,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["askp"] = {
		name = "trolleybus.trolza5265.btns.askp",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {16.28,2.85},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["avdu+"] = {
		name = "trolleybus.trolza5265.btns.avdu+",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {17.57,2.85},
			size = {1.1,1.6},
		},
	},
	["avdu-"] = {
		name = "trolleybus.trolza5265.btns.avdu-",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {18.77,2.85},
			size = {1.1,1.6},
		},
	},
	["switchleft"] = {
		name = "trolleybus.trolza5265.btns.switchleft",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {20.04,2.85},
			size = {1.1,1.6},
		},
		hotkey = KEY_COMMA,
	},
	["switchright"] = {
		name = "trolleybus.trolza5265.btns.switchright",
		model = btnmodel1,
		panel = {
			name = "leftprib",
			pos = {21.31,2.85},
			size = {1.1,1.6},
		},
		hotkey = KEY_PERIOD,
	},
	["automove"] = {
		name = "trolleybus.trolza5265.btns.automove",
		model = btnmodel1,
		panel = {
			name = "rightprib",
			pos = {1.83,0.07},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["testcurleak"] = {
		name = "trolleybus.trolza5265.btns.testcurleak",
		model = btnmodel1,
		panel = {
			name = "rightprib",
			pos = {3.08,0.07},
			size = {1.1,1.6},
		},
	},
	["charge"] = {
		name = "trolleybus.trolza5265.btns.charge",
		model = btnmodel1,
		panel = {
			name = "rightprib",
			pos = {4.32,0.07},
			size = {1.1,1.6},
		},
		toggle = true,
	},
	["door1"] = {
		name = "trolleybus.trolza5265.btns.door1",
		model = btnmodel1,
		panel = {
			name = "rightprib",
			pos = {0.57,2.88},
			size = {1.1,1.6},
		},
		toggle = true,
		hotkey = KEY_1,
		func = function(self,on)
			if on then
				self:OpenDoor("door11")
				self:OpenDoor("door12")
			else
				self:CloseDoor("door11")
				self:CloseDoor("door12")
			end
		end,
	},
	["door2"] = {
		name = "trolleybus.trolza5265.btns.door2",
		model = btnmodel1,
		panel = {
			name = "rightprib",
			pos = {1.83,2.88},
			size = {1.1,1.6},
		},
		toggle = true,
		hotkey = KEY_2,
		func = function(self,on)
			if on then
				self:OpenDoor("door21")
				self:OpenDoor("door22")
			else
				self:CloseDoor("door21")
				self:CloseDoor("door22")
			end
		end,
	},
	["door3"] = {
		name = "trolleybus.trolza5265.btns.door3",
		model = btnmodel1,
		panel = {
			name = "rightprib",
			pos = {3.08,2.88},
			size = {1.1,1.6},
		},
		toggle = true,
		hotkey = KEY_3,
		func = function(self,on)
			if on then
				self:OpenDoor("door31")
				self:OpenDoor("door32")
			else
				self:CloseDoor("door31")
				self:CloseDoor("door32")
			end
		end,
	},
	["doors"] = {
		name = "trolleybus.trolza5265.btns.doors",
		model = btnmodel1,
		panel = {
			name = "rightprib",
			pos = {4.32,2.88},
			size = {1.1,1.6},
		},
		toggle = true,
		hotkey = KEY_4,
		func = function(self,on)
			if on then
				self:OpenDoor("door11")
				self:OpenDoor("door12")
				self:OpenDoor("door21")
				self:OpenDoor("door22")
				self:OpenDoor("door31")
				self:OpenDoor("door32")
			else
				self:CloseDoor("door11")
				self:CloseDoor("door12")
				self:CloseDoor("door21")
				self:CloseDoor("door22")
				self:CloseDoor("door31")
				self:CloseDoor("door32")
			end
		end,
	},
	["emergency"] = {
		name = "trolleybus.trolza5265.btns.emergency",
		model = emergbtnmodel,
		panel = {
			name = "emerg",
			pos = {1.04,1.15},
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
	["emergency_off"] = {
		name = "trolleybus.trolza5265.btns.emergency_off",
		model = emergbtnmodel,
		panel = {
			name = "emerg",
			pos = {3.01,1.15},
			radius = 0.6,
		},
		func = function(self,on)
			self:SetAVDUActive(false)

			self:ToggleButton("accumulator",false)
			self:ToggleButton("powerunit",false)
			self:ToggleButton("converter",false)
			self:ToggleButton("charge",false)
			self:ToggleButton("automove",false)
		end,
	},
	["emergency_off_cap"] = {
		name = "trolleybus.trolza5265.btns.emergency_off_cap",
		model = {
			model = "models/trolleybus/trolza5265/emergency_off_button_lid.mdl",
			offset_pos = Vector(0,0.85,0),
			offset_ang = Angle(-90,180,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "emerg",
			pos = {2.2,0},
			size = {1.7,0.62},
		},
		toggle = true,
		func = function(self,on)
			self:SetButtonDisabled("emergency_off",!on)
		end,
	},
	["driverdoor"] = {
		name = "trolleybus.trolza5265.btns.driverdoor",
		model = {
			model = "models/trolleybus/trolza5265/cabin_door.mdl",
			offset_pos = Vector(0.5,-2,-36.3),
			offset_ang = Angle(0,180,0),
			anim = true,
			speedmult = 0.4,
			maxdrawdistance = 1000,
			sounds = {
				On = {"trolleybus/trolza5265/driver_door_open.ogg",200},
				Off = {"trolleybus/trolza5265/driver_door_close.ogg",200},
			},
		},
		panel = {
			name = "driverdoor",
			pos = {0,0},
			size = ENT.PanelsData["driverdoor"].size,
		},
		toggle = true,
	},
	["ladder"] = {
		name = "trolleybus.trolza5265.btns.ladder",
		model = {
			model = "models/trolleybus/trolza5265/ladder.mdl",
			offset_pos = Vector(1.6,10,-18.3),
			offset_ang = Angle(0,180,0),
			anim = true,
			speedmult = 0.5,
			maxdrawdistance = 500,
			sounds = {
				On = {"trolleybus/trolza5265/ladder_down.ogg",200},
				Off = {"trolleybus/trolza5265/ladder_up.ogg",200},
			},
		},
		panel = {
			name = "ladder",
			pos = {0,0},
			size = ENT.PanelsData["ladder"].size,
		},
		toggle = true,
	},
	["polecatcherspower"] = {
		name = "trolleybus.trolza5265.btns.polecatcherspower",
		model = {
			model = "models/trolleybus/trolza5265/square_button.mdl",
			offset_pos = Vector(0,0.5,-0.5),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "polecatcherspower",
			pos = {0,0},
			size = ENT.PanelsData["polecatcherspower"].size,
		},
		toggle = true,
	},
	["conditionerpower"] = {
		name = "trolleybus.trolza5265.btns.conditionerpower",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {0.74,1.5},
			radius = 1.5,
		},
		toggle = true,
	},
	["intheaterpower"] = {
		name = "trolleybus.trolza5265.btns.intheaterpower",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {4.38,1.5},
			radius = 1.5,
		},
		toggle = true,
	},
	["cabheaterpower"] = {
		name = "trolleybus.trolza5265.btns.cabheaterpower",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {8,1.5},
			radius = 1.5,
		},
		toggle = true,
	},
	["compressorpower"] = {
		name = "trolleybus.trolza5265.btns.compressorpower",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {11.67,1.5},
			radius = 1.5,
		},
		toggle = true,
	},
	["powerunit"] = {
		name = "trolleybus.trolza5265.btns.powerunit",
		model = avmodel,
		panel = {
			name = "avs",
			pos = {15.26,1.5},
			radius = 1.5,
		},
		toggle = true,
	},
	["key"] = {
		name = "trolleybus.trolza5265.btns.key",
		model = {
			model = "models/trolleybus/trolza5265/key.mdl",
			offset_pos = Vector(-0.8,1,-1),
			offset_ang = Angle(90,0,0),
			anim = true,
			maxdrawdistance = 200,
			sounds = {"trolleybus/trolza5265/key_vrash.ogg",100},
			think = function(self,ent)
				ent:SetNoDraw(!self:ButtonIsDown("keyinsert"))
			end,
		},
		panel = {
			name = "key",
			pos = {0,0},
			size = {ENT.PanelsData["key"].size[1]/2,ENT.PanelsData["key"].size[2]},
		},
		toggle = true,
		func = function(self,on)
			self:SetButtonDisabled("keyinsert",on)
		end,
	},
	["keyinsert"] = {
		name = "trolleybus.trolza5265.btns.keyinsert",
		model = {
			model = "models/trolleybus/trolza5265/key.mdl",
			anim = true,
			maxdrawdistance = 200,
			sounds = {"trolleybus/trolza5265/key_insert.ogg",100},
			initialize = function(self,ent)
				ent:SetNoDraw(true)
			end,
		},
		panel = {
			name = "key",
			pos = {ENT.PanelsData["key"].size[1]/2,0},
			size = {ENT.PanelsData["key"].size[1]/2,ENT.PanelsData["key"].size[2]},
		},
		toggle = true,
		func = function(self,on)
			self:SetButtonDisabled("key",!on)
		end,
	},
	["manualdoor11open"] = {
		name = "trolleybus.trolza5265.btns.manualdooropen",
		panel = {
			name = "doors",
			pos = {376,0},
			size = {26,70},
		},
		func = function(self,on)
			if on then self:ToggleDoorWithHand("door11") end
		end,
	},
	["manualdoor12open"] = {
		name = "trolleybus.trolza5265.btns.manualdooropen",
		panel = {
			name = "doors",
			pos = {350,0},
			size = {26,70},
		},
		func = function(self,on)
			if on then self:ToggleDoorWithHand("door12") end
		end,
	},
	["manualdoor21open"] = {
		name = "trolleybus.trolza5265.btns.manualdooropen",
		panel = {
			name = "doors",
			pos = {208,0},
			size = {26,70},
		},
		func = function(self,on)
			if on then self:ToggleDoorWithHand("door21") end
		end,
	},
	["manualdoor22open"] = {
		name = "trolleybus.trolza5265.btns.manualdooropen",
		panel = {
			name = "doors",
			pos = {182,0},
			size = {26,70},
		},
		func = function(self,on)
			if on then self:ToggleDoorWithHand("door22") end
		end,
	},
	["manualdoor31open"] = {
		name = "trolleybus.trolza5265.btns.manualdooropen",
		panel = {
			name = "doors",
			pos = {34,0},
			size = {26,70},
		},
		func = function(self,on)
			if on then self:ToggleDoorWithHand("door31") end
		end,
	},
	["manualdoor32open"] = {
		name = "trolleybus.trolza5265.btns.manualdooropen",
		panel = {
			name = "doors",
			pos = {8,0},
			size = {26,70},
		},
		func = function(self,on)
			if on then self:ToggleDoorWithHand("door32") end
		end,
	},
	["emergopendoor1"] = {
		name = "trolleybus.trolza5265.btns.emergopendoor",
		model = emergdooropenmodel,
		panel = {
			name = "doors",
			pos = {343.86,56.55},
			radius = 1,
		},
		func = function(self,on)
			if on then
				self:OpenDoor("door11")
				self:OpenDoor("door12")

				self:SetNWVar("EmergDoorOpen1",!self:GetNWVar("EmergDoorOpen1"))
			end
		end,
		think_sv = function(self,on)
			if on and self:GetNWVar("EmergDoorOpen1") then
				local air = self:GetSystem("Pneumatic"):GetAir(4)
				local newair = math.max(0,self:GetSystem("Pneumatic"):GetAir(4)-self.DeltaTime*100)

				self:GetSystem("Pneumatic"):SetAir(4,newair)

				if air>=133 and newair<133 then
					Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/trolza5265/avar_dver_spusk_vozduha.ogg",200,1,nil,Vector(168,-43,39))
				end
			end
		end,
	},
	["emergopendoor2"] = {
		name = "trolleybus.trolza5265.btns.emergopendoor",
		model = emergdooropenmodel,
		panel = {
			name = "doors",
			pos = {177.97,56.55},
			radius = 1,
		},
		func = function(self,on)
			if on then
				self:OpenDoor("door21")
				self:OpenDoor("door22")

				self:SetNWVar("EmergDoorOpen2",!self:GetNWVar("EmergDoorOpen2"))
			end
		end,
		think_sv = function(self,on)
			if on and self:GetNWVar("EmergDoorOpen2") then
				local air = self:GetSystem("Pneumatic"):GetAir(5)
				local newair = math.max(0,self:GetSystem("Pneumatic"):GetAir(5)-self.DeltaTime*100)

				self:GetSystem("Pneumatic"):SetAir(5,newair)

				if air>=133 and newair<133 then
					Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/trolza5265/avar_dver_spusk_vozduha.ogg",200,1,nil,Vector(0,-43,39))
				end
			end
		end,
	},
	["emergopendoor3"] = {
		name = "trolleybus.trolza5265.btns.emergopendoor",
		model = emergdooropenmodel,
		panel = {
			name = "doors",
			pos = {2.4,54.55},
			radius = 1,
		},
		func = function(self,on)
			if on then
				self:OpenDoor("door31")
				self:OpenDoor("door32")

				self:SetNWVar("EmergDoorOpen3",!self:GetNWVar("EmergDoorOpen3"))
			end
		end,
		think_sv = function(self,on)
			if on and self:GetNWVar("EmergDoorOpen3") then
				local air = self:GetSystem("Pneumatic"):GetAir(6)
				local newair = math.max(0,self:GetSystem("Pneumatic"):GetAir(6)-self.DeltaTime*100)

				self:GetSystem("Pneumatic"):SetAir(6,newair)

				if air>=133 and newair<133 then
					Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/trolza5265/avar_dver_spusk_vozduha.ogg",200,1,nil,Vector(-171,-43,39))
				end
			end
		end,
	},
	["removepoles"] = {
		name = "trolleybus.trolza5265.btns.removepoles",
		model = {
			model = "models/trolleybus/trolza5265/round_button.mdl",
			offset_pos = Vector(-0.1,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			maxdrawdistance = 200,
		},
		panel = {
			name = "polecatcherscontrol",
			pos = {0.88,1.66},
			radius = 0.5,
		},
	},
	["polecatcherscontrol"] = {
		name = "trolleybus.trolza5265.btns.polecatcherscontrol",
		model = {
			model = "models/trolleybus/trolza5265/tumbler.mdl",
			offset_pos = Vector(-0.1,0,0),
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			sounds = {
				On = {"trolleybus/trolza5265/button_on.ogg",100},
				Off = {"trolleybus/trolza5265/button_off.ogg",100},
			},
			maxdrawdistance = 200,
		},
		panel = {
			name = "polecatcherscontrol",
			pos = {3.06,1.66},
			radius = 0.5,
		},
		toggle = true,
	},
}

local function CreateIndicatorLamp(name,x,y,type,shouldbeactive)
	return {
		name = name,
		model = "models/trolleybus/trolza5265/indicator_panel_"..type..".mdl",
		offset_ang = Angle(90,0,0),
		panel = {
			name = "indicators",
			pos = {x,y},
			radius = 0.25,
		},
		think = function(self,ent)
			ent:SetSkin(self:GetNWVar("LowPower") and shouldbeactive(self) and 1 or 0)
		end,
	}
end

local function CreateHeaterIndicatorLamp(name,x,y,shouldbeactive)
	return {
		name = name,
		model = "models/trolleybus/trolza5265/indicator.mdl",
		offset_ang = Angle(90,0,0),
		panel = {
			name = "heaterindicators",
			pos = {x,y},
			radius = 0.25,
		},
		think = function(self,ent)
			ent:SetSkin(self:GetNWVar("LowPower") and shouldbeactive(self) and 1 or 0)
		end,
	}
end

ENT.OtherPanelEntsData = {
	["startpedal"] = {
		name = "",
		model = "models/trolleybus/trolza5265/start_pedal.mdl",
		panel = {
			name = "pedals",
			pos = {10.7,1.66},
			radius = 0,
		},
		offset_pos = Vector(4.15,0,2.4),
		offset_ang = Angle(-101,0,180),
		initialize = function(self,ent)
			ent.State = self:GetStartPedal()
			
			ent:SetCycle(ent.State)
		end,
		think = function(self,ent)
			local state = self:GetStartPedal()
			
			if ent.State!=state then
				if ent.State<state then
					ent.State = math.min(state,ent.State+self.DeltaTime*5)
				else
					ent.State = math.max(state,ent.State-self.DeltaTime*5)
				end
				
				ent:SetCycle(ent.State)
			end
		end,
		maxdrawdistance = 200,
	},
	["brakepedal"] = {
		name = "",
		model = "models/trolleybus/trolza5265/brake_pedal.mdl",
		panel = {
			name = "pedals",
			pos = {1.5,8.4},
			radius = 0,
		},
		offset_ang = Angle(-90,0,180),
		initialize = function(self,ent)
			ent.State = self:GetBrakePedal()
			
			ent:SetCycle(ent.State)
		end,
		think = function(self,ent)
			local state = self:GetBrakePedal()
			
			if ent.State!=state then
				if ent.State<state then
					ent.State = math.min(state,ent.State+self.DeltaTime*5)
				else
					ent.State = math.max(state,ent.State-self.DeltaTime*5)
				end
				
				ent:SetCycle(ent.State)
			end
		end,
		maxdrawdistance = 200,
	},
	["550vlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.550v",0.74,0.55,"red",function(self)
		return self:GetNWVar("HighPower")
	end),
	["offsnlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.offsn",1.39,0.55,"red",function(self)
		return false
	end),
	["bpn1lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.bpn1",2.04,0.55,"red",function(self)
		return self.SystemsLoaded and self:GetSystem("StaticVoltageConverter"):IsActive()
	end),
	["bpn2lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.bpn2",2.71,0.55,"red",function(self)
		return false
	end),
	["automovelamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.automove",3.35,0.55,"red",function(self)
		return self:GetNWVar("AutoMove",false)
	end),
	["door1lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.door1",0.74,1.28,"green",function(self)
		return self:DoorIsOpened("door11") or self:DoorIsOpened("door12")
	end),
	["door2lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.door2",1.39,1.28,"green",function(self)
		return self:DoorIsOpened("door21") or self:DoorIsOpened("door22")
	end),
	["door3lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.door3",2.04,1.28,"green",function(self)
		return self:DoorIsOpened("door31") or self:DoorIsOpened("door32")
	end),
	["door4lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.door4",2.71,1.28,"green",function(self)
		return false
	end),
	["emergopenlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.emergopen",3.35,1.28,"red",function(self)
		return self.SystemsLoaded and (
			self:GetNWVar("EmergDoorOpen1") and self:GetSystem("Pneumatic"):GetAir(4)<133 or
			self:GetNWVar("EmergDoorOpen2") and self:GetSystem("Pneumatic"):GetAir(5)<133 or
			self:GetNWVar("EmergDoorOpen3") and self:GetSystem("Pneumatic"):GetAir(6)<133
		)
	end),
	["profilelightslamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.profilelights",0.74,2,"green",function(self)
		return self:GetProfileLights()>0
	end),
	["farheadlightslamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.farheadlights",1.39,2,"blue",function(self)
		return self:GetNWVar("HeadLights",false)
	end),
	["fogheadlightslamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.fogheadlights",2.04,2,"blue",function(self)
		return self:GetNWVar("FogHeadLights",false)
	end),
	["turnsignallamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.turnsignal",2.71,2,"green",function(self)
		return (self:GetTurnSignal()!=0 or self:GetEmergencySignal()) and Trolleybus_System.TurnSignalTickActive(self)
	end),
	["abslamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.abs",3.35,2,"red",function(self)
		return false
	end),
	["pressurehandbrakelamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.pressurehandbrake",0.74,2.73,"red",function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(3)<400
	end),
	["pressure1lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.pressure1",1.39,2.73,"red",function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(1)<400
	end),
	["pressure2lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.pressure2",2.04,2.73,"red",function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):GetAir(2)<400
	end),
	["pressure3lamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.pressure3",2.71,2.73,"red",function(self)
		return false
	end),
	["pressuredoorslamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.pressuredoors",3.35,2.73,"red",function(self)
		return self.SystemsLoaded and (
			!self:GetNWVar("EmergDoorOpen1") and self:GetSystem("Pneumatic"):GetAir(4)<133 or
			!self:GetNWVar("EmergDoorOpen2") and self:GetSystem("Pneumatic"):GetAir(5)<133 or
			!self:GetNWVar("EmergDoorOpen3") and self:GetSystem("Pneumatic"):GetAir(6)<133
		)
	end),
	["ramplamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.ramp",0.74,3.47,"blue",function(self)
		return false
	end),
	["idklamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.idk",1.39,3.47,"blue",function(self)
		return false
	end),
	["compressorlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.compressor",2.04,3.47,"red",function(self)
		return self.SystemsLoaded and self:GetSystem("Pneumatic"):IsMotorCompressorActive()
	end),
	["strapwearlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.strapwear",2.71,3.47,"red",function(self)
		return false
	end),
	["oillamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.oil",3.35,3.47,"red",function(self)
		return false
	end),
	["ukicrashlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.ukicrash",0.74,4.19,"red",function(self)
		return false
	end),
	["ukileaklamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.ukileak",1.39,4.19,"red",function(self)
		return false
	end),
	["ukinormlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.ukinorm",2.04,4.19,"green",function(self)
		return true
	end),
	["jointanglamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.jointang",2.71,4.19,"red",function(self)
		return false
	end),
	["jointspdlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.jointspd",3.35,4.19,"red",function(self)
		return false
	end),
	["insresunsatlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.insresunsat",0.74,4.93,"red",function(self)
		return false
	end),
	["insressatlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.insressat",1.39,4.93,"red",function(self)
		return false
	end),
	["insresgoodlamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.insresgood",2.04,4.93,"green",function(self)
		return true
	end),
	["polecatcherslamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.polecatchers",2.71,4.93,"green",function(self)
		return self:GetNWVar("PoleCatchersPower") and self:GetNWVar("PoleCatchersControl")
	end),
	["polesetuplamp"] = CreateIndicatorLamp("trolleybus.trolza5265.lamps.polesetup",3.35,4.93,"green",function(self)
		return self:GetNWVar("PoleCatchersPower") and !self:GetNWVar("PoleCatchersControl")
	end),
	["cabheaterlamp"] = CreateHeaterIndicatorLamp("trolleybus.trolza5265.lamps.cabheater",3.88,0.46,function(self)
		return self.SystemsLoaded and self:GetSystem("Heater"):GetState()>0
	end),
	["intheater1lamp"] = CreateHeaterIndicatorLamp("trolleybus.trolza5265.lamps.intheater1",0.7,1.68,function(self)
		return self.SystemsLoaded and self:GetSystem("Heater","Interior1"):GetState()>0
	end),
	["intheater2lamp"] = CreateHeaterIndicatorLamp("trolleybus.trolza5265.lamps.intheater2",1.76,1.68,function(self)
		return self.SystemsLoaded and self:GetSystem("Heater","Interior2"):GetState()>0
	end),
	["intheater3lamp"] = CreateHeaterIndicatorLamp("trolleybus.trolza5265.lamps.intheater3",2.82,1.68,function(self)
		return self.SystemsLoaded and self:GetSystem("Heater","Interior3"):GetState()>0
	end),
	["intheater4lamp"] = CreateHeaterIndicatorLamp("trolleybus.trolza5265.lamps.intheater4",3.88,1.68,function(self)
		return self.SystemsLoaded and self:GetSystem("Heater","Interior4"):GetState()>0
	end),
}

local function CreateStopRequestButton(index,pos,ang)
	ENT.PanelsData[index] = {
		pos = pos,
		ang = ang,
		size = {2,2},
	}

	ENT.ButtonsData[index] = {
		name = "trolleybus.trolza5265.btns.stoprequest",
		model = {
			model = "models/trolleybus/trolza5265/stop_button.mdl",
			offset_pos = Vector(-1,1,-1),
			offset_ang = Angle(0,-90,0),
			anim = true,
			drawdistance = 200,
			sounds = {
				On = {"trolleybus/trolza5265/button_on.ogg",50,1},
				Off = {"trolleybus/trolza5265/button_off.ogg",50,1},
			},
		},
		panel = {
			name = index,
			pos = {0,0},
			size = {2,2},
		},
		func = function(self,on)
			self.StopRequests = self.StopRequests+(on and 1 or -1)
		end,
	}
end

CreateStopRequestButton("stoprequest1",Vector(29.3,-18,5),Angle(0,90,0))
CreateStopRequestButton("stoprequest2",Vector(-27.3,-18,5),Angle(0,90,0))
CreateStopRequestButton("stoprequest3",Vector(-176.15,-18,5),Angle(0,90,0))

Trolleybus_System.BuildMultiButton(ENT,"guitar_left","leftguitar","trolleybus.trolza5265.btns.turnsignall","trolleybus.trolza5265.btns.turnsignalr",{
	model = "models/trolleybus/trolza5265/guitar_left.mdl",
	offset_pos = Vector(0,0,-2),
	offset_ang = Angle(0,90,90),
	poseparameter = "state",
	maxdrawdistance = 200,
	sounds = {
		On = {"trolleybus/trolza5265/podrul_on.ogg",100},
		Off = {"trolleybus/trolza5265/podrul_off.ogg",100},
	},
},0,0,2,4,function(self,ent,state) return state end,nil,nil,nil,KEY_G,KEY_H,nil,nil,"LeftTurnSignal","RightTurnSignal")

Trolleybus_System.BuildMultiButton(ENT,"guitar_right","rightguitar","trolleybus.trolza5265.btns.wipersl","trolleybus.trolza5265.btns.wipersr",{
	model = "models/trolleybus/trolza5265/guitar_right.mdl",
	offset_pos = Vector(0,0,-2),
	offset_ang = Angle(0,-90,-90),
	poseparameter = "state",
	maxdrawdistance = 200,
	sounds = {
		On = {"trolleybus/trolza5265/podrul_on.ogg",100},
		Off = {"trolleybus/trolza5265/podrul_off.ogg",100},
	},
},0,0,2,4,function(self,ent,state) return -math.Remap(state,-1,2,-1,1) end,nil,nil,nil,nil,nil,-1,2)

Trolleybus_System.BuildMultiButton(ENT,"reverse","rightprib","trolleybus.trolza5265.btns.reverseup","trolleybus.trolza5265.btns.reversedown",btnmodel1mb,0.57,0.07,1.1,1.6,function(self,ent,state)
	return -state
end,function(self,on,state)
	if !self:ChangeReverse(self:GetReverseState()+1) then return false end
end,function(self,on,state)
	if !self:ChangeReverse(self:GetReverseState()-1) then return false end
end,nil,KEY_0,KEY_9,nil,nil,nil,nil,true)

Trolleybus_System.BuildMultiButton(ENT,"opendooroutside","opendooroutside","trolleybus.trolza5265.btns.dooroutsideopen","trolleybus.trolza5265.btns.dooroutsideclose",{
	model = "models/trolleybus/trolza5265/tumbler.mdl",
	offset_ang = Angle(90,0,0),
	poseparameter = "state",
	sounds = {
		On = {"trolleybus/trolza5265/button_on.ogg",100},
		Off = {"trolleybus/trolza5265/button_off.ogg",100},
	},
	maxdrawdistance = 200,
},0,0,2,2,function(self,ent,state) return (state+1)/2 end,function(self,on,state)
	if on and state==-1 then self:OpenDoor("door11") self:OpenDoor("door12") end
end,function(self,on,state)
	if on and state==1 then self:CloseDoor("door11") self:CloseDoor("door12") end
end,true)

local nameplatecolor = Color(255,155,0)
Trolleybus_System.BuildNameplatePanel(ENT,"nameplate_front",Vector(206.21,-21.26,36.78),Angle(-1.9,0,0),43,6,2,"Trolleybus_System.Trolleybus.TrolZa5265.RouteDisplay.Number","Trolleybus_System.Trolleybus.TrolZa5265.RouteDisplay.Name",22,nameplatecolor,true)
Trolleybus_System.BuildNameplatePanel(ENT,"nameplate_side",Vector(36.65,-45.39,36),Angle(-1.9,-90,0),43,6,2,"Trolleybus_System.Trolleybus.TrolZa5265.RouteDisplay.Number","Trolleybus_System.Trolleybus.TrolZa5265.RouteDisplay.Name",22,nameplatecolor,true)
Trolleybus_System.BuildNameplatePanel(ENT,"nameplate_back",Vector(-215.07,-20.78,36),Angle(0,-179.4,0),10,4,0,"Trolleybus_System.Trolleybus.TrolZa5265.RouteDisplay.Number",nil,20,nameplatecolor,true)

local mirror1verts = {
	{x = -2.056548,y = -6.484557},
	{x = 2.042342,y = -6.484557},
	{x = 2.771452,y = -6.163442},
	{x = 3.119007,y = -5.48722},
	{x = 3.119007,y = 0.003779},
	{x = 3.119007,y = 5.491},
	{x = 2.771452,y = 6.167222},
	{x = 2.042342,y = 6.492111},
	{x = -2.056548,y = 6.492111},
	{x = -2.800772,y = 6.163448},
	{x = -3.155884,y = 5.472113},
	{x = -3.272991,y = 0.001892},
	{x = -3.155884,y = -5.464559},
	{x = -2.800772,y = -6.155885},
}
local mirror2verts = {
	{x = 2.056548,y = 6.484557},
	{x = -2.042342,y = 6.484557},
	{x = -2.771452,y = 6.163442},
	{x = -3.119007,y = 5.48722},
	{x = -3.119007,y = -0.003779},
	{x = -3.119007,y = -5.491},
	{x = -2.771452,y = -6.167222},
	{x = -2.042342,y = -6.492111},
	{x = 2.056548,y = -6.492111},
	{x = 2.800772,y = -6.163448},
	{x = 3.155884,y = -5.472113},
	{x = 3.272991,y = -0.001892},
	{x = 3.155884,y = 5.464559},
	{x = 2.800772,y = 6.155885},
}
local mirror3verts = {
	{x = -5.473185,y = -3.114479},
	{x = 0.017814,y = -3.114479},
	{x = 5.508815,y = -3.114479},
	{x = 6.185037,y = -2.763146},
	{x = 6.506148,y = -2.034036},
	{x = 6.506148,y = 2.064853},
	{x = 6.177482,y = 2.805295},
	{x = 5.486148,y = 3.16041},
	{x = 0.017815,y = 3.277519},
	{x = -5.450518,y = 3.16041},
	{x = -6.141851,y = 2.805295},
	{x = -6.470518,y = 2.064853},
	{x = -6.470518,y = -2.034036},
	{x = -6.149408,y = -2.763146},
}

Trolleybus_System.BuildMovingMirror(ENT,"mirror_left",Vector(190.45,44.17,12.57),Angle(0,-90,0),10,10,"models/trolleybus/trolza5265/mirror_left.mdl",Vector(197.44,46.73,25),Angle(0,0,0),"MirrorBase","Mirror",Vector(-2.6,1.3,0),Angle(0,180,0),6.5,12,false,true,-45,45,-45,45,0,0,-15,15,mirror1verts,0,16,0,-5)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_right",Vector(209.39,-22.4,11.57),Angle(0,-180,0),10,10,"models/trolleybus/trolza5265/mirror_right.mdl",Vector(194.23,-46.9,37.83),Angle(0,0,0),"MirrorBase","Mirror",Vector(-2.4,-1.3,0),Angle(0,180,0),6.5,12,false,true,-45,0,-45,45,0,0,-15,15,mirror2verts,-11,-12,0,-4)
Trolleybus_System.BuildMovingMirror(ENT,"mirror_middle",Vector(209.95,6.37,24),Angle(0,-180,0),10,10,"models/trolleybus/trolza5265/mirror_cabine.mdl",Vector(199,-7,39.59),Angle(0,0,0),"MirrorBase","Mirror",Vector(-2.6,0,-1.4),Angle(0,180,0),12.5,6,false,true,0,0,-45,15,0,0,-25,15,mirror3verts,0,-19,0,-21)

local function Volume(self,ent)
	return math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/500,0.3,1)*0.5
end
local function Volume2(self,ent)
	return math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/500,0.3,1)
end

ENT.SpawnSettings = {
	{
		alias = "pressure",
		type = "Slider",
		name = "trolleybus.trolza5265.settings.pressure",
		min = 0,
		max = 8,
		default = 0,
		preview = {"trolleybus/spawnsettings_previews/trolza5265/pressure",0,8},
	},
	{
		alias = "noair",
		type = "CheckBox",
		name = "trolleybus.trolza5265.settings.noair",
		default = false,
		preview_on = "trolleybus/spawnsettings_previews/trolza5265/noair_on.png",
		preview_off = "trolleybus/spawnsettings_previews/trolza5265/noair_off.png",
	},
	{
		alias = "seats",
		type = "ComboBox",
		name = "trolleybus.trolza5265.settings.seats",
		default = 1,
		choices = {
			{name = "trolleybus.trolza5265.settings.seats.type1",preview = "trolleybus/spawnsettings_previews/trolza5265/seats1.png"},
			{name = "trolleybus.trolza5265.settings.seats.type2",preview = "trolleybus/spawnsettings_previews/trolza5265/seats2.png"},
			{name = "trolleybus.trolza5265.settings.seats.type3",preview = "trolleybus/spawnsettings_previews/trolza5265/seats3.png"},
		},
	},
	{
		alias = "steer",
		type = "ComboBox",
		name = "trolleybus.trolza5265.settings.steer",
		default = 1,
		choices = {
			{name = "trolleybus.trolza5265.settings.steer.type1",preview = "trolleybus/spawnsettings_previews/trolza5265/steer1.png"},
			{name = "trolleybus.trolza5265.settings.steer.type2",preview = "trolleybus/spawnsettings_previews/trolza5265/steer2.png"},
		},
		setup = function(self,value)
			self.SteerData = value==2 and self.SteerData1 or self.SteerData2
		end,
		unload = function(self,value)
			self.SteerData = self.SteerData1
		end,
	},
	{
		alias = "compressor",
		type = "ComboBox",
		name = "trolleybus.trolza5265.settings.compressor",
		soundpreview = true,
		default = 1,
		choices = {
			{name = "trolleybus.trolza5265.settings.compressor.type1",preview = "trolleybus/spawnsettings_previews/trolza5265/compressor1.wav"},
			{name = "trolleybus.trolza5265.settings.compressor.type2",preview = "trolleybus/spawnsettings_previews/trolza5265/compressor2.wav"},
		},
		setup = function(self,value)
			if SERVER and self:GetSystem("Pneumatic") then return end

			self:LoadSystem("Pneumatic",{
				MotorCompressorSpeed = 40,
				MotorCompressorSounds = value==1 and {
					StartSounds = Sound("trolleybus/trolza5265/compressor/1/on.ogg"),
					LoopSound = Sound("trolleybus/trolza5265/compressor/1/loop.ogg"),
					EndSounds = Sound("trolleybus/trolza5265/compressor/1/off.ogg"),
				} or {
					StartSounds = Sound("trolleybus/trolza5265/compressor/2/on.ogg"),
					LoopSound = Sound("trolleybus/trolza5265/compressor/2/loop.ogg"),
					EndSounds = Sound("trolleybus/trolza5265/compressor/2/off.ogg"),
					SndVolume = 1,
				},
				
				Receivers = {
					{
						Size = 1000,
						MCStart = 650,
						MCStop = 800,
						DefaultAir = self:GetSpawnSetting("pressure")*100,
					},
					{
						Size = 1000,
						MCStart = 650,
						MCStop = 800,
						DefaultAir = self:GetSpawnSetting("pressure")*100,
					},
					{
						Size = 1000,
						MCStart = 650,
						MCStop = 800,
						DefaultAir = self:GetSpawnSetting("noair") and 0 or 800,
					},
					{
						Size = 333,
						MCStart = 216,
						MCStop = 266,
						PneumaticDoors = {["door11"] = {133,200,6.25},["door12"] = {133,200,6.25}},
						ShouldBeIgnoredByMC = function(self) return self:GetNWVar("EmergDoorOpen1") end,
						DefaultAir = self:GetSpawnSetting("noair") and 0 or 266,
					},
					{
						Size = 333,
						MCStart = 216,
						MCStop = 266,
						PneumaticDoors = {["door21"] = {133,200,6.25},["door22"] = {133,200,6.25}},
						ShouldBeIgnoredByMC = function(self) return self:GetNWVar("EmergDoorOpen2") end,
						DefaultAir = self:GetSpawnSetting("noair") and 0 or 266,
					},
					{
						Size = 333,
						MCStart = 216,
						MCStop = 266,
						PneumaticDoors = {["door31"] = {133,200,6.25},["door32"] = {133,200,6.25}},
						ShouldBeIgnoredByMC = function(self) return self:GetNWVar("EmergDoorOpen3") end,
						DefaultAir = self:GetSpawnSetting("noair") and 0 or 266,
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
				
				BrakePedalStart = 0.5,
				BrakePedalEnd = 1,
			})
		end,
		unload = function(self,value)
			if CLIENT then
				self:UnloadSystem("Pneumatic")
			end
		end
	},
	{
		alias = "reductor",
		type = "ComboBox",
		name = "trolleybus.trolza5265.settings.reductor",
		default = 1,
		choices = {
			{name = "trolleybus.trolza5265.settings.reductor.zf",preview = "trolleybus/spawnsettings_previews/trolza5265/rearaxle1.png"},
			{name = "trolleybus.trolza5265.settings.reductor.raba",preview = "trolleybus/spawnsettings_previews/trolza5265/rearaxle2.png"},
		},
		setup = function(self,value)
			self:LoadSystem("Reductor",{
				SoundConfig = value==1 and {
					{sound = "trolleybus/trolza5265/chassis/zf/rear_axle.ogg",startspd = 0,pratestart = 0,pratemp = 0.001,volume = Volume},
					{sound = "trolleybus/trolza5265/chassis/zf/start.ogg",startspd = 150,fadein = 500,pratestart = 0.3,pratemp = 0.001,volume = Volume2},
				} or {
					{sound = "trolleybus/trolza5265/chassis/raba/rear_axle.ogg",startspd = 0,pratestart = 0,pratemp = 0.001,volume = Volume},
				},
			})

			if SERVER then
				for k,v in ipairs(self.Wheels) do
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(0,value==1 and 1 or 0)
					end
				end
			end
		end,
		unload = function(self,value)
			self:UnloadSystem("Reductor")

			if SERVER then
				for k,v in ipairs(self.Wheels) do
					for k,v in ipairs(v.Wheels) do
						v:SetBodyGroup(0,0)
					end
				end
			end
		end
	},
	{
		alias = "engine",
		type = "ComboBox",
		name = "trolleybus.trolza5265.settings.engine",
		nopreview = true,
		default = 1,
		choices = {
			{name = "trolleybus.trolza5265.settings.engine.atcd"},
			{name = "trolleybus.trolza5265.settings.engine.dta"},
		},
		setup = function(self,value)
			self:LoadSystem("Engine",{
				RotationAmperageAcceleration = 360*1.5/120,
				ResistanceRotationDeceleration = 0.003,
		
				GeneratorRotationPenalty = 0,
				GeneratorRotationAmperage = 360*3.44/200,
				GeneratorAmperageDeceleration = 360*7/200,
				
				WheelRadius = 18,
				
				SoundConfig = value==1 and {
					{sound = "trolleybus/trolza5265/engine/atcd.ogg",startspd = 0,pratestart = 0,pratemp = 0.003,volume = Volume2,endspd = 650,fadeout = 500},
				} or {
					{sound = "trolleybus/trolza5265/engine/dta.ogg",startspd = 0,fadein = 1500,pratestart = 0,pratemp = 0.0007,volume = 3},
				},
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("Engine")
		end
	},
	{
		alias = "hydrobooster",
		type = "ComboBox",
		name = "trolleybus.trolza5265.settings.hydrobooster",
		default = 1,
		soundpreview = true,
		choices = {
			{name = "trolleybus.trolza5265.settings.hydrobooster.type1",preview = "trolleybus/spawnsettings_previews/trolza5265/hydrobooster1.wav"},
			{name = "trolleybus.trolza5265.settings.hydrobooster.type2",preview = "trolleybus/spawnsettings_previews/trolza5265/hydrobooster2.wav"},
		},
		setup = function(self,value)
			local path = value==1 and "" or "2/"

			self:LoadSystem("HydraulicBooster",{
				SoundPos = Vector(174,25,-35),
		
				StartSounds = Sound("trolleybus/trolza5265/hydrobooster/"..path.."outside/on.ogg"),
				LoopSound = Sound("trolleybus/trolza5265/hydrobooster/"..path.."outside/loop.ogg"),
				StopSounds = Sound("trolleybus/trolza5265/hydrobooster/"..path.."outside/off.ogg"),
		
				InsideStartSounds = Sound("trolleybus/trolza5265/hydrobooster/"..path.."inside/on.ogg"),
				InsideLoopSound = Sound("trolleybus/trolza5265/hydrobooster/"..path.."inside/loop.ogg"),
				InsideStopSounds = Sound("trolleybus/trolza5265/hydrobooster/"..path.."inside/off.ogg"),
		
				SoundDistance = 500,
				SoundVolume = 1,
			})
		end,
		unload = function(self,value)
			self:UnloadSystem("HydraulicBooster")
		end
	},
	Trolleybus_System.BuildSkinSpawnSetting("trolza5265","trolleybus.trolza5265.settings.skins"),
}

function ENT:LoadSystems()
	self:LoadSystem("TRSU",{SoundName = "trolleybus/trolza5265/trsu.ogg"})
	self:LoadSystem("Handbrake",{
		MaxDeceleration = 5000,
		PneumaticAirBrake = 100,
		GetAirFromSystem = function(s,air)
			local nair = math.min(self:GetSystem("Pneumatic"):GetAir(3),air)
			self:GetSystem("Pneumatic"):SetAir(3,self:GetSystem("Pneumatic"):GetAir(3)-nair)

			return nair
		end,
	})

	self:LoadSystem("Heater",{
		SoundPos = Vector(203,4,-30),
		StartSounds = Sound("trolleybus/trolza5265/pech/cab/on.ogg"),
		LoopSound = Sound("trolleybus/trolza5265/pech/cab/loop.ogg"),
		EndSounds = Sound("trolleybus/trolza5265/pech/cab/off.ogg"),
	})
	self:LoadSystem("Heater",{
		SoundPos = Vector(141,27,-26),
		StartSounds = Sound("trolleybus/trolza5265/pech/int/on.ogg"),
		LoopSound = Sound("trolleybus/trolza5265/pech/int/loop.ogg"),
		EndSounds = Sound("trolleybus/trolza5265/pech/int/off.ogg"),
	},"Interior1")
	self:LoadSystem("Heater",{
		SoundPos = Vector(44,33,-37),
		StartSounds = Sound("trolleybus/trolza5265/pech/int2/on.ogg"),
		LoopSound = Sound("trolleybus/trolza5265/pech/int2/loop.ogg"),
		EndSounds = Sound("trolleybus/trolza5265/pech/int2/off.ogg"),
	},"Interior2")
	self:LoadSystem("Heater",{
		SoundPos = Vector(-49,32,-36),
		StartSounds = Sound("trolleybus/trolza5265/pech/int3/on.ogg"),
		LoopSound = Sound("trolleybus/trolza5265/pech/int3/loop.ogg"),
		EndSounds = Sound("trolleybus/trolza5265/pech/int3/off.ogg"),
	},"Interior3")
	self:LoadSystem("Heater",{
		SoundPos = Vector(-196,26,-17),
		StartSounds = Sound("trolleybus/trolza5265/pech/int4/on.ogg"),
		LoopSound = Sound("trolleybus/trolza5265/pech/int4/loop.ogg"),
		EndSounds = Sound("trolleybus/trolza5265/pech/int4/off.ogg"),
	},"Interior4")

	self:LoadSystem("AccumulatorBattery",{Voltage = 24,MaxCharge = 130})
	self:LoadSystem("AccumulatorBattery",{Voltage = 100,MaxCharge = 1},"AutoMove")
	self:LoadSystem("StaticVoltageConverter",{Voltage = 28})

	self:LoadSystem("Horn",{SoundPos = Vector(207,0,-25)})
	self:LoadSystem("Agit-132",{
		Pos = Vector(206,9.5,-3.8),
		Ang = Angle(0,165,0),
		PlayPos = Vector(0,0,32),
	})

	self:LoadSystem("Buzzer",{
		LoopSound = Sound("trolleybus/trolza5265/buzzer/buzzer_low_air.ogg"),
		SoundPos = Vector(210,25,-7),
	},"LowAir")
	self:LoadSystem("Buzzer",{
		LoopSound = Sound("trolleybus/trolza5265/buzzer/buzzer_low_voltage.ogg"),
		SoundPos = Vector(210,25,-7),
	},"LowVoltage")
	self:LoadSystem("Buzzer",{
		LoopSound = Sound("trolleybus/trolza5265/buzzer/buzzer_low_voltage_AND_low_air.ogg"),
		SoundPos = Vector(210,25,-7),
	},"LowAirVoltage")
	self:LoadSystem("Buzzer",{
		LoopSound = Sound("trolleybus/trolza5265/buzzer/buzzer_stop_request.ogg"),
		SoundPos = Vector(210,25,-7),
	},"StopRequest")
	self:LoadSystem("Buzzer",{
		LoopSound = Sound("trolleybus/trolza5265/buzzer/zadniy_hod.ogg"),
		SoundPos = Vector(-220,0,-36),
		Distance = 400,
	},"BackwardMove")

	local screenmats = {
		init = Material("trolleybus/trolza5265/chergos/chergos_intialize.png"),
		base = Material("trolleybus/trolza5265/chergos/chergos_base_ah.png"),
		turnsignal = Material("trolleybus/trolza5265/chergos/chergos_turningsignal.png"),
		arrowred = Material("trolleybus/trolza5265/chergos/chergos_arrow_red.png"),
	}
	local font = "Trolleybus_System.Trolleybus.TrolZa5265.Chergos"

	local scale = Vector(1,1,1)
	local scalebtns,scaledate,scaleready,scalevoltamp,scalevoltamp2 = scale,scale*0.7,scale*1.1,scale*1.1,scale*2

	self:LoadSystem("MultiScreen",{
		Screens = {
			Screen = {
				Pos = Vector(206,32.06,-4.26),
				Ang = Angle(-45.2,-180,0),
				Size = {6.75,4.65},
				DrawScale = 100,
				DrawDistance = 200,
				Scaled = true,
				DisplayName = function(self,sdata,x,y,pressed)
					if sdata.NW.State==2 and x then
						if sdata.Predefined.State("blackbox",x,y,pressed)>0 then
							return "trolleybus.trolza5265.chergos.blackbox"
						elseif sdata.Predefined.State("diagnostic",x,y,pressed)>0 then
							return "trolleybus.trolza5265.chergos.diagnostic"
						elseif sdata.Predefined.State("settings",x,y,pressed)>0 then
							return "trolleybus.trolza5265.chergos.settings"
						elseif sdata.Utils.InBounds(x,y,2,34,165,185) then
							return "trolleybus.trolza5265.chergos.engamp"
						elseif sdata.Utils.InRadius(x,y,0,300,130) or sdata.Utils.InBounds(x,y,120,345,282,400) then
							return "trolleybus.trolza5265.chergos.voltage"
						elseif sdata.Utils.InRadius(x,y,341,229,150) then
							return "trolleybus.trolza5265.chergos.speed"
						elseif sdata.Utils.InRadius(x,y,607,141,60) then
							return "trolleybus.trolza5265.chergos.pressure1"
						elseif sdata.Utils.InRadius(x,y,607,250,60) then
							return "trolleybus.trolza5265.chergos.pressure2"
						elseif sdata.Utils.InBounds(x,y,602,305,665,351) then
							return "trolleybus.trolza5265.chergos.cnamp"
						elseif sdata.Utils.InBounds(x,y,506,305,590,351) then
							return "trolleybus.trolza5265.chergos.cnvolt"
						elseif sdata.Utils.InBounds(x,y,396,378,471,420) then
							return "trolleybus.trolza5265.chergos.accbatamp"
						elseif sdata.Utils.InBounds(x,y,294,378,362,420) then
							return "trolleybus.trolza5265.chergos.accbatvolt"
						elseif sdata.Utils.InBounds(x,y,605,378,663,420) then
							return "trolleybus.trolza5265.chergos.accbat2amp"
						elseif sdata.Utils.InBounds(x,y,490,378,548,420) then
							return "trolleybus.trolza5265.chergos.accbat2volt"
						elseif sdata.Utils.InBounds(x,y,548,5,662,43) then
							return "trolleybus.trolza5265.chergos.datetime"
						elseif sdata.Utils.InBounds(x,y,155,8,520,39) then
							local rstate = sdata.NW.ReadyState
							local readytext =
								rstate==1 and "highvolt" or
								rstate==2 and "novolt" or
								rstate==3 and "maxspeed" or
								rstate==4 and "noavdu" or
								rstate==5 and "noconn" or
								rstate==6 and "overload" or
								"ready"

							local L = Trolleybus_System.GetLanguagePhrase
							return L("trolleybus.trolza5265.chergos.state",L("trolleybus.trolza5265.chergos.state."..readytext))
						end
					end

					return "trolleybus.trolza5265.chergos"
				end,
				ShouldBeDisabled = function(self,sdata) return !self:GetNWVar("ScreenPower") end,
				DrawScreen = function(self,sdata,scale,w,h,x,y,pressed)
					local state = sdata.NW.State
					if !state then return end

					if state==1 then
						sdata.Utils.DrawMat(0,0,w,h,screenmats.init)
					elseif state==2 then
						sdata.Utils.DrawMat(0,0,w,h,screenmats.base)

						sdata.Utils.DrawText(os.date("%d.%m.%Y"),font,603,14,color_black,1,1,scaledate)
						sdata.Utils.DrawText(os.date("%H:%M:%S"),font,603,31,color_black,1,1,scaledate)

						local rstate = sdata.NW.ReadyState
						local readytext =
							rstate==1 and "ВЫСОКОЕ НАПРЯЖ. КС" or
							rstate==2 and "НЕТ НАПРЯЖЕНИЯ КС" or
							rstate==3 and "МАКСИМАЛЬН. СКОРОСТЬ" or
							rstate==4 and "НЕ ВКЛЮЧЕН АВДУ" or
							rstate==5 and "НЕТ СВЯЗИ" or
							rstate==6 and "ПЕРЕГРУЗКА" or
							"ГОТОВ К РАБОТЕ"

						sdata.Utils.DrawText(readytext,font,340,23,color_white,1,1,scaleready)

						if (self:GetTurnSignal()!=0 or self:GetEmergencySignal()) and Trolleybus_System.TurnSignalTickActive(self) then
							if self:GetTurnSignal()==1 or self:GetEmergencySignal() then
								sdata.Utils.DrawMat(291,204,-0.25,-0.25,screenmats.turnsignal,color_white,0)
							end

							if self:GetTurnSignal()==2 or self:GetEmergencySignal() then
								sdata.Utils.DrawMat(382,204,-0.25,-0.25,screenmats.turnsignal,color_white,180)
							end
						end

						sdata.Utils.DrawText(Format("%i",sdata.NW.Speed or 0),font,328,319,color_white,2,1,scalevoltamp)

						local engamp = sdata.NW.EngAmp or 0
						sdata.EngAmp = Lerp(FrameTime()*15,sdata.EngAmp or engamp,engamp)
						sdata.Utils.DrawMat(0,100,-0.17,-0.17,screenmats.arrowred,color_white,180+sdata.EngAmp/500*90)

						sdata.Utils.DrawText(Format("%i",engamp),font,138,155,color_white,1,1,scalevoltamp2)

						local voltage = sdata.NW.Voltage or 0
						sdata.Voltage = Lerp(FrameTime()*15,sdata.Voltage or voltage,voltage)
						sdata.Utils.DrawMat(0,300,-0.2,-0.2,screenmats.arrowred,color_white,105+sdata.Voltage/1000*160)

						sdata.Utils.DrawText(Format("%i В",voltage),font,199,392,color_white,1,1,scalevoltamp2)

						local speed = sdata.NW.Speed or 0
						sdata.Speed = Lerp(FrameTime()*15,sdata.Speed or speed,speed)
						sdata.Utils.DrawMat(342,228,-0.27,-0.27,screenmats.arrowred,color_white,45-sdata.Speed/80*270)

						local air1 = self:GetSystem("Pneumatic"):GetAir(1)
						sdata.Air1 = Lerp(FrameTime()*15,sdata.Air1 or air1,air1)
						sdata.Utils.DrawMat(607,142,-0.1,-0.1,screenmats.arrowred,color_white,45-sdata.Air1/1000*270)

						local air2 = self:GetSystem("Pneumatic"):GetAir(2)
						sdata.Air2 = Lerp(FrameTime()*15,sdata.Air2 or air2,air2)
						sdata.Utils.DrawMat(607,250,-0.1,-0.1,screenmats.arrowred,color_white,45-sdata.Air2/1000*270)

						sdata.Utils.DrawText(Format("%i В",sdata.NW.VoltCN or 0),font,538,335,color_white,1,1,scalevoltamp)
						sdata.Utils.DrawText(Format("%i А",sdata.NW.Amp or 0),font,624,335,color_white,1,1,scalevoltamp)

						local battery = self:GetSystem("AccumulatorBattery")
						sdata.Utils.DrawText(Format("%i В",battery:GetLastVoltage()),font,299,400,color_white,0,1,scalevoltamp)
						sdata.Utils.DrawText(Format("%i А",battery:GetLastAmperage()),font,466,400,color_white,2,1,scalevoltamp)

						local battery = self:GetSystem("AccumulatorBattery","AutoMove")
						sdata.Utils.DrawText(Format("%i В",battery:GetLastVoltage()),font,493,400,color_white,0,1,scalevoltamp)
						sdata.Utils.DrawText(Format("%i А",battery:GetLastAmperage()),font,661,400,color_white,2,1,scalevoltamp)

						sdata.Predefined.Draw("blackbox",x,y,pressed)
						sdata.Predefined.Draw("diagnostic",x,y,pressed)
						sdata.Predefined.Draw("settings",x,y,pressed)
					end
				end,
				OnEnable = function(self,sdata)
					sdata.NW.State = 0
					sdata.NW.StartTime = CurTime()
					sdata.NW.Timer = CurTime()+math.Rand(1,2)
				end,
				OnDisable = function(self,sdata)
					sdata.NW.State = nil
				end,
				Think = function(self,sdata)
					if CLIENT then return end

					local state = sdata.NW.State
					if !state then return end

					local timer = sdata.NW.Timer

					if state==0 and CurTime()>=timer then
						sdata.NW.State,sdata.NW.Timer = 1,CurTime()+math.Rand(3,6)
					elseif state==1 and CurTime()>=timer then
						sdata.NW.State = 2
					elseif state==2 then
						sdata.NW.EngAmp = self:GetSystem("Engine"):GetAmperage()
						sdata.NW.Voltage = self.ElCircuit:GetVoltage()
						sdata.NW.Speed = math.abs(self:GetSystem("Engine"):GetMoveSpeed())

						sdata.NW.Amp = self:CalcElectricCurrentUsage()
						sdata.NW.VoltCN = self:GetPowerFromCN()

						sdata.NW.ReadyState = 
							sdata.NW.VoltCN>=800 and 1 or
							sdata.NW.VoltCN<=200 and 2 or
							sdata.NW.Speed>=80 and 3 or
							!self.AVDUActive and !self:IsUseAutoMoveCircuit() and 4 or
							!self:ButtonIsDown("key") and 5 or
							sdata.NW.Amp>660 and 6 or
							0
						
						if sdata.NW.Amp>660 then self:SetAVDUActive(false) end
					end
				end,
				Predefined = {
					blackbox = {x = 2,y = 425,w = 223,h = 38,draw = function(self,sdata,x,y,w,h,state)
						sdata.Utils.DrawText("ЧЕРНЫЙ ЯЩИК",font,x+w/2,y+h/2,color_black,1,1,scalebtns)
					end},
					diagnostic = {x = 229,y = 425,w = 223,h = 38,draw = function(self,sdata,x,y,w,h,state)
						sdata.Utils.DrawText("ДИАГНОСТИКА",font,x+w/2,y+h/2,color_black,1,1,scalebtns)
					end},
					settings = {x = 452,y = 425,w = 223,h = 38,draw = function(self,sdata,x,y,w,h,state)
						sdata.Utils.DrawText("НАСТРОЙКА",font,x+w/2,y+h/2,color_black,1,1,scalebtns)
					end},
				}
			},
		},
	})
end

function ENT:ToggleDoorWithHand(door)
	if self:CanDoorsMove(door) then return end
	
	if self:DoorIsOpened(door) then self:CloseDoorWithHand(door) else self:OpenDoorWithHand(door) end
end