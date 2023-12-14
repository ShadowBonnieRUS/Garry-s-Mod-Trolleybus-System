-- Copyright © Platunov I. M., 2021 All rights reserved

ENT.Model = "models/trolleybus/aksm333o/trailer_body.mdl"
ENT.HasPoles = true
ENT.TrolleyPoleLength = 262.5
ENT.TrolleyPolePos = Vector(-135.35,0,63.25)
ENT.TrolleyPoleSideDist = 8.95
ENT.TrolleyPoleDownedAngleLeft = Angle(-2.1,179.9,0)
ENT.TrolleyPoleDownedAngleRight = Angle(-2.1,-179.9,0)
ENT.TrolleyPoleCatcheredAngleLeft = Angle(-6,179,0)
ENT.TrolleyPoleCatcheredAngleRight = Angle(-6,-179,0)

ENT.PassCapacity = 70

ENT.OtherSeats = {}

ENT.InteriorLights = {
	{pos = Vector(-286.06,0,28),size = 200,style = 0,brightness = 3,color = Color(255,255,255)},
	{pos = Vector(-145.08,0,28),size = 200,style = 0,brightness = 3,color = Color(255,255,255)},
}

ENT.DoorsData = {
	["door4"] = {
		model = "models/trolleybus/aksm333o/door4.mdl",
		pos = Vector(-163.94,-50.58,0),
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
		model = "models/trolleybus/aksm333o/door5.mdl",
		pos = Vector(-303.22,-50.58,0),
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
	local clear1 = Trolleybus_System.BuildNameplatePanel(self,"nameplate_rear",Vector(-369.61,-31.02,44.69),Angle(-4,-180,0),12,7,0,"Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.RearNumber",nil,nil,color,true)
	local clear2 = Trolleybus_System.BuildNameplatePanel(self,"nameplate_right",Vector(-256.51,-50.29,45.47),Angle(-4.7,-90,0),50.5,7.2,2,"Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.RouteNumber","Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.Route",10,color,true)

	local clear3 = Trolleybus_System.BuildInteriorNameplate(self,"int_nameplate",Vector(-100.35,21.34,43.8),Angle(0,-180,0),42.8,2.8,function(self)
		local bus = self:GetTrolleybus()

		if IsValid(bus) and bus:GetNWVar("LowPower") then
			return bus.SystemsLoaded and bus:GetSystem("Agit-132"):GetStopText(true)
		end
	end,"Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.Integral",200,color,10)
	
	return function() clear1() clear2() clear3() end
end