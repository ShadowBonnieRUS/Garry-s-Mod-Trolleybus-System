-- Copyright © Platunov I. M., 2020 All rights reserved

if !TOOL then return end

util.AddNetworkString("TrolleybusTrafficLightEditor")

function TOOL:LeftClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficlighteditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	net.Start("TrolleybusTrafficLightEditor")
		net.WriteUInt(1,4)
		net.WriteBool(self:GetOwner():KeyDown(IN_USE))
	net.Send(self:GetOwner())
	
	return true
end

function TOOL:RightClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficlighteditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	if !self:GetOwner():KeyDown(IN_USE) then
		local light = self:GetMainTrafficLight(trace.Entity)
	
		if light then
			light:Remove()
			light.ToRemove = true
			Trolleybus_System.SaveTrafficLights()
			
			local id = light.Data and light.Data.ID
			
			if id then
				for k,v in pairs(Trolleybus_System.GetTrafficTracks()) do
					if v.TrafficLight==id then
						v.TrafficLight = nil
						
						Trolleybus_System.SaveTrafficTracks(k)
					end
				end
			end
		else
			return false
		end
	else
		return false
	end
	
	return true
end

function TOOL:Reload(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficlighteditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	local light = self:GetMainTrafficLight(trace.Entity)
	if !light then return false end
	
	if !self:GetOwner():KeyDown(IN_USE) then
		if !light.Data then return false end
		
		net.Start("TrolleybusTrafficLightEditor")
			net.WriteUInt(2,4)
			net.WriteTable(light.Data)
		net.Send(self:GetOwner())
	else
		net.Start("TrolleybusTrafficLightEditor")
			net.WriteUInt(3,4)
		net.Send(self:GetOwner())
	end
	
	return true
end

net.Receive("TrolleybusTrafficLightEditor",function(len,ply)
	if !Trolleybus_System.RunEvent("HasAccessToTool",ply,"trolleytrafficlighteditor") then return end
	
	local self = ply:HasWeapon("gmod_tool") and ply:GetWeapon("gmod_tool"):GetMode()=="trolleytrafficlighteditor" and ply:GetWeapon("gmod_tool"):GetToolObject()
	if !self then return end
	
	if Trolleybus_System.ToolsDisallowed(ply) then return end
	
	local cmd = net.ReadUInt(4)
	
	if cmd==1 then
		local E = net.ReadBool()
		local partoflight = E and net.ReadUInt(8)
		local data = net.ReadTable()
		
		local light = self:GetMainTrafficLight(ply:GetEyeTrace().Entity)
		
		local pos,ang
		if E then
			pos,ang = self:GetLightPos(ply,ply:GetEyeTrace(),data.Type,partoflight)
		else
			pos,ang = ply:GetEyeTrace().HitPos,Angle(0,ply:EyeAngles().y+180,0)
		end
		
		local ldata = Trolleybus_System.TrafficLightTypes[data.Type]
		pos,ang = LocalToWorld(ldata.ToolPosOffset or vector_origin,ldata.ToolAngOffset or angle_zero,pos,ang)
		
		local create = true
		
		if !E and light and light.Data then
			data.ID = light.Data.ID
		
			create = false
			light:LoadBehaviour(data)
		end
		
		if create then
			local ids = {}
	
			for k,v in ipairs(ents.FindByClass("trolleybus_trafficlight")) do
				if v.Data and v.Data.ID then
					ids[v.Data.ID] = true
				end
			end
			
			local id = 1
			while ids[id] do
				id = id+1
			end
			
			data.ID = id
		
			local ent = ents.Create("trolleybus_trafficlight")
			ent:SetPos(pos)
			ent:SetAngles(ang)
			ent:Spawn()
			ent:LoadBehaviour(data)
		end
		
		Trolleybus_System.SaveTrafficLights()
	end
end)