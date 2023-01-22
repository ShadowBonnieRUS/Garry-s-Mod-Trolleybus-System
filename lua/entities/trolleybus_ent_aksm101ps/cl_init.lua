-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/aksm101ps.png"

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.Nameplate",{
	font = "Aero Matics Stencil",
	size = 32,
	extended = true,
	weight = 600,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.NameplateNumber",{
	font = "Aero Matics Stencil",
	size = 80,
	extended = true,
	weight = 550,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM101PS.RouteDisplay.RearNumber",{
	font = "Aero Matics Stencil",
	size = 60,
	extended = true,
	weight = 600,
})

ENT.PassPositionBounds = {
	{Vector(-210,41,-26),Vector(-195,-41,-26)},
	{Vector(-191,41,-26),Vector(-136,-23,-26)},
	{Vector(-136,14,-26),Vector(165,-14,-26)},
	{Vector(55,-40,-26),Vector(100,-14,-26)},
}
ENT.PassPositionSeats = {
	{Vector(-103,35,-9),Angle(0,-180,0)},
	{Vector(-103,18,-9),Angle(0,-180,0)},
	
	{Vector(-85,35,-7),Angle(0,0,0)},
	{Vector(-85,18,-7),Angle(0,0,0)},
	
	{Vector(-61,35,-13),Angle(0,0,0)},
	{Vector(-61,18,-13),Angle(0,0,0)},
	
	{Vector(-36,35,-13),Angle(0,0,0)},
	{Vector(-36,18,-13),Angle(0,0,0)},
	
	{Vector(-10,35,-13),Angle(0,0,0)},
	{Vector(-10,18,-13),Angle(0,0,0)},
	
	{Vector(17,35,-13),Angle(0,0,0)},
	{Vector(17,18,-13),Angle(0,0,0)},
	
	{Vector(42,35,-13),Angle(0,0,0)},
	{Vector(42,18,-13),Angle(0,0,0)},
	
	{Vector(65,35,-13),Angle(0,0,0)},
	{Vector(65,18,-13),Angle(0,0,0)},
	
	{Vector(123,30,-10),Angle(0,-180,0)},
	{Vector(148,32,-8),Angle(0,-90,0)},
	
	{Vector(-103,-35,-9),Angle(0,-180,0)},
	{Vector(-103,-18,-9),Angle(0,-180,0)},
	
	{Vector(-85,-35,-7),Angle(0,0,0)},
	{Vector(-85,-18,-7),Angle(0,0,0)},
	
	{Vector(-61,-35,-13),Angle(0,0,0)},
	{Vector(-61,-18,-13),Angle(0,0,0)},
	
	{Vector(-36,-35,-13),Angle(0,0,0)},
	{Vector(-36,-18,-13),Angle(0,0,0)},
	
	{Vector(123,-35,-10),Angle(0,-180,0)},
	{Vector(123,-18,-10),Angle(0,-180,0)},
	
	{Vector(143,-35,-8),Angle(0,0,0)},
	{Vector(143,-18,-8),Angle(0,0,0)},
}

ENT.TrolleyPoleModel = "models/trolleybus/aksm101ps/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/aksm101ps/pole_wheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,0)
ENT.TrolleyPoleWheelRotate = Angle(19,0,0)
ENT.TrolleyPoleDrawRotate = Angle(-0.7,179.85,0)
ENT.TrolleyPoleCatcherWirePos = Vector(235,0,-3)

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-222.23,0,42.82),
	CenterDist = 21.64,
	BoundMin = Vector(-1,-9),
	BoundMax = Vector(1,9),
}

ENT.SteerData1 = {
	model = "models/trolleybus/aksm101ps/steering_wheel.mdl",
	pos = Vector(200.12,28.21,6.71),
	ang = Angle(-15,0,0),
	rollmult = 450,
}
ENT.SteerData = ENT.SteerData1

ENT.SteerData2 = {
	model = "models/trolleybus/aksm101ps/steering_wheel_maz.mdl",
	pos = Vector(199.8,28.21,6.5),
	ang = Angle(-15,0,0),
	rollmult = 450,
}

ENT.CabineLightData = {
	pos = Vector(202,14.77,45),
	ang = Angle(90,0,0),
	brightness = 0.1,
	color = Color(255,140,32),
	farz = 80,
	nearz = 1,
	fov = 179,
	texture = "effects/flashlight001",
	
	dlight_pos = Vector(189,32,45),
	dlight_size = 200,
	dlight_brightness = 4,
}

