-- Copyright © Platunov I. M., 2020 All rights reserved

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local IsButtonDown = Trolleybus_System.IsControlButtonDown

ENT.AllowKeyboardReverseChange = true
ENT.AllowKeyboardHandbrakeToggle = true
ENT.TrolleyPoleAngleLimits = {1,-90,90}

AccessorFunc(ENT,"PoleCatchingActive","PoleCatchingActive",FORCE_BOOL)
AccessorFunc(ENT,"PoleCatchingFractionLeft","PoleCatchingFractionLeft",FORCE_NUMBER)
AccessorFunc(ENT,"PoleCatchingFractionRight","PoleCatchingFractionRight",FORCE_NUMBER)
AccessorFunc(ENT,"ElectricCurrentUsage","ElectricCurrentUsage",FORCE_NUMBER)

function ENT:SetPoleCatchingFraction(fr,right)
	if right then
		self:SetPoleCatchingFractionRight(fr)
	else
		self:SetPoleCatchingFractionLeft(fr)
	end
end

function ENT:GetPoleCatchingFraction(right)
	if right then
		return self:GetPoleCatchingFractionRight()
	else
		return self:GetPoleCatchingFractionLeft()
	end
end

function ENT:Initialize()
	self.SpawnTime = self:GetCreationTime()
	self.UpdateTime = CurTime()
	self.DeltaTime = 0
	self.Passengers = {}
	self.ExpelPassengers = {}
	self.WheelsDontStop = true
	self.SpawnSettingsReceive = 0
	
	self.m_PanelsData = {}
	for k,v in pairs(self.PanelsData or {}) do self.m_PanelsData[k] = v end
	
	self.m_ButtonsData = {}
	for k,v in pairs(self.ButtonsData or {}) do self.m_ButtonsData[k] = v end
	
	self.m_OtherPanelEntsData = {}
	for k,v in pairs(self.OtherPanelEntsData or {}) do self.m_OtherPanelEntsData[k] = v end

	self:SetModel(self.Model)
	
	if !self:PhysicsInit(SOLID_VPHYSICS) then
		print("Trolleybus System: Failed to create physics object for "..self:GetClass().." with model "..self.Model)
		self:Remove()
		
		return
	end
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self.phys = self:GetPhysicsObject()
	self.phys:SetMass(self.Mass/3*2)
	
	self:SetupSpawnSettings()
	self:SetupWheels()
	self:SetupSeats()
	self:SetupButtons()
	self:SetupLights()
	self:SetupInformator()
	self:SetupSystems()
	
	self:SetHandbrakeActive(true)
	self:SetPoleStateLeft(2)
	self:SetPoleStateRight(2)
	self:SetPoleCatchingActive(false)
	self:SetPoleCatchingFractionLeft(1)
	self:SetPoleCatchingFractionRight(1)
	self:SetPoleMoveAngLeft(self.TrolleyPoleDownedAngleLeft)
	self:SetPoleMoveAngRight(self.TrolleyPoleDownedAngleRight)
	
	self.Controls = {
		WActive = false,
		SActive = false,
		Reset = false,
		Handbrake = false,
		ReverseForward = false,
		ReverseBackward = false,
		FullBrake = false,
		
		StartPedal = 0,
		BrakePedal = 0,
		
		Steer = 0,
		SteerActive = false,
	}
	
	self.OldControls = table.Copy(self.Controls)
	
	if self.HasPoles then
		self:SetupPoles()
	end
	
	if self.TrailerData then
		local dt = self.TrailerData
	
		local p,a = LocalToWorld(dt.pos,dt.ang,self:GetPos(),self:GetAngles())
		local veh = ents.Create(dt.class)
		
		if IsValid(veh) then
			veh:SetPos(p)
			veh:SetAngles(a)
			
			veh.SpawnSettings = self.SpawnSettings
			veh.CustomSpawnSettings = self.CustomSpawnSettings
			Trolleybus_System.SetOwner(veh,self.Owner)
			
			veh:Spawn()
		
			self:DeleteOnRemove(veh)
			veh:DeleteOnRemove(self)
			veh:SetTrolleybus(self)
			self:SetTrailer(veh)
			
			local bs = dt.ballsocket
			
			local p1 = veh:LocalToWorld(bs.trailerlpos)
			local p2 = self:LocalToWorld(bs.lpos)
			local p = p1+(p2-p1)/2
			local lp1 = p-(p1-p2):GetNormalized()
			local lp2 = p-(p2-p1):GetNormalized()
			
			local constraint = constraint.AdvBallsocket(veh,self,0,0,veh:WorldToLocal(lp1),self:WorldToLocal(lp2),0,0,bs.rlimits[1],bs.plimits[1],bs.ylimits[1],bs.rlimits[2],bs.plimits[2],bs.ylimits[2],0,0,0,0,1)
			if !constraint then
				self:Remove()
				return
			end

			constraint:DeleteOnRemove(self)
		else
			self:Remove()
		end
	end
	
	Trolleybus_System.UpdateTransmit(self,"TrolleybusDrawDistance")
	
	if Trolleybus_System.GetAdminSetting("trolleybus_spawn_notify") and ulx and IsValid(self.Owner) and !self.IsTrailer then
		local where,where2,dist = "",""
		
		for k,v in pairs(ents.FindByClass("trolleybus_stop")) do
			local d = self:GetPos():Distance(v:GetPos())
			
			if d<2000 and (!dist or d<dist) then
				where,where2,dist = "near",v:GetSVName(),d
			end
		end
	
		ulx.fancyLogAdmin(self.Owner,"#A spawned trolleybus #s "..where.." #s",self.PrintName,where2)
	end
end

