-- Copyright © Platunov I. M., 2022 All rights reserved

DEFINE_BASECLASS("trolleybus_ent_base")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.InteriorLightAmperage = 9.33
ENT.CabineLightAmperage = 2.8
ENT.FogHeadLightsAmperage = 9.33
ENT.HeadLightsAmperage = 7
ENT.ProfileLightsAmperage = 7
ENT.TurnSignalLightsAmperage = 14
ENT.RearLightAmperage = 7
ENT.RouteLightAmperage = 9.33

function ENT:PreInitialize(ply,tr)
	self:SetPos(tr.HitPos+Vector(0,0,62))
end

function ENT:Initialize()
	BaseClass.Initialize(self)

	self:InitializeHighVoltageCircuit()
	self:InitializeLowVoltageCircuit()

	self:ToggleButton("handbrake",true)
	self:SetButtonDisabled("emergency_off",true)
	self:SetButtonDisabled("key",true)

	self.AVDUActive = false
	self.BPNActive = false
	self.BoosterActive = false
	self.StopRequests = 0
end

function ENT:InitializeHighVoltageCircuit()
	self.ElCircuit = Trolleybus_System.CreateElectricCircuit()
	self.ElCircuit:BuildFromData({
		{name = "key",State = function() return self:ButtonIsDown("key") end},
		{name = "avdu",State = function() if self:IsUseAutoMoveCircuit() then return self:IsPriborButtonActive("automove") end return self.AVDUActive end,OnUpdate = function(amp,volt,power)
			if self:IsUseAutoMoveCircuit() then
				self:SetNWVar("AutoMove",power and self:IsPriborButtonActive("automove"))
				self:SetNWVar("HighPower",false)

				self:SetAVDUActive(false)
			else
				self:SetNWVar("AutoMove",false)
				self:SetNWVar("HighPower",power)
			end
		end},
		{node1name = "enginenode",node2name = "enginenode2",
			{name = "trsu",Resistance = function() return self:GetSystem("TRSU"):GetResistance() end},
			{name = "ptad",Direction = true},
			{name = "engine",Resistance = function() return self:GetSystem("Engine"):GetResistance() end,OnUpdate = function(amp,volt,power) self:GetSystem("Engine"):SetAmperage(math.min(amp,500)) end},
		},
		{node1name = "compressornode",node2name = "compressornode2",
			{name = "compressorpower",State = function() return self:ButtonIsDown("compressorpower") and self:IsPriborButtonActive("compressor") and self:GetSystem("Pneumatic"):ShouldBeMotorCompressorActive() end},
			{name = "compressor",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Pneumatic"):SetMotorCompressorActive(power) end},
		},
		{node1name = "noautomovenode",node2name = "noautomovenode2",
			{name = "noautomove",State = function() return !self:IsUseAutoMoveCircuit() end},
			{node1name = "intheatersnode",node2name = "intheatersnode2",
				{name = "intheaterspower",State = function() return self:ButtonIsDown("intheaterpower") and !self:IsPriborButtonActive("switchright") end},
				{node1name = "intheater1node",node2name = "intheater1node2",
					{name = "intheater1power",State = function() return self:IsPriborButtonActive("intheater") end},
					{name = "intheater1",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Heater","Interior1"):SetState(power and 1 or 0) self:GetSystem("Heater","Interior1"):SetVentActive(power) end},
				},
				{node1name = "intheater2node",node2name = "intheater2node2",
					{name = "intheater2power",State = function() return self:IsPriborButtonActive("intheater2") end},
					{name = "intheater2",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Heater","Interior2"):SetState(power and 1 or 0) self:GetSystem("Heater","Interior2"):SetVentActive(power) end},
				},
				{node1name = "intheater3node",node2name = "intheater3node2",
					{name = "intheater3power",State = function() return self:IsPriborButtonActive("intheater3") end},
					{name = "intheater3",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Heater","Interior3"):SetState(power and 1 or 0) self:GetSystem("Heater","Interior3"):SetVentActive(power) end},
				},
				{name = "intheater4power",State = function() return self:IsPriborButtonActive("intheater4") end},
				{name = "intheater4",Resistance = 50,OnUpdate = function(amp,volt,power) self:GetSystem("Heater","Interior4"):SetState(power and 1 or 0) self:GetSystem("Heater","Interior4"):SetVentActive(power) end},
			},
			{node1name = "cabheaternode",node2name = "cabheaternode2",
				{name = "cabheaterpower",State = function() return self:ButtonIsDown("cabheaterpower") and !self:IsPriborButtonActive("switchright") end},
				{node1name = "cabheaterventnode",node2name = "cabheaterventnode2",
					{name = "cabheaterventpower",State = function() return self:IsPriborButtonActive("cabheatervent") end},
					{name = "cabheatervent",Resistance = 100,OnUpdate = function(amp,volt,power) self.CabHeaterVent = power end},
				},
				{node1name = "cabheater1node",node2name = "cabheater1node2",
					{name = "cabheater1power",State = function() return self.CabHeaterVent and self:IsPriborButtonActive("cabheater") end},
					{name = "cabheater1",Resistance = 50,OnUpdate = function(amp,volt,power) self.CabHeater1 = power end},
				},
				{name = "cabheater2power",State = function() return self.CabHeaterVent and self:IsPriborButtonActive("cabheater2") end},
				{name = "cabheater2",Resistance = 50,OnUpdate = function(amp,volt,power) self.CabHeater2 = power end},
				true,true,
				{name = "cabheater",OnUpdate = function(amp,volt,power)
					self:GetSystem("Heater"):SetState(self.CabHeater1 and self.CabHeater2 and 2 or (self.CabHeater1 or self.CabHeater2) and 1 or 0)
					self:GetSystem("Heater"):SetVentActive(self.CabHeaterVent)
				end},
			},
			{name = "automovebattery",Resistance = function()
				return 5/(1-self:GetSystem("AccumulatorBattery","AutoMove"):GetChargePercent())
			end,OnUpdate = function(amp,volt,power)
				self:GetSystem("AccumulatorBattery","AutoMove"):SetCharging(power and amp)
			end},
		},
		{node1name = "powerunitnode",node2name = "powerunitnode2",
			{name = "powerunitpower",State = function() return self:ButtonIsDown("powerunit") and self:IsPriborButtonActive("converter") end},
			{name = "powerunit",Resistance = 100,OnUpdate = function(amp,volt,power)
				self:SetBPNActive(power)
				self:GetSystem("StaticVoltageConverter"):SetActive(power)
				self:GetSystem("AccumulatorBattery"):SetCircuitUsageDisabled(power)
			end},
		},
		{node1name = "switchleftnode",node2name = "switchleftnode2",
			{name = "switchleftpower",State = function() return self:IsPriborButtonActive("switchleft") end},
			{name = "switchleft",Resistance = 6,OnUpdate = function(amp,volt,power)
				if power!=self.SwitchLeftSound then
					self.SwitchLeftSound = power

					if power then
						Trolleybus_System.PlayBassSound(self,"trolleybus/trolza5265/switch_left.ogg",1000,1,true,nil,Vector(-213,-6,43))
					else
						Trolleybus_System.StopBassSound(self,"trolleybus/trolza5265/switch_left.ogg")
					end
				end
			end},
		},
		{node1name = "obduvnode",node2name = "obduvnode2",
			{name = "obduvpower",State = function() return self.AVDUActive end},
			{name = "obduv",Resistance = 100,OnUpdate = function(amp,volt,power) self:SetNWVar("ObduvPower",power) end},
		},
		{Resistance = 1000},
	})

	self:GetSystem("AccumulatorBattery","AutoMove"):SetCircuit(self.ElCircuit)
	self:GetSystem("AccumulatorBattery","AutoMove"):SetCircuitUsageDisabled(true)
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
			{name = "batterychargepower",State = function() return self:GetSystem("StaticVoltageConverter"):IsActive() end},
			{name = "batterycharge",Resistance = function()
				return 1/(1-self:GetSystem("AccumulatorBattery"):GetChargePercent())
			end,OnUpdate = function(amp,volt,power)
				self:GetSystem("AccumulatorBattery"):SetCharging(power and amp)
			end},
		},
		{node1name = "intlightnode",node2name = "intlightnode2",
			{node1name = "intlight1node",node2name = "intlight1node2",
				{name = "intlight1power",State = function() return self:IsPriborButtonActive("intlight") end},
				{name = "intlight1",Resistance = 3,OnUpdate = function(amp,volt,power) self.IntLight1 = amp/self.InteriorLightAmperage end},
			},
			{name = "intlight2power",State = function() return self:IsPriborButtonActive("intlight2") end},
			{name = "intlight2",Resistance = 3,OnUpdate = function(amp,volt,power) self.IntLight2 = amp/self.InteriorLightAmperage end},
			true,
			{name = "intlight",OnUpdate = function(amp,volt,power)
				self:SetInteriorLight((self.IntLight1+self.IntLight2)/2)

				self:SetNWVar("IntLightL",self.IntLight1>0)
				self:SetNWVar("IntLightR",self.IntLight2>0)
			end},
		},
		{node1name = "cablightnode",node2name = "cablightnode2",
			{name = "cablightpower",State = function() return self:IsPriborButtonActive("cablight") end},
			{name = "cablight",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetCabineLight(amp/self.CabineLightAmperage) end},
		},
		{node1name = "headlightsnode",node2name = "headlightsnode2",
			{node1name = "foglightsnode",node2name = "foglightsnode2",
				{name = "foglightspower",State = function() return self:IsPriborButtonActive("fogheadlights") end},
				{name = "foglights",Resistance = 3,OnUpdate = function(amp,volt,power) self.FogLights = amp/self.FogHeadLightsAmperage end},
			},
			{name = "headlightspower",State = function() return self:IsPriborButtonActive("headlights") end},
			{name = "headlights",Resistance = 4,OnUpdate = function(amp,volt,power) self.HeadLights = amp/self.HeadLightsAmperage end},
			true,
			{name = "headlight",OnUpdate = function(amp,volt,power)
				self:SetHeadLights(math.max(self.FogLights,self.HeadLights))

				self:SetNWVar("FogHeadLights",self.FogLights>0)
				self:SetNWVar("HeadLights",self.HeadLights>0)
			end},
		},
		{node1name = "profilelightsnode",node2name = "profilelightsnode2",
			{name = "profilelightspower",State = function() return self:IsPriborButtonActive("profilelights") end},
			{name = "profilelights",Resistance = 4,OnUpdate = function(amp,volt,power) self:SetProfileLights(amp/self.ProfileLightsAmperage) end},
		},
		{node1name = "doorlightsnode",node2name = "doorlightsnode2",
			{node1name = "doorlight11node",node2name = "doorlight11node2",
				{name = "doorlight11power",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door11") end},
				{name = "doorlight11",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("DoorLight1",power) end},
			},
			{node1name = "doorlight12node",node2name = "doorlight12node2",
				{name = "doorlight12power",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door12") end},
				{name = "doorlight12",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("DoorLight2",power) end},
			},
			{node1name = "doorlight21node",node2name = "doorlight21node2",
				{name = "doorlight21power",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door21") end},
				{name = "doorlight21",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("DoorLight3",power) end},
			},
			{node1name = "doorlight22node",node2name = "doorlight22node2",
				{name = "doorlight22power",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door22") end},
				{name = "doorlight22",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("DoorLight4",power) end},
			},
			{node1name = "doorlight31node",node2name = "doorlight31node2",
				{name = "doorlight31power",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door31") end},
				{name = "doorlight31",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("DoorLight5",power) end},
			},
			{name = "doorlight32power",State = function() return self:IsPriborButtonActive("doorlights") and self:DoorIsOpened("door32") end},
			{name = "doorlight32",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetNWVar("DoorLight6",power) end},
		},
		{node1name = "hydroboosternode",node2name = "hydroboosternode2",
			{name = "hydroboosterpower",State = function() return self:IsPriborButtonActive("hydrobooster") end},
			{name = "hydrobooster",Resistance = 5,OnUpdate = function(amp,volt,power) self:GetSystem("HydraulicBooster"):SetAmperage(math.abs(amp)) self:SetBoosterActive(power) end},
		},
		{node1name = "turnsignalnode",node2name = "turnsignalnode2",
			{node1name = "turnlsignalnode",node2name = "turnlsignalnode2",
				{name = "turnlsignalpower",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("guitar_left")==-1 end},
				{name = "turnlsignal",Resistance = 4,OnUpdate = function(amp,volt,power) self.TurnLSignal = power end},
			},
			{name = "turnrsignalpower",State = function() return self:IsPriborButtonActive("emergency") or self:GetMultiButton("guitar_left")==1 end},
			{name = "turnrsignal",Resistance = 4,OnUpdate = function(amp,volt,power) self.TurnRSignal = power end},
			true,
			{name = "turnsignal",OnUpdate = function(amp,volt,power)
				self:SetTurnSignalLights(amp/self.TurnSignalLightsAmperage)

				self:SetEmergencySignal(self:IsPriborButtonActive("emergency"))
				self:SetTurnSignal(self.TurnLSignal and 1 or self.TurnRSignal and 2 or 0)
			end},
		},
		{node1name = "rearlightnode",node2name = "rearlightnode2",
			{name = "rearlightpower",State = function() return self:GetRearLights()>0 end},
			{name = "rearlight",Resistance = 4,OnUpdate = function(amp,volt,power) self:SetRearLight(amp/self.RearLightAmperage) end},
		},
		{node1name = "avdunode",node2name = "avdunode2",
			{node1name = "avdu+node",node2name = "avdu+node2",
				{name = "avdu+power",State = function() return self:IsPriborButtonActive("avdu+") end},
				{name = "avdu+",Resistance = 10,OnUpdate = function(amp,volt,power) if power then self:SetAVDUActive(true) end end},
			},
			{name = "avdu-power",State = function() return self:IsPriborButtonActive("avdu-") end},
			{name = "avdu-",Resistance = 10,OnUpdate = function(amp,volt,power) if power then self:SetAVDUActive(false) end end},
		},
		{node1name = "chargenode",node2name = "chargenode2",
			{name = "chargepower",State = function() return self:IsPriborButtonActive("charge") end},
			{name = "charge",Resistance = 10,OnUpdate = function(amp,volt,power) self:SetUseAutoMoveCircuit(power) end},
		},
		{node1name = "polecatcherspowernode",node2name = "polecatcherspowernode2",
			{name = "polecatcherspowerpower",State = function() return self:IsPriborButtonActive("polecatcherspower") end,OnUpdate = function(amp,volt,power) self:SetNWVar("PoleCatchersPower",power) end},
			{name = "polecatcherspower",Resistance = 10},
		},
		{node1name = "polecatchersnode",node2name = "polecatchersnode2",
			{name = "polecatcherscontrol",State = function() return self:IsPriborButtonActive("polecatcherscontrol") and self:GetNWVar("PoleCatchersPower") end,OnUpdate = function(amp,volt,power) self:SetNWVar("PoleCatchersControl",power) end},
			{name = "polecatchers",Resistance = 8,OnUpdate = function(amp,volt,power)
				if power then
					if self:IsPriborButtonActive("removepoles") then
						if self:GetPoleState(false)==0 then self:SetPoleState(1,false) end
						if self:GetPoleState(true)==0 then self:SetPoleState(1,true) end

						self:SetPoleCatchingActive(true)
					end
				else
					self:SetPoleCatchingActive(false)
				end
			end},
		},
		{node1name = "buzzersnode",node2name = "buzzersnode2",
			{name = "buzzerdata",OnUpdate = function(amp,volt,power)
				self.BuzzerPower = self.ElCircuit:HasPower()
				self.BuzzerAir = self:GetSystem("Pneumatic"):GetAir(1)>=400 and self:GetSystem("Pneumatic"):GetAir(2)>=400 and self:GetSystem("Pneumatic"):GetAir(3)>=400
			end},
			{node1name = "buzzer1node",node2name = "buzzer1node2",
				{name = "buzzer1power",State = function() return self.BuzzerPower and !self.BuzzerAir end},
				{name = "buzzer1",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer","LowAir"):SetActive(power) end},
			},
			{node1name = "buzzer2node",node2name = "buzzer2node2",
				{name = "buzzer2power",State = function() return !self.BuzzerPower and self.BuzzerAir end},
				{name = "buzzer2",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer","LowVoltage"):SetActive(power) end},
			},
			{node1name = "buzzer3node",node2name = "buzzer3node2",
				{name = "buzzer3power",State = function() return !self.BuzzerPower and !self.BuzzerAir end},
				{name = "buzzer3",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer","LowAirVoltage"):SetActive(power) end},
			},
			{node1name = "buzzer4node",node2name = "buzzer4node2",
				{name = "buzzer4power",State = function() return self.StopRequests>0 end},
				{name = "buzzer4",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer","StopRequest"):SetActive(power) end},
			},
			{name = "buzzer5power",State = function() return self:GetRearLights()>1 end},
			{name = "buzzer5",Resistance = 10,OnUpdate = function(amp,volt,power) self:GetSystem("Buzzer","BackwardMove"):SetActive(power) end},
		},
		{node1name = "screennode",node2name = "screennode2",
			{name = "screen",Resistance = 3,OnUpdate = function(amp,volt,power) self:SetNWVar("ScreenPower",power) end},
		},
		{node1name = "informatornode",node2name = "informatornode2",
			{name = "informatorpower",State = function() return self:IsPriborButtonActive("informator") end},
			{name = "informator",Resistance = 5,OnUpdate = function(amp,volt,power) self:GetSystem("Agit-132"):SetActive(power) end},
		},
		{node1name = "routelightnode",node2name = "routelightnode2",
			{name = "routelight",Resistance = 3,OnUpdate = function(amp,volt,power) self:SetScheduleLight(amp/self.RouteLightAmperage) end},
		},
		{node1name = "priborpanelnode",node2name = "priborpanelnode2",
			BuildButtonElement("intlight"),
			BuildButtonElement("intlight2"),
			BuildButtonElement("cablight"),
			BuildButtonElement("fogheadlights"),
			BuildButtonElement("headlights"),
			BuildButtonElement("profilelights"),
			BuildButtonElement("doorlights"),
			BuildButtonElement("converter"),
			BuildButtonElement("compressor"),
			BuildButtonElement("hydrobooster"),
			BuildButtonElement("cabheatervent"),
			BuildButtonElement("cabheater"),
			BuildButtonElement("cabheater2"),
			BuildButtonElement("intheater"),
			BuildButtonElement("intheater2"),
			BuildButtonElement("intheater3"),
			BuildButtonElement("intheater4"),
			BuildButtonElement("informator"),
			BuildButtonElement("avdu+"),
			BuildButtonElement("avdu-"),
			BuildButtonElement("switchleft"),
			BuildButtonElement("switchright"),
			BuildButtonElement("automove"),
			BuildButtonElement("charge"),
			BuildButtonElement("door1"),
			BuildButtonElement("door2"),
			BuildButtonElement("door3"),
			BuildButtonElement("doors"),
			BuildButtonElement("polecatcherspower"),
			BuildButtonElement("emergopendoor1"),
			BuildButtonElement("emergopendoor2"),
			BuildButtonElement("emergopendoor3"),
			BuildButtonElement("removepoles"),
			BuildButtonElement("polecatcherscontrol"),
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

ENT.Mass = 11200

ENT.TrolleyPoleCatcherPos = Vector(-224.31,0,0.81)
ENT.TrolleyPoleCatcherAng = Angle(0,180,0)
ENT.TrolleyPoleCatcherDist = 15.63

ENT.WheelMaxTurn = 45
ENT.AllowKeyboardReverseChange = false
ENT.AllowKeyboardHandbrakeToggle = false
ENT.DriverSeatExitPos = Vector(182,28,-33)

ENT.WheelsData = {
	{
		Drive = false,
		Turn = true,
		Wheels = {
			{Type = "trolza5265",	Pos = Vector(112,40,-44),	Right = false,	Height = 1,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 6},
			{Type = "trolza5265",	Pos = Vector(112,-40,-44),	Right = true,	Height = 0.25,	Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 6},
		},
	},
	{
		Drive = true,
		Turn = false,
		Wheels = {
			{Type = "trolza5265_rear",	Pos = Vector(-109,36,-44),	Right = false,	Height = 3,		Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 6},
			{Type = "trolza5265_rear",	Pos = Vector(-109,-36,-44),	Right = true,	Height = 2.5,		Constant = 50000,	Damping = 1300,	RDamping = 1300,	Times = 6},
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

	if self.SystemsLoaded then
		if !self:IsUseAutoMoveCircuit() then
			self.ElCircuit:Update(self:GetHighVoltage())
		end

		self:SetNWVar("LowPower",self.ElLowCircuit:HasPower())
		self:SetNWVar("LowVoltage",self.ElLowCircuit:GetVoltage())

		self:GetSystem("TRSU"):SetEngineAmperage(self:GetSystem("Engine"):GetAmperage())

		self:GetSystem("Engine"):SetAsGenerator(self:GetSystem("TRSU"):IsEngineAsGenerator())
		self:GetSystem("Engine"):SetBrakeFraction(self:GetSystem("TRSU"):GetEngineBrakeFraction())
		self:GetSystem("Engine"):SetInverted(self:GetReverseState()==-1)
	end
	
	return true
end

function ENT:CalcElectricCurrentUsage()
	return !self:IsUseAutoMoveCircuit() and self.ElCircuit:GetAmperage() or 0
end

function ENT:OnReloaded()
	self:InitializeHighVoltageCircuit()
	self:InitializeLowVoltageCircuit()
end

function ENT:SetUseAutoMoveCircuit(automove)
	local system = self:GetSystem("AccumulatorBattery","AutoMove")

	system:SetActive(automove)
	system:SetCircuitUsageDisabled(!automove)
end

function ENT:IsUseAutoMoveCircuit()
	return self:GetSystem("AccumulatorBattery","AutoMove"):IsActive()
end

function ENT:SetAVDUActive(active)
	if self.AVDUActive==active then return end
	self.AVDUActive = active

	local snd = active and "lk_avdu_on" or "lk_avdu_off"
	Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/trolza5265/"..snd..".ogg",500,1,nil,Vector(5,0,59))
end

function ENT:SetBPNActive(active)
	if self.BPNActive==active then return end
	self.BPNActive = active

	local snd = active and "bpn_on" or "bpn_off"
	Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/trolza5265/"..snd..".ogg",500,1,nil,Vector(-210,0,-1))
end

function ENT:SetBoosterActive(active)
	if self.BoosterActive==active then return end
	self.BoosterActive = active

	local snd = active and "lk_gur_on" or "lk_gur_off"
	Trolleybus_System.PlayBassSoundSimple(self,"trolleybus/trolza5265/hydrobooster/"..snd..".ogg",250,1,nil,Vector(167,29,-40))
end