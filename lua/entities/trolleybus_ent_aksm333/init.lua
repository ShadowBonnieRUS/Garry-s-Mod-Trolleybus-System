-- Copyright © Platunov I. M., 2020 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.InteriorLightAmperage = 7
ENT.CabineLightAmperage = 1.4
ENT.HeadLightsAmperage = 7
ENT.ProfileLightsAmperage = 4.67
ENT.ScheduleLightAmperage = 4.67
ENT.TurnSignalLightsAmperage = 9.33
ENT.RearLightAmperage = 3.5

function ENT:PreInitialize(ply,tr)
	self:SetPos(tr.HitPos+Vector(0,0,64))
end

function ENT:Initialize()
	BaseClass.Initialize(self)
	
	self:InitializeHighVoltageCircuit()
	self:InitializeLowVoltageCircuit()

	self:ToggleButton("handbrake",true)
	self.KneelingProgress = 0
end

function ENT:InitializeHighVoltageCircuit()
	self.ElCircuit = Trolleybus_System.CreateElectricCircuit()
	self.ElCircuit:BuildFromData({
		{node1name = "keynode",node2name = "keynode2",
			{name = "keykey",State = function() return self:ButtonIsDown("key") end},
			{name = "550v",State = function() return self:ButtonIsDown("550v") end},
			{name = "trsu",Resistance = function() return self:GetSystem("TRSU"):GetResistance() end},
			{name = "engine",Resistance = function() return self:GetSystem("Engine"):GetResistance() end,OnUpdate = function(amp,volt,power) self:GetSystem("Engine"):SetAmperage(math.min(amp,500)) end},
		},
		{node1name = "voltconvnode",node2name = "voltconvnode2",
			{name = "voltconvkey",State = function() return self:ButtonIsDown("550v") end},
			{name = "voltconv",Resistance = 100,OnUpdate = function(amp,volt,power)
				self:GetSystem("StaticVoltageConverter"):SetActive(power)
				self:GetSystem("AccumulatorBattery"):SetCircuitUsageDisabled(power)
			end},
		},
		{node1name = "cabineheaternode",node2name = "cabineheaternode2",
			{name = "cabineheaterkey",State = function() return self:IsPriborButtonActive("cabineheat") end},
			{name = "cabineheater",Resistance = 20,OnUpdate = function(amp,volt,power) self:GetSystem("Heater"):SetState(power and 2 or 0) end},
		},
		{node1name = "cabineheaterventnode",node2name = "cabineheaterventnode2",
			{name = "cabineheaterventkey",State = function() return self:IsPriborButtonActive("cabinevent") end},
			{name = "cabineheatervent",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Heater"):SetVentActive(power) end},
		},
		{node1name = "interiorheaternode",node2name = "interiorheaternode2",
			{name = "interiorheaterkey",State = function() return self:IsPriborButtonActive("interiorheater") end},
			{name = "interiorheater",Resistance = 20},
		},
		{node1name = "interiorheaterventnode",node2name = "interiorheaterventnode2",
			{name = "interiorheaterventkey",State = function() return self:IsPriborButtonActive("intheatervent") end},
			{name = "interiorheatervent",Resistance = 50},
		},
		{node1name = "motorcompnode",node2name = "motorcompnode2",
			{name = "motorcompkey",State = function() return self:ButtonIsDown("converter") and self:ButtonIsDown("compressor") and self:GetSystem("Pneumatic"):ShouldBeMotorCompressorActive() end},
			{name = "motorcomp",Resistance = 100,OnUpdate = function(amp,volt,power) self:GetSystem("Pneumatic"):SetMotorCompressorActive(power) end},
		},
		{name = "powerindicator",Resistance = 1000},
	})
end

function ENT:InitializeLowVoltageCircuit()
	self.PriborPanel = {}

	local function BuildButtonElement(btn,multiv,as)
		local sbtn = as or btn

		return {
			node1name = "btn_"..sbtn.."_node1",node2name = "btn_"..sbtn.."_node2",
			{name = "btn_"..sbtn,
				State = function() return multiv and self:GetMultiButton(btn)>=multiv[1] and self:GetMultiButton(btn)<=multiv[2] or !multiv and self:ButtonIsDown(btn) end,
				OnUpdate = function(amp,volt,power) self.PriborPanel[sbtn] = power end,
			},
			{name = "btnr_"..sbtn,Resistance = 5}
		}
	end

	self.ElLowCircuit = Trolleybus_System.CreateElectricCircuit()
	self.ElLowCircuit:BuildFromData({
		{node1name = "batterychargenode",node2name = "batterychargenode2",
			{name = "batterychargekey",State = function() return self:GetSystem("StaticVoltageConverter"):IsActive() end},
			{name = "batterycharge",Resistance = function()
				return 1/(1-self:GetSystem("AccumulatorBattery"):GetChargePercent())
			end,OnUpdate = function(amp,volt,power)
				self:GetSystem("AccumulatorBattery"):SetCharging(power and amp)
			end},
		},
		{node1name = "hydroboosternode",node2name = "hydroboosternode2",
			{name = "hydroboosterkey",State = function() return self:IsPriborButtonActive("hydraulic_booster") end},
			{name = "hydrobooster",Resistance = 5,OnUpdate = function(amp,volt,power) self:GetSystem("HydraulicBooster"):SetAmperage(math.abs(amp)) end},
		},
		{node1name = "interiorlightnode",node2name = "interiorlightnode2",
			{name = "interiorlightkey",State = function() return self:IsPriborButtonActive("interiorlight") end},
			{name = "interiorlight",Resistance = 2,OnUpdate = function(amp,volt,power) self:SetInteriorLight(amp/self.InteriorLightAmperage) self:GetTrailer():SetInteriorLight(amp/self.InteriorLightAmperage) end},
		},
		{node1name = "headlightsnode",node2name = "headlightsnode2",
			{name = "headlightskey",State = function() return self:IsPriborButtonActive("headlights") end},
			{name = "headlights",Resistance = 2,OnUpdate = function(amp,volt,power) self:SetHeadLights(amp/self.HeadLightsAmperage) end},
		},
		{node1name = "profilelightsnode",node2name = "profilelightsnode2",
			{name = "profilelightskey",State = function() return self:IsPriborButtonActive("profilelights") end},
			{name = "profilelights",Resistance = 3,OnUpdate = function(amp,volt,power) self:SetProfileLights(amp/self.ProfileLightsAmperage)  self:GetTrailer():SetProfileLights(amp/self.ProfileLightsAmperage) end},
		},
		{node1name = "cabinelightnode",node2name = "cabinelightnode2",
			{name = "cabinelightkey",State = function() return self:IsPriborButtonActive("cabinelight") end},
			{name = "cabinelight",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetCabineLight(amp/self.CabineLightAmperage) end},
		},
		{node1name = "doorlight1node",node2name = "doorlight1node2",
			{name = "doorlight1key",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door2") end},
			{name = "doorlight1",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("Door1Light",power) end},
		},
		{node1name = "doorlight2node",node2name = "doorlight2node2",
			{name = "doorlight2key",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door3") end},
			{name = "doorlight2",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("Door2Light",power) end},
		},
		{node1name = "doorlight3node",node2name = "doorlight3node2",
			{name = "doorlight3key",State = function() return self:IsPriborButtonActive("doorlights") and self:GetTrailer():DoorIsOpened("door4") end},
			{name = "doorlight3",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetTrailer():SetNWVar("Door3Light",power) end},
		},
		{node1name = "doorlight4node",node2name = "doorlight4node2",
			{name = "doorlight4key",State = function() return self:IsPriborButtonActive("doorlights") and self:GetTrailer():DoorIsOpened("door5") end},
			{name = "doorlight4",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetTrailer():SetNWVar("Door4Light",power) end},
		},
		{node1name = "turnsignalnode",node2name = "turnsignalnode2",
			{node1name = "turnlsignalnode",node2name = "turnlsignalnode2",
				{name = "turnlsignalkey",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("guitar_left")==-1 end},
				{name = "turnlsignal",Resistance = 3,OnUpdate = function(amp,volt,power) self.TurnLSignal = power end},
			},
			{name = "turnrsignalkey",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("guitar_left")==1 end},
			{name = "turnrsignal",Resistance = 3,OnUpdate = function(amp,volt,power) self.TurnRSignal = power end},
			true,
			{name = "turnsignal",OnUpdate = function(amp,volt,power)
				self:SetTurnSignalLights(amp/self.TurnSignalLightsAmperage)
				self:GetTrailer():SetTurnSignalLights(amp/self.TurnSignalLightsAmperage)

				self:SetEmergencySignal(self:IsPriborButtonActive("emergency"))
				self:GetTrailer():SetEmergencySignal(self:IsPriborButtonActive("emergency"))
				self:SetTurnSignal(self.TurnLSignal and 1 or self.TurnRSignal and 2 or 0)
				self:GetTrailer():SetTurnSignal(self.TurnLSignal and 1 or self.TurnRSignal and 2 or 0)
			end},
		},
		{node1name = "buzzernode",node2name = "buzzernode2",
			{name = "buzzerkey",State = function() return self:IsPriborButtonActive("buzzer") and !self.ElCircuit:GetElement("powerindicator"):HasPower() end},
			{name = "buzzer",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer"):SetActive(power) end},
		},
		{node1name = "rearlightnode",node2name = "rearlightnode2",
			{name = "rearlightkey",State = function() return self:GetRearLights()>0 end},
			{name = "rearlight",Resistance = 4,OnUpdate = function(amp,volt,power) self:GetTrailer():SetRearLight(amp/self.RearLightAmperage) end},
		},
		{node1name = "schedulelightnode",node2name = "schedulelightnode2",
			{name = "schedulelightkey",State = function() return self:IsPriborButtonActive("schedulelight") end},
			{name = "schedulelight",Resistance = 3,OnUpdate = function(amp,volt,power) self:SetScheduleLight(amp/self.ScheduleLightAmperage) self:GetTrailer():SetScheduleLight(amp/self.ScheduleLightAmperage) end},
		},
		{node1name = "pneumaticpolecatchersnode",node2name = "pneumaticpolecatchersnode2",
			{name = "pneumaticpolecatcherskey",State = function() return self:IsPriborButtonActive("pneumaticpolecatchers") end},
			{name = "pneumaticpolecatchers",Resistance = 4,OnUpdate = function(amp,volt,power) self:SetPoleCatchingActive(power) end},
		},
		{node1name = "priborpanelnode",node2name = "priborpanelnode2",
			BuildButtonElement("hydraulic_booster"),
			BuildButtonElement("interiorlight"),
			BuildButtonElement("headlights"),
			BuildButtonElement("priborslight"),
			BuildButtonElement("profilelights"),
			BuildButtonElement("cabinelight"),
			BuildButtonElement("doorlights"),
			BuildButtonElement("buzzer"),
			BuildButtonElement("cabinevent"),
			BuildButtonElement("intheatervent"),
			BuildButtonElement("doorbtn1"),
			BuildButtonElement("doorbtn2"),
			BuildButtonElement("doorbtn3"),
			BuildButtonElement("doorbtn4"),
			BuildButtonElement("doorbtn5"),
			BuildButtonElement("doorbtn6"),
			BuildButtonElement("doorbtn7"),
			BuildButtonElement("doorbtn8"),
			BuildButtonElement("doorbtn9"),
			BuildButtonElement("doorbtn10"),
			BuildButtonElement("doorbtn11"),
			BuildButtonElement("doorbtn12"),
			BuildButtonElement("cabineheat"),
			BuildButtonElement("interiorheater"),
			BuildButtonElement("schedulelight"),
			BuildButtonElement("mirrorheat"),
			BuildButtonElement("airflow"),
			BuildButtonElement("pneumaticpolecatchers"),
			BuildButtonElement("stop_with_opened_doors"),
			{node1name = "btn_emergency_node1",node2name = "btn_emergency_node2",
				{name = "btn_emergency",
					State = function() return self.EmergencySignal end,
					OnUpdate = function(amp,volt,power) self.PriborPanel["emergency"] = power end,
				},
				{name = "btnr_emergency",Resistance = 5}
			},
			{Resistance = math.huge},
		},
		{name = "indicatorlamps",Resistance = 100},
	})

	self:GetSystem("AccumulatorBattery"):SetCircuit(self.ElLowCircuit)
	self:GetSystem("StaticVoltageConverter"):SetCircuit(self.ElLowCircuit)
end

ENT.Mass = 18666

ENT.WheelMaxTurn = 45
ENT.AllowKeyboardHandbrakeToggle = false
ENT.AllowKeyboardReverseChange = false

ENT.KneelingTime = 5

ENT.WheelsData = {
	{
		Drive = false,
		Turn = true,
		Wheels = {
			{Type = "aksm333",	Pos = Vector(253.5,45,-42),		Right = false,	Height = 6,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 8},
			{Type = "aksm333",	Pos = Vector(253.5,-45,-42),	Right = true,	Height = 6,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 8,		KneelingMul = 0.7},
		},
	},
	{
		Drive = true,
		Turn = false,
		Wheels = {
			{Type = "aksm333_rear",	Pos = Vector(16,37,-42),	Right = false,	Height = 2,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 8},
			{Type = "aksm333_rear",	Pos = Vector(16,-37,-42),	Right = true,	Height = 2,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 8,	KneelingMul = 0.4},
		},
	},
}

function ENT:PreDriveWheelsRotationUpdate(group,data,rotdata)
	BaseClass.PreDriveWheelsRotationUpdate(self,group,data,rotdata)
	
	self:GetSystem("Reductor"):SetRotation(self:GetSystem("Engine"):GetRotation())
end

function ENT:PostDriveWheelsRotationUpdate(group,data,rotdata)
	BaseClass.PostDriveWheelsRotationUpdate(self,group,data,rotdata)
	
	self:GetSystem("Engine"):SetRotation(self:GetSystem("Reductor"):GetRotation())
end

function ENT:IsPriborButtonActive(btn)
	return self.PriborPanel[btn]
end

function ENT:Think()
	BaseClass.Think(self)
	
	local kneelingdest = self:ButtonIsDown("kneeling") and 1 or 0
	if self.KneelingProgress!=kneelingdest then
		self.KneelingProgress = self.KneelingProgress<kneelingdest and math.min(self.KneelingProgress+1/self.KneelingTime*self.DeltaTime,kneelingdest) or math.max(self.KneelingProgress-1/self.KneelingTime*self.DeltaTime,kneelingdest)
		
		for k,v in ipairs(self.Wheels) do
			local data = self.WheelsData[k]
			
			for k2,v2 in ipairs(v.Wheels) do
				local dt = data.Wheels[k2]
				
				if dt.Right then
					Trolleybus_System.MultiplyWheelConstant(self,v2,1-(1-dt.KneelingMul)*self.KneelingProgress)
				end
			end
		end
		
		for k,v in ipairs(self:GetTrailer().Wheels) do
			local data = self:GetTrailer().WheelsData[k]
			
			for k2,v2 in ipairs(v.Wheels) do
				local dt = data.Wheels[k2]
				
				if dt.Right then
					Trolleybus_System.MultiplyWheelConstant(self:GetTrailer(),v2,1-(1-dt.KneelingMul)*self.KneelingProgress)
				end
			end
		end
	end
	
	if self.SystemsLoaded then
		self.ElCircuit:Update(self:GetHighVoltage())

		self:SetNWVar("LowPower",self.ElLowCircuit:HasPower())
		self:SetNWVar("LowVoltage",self.ElLowCircuit:GetVoltage())

		self:GetSystem("Handbrake"):SetActive(self:GetHandbrakeActive() or self:GetSystem("Pneumatic"):GetAir(1)<=500)
		self:GetSystem("TRSU"):SetEngineAmperage(self:GetSystem("Engine"):GetAmperage())

		self:GetSystem("Engine"):SetAsGenerator(self:GetSystem("TRSU"):IsEngineAsGenerator())
		self:GetSystem("Engine"):SetBrakeFraction(self:GetSystem("TRSU"):GetEngineBrakeFraction())
		self:GetSystem("Engine"):SetInverted(self:GetReverseState()==-1)
	end
	
	return true
end

function ENT:OnReloaded()
	self:InitializeHighVoltageCircuit()
	self:InitializeLowVoltageCircuit()
end