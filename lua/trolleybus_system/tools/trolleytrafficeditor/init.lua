-- Copyright © Platunov I. M., 2020 All rights reserved

if !TOOL then return end

util.AddNetworkString("TrolleybusTrafficTrackEditor")

local function switchandsetoperation(ply,op)
	ply:SelectWeapon("gmod_tool")
	ply:ConCommand("gmod_toolmode trolleytrafficeditor")
	ply:GetWeapon("gmod_tool").Mode = "trolleytrafficeditor"
	ply:GetWeapon("gmod_tool"):GetToolObject():SetOperation(op)
	ply:GetWeapon("gmod_tool"):GetToolObject():SetStage(0)
end

local function savetracks(id)
	Trolleybus_System.SaveTrafficTracks(id)
end

local function createtrack(id,track)
	local tracks = Trolleybus_System.GetTrafficTracks()
	local prevtrack = tracks[id]
	tracks[id] = track
	
	for k,v in pairs(track.Next) do
		if tracks[v] and !table.HasValue(tracks[v].Prev,id) then
			table.insert(tracks[v].Prev,id)
			savetracks(v)
		end
	end
	
	for k,v in pairs(track.Prev) do
		if tracks[v] and !table.HasValue(tracks[v].Next,id) then
			table.insert(tracks[v].Next,id)
			savetracks(v)
		end
	end
	
	if prevtrack then
		for k,v in pairs(prevtrack.Next) do
			if tracks[v] and !table.HasValue(track.Next,v) and table.HasValue(tracks[v].Prev,id) then
				table.RemoveByValue(tracks[v].Prev,id)
				savetracks(v)
			end
		end
		
		for k,v in pairs(prevtrack.Prev) do
			if tracks[v] and !table.HasValue(track.Prev,v) and table.HasValue(tracks[v].Next,id) then
				table.RemoveByValue(tracks[v].Next,id)
				savetracks(v)
			end
		end
	end
end

local function removetrack(id)
	local tracks = Trolleybus_System.GetTrafficTracks()
	local track = tracks[id]
	
	if track then
		for k,v in pairs(tracks) do
			if id==k then continue end
			
			local save
			
			if table.HasValue(v.Prev,id) then
				table.RemoveByValue(v.Prev,id)
				save = true
			end
			
			if table.HasValue(v.Next,id) then
				table.RemoveByValue(v.Next,id)
				save = true
			end
			
			if v.Look and table.HasValue(v.Look,id) then
				table.RemoveByValue(v.Look,id)
				save = true
			end
			
			if v.LookBase==id then
				v.LookBase = nil
				save = true
			end
			
			if save then
				savetracks(k)
			end
		end
	end
	
	tracks[id] = nil
	
	return track
end

local function newid()
	local id = 1

	while Trolleybus_System.GetTrafficTracks()[id] do
		id = id+1
	end
	
	return id
end

function TOOL:LeftClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficeditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	local op,stage = self:GetOperation(),self:GetStage()
	
	if op==0 then
		net.Start("TrolleybusTrafficTrackEditor")
			net.WriteUInt(2,4)
		net.Send(self:GetOwner())
	else
		local pos = self:GetNearestConnectPos()
	
		if op==1 then
			net.Start("TrolleybusTrafficTrackEditor")
				net.WriteUInt(0,4)
				net.WriteBool(stage==1)
				net.WriteVector(pos)
			net.Send(self:GetOwner())
		elseif op==2 then
			if stage==0 or stage==1 then
				net.Start("TrolleybusTrafficTrackEditor")
					net.WriteUInt(4,4)
					net.WriteBool(stage==1)
					net.WriteVector(pos)
				net.Send(self:GetOwner())
				
				self:SetStage(stage+1)
				
				return true
			elseif stage==2 then
				net.Start("TrolleybusTrafficTrackEditor")
					net.WriteUInt(5,4)
					net.WriteUInt(self:GetOwner():KeyDown(IN_USE) and 1 or 0,2)
					net.WriteBool(self:GetOwner():KeyDown(IN_RELOAD))
				net.Send(self:GetOwner())
			end
		elseif op==3 then
			if IsValid(trace.Entity) and trace.Entity:GetClass()=="trolleybus_trafficlight" and trace.Entity.Data then
				local id = self:GetClientNumber("trackid")
				local track = Trolleybus_System.GetTrafficTracks()[id]
				
				if track then
					track.TrafficLight = trace.Entity.Data.ID
					savetracks(id)
				end
			else
				return false
			end
		end
		
		self:SetOperation(0)
		self:SetStage(0)
	end
	
	return true
