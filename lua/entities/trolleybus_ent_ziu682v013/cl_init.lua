-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/ziu682v013.png"

surface.CreateFont("Trolleybus_System.Trolleybus.ZiU682V013.RouteDisplay.Nameplate",{
	font = "Aero Matics Stencil",
	size = 32,
	extended = true,
	weight = 600,
})

surface.CreateFont("Trolleybus_System.Trolleybus.ZiU682V013.RouteDisplay.NameplateNumber",{
	font = "Aero Matics Stencil",
	size = 80,
	extended = true,
	weight = 550,
})

surface.CreateFont("Trolleybus_System.Trolleybus.ZiU682V013.RouteDisplay.RearNumber",{
	font = "Aero Matics Stencil",
	size = 60,
	extended = true,
	weight = 600,
})

ENT.PassPositionBounds = {
	{Vector(-210,41,-26),Vector(-195,-41,-26)},
	{Vector(-191,41,-26),Vector(-136,-23,-26)},
	{Vector(-136,14,-26),Vector(165,-14,-26)},
}
ENT.PassPositionSeats = {
	{Vector(-107,35,-11),Angle(0,-180,0)},
	{Vector(-107,18,-11),Angle(0,-180,0)},
	
	{Vector(-89,35,-10),Angle(0,0,0)},
	{Vector(-89,18,-10),Angle(0,0,0)},
	
	{Vector(-65,35,-12),Angle(0,0,0)},
	{Vector(-65,18,-12),Angle(0,0,0)},
	
	{Vector(-38,35,-12),Angle(0,0,0)},
	{Vector(-38,18,-12),Angle(0,0,0)},
	
	{Vector(-11,35,-12),Angle(0,0,0)},
	{Vector(-11,18,-12),Angle(0,0,0)},
	
	{Vector(17,35,-12),Angle(0,0,0)},
	{Vector(17,18,-12),Angle(0,0,0)},
	
	{Vector(45,35,-12),Angle(0,0,0)},
	{Vector(45,18,-12),Angle(0,0,0)},
	
	{Vector(75,35,-12),Angle(0,0,0)},
	{Vector(75,18,-12),Angle(0,0,0)},
	
	{Vector(121,30,-9),Angle(0,-180,0)},
	{Vector(148,30,-8),Angle(0,-90,0)},
	
	{Vector(-107,-35,-11),Angle(0,-180,0)},
	{Vector(-107,-18,-11),Angle(0,-180,0)},
	
	{Vector(-89,-35,-10),Angle(0,0,0)},
	{Vector(-89,-18,-10),Angle(0,0,0)},
	
	{Vector(-65,-35,-12),Angle(0,0,0)},
	{Vector(-65,-18,-12),Angle(0,0,0)},
	
	{Vector(-38,-35,-12),Angle(0,0,0)},
	{Vector(-38,-18,-12),Angle(0,0,0)},
	
	{Vector(75,-35,-12),Angle(0,0,0)},
	
	{Vector(121,-35,-9),Angle(0,-180,0)},
	{Vector(121,-18,-9),Angle(0,-180,0)},
	
	{Vector(143,-35,-8),Angle(0,0,0)},
	{Vector(143,-18,-8),Angle(0,0,0)},
}

ENT.TrolleyPoleModel = "models/trolleybus/ziu682v/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/ziu682v/pole_wheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,-1.1)
ENT.TrolleyPoleWheelRotate = Angle(19,0,0)
ENT.TrolleyPoleDrawRotate = Angle(-2.98,180,0.8)
ENT.TrolleyPoleCatcherWirePos = Vector(235,0,-3)

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-222.23,0,42.82),
	CenterDist = 21.64,
	BoundMin = Vector(-1.5,-10),
	BoundMax = Vector(1.5,10),
}

