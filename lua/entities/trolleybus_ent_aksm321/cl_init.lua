-- Copyright © Platunov I. M., 2020 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/aksm321.png"

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.RearNumber",{
	font = "Minecart LCD",
	size = 45,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Number",{
	font = "Minecart LCD",
	size = 95,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Name",{
	font = "Minecart LCD",
	size = 40,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM321.RouteDisplay.Integral",{
	font = "Minecart LCD",
	size = 38,
	extended = true,
})

ENT.PassPositionBounds = {
	{Vector(-200,9,-47),Vector(-220,-45,-44)},
	{Vector(-142,-45,-47),Vector(-196,9,-47)},
	{Vector(-140,13,-47),Vector(-30,-13,-47)},
	{Vector(-29,-44,-47),Vector(28,46,-47)},
	{Vector(49,46,-47),Vector(29,-16,-47)},
	{Vector(49,-13,-47),Vector(166,16,-47)},
	{Vector(166,-17,-47),Vector(191,-45,-47)},
}

ENT.PassPositionSeats = {
	{Vector(-222,21,-16),Angle(0,0,0)},
	{Vector(-222,38,-16),Angle(0,0,0)},
	
	{Vector(-181,37,-17),Angle(0,180,0)},
	{Vector(-181,19,-17),Angle(0,180,0)},
	{Vector(-158,19,-17),Angle(0,0,0)},
	{Vector(-158,37,-17),Angle(0,0,0)},
	
	{Vector(-114,38,-14),Angle(0,180,0)},
	{Vector(-114,21,-14),Angle(0,180,0)},
	{Vector(-89,22,-14),Angle(0,0,0)},
	{Vector(-89,38,-14),Angle(0,0,0)},
	
	{Vector(-114,-22,-14),Angle(0,180,0)},
	{Vector(-114,-38,-14),Angle(0,180,0)},
	{Vector(-89,-38,-14),Angle(0,0,0)},
	{Vector(-89,-22,-14),Angle(0,0,0)},
	
	{Vector(-54,-22,-18),Angle(0,0,0)},
	{Vector(-54,-38,-18),Angle(0,0,0)},
	
	{Vector(-54,38,-18),Angle(0,0,0)},
	
	{Vector(40,-34,-28),Angle(0,0,0)},
	
	{Vector(67,-38,-28),Angle(0,0,0)},
	{Vector(67,-22,-28),Angle(0,0,0)},
	
	{Vector(63,22,-28),Angle(0,0,0)},
	{Vector(63,38,-28),Angle(0,0,0)},
	
	{Vector(106,38,-28),Angle(0,180,0)},
	{Vector(106,22,-28),Angle(0,180,0)},
	
	{Vector(107,-22,-28),Angle(0,180,0)},
	{Vector(107,-38,-28),Angle(0,180,0)},
}

ENT.SteerData = {
	model = "models/trolleybus/aksm321/steer.mdl",
	pos = Vector(209.22,30.55,-11.3),
	ang = Angle(-17,0,0),
	rollmult = 450,
}

ENT.CabineLightData = {
	pos = Vector(200,0,51),
	ang = Angle(90,0,0),
	brightness = 0.3,
	color = Color(255,255,255),
	farz = 100,
	nearz = 1,
	fov = 179,
	texture = "effects/flashlight001",
	
	dlight_pos = Vector(200,0,24),
	dlight_size = 200,
	dlight_brightness = 4,
}

ENT.CameraView = {
	DriverCameraPos = Vector(190,30,8),
	Pos = Vector(0,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(211,58,19),Angle(0,180,0)},
	MirrorRight = {Vector(230,-63,17),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-20,-16,-40),Vector(30,18,30)},
}

ENT.TrolleyPoleModel = "models/trolleybus/aksm321/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/aksm321/polewheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,0.3)
ENT.TrolleyPoleDrawRotate = Angle(-20.05,180,0)
ENT.TrolleyPoleCatcherWirePos = Vector(250,0,-4.25)

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-233,0,62),
	CenterDist = 27,
	BoundMin = Vector(-6,-19),
	BoundMax = Vector(-1,19),
}

