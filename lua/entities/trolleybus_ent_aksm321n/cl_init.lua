-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/aksm321n.png"

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.RearNumber",{
	font = "Minecart LCD",
	size = 45,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Number",{
	font = "Minecart LCD",
	size = 95,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Name",{
	font = "Minecart LCD",
	size = 40,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321n.RouteDisplay.Integral",{
	font = "Minecart LCD",
	size = 38,
	extended = true,
})

ENT.PassPositionBounds = {
	{Vector(-200,9,-52),Vector(-220,-45,-50)},
	{Vector(-142,-45,-52),Vector(-196,9,-52)},
	{Vector(-140,13,-52),Vector(-30,-13,-52)},
	{Vector(-29,-44,-52),Vector(28,46,-52)},
	{Vector(49,46,-52),Vector(29,-16,-52)},
	{Vector(49,-13,-52),Vector(166,16,-52)},
	{Vector(166,-17,-52),Vector(191,-45,-52)},
}

ENT.PassPositionSeats = {
	{Vector(-222,21,-21),Angle(0,0,0)},
	{Vector(-222,38,-21),Angle(0,0,0)},
	
	{Vector(-181,37,-22),Angle(0,180,0)},
	{Vector(-181,19,-22),Angle(0,180,0)},
	{Vector(-158,19,-22),Angle(0,0,0)},
	{Vector(-158,37,-22),Angle(0,0,0)},
	
	{Vector(-114,38,-19),Angle(0,180,0)},
	{Vector(-114,21,-19),Angle(0,180,0)},
	{Vector(-89,22,-19),Angle(0,0,0)},
	{Vector(-89,38,-19),Angle(0,0,0)},
	
	{Vector(-114,-22,-19),Angle(0,180,0)},
	{Vector(-114,-38,-19),Angle(0,180,0)},
	{Vector(-89,-38,-19),Angle(0,0,0)},
	{Vector(-89,-22,-19),Angle(0,0,0)},
	
	{Vector(-54,-22,-23),Angle(0,0,0)},
	{Vector(-54,-38,-23),Angle(0,0,0)},
	
	{Vector(-54,38,-23),Angle(0,0,0)},
	
	{Vector(40,-34,-33),Angle(0,0,0)},
	
	{Vector(67,-38,-33),Angle(0,0,0)},
	{Vector(67,-22,-33),Angle(0,0,0)},
	
	{Vector(63,22,-33),Angle(0,0,0)},
	{Vector(63,38,-33),Angle(0,0,0)},
	
	{Vector(106,38,-33),Angle(0,180,0)},
	{Vector(106,22,-33),Angle(0,180,0)},
	
	{Vector(107,-22,-33),Angle(0,180,0)},
	{Vector(107,-38,-33),Angle(0,180,0)},
}

ENT.SteerData = {
	model = "models/trolleybus/aksm321n/steer.mdl",
	pos = Vector(209.75,30.55,-16),
	ang = Angle(-17,0,0),
	rollmult = 450,
}

ENT.CabineLightData = {
	pos = Vector(200,0,46),
	ang = Angle(90,0,0),
	brightness = 0.3,
	color = Color(255,255,255),
	farz = 100,
	nearz = 1,
	fov = 179,
	texture = "effects/flashlight001",
	
	dlight_pos = Vector(200,0,19),
	dlight_size = 200,
	dlight_brightness = 4,
}

ENT.CameraView = {
	DriverCameraPos = Vector(190,30,3),
	Pos = Vector(0,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(211,58,14),Angle(0,180,0)},
	MirrorRight = {Vector(230,-63,12),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-20,-16,-40),Vector(30,18,30)},
}

ENT.TrolleyPoleModel = "models/trolleybus/aksm321n/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/aksm321n/polewheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,0.3)
ENT.TrolleyPoleDrawRotate = Angle(-20.05,180,0)
ENT.TrolleyPoleCatcherWirePos = Vector(250,0,-4.25)

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-233,0,57),
	CenterDist = 27,
	BoundMin = Vector(-6,-19),
	BoundMax = Vector(-1,19),
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(231.69,48.91,-45.6),size = 40},
	{pos = Vector(228.66,51.52,-24.74),size = 45},
	{pos = Vector(-239.39,43.67,-20.65),size = 50},
}

