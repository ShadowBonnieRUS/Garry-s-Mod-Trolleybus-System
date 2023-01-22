-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "Trolleybus Traffic Light"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.AutomaticFrameAdvance = false

function ENT:SetupDataTables()
	self:NetworkVar("Float",0,"Time")
	self:NetworkVar("Float",1,"StatesDuration")
	self:NetworkVar("Int",0,"State")
	self:NetworkVar("Int",1,"ID")
	self:NetworkVar("String",0,"Type")
	self:NetworkVar("Bool",0,"Disabled")
	
	for i=1,10 do
		self:NetworkVar("Int",1+i,"Lense"..i)
	end
	
	if SERVER then
		self:SetupDataTablesSV()
	end
end

function ENT:LightType(type)
	return Trolleybus_System.TrafficLightTypes[type or self:GetType()]
end

function ENT:GetLense(num)
	if self:GetDisabled() then
		return "nolense"
	end

	local id = self["GetLense"..num](self)
	return Trolleybus_System.TrafficLightLenseIDs[id] or "nolense"
end

function ENT:GetLenseData(num)
	local lense = self:GetLense(num)
	local ldata = Trolleybus_System.TrafficLightLenses[lense]
	
	if !ldata then
		lense = "nolense"
		ldata = Trolleybus_System.TrafficLightLenses[lense]
	end
	
	return lense,ldata
end

hook.Add("PhysgunPickup","Trolleybus_System_PickupTrafficlight",function(ply,ent)
	if ent:GetClass()=="trolleybus_trafficlight" or Trolleybus_System.NetworkSystem.GetNWVar(ent,"TrafficLight") then return false end
end)

hook.Add("CanProperty","Trolleybus_System_TrafficLightEnts",function(ply,property,ent)
	if ent:GetClass()=="trolleybus_trafficlight" or Trolleybus_System.NetworkSystem.GetNWVar(ent,"TrafficLight") then return false end
end)

local tools = {trolleytrafficeditor = true,trolleytrafficlighteditor = true}
hook.Add("CanTool","Trolleybus_System_TrafficLightEnts",function(ply,tr,toolname,tool,button)
	if IsValid(tr.Entity) and (tr.Entity:GetClass()=="trolleybus_trafficlight" or Trolleybus_System.NetworkSystem.GetNWVar(tr.Entity,"TrafficLight")) and !tools[toolname] then
		return false
	end
end)