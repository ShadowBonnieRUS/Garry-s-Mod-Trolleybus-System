-- Copyright © Platunov I. M., 2020 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/trolza5265.png"

surface.CreateFont("Trolleybus_System.Trolleybus.TrolZa5265.Chergos",{
	font = "Arial",
	size = 32,
	extended = true,
	weight = 800,
})

surface.CreateFont("Trolleybus_System.Trolleybus.TrolZa5265.RouteDisplay.Number",{
	font = "Minecart LCD",
	size = 135,
	extended = true,
	weight = 600,
})

surface.CreateFont("Trolleybus_System.Trolleybus.TrolZa5265.RouteDisplay.Name",{
	font = "Minecart LCD",
	size = 75,
	extended = true,
	weight = 600,
})

ENT.PassPositionBounds = {
	{Vector(-201,6,-43),Vector(-25,-13,-43)},
	{Vector(-25,-13,-43),Vector(22,45,-43)},
	{Vector(22,9,-43),Vector(165,-14,-43)},
}
ENT.PassPositionSeats = {
	{Vector(-176,34,-18),Angle(0,0,0)},
	{Vector(-176,20,-18),Angle(0,0,0)},
	{Vector(-138,34,-18),Angle(0,180,0)},
	{Vector(-138,20,-18),Angle(0,180,0)},
	
	{Vector(-83,34,-28),Angle(0,0,0)},
	{Vector(-83,20,-28),Angle(0,0,0)},
	{Vector(-52,34,-28),Angle(0,0,0)},
	{Vector(-52,20,-28),Angle(0,0,0)},
	
	{Vector(43,34,-28),Angle(0,0,0)},
	{Vector(43,20,-28),Angle(0,0,0)},
	{Vector(82,34,-28),Angle(0,180,0)},
	{Vector(82,20,-28),Angle(0,180,0)},
	
	{Vector(-128,-34,-18),Angle(0,180,0)},
	{Vector(-128,-20,-18),Angle(0,180,0)},
	
	{Vector(-83,-34,-28),Angle(0,0,0)},
	{Vector(-83,-20,-28),Angle(0,0,0)},
	{Vector(-52,-34,-28),Angle(0,0,0)},
	{Vector(-52,-20,-28),Angle(0,0,0)},
	
	{Vector(43,-34,-28),Angle(0,0,0)},
	{Vector(82,-34,-28),Angle(0,180,0)},
}

ENT.TrolleyPoleModel = "models/trolleybus/trolza5265/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/trolza5265/pole_wheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,0)
ENT.TrolleyPoleDrawRotate = Angle(-16.9,180.1,0)
ENT.TrolleyPoleCatcherWirePos = Vector(218,0,-2.5)
ENT.TrolleyPoleAnimation = {
	bone_static = "Static",
	bone_base_pole = {"Base",1,Angle(0,-0.4,0)},
	bone_pole = "Pole",
	bone_pole_spring = {"Pole",0.85},
	bone_pole_spring1 = "Pole",
	["bone_base-pole_piston"] = {"Base+Pole",0.82},
}

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-217.34,0,52.7),
	CenterDist = 21.66,
	BoundMin = Vector(-1.6,-10),
	BoundMax = Vector(1.6,10),
}

ENT.SteerData1 = {
	model = "models/trolleybus/trolza5265/steer_kamaz.mdl",
	pos = Vector(193.66,24.86,-6.51),
	ang = Angle(-24.5,0,0),
	rollmult = 450,
}
ENT.SteerData = ENT.SteerData1

ENT.SteerData2 = {
	model = "models/trolleybus/trolza5265/steer_trolza.mdl",
	pos = Vector(193.66,24.86,-6.51),
	ang = Angle(-24.5,0,0),
	rollmult = 450,
}

ENT.CabineLightData = {
	pos = Vector(183,27,44),
	ang = Angle(90,0,0),
	brightness = 0.3,
	color = Color(255,255,255),
	farz = 100,
	nearz = 1,
	fov = 179,
	texture = "effects/flashlight001",
	
	dlight_pos = Vector(182,22,30),
	dlight_size = 250,
	dlight_brightness = 2,
}

ENT.CameraView = {
	DriverCameraPos = Vector(172,26,11),
	Pos = Vector(0,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(174,57,19),Angle(0,180,0)},
	MirrorRight = {Vector(184,-57,24),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-5,-10,-15),Vector(30,10,25)},
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(-221.59,42.82,-10.73),size = 35},
	{pos = Vector(205.58,47.65,-23.89),size = 35},
	{pos = Vector(213.61,42.91,-18.77),size = 30},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(-221.59,-42.82,-10.73),size = 35},
	{pos = Vector(205.58,-47.65,-23.89),size = 35},
	{pos = Vector(213.61,-42.91,-18.77),size = 30},
}

