-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base_trailer")

include("shared.lua")

ENT.PassPositionBounds = {
	{Vector(-330,13,-49),Vector(-275,-45,-49)},
	{Vector(-275,13,-49),Vector(-190,-14,-49)},
	{Vector(-190,46,-49),Vector(-140,-45,-49)},
	{Vector(-140,12,-49),Vector(-93,-15,-49)},
}
ENT.PassPositionSeats = {
	{Vector(-357,37,-19),Angle(0,0,0)},
	{Vector(-357,18,-19),Angle(0,0,0)},
	{Vector(-357,0,-19),Angle(0,0,0)},
	{Vector(-357,-18,-19),Angle(0,0,0)},
	{Vector(-357,-37,-19),Angle(0,0,0)},
	
	{Vector(-314,36,-19),Angle(0,-90,0)},
	{Vector(-291,36,-19),Angle(0,-90,0)},
	
	{Vector(-249,38,-19),Angle(0,180,0)},
	{Vector(-249,22,-19),Angle(0,180,0)},
	{Vector(-221,22,-19),Angle(0,0,0)},
	{Vector(-221,38,-19),Angle(0,0,0)},
	
	{Vector(-221,-22,-19),Angle(0,0,0)},
	{Vector(-221,-38,-19),Angle(0,0,0)},
	{Vector(-249,-38,-19),Angle(0,180,0)},
	{Vector(-249,-22,-19),Angle(0,180,0)},
	
	{Vector(-122,-34,-30),Angle(0,0,0)},
	
	{Vector(-122,38,-30),Angle(0,0,0)},
	{Vector(-122,22,-30),Angle(0,0,0)},
}

ENT.TrolleyPoleModel = "models/trolleybus/aksm333o/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/aksm333o/polewheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,0.3)
ENT.TrolleyPoleDrawRotate = Angle(-20.05,180,0)
ENT.TrolleyPoleCatcherWirePos = Vector(250,0,-4.25)

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-368,0,58),
	CenterDist = 27,
	BoundMin = Vector(-4,-19),
	BoundMax = Vector(-1,19),
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(-373.43,43.9,-17.67),size = 50},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(-373.48,-43.56,-17.91),size = 50},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(-101.32,51.09,-42.39),size = 40,color = Color(255,155,0)},
	{pos = Vector(-202.91,51.09,-42.39),size = 40,color = Color(255,155,0)},
	{pos = Vector(-265.81,51.09,-42.39),size = 40,color = Color(255,155,0)},
	{pos = Vector(-367.23,51.49,-40.72),size = 40,color = Color(255,155,0)},
	{pos = Vector(-101.26,-51.04,-42.36),size = 40,color = Color(255,155,0)},
	{pos = Vector(-201.61,-51.04,-42.36),size = 40,color = Color(255,155,0)},
	{pos = Vector(-265.79,-51.04,-42.36),size = 40,color = Color(255,155,0)},
	{pos = Vector(-367.3,-51.45,-40.83),size = 40,color = Color(255,155,0)},
	{pos = Vector(-369.28,37.88,49.18),size = 40,color = Color(255,0,0)},
	{pos = Vector(-369.31,-37.97,49.14),size = 40,color = Color(255,0,0)},
	{pos = Vector(-373.51,43.73,-13.79),size = 40,color = Color(255,0,0)},
	{pos = Vector(-373.51,43.73,-30.65),size = 40,color = Color(255,0,0)},
	{pos = Vector(-373.45,-43.69,-13.98),size = 40,color = Color(255,0,0)},
	{pos = Vector(-373.45,-43.69,-30.91),size = 40,color = Color(255,0,0)},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-373.45,-43.69,-23.78),size = 50},
	{pos = Vector(-373.41,43.88,-23.71),size = 50},
}
ENT.BackwardMoveLights = {
	brightness = 1,

	{pos = Vector(-373.42,43.73,-28.08),size = 45},
	{pos = Vector(-373.46,-43.7,-28.08),size = 45},
}

ENT.OtherPanelEntsData = {}

local seats = {
	"models/trolleybus/aksm333o/trailer_seats1.mdl",
	"models/trolleybus/aksm333o/trailer_seats2.mdl",
	"models/trolleybus/aksm333o/trailer_seats3.mdl",
}

local interior = "models/trolleybus/aksm333o/trailer_interior.mdl"
local handrails = "models/trolleybus/aksm333o/trailer_handrails.mdl"
local lamp = "models/trolleybus/aksm333o/lamp.mdl"
local doorlight3 = "models/trolleybus/aksm333o/doorlight3.mdl"
local doorlight4 = "models/trolleybus/aksm333o/doorlight4.mdl"

local lamps = {
	{Vector(-120,-24,45.5),Angle(-180,90,0)},
    {Vector(-232,-24,45.5),Angle(-180,90,0)},
    {Vector(-348,-24,45.5),Angle(-180,90,0)},
    {Vector(-288,24,45.5),Angle(-180,90,0)},
	{Vector(-288,24,45.5),Angle(-180,90,0)},
	{Vector(-178,24,45.5),Angle(-180,90,0)},
}

local function CreateModel(self,index,model,pos,ang)
	local ent = self:CreateCustomClientEnt(index,model)
	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)
	
	return ent
end

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	local seats = CreateModel(self,"seats",seats[self:GetSpawnSetting("seats") or 1])
	
	CreateModel(self,"handrails",handrails)
	CreateModel(self,"interior",interior)
	CreateModel(self,"doorlight3",doorlight3)
	CreateModel(self,"doorlight4",doorlight4)
	
	for k,v in ipairs(lamps) do
		local ent = CreateModel(self,"lamp"..k,lamp,v[1],v[2])
		ent:SetBodygroup(0,(self:GetSpawnSetting("lamps") or 1)-1)
	end
end

function ENT:Think()
	BaseClass.Think(self)
	
	
	local doorlight3 = self:GetCustomClientEnt("doorlight3")
	if IsValid(doorlight3) then
		doorlight3:SetSkin(self:GetNWVar("Door3Light") and 1 or 0)
	end
	
	local doorlight4 = self:GetCustomClientEnt("doorlight4")
	if IsValid(doorlight4) then
		doorlight4:SetSkin(self:GetNWVar("Door4Light") and 1 or 0)
	end
	
	local bus = self:GetMainTrolleybus()
	if IsValid(bus) then
		local skin = bus:GetInteriorLight()>0 and 1 or 0
	
		for k,v in ipairs(lamps) do
			local lamp = self:GetCustomClientEnt("lamp"..k)
			if !IsValid(lamp) then continue end
			
			lamp:SetSkin(skin)
		end
	end

	return true
end