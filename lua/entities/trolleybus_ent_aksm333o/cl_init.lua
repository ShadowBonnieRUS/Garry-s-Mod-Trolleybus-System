-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/aksm333o.png"

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.RearNumber",{
	font = "Minecart LCD",
	size = 52,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.RouteNumber",{
	font = "Minecart LCD",
	size = 108,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.Route",{
	font = "Minecart LCD",
	size = 42,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333o.RouteDisplay.Integral",{
	font = "Minecart LCD",
	size = 38,
	extended = true,
})

ENT.PassPositionBounds = {
	{Vector(-27,-13,-49),Vector(54,13,-49)},
	{Vector(54,-26,-49),Vector(113,8,-49)},
	{Vector(113,8,-49),Vector(165,-45,-49)},
	{Vector(165,-12,-49),Vector(279,12,-49)},
	{Vector(277,-18,-49),Vector(300,-44,-49)},
}
ENT.PassPositionSeats = {
	{Vector(-4,38,-18),Angle(0,180,0)},
	{Vector(-4,22,-18),Angle(0,180,0)},
	{Vector(22,22,-18),Angle(0,0,0)},
	{Vector(22,38,-18),Angle(0,0,0)},
	
	{Vector(-4,-38,-18),Angle(0,180,0)},
	{Vector(-4,-22,-18),Angle(0,180,0)},
	{Vector(23,-22,-18),Angle(0,0,0)},
	{Vector(23,-38,-18),Angle(0,0,0)},
	
	{Vector(56,-38,-18),Angle(0,0,0)},
	{Vector(84.5,-38,-18),Angle(0,0,0)},
	
	{Vector(65,36,-18),Angle(0,180,0)},
	{Vector(65,19,-18),Angle(0,180,0)},
	{Vector(89,36,-18),Angle(0,0,0)},
	{Vector(89,19,-18),Angle(0,0,0)},
	
	{Vector(123,38,-30),Angle(0,0,0)},
	{Vector(123,22,-30),Angle(0,0,0)},
	{Vector(153,38,-32),Angle(0,0,0)},
	{Vector(153,22,-32),Angle(0,0,0)},
	
	{Vector(180,-38,-32),Angle(0,0,0)},
	{Vector(180,-22,-32),Angle(0,0,0)},
	{Vector(218,-22,-32),Angle(0,180,0)},
	{Vector(218,-38,-32),Angle(0,180,0)},
	
	{Vector(217,38,-32),Angle(0,180,0)},
	{Vector(217,22,-32),Angle(0,180,0)},
	{Vector(180,22,-32),Angle(0,0,0)},
	{Vector(180,38,-32),Angle(0,0,0)},
}

ENT.SteerData = {
	model = "models/trolleybus/aksm333o/steer.mdl",
	pos = Vector(319.49,30.49,-13.19),
	ang = Angle(-20,0,0),
	rollmult = 450,
}

ENT.CabineLightData = {
	pos = Vector(317.94,1.99,42),
	ang = Angle(90,0,0),
	brightness = 0.3,
	color = Color(255,255,255),
	farz = 100,
	nearz = 1,
	fov = 179,
	texture = "effects/flashlight001",
	
	dlight_pos = Vector(317.94,1.99,22),
	dlight_size = 200,
	dlight_brightness = 3,
}

ENT.CameraView = {
	DriverCameraPos = Vector(300,30.5,7),
	Pos = Vector(0,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(316,56,17),Angle(0,180,0)},
	MirrorRight = {Vector(326,-65,16),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-17,-17,-40),Vector(28,17,30)},
}

ENT.TurnSignalLeft1 = {
	brightness = 1,
	
	{pos = Vector(344.12,39.13,-40.08),size = 45},
	{pos = Vector(338.92,51.53,-22.13),size = 40},
}
ENT.TurnSignalLeft = ENT.TurnSignalLeft1

ENT.TurnSignalLeft2 = {
	brightness = 1,
	
	{pos = Vector(342.31,48.63,-42.73),size = 35},
	{pos = Vector(338.92,51.53,-22.13),size = 40},
}

ENT.TurnSignalRight1 = {
	brightness = 1,
	
	{pos = Vector(344.08,-39.27,-39.88),size = 45},
	{pos = Vector(338.95,-51.5,-22.06),size = 40},
}
ENT.TurnSignalRight = ENT.TurnSignalRight1

ENT.TurnSignalRight2 = {
	brightness = 1,
	
	{pos = Vector(342.31,-48.79,-42.73),size = 35},
	{pos = Vector(338.95,-51.5,-22.06),size = 40},
}

ENT.TurnSignalSoundOn = "trolleybus/turnsound_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/turnsound_off.ogg"