ENT.TurnSignalRight = {
	brightness = 1,
	
	{pos = Vector(232.07,-48.76,-45.27),size = 40},
	{pos = Vector(228.63,-51.57,-24.76),size = 45},
	{pos = Vector(-239.33,-43.78,-20.46),size = 50},
}

ENT.TurnSignalSoundOn = "trolleybus/turnsound_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/turnsound_off.ogg"

ENT.HeadLights = {
	brightness = 1,

	{pos = Vector(236,43.2,-43.62),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
	{pos = Vector(236,-43.2,-43.62),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(231.86,-48.83,-42.79),size = 40,color = Color(255,255,255)},
	{pos = Vector(231.86,48.85,-42.79),size = 40,color = Color(255,255,255)},
	{pos = Vector(229.88,40.22,36.39),size = 40,color = Color(255,255,255)},
	{pos = Vector(229.88,-40.2,36.39),size = 40,color = Color(255,255,255)},
	
	{pos = Vector(189.39,51.12,-43.32),size = 40,color = Color(255,155,0)},
	{pos = Vector(61.38,51.12,-43.32),size = 40,color = Color(255,155,0)},
	{pos = Vector(-42.23,51.12,-43.32),size = 40,color = Color(255,155,0)},
	{pos = Vector(-168.45,51.12,-43.32),size = 40,color = Color(255,155,0)},
	{pos = Vector(-233.14,51.5,-43.32),size = 40,color = Color(255,155,0)},
	
	{pos = Vector(164.37,-51.08,-43.2),size = 40,color = Color(255,155,0)},
	{pos = Vector(53.48,-51.08,-43.25),size = 40,color = Color(255,155,0)},
	{pos = Vector(-47.12,-51.08,-43.25),size = 40,color = Color(255,155,0)},
	{pos = Vector(-131.67,-51.08,-43.25),size = 40,color = Color(255,155,0)},
	{pos = Vector(-233.2,-51.49,-43.25),size = 40,color = Color(255,155,0)},
	
	{pos = Vector(-235.35,37.79,46.58),size = 40,color = Color(255,0,0)},
	{pos = Vector(-235.35,-37.85,46.58),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.3,-43.79,-16.88),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.3,43.78,-16.88),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.3,43.78,-33.56),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.3,-43.79,-33.56),size = 40,color = Color(255,0,0)},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-239.3,-43.79,-26.04),size = 50},
	{pos = Vector(-239.3,43.78,-26.04),size = 50},
}
ENT.BackwardMoveLights = {
	brightness = 1,

	{pos = Vector(-239.3,43.78,-30.86),size = 45},
	{pos = Vector(-239.3,-43.71,-30.86),size = 45},
}

local interior1 = "models/trolleybus/aksm321n/interior.mdl"
local interior2 = "models/trolleybus/aksm321n/interior2.mdl"
local lamp = "models/trolleybus/aksm321n/lamp.mdl"
local wipers = "models/trolleybus/aksm321n/wipers.mdl"
local doorlight = "models/trolleybus/aksm321n/doorlight.mdl"

local handrails1 = "models/trolleybus/aksm321n/handrails.mdl"
local handrails2 = "models/trolleybus/aksm321n/handrails2.mdl"

local seats = {
	"models/trolleybus/aksm321n/seats1.mdl",
	"models/trolleybus/aksm321n/seats2.mdl",
	"models/trolleybus/aksm321n/seats3.mdl",
}

