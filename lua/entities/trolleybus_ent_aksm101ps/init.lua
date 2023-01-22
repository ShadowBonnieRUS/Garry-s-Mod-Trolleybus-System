-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.InteriorLightAmperage = 9.2
ENT.CabineLightAmperage = 2.75
ENT.HeadLightsAmperage = 13.75
ENT.ProfileLightsAmperage = 6.875
ENT.ScheduleLightAmperage = 5.5
ENT.TurnSignalLightsAmperage = 13.75
ENT.RearLightAmperage = 6.875

function ENT:PreInitialize(ply,tr)
	self:SetPos(tr.HitPos+Vector(0,0,60))
end

function ENT:Initialize()
	BaseClass.Initialize(self)
	
	self:InitializeHighVoltageCircuit()
	self:InitializeLowVoltageCircuit()

	self:ToggleButton("handbrake",true)
end

function ENT:InitializeHighVoltageCircuit()
	self.ElCircuit = Trolleybus_System.CreateElectricCircuit()
	self.ElCircuit:BuildFromData({
		{node1name = "avnode",node2name = "avnode2",
			{name = "avkey",State = function() return self:ButtonIsDown("main_switch") end},
			{name = "rksu",Resistance = function() return self:GetSystem("RKSU"):GetResistance() end},
			{name = "engine",Resistance = function() return self:GetSystem("Engine"):GetResistance() end,OnUpdate = function(amp,volt,power)
				self:GetSystem("Engine"):SetAmperage(math.min(amp,500))

				if math.abs(amp)>500 and self:GetSpawnSetting("mainswitchdisabling") then
					self:DisableMainSwitchByHighCurrent()
				end
			end},
		},
		{node1name = "voltconvnode",node2name = "voltconvnode2",
			{name = "voltconvkey",State = function() return self:ButtonIsDown("voltageconverter") end},
			{name = "voltconvkey2",State = function() return self:ButtonIsDown("interior_heater_power_voltageconverter") end},
			{name = "voltconv",Resistance = 100,OnUpdate = function(amp,volt,power)
				self:GetSystem("StaticVoltageConverter"):SetActive(power)
				self:GetSystem("AccumulatorBattery"):SetCircuitUsageDisabled(power)
			end},
		},
		{node1name = "cabineheaternode",node2name = "cabineheaternode2",
			{node1name = "cabineheater2node",node2name = "cabineheater2node2",
				{name = "cabineheater2key",State = function() return self:IsPriborButtonActive("cabineheater2") end},
				{name = "cabineheater2",Resistance = 40},
			},
			{name = "cabineheater1key",State = function() return self:IsPriborButtonActive("cabineheater1") end},
			{name = "cabineheater1",Resistance = 40},
		},
		{node1name = "cabineheaterventnode",node2name = "cabineheaterventnode2",
			{name = "cabineheaterventkey",State = function() return self:IsPriborButtonActive("cabinevent") end},
			{name = "cabineheatervent",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Heater"):SetVentActive(power) end},
		},
		{node1name = "interiorheaternode",node2name = "interiorheaternode2",
			{name = "interiorheaterkey",State = function() return self:ButtonIsDown("interior_heater_power_voltageconverter") end},
			{node1name = "interiorheater2node",node2name = "interiorheater2node2",
				{name = "interiorheater2key",State = function() return self:IsPriborButtonActive("interiorheater2") end},
				{name = "interiorheater2",Resistance = 60},
			},
			{name = "interiorheater1key",State = function() return self:IsPriborButtonActive("interiorheater1") end},
			{name = "interiorheater1",Resistance = 60},
		},
		{node1name = "interiorheaterventnode",node2name = "interiorheaterventnode2",
			{node1name = "interiorheatervent2node",node2name = "interiorheatervent2node2",
				{name = "interiorheatervent2key",State = function() return self:IsPriborButtonActive("interiorvent2") end},
				{name = "interiorheatervent2",Resistance = 100},
			},
			{name = "interiorheatervent1key",State = function() return self:IsPriborButtonActive("interiorvent1") end},
			{name = "interiorheatervent1",Resistance = 100},
		},
		{node1name = "motorcompnode",node2name = "motorcompnode2",
			{name = "motorcompkey",State = function() return self:ButtonIsDown("compressor_high") and self:IsPriborButtonActive("compressor") and self:GetSystem("Pneumatic"):ShouldBeMotorCompressorActive() end},
			{name = "motorcomp",Resistance = 100,OnUpdate = function(amp,volt,power) self:GetSystem("Pneumatic"):SetMotorCompressorActive(power) end},
		},
		{name = "powerlamp",Resistance = 1000,OnUpdate = function(amp,volt,power) self:SetNWVar("PowerLamp",power) end},
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
			{name = "hydroboosterkey",State = function() return self:ButtonIsDown("hydrobooster") end},
			{name = "hydrobooster",Resistance = 5,OnUpdate = function(amp,volt,power) self:GetSystem("HydraulicBooster"):SetAmperage(math.abs(amp)) end},
		},
		{node1name = "interiorlightnode",node2name = "interiorlightnode2",
			{node1name = "interiorlight2node",node2name = "interiorlight2node2",
				{name = "interiorlight2key",State = function() return self:IsPriborButtonActive("interiorlight2") end},
				{name = "interiorlight2",Resistance = 3,OnUpdate = function(amp,volt,power)
					self.InteriorLight2A = amp
					self:SetNWVar("InteriorLightActive2",power)
				end},
			},
			{name = "interiorlight1key",State = function() return self:IsPriborButtonActive("interiorlight1") end},
			{name = "interiorlight1",Resistance = 3,OnUpdate = function(amp,volt,power)
				self.InteriorLight1A = amp
				self:SetNWVar("InteriorLightActive1",power)
			end},
		},
		{node1name = "headlightsnode",node2name = "headlightsnode2",
			{name = "headlightskey",State = function() return self:IsPriborButtonActive("headlights") end},
			{name = "headlights",Resistance = 2,OnUpdate = function(amp,volt,power) self:SetHeadLights(amp/self.HeadLightsAmperage) end},
		},
		{node1name = "priblightsnode",node2name = "priblightsnode2",
			{name = "priblightskey",State = function() return self:IsPriborButtonActive("priborslight") end},
			{name = "priblights",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("PribLights",power) end},
		},
		{node1name = "profilelightsnode",node2name = "profilelightsnode2",
			{name = "profilelightskey",State = function() return self:IsPriborButtonActive("profilelights") end},
			{name = "profilelights",Resistance = 4,OnUpdate = function(amp,volt,power) self:SetProfileLights(amp/self.ProfileLightsAmperage) end},
		},
		{node1name = "cabinelightnode",node2name = "cabinelightnode2",
			{name = "cabinelightkey",State = function() return self:IsPriborButtonActive("cabinelight") end},
			{name = "cabinelight",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetCabineLight(amp/self.CabineLightAmperage) end},
		},
		{node1name = "doorlight1node",node2name = "doorlight1node2",
			{name = "doorlight1key",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door1") end},
			{name = "doorlight1",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("Door1Light",power) end},
		},
		{node1name = "doorlight2node",node2name = "doorlight2node2",
			{name = "doorlight2key",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door2") end},
			{name = "doorlight2",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("Door2Light",power) end},
		},
		{node1name = "doorlight3node",node2name = "doorlight3node2",
			{name = "doorlight3key",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door3") end},
			{name = "doorlight3",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("Door3Light",power) end},
		},
		{node1name = "turnsignalnode",node2name = "turnsignalnode2",
			{node1name = "turnlsignalnode",node2name = "turnlsignalnode2",
				{name = "turnlsignalkey",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("turnsignal")==1 end},
				{name = "turnlsignal",Resistance = 4,OnUpdate = function(amp,volt,power) self.TurnLSignal = power end},
			},
			{name = "turnrsignalkey",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("turnsignal")==-1 end},
			{name = "turnrsignal",Resistance = 4,OnUpdate = function(amp,volt,power) self.TurnRSignal = power end},
			true,
			{name = "turnsignal",OnUpdate = function(amp,volt,power) self:SetTurnSignalLights(amp/self.TurnSignalLightsAmperage) end},
		},
		{node1name = "buzzernode",node2name = "buzzernode2",
			{name = "buzzerkey",State = function() return self:IsPriborButtonActive("buzzer") and !self:GetSystem("StaticVoltageConverter"):IsActive() end},
			{name = "buzzer",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer"):SetActive(power) end},
		},
		{node1name = "contactorsnode",node2name = "contactorsnode2",
			{name = "contactorsvukey",State = function() return self:IsPriborButtonActive("vu") end},
			{node1name = "contactors2node",node2name = "contactors2node2",
				{name = "contactorssvckey",State = function() return self:GetSystem("StaticVoltageConverter"):IsActive() end},
			},
			{name = "contactorsseqkey",State = function() return self:IsPriborButtonActive("sequence") end},
			true,
			{name = "contactors",Resistance = 5,OnUpdate = function(amp,volt,power) self:GetSystem("RKSU"):SetContactorsActive(power) end},
		},
		{node1name = "rearlightnode",node2name = "rearlightnode2",
			{name = "rearlightkey",State = function() return self:GetRearLights()>0 end},
			{name = "rearlight",Resistance = 4,OnUpdate = function(amp,volt,power) self:SetRearLight(amp/self.RearLightAmperage) end},
		},
		{node1name = "schedulelightnode",node2name = "schedulelightnode2",
			{name = "schedulelightkey",State = function() return self:IsPriborButtonActive("window_washer") end},
			{name = "schedulelight",Resistance = 5,OnUpdate = function(amp,volt,power) self:SetScheduleLight(amp/self.ScheduleLightAmperage) end},
		},
		{node1name = "wipersnode",node2name = "wipersnode2",
			{node1name = "wipers2node",node2name = "wipers2node2",
				{name = "wipers2key",State = function() return self:IsPriborButtonActive("wipers_right") end},
				{name = "wipers2",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("WipersRight",power) end},
			},
			{name = "wipers1key",State = function() return self:IsPriborButtonActive("wipers_left") end},
			{name = "wipers1",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("WipersLeft",power) end},
		},
		{node1name = "polesremovalnode",node2name = "polesremovalnode2",
			{name = "polesremovalkey",State = function() return self:IsPriborButtonActive("polecatchers_control") end},
			{name = "polesremoval",Resistance = 5,OnUpdate = function(amp,volt,power)
				if power!=self:GetPoleCatchingActive() then
					self:SetPoleCatchingActive(power)
					self:SetPoleCatchingFraction(0,false)
					self:SetPoleCatchingFraction(0,true)
				end
			end},
		},
		{node1name = "priborpanelnode",node2name = "priborpanelnode2",
			BuildButtonElement("interiorlight1"),
			BuildButtonElement("interiorlight2"),
			BuildButtonElement("headlights"),
			BuildButtonElement("priborslight"),
			BuildButtonElement("profilelights"),
			BuildButtonElement("cabinelight"),
			BuildButtonElement("doorlights"),
			BuildButtonElement("vu"),
			BuildButtonElement("compressor"),
			BuildButtonElement("buzzer"),
			BuildButtonElement("sequence"),
			BuildButtonElement("cabinevent"),
			BuildButtonElement("interiorvent1"),
			BuildButtonElement("interiorvent2"),
			BuildButtonElement("opendoor1"),
			BuildButtonElement("opendoor2"),
			BuildButtonElement("opendoor3"),
			BuildButtonElement("cabineheater"),
			BuildButtonElement("cabineheater2"),
			BuildButtonElement("interiorheater1"),
			BuildButtonElement("interiorheater2"),
			BuildButtonElement("window_washer"),
			BuildButtonElement("wipers_left"),
			BuildButtonElement("wipers_right"),
			BuildButtonElement("polecatchers_control"),
			BuildButtonElement("poles_removal",{-1,-1},"poles_removal_left"),
			BuildButtonElement("poles_removal",{1,1},"poles_removal_right"),
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

ENT.Mass = 10400
ENT.WheelMaxTurn = 45

ENT.TrolleyPoleCatcherPos = Vector(-222.88,0,-3.54)
ENT.TrolleyPoleCatcherAng = Angle(0,180,0)
ENT.TrolleyPoleCatcherDist = 15.64

ENT.AllowKeyboardReverseChange = false
ENT.AllowKeyboardHandbrakeToggle = false

ENT.WheelsData = {
	{
		Drive = false,
		Turn = true,
		Wheels = {
			{Type = "aksm101ps",	Pos = Vector(135.32,41.63,-38.44),	Right = false,	Height = 4.5,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 4},
			{Type = "aksm101ps",	Pos = Vector(135.32,-41.63,-38.44),	Right = true,	Height = 4,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 4},
		},
	},
	{
		Drive = true,
		Turn = false,
		Wheels = {
			{Type = "aksm101ps_rear",	Pos = Vector(-92.58,36.23,-38.55),	Right = false,	Height = 5.5,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 4},
			{Type = "aksm101ps_rear",	Pos = Vector(-92.58,-36.23,-38.55),	Right = true,	Height = 5,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 4},
		},
	},
}

function ENT:IsPriborButtonActive(btn)
	return self.PriborPanel[btn]
end

function ENT:PreDriveWheelsRotationUpdate(group,data,rotdata)
	BaseClass.PreDriveWheelsRotationUpdate(self,group,data,rotdata)
	
	self:GetSystem("Reductor"):SetRotation(self:GetSystem("Engine"):GetRotation())
end

function ENT:PostDriveWheelsRotationUpdate(group,data,rotdata)
	BaseClass.PostDriveWheelsRotationUpdate(self,group,data,rotdata)
	
	self:GetSystem("Engine"):SetRotation(self:GetSystem("Reductor"):GetRotation())
end

function ENT:Think()
	BaseClass.Think(self)
	
	if self:GetPoleCatchingActive() then
		if self:IsPriborButtonActive("poles_removal_left") then
			if self:GetPoleState(false)==0 then self:SetPoleState(4,false) end
			
			if self:GetPoleCatchingFraction(false)<1 then
				self:SetPoleCatchingFraction(math.min(1,self:GetPoleCatchingFraction(false)+self.DeltaTime/3),false)
			end
		elseif self:IsPriborButtonActive("poles_removal_right") then
			if self:GetPoleState(true)==0 then self:SetPoleState(4,true) end
			
			if self:GetPoleCatchingFraction(true)<1 then
				self:SetPoleCatchingFraction(math.min(1,self:GetPoleCatchingFraction(true)+self.DeltaTime/3),true)
			end
		end

		self:SetNWVar("PoleCatchingLeft",self:IsPriborButtonActive("poles_removal_left"))
		self:SetNWVar("PoleCatchingRight",self:IsPriborButtonActive("poles_removal_right"))
	end
	
	if self.SystemsLoaded then
		self.ElCircuit:Update(self:GetHighVoltage())

		self:SetNWVar("LowPower",self.ElLowCircuit:HasPower())
		self:SetNWVar("LowVoltage",self.ElLowCircuit:GetVoltage())

		local cabineheater1 = self.ElCircuit:GetElement("cabineheater1"):HasPower()
		local cabineheater2 = self.ElCircuit:GetElement("cabineheater2"):HasPower()
		self:GetSystem("Heater"):SetState(cabineheater1 and cabineheater2 and 2 or (cabineheater1 or cabineheater2) and 1 or 0)

		local interiorlight = (self.InteriorLight1A+self.InteriorLight2A)/2
		self:SetInteriorLight(interiorlight/self.InteriorLightAmperage)

		self:SetEmergencySignal(self:IsPriborButtonActive("emergency"))

		if !self:IsPriborButtonActive("emergency") then
			self:SetTurnSignal(self.TurnLSignal and 1 or self.TurnRSignal and 2 or 0)
		end

		self:GetSystem("RKSU"):SetEngineAmperage(self:GetSystem("Engine"):GetAmperage())
		self:GetSystem("Engine"):SetAsGenerator(self:GetSystem("RKSU"):IsEngineAsGenerator())
		self:GetSystem("Engine"):SetBrakeFraction(self:GetSystem("RKSU"):GetEngineBrakeFraction())
		self:GetSystem("Engine"):SetInverted(self:GetReverseState()==-1)
	end
	
	return true
end

function ENT:CalcElectricCurrentUsage()
	return self.ElCircuit:GetAmperage()
end

function ENT:OnReloaded()
	self:InitializeHighVoltageCircuit()
	self:InitializeLowVoltageCircuit()
end

function ENT:DisableMainSwitchByHighCurrent()
	if self:ButtonIsDown("main_switch") then
		self:ToggleButton("main_switch",false)

		local pos = Vector(166.07,39.97,36.58)
		Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/aksm101ps/av8a_off_highcurrent.ogg",500,1,nil,pos)
		Trolleybus_System.ElectricSpark(self:LocalToWorld(pos))
	end
end