ENT.TurnSignalSoundOn = "trolleybus/trolza5265/blinkers_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/trolza5265/blinkers_off.ogg"

ENT.HeadLights = {
	brightness = 1,

	{pos = Vector(213.96,-41.44,-25.68),ang = Angle(),color = color_white,size = 35,brightness = 0.3,farz = 1000,nearz = 5,fov = 60,texture = "effects/flashlight001",shouldbeactive = function(self) return self:GetNWVar("HeadLights") end},
	{pos = Vector(213.96,41.51,-25.68),ang = Angle(),color = color_white,size = 35,brightness = 0.3,farz = 1000,nearz = 5,fov = 60,texture = "effects/flashlight001",shouldbeactive = function(self) return self:GetNWVar("HeadLights") end},
	{pos = Vector(213.96,39.94,-30.93),ang = Angle(),color = color_white,size = 35,brightness = 0.5,farz = 1500,nearz = 5,fov = 60,texture = "effects/flashlight001",shouldbeactive = function(self) return self:GetNWVar("FogHeadLights") end},
	{pos = Vector(213.96,-39.96,-30.93),ang = Angle(),color = color_white,size = 35,brightness = 0.5,farz = 1500,nearz = 5,fov = 60,texture = "effects/flashlight001",shouldbeactive = function(self) return self:GetNWVar("FogHeadLights") end},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(205.86,40.32,42.48),size = 30,color = color_white},
	{pos = Vector(205.86,-40.26,42.48),size = 30,color = color_white},
	{pos = Vector(213.96,-39.7,-21),size = 30,color = color_white},
	{pos = Vector(213.96,39.68,-21),size = 30,color = color_white},
	{pos = Vector(-218.84,-42.21,43.33),size = 30,color = color_white},
	{pos = Vector(-218.84,42.28,43.33),size = 30,color = color_white},
	{pos = Vector(131.72,47.03,-23.66),size = 30,color = Color(255,155,0)},
	{pos = Vector(41.12,47.03,-23.66),size = 30,color = Color(255,155,0)},
	{pos = Vector(-41.68,47.03,-23.66),size = 30,color = Color(255,155,0)},
	{pos = Vector(-137.7,47.03,-23.66),size = 30,color = Color(255,155,0)},
	{pos = Vector(-209.89,47.03,-22.81),size = 30,color = Color(255,155,0)},
	{pos = Vector(-210.05,-47.04,-23.59),size = 30,color = Color(255,155,0)},
	{pos = Vector(-137.67,-47.04,-23.59),size = 30,color = Color(255,155,0)},
	{pos = Vector(-41.72,-47.04,-23.59),size = 30,color = Color(255,155,0)},
	{pos = Vector(40.96,-47.04,-23.59),size = 30,color = Color(255,155,0)},
	{pos = Vector(131.65,-47.04,-23.59),size = 30,color = Color(255,155,0)},
	{pos = Vector(-221.53,40.73,-26.93),size = 35,color = Color(255,0,0)},
	{pos = Vector(-221.53,-40.89,-26.93),size = 35,color = Color(255,0,0)},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-221.62,-42.06,-15.99),size = 40},
	{pos = Vector(-221.62,41.88,-15.99),size = 40},
}
ENT.BackwardMoveLights = {
	brightness = 1,

	{pos = Vector(-221.62,41.45,-21.59),size = 40},
	{pos = Vector(-221.62,-41.56,-21.59),size = 40},
}

local function CreateModel(self,index,model,pos,ang)
	local ent = self:CreateCustomClientEnt(index,model)
	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)
	
	return ent
end

