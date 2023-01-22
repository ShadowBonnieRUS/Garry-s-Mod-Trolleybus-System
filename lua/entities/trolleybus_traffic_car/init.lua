-- Copyright © Platunov I. M., 2021 All rights reserved

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.UpdateDelay = 0.1

function ENT:SetupDataTablesSV()
	self:NetworkVarNotify("VehicleClass",function(self,name,old,new)
		local data = self:GetVehicleData(new)

		if data then
			self:SetModel(data.Model)
			self:SetSkin(isfunction(data.Skin) and data.Skin(self) or isnumber(data.Skin) and data.Skin or math.random(0,self:SkinCount()-1))
		end
	end)
end

function ENT:SpawnFunction(ply,tr,class)
	local ent = ents.Create(class)
	ent:SetupVehicleClass()
	ent:SetAngles(Angle(0,ply:EyeAngles().y+180,0))
	ent:SetPos(tr.HitPos+ent:GetAngles():Up()*ent:GetVehicleData().SpawnHeightOffset)
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self.SpawnTime = self:GetCreationTime()
	self:SetupVehicleClass()

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	self.phys = self:GetPhysicsObject()
	self.phys:SetMass(self:GetVehicleData().Mass/3*2)
	self.phys:EnableMotion(false)
	
	self.JamEnt = NULL
	self.JamTrace = {}
	self.DesiredSpeed = 0
	
	self:SetupWheels()
	
	self.TracingPos = self:OBBCenter()
	self.TracingPos.x = self:OBBMaxs().x
	
	self.TrackingPos = self:OBBCenter()
	self.TrackingPos.x = self.TrackingPos.x+(self:OBBMaxs().x-self.TrackingPos.x)/2
	
	if !self.CurTrack then
		self:FindTrack()
	end

	self.LastData = {
		Pos = self:GetTrackingPos(),
		Ang = self:GetAngles(),
		Radius = self:BoundingRadius(),
		Track = self:GetTrack(),
		NextTrack = self:GetNextTrack(),
	}

	self.AITask = Trolleybus_System.CreatePseudoAsyncTask(function(task)
		while self:IsValid() do
			self:ControlAI(task)

			task:Sleep(self.UpdateDelay)
		end
	end)
	
	Trolleybus_System.UpdateTransmit(self,"TrafficDrawDistance")
end

function ENT:GetTracingPos()
	return self:LocalToWorld(self.TracingPos)
end

function ENT:GetTrackingPos()
	return self:LocalToWorld(self.TrackingPos)
end

