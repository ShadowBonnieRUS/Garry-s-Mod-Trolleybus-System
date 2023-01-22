-- Copyright © Platunov I. M., 2021 All rights reserved

include("shared.lua")

ENT.PassSpeed = 100

function ENT:Initialize()
	self:SetRenderBounds(Vector(0,0,0),Vector(0,0,300),Vector(100,100,100))
	
	self:DrawShadow(true)
end

function ENT:Think()
	if !self:IsDormant() then
		self.Ents = self.Ents or {}
		
		local count = self:GetPassCount()
		local Ents = self.Ents
		
		if count>#Ents then
			while count>#Ents do
				local ent = Trolleybus_System.CreatePassenger()
				local pos,posindex = self:GetSpawnPassPos()
				local tr = util.TraceLine({start = pos+Vector(0,0,18),endpos = pos-Vector(0,0,10000),mask = MASK_SOLID_BRUSHONLY})
				
				ent.PosIndex = posindex
				ent:SetPos(tr.HitPos)
				ent:SetAngles(Angle(0,self:GetAngles().y,0))
				
				Ents[#Ents+1] = ent
			end
		elseif count<#Ents then
			local buses = {}
			local str = self:GetNWVar("CurrentTrolleybuses","")
			
			if str!="" then
				for k,v in ipairs(string.Explode(" ",self:GetNWVar("CurrentTrolleybuses",""))) do
					local ent = Entity(v)
					
					if IsValid(ent) then
						buses[#buses+1] = ent
					end
				end
			end
		
			while count<#Ents do
				local ent = table.remove(Ents,math.random(1,#Ents))
				if !IsValid(ent) then continue end
				
				local pos = ent:GetPos()
				
				local doorpos,dist
				for k,bus in ipairs(buses) do
					for k,v in pairs(bus.DoorsData) do
						if v.nopass or !bus:DoorIsOpened(k) then continue end
					
						local position = bus:LocalToWorld(v.pos)
						local distance = pos:Distance(position)
						
						if !dist or distance<dist then
							doorpos,dist = position,distance
						end
					end
				end
				
				if !doorpos then ent:Remove() continue end
				
				ent:SetPoseParameter("move_x",1)
				ent:ResetSequence("walk_all")
				
				hook.Add("Think",ent,function(ent)
					if !IsValid(self) then ent:Remove() return end
					if Trolleybus_System.EyePos():Distance(ent:GetPos())>Trolleybus_System.GetPlayerSetting("PassengersDrawDistance") then ent:Remove() return end
					
					self:MovePass(ent,doorpos,true)
					
					if self:Distance(ent:GetPos(),doorpos)<20 then
						ent:Remove()
					end
				end)
			end
		end
	end

	self:SetNextClientThink(CurTime()+0.1)
	return true
end

function ENT:MovePass(ent,pos,ang)
	local dir = (pos-ent:GetPos()):GetNormalized()
	dir.z = 0
	dir:Normalize()

	local fpos = ent:GetPos()+dir*self.PassSpeed*FrameTime()
	local tr = util.TraceLine({start = fpos+Vector(0,0,18),endpos = fpos-Vector(0,0,10000),mask = MASK_SOLID_BRUSHONLY})
	
	ent:SetPos(tr.StartSolid and fpos or tr.HitPos)
	
	if ang then
		local ang = (pos-ent:GetPos()):Angle()
		ent:SetAngles(Angle(0,ang.y,0))
	end
	
	ent:FrameAdvance(0)
end

function ENT:GetSpawnPassPos()
	local blocked = {}
	
	for k,v in pairs(self.Ents) do
		if IsValid(v) then
			blocked[v.PosIndex] = true
		end
	end
	
	local poss = {}
	local s = self.PassSize
	
	for x=1,self:GetLength()/s.x do
		for y=1,self:GetWidth()/s.y do
			local str = x..":"..y
			
			if !blocked[str] then
				poss[#poss+1] = {x,y,str}
			end
		end
	end
	
	local pos = poss[math.random(#poss)]
	if !pos then return self:GetPos(),"" end
	
	local p = Vector(-self:GetWidth()/2,self:GetLength()/2)+Vector(pos[2]*s.y-s.y/2,-pos[1]*s.x+s.x/2)
	
	local r = math.random()
	math.randomseed(math.floor(p.x+p.y))
	
	p.x = p.x+math.Rand(-s.y,s.y)/3
	p.y = p.y+math.Rand(-s.x,s.x)/3
	
	math.randomseed(r*1000)
	
	return self:LocalToWorld(p),pos[3]
end

function ENT:GetRandomPassPos()
	local pos,ang = self:GetPos(),self:GetAngles()
	pos:Add(math.Rand(0,self:GetLength()/2)*ang:Right()*(math.random(0,1)==1 and 1 or -1))
	pos:Add(math.Rand(0,self:GetWidth()/2)*ang:Forward()*(math.random(0,1)==1 and 1 or -1))
	
	return pos
end

function ENT:Distance(vec1,vec2)
	return math.Distance(vec1.x,vec1.y,vec2.x,vec2.y)
end

function ENT:OnRemove()
	self:NotifyShouldTransmit(false)
end

local L = Trolleybus_System.GetLanguagePhrase
local LN = Trolleybus_System.GetLanguagePhraseName

function ENT:Draw(flags)
	if self:GetPavilion() then
		self:DrawModel(flags)
		self:CreateShadow()
	else
		self:DestroyShadow()
	end
end

function ENT:DrawTranslucent(flags)
	if self:GetPavilion() then
		self:DrawModel(flags)
		self:CreateShadow()
	else
		self:DestroyShadow()
	end

	local pos,ang = self:GetPos()+self:GetAngles():Up()*200,EyeAngles()
	ang:RotateAroundAxis(ang:Up(),-90)
	ang:RotateAroundAxis(ang:Forward(),90)
	
	cam.Start3D2D(pos,ang,0.25)
		local routesstr = ""
		
		for k,v in pairs(self:GetRoutes()) do
			local route = Trolleybus_System.Routes.Routes[k]
			
			if route then
				routesstr = routesstr..(routesstr=="" and "" or ", ")..Trolleybus_System.Routes.GetRouteName(k)
			end
		end
	
		local text = L("trolleybus_stop",LN("stop."..game.GetMap()..".",self:GetStopName()))
		text = text.."\n(!tstop "..self:GetSVName()..")\n"..L("trolleybus_stop_routes",routesstr)
	
		draw.DrawText(text,"Trolleybus_System.Stop",0,0,Color(255,0,0),1,1)
	cam.End3D2D()
end

function ENT:NotifyShouldTransmit(should)
	if !should then
		if self.Ents then
			for k,v in pairs(self.Ents) do
				SafeRemoveEntity(v)
			end
			
			self.Ents = nil
		end
	end
end

surface.CreateFont("Trolleybus_System.Stop",{
	font = "Arial",
	size = 50,
	extended = true,
})

net.Receive("TrolleybusSystem.Stop.PassOut",function(len)
	local stop = net.ReadEntity()
	local bus = net.ReadEntity()
	local count = net.ReadUInt(8)
	
	if IsValid(stop) and stop:GetClass()=="trolleybus_stop" and stop.GetRandomPassPos and IsValid(bus) and !stop:IsDormant() and !bus:IsDormant() and bus.IsTrolleybus then
		for i=1,count do
			local poss = {}
			
			for k,v in pairs(bus.DoorsData) do
				if !v.nopass and bus:DoorIsOpened(k) then
					poss[#poss+1] = v.pos
				end
			end
			
			if #poss==0 then continue end
			
			local pass = Trolleybus_System.CreatePassenger()
			pass:SetPos(bus:LocalToWorld(table.Random(poss)))
			pass:SetPoseParameter("move_x",1)
			pass:SetSequence("walk_all")
			
			local goal = stop:GetRandomPassPos()
			
			stop:MovePass(pass,goal,true)
			
			hook.Add("Think",pass,function(self)
				if !IsValid(stop) then self:Remove() return end
				if Trolleybus_System.EyePos():Distance(self:GetPos())>Trolleybus_System.GetPlayerSetting("PassengersDrawDistance") then self:Remove() return end
				
				stop:MovePass(self,goal,true)
				
				if stop:Distance(self:GetPos(),goal)<20 then
					self:Remove()
				end
			end)
		end
	end
end)