ENT.CameraView = {
	DriverCameraPos = Vector(182,28,25),
	Pos = Vector(0,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(200,55,20),Angle(0,180,0)},
	MirrorRight = {Vector(203,-55,20),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-9,-14,-40),Vector(30,14,20)},
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(220.5,38.81,-32.37),size = 35},
	{pos = Vector(204.95,48.61,-7.75),size = 35},
	{pos = Vector(-219.2,36.79,-14.11),size = 35},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(220.5,-38.81,-32.37),size = 35},
	{pos = Vector(204.95,-48.61,-7.75),size = 35},
	{pos = Vector(-219.2,-36.79,-14.11),size = 35},
}

ENT.TurnSignalSoundOn = "trolleybus/turnsound_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/turnsound_off.ogg"

ENT.HeadLights = {
	brightness = 1,

	{pos = Vector(220.57,31.71,-32.32),ang = Angle(),color = Color(255,230,150),size = 45,brightness = 0.5,farz = 500,nearz = 5,fov = 60,texture = "effects/flashlight001"},
	{pos = Vector(220.57,-31.71,-32.32),ang = Angle(),color = Color(255,230,150),size = 45,brightness = 0.5,farz = 500,nearz = 5,fov = 60,texture = "effects/flashlight001"},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(216.76,40.92,40.58),size = 30,color = Color(255,230,150)},
	{pos = Vector(216.76,-40.92,40.58),size = 30,color = Color(255,230,150)},
	{pos = Vector(-219.18,36.79,-17.05),size = 30,color = Color(255,0,0)},
	{pos = Vector(-219.18,-36.79,-17.05),size = 30,color = Color(255,0,0)},
	{pos = Vector(-218.7,32.41,46.42),size = 30,color = Color(255,0,0)},
	{pos = Vector(-218.7,-32.41,46.42),size = 30,color = Color(255,0,0)},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-219.2,36.75,-10.42),size = 35},
	{pos = Vector(-219.2,-36.75,-10.42),size = 35},
}
ENT.BackwardMoveLights = {
	brightness = 1,
	
	{pos = Vector(-219.21,36.81,-20.07),size = 35},
	{pos = Vector(-219.21,-36.81,-20.07),size = 35},
}

local interior = "models/trolleybus/aksm101ps/part_interior.mdl"
local seats = "models/trolleybus/aksm101ps/part_seats.mdl"

local wipers1 = "models/trolleybus/aksm101ps/wiper_left.mdl"
local wipers2 = "models/trolleybus/aksm101ps/wiper_right.mdl"

local lamp = "models/trolleybus/aksm101ps/interior_lamp.mdl"
local lamps = {
	{Vector(140.01,32.21,47.63),Angle(0,0,-10.3),0},
	{Vector(81.86,32.21,47.63),Angle(0,0,-10.3),1},
	{Vector(20.21,32.21,47.63),Angle(0,0,-10.3),0},
	{Vector(-35.14,32.21,47.63),Angle(0,0,-10.3),1},
	{Vector(-91.72,32.21,47.63),Angle(0,0,-10.3),0},
	{Vector(-162.66,32.21,47.63),Angle(0,0,-10.3),1},
	
	{Vector(-162.18,-8.17,49.37),Angle(0,0,0.3),0},
	{Vector(-91.79,-32.53,47.57),Angle(0,0,10.3),1},
	{Vector(-35.22,-32.53,47.57),Angle(0,0,10.3),0},
	{Vector(81.91,-32.53,47.57),Angle(0,0,10.3),0},
	{Vector(140.03,-32.53,47.57),Angle(0,0,10.3),1},
	
	{Vector(188.39,32.21,47.63),Angle(0,0,-10.3),2},
}

local doorlight = "models/trolleybus/aksm101ps/door_illumination.mdl"
local footlight = "models/trolleybus/aksm101ps/footstep_illumination.mdl"