function ENT:SetupSpawnSettings()
	local send = false
	
	if self._SpawnSettings then
		for k,v in ipairs(self._SpawnSettings) do
			if self.SpawnSettings and self.SpawnSettings[k] and self.SpawnSettings[k].unload then
				self.SpawnSettings[k].unload(self,v)
			end
			
			if self:GetNWVar("SpawnSetting_"..k)!=nil then
				self:SetNWVar("SpawnSetting_"..k,nil)
				send = true
			end
		end
	end
	
	self._SpawnSettings = {}
	self._SpawnSettingsNames = {}
	
	local custom = self.CustomSpawnSettings
	
	if self.SpawnSettings then
		for k,v in ipairs(self.SpawnSettings) do
			local value = v.default
			local cust = false
		
			if custom and custom[k]!=nil and custom[k]!=value then
				value = custom[k]
				cust = true
			end
			
			if v.type=="ComboBox" then
				if isnumber(value) then
					if !v.choices[value] then value = v.default end
				else
					for k,v in ipairs(v.choices) do
						if v.value!=nil and v.value==value then
							value = k
							break
						end
					end
					
					if !isnumber(value) then value = v.default end
				end
				
				if v.choices[value].value!=nil then
					value = v.choices[value].value
				end
			elseif v.type=="CheckBox" then
				value = tobool(value)
			elseif v.type=="Slider" then
				value = math.Clamp(tonumber(value) or v.default,v.min,v.max)
			elseif v.type=="Skin" then
				local v = tostring(value):sub(1,1024)
				local parts = {}

				for _,part in ipairs(string.Explode("&",v)) do
					local kv = string.Explode("=",part)
					if #kv<2 then continue end

					parts[kv[1]:gsub("[^%w_%.%-]",""):sub(1,64)] = kv[2]:gsub("[^%w_%.%-]",""):sub(1,64)
				end

				local iparts = {}
				for k,v in pairs(parts) do
					iparts[#iparts+1] = k.."="..v
				end

				value = table.concat(iparts,"&")
			end
			
			self._SpawnSettings[k] = value
			
			if v.alias then
				self._SpawnSettingsNames[v.alias] = k
			end
			
			if cust then
				send = true
				self:SetNWVar("SpawnSetting_"..k,value)
			end
			
			if self.SystemsLoaded and v.setup then v.setup(self,value) end
		end
	end
	
	if send or self.SpawnSettingsReceive==0 then
		self.SpawnSettingsReceive = self.SpawnSettingsReceive+1
		self:SetNWVar("SpawnSettingsReceive",self.SpawnSettingsReceive)
	end
end

function ENT:SetupPoles()
	self.PolesData = {}

	for i=-1,1,2 do
		local right = i==1
		local t = {}
		local p,a = LocalToWorld(self.TrolleyPoleCatcherPos+Vector(0,self.TrolleyPoleCatcherDist or Trolleybus_System.OverheadLinesDist,0)*(right and -1 or 1),self.TrolleyPoleCatcherAng,self:GetPos(),self:GetAngles())
	
		t.PoleCatcher = ents.Create("trolleybus_polecatcher")
		t.PoleCatcher:SetPos(p)
		t.PoleCatcher:SetAngles(a)
		t.PoleCatcher.Trolleybus = self
		t.PoleCatcher.Left = !right
		t.PoleCatcher:Spawn()
		
		constraint.NoCollide(t.PoleCatcher,self,0,0)
		self:DeleteOnRemove(t.PoleCatcher)
		Trolleybus_System.SetOwner(t.PoleCatcher,self.Owner)
	
		self.PolesData[right and "Right" or "Left"] = t
	end
end

function ENT:SetupLights()
	self.Lights = {}
	
	for k,v in pairs(self.InteriorLights) do
		local light = ents.Create("light_dynamic")
		light:SetParent(self)
		light:SetLocalPos(v.pos)
		light:SetKeyValue("_light",Format("%i %i %i 255",v.color.r,v.color.g,v.color.b))
		light:SetKeyValue("distance",200)
		light:SetKeyValue("style",1)
		light:SetKeyValue("brightness",6)
		light:Spawn()
		light:Fire("TurnOff")
		light:SetNoDraw(true)
		
		Trolleybus_System.SetOwner(light,self.Owner)
		
		self.Lights[k] = light
		self:DeleteOnRemove(light)
		self:SetNWVar("InteriorLight"..k,light:EntIndex())
	end
end

function ENT:SetupButtons()
	self.Buttons = {}
	
	for k,v in pairs(self.m_ButtonsData) do
		self:SetNWVar("Buttons."..k,false)
		
		self.Buttons[k] = {
			Cfg = v,
			PressedBy = {},
		}
	end
end

function ENT:SetupSeats()
	if !self.IsTrailer then
		local ddata = self.DriverSeatData

		local driver = ents.Create("prop_vehicle_prisoner_pod")
		driver:SetModel("models/nova/jeep_seat.mdl")
		driver:SetKeyValue("limitview","0")
		driver:SetPos(self:LocalToWorld(ddata.Pos))
		driver:SetAngles(self:LocalToWorldAngles(ddata.Ang-Angle(0,90,0)))
		driver:SetCameraDistance(10)
		driver:Spawn()
		driver:GetPhysicsObject():SetMass(1)
		driver:SetCollisionGroup(COLLISION_GROUP_WORLD)
		driver:DrawShadow(false)
		driver:SetNoDraw(true)
		driver.ExitPos = self.DriverSeatExitPos
		Trolleybus_System.NetworkSystem.SetNWVar(driver,"SeatID",-1)
		Trolleybus_System.NetworkSystem.SetNWVar(driver,"Trolleybus",self:EntIndex())
		Trolleybus_System.NetworkSystem.SetNWVar(driver,"CanPressTrolleyButtons",true)
		self:DeleteOnRemove(driver)
		
		Trolleybus_System.SetOwner(driver,self.Owner)
		
		constraint.Weld(driver,self,0,0,0,true,true)
		
		self:SetDriverSeat(driver)
	end
	
	for k,v in ipairs(self.OtherSeats) do
		local seat = ents.Create("prop_vehicle_prisoner_pod")
		seat:SetModel(v.Type==0 and "models/nova/jeep_seat.mdl" or v.Type==1 and "models/vehicles/prisoner_pod_inner.mdl")
		seat:SetKeyValue("limitview","0")
		seat:SetPos(self:LocalToWorld(v.Pos))
		seat:SetAngles(self:LocalToWorldAngles(v.Ang))
		seat:SetCameraDistance(10)
		seat:Spawn()
		seat:GetPhysicsObject():SetMass(1)
		seat:SetCollisionGroup(COLLISION_GROUP_WORLD)
		seat:DrawShadow(false)
		seat:SetNoDraw(true)
		seat.ExitPos = v.ExitPos
		Trolleybus_System.NetworkSystem.SetNWVar(seat,"SeatID",k)
		Trolleybus_System.NetworkSystem.SetNWVar(seat,"SeatType",v.Type)
		Trolleybus_System.NetworkSystem.SetNWVar(seat,"Trolleybus",self:EntIndex())
		Trolleybus_System.NetworkSystem.SetNWVar(seat,"CanPressTrolleyButtons",true)
		self:DeleteOnRemove(seat)
		
		Trolleybus_System.SetOwner(seat,self.Owner)
		
		constraint.Weld(seat,self,0,0,0,true,true)
	end
end

function ENT:SetupWheels()
	self.Wheels = {}
	
	local wmass,wcount = self.Mass/3,0
	
	for k,v in ipairs(self.WheelsData) do
		wcount = wcount+#v.Wheels
	end
	
	wmass = wmass/wcount
	
	for k,v in ipairs(self.WheelsData) do
		local data = {
			Drive = v.Drive,
			Turn = v.Turn,
			Wheels = {},
			RotationData = v.Drive and {Rotation = 0,Spd = 0,Wheels = 0,Diff = {}},
		}
		
		for k2,v2 in ipairs(v.Wheels) do
			local wheel = Trolleybus_System.CreateWheel(self,v2.Type,v2.Pos,Angle(0,0,0),v2.Height,v2.Constant,v2.Damping,v2.RDamping,v2.Times,v.Drive,v2.Right,wmass)
			wheel.WheelsGroup = k
			wheel.WheelsGroupWheel = k2
			
			data.Wheels[k2] = wheel
			
			if v.Drive then
				data.RotationData.Diff[k2] = 0
			end
		end
		
		self.Wheels[k] = data
	end
	
	for _,data in ipairs(self.Wheels) do
		for k,v in ipairs(data.Wheels) do
			for _,data2 in ipairs(self.Wheels) do
				for k2,v2 in ipairs(data2.Wheels) do
					if v==v2 then continue end
					
					constraint.NoCollide(v,v2,0,0)
				end
			end
			
			v.phys:EnableMotion(true)
		end
	end
end

function ENT:SetupInformator()
	self.InformatorData = {
		Playlines = {},
		Sound = "",
		SoundID = 0,
		Length = 0,
		Time = CurTime(),
	}
end

function ENT:SetTurn(ang)
	if self._WheelTurn!=ang then
		self._WheelTurn = ang
	
		for _,data in ipairs(self.Wheels) do
			if !data.Turn then continue end
			
			for k,v in ipairs(data.Wheels) do
				v:SetRotate(ang)
			end
		end
	end
end

function ENT:OpenDoor(name,force)
	if self:DoorIsOpened(name) then return false end

	if force or self:CanDoorsMove(name) then
		self:SetNWVar("Doors."..name,true)
		self:OnDoorMove(name,true)
		
		self:SetNWVar("MoveDoorHand."..name,false)
		
		return true
	end
	
	return false
end

function ENT:CloseDoor(name,force)
	if !self:DoorIsOpened(name) then return false end

	if force or self:CanDoorsMove(name) then
		self:SetNWVar("Doors."..name,false)
		self:OnDoorMove(name,false)
		
		self:SetNWVar("MoveDoorHand."..name,false)
		
		return true
	end
	
	return false
end

function ENT:OpenDoorWithHand(name)
	local prev = self:GetNWVar("MoveDoorHand."..name)
	self:SetNWVar("MoveDoorHand."..name,true)
	self:SetNWVar("MoveDoorHand."..name,self:OpenDoor(name,true) or prev)
end

function ENT:CloseDoorWithHand(name)
	local prev = self:GetNWVar("MoveDoorHand."..name)
	self:SetNWVar("MoveDoorHand."..name,true)
	self:SetNWVar("MoveDoorHand."..name,self:CloseDoor(name,true) or prev)
end

function ENT:CanDoorsMove(name)
	local sysvalue = self:SystemsHook("CanDoorsMove",name)
	if sysvalue!=nil then return sysvalue end

	return true
end

function ENT:OnDoorMove(name,opened)
	self:SystemsEvent(true,"OnDoorMove",name,opened)
	Trolleybus_System.RunChangeEvent("Trolleybus_DoorState",!opened,opened,self,name)
end

function ENT:ControlPoles()
	for i=-1,1,2 do
		local right = i==1
		local t = self.PolesData[!right and "Left" or "Right"]
		local state = self:GetPoleState(right)

		local lastwheelang = t.LastWheelAng
		t.LastWheelAng = nil

		if state==0 then
			local polepos = self:GetPolePos(right)
			local oldcontact,oldwire = self:GetPoleContactWire(right)
			local oldendpos = self:GetPoleAngInversion(right)

			local data = Trolleybus_System.ContactNetwork.GetCurrentContactWire(polepos,self.TrolleyPoleLength,oldcontact,oldwire,oldendpos)
			local pos,wheelang,poleang,contact,wire

			if data then
				pos,wheelang,contact,wire,endpos = data.Pos,data.Ang,data.Contact,data.Wire,data.EndPos
				poleang = (pos-polepos):Angle()

				if contact!=oldcontact or wire!=oldwire then self:SetPoleContactWire(contact,wire,right) end
				if endpos!=oldendpos then self:SetPoleAngInversion(endpos,right) end

				local curang = self:WorldToLocalAngles(poleang)
				t.LastPoleAngVel = Vector(math.NormalizeAngle(curang.p-t.LastPoleAng.p),math.NormalizeAngle(curang.y-t.LastPoleAng.y))/self.DeltaTime
				t.LastPoleVel = self.phys:GetVelocityAtPoint(polepos)
				t.LastPoleAng = curang

				if oldcontact!=contact then
					local oldobject = Trolleybus_System.ContactNetwork.GetObject(oldcontact)
					if oldobject then
						oldobject:OnWheelChangedContactFrom(self,t.LastWheelPos or pos,oldwire)
					end

					local object = Trolleybus_System.ContactNetwork.GetObject(contact)
					if object then
						object:OnWheelChangedContactTo(self,pos,wire)
					end
				elseif oldwire!=wire then
					local object = Trolleybus_System.ContactNetwork.GetObject(contact)
					if object then
						object:OnWheelChangedWire(self,t.LastWheelPos or pos,pos,oldwire,wire)
					end
				end
			end
			
			t.LastPolePos = polepos
			t.LastWheelPos = pos
			t.LastWheelAng = wheelang
			
			local flyoff = false
			
			local lpoleang = pos and self:WorldToLocalAngles(poleang)
			if
				pos and
				lpoleang.p<self.TrolleyPoleAngleLimits[1] and
				math.NormalizeAngle(lpoleang.y+180)>self.TrolleyPoleAngleLimits[2] and
				math.NormalizeAngle(lpoleang.y+180)<self.TrolleyPoleAngleLimits[3]
			then
				if lastwheelang and (oldcontact!=contact or oldwire!=wire) and Trolleybus_System.GetAdminSetting("trolleybus_poles_speed_check") then
					local dot = lastwheelang:Forward():Dot(wheelang:Forward())
					
					if dot<0 then
						flyoff = true
					else
						local radians = math.acos(dot)
						local mp = math.tan(math.pi/2-radians)
						local maxspeed = 15*mp	-- max 15 km/h on 45 degrees angle
						local speed = math.abs(self:GetMoveSpeed())
						
						if speed>maxspeed then
							flyoff = true
						end
					end
				end

				if !flyoff and (oldcontact!=contact or oldwire!=wire) then
					local obj = Trolleybus_System.ContactNetwork.GetObject(contact)
					local chance = obj and obj:GetChanceToFlyOffPole(self,oldcontact==contact and oldwire or nil,wire,math.abs(self:GetMoveSpeed()))

					if chance and math.Rand(0,100)<chance then
						flyoff = true
					end
				end
			else
				flyoff = true
			end
			
			if flyoff then
				Trolleybus_System.ForceFlyOffPole(self,right)
				state = self:GetPoleState(right)
			end
		end
		
		t.LastPoleAngVel = t.LastPoleAngVel or Vector()
		
		if state!=0 then
			if state==1 and self:GetMainTrolleybus():GetPoleCatchingActive() then
				self:SetPoleState(4,right)
				self:SetPoleStateTime(CurTime(),right)
				
				state = 4
			elseif state==4 and !self:GetMainTrolleybus():GetPoleCatchingActive() then
				self:SetPoleState(1,right)
				self:SetPoleStateTime(CurTime(),right)
				
				state = 1
			end
			
			if state==1 or state==4 then
				local polepos = self:GetPolePos()
				local curpos = polepos+self:LocalToWorldAngles(self:GetPoleMoveAng(right)):Forward()*self.TrolleyPoleLength
				local curvel = self.phys:GetVelocityAtPoint(curpos)
				
				if t.LastPolePos and t.LastWheelPos then
					local diff = WorldToLocal(t.LastPoleVel-curvel*1.005,angle_zero,vector_origin,Angle(0,self:LocalToWorldAngles(self:GetPoleMoveAng(right)).y,0))
					
					t.LastPoleAngVel.x = t.LastPoleAngVel.x+diff.x/4-diff.z/4
					t.LastPoleAngVel.y = t.LastPoleAngVel.y+diff.y/2
				end
				
				t.LastPolePos = polepos
				t.LastPoleVel = curvel
				t.LastWheelPos = curpos
				
				self:ControlPolePhysics(t.LastPoleAngVel,state==4 and self:GetMainTrolleybus():GetPoleCatchingFraction(right) or 0,self.DeltaTime,right)
			else
				t.LastPoleAngVel:Zero()
				t.LastPolePos = nil
				t.LastPoleVel = nil
				t.LastWheelPos = nil
				
				if state==2 then
					self:SetPoleMoveAng(right and self.TrolleyPoleDownedAngleRight or self.TrolleyPoleDownedAngleLeft,right)
				end
			end
		end
		
		t.PrevWheelPos = self:GetPolePos(right)+self:LocalToWorldAngles(state==0 and t.LastPoleAng or self:GetPoleMoveAng(right)):Forward()*self.TrolleyPoleLength
	end

	self:SetPowerFromCN(self:CalcPowerFromCN())

	local oldusage,usage = self:GetElectricCurrentUsage(),self:CalcElectricCurrentUsage()
	self:SetElectricCurrentUsage(usage)

	if Trolleybus_System.GetAdminSetting("trolleybus_poles_electric_arc_check") then
		self:ControlElectricArc(oldusage or 0)
	end
	
	local otherbus = self.IsTrailer and self:GetTrolleybus() or self:GetTrailer()
	if IsValid(otherbus) and !otherbus.HasPoles then
		otherbus:SetPoleState(self:GetPoleState(false),false)
		otherbus:SetPoleState(self:GetPoleState(true),true)
		
		local contact,wire = self:GetPoleContactWire(false)
		otherbus:SetPoleContactWire(contact,wire,false)
		local contact,wire = self:GetPoleContactWire(true)
		otherbus:SetPoleContactWire(contact,wire,true)
		
		otherbus:SetPowerFromCN(self:GetPowerFromCN())
		otherbus:SetElectricCurrentUsage(usage)
	end
end

function ENT:ControlPolePhysics(vel,catchfr,dt,right)
	local ang = self:GetPoleMoveAng(right)
	local upmax = Trolleybus_System.MaxTrolleybusPolesUpAng
	
	local up = upmax<ang.p and (upmax-ang.p)*15 or 0
	local gravity = math.cos(math.rad(ang.p))*200
	local catchy = 0
	
	if catchfr>0 then
		local catchang = right and self.TrolleyPoleCatcheredAngleRight or self.TrolleyPoleCatcheredAngleLeft
		
		up = up*(1-catchfr)+(math.NormalizeAngle(catchang.p-ang.p)*(catchang.p-ang.p>0 and 20 or 50)-gravity)*catchfr
		catchy = math.NormalizeAngle(catchang.y-ang.y)*50*catchfr
	end
	
	vel.x = vel.x+(up+gravity)*dt
	vel.x = vel.x-vel.x*dt*(2+catchfr*3)
	
	vel.y = vel.y+(catchy)*dt
	vel.y = vel.y-vel.y*dt*(0.5+catchfr*4.5)
	
	vel.x = math.Clamp(vel.x,-360,360)
	vel.y = math.Clamp(vel.y,-360,360)
	
	local plimitn,plimitx = -89,math.min(self.TrolleyPoleAngleLimits[1],89)
	local ylimitn,ylimitx = self.TrolleyPoleAngleLimits[2],self.TrolleyPoleAngleLimits[3]
	local prange,yrange = plimitx-plimitn,ylimitx-ylimitn
	
	local addp = vel.x*dt
	
	while true do
		ang.p = ang.p+addp
		
		if ang.p>plimitx then
			addp = -(math.abs(addp)-(ang.p-plimitx))
			vel.x = -vel.x
			
			ang.p = plimitx
		elseif ang.p<plimitn then
			addp = math.abs(addp)-(plimitn-ang.p)
			vel.x = -vel.x
			
			ang.p = plimitn
		else
			break
		end
	end
	
	local addy = vel.y*dt
	ang.y = math.NormalizeAngle(ang.y+180)
	
	while true do
		ang.y = ang.y+addy
		
		if ang.y>ylimitx then
			addy = -(math.abs(addy)-(ang.y-ylimitx))
			vel.y = -vel.y
			
			ang.y = ylimitx
		elseif ang.y<ylimitn then
			addy = math.abs(addy)-(ylimitn-ang.y)
			vel.y = -vel.y
			
			ang.y = ylimitn
		else
			break
		end
	end
	
	ang.y = math.NormalizeAngle(ang.y+180)
	ang.r = 0
	
	self:SetPoleMoveAng(ang,right)
end

function ENT:ControlElectricArc(oldcurrentusage)
	local contact,wire = self:GetPoleContactWire(false)
	local state = self:GetPoleState(false)==0
	local volt = state and Trolleybus_System.ContactNetwork.GetContactWireVoltage(contact,wire) or 0

	if !self._ElectricArcLastVolt or volt!=self._ElectricArcLastVolt or CurTime()-self._ElectricArcLastVoltTime>0.15 then
		self._ElectricArcLastVoltDiff = math.abs(volt-(self._ElectricArcLastVolt or 0))
		self._ElectricArcLastVolt = volt
		self._ElectricArcLastVoltTime = CurTime()
	end

	if oldcurrentusage-self:GetElectricCurrentUsage()>30 and self._ElectricArcLastVoltDiff>100 then
		local object = Trolleybus_System.ContactNetwork.GetObject(contact)
		local allow = object:AllowElectricArcsOnWire(wire)

		if allow then
			local pos = self.PolesData["Left"].PrevWheelPos
			if pos then
				Trolleybus_System.ElectricSpark(pos)
				Trolleybus_System.RunEvent("Trolleybus_OnElectricArc",self)
			end
		end
	end
end

function ENT:SetupControls()
	local ply = self:GetDriver()
	local dt = self.DeltaTime
	local C = self.Controls
	local OC = self.OldControls
	
	local active = IsValid(ply) and !IsButtonDown(ply,"viewmove")
	
	C.WActive = active and IsButtonDown(ply,"acceleration")
	C.SActive = active and IsButtonDown(ply,"deceleration")
	C.Reset = active and IsButtonDown(ply,"drop")
	C.Handbrake = active and (IsButtonDown(ply,"handbrake") or Trolleybus_System.GetPlayerSetting(ply,"UseExternalButtons") and Trolleybus_System.IsExternalButtonDown(ply,"Handbrake"))
	C.ReverseForward = active and IsButtonDown(ply,"reverseforward")
	C.ReverseBackward = active and IsButtonDown(ply,"reversebackward")
	C.FullBrake = active and IsButtonDown(ply,"fullbrake")
	
	if self.AllowKeyboardHandbrakeToggle and C.Handbrake and !OC.Handbrake then
		self:ToggleHandbrake()
	end
	
	self:SetupControls_Pedals(ply,dt,C,OC)
	self:SetupControls_Steer(ply,dt,C,OC)
	
	if self.AllowKeyboardReverseChange then
		if C.ReverseForward and !OC.ReverseForward then
			self:ChangeReverse(self:GetReverseState()+1)
		elseif C.ReverseBackward and !OC.ReverseBackward then
			self:ChangeReverse(self:GetReverseState()-1)
		end
	end
	
	self:SetRearLights((C.BrakePedal>0 and self:GetReverseState()==-1 and 3 or C.BrakePedal>0 and 1 or self:GetReverseState()==-1 and 2) or 0)
	self:SetTurn(C.Steer*self.WheelMaxTurn)
	if IsValid(self:GetTrailer()) then self:GetTrailer():SetTurn(C.Steer*self:GetTrailer().WheelMaxTurn) end
	
	for k,v in pairs(C) do
		OC[k] = v
	end
end

function ENT:SetupControls_Steer(ply,dt,C,OC)
	local boostfr = self:SystemsHook("GetSteerBoosterPowerFraction") or 0
	
	if Trolleybus_System.GetPlayerSetting(ply,"UseExternalSteer") then
		C.SteerActive = true
	
		local value = ply.TrolleybusDeviceInputData_steer
		
		if value and C.Steer!=value then
			local spd = 0.3+4.7*boostfr
			
			C.Steer = math[C.Steer<value and "min" or "max"](C.Steer+spd*(C.Steer<value and 1 or -1)*dt,value)
		end
		
		self:SetSteerAngle(C.Steer)
	else
		local active = IsValid(ply) and !IsButtonDown(ply,"viewmove")
		local spdmp = active and IsButtonDown(ply,"faststeer") and !IsButtonDown(ply,"mousesteer") and 2 or 1
		
		spdmp = spdmp*(0.3+0.7*boostfr)/(1+math.abs(self:GetMoveSpeed())/60)
		
		local spd = spdmp/2
		
		if active and IsButtonDown(ply,"mousesteer") then
			local y = math.AngleDifference(ply:EyeAngles().y,self:GetAngles().y)
		
			if !C.MouseSteerStartSteer then
				C.MouseSteerStartSteer = C.Steer
				C.MouseSteerStartY = y
			end
		
			C.SteerActive = true
			C.Steer = math.Clamp(C.MouseSteerStartSteer+(y-C.MouseSteerStartY)/30*spdmp,-1,1)
		else
			C.MouseSteerStartSteer = nil
			C.MouseSteerStartY = nil
		
			if active then
				if IsButtonDown(ply,"steerleft") or IsButtonDown(ply,"steerright") then
					C.Steer = math.Clamp(C.Steer+spd*(IsButtonDown(ply,"steerleft") and 1 or -1)*dt,-1,1)
					C.SteerActive = true
				elseif IsButtonDown(ply,"steerreturn") then
					C.SteerActive = false
				end
			end
		end
		
		if !C.SteerActive and C.Steer!=0 then
			C.Steer = math[C.Steer<0 and "min" or "max"](0,C.Steer+spd*(C.Steer<0 and 1 or -1)*dt)
		end
		
		self:SetSteerAngle(C.Steer)
	end
end

function ENT:SetupControls_Pedals(ply,dt,C,OC)
	if IsValid(ply) and !IsButtonDown(ply,"viewmove") then
		self:ControlPedals(ply,dt,C,OC)
	else
		C.StartPedal = 0
		C.BrakePedal = 0
	end
	
	self:SetStartPedal(C.StartPedal)
	self:SetBrakePedal(C.BrakePedal)
	
	if C.StartPedal>0 and OC.StartPedal==0 or C.BrakePedal>0 and OC.BrakePedal==0 then
		Trolleybus_System.PlayBassSoundSimple(self:GetDriverSeat(),self.PedalInSound or "trolleybus/pedal_in.mp3",100,0.5)
	elseif C.StartPedal==0 and OC.StartPedal>0 or C.BrakePedal==0 and OC.BrakePedal>0 then
		Trolleybus_System.PlayBassSoundSimple(self:GetDriverSeat(),self.PedalOutSound or "trolleybus/pedal_out.mp3",100,0.5)
	end
end

function ENT:ControlPedals(ply,dt,C,OC)
	self:SystemsEvent(false,"ControlPedals",ply,dt,C,OC)
end

function ENT:ToggleHandbrake()
	self:SetHandbrakeActive(!self:GetHandbrakeActive())
	
	//Trolleybus_System.PlayBassSoundSimple(self:GetDriverSeat(),"trolleybus/reverse_switch.mp3",100,0.5)
	
	return self:GetHandbrakeActive()
end

function ENT:ChangeReverse(state)
	if state>1 or state<-1 then return false end

	local C = self.Controls
	if C.StartPedal==0 and C.BrakePedal==0 then
		local old = self:GetReverseState()
		self:SetReverseState(state)

		Trolleybus_System.RunChangeEvent("Trolleybus_Reverse",old,state,self)
	
		//Trolleybus_System.PlayBassSoundSimple(self:GetDriverSeat(),self.ReverseSwitchSound or "trolleybus/reverse_switch.mp3",100,0.5)
		
		return true
	end
	
	return false
end

function ENT:CalcWheelFinalRotationSpeed(wheel,rspeed,dt)
	if !wheel.WheelsGroup then return end
	
	local group = self.Wheels[wheel.WheelsGroup]
	
	if group.Drive then
		local rotdata = group.RotationData
		
		if rotdata.Wheels==0 then
			self:PreDriveWheelsRotationUpdate(wheel.WheelsGroup,group,rotdata)
	
			if self.SystemsLoaded then
				for k,v in pairs(self:GetMainTrolleybus().Systems) do
					if v.GetWheelsControl then
						rotdata.Rotation = v:GetWheelsControl(rotdata.Rotation,true)
					end
				end
			end
		end
		
		local nspeed = rotdata.Rotation+rotdata.Diff[wheel.WheelsGroupWheel]
		
		if self.SystemsLoaded then
			for k,v in pairs(self:GetMainTrolleybus().Systems) do
				if v.GetWheelsBrake then
					nspeed = v:GetWheelsBrake(nspeed,true)
				end
			end
		end
		
		rotdata.Spd = rotdata.Spd+(rspeed+nspeed)/2
		rotdata.Wheels = rotdata.Wheels+1
		rotdata.Diff[wheel.WheelsGroupWheel] = rspeed-rotdata.Rotation
		
		if rotdata.Wheels==#group.Wheels then
			rotdata.Rotation = rotdata.Spd/rotdata.Wheels
			rotdata.Wheels = 0
			rotdata.Spd = 0
			
			local diff = 0
			for k,v in ipairs(rotdata.Diff) do
				diff = diff+v
			end
			diff = diff/#group.Wheels
			
			for k,v in ipairs(rotdata.Diff) do
				rotdata.Diff[k] = v-diff
			end
			
			self:PostDriveWheelsRotationUpdate(wheel.WheelsGroup,group,rotdata)
		end
		
		return nspeed
	end
	
	if self.SystemsLoaded then
		for k,v in pairs(self:GetMainTrolleybus().Systems) do
			if v.GetWheelsControl then
				rspeed = v:GetWheelsControl(rspeed,false)
			end
		end
		
		for k,v in pairs(self:GetMainTrolleybus().Systems) do
			if v.GetWheelsBrake then
				rspeed = v:GetWheelsBrake(rspeed,false)
			end
		end
		
		return rspeed
	end
end

function ENT:PreDriveWheelsRotationUpdate(group,data,rotdata)
	self:SystemsEvent(false,"PreDriveWheelsRotationUpdate",group,data,rotdata)
end

function ENT:PostDriveWheelsRotationUpdate(group,data,rotdata,dt)
	self:SystemsEvent(false,"PostDriveWheelsRotationUpdate",group,data,rotdata,dt)
end

function ENT:IsWheelsFullStop()
	return self:GetHandbrakeActive()
end

function ENT:CanButtonBePressedBy(ply,btn)
	return !self:IsButtonDisabled(btn) and IsValid(ply) and Trolleybus_System.CanPressButtons(self,ply) and !IsButtonDown(ply,"viewmove")
end

function ENT:CanButtonBePressedByType(ply,btn,type)
	local cfg = self.Buttons[btn].Cfg
	
	if type==1 then
		return ply:KeyDown(IN_ATTACK) and !ply:InVehicle()
	elseif type==2 then
		return ply:KeyDown(IN_ATTACK) and ply:InVehicle() and !IsButtonDown(ply,"mousesteer")
	elseif type==4 then
		return Trolleybus_System.PlayerInDriverPlace(self,ply) and cfg.hotkey and IsButtonDown(ply,btn,self)
	elseif type==8 then
		return Trolleybus_System.PlayerInDriverPlace(self,ply) and cfg.externalhotkey and Trolleybus_System.GetPlayerSetting(ply,"UseExternalButtons") and Trolleybus_System.IsExternalButtonDown(ply,cfg.externalhotkey)
	end
	
	return false
end

function ENT:TryPressButtonBy(ply,btn,type)
	if !self.Buttons[btn] or !self:CanButtonBePressedBy(ply,btn) or !self:CanButtonBePressedByType(ply,btn,type) then return end
	
	local b = self.Buttons[btn]
	
	if b.PressedBy[ply] then
		b.PressedBy[ply] = bit.bor(b.PressedBy[ply],type)
		return
	end
	
	b.PressedBy[ply] = type
	b.PressedUpdate = true

	self:ButtonPressedBy(btn,ply)
end

function ENT:ControlButtons()
	for k,v in pairs(self.Buttons) do
		local oldcount,count = v.PrevPressed or 0,0
		
		if v.PressedUpdate then
			local nextk,nextv = next(v.PressedBy)
			
			while nextk do
				local ply,types = nextk,nextv
				nextk,nextv = next(v.PressedBy,ply)
				
				if !self:CanButtonBePressedBy(ply,k) then types = 0 end
				
				local b = 1
				while b<=types do
					if bit.band(types,b)>0 and !self:CanButtonBePressedByType(ply,k,b) then types = bit.bxor(types,b) end
					
					b = b*2
				end
				
				if types==0 then
					v.PressedBy[ply] = nil
					self:ButtonReleasedBy(k,ply)
					
					continue
				end
				
				if types!=v.PressedBy[ply] then v.PressedBy[ply] = types end

				count = count+1
			end

			if count==0 then v.PressedUpdate = nil end
		end
		
		if oldcount!=count then
			local old = self:GetNWVar("Buttons."..k)
			local new = old
			
			if oldcount==0 and count>0 then
				new = Either(v.Cfg.toggle,!old,true)
			elseif !v.Cfg.toggle and old and count==0 then
				new = false
			end
			
			if old!=new then
				self:SetNWVar("Buttons."..k,new)

				if v.Cfg.func then v.Cfg.func(self,new) end
			end
			
			v.PrevPressed = count
			Trolleybus_System.RunChangeEvent("Trolleybus_Button",old,new,self,k)
		end
		
		if v.Cfg.think_sv then v.Cfg.think_sv(self,self:GetNWVar("Buttons."..k)) end
	end
end

function ENT:ButtonPressedBy(button,ply)
	local dt = self.Buttons[button]
	
	if dt.Cfg.onpressby then dt.Cfg.onpressby(self,ply,false) end
end

function ENT:ButtonReleasedBy(button,ply)
	local dt = self.Buttons[button]
	
	if dt.Cfg.onpressby then dt.Cfg.onpressby(self,ply,true) end
end

function ENT:ToggleButton(btn,value)
	local data = self.Buttons[btn]
	if !data then return end

	local old = self:GetNWVar("Buttons."..btn)
	if value==nil then value = !old end
	
	self:SetNWVar("Buttons."..btn,value)
	
	if data.Cfg.func then data.Cfg.func(self,value) end

	Trolleybus_System.RunChangeEvent("Trolleybus_Button",old,value,self,btn)
end

function ENT:SetMultiButton(btn,value)
	local old = self:GetNWVar("MultiBtns."..btn)
	self:SetNWVar("MultiBtns."..btn,value)

	Trolleybus_System.RunChangeEvent("Trolleybus_MultiButton",old,value,self,btn)
end

function ENT:SetButtonDisabled(btn,disabled)
	if self.Buttons[btn] then
		self:SetNWVar("BtnsDisabled."..btn,disabled)
	end
end

function ENT:ControlDoors()
	if self.DoorsData then
		for k,v in pairs(self.DoorsData) do
			if v.shouldopen then
				local open = v.shouldopen(self) or false
			
				if open!=self:DoorIsOpened(k) then
					if open then self:OpenDoor(k) else self:CloseDoor(k) end
				end
			end
		end
	end
end

function ENT:CalcPowerFromCN()
	local polarity = self:GetPolesPolarityInversion() and -1 or 1
	if Trolleybus_System.GetAdminSetting("trolleybus_control_without_wires") then return Trolleybus_System.ContactNetwork.GetVoltage()*polarity end

	if self:GetPoleState(false)!=0 or self:GetPoleState(true)!=0 then return 0 end

	local volt1,pos1 = Trolleybus_System.ContactNetwork.GetContactWireVoltage(self:GetPoleContactWire(false))
	local volt2,pos2 = Trolleybus_System.ContactNetwork.GetContactWireVoltage(self:GetPoleContactWire(true))

	if pos1==pos2 then return 0 end
	
	return (pos1 and volt1 or volt2)*(pos1 and 1 or -1)*polarity
end

function ENT:CalcElectricCurrentUsage()
	return 0
end

function ENT:AddDynamicButton(button,data)
	self.m_ButtonsData[button] = data
	self.Buttons[button] = {
		Cfg = data,
		PressedBy = {},
	}
	
	self:SetNWVar("Buttons."..button,false)
end

function ENT:RemoveDynamicButton(button)
	self.m_ButtonsData[button] = nil
	self.Buttons[button] = nil
	
	self:SetNWVar("Buttons."..button,nil)
	self:SetNWVar("BtnDisabled."..button,nil)
end

function ENT:AddDynamicPanel(panel,data)
	self.m_PanelsData[panel] = data
end

function ENT:RemoveDynamicPanel(panel)
	self.m_PanelsData[panel] = nil
end

function ENT:AddDynamicOtherPanelEnt(ent,data)
	self.m_OtherPanelEntsData[ent] = data
end

function ENT:RemoveDynamicOtherPanelEnt(ent)
	self.m_OtherPanelEntsData[ent] = nil
end

function ENT:Think()
	local delta = CurTime()-self.UpdateTime
	self.UpdateTime = CurTime()
	self.DeltaTime = delta

	local vel = self:GetVelocity()
	vel:Rotate(-self:GetAngles())

	self:SetMoveSpeed(self:UPSToKPH(vel.x))
	
	self:ControlButtons()
	self:ControlDoors()
	
	if self.HasPoles then
		self:ControlPoles()
	end
	
	if !self.IsTrailer then
		local seat = self:GetDriverSeat()
		self:SetDriver(seat:IsValid() and seat:GetDriver() or NULL)
		self:SetDriverSeatVelocity(seat:IsValid() and self.phys:GetVelocityAtPoint(seat:GetPos()) or self:GetVelocity())
	end
	
	self:SetupControls()
	
	self:SystemsEvent(false,"Think",delta)
	
	if IsValid(self.Owner) and Trolleybus_System.PlayerInDriverPlace(self,self.Owner) then
		local num = Trolleybus_System.GetPlayerSetting(self.Owner,"BortNumber")
		
		if self:GetBortNumber()!=num then
			self:SetBortNumber(num)
		end
	end
	
	Trolleybus_System.UpdateTransmit(self,"TrolleybusDrawDistance")

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	if self.HasPoles then
		Trolleybus_System.ForceFlyOffPole(self,false)
		Trolleybus_System.ForceFlyOffPole(self,true)
	end

	self:SystemsEvent(false,"OnRemove")
end

function ENT:PhysicsCollide(data,phys)
	if data.HitEntity:IsPlayer() then
		local spddiff = math.abs(data.TheirOldVelocity:Length()-data.OurOldVelocity:Length())
		
		if spddiff<500 then
			phys:SetVelocityInstantaneous(data.OurOldVelocity)
		end
	end
end

hook.Add("GravGunPickupAllowed","Trolleybus_System.TrolleybusSeats",function(ply,ent)
	if IsValid(ent) and IsValid(Trolleybus_System.GetSeatTrolleybus(ent)) then return false end
end)

hook.Add("Think","Trolleybus_System.PolesCrossCheck",function()
	if !Trolleybus_System.GetAdminSetting("trolleybus_poles_cross_check") then return end

	local t = ents.FindByClass("trolleybus_ent_*")
	local wheelrad = 5*5

	for k,v in ipairs(t) do
		if !v.HasPoles then continue end

		for k2,v2 in ipairs(t) do
			if !v2.HasPoles then continue end

			for i=1,2 do
				if v:GetPoleState(i==2)!=0 then continue end

				local t = v.PolesData[i==2 and "Right" or "Left"]
				if !t or !t.PrevWheelPos then continue end

				for j=1,2 do
					if v==v2 and i==j then continue end

					local t2 = v2.PolesData[j==2 and "Right" or "Left"]
					if !t2 or !t2.PrevWheelPos then continue end

					if t.PrevWheelPos:DistToSqr(t2.PrevWheelPos)<wheelrad then
						Trolleybus_System.ForceFlyOffPole(v,i==2)
					end
				end
			end
		end
	end
end)