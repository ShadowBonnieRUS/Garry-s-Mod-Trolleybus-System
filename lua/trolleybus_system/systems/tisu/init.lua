-- Copyright © Platunov I. M., 2021 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.Start1Resistance = 8.308
SYSTEM.Start2Resistance = 3.308
SYSTEM.Start3Resistance = 1.224
SYSTEM.Start4Resistance = 0.161

SYSTEM.Brake1Percent = 0.5

SYSTEM.ContactorSounds = {
	LK = {Sound("trolleybus/contactor_go_in.mp3"),Sound("trolleybus/contactor_go_out.mp3")},
	T = {Sound("trolleybus/contactor_brake_in.mp3"),Sound("trolleybus/contactor_brake_out.mp3")},
}
SYSTEM.ContactorSoundPos = Vector(251,-10,21)
SYSTEM.ContactorSoundVolume = 0.5

function SYSTEM:Initialize()
	self.Resistance = 1
	self.ContactorsActive = false
	self.LK = false
	self.T = false
end

function SYSTEM:SetEngineAmperage(amp)
	self:SetNWVar("EngineAmperage",amp)
end

function SYSTEM:SetEngineRotation(rotation)
	self:SetNWVar("EngineRotation",rotation)
end

function SYSTEM:Think(dt)
	local bus = self.Trolleybus
	local C = bus.Controls
	
	local startpedal = C.StartPedal
	local brakepedal = C.BrakePedal
	local contactors = self.ContactorsActive
	local reverseactive = bus:GetReverseState()!=0
	
	local LK = contactors and reverseactive and self.TISUActive and startpedal>0 or false
	
	if self.LK!=LK then
		self.LK = LK
		
		self:PlayContactorSound("LK",LK)
	end
	
	local T = contactors and reverseactive and self.TISUActive and brakepedal>0 or false
	
	if self.T!=T then
		self.T = T
		
		self:PlayContactorSound("T",T)
	end
	
	local amp,br = 0,1
	
	if LK then
		self.Resistance =
			startpedal>3 and self.Start4Resistance or
			startpedal>2 and self.Start3Resistance or
			startpedal>1 and self.Start2Resistance or
			self.Start1Resistance
	elseif T and brakepedal<=1 then
		br = self.Brake1Percent
	end
	
	self:SetNWVar("EngineAsGenerator",T)
	
	if T then
		self.EngineBrakeFraction = br
	end
end

function SYSTEM:GetResistance()
	if self.LK then
		return self.Resistance
	end

	return math.huge
end

function SYSTEM:PlayContactorSound(type,lock)
	local snds = self.ContactorSounds[type]
	
	if snds then
		Trolleybus_System.PlayBassSoundSimple(self.Trolleybus,snds[lock and 1 or 2],200,self.ContactorSoundVolume,nil,self.ContactorSoundPos)
	end
end

function SYSTEM:GetEngineBrakeFraction()
	return self.EngineBrakeFraction or 0
end

function SYSTEM:SetContactorsActive(active)
	self.ContactorsActive = active
end

function SYSTEM:SetTISUBlockActive(active)
	self.TISUActive = active
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
end

Trolleybus_System.RegisterSystem("TISU",SYSTEM)
SYSTEM = nil