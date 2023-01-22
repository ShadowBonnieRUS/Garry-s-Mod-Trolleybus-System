-- Copyright © Platunov I. M., 2020 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base_trailer")

include("shared.lua")

ENT.PassPositionBounds = {
	{Vector(-61,-11,-28),Vector(57,10,-28)},
	{Vector(-61,10,-28),Vector(-115,-22,-28)},
	{Vector(57,23,-28),Vector(113,-18,-28)},
}
ENT.PassPositionSeats = {
	{Vector(-108,35,-15),Angle(0,0,0)},
	{Vector(-108,18,-15),Angle(0,0,0)},
	{Vector(-80,35,-15),Angle(0,0,0)},
	{Vector(-80,18,-15),Angle(0,0,0)},
	
	{Vector(-49,32,-12),Angle(0,180,0)},
	{Vector(-28,30,-8),Angle(0,0,0)},
	
	{Vector(8,35,-15),Angle(0,0,0)},
	{Vector(8,18,-15),Angle(0,0,0)},
	{Vector(38,35,-15),Angle(0,0,0)},
	{Vector(38,18,-15),Angle(0,0,0)},
	
	{Vector(65,34,-15),Angle(0,0,0)},
	{Vector(92,34,-15),Angle(0,0,0)},
	
	{Vector(-36,-35,-11),Angle(0,180,0)},
	{Vector(-36,-18,-11),Angle(0,180,0)},
	{Vector(-14,-35,-15),Angle(0,0,0)},
	{Vector(-14,-18,-15),Angle(0,0,0)},
	
	{Vector(15,-35,-15),Angle(0,0,0)},
	{Vector(15,-18,-15),Angle(0,0,0)},
	{Vector(43,-32,-15),Angle(0,90,0)},
}

ENT.TrolleyPoleModel = "models/trolleybus/ziu6205/pole.mdl"
ENT.TrolleyPoleWheelModel = "models/trolleybus/ziu6205/pole_wheel.mdl"
ENT.TrolleyPoleWheelOffset = Vector(0,0,0)
ENT.TrolleyPoleWheelRotate = Angle(19,0,0)
ENT.TrolleyPoleDrawRotate = Angle(-0.7,179.83,0)
ENT.TrolleyPoleCatcherWirePos = Vector(235,0,-3)

ENT.TrolleyPoleCatcherWiresLimits = {
	CenterPos = Vector(-127.5,0,41),
	CenterDist = 22,
	BoundMin = Vector(-1.8,-10),
	BoundMax = Vector(1.5,10),
}

ENT.OtherPanelEntsData = {}

ENT.TurnSignalLeft = {
	brightness = 1,

	{pos = Vector(-124.26,36.81,-15.68),size = 45},
}

ENT.TurnSignalRight = {
	brightness = 1,

	{pos = Vector(-124.26,-36.81,-15.68),size = 45},
}

ENT.ProfileLights = {
	brightness = 1,

	{pos = Vector(-124.26,36.81,-18.68),size = 40,color = Color(255,0,0),active = function(self) return self:GetMainTrolleybus(true):ButtonIsDown("profilelightsbottom") end},
	{pos = Vector(-124.26,-36.81,-18.68),size = 40,color = Color(255,0,0),active = function(self) return self:GetMainTrolleybus(true):ButtonIsDown("profilelightsbottom") end},
	{pos = Vector(-123.82,32.42,44.69),size = 40,color = Color(255,0,0),active = function(self) return self:GetMainTrolleybus(true):ButtonIsDown("profilelightstop") end},
	{pos = Vector(-123.82,-32.42,44.69),size = 40,color = Color(255,0,0),active = function(self) return self:GetMainTrolleybus(true):ButtonIsDown("profilelightstop") end},
}

ENT.BrakeLights = {
	brightness = 1,

	{pos = Vector(-124.23,36.76,-12.24),size = 45},
	{pos = Vector(-124.23,-36.76,-12.24),size = 45},
}
ENT.BackwardMoveLights = {
	brightness = 1,

	{pos = Vector(-124.21,36.9,-21.83),size = 45},
	{pos = Vector(-124.21,-36.9,-21.83),size = 45},
}

local lamp = "models/trolleybus/ziu6205/interior_lamp.mdl"
local doorlight = "models/trolleybus/ziu6205/door_illumination.mdl"
local footlight = "models/trolleybus/ziu6205/footstep_illumination.mdl"

local lamps = {
	{Vector(-83.54,32.25,45.8),Angle(0,0,-11.7),0},
	{Vector(-27.13,32.25,45.8),Angle(0,0,-11.7),1},
	{Vector(26.97,32.25,45.8),Angle(0,0,-11.7),0},
	{Vector(83.8,32.25,45.8),Angle(0,0,-11.7),1},
	
	{Vector(-94.04,-8.1,47.63),Angle(0,0,0.8),1},
	{Vector(-28.73,-32.61,45.78),Angle(0,0,10.2),0},
	{Vector(27.26,-32.61,45.78),Angle(0,0,10.2),1},
}

local doorlights = {
	{Vector(92.32,-33.49,-41),Angle(0,0,0),"Door3Light",true},
	{Vector(76.37,-33.49,-41),Angle(0,0,0),"Door3Light",true},
	{Vector(76.22,-39.58,34.57),Angle(0,0,-8.6),"Door3Light"},
	{Vector(-78.63,-33.49,-41),Angle(0,0,0),"Door4Light",true},
	{Vector(-94.68,-33.49,-41),Angle(0,0,0),"Door4Light",true},
	{Vector(-95.03,-39.58,34.57),Angle(0,0,-8.6),"Door4Light"},
}

local function CreateModel(self,index,model,pos,ang)
	local mdl = self:CreateCustomClientEnt(index,model)
	mdl:SetLocalPos(pos or vector_origin)
	mdl:SetLocalAngles(ang or angle_zero)
	
	return mdl
end

function ENT:CreateClientEnts()
	BaseClass.CreateClientEnts(self)
	
	for k,v in ipairs(lamps) do
		CreateModel(self,"Lamp"..k,lamp,v[1],v[2])
	end
	
	for k,v in ipairs(doorlights) do
		CreateModel(self,"Doorlight"..k,v[4] and footlight or doorlight,v[1],v[2])
	end
end

function ENT:Think()
	BaseClass.Think(self)
	
	local bus = self:GetMainTrolleybus()
	if IsValid(bus) then
		local intlight = bus:GetInteriorLight()>0
		local cablight = bus:GetCabineLight()>0
		
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
	end
end