-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.PosCollSpeed = 9
SYSTEM.PosUncollSpeed = 9
SYSTEM.RCRotatingAmperage = {250,300,400,450}

SYSTEM.Resistances = {5.308,4.308,3.488,2.848,2.04,1.732,1.424,1.11,1.032,0.87,0.731,0.536,1,1,0.644,0.483,0.01186,0.00935}

SYSTEM.Brake1Percent = 0.5

SYSTEM.ContactorSounds = {
	LK123 = {Sound("trolleybus/contactor_go_in.mp3"),Sound("trolleybus/contactor_go_out.mp3")},
	R = {Sound("trolleybus/contactor_r.mp3"),Sound("trolleybus/contactor_r2.mp3")},
	T = {Sound("trolleybus/contactor_brake_in.mp3"),Sound("trolleybus/contactor_brake_out.mp3")},
}
SYSTEM.ContactorSoundPos = Vector(251,-10,21)
SYSTEM.ContactorSoundVolume = 0.5

function SYSTEM:Initialize()
	self.Position = 1
	self.RCRotating = false
	
	self.LK123 = false
	self.R = false
	self.T = false
	self.ContactorsActive = false
	self.EngineAmperage = 0
end

function SYSTEM:GetPosition()
	return math.floor(self.Position)
end

function SYSTEM:Think(dt)
	local bus = self.Trolleybus
	local C = bus.Controls
	local power = self.ContactorsActive
	
	local startpedal = C.StartPedal
	local brakepedal = C.BrakePedal
	
	local LK123 = power and bus:GetReverseState()!=0 and startpedal>0 and (self.LK123 or !self.RCRotating)
	
	if self.LK123!=LK123 then
		self.LK123 = LK123
		
		self:PlayContactorSound("LK123",LK123)
	end
	
	local T = power and bus:GetReverseState()!=0 and brakepedal>0
	
	if self.T!=T then
		self.T = T
	
		self:PlayContactorSound("T",T)
	end
	
	local destpos = power and LK123 and (startpedal>3 and 18 or startpedal>2 and 17 or startpedal>1 and 15) or 1

	local stoprotoffset = startpedal>2 and 2 or 0
	self.StopRotating = LK123 and !self.R and self.EngineAmperage>self.RCRotatingAmperage[(self.StopRotating and 1 or 2)+stoprotoffset]
	self.RCRotating = self.Position!=destpos and !self.StopRotating
	
	self:SetNWVar("RCState",self.RCRotating and (self.Position<destpos and 1 or 2) or 0)
	
	if self.RCRotating then
		self.Position = self.Position>destpos and math.max(destpos,self.Position-dt*self.PosUncollSpeed) or math.min(destpos,self.Position+dt*self.PosCollSpeed)
	end
	
	local R = startpedal>0 and self.Position>=13 and (self.R or !self.RCRotating)
	
	if self.R!=R then
		self.R = R
		
		if R then
			self:PlayContactorSound("R",R)
		end
	end
	
	self:SetNWVar("Position",self:GetPosition())
	
	if T then
		self.EngineBrakeFraction = 1
		
		if brakepedal<=1 then
			self.EngineBrakeFraction = self.Brake1Percent
		end
	end
	
	self.EngineAsGenerator = T
end

function SYSTEM:GetResistance()
	if self.LK123 then
		return self.Resistances[self:GetPosition()]
	end

	return math.huge
end

function SYSTEM:SetEngineAmperage(amperage)
	self.EngineAmperage = amperage
end

function SYSTEM:GetEngineBrakeFraction()
	return self.EngineBrakeFraction or 1
end

function SYSTEM:IsEngineAsGenerator()
	return self.EngineAsGenerator or false
end

function SYSTEM:PlayContactorSound(type,lock)
	local snds = self.ContactorSounds[type]
	
	if snds then
		Trolleybus_System.PlayBassSoundSimple(self.Trolleybus,snds[lock and 1 or 2],200,self.ContactorSoundVolume,nil,self.ContactorSoundPos)
	end
end

function SYSTEM:ControlPedals(ply,dt,C,OC)
	if Trolleybus_System.GetPlayerSetting(ply,"UseExternalPedals") then
		local startpedal = ply.TrolleybusDeviceInputData_startpedal
		local brakepedal = ply.TrolleybusDeviceInputData_brakepedal
	
		C.StartPedal = C.BrakePedal>0 and 0 or startpedal and startpedal*4 or C.StartPedal
		C.BrakePedal = brakepedal and brakepedal*3 or C.BrakePedal
	else
		if C.FullBrake then
			C.StartPedal = 0
			C.BrakePedal = 3
		else
			if C.Reset then
				if !OC.Reset then
					C.StartPedal = 0
					C.BrakePedal = 0
				end
			elseif C.SActive then
				C.StartPedal = 0
			
				if !OC.SActive and C.BrakePedal<2 then
					C.BrakePedal = math.min(2,C.BrakePedal+1)
				elseif (C.BrakePedal>2 or C.BrakePedal==2 and !OC.SActive) and C.BrakePedal<3 then
					C.BrakePedal = math.min(C.BrakePedal+dt,3)
				end
			elseif C.WActive then
				C.BrakePedal = 0
			
				if !OC.WActive and C.StartPedal<4 then
					C.StartPedal = math.min(4,C.StartPedal+1)
				end
			end
		end
	end
	
	self:SetNWVar("PedalPos",C.BrakePedal>0 and -math.ceil(C.BrakePedal) or math.ceil(C.StartPedal))
end

function SYSTEM:SetContactorsActive(active)
	self.ContactorsActive = active
end

Trolleybus_System.RegisterSystem("RKSU",SYSTEM)
SYSTEM = nil