function ENT:SetupVehicleClass()
	if self:GetVehicleClass()=="" then
		local toselect,weight = {},0

		for k,v in pairs(Trolleybus_System.TrafficVehiclesTypes) do
			if v.IsService and self:GetTrack() and self:GetTrack().NoService then continue end

			toselect[#toselect+1] = {v.SpawnSelectWeight,k}
			weight = weight+v.SpawnSelectWeight
		end

		local selected = math.random()*weight
		local class

		weight = 0
		for k,v in ipairs(toselect) do
			if selected>=weight and selected<weight+v[1] then
				class = v[2]
				break
			end

			weight = weight+v[1]
		end

		if !class then self:Remove() return end
		
		self:SetVehicleClass(class)
	end
end

function ENT:SelectNextTrack()
	local next = self:GetTrack().Next
	if #next<2 then
		self.NextTrack = #next==1 and next[1] or nil
		return
	end

	local tracks,sum = {},0

	for k,v in ipairs(next) do
		local t = Trolleybus_System.GetTrafficTracks()[v]
		if !t or t.NoService and self:GetVehicleData().IsService then continue end

		local weight = t.DirWeight or 100
		tracks[#tracks+1] = {v,weight}
		sum = sum+weight
	end

	local rand = math.random()*sum
	for k,v in ipairs(tracks) do
		rand = rand-v[2]

		if rand<0 then
			self.NextTrack = v[1]

			return
		end
	end

	self.NextTrack = nil
end

function ENT:GetNextTrack()
	return Trolleybus_System.GetTrafficTracks()[self.NextTrack]
end

function ENT:GetTrack()
	return Trolleybus_System.GetTrafficTracks()[self.CurTrack]
end

function ENT:FindTrack()
	local pos = self:GetTrackingPos()
	local cur,dist
	
	for k,v in pairs(Trolleybus_System.GetTrafficTracks()) do
		local lp = WorldToLocal(pos,angle_zero,v.Start,(v.End-v.Start):Angle())
		
		if lp.x<0 or lp.x*lp.x>v.End:DistToSqr(v.Start) then continue end
		
		local d = lp.y*lp.y+lp.z*lp.z
		
		if !dist or d<dist then
			cur,dist = k,d
		end
	end
	
	local prevcur = self.CurTrack
	self.CurTrack = cur
	self.UpdateTrackTime = CurTime()
	
	if cur and prevcur!=cur then
		self:SelectNextTrack()
	end
end

function ENT:IsOnTrack()
	local ldata = self.LastData
	if !ldata then return end

	local track = ldata.Track
	if !track then return false end
	
	local pos,ang = ldata.Pos,ldata.Ang
	local lp,la = WorldToLocal(pos,ang,track.Start,(track.End-track.Start):Angle())
	
	if math.abs(la.y)>45 then return false end
	
	local len = track.End:Distance(track.Start)
	local radius = ldata.Radius*0.66
	
	if lp.x>len+radius then return false end
	if lp.x<-radius then return false end
	
	return math.abs(lp.y)<=radius
end

function ENT:GetTraceDistance()
	return self.TraceDistance or self:GetVehicleData().TraceDistance
end

function ENT:CalculateCollisionTimePos(ent)
	local pos = self:WorldSpaceCenter()
	local entpos = ent:WorldSpaceCenter()

	local vel = self:GetVelocity()
	local entvel = ent:GetVelocity()

	local collisionpos = Trolleybus_System.GetLinesIntersectPosition3D(pos,vel:Angle(),entpos,entvel:Angle())
	if !collisionpos then return collisionpos,math.huge end

	local radius = self:BoundingRadius()
	local entradius = ent:BoundingRadius()
	local maxradius = math.max(radius,entradius)

	local dist = collisionpos:Distance(pos)
	local entdist = collisionpos:Distance(entpos)

	if (collisionpos-pos):GetNormalized():Dot(vel:GetNormalized())<dist/math.sqrt(maxradius*maxradius+dist*dist) then return collisionpos,math.huge end
	if (collisionpos-entpos):GetNormalized():Dot(entvel:GetNormalized())<entdist/math.sqrt(maxradius*maxradius+entdist*entdist) then return collisionpos,math.huge end

	local spd = vel:Length()
	local entspd = entvel:Length()

	local itime = radius/spd
	local entitime = entradius/entspd

	local time = math.max(0,dist/spd-itime)
	local enttime = math.max(0,entdist/entspd-entitime)

	local diff = math.abs(time-enttime)
	if diff>itime or diff>entitime then return collisionpos,math.huge end

	return collisionpos,math.min(time,enttime)
end

function ENT:SetupJamTrace(ontrack)
	local data = self:GetVehicleData()

	local movedata = {}
	local movetime

	/*if !Trolleybus_System._TrafficCarCollisionsTime or CurTime()>=Trolleybus_System._TrafficCarCollisionsTime then
		Trolleybus_System._TrafficCarCollisionsTime = CurTime()+0.25

		Trolleybus_System._TrafficCarCollisions = {}

		for k,v in ipairs(ents.GetAll()) do
			if !self:IsObstacleEnt(v) or !v:GetPhysicsObject():IsValid() then continue end

			table.insert(Trolleybus_System._TrafficCarCollisions,v)
		end
	end

	for k,v in ipairs(Trolleybus_System._TrafficCarCollisions) do
		if v==self or !v:IsValid() or !v:GetPhysicsObject():IsValid() then continue end

		local pos,time = self:CalculateCollisionTimePos(v)
		if pos and time<3 then
			local phys = v:GetPhysicsObject()
			movedata[#movedata+1] = {phys,phys:GetPos(),phys:GetVelocity()}

			if !movetime or movetime>time then
				movetime = time
			end
		end
	end*/

	if movetime then
		for k,v in ipairs(movedata) do
			v[1]:SetPos(v[2]+v[3]*movetime)
			v[1]:SetVelocityInstantaneous(v[3])
		end
	end
	
	ProtectedCall(function()
		local ldata = self.LastData

		local start = self:GetPos()+ldata.Ang:Forward()*ldata.Radius/4
		local filter = self.JamIgnoreEnt and function(ent) return self.JamIgnoreEnt!=ent end
		local tracedist = self:GetTraceDistance()
		
		if ontrack and !self.ReverseActive then
			local curdist,curtrack,curpos = 0,ldata.Track,start
			local trackang = (curtrack.End-curtrack.Start):Angle()
			local zoffset = WorldToLocal(curpos,angle_zero,curtrack.Start,trackang).z/math.cos(math.rad(math.abs(trackang.p)))
			
			local disttohit = 0
			local traceparts = {}
			
			local tt = SysTime()
			while curtrack and curdist<tracedist do
				local tracepos = Vector(curtrack.End)
				tracepos.z = tracepos.z+zoffset
				
				local maxdist = math.min(tracedist-curdist,curpos:Distance(tracepos))
				local tracedir = tracepos-curpos
				tracedir:Normalize()
				
				self.JamTrace = self:TraceHull(curpos,curpos+tracedir*maxdist,filter)
				curdist = curdist+maxdist
				
				disttohit = disttohit+self.JamTrace.StartPos:Distance(self.JamTrace.HitPos)
				self.JamTrace.DistToHit = disttohit
				
				traceparts[#traceparts+1] = {Start = self.JamTrace.StartPos,End = self.JamTrace.HitPos}
				self.JamTrace.TraceParts = traceparts
				
				if curdist>=tracedist or self.JamTrace.Hit then break end
				
				curpos = tracepos
				
				local newtrack
				if curtrack==ldata.Track then
					newtrack = ldata.NextTrack
				else
					if #curtrack.Next!=1 then break end
					
					newtrack = Trolleybus_System.GetTrafficTracks()[curtrack.Next[1]]
				end

				if newtrack==curtrack then
					ErrorNoHalt("Trolleybus System: Traffic Track "..table.KeyFromValue(Trolleybus_System.GetTrafficTracks(),newtrack).." has itself in Next Tracks!!! Breaking infinite loop\n")

					self:Remove()
					break
				end

				curtrack = newtrack
			end
		else
			local dir = ldata.Ang:Forward()
			local turn = self:GetTurn()
			
			if self.ReverseActive then
				dir = -dir
				turn = -turn
			end
			
			if math.abs(turn)<=1 then
				self.JamTrace = self:TraceHull(start,start+dir*tracedist,filter)
				self.JamTrace.DistToHit = self.JamTrace.StartPos:Distance(self.JamTrace.HitPos)
				self.JamTrace.TraceParts = {{Start = self.JamTrace.StartPos,End = self.JamTrace.HitPos}}
			elseif self.WheelsDistance>0 then
				local wheeldist = self.WheelsDistance
				local radius = ldata.Radius

				local wheelrad = wheeldist/math.sin(math.rad(turn))*2
				local forwardang = dir:Angle()
				local center = start-forwardang:Right()*wheelrad
				
				local lpos = WorldToLocal(start,angle_zero,center,forwardang)
				local lang = lpos:Angle()*(wheelrad<0 and -1 or 1)
				lang:Normalize()
				local oneang = -lang/90
				local len = math.pi*wheelrad*2
				local fullang = tracedist/len*360
				
				local selfd = radius*2
				local curang = addang
				
				local disttohit = 0
				local traceparts = {}
				
				local cdist = selfd
				while cdist<=tracedist do
					local fr = cdist/tracedist
					
					local circleang = lang+oneang*fullang*fr
					local endpos = LocalToWorld(circleang:Forward()*wheelrad,angle_zero,center,forwardang)
					
					local ang = Angle(circleang)
					ang:RotateAroundAxis(ang:Up(),wheelrad<0 and -90 or 90)
					
					self.JamTrace = self:TraceHull(start,endpos,filter)
					
					disttohit = disttohit+self.JamTrace.StartPos:Distance(self.JamTrace.HitPos)
					self.JamTrace.DistToHit = disttohit
					
					traceparts[#traceparts+1] = {Start = self.JamTrace.StartPos,End = self.JamTrace.HitPos}
					self.JamTrace.TraceParts = traceparts
					
					if cdist>=tracedist or self.JamTrace.Hit then break end
					
					cdist = math.min(cdist+selfd,tracedist)
					start = endpos
				end
			end
		end
	end)

	if movetime then
		for k,v in ipairs(movedata) do
			v[1]:SetPos(v[2])
			v[1]:SetVelocityInstantaneous(v[3])
		end
	end
end

function ENT:CheckLoopStuck()
	local ent = self
	local loop = {}

	while !loop[ent] and ent.JamTrace and ent.JamTrace.Hit and IsValid(ent.JamTrace.Entity) do
		loop[ent] = true
	
		if ent.JamTrace.Entity==self then return true end
		
		ent = ent.JamTrace.Entity
	end
	
	return false
end

function ENT:IsObstacleEnt(ent)
	if ent.IsTrolleybus or ent:IsVehicle() and ent:GetClass()!="prop_vehicle_prisoner_pod" or ent:IsPlayer() then return true end
	
	local class = ent:GetClass()
	
	return class==self:GetClass() or class=="gmod_sent_vehicle_fphysics_base"
end

function ENT:IsLookAroundEnt(ent)
	if ent.IsTrolleybus or ent:IsVehicle() and ent:GetClass()!="prop_vehicle_prisoner_pod" then return true end
	
	local class = ent:GetClass()
	
	return class==self:GetClass() or class=="gmod_sent_vehicle_fphysics_base"
end

local function math_DistToSqr(x1,y1,x2,y2)
	return (x2-x1)^2+(y2-y1)^2
end

function ENT:GetSqrDistToStop()
	local ldata = self.LastData

	local data = self:GetVehicleData()
	local tracedist = self:GetTraceDistance()
	local dists = {}
	
	local tracepos = self:GetTracingPos()
	if self.JamTrace and self.JamTrace.Hit then
		dists[#dists+1] = self.JamTrace.DistToHit^2
	end
	
	if !self.ReverseActive then
		if !Trolleybus_System.TrafficCarLookAroundTime or CurTime()-Trolleybus_System.TrafficCarLookAroundTime>0.25 then
			Trolleybus_System.TrafficCarLookAroundTime = CurTime()
			Trolleybus_System.TrafficCarLookAround = {}
			local t = Trolleybus_System.TrafficCarLookAround
			
			for k,v in ipairs(ents.GetAll()) do
				if !self:IsLookAroundEnt(v) or v:GetVelocity():Length2DSqr()<50*50 then continue end
				
				if v:GetClass()=="trolleybus_traffic_car" then
					if v.CurTrack then t[v.CurTrack] = true end
				else
					local pos,ang = v:WorldSpaceCenter(),v:GetAngles()
					local radius = v:BoundingRadius()
				
					for k2,v2 in pairs(Trolleybus_System.GetTrafficTracks()) do
						local lpos,lang = WorldToLocal(pos,ang,v2.Start,(v2.End-v2.Start):Angle())
						
						if math.abs(lang.y)<=40 and lpos.y^2+lpos.z^2<radius^2 and lpos.x>-radius and lpos.x<v2.Start:Distance(v2.End)+radius then
							t[k2] = true
						end
					end
				end
			end
		end

		local ntrack = ldata.NextTrack
		if ntrack then
			local light = Trolleybus_System.TrafficLightIDs[ntrack.TrafficLight]
			
			if IsValid(light) and light:IsStopSignal() then
				local dist = math_DistToSqr(tracepos.x,tracepos.y,ntrack.Start.x,ntrack.Start.y)
				
				if dist<=tracedist*tracedist then
					dists[#dists+1] = dist
				end
			end

			local look = ntrack.Look or ntrack.LookBase and Trolleybus_System.GetTrafficTracks()[ntrack.LookBase] and Trolleybus_System.GetTrafficTracks()[ntrack.LookBase].Look
			if look then
				for k,v in ipairs(look) do
					if Trolleybus_System.TrafficCarLookAround[v] then
						local dist = math_DistToSqr(tracepos.x,tracepos.y,ntrack.Start.x,ntrack.Start.y)
				
						if dist<=tracedist*tracedist then
							dists[#dists+1] = dist
						end

						break
					end
				end
			end
		end

		local track = ldata.Track
		if track then
			local look = track.Look or track.LookBase and Trolleybus_System.GetTrafficTracks()[track.LookBase] and Trolleybus_System.GetTrafficTracks()[track.LookBase].Look
			if look then
				for k,v in ipairs(look) do
					if Trolleybus_System.TrafficCarLookAround[v] then
						dists[#dists+1] = 0
						
						break
					end
				end
			end
		end
	end
	
	return #dists>0 and math.min(unpack(dists)) or false
end

function ENT:GetAllowedSpeed(pos)
	local ldata = self.LastData

	local data = self:GetVehicleData()
	local tracedist = self:GetTraceDistance()
	
	local trackpos = self:GetTrackingPos()
	local lpos,lang = WorldToLocal(trackpos,ldata.Ang,pos,(pos-trackpos):Angle())
	
	local spd = math.min(data.MaxSpeed,ldata.Track.MaxSpeed or 500)
	
	do
		local track = ldata.NextTrack
		local tdist = tracedist-trackpos:Distance(pos)
		
		local fspd,disttotrack = spd,0
		while tdist>0 and track do
			local trackspd = track.MaxSpeed or 500
			
			if fspd>trackspd then
				fspd = trackspd
				disttotrack = tracedist-tdist
			end
			
			tdist = tdist-track.Start:Distance(track.End)
			track = #track.Next==1 and Trolleybus_System.GetTrafficTracks()[track.Next[1]] or nil
		end
		
		local fr = 1-disttotrack/tracedist
		spd = spd+(fspd-spd)*fr
	end
	
	local fspd = spd
	
	if !self.ReverseActive then
		local dist = math.Distance(trackpos.x,trackpos.y,pos.x,pos.y)
		local curdir,track = ldata.Ang:Forward(),ldata.NextTrack
		
		if dist<tracedist and track then
			local fang = 0
			local curdist = dist
			
			repeat
				local dir = (track.End-track.Start):GetNormalized()
				local dot = curdir:Dot(dir)
				fang = fang+math.abs(math.deg(math.acos(dot)))
				
				curdir = dir
				curdist = curdist+track.End:Distance(track.Start)
				track = #track.Next==1 and Trolleybus_System.GetTrafficTracks()[track.Next[1]] or nil
			until !track or curdist>=tracedist
			
			local fr = math.Remap(dist,tracedist,0,0,math.Clamp(fang/90,0,1))
			local mp = 1+fr
			
			fspd = math.min(fspd,spd/mp)
		end
	end
	
	do
		local dist = self:GetSqrDistToStop()
		
		if dist then
			dist = math.sqrt(dist)
			
			local speedstopdecr = self.ReverseActive and 50 or 120
			local stopdistance = self.ReverseActive and 25 or 100
			
			fspd = math.min(fspd,dist<=stopdistance and 0 or dist<=speedstopdecr and 5 or math.Remap(dist,speedstopdecr,tracedist,5,spd))
		end
	end
	
	if math.abs(lang.y)>1 then
		local fr = math.Clamp(math.abs(lang.y),0,90)/90
		local mp = 1+fr*1
		
		fspd = math.min(fspd,spd/mp)
	end
	
	if lang.p>0 and lang.p<90 then
		spd = spd/math.atan(math.rad(90-math.min(lang.p,60)))
	end
	
	return fspd*math.Clamp(self:GetSurfaceFriction()*5,0,1)
end

function ENT:SetRotateTo(pos)
	local curpos = self:GetTrackingPos()
	local lpos,lang = WorldToLocal(curpos,self:GetAngles(),pos,(pos-curpos):Angle())
	local rotate = math.Clamp(-lang.y,-60,60)
	
	self:SetRotate(self.ReverseActive and -rotate or rotate)
end

function ENT:MoveTo(pos)
	self:SetSpeed(self.ReverseActive and -self:GetAllowedSpeed(pos) or self:GetAllowedSpeed(pos))
	self:SetRotateTo(pos)

	//debugoverlay.Axis(pos,angle_zero,30,0.15)
end

function ENT:SetSpeed(speed)
	self.DesiredSpeed = speed
end

function ENT:SetRotate(ang)
	for k,v in ipairs(self.Wheels) do
		if v.Turn then
			for k,v in ipairs(v.Wheels) do
				v:SetRotate(ang)
			end
		end
	end
	
	self:SetTurn(ang)
end

function ENT:GetSpeed()
	return self:GetVelocity():Length()
end

function ENT:GetSurfaceFriction()
	local friction

	for k,v in ipairs(self.Wheels) do
		if v.Drive then
			for k,v in ipairs(v.Wheels) do
				if v.LastFrictionSnapshot then
					for k,v in ipairs(v.LastFrictionSnapshot) do
						local sdata = util.GetSurfaceData(v.MaterialOther)
					
						if sdata and (!friction or friction>sdata.friction) then
							friction = sdata.friction
						end
					end
				end
			end
		end
	end

	if friction then return friction end
	
	local ldata = self.LastData
	local tr = util.TraceLine({start = ldata.Pos,endpos = ldata.Pos-ldata.Ang:Up()*300,filter = self})
	local sdata = util.GetSurfaceData(tr.SurfaceProps)
	
	return sdata and sdata.friction or 0
end

function ENT:SetupWheels()
	local data = self:GetVehicleData()
	self.Wheels = {}
	
	local wmass,wcount = data.Mass/3,0
	for k,v in ipairs(data.Wheels) do
		wcount = wcount+#v.Wheels
	end
	
	wmass = wmass/wcount

	local turnpsum,nturnpsum = Vector(),Vector()
	local turncount,nturncount = 0,0
	
	for k,v in ipairs(data.Wheels) do
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

			if v.Turn then
				turnpsum:Add(v2.Pos)
				turncount = turncount+1
			else
				nturnpsum:Add(v2.Pos)
				nturncount = nturncount+1
			end
		end
	
		self.Wheels[k] = data
	end

	self.WheelsDistance = turncount>0 and nturncount>0 and (turnpsum/turncount):Distance(nturnpsum/nturncount) or 0
	
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

	self.phys:EnableMotion(true)
end

function ENT:CalcWheelFinalRotationSpeed(wheel,rspeed,dt)
	if !wheel.WheelsGroup then return end
	
	local group = self.Wheels[wheel.WheelsGroup]
	if group.Drive then
		local rotdata = group.RotationData
	
		if rotdata.Wheels==0 then
			local dspd = self.DesiredSpeed
			local spd = wheel:RotationSpeedToMovementSpeed(rotdata.Rotation)
			local vdata = self:GetVehicleData()
			
			if spd<0 then
				spd = dspd>=spd and math.min(spd+vdata.Deceleration*dt,dspd) or math.max(spd-vdata.Acceleration*dt,dspd)
			else
				spd = dspd<=spd and math.max(spd-vdata.Deceleration*dt,dspd) or math.min(spd+vdata.Acceleration*dt,dspd)
			end
			
			rotdata.Rotation = wheel:MovementSpeedToRotationSpeed(spd)
		end

		local nspeed = rotdata.Rotation+rotdata.Diff[wheel.WheelsGroupWheel]
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
		end
		
		return nspeed
	end
end

function ENT:IsWheelsFullStop()
	return self.DesiredSpeed==0
end

function ENT:WheelsIsOnGround()
	for k,v in ipairs(self.Wheels) do
		for k,v in ipairs(v.Wheels) do
			if v.LastFrictionSnapshot and #v.LastFrictionSnapshot>0 then return true end
		end
	end
	
	return false
end

function ENT:TraceHull(startpos,endpos,filter)
	local ang = (endpos-startpos):Angle()
	local div = 1+(math.sin(math.rad(-90+ang.y*4))+1)/2
	
	local min,max = self:GetCollisionBounds()
	min:Div(div)
	max:Div(div)

	local bounds = {
		min,Vector(min.x,min.y,max.z),Vector(min.x,max.y,min.z),Vector(max.x,min.y,min.z),
		max,Vector(max.x,min.y,max.z),Vector(max.x,max.y,min.z),Vector(min.x,max.y,max.z),
	}

	local gmin,gmax = Vector(),Vector()
	for i=1,#bounds do
		local bound = bounds[i]
		bound:Rotate(ang)

		for c=1,3 do
			if bound[c]<gmin[c] then gmin[c] = bound[c] end
			if bound[c]>gmax[c] then gmax[c] = bound[c] end
		end
	end
	
	local customcoll = self:GetCustomCollisionCheck()
	local tr = util.TraceHull({
		start = startpos,
		endpos = endpos,
		mins = gmin,
		maxs = gmax,
		ignoreworld = true,
		filter = function(ent)
			if ent==self or !self:IsObstacleEnt(ent) or filter and !filter(ent) then return false end
			if customcoll and !gamemode.Call("ShouldCollide",self,ent) then return false end
			
			return true
		end
	})
	
	//debugoverlay.SweptBox(startpos,tr.HitPos,gmin,gmax,Angle(),0.15,tr.Hit and Color(255,255,0) or Color(0,255,0))
	//debugoverlay.Text((startpos+tr.HitPos)/2+(gmin+gmax)/2,div,0.15)
	
	return tr
end

function ENT:ControlAI(task)
	local selfpos,selfang = self:GetTrackingPos(),self:GetAngles()
	local selfradius = self:BoundingRadius()
	local track,trackang,lpos,lang = self:GetTrack()

	if !track then
		self:Remove()
		return
	end

	task:Yield()
	
	while true do
		trackang = (track.End-track.Start):Angle()
		lpos,lang = WorldToLocal(selfpos,selfang,track.Start,trackang)
		
		if lpos.x<-selfradius or math.abs(lpos.y)>selfradius*2*3 then
			self:FindTrack()
			
			if !self:GetTrack() then
				self:Remove()
				return
			end
			
			if track!=self:GetTrack() then
				track = self:GetTrack()
				continue
			end
		end
		
		if lpos.x>track.End:Distance(track.Start) then
			if !self:GetNextTrack() then
				self:SelectNextTrack()
				
				if !self:GetNextTrack() then
					self:Remove()
					return
				end
			end
		
			self.CurTrack = self.NextTrack
			self:SelectNextTrack()
			
			if track!=self:GetTrack() then
				track = self:GetTrack()
				continue
			end
		end
		
		break
	end

	self.LastData = {
		Pos = selfpos,
		Ang = selfang,
		Radius = selfradius,
		Track = track,
		TrackAng = trackang,
		LPos = lpos,
		LAng = lang,
		NextTrack = self:GetNextTrack(),
	}

	task:Yield()

	self:SetTurnSignal(self.LastData.NextTrack and self.LastData.NextTrack.TurnSignal or track and track.TurnSignal or 0)
	
	if math.abs(lang.r)<90 then
		local ontrack = self:IsOnTrack()
		local dist = track.End:Distance(track.Start)-lpos.x+math.abs(lpos.y)
		local ntrack = self.LastData.NextTrack
		
		local pos = dist<150 and ntrack and ntrack.Start+(ntrack.End-ntrack.Start):GetNormalized()*(150-dist) or track.End
		
		if !ontrack and !self.ReverseActive then
			if math.abs(lang.y)>90 then
				local toleft = lang.y<0

				pos = LocalToWorld(Vector(0,selfradius*(toleft and 1 or -1),0),angle_zero,selfpos,selfang)
			else
				local x = lpos.x+(selfradius/(math.abs(lpos.y)/100))
				local lpos = Vector(x<0 and 0 or math.min(x,track.Start:Distance(pos)),0,0)
				
				pos = LocalToWorld(lpos,angle_zero,track.Start,trackang)
			end
		end
		
		//debugoverlay.Sphere(pos,10,0.5)
		
		self:SetRotateTo(pos)
		self._JamTurn = self:GetTurn()

		task:Yield()
		self:SetupJamTrace(self:IsOnTrack())
		task:Yield()
		
		local jamtrace = self.JamTrace
		
		if self:CheckLoopStuck() then
			if jamtrace.Entity.JamTrace.Entity==self then
				/*if false and jamtrace.StartPos:DistToSqr(jamtrace.HitPos)>25^2 then -- todo
					local ent = jamtrace.Entity
					local spos = self:WorldSpaceCenter()
					local jpos = ent:WorldSpaceCenter()
					
					local sang = Angle(selfang)
					sang:RotateAroundAxis(sang:Up(),self:GetTurn())
					
					local jang = ent:GetAngles()
					jang:RotateAroundAxis(jang:Up(),ent._JamTurn or ent:GetTurn())
				
					local colpos = Trolleybus_System.GetLinesIntersectPosition3D(spos,sang,jpos,jang)
					
					if colpos then
						local lpos = WorldToLocal(jpos,angle_zero,spos,sang)
						local lcpos = WorldToLocal(colpos,angle_zero,spos,sang)
						local jlcpos = WorldToLocal(colpos,angle_zero,jpos,jang)
						
						local color = HSVToColor(self:EntIndex()*5%360,1,1)
						color.a = 255
						
						//debugoverlay.EntityTextAtPosition(spos,1,tostring(self),0.15,color)
						//debugoverlay.Sphere(colpos,15,0.15,color,true)
						
						local angdiff = 180-math.deg(math.acos(selfang:Forward():Dot(ent:GetAngles():Forward())))
						
						if lcpos.x>0 or angdiff<20 then
							local iamcloser = lcpos:LengthSqr()<lpos:DistToSqr(lcpos)
							local right
							
							if lpos.y>=0 then
								right = iamcloser or lcpos.x<0 or lcpos.x>lpos.x
							else
								right = !iamcloser and lcpos.x>=0 and lcpos.x<=lpos.x
							end
							
							pos = LocalToWorld(Vector(lpos.x,lpos.y+(right and -150 or 150),0),angle_zero,spos,sang)
							self:SetRotateTo(pos)
						end
						
						//debugoverlay.Sphere(pos,10,0.15,color,true)
						
						if jlcpos.x>0 then
							self.JamIgnoreEnt = ent
							self:SetupJamTrace()
							self.JamIgnoreEnt = nil
							
							self:MoveTo(pos)
						
							self.JamTrace = jamtrace
							
							if self:GetSpeed()>1 then
								self.StuckTime = CT
							end
						else
							self:MoveTo(pos)
							
							if self:GetSpeed()>1 then
								self.StuckTime = CT
							end
						end
					else
						self:SetSpeed(0)
					end
				else*/
					self:SetSpeed(0)
				//end
			else
				self:MoveTo(pos)
				
				if self:GetSpeed()>1 then
					self.StuckTime = CurTime()
				end
			end
		else
			/*if false and (!self.UnexpectedCollisionsTime or CT>self.UnexpectedCollisionsTime) then -- todo
				self.UnexpectedCollisionsTime = CT+math.Rand(0.3,0.6)
				self.UnexpectedCollisions = false
				
				local vel = self:GetVelocity()
				local spd = vel:Length()
				
				if spd>50 then
					for k,v in ipairs(ents.GetAll()) do
						if v==self or !self:IsLookAroundEnt(v) then continue end
						
						local vvel = v:GetVelocity()
						local vspd = vvel:Length()
						
						if vspd<50 then continue end
						
						local vpos = v:WorldSpaceCenter()
						local colpos = Trolleybus_System.GetLinesIntersectPosition3D(selfpos,vel:Angle(),vpos,vvel:Angle())
						
						if !colpos then continue end
						
						local dist = selfpos:Distance(colpos)
						local time = dist/spd
						
						if time>1.5 then continue end
						
						local vdist = vpos:Distance(colpos)
						local vtime = vdist/vspd
						
						if vtime>1.5 then continue end
						
						local dot = vel:GetNormalized():Dot((colpos-selfpos):GetNormalized())
						dot = math.Clamp(dot,-1,1)
						
						if math.deg(math.acos(dot))>30 then continue end
						
						local vdot = vvel:GetNormalized():Dot((colpos-vpos):GetNormalized())
						vdot = math.Clamp(vdot,-1,1)
						
						if math.deg(math.acos(vdot))>30 then continue end
						
						//debugoverlay.Text(selfpos,tostring(self),1)
						//debugoverlay.Text(vpos,tostring(self),1)
						
						self.UnexpectedCollisions = true
						break
					end
				end
			end
			
			if self.UnexpectedCollisions then
				self:SetSpeed(0)
			else*/
				self.StuckTime = CurTime()
				self:MoveTo(pos)
			//end
		end

		task:Yield()
		
		if self.ReverseActive then
			if math.abs(self:GetTurn())<10 then
				self.ReverseActive = false
			end
		elseif (jamtrace.Hit or self.DesiredSpeed<=30 or self:GetSpeed()>10) then
			self.ReverseTime = CurTime()
		end
	else
		self:SetSpeed(0)
	end

	task:Yield()

	local CT = CurTime()
	
	if self.phys:IsMotionEnabled() then
		if self.StuckTime and CT-self.StuckTime>3 then
			self:Remove()
			return
		end
		
		if self:WheelsIsOnGround() then
			self.FlippedTime = CT
		else
			self.ReverseTime = CT
		end
		
		if self.FlippedTime and CT-self.FlippedTime>5 then
			self:Remove()
			return
		end
		
		if self.ReverseTime and CT-self.ReverseTime>2 then
			self.ReverseActive = !self.ReverseActive
			self.ReverseTime = CT
		end
	else
		self.FlippedTime = CT
		self.StuckTime = CT
		self.ReverseTime = CT
	end

	task:Yield()
end

function ENT:Think()
	Trolleybus_System.UpdateTransmit(self,"TrafficDrawDistance")
end

function ENT:OnRemove()
	for k,v in ipairs(self.Wheels) do
		for k,v in ipairs(v.Wheels) do
			SafeRemoveEntity(v)
		end
	end

	self.AITask:Cancel()
end