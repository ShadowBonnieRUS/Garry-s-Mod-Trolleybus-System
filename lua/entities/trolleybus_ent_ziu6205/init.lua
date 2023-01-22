-- Copyright © Platunov I. M., 2021 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.InteriorLightAmperage = 9.3
ENT.CabineLightAmperage = 2.8
ENT.HeadLightsAmperage = 14
ENT.ProfileLightsAmperage = 7
ENT.ScheduleLightAmperage = 5.6
ENT.TurnSignalLightsAmperage = 14
ENT.RoadTrainLightsAmperage = 7

function ENT:PreInitialize(ply,tr)
	self:SetPos(tr.HitPos+Vector(0,0,62))
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
			{name = "avkey",State = function() return self:ButtonIsDown("mainswitch1") end},
			{name = "av2key",State = function() return self:ButtonIsDown("mainswitch2") end},
			{name = "polarity",State = function() return self:GetReverseButton("polarity")!=0 end},
			{name = "tisu",Resistance = function() return self:GetSystem("TISU"):GetResistance() end},
			{name = "engine",Resistance = function() return self:GetSystem("Engine"):GetResistance() end,OnUpdate = function(amp,volt,power)
				self:GetSystem("Engine"):SetAmperage(math.min(amp,500))

				if math.abs(amp)>500 and self:GetSpawnSetting("mainswitchdisabling") then
					self:DisableMainSwitchesByHighCurrent()
				end
			end},
		},
		{node1name = "motorventnode",node2name = "motorventnode2",
			{name = "motorventkey",State = function() return self:ButtonIsDown("motorvent1") end},
			{name = "motorvent",Resistance = 100,OnUpdate = function(amp,volt,power)
				self:GetSystem("MotorVentilator"):SetActive(power)
				self:GetSystem("AccumulatorBattery"):SetCircuitUsageDisabled(power)
			end},
			{name = "motorventkey2",State = function() return self:ButtonIsDown("motorvent2") end},
		},
		{node1name = "switchpassrightnode",node2name = "switchpassrightnode2",
			{name = "switchpassright",State = function() return !self:IsPriborButtonActive("switchpassright") end},
			{node1name = "trailermotorventnode",node2name = "trailermotorventnode2",
				{name = "trailermotorventkey",State = function() return self:ButtonIsDown("trailermotorvent") end},
				{name = "trailermotorvent",Resistance = 100,OnUpdate = function(amp,volt,power)
					self:GetTrailer():GetSystem("MotorVentilator"):SetActive(power)
					self:GetTrailer():GetSystem("AccumulatorBattery"):SetCircuitUsageDisabled(power)
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
				{name = "cabineheaterventkey",State = function() return self:IsPriborButtonActive("cabineheatervent") end},
				{name = "cabineheatervent",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Heater"):SetVentActive(power) end},
			},
			{node1name = "interiorheaternode",node2name = "interiorheaternode2",
				{name = "interiorheaterkey",State = function() return self:ButtonIsDown("interiorheaterpower") and self:IsPriborButtonActive("interiorheater") end},
				{name = "interiorheater",Resistance = 60},
			},
			{node1name = "interiorheaterventnode",node2name = "interiorheaterventnode2",
				{name = "interiorheaterventkey",State = function() return self:IsPriborButtonActive("interiorheatervent") end},
				{name = "interiorheatervent",Resistance = 100,OnUpdate = function(amp,volt,power) self:GetSystem("InteriorHeater"):SetVentActive(power) end},
			},
			{name = "motorcompkey",State = function() return self:ButtonIsDown("compressorpower") and self:IsPriborButtonActive("compressor") and self:GetSystem("Pneumatic"):ShouldBeMotorCompressorActive() end},
			{name = "motorcomp",Resistance = 100,OnUpdate = function(amp,volt,power) self:GetSystem("Pneumatic"):SetMotorCompressorActive(power) end},
		},
		{node1name = "switchpassleftnode",node2name = "switchpassleftnode2",
			{name = "switchpassleft",State = function() return self:IsPriborButtonActive("switchpassleft") end},
			{name = "switchpassleftr",Resistance = 8},
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
			{name = "batterychargekey",State = function() return self:GetSystem("MotorVentilator"):IsActive() end},
			{name = "batterycharge",Resistance = function()
				return 1/(1-self:GetSystem("AccumulatorBattery"):GetChargePercent())
			end,OnUpdate = function(amp,volt,power)
				self:GetSystem("AccumulatorBattery"):SetCharging(power and amp)
			end},
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
			{name = "profilelightskey",State = function() return self:IsPriborButtonActive("profilelightstop") or self:IsPriborButtonActive("profilelightsbottom") end},
			{name = "profilelights",Resistance = 4,OnUpdate = function(amp,volt,power) self:SetProfileLights(amp/self.ProfileLightsAmperage) end},
		},
		{node1name = "roadtrainlightsnode",node2name = "roadtrainlightsnode2",
			{name = "roadtrainlightskey",State = function() return self:IsPriborButtonActive("roadtrainlights") end},
			{name = "roadtrainlights",Resistance = 4,OnUpdate = function(amp,volt,power) self:SetRoadTrainLights(amp/self.RoadTrainLightsAmperage) end},
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
			{name = "buzzerkey",State = function() return self:IsPriborButtonActive("buzzer") and !self:GetSystem("MotorVentilator"):IsActive() end},
			{name = "buzzer",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer"):SetActive(power) end},
		},
		{node1name = "wipersnode",node2name = "wipersnode2",
			{node1name = "wipers2node",node2name = "wipers2node2",
				{name = "wipers2key",State = function() return self:IsPriborButtonActive("rightwiper") end},
				{name = "wipers2",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("WipersRight",power) end},
			},
			{name = "wipers1key",State = function() return self:IsPriborButtonActive("leftwiper") end},
			{name = "wipers1",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("WipersLeft",power) end},
		},
		{node1name = "contactorsnode",node2name = "contactorsnode2",
			{name = "contactorskey",State = function() return self:IsPriborButtonActive("vu") end},
			{node1name = "contactors2node",node2name = "contactors2node2",
				{name = "contactorsmvkey",State = function() return self:GetSystem("MotorVentilator"):IsActive() end},
			},
			{name = "contactorsseqkey",State = function() return self:IsPriborButtonActive("sequence") end},
			true,
			{name = "contactors",Resistance = 5,OnUpdate = function(amp,volt,power) self:GetSystem("TISU"):SetContactorsActive(power and self:GetSystem("MotorVentilator"):IsActive()) end},
		},
		{node1name = "ppnnode",node2name = "ppnnode2",
			{name = "ppnkey",State = function() return self:GetNWVar("PPNActive") end},
			{name = "ppn",Resistance = 5,OnUpdate = function(amp,volt,power) self:SetNWVar("PPNActiveLamp",power) end},
		},
		{node1name = "priborpanelnode",node2name = "priborpanelnode2",
			BuildButtonElement("interiorlight1"),
			BuildButtonElement("interiorlight2"),
			BuildButtonElement("headlights"),
			BuildButtonElement("priborslight"),
			BuildButtonElement("profilelightstop"),
			BuildButtonElement("profilelightsbottom"),
			BuildButtonElement("cabinelight"),
			BuildButtonElement("doorlights"),
			BuildButtonElement("roadtrainlights"),
			BuildButtonElement("vu"),
			BuildButtonElement("compressor"),
			BuildButtonElement("buzzer"),
			BuildButtonElement("sequence"),
			BuildButtonElement("cabineheatervent"),
			BuildButtonElement("opendoor1"),
			BuildButtonElement("opendoor2"),
			BuildButtonElement("opendoor3"),
			BuildButtonElement("opendoor4"),
			BuildButtonElement("cabineheater"),
			BuildButtonElement("interiorheater"),
			BuildButtonElement("interiorheatervent"),
			BuildButtonElement("leftwiper"),
			BuildButtonElement("rightwiper"),
			BuildButtonElement("ppn"),
			BuildButtonElement("emergency"),
			BuildButtonElement("switchpassleft"),
			BuildButtonElement("switchpassright"),
			{Resistance = math.huge},
		},
		{name = "indicatorlamps",Resistance = 100},
	})

	self:GetSystem("AccumulatorBattery"):SetCircuit(self.ElLowCircuit)
	self:GetSystem("MotorVentilator"):SetCircuit(self.ElLowCircuit)

	local trailer = self:GetTrailer()

	trailer.ElLowCircuit = Trolleybus_System.CreateElectricCircuit()
	trailer.ElLowCircuit:BuildFromData({
		{node1name = "batterychargenode",node2name = "batterychargenode2",
			{name = "batterychargekey",State = function() return trailer:GetSystem("MotorVentilator"):IsActive() end},
			{name = "batterycharge",Resistance = function()
				return 1/(1-trailer:GetSystem("AccumulatorBattery"):GetChargePercent())
			end,OnUpdate = function(amp,volt,power)
				trailer:GetSystem("AccumulatorBattery"):SetCharging(power and amp)
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
					trailer.InteriorLight2A = amp
					trailer:SetNWVar("InteriorLightActive2",power)
				end},
			},
			{name = "interiorlight1key",State = function() return self:IsPriborButtonActive("interiorlight1") end},
			{name = "interiorlight1",Resistance = 3,OnUpdate = function(amp,volt,power)
				trailer.InteriorLight1A = amp
				trailer:SetNWVar("InteriorLightActive1",power)
			end},
		},
		{node1name = "profilelightsnode",node2name = "profilelightsnode2",
			{name = "profilelightskey",State = function() return self:IsPriborButtonActive("profilelightstop") or self:IsPriborButtonActive("profilelightsbottom") end},
			{name = "profilelights",Resistance = 4,OnUpdate = function(amp,volt,power) trailer:SetProfileLights(amp/trailer.ProfileLightsAmperage) end},
		},
		{node1name = "doorlight3node",node2name = "doorlight3node2",
			{name = "doorlight3key",State = function() return self:IsPriborButtonActive("doorlights") and trailer:DoorIsOpened("door3") end},
			{name = "doorlight3",Resistance = 10,OnUpdate = function(amp,volt,power) trailer:SetNWVar("Door3Light",power) end},
		},
		{node1name = "doorlight4node",node2name = "doorlight4node2",
			{name = "doorlight4key",State = function() return self:IsPriborButtonActive("doorlights") and trailer:DoorIsOpened("door4") end},
			{name = "doorlight4",Resistance = 10,OnUpdate = function(amp,volt,power) trailer:SetNWVar("Door4Light",power) end},
		},
		{node1name = "turnsignalnode",node2name = "turnsignalnode2",
			{node1name = "turnlsignalnode",node2name = "turnlsignalnode2",
				{name = "turnrsignalkey",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("turnsignal")==1 end},
				{name = "turnrsignal",Resistance = 4,OnUpdate = function(amp,volt,power) trailer.TurnLSignal = power end},
			},
			{name = "turnrsignalkey",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("turnsignal")==-1 end},
			{name = "turnrsignal",Resistance = 4,OnUpdate = function(amp,volt,power) trailer.TurnRSignal = power end},
			true,
			{name = "turnsignal",OnUpdate = function(amp,volt,power) trailer:SetTurnSignalLights(amp/trailer.TurnSignalLightsAmperage) end},
		},
		{node1name = "rearlightnode",node2name = "rearlightnode2",
			{name = "rearlightkey",State = function() return self:GetRearLights()>0 end},
			{name = "rearlight",Resistance = 4,OnUpdate = function(amp,volt,power) trailer:SetRearLight(amp/trailer.RearLightAmperage) end},
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
			BuildButtonElement("polecatchers_control"),
			BuildButtonElement("poles_removal",{-1,-1},"poles_removal_left"),
			BuildButtonElement("poles_removal",{1,1},"poles_removal_right"),
			{Resistance = math.huge},
		},
		{name = "indicatorlamps",Resistance = 100},
	})

	trailer:GetSystem("AccumulatorBattery"):SetCircuit(trailer.ElLowCircuit)
	trailer:GetSystem("MotorVentilator"):SetCircuit(trailer.ElLowCircuit)