ENT.TurnSignalLeft1 = {
	brightness = 1,

	{pos = Vector(231.96,48.99,-40.78),size = 40},
	{pos = Vector(228.6,51.53,-20.17),size = 45},
	{pos = Vector(-239.28,43.68,-15.96),size = 50},
}
ENT.TurnSignalLeft = ENT.TurnSignalLeft1

ENT.TurnSignalLeft2 = {
	brightness = 1,

	{pos = Vector(233.87,39.17,-38),size = 40},
	{pos = Vector(228.6,51.53,-20.17),size = 45},
	{pos = Vector(-239.28,43.68,-15.96),size = 50},
}

ENT.TurnSignalRight1 = {
	brightness = 1,
	
	{pos = Vector(232.34,-48.97,-40.9),size = 40},
	{pos = Vector(228.58,-51.51,-20.25),size = 45},
	{pos = Vector(-239.38,-43.72,-15.8),size = 50},
}
ENT.TurnSignalRight = ENT.TurnSignalRight1

ENT.TurnSignalRight2 = {
	brightness = 1,
	
	{pos = Vector(233.89,-39.13,-37.88),size = 40},
	{pos = Vector(228.58,-51.51,-20.25),size = 45},
	{pos = Vector(-239.38,-43.72,-15.8),size = 50},
}

ENT.TurnSignalSoundOn = "trolleybus/turnsound_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/turnsound_off.ogg"

