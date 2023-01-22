-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.IsTrolleybus = true
ENT.AutomaticFrameAdvance = false

ENT.TrolleyPoleSideDist = Trolleybus_System.OverheadLinesDist
ENT.TrolleyPoleDownedAngleLeft = Angle(0,180,0)
ENT.TrolleyPoleDownedAngleRight = Angle(0,180,0)

local networkvars
local function NetworkVar(self,type,name)
	networkvars[type] = networkvars[type] or 0

	self:NetworkVar(type,networkvars[type],name)

	if SERVER then
		self:NetworkVarNotify(name,function(ent,name,old,new)
			Trolleybus_System.RunChangeEvent("Trolleybus_DTVar",old,new,self,name)
		end)
	end

	networkvars[type] = networkvars[type]+1
end

local function NetworkVarOptFloat(self,name,decimals)
	local mp = 10^(decimals or 2)
	local internal = "-"..name
	
	NetworkVar(self,"Int",internal)

	local set,get = self["Set"..internal],self["Get"..internal]

	self["Set"..name] = function(self,value) set(self,value*mp) end
	self["Get"..name] = function(self) return get(self)/mp end
end

function ENT:SetupDataTables()
	networkvars = {}

	NetworkVar(self,"Bool","PoleAngInversionLeft")
	NetworkVar(self,"Bool","PoleAngInversionRight")
	NetworkVar(self,"Bool","HandbrakeActive")
	NetworkVar(self,"Bool","EmergencySignal")
	NetworkVar(self,"Bool","PolesPolarityInversion")
	NetworkVarOptFloat(self,"SteerAngle",3)
	NetworkVar(self,"Int","PoleStateLeft")
	NetworkVar(self,"Int","PoleContactWireLeft")
	NetworkVar(self,"Int","PoleStateRight")
	NetworkVar(self,"Int","PoleContactWireRight")
	NetworkVar(self,"Int","PassCount")
	NetworkVar(self,"Int","TurnSignal")
	NetworkVar(self,"Int","RearLights")
	NetworkVar(self,"Int","RouteNum")
	NetworkVar(self,"Int","InformatorState")
	NetworkVar(self,"Int","InformatorID")
	NetworkVar(self,"Int","InformatorPlayLine")
	NetworkVarOptFloat(self,"MoveSpeed")
	NetworkVarOptFloat(self,"StartPedal")
	NetworkVarOptFloat(self,"BrakePedal")
	NetworkVarOptFloat(self,"PowerFromCN",3)
	NetworkVar(self,"Int","ReverseState")
	NetworkVar(self,"Int","BortNumber")
	NetworkVarOptFloat(self,"CabineLight")
	NetworkVarOptFloat(self,"HeadLights")
	NetworkVarOptFloat(self,"ProfileLights")
	NetworkVarOptFloat(self,"InteriorLight")
	NetworkVarOptFloat(self,"ScheduleLight")
	NetworkVarOptFloat(self,"RoadTrainLights")
	NetworkVarOptFloat(self,"TurnSignalLights")
	NetworkVarOptFloat(self,"RearLight")
	NetworkVar(self,"Float","PoleStateTimeLeft")
	NetworkVar(self,"Float","PoleStateTimeRight")
	NetworkVar(self,"Entity","DriverSeat")
	NetworkVar(self,"Entity","Driver")
	NetworkVar(self,"Entity","Trailer")
	NetworkVar(self,"Entity","Trolleybus")
	NetworkVar(self,"Angle","PoleMoveAngLeft")
	NetworkVar(self,"Angle","PoleMoveAngRight")
	NetworkVar(self,"Vector","DriverSeatVelocity")
	NetworkVar(self,"String","PoleContactLeft")
	NetworkVar(self,"String","PoleContactRight")
end

function ENT:DoorIsOpened(name,fullyclosed)
	local val = self:GetNWVar("Doors."..name,false)
	
	if CLIENT and !val and fullyclosed and self.Doors and self.Doors[name] then
		val = self.Doors[name].MoveState>0
	end
	
	return val
end

function ENT:GetHighVoltage()
	if !self.HasPoles then
		if self.IsTrailer then
			return IsValid(self:GetTrolleybus()) and self:GetTrolleybus():GetHighVoltage() or 0
		else
			return IsValid(self:GetTrailer()) and self:GetTrailer().HasPoles and self:GetTrailer():GetHighVoltage() or 0
		end
	end
	
	return self:GetPowerFromCN()
end

function ENT:ButtonIsDown(name)
	return self:GetNWVar("Buttons."..name,false)
end

function ENT:GetMultiButton(btn)
	return self:GetNWVar("MultiBtns."..btn,0)
end

function ENT:GetReverseButton(btn)
	return self:GetNWVar("ReverseState."..btn,0),self:GetNWVar("ReverseData.Active."..btn,false)
end

function ENT:IsButtonDisabled(btn)
	return self:GetNWVar("BtnsDisabled."..btn,false)
end

function ENT:UPSToKPH(ups) --Units per second to kilometers per hour
	local mps = ups/Trolleybus_System.UnitsPerMeter
	local mph = mps*3600
	local kph = mph/1000
	
	return kph
end

function ENT:KPHToUPS(kph) --Kilometers per hour to units per second
	local mph = kph*1000
	local mps = mph/3600
	local ups = mps*Trolleybus_System.UnitsPerMeter
	
	return ups
end

function ENT:SetupSystems()
	self.Systems = {}
	
	self:LoadSystems()
	
	self.SystemsLoaded = true
	
	if self.SpawnSettings then
		for k,v in ipairs(self.SpawnSettings) do
			if v.setup then v.setup(self,self._SpawnSettings[k]) end
		end
	end
end

function ENT:LoadSystems()
end

