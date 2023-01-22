-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Trolleybus Stop"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AutomaticFrameAdvance = false

ENT.PassSize = Vector(50,30)

Trolleybus_System.PassModels = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl",
	
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl",
}

Trolleybus_System.PassStaySequences = {
	"idle_all_01",
	"idle_all_02",
	"pose_standing_01",
	"pose_standing_02",
}

ENT.PassModels = Trolleybus_System.PassModels
ENT.PassWaitSequences = Trolleybus_System.PassStaySequences

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Length")
	self:NetworkVar("Int",1,"Width")
	self:NetworkVar("Int",2,"PassCount")
	self:NetworkVar("Int",3,"PassCountPercent")
	self:NetworkVar("Int",4,"ID")
	self:NetworkVar("Bool",0,"Pavilion")
	self:NetworkVar("String",0,"RoutesStr")
	self:NetworkVar("String",1,"StopName")
	self:NetworkVar("String",2,"SVName")
end

function ENT:GetNWVar(var,default)
	return Trolleybus_System.NetworkSystem.GetNWVar(self,var,default)
end

function ENT:GetSquare()
	return self:GetLength()*self:GetWidth()
end

function ENT:GetSize()
	return self:GetLength(),self:GetWidth()
end

function ENT:GetRoutes()
	local str = self:GetRoutesStr()
	
	if self.RoutesStr!=str then
		self.RoutesStr = str
		self.Routes = {}
		self.RoutesCount = 0
		
		local t = string.Explode(",",str)
	
		for k,v in ipairs(t) do
			local n = tonumber(v:Trim())
			
			if n then
				self.Routes[n] = true
				self.RoutesCount = self.RoutesCount+1
			end
		end
	end
	
	return self.Routes,self.RoutesCount
end

hook.Add("PhysgunPickup","Trolleybus_System_PickupStop",function(ply,ent)
	if ent:GetClass()=="trolleybus_stop" then return false end
end)

hook.Add("CanProperty","Trolleybus_System_Stops",function(ply,property,ent)
	if ent:GetClass()=="trolleybus_stop" then return false end
end)

hook.Add("CanTool","Trolleybus_System_Stops",function(ply,tr,toolname,tool,button)
	if IsValid(tr.Entity) and tr.Entity:GetClass()=="trolleybus_stop" then
		return false
	end
end)