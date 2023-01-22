-- Copyright © Platunov I. M., 2020 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base_trailer")

include("shared.lua")

ENT.PassPositionBounds = {
	{Vector(-330,-47,-47),Vector(-352,9,-44)},
	{Vector(-325,12,-47),Vector(-272,-45,-47)},
	{Vector(-267,13,-47),Vector(-188,-14,-47)},
	{Vector(-186,46,-47),Vector(-133,-45,-47)},
	{Vector(-130,12,-47),Vector(-92,-15,-47)},
}
ENT.PassPositionSeats = {
	{Vector(-350,22,-16),Angle(0,0,0)},
    {Vector(-350,38,-16),Angle(0,0,0)},
    {Vector(-318,38,-14),Angle(0,0,0)},
	{Vector(-318,22,-14),Angle(0,0,0)},
	{Vector(-286,22,-14),Angle(0,0,0)},
	{Vector(-286,38,-14),Angle(0,0,0)},
	
	{Vector(-243,38,-14),Angle(0,180,0)},
	{Vector(-243,22,-14),Angle(0,180,0)},
	{Vector(-217,22,-14),Angle(0,0,0)},
	{Vector(-217,38,-14),Angle(0,0,0)},
	
	{Vector(-217,-22,-14),Angle(0,0,0)},
	{Vector(-217,-38,-14),Angle(0,0,0)},
	{Vector(-243,-38,-14),Angle(0,180,0)},
	{Vector(-243,-22,-14),Angle(0,180,0)},
	
	{Vector(-111,-34,-28),Angle(0,0,0)},
	
	{Vector(-115,38,-28),Angle(0,0,0)},
	{Vector(-115,22,-28),Angle(0,0,0)},
}

ENT.TrolleyPoleModel = "models/trolleybus/aksm333/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/aksm333/polewheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,0.3)
ENT.TrolleyPoleDrawRotate = Angle(-20.05,180,0)
ENT.TrolleyPoleCatcherWirePos = Vector(250,0,-4.25)

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-363.22,0,60.47),
	CenterDist = 27,
	BoundMin = Vector(-4,-19),
	BoundMax = Vector(-1,19),
}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(-368.59,43.63,-16.05),size = 50},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(-368.59,-43.75,-16.05),size = 50},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(-110.51,51.09,-38.42),size = 40,color = Color(255,155,0)},
	{pos = Vector(-198.03,51.09,-38.42),size = 40,color = Color(255,155,0)},
	{pos = Vector(-261,51.09,-38.42),size = 40,color = Color(255,155,0)},
	{pos = Vector(-362.32,51.48,-38.42),size = 40,color = Color(255,155,0)},
	{pos = Vector(-104.14,-51.21,-38.53),size = 40,color = Color(255,155,0)},
	{pos = Vector(-196.89,-51.21,-38.53),size = 40,color = Color(255,155,0)},
	{pos = Vector(-260.95,-51.21,-38.53),size = 40,color = Color(255,155,0)},
	{pos = Vector(-362.4,-51.54,-38.53),size = 40,color = Color(255,155,0)},
	{pos = Vector(-364.56,-38.09,51.23),size = 40,color = Color(255,0,0)},
	{pos = Vector(-364.42,37.75,51.46),size = 40,color = Color(255,0,0)},
	{pos = Vector(-368.71,43.71,-11.64),size = 40,color = Color(255,0,0)},
	{pos = Vector(-368.71,43.71,-28.86),size = 40,color = Color(255,0,0)},
	{pos = Vector(-368.71,-43.74,-28.86),size = 40,color = Color(255,0,0)},
	{pos = Vector(-368.71,-43.74,-11.91),size = 40,color = Color(255,0,0)},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-368.71,-43.74,-21.38),size = 50},
	{pos = Vector(-368.71,43.78,-21.38),size = 50},
}
ENT.BackwardMoveLights = {
	brightness = 1,

	{pos = Vector(-368.71,43.78,-25.85),size = 45},
	{pos = Vector(-368.71,-43.82,-25.85),size = 45},
}

ENT.OtherPanelEntsData = {}

local seats = "models/trolleybus/aksm333/trailer_parts1.mdl"
local parts2 = "models/trolleybus/aksm333/trailer_parts2.mdl"
local parts3 = "models/trolleybus/aksm333/trailer_parts3.mdl"
local interior = "models/trolleybus/aksm333/trailer_interior.mdl"
local lamp = "models/trolleybus/aksm333/lamp.mdl"
local doorlight3 = "models/trolleybus/aksm333/doorlight3.mdl"
local doorlight4 = "models/trolleybus/aksm333/doorlight4.mdl"

local lamps = {
	{Vector(-299.46,0,47.07),Angle(-180,-90,0)},
    {Vector(-138.2,0,47.07),Angle(-180,-90,0)},
    {Vector(-187.78,0,47.07),Angle(-180,-90,0)},
    {Vector(-232.18,0,47.07),Angle(-180,-90,0)},
}

local function CreateModel(self,index,model,pos,ang)
	local ent = self:CreateCustomClientEnt(index,model)
	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)
	
	return ent
end

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	local seats = CreateModel(self,"seats",seats)
	seats:SetBodygroup(0,(self:GetSpawnSetting("seats") or 1)-1)
	
	CreateModel(self,"parts2",parts2)
	
	local parts3 = CreateModel(self,"parts3",parts3)
	parts3:SetBodygroup(0,self:GetSpawnSetting("wnddet")==1 and 0 or 1)
	parts3:SetBodygroup(1,self:GetSpawnSetting("emblem") and 0 or 1)
	
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