end

ENT.Mass = 14660/3*2
ENT.WheelMaxTurn = 45

ENT.AllowKeyboardHandbrakeToggle = false
ENT.AllowKeyboardReverseChange = false

ENT.WheelsData = {
	{
		Drive = false,
		Turn = true,
		Wheels = {
			{Type = "ziu6205",	Pos = Vector(102,42,-41),	Right = false,	Height = 3,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 5},
			{Type = "ziu6205",	Pos = Vector(102,-42,-41),	Right = true,	Height = 3,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 5},
		},
	},
	{
		Drive = true,
		Turn = false,
		Wheels = {
			{Type = "ziu6205_rear",	Pos = Vector(-126,36,-40),	Right = false,	Height = 4,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 6},
			{Type = "ziu6205_rear",	Pos = Vector(-126,-36,-40),	Right = true,	Height = 4,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 6},
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
			if self:GetTrailer():GetPoleState(false)==0 then self:GetTrailer():SetPoleState(4,false) end
			
			if self:GetPoleCatchingFraction(false)<1 then
				self:SetPoleCatchingFraction(math.min(1,self:GetPoleCatchingFraction(false)+self.DeltaTime/3),false)
			end
		elseif self:IsPriborButtonActive("poles_removal_right") then
			if self:GetTrailer():GetPoleState(true)==0 then self:GetTrailer():SetPoleState(4,true) end
			
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

		local interiorlight = (self.InteriorLight1A+self.InteriorLight2A)/2
		self:SetInteriorLight(interiorlight/self.InteriorLightAmperage)

		self:SetEmergencySignal(self:IsPriborButtonActive("emergency"))

		if !self:IsPriborButtonActive("emergency") then
			self:SetTurnSignal(self.TurnLSignal and 1 or self.TurnRSignal and 2 or 0)
		end

		self:SetScheduleLight(self:ButtonIsDown("profilelightstop") and self:GetProfileLights() or 0)
		
		self:GetSystem("TISU"):SetEngineAmperage(self:GetSystem("Engine"):GetAmperage())
		self:GetSystem("TISU"):SetEngineRotation(self:GetSystem("Engine"):GetRotation())

		self:GetSystem("Engine"):SetAsGenerator(self:GetSystem("TISU"):IsEngineAsGenerator())
		self:GetSystem("Engine"):SetBrakeFraction(self:GetSystem("TISU"):GetEngineBrakeFraction())
		self:GetSystem("Engine"):SetInverted(self:GetReverseState()==-1)
	end
	
	return true
end

function ENT:OnReloaded()
	self:InitializeHighVoltageCircuit()
	self:InitializeLowVoltageCircuit()
end

function ENT:DisableMainSwitchesByHighCurrent()
	if self:ButtonIsDown("mainswitch1") and self:ButtonIsDown("mainswitch2") then
		self:ToggleButton("mainswitch1",false)
		self:ToggleButton("mainswitch2",false)

		local pos = Vector(131.44,38.49,33.74)
		Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/ziu6205/av8a_off_highcurrent.ogg",500,1,nil,pos)
		Trolleybus_System.ElectricSpark(self:LocalToWorld(pos))

		local pos = Vector(131.51,19.49,37.74)
		Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/ziu6205/av8a_off_highcurrent.ogg",500,1,nil,pos)
		Trolleybus_System.ElectricSpark(self:LocalToWorld(pos))
	end
end