ENT.HeadLights1 = {
	brightness = 1,

	{pos = Vector(344.5,-32.09,-40),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
	{pos = Vector(344.29,32.01,-40),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
}
ENT.HeadLights = ENT.HeadLights1

ENT.HeadLights2 = {
	brightness = 1,

	{pos = Vector(345.34,-43.38,-40.53),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
	{pos = Vector(345.34,43.4,-40.53),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
}

ENT.ProfileLights1 = {
	brightness = 1,

	{pos = Vector(340.03,40.16,39.08),size = 40,color = Color(255,255,255)},
	{pos = Vector(340.04,-40.21,39.12),size = 40,color = Color(255,255,255)},
	{pos = Vector(329.52,-6.09,52.82),size = 40,color = Color(255,155,0)},
	{pos = Vector(329.52,0.06,52.82),size = 40,color = Color(255,155,0)},
	{pos = Vector(329.52,6.1,52.82),size = 40,color = Color(255,155,0)},
	{pos = Vector(273.87,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(177.65,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(98.8,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(-21.5,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(276.53,51.06,-42.55),size = 40,color = Color(255,155,0)},
	{pos = Vector(218.04,51.06,-42.55),size = 40,color = Color(255,155,0)},
	{pos = Vector(98.8,51.06,-42.55),size = 40,color = Color(255,155,0)},
	{pos = Vector(-21.43,51.06,-42.55),size = 40,color = Color(255,155,0)},
}
ENT.ProfileLights = ENT.ProfileLights1

ENT.ProfileLights2 = {
	brightness = 1,

	{pos = Vector(340.03,40.16,39.08),size = 40,color = Color(255,255,255)},
	{pos = Vector(340.04,-40.21,39.12),size = 40,color = Color(255,255,255)},
	{pos = Vector(329.52,-6.09,52.82),size = 40,color = Color(255,155,0)},
	{pos = Vector(329.52,0.06,52.82),size = 40,color = Color(255,155,0)},
	{pos = Vector(329.52,6.1,52.82),size = 40,color = Color(255,155,0)},
	{pos = Vector(273.87,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(177.65,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(98.8,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(-21.5,-51.07,-42.34),size = 40,color = Color(255,155,0)},
	{pos = Vector(276.53,51.06,-42.55),size = 40,color = Color(255,155,0)},
	{pos = Vector(218.04,51.06,-42.55),size = 40,color = Color(255,155,0)},
	{pos = Vector(98.8,51.06,-42.55),size = 40,color = Color(255,155,0)},
	{pos = Vector(-21.43,51.06,-42.55),size = 40,color = Color(255,155,0)},
	{pos = Vector(342.31,48.79,-40.14),size = 35,color = Color(255,255,255)},
	{pos = Vector(342.31,-48.79,-40.14),size = 35,color = Color(255,255,255)},
}

ENT.BrakeLights = {}
ENT.BackwardMoveLights = {}

local seats = {
	"models/trolleybus/aksm333o/seats1.mdl",
	"models/trolleybus/aksm333o/seats2.mdl",
	"models/trolleybus/aksm333o/seats3.mdl",
}

local handrails = "models/trolleybus/aksm333o/handrails.mdl"
local interior = "models/trolleybus/aksm333o/interior.mdl"
local interior2 = "models/trolleybus/aksm333o/interior2.mdl"
local lamp = "models/trolleybus/aksm333o/lamp.mdl"
local wipers = "models/trolleybus/aksm333o/wipers.mdl"
local doorlight1 = "models/trolleybus/aksm333o/doorlight1.mdl"
local doorlight2 = "models/trolleybus/aksm333o/doorlight2.mdl"

local lamps = {
    {Vector(232,23,45.48),Angle(-180,90,0)},
	{Vector(127,23,45.48),Angle(-180,90,0)},
	{Vector(13,23,45.48),Angle(-180,90,0)},
	{Vector(189,-24,45.48),Angle(-180,90,0)},
	{Vector(67,-24,45.48),Angle(-180,90,0)},
    
    {Vector(320.33,21.53,43.33),Angle(-180,0,0),true},
}

local function CreateModel(self,index,model,pos,ang)
	local ent = self:CreateCustomClientEnt(index,model)
	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)
	
	return ent
end

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	CreateModel(self,"seats",seats[self:GetSpawnSetting("seats")])
	CreateModel(self,"handrails",handrails)
	CreateModel(self,"interior",interior)
	CreateModel(self,"interior2",interior2)
	CreateModel(self,"doorlight1",doorlight1)
	CreateModel(self,"doorlight2",doorlight2)
	
	for k,v in ipairs(lamps) do
		local ent = CreateModel(self,"lamp"..k,lamp,v[1],v[2])
		ent.Cabine = v[3]
	end
	
	CreateModel(self,"wipers",wipers,Vector(345.08,0.06,-21.01),Angle(0,0,0))
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