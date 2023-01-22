-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.Model = "models/trolleybus/aksm333/trailer_body.mdl"
ENT.HasPoles = true
ENT.TrolleyPoleLength = 262.5
ENT.TrolleyPolePos = Vector(-130.74,0,65.34)
ENT.TrolleyPoleSideDist = 9
ENT.TrolleyPoleDownedAngleLeft = Angle(-2.1,179.9,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-2.1,-179.9,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-6,179,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-6,-179,0)

ENT.PassCapacity = 70

ENT.OtherSeats = {}

ENT.InteriorLights = {
	{pos = Vector(-130,0,30),size = 200,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(-268,0,30),size = 200,style = 0,brightness = 3,color = Color(255,255,255)},
}

ENT.DoorsData = {
	["door4"] = {
		model = "models/trolleybus/aksm333/door4.mdl",
		pos = Vector(-159.15,-50.65,0),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_aksm321_start_open.ogg",500},
		opensoundend = {"trolleybus/door_aksm321_end.ogg",500},
		movesound = {"trolleybus/door_aksm321_move.ogg",500},
		closesoundstart = {"trolleybus/door_aksm321_start_close.ogg",500},
		closesoundend = {"trolleybus/door_aksm321_end.ogg",500},
		poseparameter = "state",
		speedmult = 1,
	},
	["door5"] = {
		model = "models/trolleybus/aksm333/door5.mdl",
		pos = Vector(-298.4,-50.65,0),
		ang = Angle(),
		opensoundstart = {"trolleybus/door_aksm321_start_open.ogg",500},
		opensoundend = {"trolleybus/door_aksm321_end.ogg",500},
		movesound = {"trolleybus/door_aksm321_move.ogg",500},
		closesoundstart = {"trolleybus/door_aksm321_start_close.ogg",500},
		closesoundend = {"trolleybus/door_aksm321_end.ogg",500},
		poseparameter = "state",
		speedmult = 1,
	},
}

ENT.ButtonsData = {}
ENT.PanelsData = {}

function ENT:_SetupNameplates(color)
	Trolleybus_System.BuildNameplatePanel(self,"nameplate_rear",Vector(-364.73,-30.21,47.79),Angle(-4.4,-180,0),14,9,0,"Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.RearNumber",nil,nil,color,true)
	Trolleybus_System.BuildNameplatePanel(self,"nameplate_right",Vector(-253.86,-50.21,48.64),Angle(-5.6,-90,0),51,7,2,"Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.RouteNumber","Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.Route",10,color,true)

	Trolleybus_System.BuildInteriorNameplate(self,"int_nameplate",Vector(-95.72,21.23,44.83),Angle(0,-180,0),42.7,2.7,function(self)
		local bus = self:GetTrolleybus()

		if IsValid(bus) and bus:GetNWVar("LowPower") then
			return bus.SystemsLoaded and bus:GetSystem("Agit-132"):GetStopText(true)
		end
	end,"Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.Integral",200,color,10)
end

ENT:_SetupNameplates(Color(255,155,0))