end

function TOOL:RightClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficeditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	local op,stage = self:GetOperation(),self:GetStage()
	
	if op==0 then
		if self:GetOwner():KeyDown(IN_USE) then
			net.Start("TrolleybusTrafficTrackEditor")
				net.WriteUInt(3,4)
				net.WriteUInt(self:GetClientNumber("trackid"),32)
				net.WriteUInt(newid(),32)
			net.Send(self:GetOwner())
		else
			local id = self:GetClientNumber("trackid")
			
			if removetrack(id) then
				savetracks(id)
			end
		end
	else
		if op==2 then
			if stage==2 and self:GetOwner():KeyDown(IN_USE) then
				net.Start("TrolleybusTrafficTrackEditor")
					net.WriteUInt(5,4)
					net.WriteUInt(2,2)
					net.WriteBool(self:GetOwner():KeyDown(IN_RELOAD))
				net.Send(self:GetOwner())
			end
		end
		
		self:SetOperation(0)
		self:SetStage(0)
	end
	
	return true
end

function TOOL:Reload()
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficeditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	local op,stage = self:GetOperation(),self:GetStage()
	
	if op==0 then
		local id = self:GetNearestTrack()
		
		if Trolleybus_System.GetTrafficTracks()[id] then
			self:GetOwner():ConCommand("trolleytrafficeditor_trackid "..id)
		
			net.Start("TrolleybusTrafficTrackEditor")
				net.WriteUInt(1,4)
				net.WriteUInt(id,32)
			net.Send(self:GetOwner())
		else
			return false
		end
	end
	
	return true
end

net.Receive("TrolleybusTrafficTrackEditor",function(len,ply)
	if !Trolleybus_System.RunEvent("HasAccessToTool",ply,"trolleytrafficeditor") then return end

	local self = ply:HasWeapon("gmod_tool") and ply:GetWeapon("gmod_tool"):GetMode()=="trolleytrafficeditor" and ply:GetWeapon("gmod_tool"):GetToolObject()
	if !self then return end
	
	if Trolleybus_System.ToolsDisallowed(ply) then return end
	
	local cmd = net.ReadUInt(4)
	
	if cmd==0 then
		switchandsetoperation(ply,1)
		self:SetStage(net.ReadBool() and 1 or 0)
	elseif cmd==1 then
		local id = net.ReadUInt(32)
		local t = net.ReadTable()
		
		createtrack(id,t)
		savetracks(id)
	elseif cmd==2 then
		switchandsetoperation(ply,2)
	elseif cmd==3 then
		local type = net.ReadUInt(2)
		local R = net.ReadBool()
		local pos1 = net.ReadVector()
		local pos2 = net.ReadVector()
		
		local ang = ply:EyeAngles()
		ang.p = 0
		ang.r = 0
		
		local prevtrack,previd
		self:BuildRotation(pos1,pos2,ang,self:GetClientNumber("rotation_segments"),self:GetClientNumber("rotation_curvature"),R,function(i,count,pos,prevpos)
			if !prevpos then return end
			
			local id = newid()
			local t = {
				Start = prevpos,
				End = pos,
				Next = {},
				Prev = {previd},
				MaxSpeed = self:GetClientNumber("maxspeed")*1000/3600*Trolleybus_System.UnitsPerMeter,
				SpawnChance = self:GetClientNumber("spawnchance"),
				DirWeight = self:GetClientNumber("dirweight"),
				NoService = tobool(self:GetClientNumber("noservice")),
			}
			
			if type!=0 then
				t.TurnSignal = type
			end
			
			Trolleybus_System.GetTrafficTracks()[id] = t
			savetracks(id)
			
			if prevtrack then
				prevtrack.Next = {id}
				savetracks(previd)
			end
			
			prevtrack,previd = t,id
		end)
	elseif cmd==4 then
		switchandsetoperation(ply,3)
	elseif cmd==5 then
		local id = self:GetClientNumber("trackid")
		local track = Trolleybus_System.GetTrafficTracks()[id]
		
		if track and track.TrafficLight then
			track.TrafficLight = nil
			savetracks(id)
		end
	end
end)