ENT.HeadLights1 = {
	brightness = 1,

	{pos = Vector(235.34,42.67,-39.18),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
	{pos = Vector(235.34,-42.67,-39.18),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
}
ENT.HeadLights = ENT.HeadLights1

ENT.HeadLights2 = {
	brightness = 1,

	{pos = Vector(234.13,-32.04,-38.13),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
	{pos = Vector(234.08,32.22,-37.97),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
}

ENT.ProfileLights1 = {
	brightness = 1,

	{pos = Vector(232.23,-48.98,-38.1),size = 40,color = Color(255,255,255)},
	{pos = Vector(232.21,48.77,-38.22),size = 40,color = Color(255,255,255)},
	{pos = Vector(229.94,-40.14,40.94),size = 40,color = Color(255,255,255)},
	{pos = Vector(229.94,40.14,40.94),size = 40,color = Color(255,255,255)},
	
	{pos = Vector(164.24,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(53.6,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(-47.02,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(-131.62,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(-233.06,-51.47,-38.61),size = 40,color = Color(255,155,0)},
	
	{pos = Vector(189.27,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(61.3,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(-42.2,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(-168.35,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(-233.12,51.5,-38.59),size = 40,color = Color(255,155,0)},
	
	{pos = Vector(-235.31,37.85,51.01),size = 40,color = Color(255,0,0)},
	{pos = Vector(-235.31,-37.92,51.01),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,43.76,-12.06),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,43.76,-29.03),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,-43.75,-29.03),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,-43.75,-12.06),size = 40,color = Color(255,0,0)},
}
ENT.ProfileLights = ENT.ProfileLights1

ENT.ProfileLights2 = {
	brightness = 1,
	
	{pos = Vector(229.94,-40.14,40.94),size = 40,color = Color(255,255,255)},
	{pos = Vector(229.94,40.14,40.94),size = 40,color = Color(255,255,255)},
	
	{pos = Vector(164.24,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(53.6,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(-47.02,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(-131.62,-51.12,-38.61),size = 40,color = Color(255,155,0)},
	{pos = Vector(-233.06,-51.47,-38.61),size = 40,color = Color(255,155,0)},
	
	{pos = Vector(189.27,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(61.3,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(-42.2,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(-168.35,51.04,-38.59),size = 40,color = Color(255,155,0)},
	{pos = Vector(-233.12,51.5,-38.59),size = 40,color = Color(255,155,0)},
	
	{pos = Vector(-235.31,37.85,51.01),size = 40,color = Color(255,0,0)},
	{pos = Vector(-235.31,-37.92,51.01),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,43.76,-12.06),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,43.76,-29.03),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,-43.75,-29.03),size = 40,color = Color(255,0,0)},
	{pos = Vector(-239.34,-43.75,-12.06),size = 40,color = Color(255,0,0)},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-239.34,-43.75,-21.27),size = 50},
	{pos = Vector(-239.34,43.76,-21.27),size = 50},
}
ENT.BackwardMoveLights = {
	brightness = 1,

	{pos = Vector(-239.34,-43.75,-26.06),size = 45},
	{pos = Vector(-239.34,43.76,-26.06),size = 45},
}

local interior1 = "models/trolleybus/aksm321/interior.mdl"
local interior2 = "models/trolleybus/aksm321/interior2.mdl"
local parts1 = "models/trolleybus/aksm321/parts1.mdl"
local parts2 = "models/trolleybus/aksm321/parts2.mdl"
local lamp = "models/trolleybus/aksm321/lamp.mdl"
local wipers = "models/trolleybus/aksm321/wipers.mdl"
local doorlight1 = "models/trolleybus/aksm321/doorlight1.mdl"
local doorlight2 = "models/trolleybus/aksm321/doorlight2.mdl"
local doorlight3 = "models/trolleybus/aksm321/doorlight3.mdl"

local handrails = {
	"models/trolleybus/aksm321/parts6.mdl",
	"models/trolleybus/aksm321/parts7.mdl",
}

local seats = {
	"models/trolleybus/aksm321/parts3.mdl",
	"models/trolleybus/aksm321/parts4.mdl",
	"models/trolleybus/aksm321/parts5.mdl",
	"models/trolleybus/aksm321/parts8.mdl",
}

local lamps = {
	{Vector(117.51,25.73,45.24),Angle(171.4,-90,0)},
    {Vector(48,0,46.76),Angle(-180,-90,0)},
    {Vector(-8,0,46.76),Angle(-180,-90,0)},
    {Vector(-58,0,46.76),Angle(-180,-90,0)},
	{Vector(-115,0,46.76),Angle(-180,-90,0)},
    {Vector(-175,0,46.76),Angle(-180,-90,0)},
    
    {Vector(211.65,23,45.28),Angle(180,-180,0),true},
}

local function CreateModel(self,index,model,pos,ang)
	local ent = self:CreateCustomClientEnt(index,model)
	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)
	
	return ent
end

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	CreateModel(self,"interior1",interior1)
	CreateModel(self,"interior2",interior2)
	
	local parts1 = CreateModel(self,"parts1",parts1)
	parts1:SetBodygroup(0,self:GetSpawnSetting("arcs")-1)
	parts1:SetBodygroup(1,self:GetSpawnSetting("cells")-1)
	parts1:SetBodygroup(2,self:GetSpawnSetting("bodydop") and 0 or 1)
	parts1:SetBodygroup(3,self:GetSpawnSetting("catchers")-1)
	parts1:SetBodygroup(4,self:GetSpawnSetting("ee_casing")-1)
	
	local parts2 = CreateModel(self,"parts2",parts2)
	parts2:SetBodygroup(0,self:GetSpawnSetting("head")-1)
	parts2:SetBodygroup(1,self:GetSpawnSetting("intmolding")-1)
	parts2:SetBodygroup(2,self:GetSpawnSetting("ramp") and 0 or 1)
	parts2:SetBodygroup(3,self:GetSpawnSetting("rubbers") and 0 or 1)
	parts2:SetBodygroup(4,self:GetSpawnSetting("wheelchairback") and 0 or 1)
	parts2:SetBodygroup(5,self:GetSpawnSetting("windows")-1)
	
	for k,v in ipairs(lamps) do
		local lamp = CreateModel(self,"lamp"..k,lamp,v[1],v[2])
		lamp:SetBodygroup(0,self:GetSpawnSetting("lamps")-1)
		lamp.Cabine = v[3]
	end
	
	CreateModel(self,"wipers",wipers,Vector(234.88,0.09,-19.18))
	CreateModel(self,"seats",seats[self:GetSpawnSetting("seats")])
	CreateModel(self,"handrails",handrails[self:GetSpawnSetting("handrails")])
	
	CreateModel(self,"doorlight1",doorlight1)
	CreateModel(self,"doorlight2",doorlight2)
	CreateModel(self,"doorlight3",doorlight3)
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