ENT.SteerData = {
	model = "models/trolleybus/ziu682v/steering_wheel.mdl",
	pos = Vector(197.42,28.2,1.5),
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
	DriverCameraPos = Vector(182,28,18),
	Pos = Vector(0,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(200,55,20),Angle(0,180,0)},
	MirrorRight = {Vector(203,-55,20),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-9,-14,-40),Vector(30,14,20)},
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(219.2,39.26,-19.35),size = 35},
	{pos = Vector(204.89,48.56,-7.7),size = 35},
	{pos = Vector(-218.57,36.82,-13.99),size = 35},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(219.24,-39.28,-19.31),size = 35},
	{pos = Vector(204.92,-48.61,-7.72),size = 35},
	{pos = Vector(-218.57,-36.79,-13.97),size = 35},
}

ENT.TurnSignalSoundOn = "trolleybus/turnsound_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/turnsound_off.ogg"

ENT.HeadLights = {
	brightness = 1,

	{pos = Vector(218.82,29.47,-20.27),ang = Angle(),color = Color(255,230,150),size = 45,brightness = 0.5,farz = 500,nearz = 5,fov = 60,texture = "effects/flashlight001"},
	{pos = Vector(218.74,-29.33,-20.27),ang = Angle(),color = Color(255,230,150),size = 45,brightness = 0.5,farz = 500,nearz = 5,fov = 60,texture = "effects/flashlight001"},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(219.21,-39.21,-22.38),size = 30,color = Color(255,230,150)},
	{pos = Vector(219.21,39.31,-22.38),size = 30,color = Color(255,230,150)},
	{pos = Vector(219.74,32.43,40.06),size = 30,color = Color(255,230,150)},
	{pos = Vector(219.74,-32.49,40.06),size = 30,color = Color(255,230,150)},
	{pos = Vector(-218.15,-32.45,46.39),size = 30,color = Color(255,0,0)},
	{pos = Vector(-218.15,32.44,46.39),size = 30,color = Color(255,0,0)},
	{pos = Vector(-218.52,36.78,-16.86),size = 30,color = Color(255,0,0)},
	{pos = Vector(-218.52,-36.78,-16.86),size = 30,color = Color(255,0,0)},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-218.52,-36.78,-10.38),size = 35},
	{pos = Vector(-218.52,36.79,-10.38),size = 35},
}
ENT.BackwardMoveLights = {
	brightness = 1,
}

local model2 = "models/trolleybus/ziu682v/body_2.mdl"
local model3 = "models/trolleybus/ziu682v/bottom.mdl"
local model4 = "models/trolleybus/ziu682v/interior_1.mdl"
local model5 = "models/trolleybus/ziu682v/interior_2.mdl"
local model6 = "models/trolleybus/ziu682v/glass.mdl"
local lamp = "models/trolleybus/ziu682v/interior_lamp.mdl"
local doorlight = "models/trolleybus/ziu682v/door_illumination.mdl"
local footlight = "models/trolleybus/ziu682v/footstep_illumination.mdl"
local wiperleft = "models/trolleybus/ziu682v/wiper_left.mdl"
local wiperright = "models/trolleybus/ziu682v/wiper_right.mdl"

local lamps = {
	{Vector(140.11,32.21,47.63),Angle(0,0,-10.3),0},
	{Vector(82.06,32.21,47.63),Angle(0,0,-10.3),1},
	{Vector(20.51,32.21,47.63),Angle(0,0,-10.3),0},
	{Vector(-34.74,32.21,47.63),Angle(0,0,-10.3),1},
	{Vector(-91.32,32.21,47.63),Angle(0,0,-10.3),0},
	{Vector(-162.16,32.21,47.63),Angle(0,0,-10.3),1},
	
	{Vector(-161.68,-8.17,49.37),Angle(0,0,0.3),0},
	{Vector(-91.39,-32.53,47.57),Angle(0,0,10.3),1},
	{Vector(-34.92,-32.53,47.57),Angle(0,0,10.3),0},
	{Vector(82.01,-32.53,47.57),Angle(0,0,10.3),0},
	{Vector(140.13,-32.53,47.57),Angle(0,0,10.3),1},
	
	{Vector(189.59,32.21,47.63),Angle(0,0,-10.3),2},
}

