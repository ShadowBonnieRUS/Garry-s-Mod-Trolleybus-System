-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.PlayPos = Vector(5,6,58)
SYSTEM.TrailerPlayPos = Vector()

function SYSTEM:SetActive(active)
	self:SetNWVar("Active",active)
end

function SYSTEM:SetRouteState(active)
	self:SetNWVar("State",active)
end

function SYSTEM:SetRoute(route)
	self:SetNWVar("Route",route)
end

function SYSTEM:OnChangeButtonPressed(isnext)
	if !self:IsActive() then return end

	if self:IsRouteState() then
		local routes = {}
		
		for k,v in pairs(Trolleybus_System.GetInformators()) do
			routes[#routes+1] = {k,v}
		end
		
		if #routes==0 then
			self:SetRoute(0)
		
			return
		end
		
		table.sort(routes,function(a,b) return a[1]<b[1] end)
		
		local prev
		local route = self:GetRoute()
		
		for i=1,#routes do
			local id = routes[i][1]
			
			if isnext and id>route or !isnext and prev and prev<route and id>=route then
				self:SetRoute(isnext and id or prev)
			
				break
			end
			
			prev = id
		end
	else
		local data = self.CurrentData
		
		self:StopSound()
		
		if isnext then
			if data.CurrentPlayline==#data.Playlines then
				data.CurrentPlayline = 1
			else
				data.CurrentPlayline = data.CurrentPlayline+1
			end
		else
			if data.CurrentPlayline==1 then
				data.CurrentPlayline = #data.Playlines
			else
				data.CurrentPlayline = data.CurrentPlayline-1
			end
		end
		
		data.CurrentSoundID = 1
		
		self:SetNWVar("Playline",data.CurrentPlayline)
	end
end

function SYSTEM:Think(dt)
	if self:IsActive() and !self:IsRouteState() then
		local data = self.CurrentData
		
		if data.Playing and CurTime()>data.PlayEndTime then
			local sounds = data.Playlines[data.CurrentPlayline].sounds
			
			self:StopSound()
			
			if sounds[data.CurrentSoundID+1] then
				data.CurrentSoundID = data.CurrentSoundID+1
				
				self:PlaySound()
			else
				if data.Playlines[data.CurrentPlayline+1] then
					data.CurrentPlayline = data.CurrentPlayline+1
				else
					data.CurrentPlayline = 1
				end
				
				data.CurrentSoundID = 1
				
				self:SetNWVar("Playline",data.CurrentPlayline)
			end
		end
	end
end

function SYSTEM:PlaySound()
	local data = self.CurrentData
	
	if data then
		self:StopSound()
	
		local sounddata = data.Playlines[data.CurrentPlayline].sounds[data.CurrentSoundID]
		
		if !sounddata then
			if data.Playlines[data.CurrentPlayline+1] then
				data.CurrentPlayline = data.CurrentPlayline+1
			else
				data.CurrentPlayline = 1
			end
			
			self:SetNWVar("Playline",data.CurrentPlayline)
		
			return
		end
		
		local sound = sounddata.sound
		
		data.Playing = true
		data.PlayEndTime = CurTime()+sounddata.length
	
		if sound=="" then
			data.CurrentSound = nil
		else
			data.CurrentSound = sound
			
			Trolleybus_System.PlayBassSound(self.Trolleybus,data.CurrentSound,500,nil,nil,nil,self.PlayPos)
			
			if IsValid(self.Trolleybus:GetTrailer()) then
				Trolleybus_System.PlayBassSound(self.Trolleybus:GetTrailer(),data.CurrentSound,500,nil,nil,nil,self.TrailerPlayPos)
			end
		end
	end
end

function SYSTEM:StopSound()
	local data = self.CurrentData
	
	if data then
		if data.Playing and data.CurrentSound then
			Trolleybus_System.StopBassSound(self.Trolleybus,data.CurrentSound)
			
			if IsValid(self.Trolleybus:GetTrailer()) then
				Trolleybus_System.StopBassSound(self.Trolleybus:GetTrailer(),data.CurrentSound)
			end
			
			data.CurrentSound = nil
		end
		
		data.Playing = false
	end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	self:StopSound()
	self:SetupUnload()
end

Trolleybus_System.RegisterSystem("IR-2002",SYSTEM)
SYSTEM = nil