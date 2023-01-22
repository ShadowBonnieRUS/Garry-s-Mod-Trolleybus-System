-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

SYSTEM.MotorCompressorSpeed = 14

SYSTEM.BrakePedalStart = 2
SYSTEM.BrakePedalEnd = 3

function SYSTEM:Initialize()
	self.MCActive = false
	self.MCAirActive = false
end

function SYSTEM:Think(dt)
	if self.MCActive and self:ShouldBeMotorCompressorActive() then
		if !self:GetNWVar("MCActive") then
			self:SetNWVar("MCActive",true)

			self.MCAirActive = true
		end

		local toadd = self.MotorCompressorSpeed*dt
		local receivers = {}

		for k,v in ipairs(self.Receivers) do
			if self:GetAir(k)<v.MCStop then receivers[#receivers+1] = k end
		end

		for k,v in ipairs(receivers) do
			self:SetAir(v,math.min(self.Receivers[v].Size,self:GetAir(v)+toadd/#receivers))
		end
	elseif self:GetNWVar("MCActive") then
		if !self:ShouldBeMotorCompressorActive() then
			self.MCAirActive = false
		end
		
		self:SetNWVar("MCActive",false)
	end

	local C = self.Trolleybus.Controls
	local brakefr = self:GetBrakeControlFraction() or math.Remap(math.Clamp(C.BrakePedal,self.BrakePedalStart,self.BrakePedalEnd),self.BrakePedalStart,self.BrakePedalEnd,0,1)

	for k,v in ipairs(self.BrakeChambers) do
		local cur,dest = self:GetBrake(k),v.Size*brakefr
		
		if dest!=cur then
			if cur>dest then
				self:SetBrake(k,dest)
			else
				local air = math.min(self:GetAir(v.BrakeReceiver),dest-cur)

				if air>0 then
					self:SetAir(v.BrakeReceiver,self:GetAir(v.BrakeReceiver)-air)
					self:SetBrake(k,cur+air)
				end
			end
		end
	end
end

function SYSTEM:ShouldBeMotorCompressorActive()
	for k,v in ipairs(self.Receivers) do
		local ignore = v.ShouldBeIgnoredByMC and v.ShouldBeIgnoredByMC(self.Trolleybus)

		if !ignore and self:GetAir(k)<(self.MCAirActive and v.MCStop or v.MCStart) then
			return true
		end
	end

	return false
end

function SYSTEM:GetWheelsBrake(speed,isdrive)
	for k,v in ipairs(self.BrakeChambers) do
		if self:GetBrake(k)>0 and v.DriveWheelsBrake==isdrive then
			local brake = v.BrakeDeceleration*self:GetBrakePressure(k)/self.Receivers[v.BrakeReceiver].Size
		
			speed = speed>0 and math.max(0,speed-brake*self.Trolleybus.DeltaTime) or math.min(0,speed+brake*self.Trolleybus.DeltaTime)
			if speed==0 then return 0 end
		end
	end
	
	return speed
end

function SYSTEM:GetBrakeControlFraction() end

function SYSTEM:SetMotorCompressorActive(active)
	self.MCActive = active
end

function SYSTEM:SetAir(receiver,air)
	if self.Receivers[receiver] then
		self:SetNWVar("Air"..receiver,air)
	end
end

function SYSTEM:SetBrake(chamber,brake)
	if self.BrakeChambers[chamber] then
		self:SetNWVar("Brake"..chamber,brake)
	end
end

function SYSTEM:CanDoorsMove(name)
	for k,v in ipairs(self.Receivers) do
		if v.PneumaticDoors and v.PneumaticDoors[name] and self:GetAir(k)<v.PneumaticDoors[name][1] then
			return false
		end
	end
end

function SYSTEM:OnDoorMove(name,opened)
	if self.Trolleybus:GetNWVar("MoveDoorHand."..name) then return end

	for k,v in ipairs(self.Receivers) do
		if v.PneumaticDoors and v.PneumaticDoors[name] then
			self:SetAir(k,math.max(0,self:GetAir(k)-v.PneumaticDoors[name][3]))
		end
	end
end

Trolleybus_System.RegisterSystem("Pneumatic",SYSTEM)
SYSTEM = nil