function ENT:LoadSystem(name,defvalues,index)
	return Trolleybus_System.LoadSystem(self,name,defvalues,index)
end

function ENT:UnloadSystem(name,index)
	return Trolleybus_System.UnloadSystem(self,name,index)
end

function ENT:GetSystem(name,index)
	index = index or "0"

	return self.Systems[name..":"..index]
end

function ENT:SetNWVar(var,value)
	Trolleybus_System.NetworkSystem.SetNWVar(self,var,value)
end

function ENT:GetNWVar(var,default)
	return Trolleybus_System.NetworkSystem.GetNWVar(self,var,default)
end

function ENT:GetMainTrolleybus(orself)
	local ent = self.IsTrailer and self:GetTrolleybus() or self
	
	return orself and (IsValid(ent) and ent or self) or ent
end

function ENT:GetSpawnSetting(index)
	if !self.SpawnSettings then return end
	
	if isstring(index) and self._SpawnSettingsNames then
		index = self._SpawnSettingsNames[index]
	end
	
	if SERVER then
		return self._SpawnSettings[index]
	else
		if self._SpawnSettings then
			return self._SpawnSettings[index]
		else
			if isstring(index) then
				for k,v in ipairs(self.SpawnSettings) do
					if v.alias==index then
						index = k
						break
					end
				end
			end
			
			if self.SpawnSettings[index] then
				local value = self.SpawnSettings[index].default
			
				if self.SpawnSettings[index].type=="ComboBox" then
					value = self.SpawnSettings[index].choices[value].value or value
				end
				
				return value
			end
		end
	end
end

function ENT:SetPoleState(state,right)
	local old = self:GetPoleState(right)

	if right then
		self:SetPoleStateRight(state)
	else
		self:SetPoleStateLeft(state)
	end

	Trolleybus_System.RunChangeEvent("Trolleybus_PoleState",old,state,self,right)
end

function ENT:GetPoleState(right)
	return right and self:GetPoleStateRight() or self:GetPoleStateLeft()
end

function ENT:SetPoleContactWire(contact,wire,right)
	local oldc,oldw = self:GetPoleContactWire(right)

	if right then
		self:SetPoleContactRight(contact)
		self:SetPoleContactWireRight(wire)
	else
		self:SetPoleContactLeft(contact)
		self:SetPoleContactWireLeft(wire)
	end

	Trolleybus_System.RunChangeEvent("Trolleybus_PoleContact",oldc,contact,self,right)
	Trolleybus_System.RunChangeEvent("Trolleybus_PoleContactWire",oldw,wire,self,right)
end

function ENT:GetPoleContactWire(right)
	return right and self:GetPoleContactRight() or self:GetPoleContactLeft(),right and self:GetPoleContactWireRight() or self:GetPoleContactWireLeft()
end

function ENT:SetPoleAngInversion(invert,right)
	if right then
		self:SetPoleAngInversionRight(invert)
	else
		self:SetPoleAngInversionLeft(invert)
	end
end

function ENT:GetPoleAngInversion(right)
	return right and self:GetPoleAngInversionRight() or !right and self:GetPoleAngInversionLeft()
end

function ENT:SetPoleStateTime(time,right)
	if right then
		self:SetPoleStateTimeRight(time)
	else
		self:SetPoleStateTimeLeft(time)
	end
end

function ENT:GetPoleStateTime(right)
	return right and self:GetPoleStateTimeRight() or self:GetPoleStateTimeLeft()
end

function ENT:SetPoleMoveAng(time,right)
	if right then
		self:SetPoleMoveAngRight(time)
	else
		self:SetPoleMoveAngLeft(time)
	end
end

function ENT:GetPoleMoveAng(right)
	return right and self:GetPoleMoveAngRight() or self:GetPoleMoveAngLeft()
end

function ENT:IsPoleLinePositive(right)
	local voltage,positive = Trolleybus_System.ContactNetwork.GetContactWireVoltage(self:GetPoleContactWire(right))
	return positive
end

function ENT:PlayerIsInside(ply)
	local pos = Trolleybus_System.EyePos(ply)
	local lpos = self:WorldToLocal(pos)
	
	return lpos:WithinAABox(self:GetModelBounds())
end

function ENT:GetPolePos(right,loc)
	local pos = self.TrolleyPolePos+Vector(0,right and -self.TrolleyPoleSideDist or self.TrolleyPoleSideDist,0)

	return loc and pos or self:LocalToWorld(pos)
end

local function SystemsHook(self,name,skip,...)
	if !self.SystemsLoaded or !self.Systems then return end
	
	for k,v in pairs(self.Systems) do
		if skip and skip[k] then continue end
		
		local func = v[name]
		
		if func then
			local args = {func(v,...)}
			
			if args[1]!=nil then
				return args
			end
		end
	end
end

function ENT:SystemsHook(name,...)
	if !self.SystemsLoaded then return end
	
	local skipsys
	if self.IsTrailer then
		skipsys = self.Systems
		
		local result = SystemsHook(self,name,nil,...)
		if result then if result[2]!=nil then return unpack(result) else return result[1] end end
	end
	
	local result = SystemsHook(self:GetMainTrolleybus(),name,skipsys,...)
	if result then if result[2]!=nil then return unpack(result) else return result[1] end end
end

function ENT:SystemsEvent(main,name,...)
	if !self.SystemsLoaded then return end
	
	local bus = main and self:GetMainTrolleybus() or self
	
	for k,v in pairs(bus.SystemsLoaded and bus.Systems or {}) do
		if v[name] then v[name](v,...) end
	end
end

hook.Add("CanProperty","Trolleybus_System.BaseBGs",function(ply,type,ent)
	if ent.IsTrolleybus and type=="bodygroups" then return false end
end)