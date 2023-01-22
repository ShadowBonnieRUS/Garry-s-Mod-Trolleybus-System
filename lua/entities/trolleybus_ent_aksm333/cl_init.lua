-- Copyright © Platunov I. M., 2020 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

ENT.MirrorsData = {}
include("shared.lua")

ENT.IconOverride = "trolleybus/trolleybus_icons/aksm333.png"

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.RearNumber",{
	font = "Minecart LCD",
	size = 52,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.RouteNumber",{
	font = "Minecart LCD",
	size = 108,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.Route",{
	font = "Minecart LCD",
	size = 42,
	extended = true,
})

surface.CreateFont("Trolleybus_System.Trolleybus.AKSM333.RouteDisplay.Integral",{
	font = "Minecart LCD",
	size = 38,
	extended = true,
})

ENT.PassPositionBounds = {
	{Vector(-24,-13.44,-47),Vector(58,13,-47)},
	{Vector(58,-26,-47),Vector(82,8,-47)},
	{Vector(87,8,-47),Vector(137,-42,-47)},
	{Vector(112,48,-47),Vector(162,16,-47)},
	{Vector(142,-10,-47),Vector(279,16,-47)},
	{Vector(281,-18,-47),Vector(306,-44,-47)},
}
ENT.PassPositionSeats = {
	{Vector(0,38,-13),Angle(0,180,0)},
    {Vector(0,22,-13),Angle(0,180,0)},
    {Vector(27,22,-13),Angle(0,0,0)},
    {Vector(27,38,-13),Angle(0,0,0)},
    
    {Vector(0,-38,-13),Angle(0,180,0)},
    {Vector(0,-22,-13),Angle(0,180,0)},
    {Vector(28,-22,-13),Angle(0,0,0)},
    {Vector(28,-38,-13),Angle(0,0,0)},
    
    {Vector(61,-38,-13),Angle(0,0,0)},
	
	{Vector(69,38,-13),Angle(0,180,0)},
	{Vector(69,22,-13),Angle(0,180,0)},
    
	{Vector(156,-38,-27),Angle(0,0,0)},
	
	{Vector(183,-38,-27),Angle(0,0,0)},
	{Vector(183,-22,-27),Angle(0,0,0)},
	{Vector(221,-22,-27),Angle(0,180,0)},
	{Vector(221,-38,-27),Angle(0,180,0)},
	
	{Vector(221,38,-27),Angle(0,180,0)},
	{Vector(221,22,-27),Angle(0,180,0)},
	{Vector(179,22,-27),Angle(0,0,0)},
	{Vector(179,38,-27),Angle(0,0,0)},
}

ENT.SteerData = {
	model = "models/trolleybus/aksm333/steer.mdl",
	pos = Vector(324.43,30.67,-11.21),
	ang = Angle(-20,0,0),
	rollmult = 450,
}

ENT.CabineLightData = {
	pos = Vector(320.71,1.65,41.74),
	ang = Angle(90,0,0),
	brightness = 0.3,
	color = Color(255,255,255),
	farz = 100,
	nearz = 1,
	fov = 179,
	texture = "effects/flashlight001",
	
	dlight_pos = Vector(320.71,1.65,24),
	dlight_size = 200,
	dlight_brightness = 3,
}

ENT.CameraView = {
	DriverCameraPos = Vector(304,30.5,8),
	Pos = Vector(0,0,0),
	MaxDistance = 700,
	MirrorLeft = {Vector(324,58,19),Angle(0,180,0)},
	MirrorRight = {Vector(341,-59,20),Angle(0,180,0)},
	ViewMoveLimits = {Vector(-17,-17,-40),Vector(30,17,30)},
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(346.16,48.86,-40.6),size = 40},
	{pos = Vector(343.17,51.36,-19.86),size = 45},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(346.16,-49.1,-40.6),size = 40},
	{pos = Vector(343.31,-51.63,-20.04),size = 45},
}

ENT.TurnSignalSoundOn = "trolleybus/turnsound_on.ogg"
ENT.TurnSignalSoundOff = "trolleybus/turnsound_off.ogg"

