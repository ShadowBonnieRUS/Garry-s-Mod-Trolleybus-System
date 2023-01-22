-- Copyright © Platunov I. M., 2020 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base_trailer")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.Mass = 9333

ENT.WheelMaxTurn = 0

ENT.TrolleyPoleCatcherPos = Vector(-370,0,-16.76)
ENT.TrolleyPoleCatcherAng = Angle(0,180,0)
ENT.TrolleyPoleCatcherDist = 17.54

ENT.WheelsData = {
	{
		Drive = false,
		Turn = false,
		Wheels = {
			{Type = "aksm333_rear",	Pos = Vector(-228.5,37,-42),	Right = false,	Height = 5,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 9},
			{Type = "aksm333_rear",	Pos = Vector(-228.5,-37,-42),	Right = true,	Height = 5,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 9,	KneelingMul = 0.7},
		},
	},
}

function ENT:CalcElectricCurrentUsage()
	return self:GetTrolleybus().ElCircuit:GetAmperage()
end