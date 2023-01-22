-- Copyright © Platunov I. M., 2021 All rights reserved

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("TrolleybusSystem.Stop.PassOut")

Trolleybus_System.StopsPassengersSpawn = Trolleybus_System.StopsPassengersSpawn or {NextSpawn = 0,Rate = {15,30},Stops = 0}

function ENT:Initialize()
	self:SetModel("models/trolleybus/tstop.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:DrawShadow(false)
	
	self:GetPhysicsObject():EnableMotion(false)
	self:GetPhysicsObject():EnableDrag(false)

	self.SpawnTime = CurTime()
	self.LastTime = CurTime()
	self.CurrentTrolleybuses = {}
	self.Passengers = {}
	
	Trolleybus_System.UpdateTransmit(self,"TrolleybusStopDrawDistance")
	Trolleybus_System.StopsPassengersSpawn.Stops = Trolleybus_System.StopsPassengersSpawn.Stops+1
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:UpdateData(dt)
	self:SetStopName(dt.Name)
	self:SetSVName(dt.SVName)
	self:SetPavilion(dt.Pavilion)
	self:SetSize(dt.Length,dt.Width)
	self:SetPassCountPercent(dt.PassPercent)

	self:SetNotSolid(!self:GetPavilion())

	local routesstr,routes,endroutes = {},{},{}

	for k,v in pairs(Trolleybus_System.Routes.Routes) do
		for k2,v2 in ipairs(v.Dirs) do
			local key = table.KeyFromValue(v2.Stops,self:GetID())

			if key then
				routesstr[#routesstr+1] = k

				routes[k] = routes[k] or {}
				routes[k][k2] = key

				if !v.Circular and key==#v2.Stops then
					endroutes[k] = true
				end
			end
		end
	end

	self:SetRoutesStr(table.concat(routesstr,","))
	self.RoutesBelonging = routes
	self.EndRoutes = endroutes

	local i = 1
	while i<=#self.Passengers do
		if !self:CanPassReachGoal(self:GetID(),self.Passengers[i].GoalStop) then
			table.remove(self.Passengers,i)
			self:SetPassCount(self:GetPassCount()-1)
		else
			i = i+1
		end
	end
end

function ENT:SetNWVar(var,value)
	Trolleybus_System.NetworkSystem.SetNWVar(self,var,value)
end

function ENT:SetSize(l,w)
	self:SetLength(l)
	self:SetWidth(w)
end

function ENT:GetPassCountMult()
	if !AtmosGlobal then return 1 end
	
	--[[local time = AtmosGlobal:GetTime()
	
	if time>12 then
		return 1/((time-12)/12*5)
	else
		return 1/((12-time)/12*5)
	end]]
	
	return 1
end

function ENT:GetMaxPassCount()
	local x = math.floor(self:GetLength()/self.PassSize.x)
	local y = math.floor(self:GetWidth()/self.PassSize.y)

	return math.floor(x*y*self:GetPassCountMult()*(self:GetPassCountPercent()/100))
end

function ENT:CanPassReachGoal(cur,goal,route)
	local curent = Trolleybus_System.Routes.StopEnts[cur]
	if !IsValid(curent) then return false end

	local goalent = Trolleybus_System.Routes.StopEnts[goal]
	if !IsValid(goalent) then return false end

	for k,v in pairs(route and {[route] = curent.RoutesBelonging[route]} or curent.RoutesBelonging) do
		if !goalent.RoutesBelonging[k] then continue end

		local data = Trolleybus_System.Routes.Routes[k]
		if !data then continue end

		for k2,v2 in pairs(v) do
			local gv2 = goalent.RoutesBelonging[k][k2]
			if !gv2 then continue end

			if !data.Dirs[k2] or data.Dirs[k2].Stops[v2]!=cur or data.Dirs[k2].Stops[gv2]!=goal then continue end

			if data.Circular or v2<gv2 then return true end
		end
	end

	return false
end

function ENT:GetPassengersForTrolleybus(bus)
	local route = bus:GetMainTrolleybus():GetRouteNum()
	local passengers = {}
	
	for k,v in ipairs(self.Passengers) do
		if self:CanPassReachGoal(self:GetID(),v.GoalStop,route) then passengers[#passengers+1] = v end
	end
	
	return passengers
end

function ENT:Think()
	local delta = CurTime()-self.LastTime
	self.LastTime = CurTime()

	self:SetupTrolleybuses()
	
	local busids = {}
	
	for bus,route in RandomPairs(self.CurrentTrolleybuses) do
		busids[#busids+1] = bus:EntIndex()
		
		local openeddoors
		
		if !self.EndRoutes[route] and self:GetPassCount()>0 and !bus.ExpelPassengers[self] and bus:GetVelocity():Length()<5 and self:IsTrolleybusRouteRight(bus) then
			local tofill = bus.PassCapacity-bus:GetPassCount()
			
			if tofill>0 then
				openeddoors = 0
				
				for k,v in pairs(bus.DoorsData) do
					if !v.nopass and bus:DoorIsOpened(k) then openeddoors = openeddoors+1 end
				end
				
				if openeddoors>0 then
					local passengers = self:GetPassengersForTrolleybus(bus)
					
					if #passengers>0 then
						for i=1,math.min(#passengers,tofill,openeddoors) do
							local passenger = passengers[i]
							
							table.RemoveByValue(self.Passengers,passenger)
							self:SetPassCount(self:GetPassCount()-1)
							
							bus.Passengers[#bus.Passengers+1] = passenger
							bus:SetPassCount(bus:GetPassCount()+1)
						end
					end
				end
			end
		end
		
		if bus:GetPassCount()>0 and bus:GetVelocity():Length()<5 then
			if !openeddoors then
				openeddoors = 0
				
				for k,v in pairs(bus.DoorsData) do
					if !v.nopass and bus:DoorIsOpened(k) then openeddoors = openeddoors+1 end
				end
			end
			
			if openeddoors>0 then
				local maxout = math.min(openeddoors,bus:GetPassCount())
				local out = 0
				
				for k,v in ipairs(bus.Passengers) do
					if self.EndRoutes[route] or bus.ExpelPassengers[self] or v.GoalStop==self:GetID() or !Trolleybus_System.Routes.StopEnts[v.GoalStop] then
						table.RemoveByValue(bus.Passengers,v)
						bus:SetPassCount(bus:GetPassCount()-1)
						
						out = out+1
						
						if self:GetPassCount()<self:GetMaxPassCount() and bus.ExpelPassengers[self] and self:CanPassReachGoal(self:GetID(),v.GoalStop) then
							self.Passengers[#self.Passengers+1] = v
							v:StopUpdate()

							self:SetPassCount(self:GetPassCount()+1)
						end
					end
					
					if out>=maxout then break end
				end
				
				net.Start("TrolleybusSystem.Stop.PassOut",true)
					net.WriteEntity(self)
					net.WriteEntity(bus)
					net.WriteUInt(out,8)
				net.SendPVS(bus:WorldSpaceCenter())
			end
		end
	end
	
	self:SetNWVar("CurrentTrolleybuses",table.concat(busids," "))
	
	local maxpasscount = self:GetMaxPassCount()
	while self:GetPassCount()>maxpasscount do
		table.remove(self.Passengers,math.random(1,#self.Passengers))
		self:SetPassCount(self:GetPassCount()-1)
	end

	local i = 1
	while i<=#self.Passengers do
		if #busids>0 then
			self.Passengers[i].LeaveTime = self.Passengers[i].LeaveTime+delta
		elseif CurTime()>=self.Passengers[i].LeaveTime then
			table.remove(self.Passengers,i)
			self:SetPassCount(self:GetPassCount()-1)

			continue
		end

		i = i+1
	end
	
	Trolleybus_System.UpdateStopsPassengersSpawn()
	
	Trolleybus_System.UpdateTransmit(self,"TrolleybusStopDrawDistance")

	self:NextThink(CurTime()+math.Rand(0.25,0.75))
	
	return true
end

function ENT:IsTrolleybusRouteRight(bus)
	if !Trolleybus_System.GetAdminSetting("trolleybus_stop_route_check") then return true end

	local num = bus:GetMainTrolleybus():GetRouteNum()
	if !num then return false end
	
	return self:GetRoutes()[num]
end

function ENT:IsTrolleybusInBounds(bus)
	local lpos,lang = WorldToLocal(bus:WorldSpaceCenter(),bus:GetAngles(),self:GetPos(),self:GetAngles())
	
	return lpos.x>50 and lpos.x<350 and math.abs(lpos.z)<150 and math.abs(lpos.y)<self:GetLength()/2+bus:BoundingRadius() and
	math.abs(lang.p)<45 and math.abs(lang.r)<45 and math.abs(lang.y+90)<45
end

function ENT:SetupTrolleybuses()
	local cur = self.CurrentTrolleybuses
	local t = {}

	for k,v in ipairs(ents.FindByClass("trolleybus_ent_*")) do
		if !self:IsTrolleybusInBounds(v) then
			local otherbus = v.IsTrailer and v:GetTrolleybus() or v:GetTrailer()
			
			if !IsValid(otherbus) or !self:IsTrolleybusInBounds(otherbus) then
				continue
			end
		end
		
		t[v] = true
		
		local num = v:GetMainTrolleybus():GetRouteNum()
		
		if !cur[v] then
			self:OnTrolleybusArrived(v,num)
		end
		
		cur[v] = num
	end
	
	for k,v in pairs(cur) do
		if !t[k] then
			cur[k] = nil
			self:OnTrolleybusLeft(k,v)
		end
	end
end

function ENT:OnTrolleybusArrived(bus,route)
	bus.ExpelPassengers[self] = false

	Trolleybus_System.RunEvent("Stop_TrolleybusArrived",self,bus,route)
end

function ENT:OnTrolleybusLeft(bus,route)
	if IsValid(bus) then
		bus.ExpelPassengers[self] = nil
	end

	Trolleybus_System.RunEvent("Stop_TrolleybusLeft",self,bus,route)
end

function ENT:OnRemove()
	Trolleybus_System.StopsPassengersSpawn.Stops = math.max(0,Trolleybus_System.StopsPassengersSpawn.Stops-1)
end

local PASSENGER = {
	Init = function(self,goalstop)
		self.GoalStop = goalstop
		self:StopUpdate()
	end,
	StopUpdate = function(self)
		self.LeaveTime = CurTime()+math.random(60*5,60*10)
	end,
}

function Trolleybus_System.CreateNewPassenger(goalstop)
	local pass = setmetatable({},{__index = PASSENGER})
	pass:Init(goalstop)

	return pass
end

function Trolleybus_System.UpdateStopsPassengersSpawn()
	local dt = Trolleybus_System.StopsPassengersSpawn
	
	if dt.Stops>0 and CurTime()>=dt.NextSpawn then
		local stops = Trolleybus_System.Routes.StopEnts
		local dest,destid = table.Random(stops)
		
		if dest then
			local starts = {}

			for k,v in pairs(stops) do
				if v:CanPassReachGoal(v:GetID(),destid) then
					starts[#starts+1] = v
				end
			end

			if #starts>0 then
				local start = starts[math.random(#starts)]

				if start:GetPassCount()<start:GetMaxPassCount() then
					start.Passengers[#start.Passengers+1] = Trolleybus_System.CreateNewPassenger(destid)
					start:SetPassCount(start:GetPassCount()+1)
				end
			end
		end
		
		dt.NextSpawn = CurTime()+math.random(dt.Rate[1],dt.Rate[2])/dt.Stops
	end
end

function Trolleybus_System.TrolleybusExpelPassengers(bus)
	for k,v in pairs(bus.ExpelPassengers) do
		bus.ExpelPassengers[k] = true
	end
	
	if IsValid(bus:GetTrailer()) then
		bus = bus:GetTrailer()
		
		for k,v in pairs(bus.ExpelPassengers) do
			bus.ExpelPassengers[k] = true
		end
	end
end

concommand.Add("trolleybus_expel_passengers",function(ply,cmd,args,str)
	if !IsValid(ply) or !Trolleybus_System.PlayerInDriverPlace(nil,ply) then return end
	
	Trolleybus_System.TrolleybusExpelPassengers(Trolleybus_System.GetSeatTrolleybus(ply:GetVehicle()))
end,nil,"Высаживает пассажиров с троллейбуса")