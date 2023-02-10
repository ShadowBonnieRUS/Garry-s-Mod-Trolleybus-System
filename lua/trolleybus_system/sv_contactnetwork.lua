-- Copyright © Platunov I. M., 2021 All rights reserved

util.AddNetworkString("Trolleybus_System.ContactNetwork.FullUpdateRequest")

Trolleybus_System.ContactNetwork.FullUpdateRequests = Trolleybus_System.ContactNetwork.FullUpdateRequests or {}

local function GetEditors()
	local plys = {}
	for k,v in ipairs(player.GetHumans()) do
		local w = v:GetActiveWeapon()

		if IsValid(w) and w:GetClass()=="gmod_tool" and w.Mode=="trolleybus_cn_editor" then
			plys[#plys+1] = v
		end
	end

	return plys
end

--[[------------------------------------
	Type: Contact Network API Function
	Name: Trolleybus_System.ContactNetwork.Load
	Desc: Loads contact network from data file for current map.
	Arg1: (optional) Player | ply | If set, sends data to player instead of loading on server. Can be table of players. If `true`, sends to all players.
	Ret1: 
--]]------------------------------------
Trolleybus_System.ContactNetwork.SaveTask = Trolleybus_System.ContactNetwork.SaveTask or nil
function Trolleybus_System.ContactNetwork.Load(ply)
	local str = Trolleybus_System.ReadDataFile("contactnetwork")

	if !ply then
		if Trolleybus_System.ContactNetwork.SaveTask and Trolleybus_System.ContactNetwork.SaveTask:IsValid() then
			Trolleybus_System.PlayerMessage(GetEditors(),0,"%s","#tool.trolleybus_cn_editor.msg.savingcanceled")
			Trolleybus_System.ContactNetwork.SaveTask:Cancel()
		end

		Trolleybus_System.ContactNetwork.ClearObjects()

		if !str then return end

		local network = util.JSONToTable(str) or {}
		local objs = {}

		for k,v in pairs(network) do
			objs[k] = Trolleybus_System.ContactNetwork.AddObject(k,v)

			if !objs[k] then
				print("Trolleybus System: Failed to load contact network object '"..k.."'")
			end
		end

		for k,v in pairs(network) do
			if !objs[k] then continue end

			for k2,v2 in pairs(v.Connections) do
				if !objs[v2[1]] then continue end

				objs[k]:ConnectConnectableTo(k2,objs[v2[1]],v2[2])
			end
		end

		Trolleybus_System.ContactNetwork.UpdateWiresVoltageLinks()
	else
		local network = str and util.JSONToTable(str) or {}
		local connections = {}

		local cluster,count,clear = {},0,true
		for k,v in pairs(network) do
			cluster[k] = v
			connections[k] = v.Connections
			v.Connections = nil

			count = count+1

			if count>=300 then
				Trolleybus_System.SendMassiveData(ply!=true and ply,{Cluster = cluster,Clear = clear},"ContactNetwork")

				cluster,count,clear = {},0,false
			end
		end

		Trolleybus_System.SendMassiveData(ply!=true and ply,{Cluster = cluster,Clear = clear,Connections = connections},"ContactNetwork")
	end
end

--[[------------------------------------
	Type: Contact Network API Function
	Name: Trolleybus_System.ContactNetwork.Save
	Desc: Saves contact network to data file for current map. This will use pseudo async task to prevent server freeze. Also sends messages to players with active contact network editor tool.
	Arg1:
	Ret1: 
--]]------------------------------------
function Trolleybus_System.ContactNetwork.Save()
	if Trolleybus_System.ContactNetwork.SaveTask and Trolleybus_System.ContactNetwork.SaveTask:IsValid() then
		Trolleybus_System.ContactNetwork.SaveTask:Cancel()
	end

	Trolleybus_System.ContactNetwork.SaveTask = Trolleybus_System.CreatePseudoAsyncTask(function(self)
		Trolleybus_System.PlayerMessage(GetEditors(),0,"%s","#tool.trolleybus_cn_editor.msg.saving")

		local objects,network = Trolleybus_System.ContactNetwork.Objects,{}

		for k,v in pairs(objects.Contacts) do
			network[k] = Trolleybus_System.ContactNetwork.GetObjectData(k,true)
			self:Yield()
		end

		for k,v in pairs(objects.SuspensionAndOther) do
			network[k] = Trolleybus_System.ContactNetwork.GetObjectData(k,true)
			self:Yield()
		end

		Trolleybus_System.WriteDataFile("contactnetwork",util.TableToJSON(network,true))

		Trolleybus_System.PlayerMessage(GetEditors(),0,"%s","#tool.trolleybus_cn_editor.msg.saved")
	end)
end

--[[------------------------------------
	Type: Contact Network API Function
	Name: Trolleybus_System.ContactNetwork.UpdateWiresVoltageLinks
	Desc: Updates contact network object wires links to corresponding voltage sources.
	Arg1:
	Ret1: 
--]]------------------------------------
function Trolleybus_System.ContactNetwork.UpdateWiresVoltageLinks()
	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
		for i=1,v:GetWiresCount() do
			v:SetWirePolarity(i,false)
			v:LinkWireToVoltageSource(i,nil)
		end
	end

	local loop = {}

	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
		if v.Cfg.VoltageSource then
			for i=1,2 do
				local positive = i%2==1
				local connections = v:GetOtherConnections(i,true)

				while #connections>0 do
					local connection = table.remove(connections,1)
					local obj,id = connection[1],connection[2]
					
					if obj.Cfg.VoltageSource then continue end

					for k2,v2 in ipairs(obj:GetWiresToUpdateVoltage(id)) do
						obj:SetWirePolarity(v2,positive)
						obj:LinkWireToVoltageSource(v2,v)
					end

					for k,v in ipairs(obj:GetNextConnectablesToUpdateVoltage(id)) do
						for k2,v2 in ipairs(obj:GetOtherConnections(v,true)) do
							if v2[1].Cfg.VoltageSource then continue end

							if !loop[v2[1]] or !loop[v2[1]][v2[2]] then
								loop[v2[1]] = loop[v2[1]] or {}
								loop[v2[1]][v2[2]] = true

								connections[#connections+1] = v2
							end
						end
					end
				end
			end
		end
	end

	Trolleybus_System.RunEvent("ContactNetwork_OnUpdateWiresVoltageLinks")
end

--[[------------------------------------
	Type: Contact Network API Hook
	Name: PlayerInitialSpawn::Trolleybus_System.ContactNetwork
	Desc: Sends contact network data to connected player.
--]]------------------------------------
hook.Add("PlayerInitialSpawn","Trolleybus_System.ContactNetwork",function(ply)
	Trolleybus_System.ContactNetwork.Load(ply)
end)

--[[------------------------------------
	Type: Contact Network API Hook
	Name: InitPostEntity::Trolleybus_System.ContactNetwork
	Desc: Loads contact network for current map when map is loaded.
--]]------------------------------------
hook.Add("InitPostEntity","Trolleybus_System.ContactNetwork",function()
	Trolleybus_System.ContactNetwork.Load()
end)

--[[------------------------------------
	Type: Contact Network API Hook
	Name: Think::Trolleybus_System.ContactNetwork
	Desc: Updates contact network object wires amperage and global contact network voltage setting.
--]]------------------------------------
local updcn
hook.Add("Think","Trolleybus_System.ContactNetwork",function()
	local upd = {}

	for k,v in ipairs(ents.FindByClass("trolleybus_ent_*")) do
		if v.HasPoles then
			for i=1,2 do
				if v:GetPoleState(i==2)!=0 then continue end

				local contact,wire = v:GetPoleContactWire(i==2)
				local object = Trolleybus_System.ContactNetwork.Objects.Contacts[contact]
				if IsValid(object) then
					upd[object] = upd[object] or {}
					upd[object][wire] = (upd[object][wire] or 0)+v:GetElectricCurrentUsage()
				end
			end
		end
	end

	for k,v in pairs(upd) do
		for k2,v2 in pairs(v) do
			k:AmperageUpdate(k2,v2)
		end
	end

	if !updcn or CurTime()-updcn>1 then
		updcn = CurTime()

		for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
			for i=1,v:GetWiresCount() do
				if !upd[v] or !upd[v][i] then
					v:AmperageUpdate(i,0)
				end
			end
		end

		Trolleybus_System.NetworkSystem.SetNWVar(game.GetWorld(),"ContactNetworkVoltage",Trolleybus_System.GetAdminSetting("trolleybus_contact_network_voltage"))
	end
end)

--[[------------------------------------
	Type: Contact Network API Hook
	Name: PlayerDisconnected::Trolleybus_System.ContactNetwork.FullUpdateRequest
	Desc: Clears full update requests cache for disconnected player.
--]]------------------------------------
hook.Add("PlayerDisconnected","Trolleybus_System.ContactNetwork.FullUpdateRequest",function(ply)
	Trolleybus_System.ContactNetwork.FullUpdateRequests[ply] = nil
end)

--[[------------------------------------
	Type: Network receiver
	Name: Trolleybus_System.ContactNetwork.FullUpdateRequest
	Desc: Handles contact network full update requests from players.
--]]------------------------------------
net.Receive("Trolleybus_System.ContactNetwork.FullUpdateRequest",function(len,ply)
	local requests = Trolleybus_System.ContactNetwork.FullUpdateRequests

	if !requests[ply] or CurTime()-requests[ply]>10 then
		requests[ply] = CurTime()

		Trolleybus_System.ContactNetwork.Load(ply)
	end
end)