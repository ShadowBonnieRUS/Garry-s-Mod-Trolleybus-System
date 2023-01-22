-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.Start1Resistance = 10
SYSTEM.Start2Resistance = 0.1

function SYSTEM:Initialize()
	self:SetEngineAmperage(0)
	self.LastResistance = math.huge
end

function SYSTEM:SetEngineAmperage(amperage)
	self:SetNWVar("EngineAmperage",amperage)
end

function SYSTEM:Think(dt)
	local bus = self.Trolleybus
	local C = bus.Controls
	
	self.StartActive = bus:GetReverseState()!=0 and C.StartPedal
	self.BrakeActive = bus:GetReverseState()!=0 and C.BrakePedal>0
	
	local br = self.BrakeActive and C.BrakePedal or 0
	
	self:SetNWVar("EngineAsGenerator",self.BrakeActive)
	
	if self:IsEngineAsGenerator() then
		self.EngineBrakeFraction = br
	end
end

function SYSTEM:GetResistance()
	local resistance = math.huge

	if self.StartActive and self.StartActive>0 then
		local engamp = self:GetNWVar("EngineAmperage",0)
		local res = math.Remap(self.StartActive,0,1,self.Start1Resistance,self.Start2Resistance)
		local minres = self.LastResistance*engamp/450

		resistance = minres!=minres and self.Start1Resistance or math.max(res,minres)
	end

	self.LastResistance = resistance
	return resistance
end

function SYSTEM:GetEngineBrakeFraction()
	return self.EngineBrakeFraction or 0
end

function SYSTEM:ControlPedals(ply,dt,C,OC)
	if Trolleybus_System.GetPlayerSetting(ply,"UseExternalPedals") then
		local startpedal = ply.TrolleybusDeviceInputData_startpedal
		local brakepedal = ply.TrolleybusDeviceInputData_brakepedal
	
		C.StartPedal = C.BrakePedal>0 and 0 or startpedal or C.StartPedal
		C.BrakePedal = brakepedal or C.BrakePedal
	else
		if C.FullBrake then
			C.StartPedal = 0
			C.BrakePedal = 1
		else
			if C.Reset then
				if !OC.Reset then
					C.StartPedal = 0
					C.BrakePedal = 0
				end
			elseif C.SActive then
				C.StartPedal = 0
				
				C.BrakePedal = math.min(1,C.BrakePedal+dt)
			elseif C.WActive then
				C.BrakePedal = 0
				
				C.StartPedal = math.min(1,C.StartPedal+dt)
			end
		end
	end
end

Trolleybus_System.RegisterSystem("TRSU",SYSTEM)
SYSTEM = nil