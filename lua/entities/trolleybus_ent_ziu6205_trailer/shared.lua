-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.Model = "models/trolleybus/ziu6205/trailer.mdl"

ENT.HasPoles = true
ENT.TrolleyPoleLength = 245.5
ENT.TrolleyPolePos = Vector(94.37,0.45,55.62)
ENT.TrolleyPoleSideDist = 9.37
ENT.TrolleyPoleDownedAngleLeft = Angle(-1,179.9,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-1,-179.9,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-6,179.9,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-6,-179.9,0)

ENT.PassCapacity = 64
ENT.AccBatteryVoltage = 20

ENT.OtherSeats = {}

ENT.InteriorLights = {
	{pos = Vector(19,0,26),size = 300,style = 0,brightness = 3,color = Color(255,140,32)},
}

ENT.DoorsData = {
	["door3"] = {
		model = "models/trolleybus/ziu6205/door_trailer_first.mdl",
		pos = Vector(84.42,-44.48,1.58),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_start.ogg",500},
		opensoundend = {"trolleybus/door_open_end.ogg",500},
		movesound = {"trolleybus/door_move.ogg",500},
		closesoundstart = {"trolleybus/door_start.ogg",500},
		closesoundend = {"trolleybus/door_close_end.ogg",500},
		anim = true,
		speedmult = 0.6,
	},
	["door4"] = {
		model = "models/trolleybus/ziu6205/door_trailer_second.mdl",
		pos = Vector(-86.74,-44.48,1.58),
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

local model_trapdoor = {
	model = "models/trolleybus/ziu6205/trapdoor.mdl",
	offset_ang = Angle(-90,0,0),
	offset_pos = Vector(-2,21,-19.5),
	sounds = {
		On = {"trolleybus/ziu6205/trapdoor_open.ogg",200},
		Off = {"trolleybus/ziu6205/trapdoor_close.ogg",200},
	},
	anim = true,
	maxdrawdistance = 1000,
	speedmult = 0.5,
}

ENT.PanelsData = {
	["reartrapdoor"] = {
		pos = Vector(-118.35,-5.57,46.64),
		ang = Angle(40.7,0,0),
		size = {11,7},
	},
	["trapdoors"] = {
		pos = Vector(0,-21,47),
		ang = Angle(90,0,0),
		size = {42,76},
	},
	["ladder"] = {
		pos = Vector(-127,10,37),
		ang = Angle(0,-180,0),
		size = {20,50},
	},
}

ENT.ButtonsData = {
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
			pos = {0,58.3},
			size = {ENT.PanelsData["trapdoors"].size[1],18},
		},
		toggle = true,
	},
	["ladder"] = {
		name = "trolleybus.ziu6205.btns.ladder",
		model = {
			model = "models/trolleybus/ziu6205/rear_footstep.mdl",
			offset_ang = Angle(0,180,0),
			offset_pos = Vector(-1.9,10,-21.5),
			sounds = {
				On = {"trolleybus/ziu6205/ladder_down.ogg",200},
				Off = {"trolleybus/ziu6205/ladder_up.ogg",200},
			},
			anim = true,
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
	["reartrapdoor"] = {
		name = "trolleybus.ziu6205.btns.reartrapdoor",
		model = {
			model = "models/trolleybus/ziu6205/route_trapdoor_small.mdl",
			anim = true,
			offset_ang = Angle(-40,0,0),
			offset_pos = Vector(0,5.5,-6.7),
			maxdrawdistance = 1000,
			speedmult = 0.5,
		},
		panel = {
			name = "reartrapdoor",
			pos = {0,0},
			size = ENT.PanelsData["reartrapdoor"].size,
		},
		toggle = true,
	},
}

function ENT:LoadSystems()
	self:LoadSystem("AccumulatorBattery",{
		Voltage = self.AccBatteryAmperage,
	})
	self:LoadSystem("MotorVentilator",{
		SoundPos = Vector(32.1,33.18,-37.88),
		SoundDistance = 1000,
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
			["small"] = {
				type = 2,
				width = 8,
				height = 5,
				model = {
					model = "models/trolleybus/routeplate.mdl",
					offset_pos = Vector(-0.25,4,-5.1),
					offset_ang = Angle(),
					bg = "1",
				},
				nfont = "Trolleybus_System.Trolleybus.ZiU6205.RouteDisplay.RearNumber",
				drawscale = 10,
			},
		},
		Positions = {
			{
				pos = Vector(-42.33,-46.27,11.64),
				ang = Angle(-2,-90,0),
				type = "default",
			},
			{
				pos = Vector(-125.62,4,47.39),
				ang = Angle(0,180,0),
				type = "small",
				shouldbeactive = function(sys,self) return self:ButtonIsDown("reartrapdoor") end,
				think = function(sys,self,ent) ent:SetSkin(self:GetScheduleLight()>0 and 1 or 0) end,
			},
		},
	})
end