ENT.HeadLights = {
	brightness = 1,

	{pos = Vector(350.39,-43.59,-38.88),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
	{pos = Vector(350.39,43.17,-38.88),ang = Angle(),color = Color(255,255,255),size = 90,brightness = 0.5,farz = 1000,nearz = 2,fov = 90,texture = "effects/flashlight001"},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(344.58,40.07,41.19),size = 40,color = Color(255,255,255)},
	{pos = Vector(344.58,-40.36,41.19),size = 40,color = Color(255,255,255)},
	{pos = Vector(333.94,-6.21,55.08),size = 40,color = Color(255,155,0)},
	{pos = Vector(333.94,-0.22,55.08),size = 40,color = Color(255,155,0)},
	{pos = Vector(333.94,5.91,55.08),size = 40,color = Color(255,155,0)},
	{pos = Vector(303.92,50.91,-38.52),size = 40,color = Color(255,155,0)},
	{pos = Vector(186.9,50.91,-38.52),size = 40,color = Color(255,155,0)},
	{pos = Vector(103.04,50.91,-38.52),size = 40,color = Color(255,155,0)},
	{pos = Vector(-17.15,50.91,-38.52),size = 40,color = Color(255,155,0)},
	{pos = Vector(278.72,-51.25,-38.49),size = 40,color = Color(255,155,0)},
	{pos = Vector(168.07,-51.25,-38.49),size = 40,color = Color(255,155,0)},
	{pos = Vector(67.48,-51.25,-38.49),size = 40,color = Color(255,155,0)},
	{pos = Vector(-17.12,-51.25,-38.49),size = 40,color = Color(255,155,0)},
	{pos = Vector(346.5,-48.87,-38.06),size = 40,color = Color(255,255,255)},
	{pos = Vector(346.5,48.66,-38.06),size = 40,color = Color(255,255,255)},
}

ENT.BrakeLights = {}
ENT.BackwardMoveLights = {}

local seats = {
	"models/trolleybus/aksm333/parts1.mdl",
	"models/trolleybus/aksm333/parts2.mdl",
}

local parts3 = "models/trolleybus/aksm333/parts3.mdl"
local parts4 = "models/trolleybus/aksm333/parts4.mdl"
local interior = "models/trolleybus/aksm333/interior.mdl"
local interior2 = "models/trolleybus/aksm333/interior2.mdl"
local lamp = "models/trolleybus/aksm333/lamp.mdl"
local wipers = "models/trolleybus/aksm333/wipers.mdl"
local doorlight1 = "models/trolleybus/aksm333/doorlight1.mdl"
local doorlight2 = "models/trolleybus/aksm333/doorlight2.mdl"

local lamps = {
	{Vector(163.57,0,47.05),Angle(-180,-90,0)},
    {Vector(113.38,0,47.05),Angle(-180,-90,0)},
    {Vector(59.45,0,47.05),Angle(-180,-90,0)},
    {Vector(1.5,0,47.05),Angle(-180,-90,0)},
    {Vector(234.68,26.09,45.37),Angle(172,-90,0)},
    
    {Vector(325.41,21.76,45.5),Angle(-180,0,0),true},
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
	CreateModel(self,"parts3",parts3)
	
	local parts4 = CreateModel(self,"parts4",parts4)
	parts4:SetBodygroup(0,self:GetSpawnSetting("wnddet")-1)
	parts4:SetBodygroup(1,self:GetSpawnSetting("speakers") and 0 or 1)
	
	CreateModel(self,"interior",interior)
	CreateModel(self,"interior2",interior2)
	CreateModel(self,"doorlight1",doorlight1)
	CreateModel(self,"doorlight2",doorlight2)
	
	for k,v in ipairs(lamps) do
		local ent = CreateModel(self,"lamp"..k,lamp,v[1],v[2])
		ent:SetBodygroup(0,self:GetSpawnSetting("lamps")-1)
		ent.Cabine = v[3]
	end
	
	CreateModel(self,"wipers",wipers,Vector(349.89,-0.14,-19.1))
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