local interior = "models/trolleybus/trolza5265/interior.mdl"
local lights = "models/trolleybus/trolza5265/body_lights.mdl"
local seats = {
	"models/trolleybus/trolza5265/seats_type_1.mdl",
	"models/trolleybus/trolza5265/seats_type_2.mdl",
	"models/trolleybus/trolza5265/seats_type_3.mdl",
}
local plafons = {
	"models/trolleybus/trolza5265/plafons_left.mdl",
	"models/trolleybus/trolza5265/plafons_right.mdl",
	"models/trolleybus/trolza5265/plafon_cabine.mdl",
}
local doorlight = "models/trolleybus/trolza5265/door_light.mdl"
local doorlights = {
	{Vector(175.38,-42.35,37.37),Angle(0,0,-180)},
	{Vector(156.78,-42.35,37.37),Angle(0,0,-180)},
	{Vector(9.38,-42.35,37.37),Angle(0,0,-180)},
	{Vector(-9.17,-42.35,37.37),Angle(0,0,-180)},
	{Vector(-164.47,-42.35,37.37),Angle(0,0,-180)},
	{Vector(-183.03,-42.35,37.37),Angle(0,0,-180)},
}
local wipers = "models/trolleybus/trolza5265/wipers.mdl"

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	CreateModel(self,"interior",interior)
	CreateModel(self,"lights",lights)
	CreateModel(self,"seats",seats[self:GetSpawnSetting("seats") or 1])

	CreateModel(self,"intlightl",plafons[1],Vector(-22.79,24.33,47.31),Angle(0,0,-10))
	CreateModel(self,"intlightr",plafons[2],Vector(-21.53,-24.05,47.36),Angle(0,0,0))
	CreateModel(self,"cablight",plafons[3],Vector(180.74,29.95,46.94),Angle(0,-180,3))

	for k,v in ipairs(doorlights) do
		CreateModel(self,"doorlight"..k,doorlight,v[1],v[2])
	end

	CreateModel(self,"wipers",wipers,Vector(213.41,1.5,-18.63),Angle())
end

function ENT:Think()
	BaseClass.Think(self)

	if !self:IsDormant() then
		local intlightl = self:GetCustomClientEnt("intlightl")
		if IsValid(intlightl) then
			intlightl:SetSkin(self:GetNWVar("IntLightL") and 1 or 0)
		end

		local intlightr = self:GetCustomClientEnt("intlightr")
		if IsValid(intlightr) then
			intlightr:SetSkin(self:GetNWVar("IntLightR") and 1 or 0)
		end

		local cablight = self:GetCustomClientEnt("cablight")
		if IsValid(cablight) then
			cablight:SetSkin(self:GetCabineLight()>0 and 1 or 0)
		end

		for k,v in ipairs(doorlights) do
			local light = self:GetCustomClientEnt("doorlight"..k)
			if !IsValid(light) then continue end

			light:SetSkin(self:GetNWVar("DoorLight"..k) and 1 or 0)
		end

		local wipers = self:GetCustomClientEnt("wipers")
		if IsValid(wipers) then
			self._WiperState = self._WiperState or 0
			self._WiperMoveState = self._WiperMoveState or false
			
			local guitarstate = self:GetMultiButton("guitar_right")
			local dspd = self:GetNWVar("LowPower") and (guitarstate==-1 and 1 or 0.5) or 0
			local spd = self._WiperSpd or dspd

			if self._WiperSpd!=dspd then
				spd = spd>dspd and math.max(dspd,spd-self.DeltaTime*2) or math.min(dspd,spd+self.DeltaTime*2)
				self._WiperSpd = spd
			end
			
			self._WiperMoveState = guitarstate!=0 and (self._WiperMoveState and self._WiperState<1 or !self._WiperMoveState and self._WiperState==0 and (guitarstate!=1 or !self._WiperTime or RealTime()-self._WiperTime>10)) or false
			
			if spd>0 and self._WiperState==(self._WiperMoveState and 0 or 1) then
				Trolleybus_System.PlayBassSound(wipers,"trolleybus/trolza5265/wipers.ogg",200,0.75)
			end

			if self._WiperMoveState then
				if self._WiperState<1 then
					if self._WiperState==0 then self._WiperTime = RealTime() end

					self._WiperState = math.min(1,self._WiperState+spd*self.DeltaTime)
				end
			else
				if self._WiperState>0 then
					self._WiperState = math.max(0,self._WiperState-spd*self.DeltaTime)
				end
			end
			
			wipers:SetCycle(self._WiperState)
		end

		self.ObduvSound = self.ObduvSound or Trolleybus_System.CreateWorkSound(self,Vector(-103,-20,61),750,1,1,"trolleybus/trolza5265/obduv_on.ogg","trolleybus/trolza5265/obduv.ogg","trolleybus/trolza5265/obduv_off.ogg")
		self.ObduvSound:SetActive(self:GetNWVar("ObduvPower",false))

		if self.SystemsLoaded then
			local pbrake = math.max(self:GetSystem("Pneumatic"):GetBrake(1),self:GetSystem("Pneumatic"):GetBrake(2))
			self.LastPBrake = self.LastPBrake or pbrake

			if self.LastPBrake!=pbrake then
				self.LastPBrake = pbrake

				if pbrake==0 then
					Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/trolza5265/otpusk_pnevmotormoz.ogg",500,1,nil,Vector(173,25,-43))
				end
			end
		end
	end

	return true
end

function ENT:OnRemove()
	BaseClass.OnRemove(self)

	if self.ObduvSound then self.ObduvSound:Remove() end
end