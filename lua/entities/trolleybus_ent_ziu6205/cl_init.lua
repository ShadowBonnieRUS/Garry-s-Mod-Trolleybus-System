-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/ziu6205.png"

surface.CreateFont("Trolleybus_System.Trolleybus.ZiU6205.RouteDisplay.Nameplate",{
	font = "Aero Matics Stencil",
	size = 32,
	extended = true,
	weight = 600,
})

surface.CreateFont("Trolleybus_System.Trolleybus.ZiU6205.RouteDisplay.NameplateNumber",{
	font = "Aero Matics Stencil",
	size = 80,
	extended = true,
	weight = 550,
})

surface.CreateFont("Trolleybus_System.Trolleybus.ZiU6205.RouteDisplay.RearNumber",{
	font = "Aero Matics Stencil",
	size = 60,
	extended = true,
	weight = 600,
})

ENT.PassPositionBounds = {
	{Vector(-175,-12,-28),Vector(-75,13,-28)},
	{Vector(-75,-12,-28),Vector(79,23,-28)},
	{Vector(79,15,-28),Vector(132,-12,-28)},
}
ENT.PassPositionSeats = {
	{Vector(-141,35,-12),Angle(0,180,0)},
	{Vector(-141,18,-12),Angle(0,180,0)},
	{Vector(-141,-35,-12),Angle(0,180,0)},
	{Vector(-141,-18,-12),Angle(0,180,0)},
	
	{Vector(-122,35,-9),Angle(0,0,0)},
	{Vector(-122,18,-9),Angle(0,0,0)},
	{Vector(-122,-35,-9),Angle(0,0,0)},
	{Vector(-122,-18,-9),Angle(0,0,0)},
	
	{Vector(-98,35,-14),Angle(0,0,0)},
	{Vector(-98,18,-14),Angle(0,0,0)},
	{Vector(-98,-35,-14),Angle(0,0,0)},
	{Vector(-98,-18,-14),Angle(0,0,0)},
	
	{Vector(-70,35,-14),Angle(0,0,0)},
	{Vector(-70,-35,-14),Angle(0,0,0)},
	{Vector(-70,-18,-14),Angle(0,0,0)},
	
	{Vector(-43,35,-14),Angle(0,0,0)},
	{Vector(-16,35,-14),Angle(0,0,0)},
	{Vector(12,35,-14),Angle(0,0,0)},
	
	{Vector(39,35,-14),Angle(0,0,0)},
	{Vector(40,-35,-14),Angle(0,0,0)},
	{Vector(40,-18,-14),Angle(0,0,0)},
	
	{Vector(83,32,-14),Angle(0,180,0)},
	{Vector(85,-35,-14),Angle(0,180,0)},
	{Vector(85,-18,-14),Angle(0,180,0)},
	
	{Vector(106,30,-8),Angle(0,0,0)},
	{Vector(106,-35,-8),Angle(0,0,0)},
	{Vector(106,-18,-8),Angle(0,0,0)},
}

ENT.SteerData = {
	model = "models/trolleybus/ziu6205/steering_wheel.mdl",
	pos = Vector(164.6,28.29,5.23),
	ang = Angle(-15,0,0),
	rollmult = 450,
}

ENT.CabineLightData = {
	pos = Vector(164,19,49),
	ang = Angle(90,0,0),
	brightness = 0.3,
	color = Color(255,140,32),
	farz = 100,
	nearz = 1,
	fov = 179,
	texture = "effects/flashlight001",
	
	dlight_pos = Vector(164,16,15),
	dlight_size = 200,
	dlight_brightness = 3,
}

ENT.CameraView = {
	DriverCameraPos = Vector(150,28,25),
	Pos = Vector(-150,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(170,57,12),Angle(0,180,0)},
	MirrorRight = {Vector(170,-59,16),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-10,-20,-30),Vector(15,13,15)},
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(185.53,39.25,-21.17),size = 45},
	{pos = Vector(171.27,48.65,-9.56),size = 45},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(185.53,-39.25,-21.17),size = 45},
	{pos = Vector(171.27,-48.65,-9.56),size = 45},
}

ENT.TurnSignalSoundOn = "trolleybus/turnsound_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/turnsound_off.ogg"

ENT.HeadLights = {
	brightness = 1,

	{pos = Vector(184.96,29.48,-22.13),ang = Angle(),color = Color(255,230,150),size = 50,brightness = 0.5,farz = 1000,nearz = 5,fov = 60,texture = "effects/flashlight001"},
	{pos = Vector(184.96,-29.48,-22.13),ang = Angle(),color = Color(255,230,150),size = 50,brightness = 0.5,farz = 1000,nearz = 5,fov = 60,texture = "effects/flashlight001"},
}

