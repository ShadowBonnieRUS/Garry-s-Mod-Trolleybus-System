-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base_trailer")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.InteriorLightAmperage = 9.3
ENT.ProfileLightsAmperage = 7
ENT.ScheduleLightAmperage = 5.6
ENT.TurnSignalLightsAmperage = 14
ENT.RearLightAmperage = 7

ENT.Mass = 14660/3
ENT.WheelMaxTurn = -15

ENT.TrolleyPoleCatcherPos = Vector(-128.51,0,-5.52)
ENT.TrolleyPoleCatcherAng = Angle(0,180,0)
ENT.TrolleyPoleCatcherDist = 15.57

ENT.WheelsData = {
	{
		Drive = false,
		Turn = true,
		Wheels = {
			{Type = "ziu6205",	Pos = Vector(-31,42,-41),	Right = false,	Height = 3,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 5},
			{Type = "ziu6205",	Pos = Vector(-31,-42,-41),	Right = true,	Height = 3,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 5},
		},
	},
}

function ENT:Think()
	BaseClass.Think(self)
	
	local bus = self:GetTrolleybus()
	
	if IsValid(bus) and self.SystemsLoaded then
		self:SetNWVar("LowPower",self.ElLowCircuit:HasPower())
		self:SetNWVar("LowVoltage",self.ElLowCircuit:GetVoltage())

		local interiorlight = (self.InteriorLight1A+self.InteriorLight2A)/2
		self:SetInteriorLight(interiorlight/self.InteriorLightAmperage)

		self:SetEmergencySignal(bus:IsPriborButtonActive("emergency"))

		if !bus:IsPriborButtonActive("emergency") then
			self:SetTurnSignal(self.TurnLSignal and 1 or self.TurnRSignal and 2 or 0)
		end

		self:SetScheduleLight(bus:ButtonIsDown("profilelightstop") and self:GetProfileLights() or 0)
	end
	
	return true
end

function ENT:CalcElectricCurrentUsage()
	return self:GetTrolleybus().ElCircuit:GetAmperage()
end