local doorlights = {
	{Vector(173.45,-33.51,-39.51),Angle(0,0,0),"Door1Light",true},
	{Vector(15.26,-39.49,36.3),Angle(0,0,-10.4),"Door2Light"},
	{Vector(33.33,-33.51,-39.51),Angle(0,0,0),"Door2Light",true},
	{Vector(14.2,-33.51,-39.51),Angle(0,0,0),"Door2Light",true},
	{Vector(-170.03,-39.49,36.3),Angle(0,0,-10.4),"Door3Light"},
	{Vector(-152.4,-33.51,-39.51),Angle(0,0,0),"Door3Light",true},
	{Vector(-170.59,-33.51,-39.51),Angle(0,0,0),"Door3Light",true},
}

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	self:CreateCustomClientEnt("model2",model2)
	self:CreateCustomClientEnt("model3",model3)
	self:CreateCustomClientEnt("model4",model4)
	self:CreateCustomClientEnt("model5",model5)
	self:CreateCustomClientEnt("model6",model6)
	
	for k,v in ipairs(lamps) do
		local lamp = self:CreateCustomClientEnt("lamp"..k,lamp)
		lamp:SetLocalPos(v[1])
		lamp:SetLocalAngles(v[2])
	end
	
	for k,v in ipairs(doorlights) do
		local doorlight = self:CreateCustomClientEnt("doorlight"..k,v[4] and footlight or doorlight)
		doorlight:SetLocalPos(v[1])
		doorlight:SetLocalAngles(v[2])
	end
	
	local wiperleft = self:CreateCustomClientEnt("wiperleft",wiperleft)
	wiperleft:SetLocalPos(Vector(220.46,21.44,-4.68))
	
	local wiperright = self:CreateCustomClientEnt("wiperright",wiperright)
	wiperright:SetLocalPos(Vector(220.46,-21.44,-4.68))
end

function ENT:Think()
	BaseClass.Think(self)
	
	local intlight = self:GetInteriorLight()>0
	local cablight = self:GetCabineLight()>0
	local intlight1 = self:GetNWVar("InteriorLightActive1")
	local intlight2 = self:GetNWVar("InteriorLightActive2")
	
	for k,v in ipairs(lamps) do
		local lamp = self:GetCustomClientEnt("lamp"..k)
		if !IsValid(lamp) then continue end
		
		local bg = (
			v[3]==0 and intlight and intlight1 or
			v[3]==1 and intlight and intlight2 or
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
		local btn = self:GetMultiButton("wipers_left")
		
		if btn!=0 then
			local spd = btn==-1 and 1 or 2
			
			self.WiperLeftMoveState = self.WiperLeftMoveState or 0
			self.WiperLeftState = self.WiperLeftState and self.WiperLeftMoveState<1 or !self.WiperLeftState and self.WiperLeftMoveState<=0
		
			self.WiperLeftMoveState = self.WiperLeftState and math.min(1,self.WiperLeftMoveState+self.DeltaTime*spd) or math.max(0,self.WiperLeftMoveState-self.DeltaTime*spd)
			
			wiperleft:SetPoseParameter("state",self.WiperLeftMoveState)
		end
	end
	
	local wiperright = self:GetCustomClientEnt("wiperright")
	if IsValid(wiperright) then
		local btn = self:GetMultiButton("wipers_right")
		
		if btn!=0 then
			local spd = btn==-1 and 1 or 2
			
			self.WiperRightMoveState = self.WiperRightMoveState or 0
			self.WiperRightState = self.WiperRightState and self.WiperRightMoveState<1 or !self.WiperRightState and self.WiperRightMoveState<=0
		
			self.WiperRightMoveState = self.WiperRightState and math.min(1,self.WiperRightMoveState+self.DeltaTime*spd) or math.max(0,self.WiperRightMoveState-self.DeltaTime*spd)
			
			wiperright:SetPoseParameter("state",self.WiperRightMoveState)
		end
	end
end