local doorlights = {
	{Vector(173.45,-33.51,-39.51),Angle(0,0,0),"Door1Light",true},
	{Vector(15.1,-39.49,36.3),Angle(0,0,-10.4),"Door2Light"},
	{Vector(33.33,-33.51,-39.51),Angle(0,0,0),"Door2Light",true},
	{Vector(14.2,-33.51,-39.51),Angle(0,0,0),"Door2Light",true},
	{Vector(-170.5,-39.49,36.3),Angle(0,0,-10.4),"Door3Light"},
	{Vector(-152.4,-33.51,-39.51),Angle(0,0,0),"Door3Light",true},
	{Vector(-170.59,-33.51,-39.51),Angle(0,0,0),"Door3Light",true},
}

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	self:CreateCustomClientEnt("Interior",interior)
	self:CreateCustomClientEnt("Seats",seats)
	
	self:CreateCustomClientEnt("wiperleft",wipers1):SetLocalPos(Vector(220.46,21.75,-4))
	self:CreateCustomClientEnt("wiperright",wipers2):SetLocalPos(Vector(220.46,-21.75,-4))
	
	for k,v in ipairs(lamps) do
		local lamp = self:CreateCustomClientEnt("Lamp"..k,lamp)
		lamp:SetLocalPos(v[1])
		lamp:SetLocalAngles(v[2])
	end
	
	for k,v in ipairs(doorlights) do
		local doorlight = self:CreateCustomClientEnt("doorlight"..k,v[4] and footlight or doorlight)
		doorlight:SetLocalPos(v[1])
		doorlight:SetLocalAngles(v[2])
	end
end

function ENT:Think()
	BaseClass.Think(self)
	
	local intlight = self:GetInteriorLight()>0
	local cablight = self:GetCabineLight()>0

	for k,v in ipairs(lamps) do
		local lamp = self:GetCustomClientEnt("Lamp"..k)
		if !IsValid(lamp) then continue end
		
		local bg = (
			v[3]==0 and intlight and self:GetNWVar("InteriorLightActive1") or
			v[3]==1 and intlight and self:GetNWVar("InteriorLightActive2") or
			v[3]==2 and cablight
		) and 1 or 0

		lamp:SetBodygroup(1,bg)
	end
	
	for k,v in ipairs(doorlights) do
		local doorlight = self:GetCustomClientEnt("doorlight"..k)
		if !IsValid(doorlight) then continue end
		
		doorlight:SetSkin(self:GetNWVar(v[3]) and 1 or 0)
	end
	
	local wiperleft = self:GetCustomClientEnt("wiperleft")
	if IsValid(wiperleft) then
		local spd = self:GetNWVar("WipersLeft") and 1 or 0
		
		self.WiperLeftSpd = self.WiperLeftSpd or spd
		self.WiperLeftSpd = self.WiperLeftSpd<spd and math.min(self.WiperLeftSpd+self.DeltaTime*3,spd) or math.max(self.WiperLeftSpd-self.DeltaTime*3,spd)
		
		self.WiperLeftMoveState = self.WiperLeftMoveState or 0
		self.WiperLeftState = self.WiperLeftState and self.WiperLeftMoveState<1 or !self.WiperLeftState and self.WiperLeftMoveState<=0
	
		self.WiperLeftMoveState = self.WiperLeftState and math.min(1,self.WiperLeftMoveState+self.DeltaTime*self.WiperLeftSpd) or math.max(0,self.WiperLeftMoveState-self.DeltaTime*self.WiperLeftSpd)
		
		wiperleft:SetCycle(self.WiperLeftMoveState)
	end
	
	local wiperright = self:GetCustomClientEnt("wiperright")
	if IsValid(wiperright) then
		local spd = self:GetNWVar("WipersRight") and 1 or 0
		
		self.WiperRightSpd = self.WiperRightSpd or spd
		self.WiperRightSpd = self.WiperRightSpd<spd and math.min(self.WiperRightSpd+self.DeltaTime*3,spd) or math.max(self.WiperRightSpd-self.DeltaTime*3,spd)
		
		self.WiperRightMoveState = self.WiperRightMoveState or 0
		self.WiperRightState = self.WiperRightState and self.WiperRightMoveState<1 or !self.WiperRightState and self.WiperRightMoveState<=0
	
		self.WiperRightMoveState = self.WiperRightState and math.min(1,self.WiperRightMoveState+self.DeltaTime*self.WiperRightSpd) or math.max(0,self.WiperRightMoveState-self.DeltaTime*self.WiperRightSpd)
		
		wiperright:SetCycle(self.WiperRightMoveState)
	end
end