local lamps = {
	{Vector(117.51,25.73,40.74),Angle(171.4,-90,0)},
    {Vector(48,0,42.26),Angle(-180,-90,0)},
    {Vector(-8,0,42.26),Angle(-180,-90,0)},
    {Vector(-58,0,42.26),Angle(-180,-90,0)},
	{Vector(-115,0,42.26),Angle(-180,-90,0)},
    {Vector(-175,0,42.26),Angle(-180,-90,0)},
    
    {Vector(211.65,23,40.78),Angle(180,-180,0),true},
}

local function CreateModel(self,index,model,pos,ang)
	local ent = self:CreateCustomClientEnt(index,model)
	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)
	
	return ent
end

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	local interior1 = CreateModel(self,"interior1",interior1)
	interior1:SetBodygroup(1,self:GetSpawnSetting("handrail_windows")-1)
	
	local interior2 = CreateModel(self,"interior2",interior2)
	interior2:SetBodygroup(1,self:GetSpawnSetting("ceiling")-1)
	interior2:SetBodygroup(2,self:GetSpawnSetting("integral_color")-1)
	interior2:SetBodygroup(3,self:GetSpawnSetting("manometers")-1)
	interior2:SetBodygroup(4,self:GetSpawnSetting("wnddet")-1)
	
	CreateModel(self,"seats",seats[self:GetSpawnSetting("seats")])
	
	local doorlight1 = CreateModel(self,"doorlight1",doorlight)
	doorlight1:SetBodygroup(0,0)
	
	local doorlight2 = CreateModel(self,"doorlight2",doorlight)
	doorlight2:SetBodygroup(0,1)
	
	local doorlight3 = CreateModel(self,"doorlight3",doorlight)
	doorlight3:SetBodygroup(0,2)
	
	CreateModel(self,"handrails",handrails1)
	CreateModel(self,"handrails2",handrails2)
	
	for k,v in ipairs(lamps) do
		local lamp = CreateModel(self,"lamp"..k,lamp,v[1],v[2])
		lamp:SetBodygroup(0,self:GetSpawnSetting("lamps")-1)
		lamp.Cabine = v[3]
	end
	
	CreateModel(self,"wipers",wipers,Vector(234.81,0.19,-23.77),Angle(0,0,0))
end

function ENT:Think()
	BaseClass.Think(self)
	
	local cabine = self:GetCabineLight()>0
	local interior = self:GetInteriorLight()>0
	
	for k,v in ipairs(lamps) do
		local lamp = self:GetCustomClientEnt("lamp"..k)
		if !IsValid(lamp) then continue end
	
		lamp:SetSkin(Either(lamp.Cabine,cabine,interior) and 1 or 0)
	end
	
	local doorlight1 = self:GetCustomClientEnt("doorlight1")
	if IsValid(doorlight1) then
		doorlight1:SetSkin(self:GetNWVar("Door1Light") and 1 or 0)
	end
	
	local doorlight2 = self:GetCustomClientEnt("doorlight2")
	if IsValid(doorlight2) then
		doorlight2:SetSkin(self:GetNWVar("Door2Light") and 1 or 0)
	end
	
	local doorlight3 = self:GetCustomClientEnt("doorlight3")
	if IsValid(doorlight3) then
		doorlight3:SetSkin(self:GetNWVar("Door3Light") and 1 or 0)
	end
	
	local wipers = self:GetCustomClientEnt("wipers")
	if IsValid(wipers) then
		self._WiperState = self._WiperState or 0
		self._WiperMoveState = self._WiperMoveState or false
		
		local guitarstate = self:GetMultiButton("guitar_right")
		local spd = guitarstate==1 and 1 or 0.5
		
		self._WiperMoveState = guitarstate!=0 and (self._WiperMoveState and self._WiperState<1 or !self._WiperMoveState and self._WiperState==0) or false
		
		if self._WiperMoveState then
			if self._WiperState<1 then
				self._WiperState = math.min(1,self._WiperState+spd*self.DeltaTime)
			end
		else
			if self._WiperState>0 then
				self._WiperState = math.max(0,self._WiperState-spd*self.DeltaTime)
			end
		end
		
		wipers:SetPoseParameter("state",self._WiperState)
	end
	
	return true
end