ENT.ProfileLights = {
	brightness = 1,
	
	{pos = Vector(185.49,-39.29,-24.26),size = 40,color = Color(255,230,150),active = function(self) return self:ButtonIsDown("profilelightsbottom") end},
	{pos = Vector(185.49,39.29,-24.26),size = 40,color = Color(255,230,150),active = function(self) return self:ButtonIsDown("profilelightsbottom") end},
	{pos = Vector(186,32.41,38.41),size = 40,color = Color(255,230,150),active = function(self) return self:ButtonIsDown("profilelightstop") end},
	{pos = Vector(186,-32.41,38.41),size = 40,color = Color(255,230,150),active = function(self) return self:ButtonIsDown("profilelightstop") end},
}

ENT.RoadTrainLights = {
	brightness = 1,
	
	{pos = Vector(182.5,5.57,50.97),size = 40,color = Color(255,155,0)},
	{pos = Vector(182.5,0,50.97),size = 40,color = Color(255,155,0)},
	{pos = Vector(182.5,-5.57,50.97),size = 40,color = Color(255,155,0)},
}

ENT.BrakeLights = {}
ENT.BackwardMoveLights = {}

local model2 = "models/trolleybus/ziu6205/body_2.mdl"
local lamp = "models/trolleybus/ziu6205/interior_lamp.mdl"
local doorlight = "models/trolleybus/ziu6205/door_illumination.mdl"
local footlight = "models/trolleybus/ziu6205/footstep_illumination.mdl"
local wiperleft = "models/trolleybus/ziu6205/wiper_left.mdl"
local wiperright = "models/trolleybus/ziu6205/wiper_right.mdl"

local lamps = {
	{Vector(-125.16,32.28,45.81),Angle(0,0,-10.8),0},
	{Vector(-68.64,32.28,45.81),Angle(0,0,-10.8),1},
	{Vector(-13.34,32.28,45.81),Angle(0,0,-10.8),0},
	{Vector(48.3,32.28,45.81),Angle(0,0,-10.8),1},
	{Vector(106.36,32.28,45.81),Angle(0,0,-10.8),0},
	
	{Vector(106.52,-32.59,45.71),Angle(0,0,10),1},
	{Vector(48.26,-32.59,45.71),Angle(0,0,10),0},
	{Vector(-68.62,-32.59,45.71),Angle(0,0,10),0},
	{Vector(-125.19,-32.59,45.71),Angle(0,0,10),1},
	
	{Vector(154.66,32.28,45.81),Angle(0,0,-10.8),2},
}

local doorlights = {
	{Vector(139.6,-33.57,-41.01),Angle(0,0,0),"Door1Light",true},
	{Vector(-18.47,-39.48,34.52),Angle(0,0,-10),"Door2Light"},
	{Vector(-1.92,-33.57,-41.01),Angle(0,0,0),"Door2Light",true},
	{Vector(-17.96,-33.57,-41.01),Angle(0,0,0),"Door2Light",true},
}

local function CreateModel(self,index,model,pos,ang)
	local mdl = self:CreateCustomClientEnt(index,model)
	mdl:SetLocalPos(pos or vector_origin)
	mdl:SetLocalAngles(ang or angle_zero)
	
	return mdl
end

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	CreateModel(self,"Model2",model2)
	
	for k,v in ipairs(lamps) do
		CreateModel(self,"Lamp"..k,lamp,v[1],v[2])
	end
	
	for k,v in ipairs(doorlights) do
		CreateModel(self,"Doorlight"..k,v[4] and footlight or doorlight,v[1],v[2])
	end
	
	CreateModel(self,"WiperLeft",wiperleft,Vector(186.28,24.16,-8.27),Angle(0,0,0))
	CreateModel(self,"WiperRight",wiperright,Vector(186.28,-24.16,-8.27),Angle(0,0,0))
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
		local doorlight = self:GetCustomClientEnt("Doorlight"..k)
		if !IsValid(doorlight) then continue end
		
		doorlight:SetSkin(self:GetNWVar(v[3]) and 1 or 0)
	end
	
	local wiperleft = self:GetCustomClientEnt("WiperLeft")
	if IsValid(wiperleft) then
		local spd = self:GetNWVar("WipersLeft") and 1 or 0
		
		self.WiperLeftSpd = self.WiperLeftSpd or spd
		self.WiperLeftSpd = self.WiperLeftSpd<spd and math.min(self.WiperLeftSpd+self.DeltaTime*3,spd) or math.max(self.WiperLeftSpd-self.DeltaTime*3,spd)
		
		self.WiperLeftMoveState = self.WiperLeftMoveState or 0
		self.WiperLeftState = self.WiperLeftState and self.WiperLeftMoveState<1 or !self.WiperLeftState and self.WiperLeftMoveState<=0
		self.WiperLeftMoveState = self.WiperLeftState and math.min(1,self.WiperLeftMoveState+self.DeltaTime*self.WiperLeftSpd) or math.max(0,self.WiperLeftMoveState-self.DeltaTime*self.WiperLeftSpd)
		
		wiperleft:SetCycle(self.WiperLeftMoveState)
	end
	
	local wiperright = self:GetCustomClientEnt("WiperRight")
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