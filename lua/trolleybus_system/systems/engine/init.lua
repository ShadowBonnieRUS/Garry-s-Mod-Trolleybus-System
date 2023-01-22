-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.RotationAmperageAcceleration = 120*1/75
SYSTEM.RotationSpeedDeceleration = 0.03
SYSTEM.ResistanceRotationDeceleration = 0.002

SYSTEM.GeneratorRotationPenalty = 0
SYSTEM.GeneratorRotationAmperage = 360*3.44/200
SYSTEM.GeneratorAmperageDeceleration = 360*4/200

function SYSTEM:Initialize()
	self.IncomeAmperage = 0
	self.BrakeFraction = 1
end

function SYSTEM:SetAmperage(amperage)
	self.IncomeAmperage = amperage
end

function SYSTEM:SetAsGenerator(gen)
	self.AsGenerator = gen
end

function SYSTEM:SetBrakeFraction(fr)
	self.BrakeFraction = fr
end

function SYSTEM:SetInverted(inverted)
	self.Inverted = inverted
end

function SYSTEM:SetRotation(rotation)
	self:SetNWVar("Rotation",rotation)
end

function SYSTEM:GetResistance()
	return math.abs(self:GetRotation())*self.ResistanceRotationDeceleration
end

function SYSTEM:PreDriveWheelsRotationUpdate(group,data,rotdata)
	local dt = FrameTime()
	local rotation = self:GetRotation()
	
	if self.AsGenerator then
		local rot = math.max(0,math.abs(rotation)*self.BrakeFraction-self.GeneratorRotationPenalty)
		local amp = rot/self.GeneratorRotationAmperage
		local dec = amp*self.GeneratorAmperageDeceleration
		
		self:SetRotation(rotation>0 and math.max(0,rotation-dec*dt) or math.min(0,rotation+dec*dt))
		self:SetNWVar("Amperage",-amp)
	else
		local amperage = self.IncomeAmperage
		if self.Inverted then amperage = -amperage end
		
		local add = 0
		if amperage>0 then
			add = math.max(0,amperage*self.RotationAmperageAcceleration-math.abs(rotation)*self.RotationSpeedDeceleration)
		else
			add = math.min(0,amperage*self.RotationAmperageAcceleration+math.abs(rotation)*self.RotationSpeedDeceleration)
		end

		self:SetRotation(rotation+add*dt)
		self:SetNWVar("Amperage",math.abs(amperage))
	end
end

Trolleybus_System.RegisterSystem("Engine",SYSTEM)
SYSTEM = nil