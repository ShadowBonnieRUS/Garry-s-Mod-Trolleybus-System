-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.TrafficLightIDs = Trolleybus_System.TrafficLightIDs or {}

Trolleybus_System.ControlWithoutWires = CreateConVar("trolleybus_control_without_wires",0)
Trolleybus_System.CheckPolesCross = CreateConVar("trolleybus_poles_cross_check",1)
Trolleybus_System.MaxTrolleybuses = CreateConVar("trolleybus_max_trolleybuses",15)
Trolleybus_System.SpawnNotify = CreateConVar("trolleybus_spawn_notify",1)
Trolleybus_System.StopRouteCheck = CreateConVar("trolleybus_stop_route_check",1)

util.AddNetworkString("TrolleybusSystem_Buttons")
util.AddNetworkString("TrolleybusSystem_Informators")
util.AddNetworkString("TrolleybusSystem_CreateBus")
util.AddNetworkString("TrolleybusSystem_ElecSpark")

if !file.Exists("trolleybussystem","DATA") then file.CreateDir("trolleybussystem") end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.SetOwner
	Desc: Sets the owner of given entity. If CPPI is exists, also sets owner using CPPI.
	Arg1: Entity | ent | Entity to set owner to.
	Arg2: Player | ply | The owner player.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.SetOwner(ent,ply)
	if IsValid(ply) and ent.CPPISetOwner then ent:CPPISetOwner(ply) end
	ent.Owner = ply
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.WriteDataFile
	Desc: Writes data to trolleybus system data directory of current map. Does nothing when current map is default and default maps editing is not allowed.
	Arg1: string | type | Data type. Actually, this is a file name.
	Arg2: string | data | Data to be written.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.WriteDataFile(type,data)
	if Trolleybus_System.DefaultMaps[game.GetMap()] and !Trolleybus_System.IsEditingDefaultMapsAllowed() then return end

	if !file.Exists("trolleybussystem/"..game.GetMap(),"DATA") then file.CreateDir("trolleybussystem/"..game.GetMap()) end

	file.Write("trolleybussystem/"..game.GetMap().."/"..type..".txt",data)
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.ReadDataFile
	Desc: Reads data from trolleybus system data directory of current map. If reading is failed, tries to read from LUA directory. When current map is default and default maps editing is not allowed, reads only from LUA directory.
	Arg1: string | type | Data type. Actually, this is a file name.
	Ret1: string | Data from file. Will be nil on fail.
--]]------------------------------------
function Trolleybus_System.ReadDataFile(type)
	if Trolleybus_System.DefaultMaps[game.GetMap()] and !Trolleybus_System.IsEditingDefaultMapsAllowed() then
		return file.Read("trolleybus_system/data/"..game.GetMap().."/"..type..".lua","LUA")
	end

	return
		file.Read("trolleybussystem/"..game.GetMap().."/"..type..".txt") or
		file.Read("trolleybus_system/data/"..game.GetMap().."/"..type..".lua","LUA")
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.UpdateTransmit
	Desc: Used to constant call in hooks like `Think`. Controls data transfer for all players, hides given entity when distance between player and entity bigger than value from given player setting. Updates one time per second.
	Arg1: Entity | self | Entity to control data transfer of.
	Arg2: string | setting | Name of player setting to get distance value from.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.UpdateTransmit(self,setting)
	if !self.UpdateTransmit or CurTime()-self.UpdateTransmit>1 then
		self.UpdateTransmit = CurTime()
		
		for k,v in ipairs(player.GetHumans()) do
			local dist = Trolleybus_System.GetPlayerSetting(v,setting)
			Trolleybus_System.SetPreventTransmit(self,v,Trolleybus_System.EyePos(v):DistToSqr(self:GetPos())>dist*dist or !v:TestPVS(self))
		end
	end
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.SaveTrafficTracks
	Desc: Saves data of traffic tracks on current map to data file. Also sends data of one/all tracks to players.
	Arg1: (optional) number | id | If set, sends only track with this ID.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.SaveTrafficTracks(id)
	Trolleybus_System.WriteDataFile("traffictracks",util.TableToJSON(Trolleybus_System.TrafficTracks,true))

	if id then
		Trolleybus_System.SendMassiveData(nil,{id = id,track = Trolleybus_System.TrafficTracks[id]},"Trolleybus_System.TrafficTrackUpdate")
	else
		Trolleybus_System.LoadTrafficTracks(true)
	end
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.LoadTrafficTracks
	Desc: Loads traffic data for current map from data file. If no player given, saves data to server memory, else will send data to player(s).
	Arg1: (optional) Player | ply | Player to send data to. Can also be table of players. If `true`, sends to all players.
	Arg2: (optional) bool | force | If set and data cannot be read, this will try to use existing data.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.LoadTrafficTracks(ply,force)
	local str = Trolleybus_System.ReadDataFile("traffictracks")
	if !str and !force then return end

	if !ply then
		local data = util.JSONToTable(str)
		
		Trolleybus_System.TrafficTracks = data
	else
		Trolleybus_System.SendMassiveData(ply!=true and ply or nil,str and util.JSONToTable(str) or Trolleybus_System.TrafficTracks,"Trolleybus_System.TrafficTracks")
	end
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.SaveTrafficLights
	Desc: Saves all traffic lights to data file for current map. Ignores traffic lights with no data.
	Arg1:
	Ret1: 
--]]------------------------------------
function Trolleybus_System.SaveTrafficLights()
	local data = {}
	
	for k,v in ipairs(ents.FindByClass("trolleybus_trafficlight")) do
		if !v.Data or v.ToRemove then continue end
		
		local pos,ang = v:GetPos(),v:GetAngles()
		local baseindex = Trolleybus_System.NetworkSystem.GetNWVar(v,"TrafficLightBase")
		
		if baseindex then
			local base = Entity(baseindex)
			
			if IsValid(base) then
				pos,ang = base:GetPos(),base:GetAngles()
			end
		end
		
		table.insert(data,{
			pos = pos,
			ang = ang,
			data = v.Data,
		})
	end

	Trolleybus_System.WriteDataFile("trafficlights",util.TableToJSON(data,true))
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.LoadTrafficLights
	Desc: Loads all traffic lights from data file for current map. Removes all old traffic lights.
	Arg1:
	Ret1: 
--]]------------------------------------
function Trolleybus_System.LoadTrafficLights()
	local data = Trolleybus_System.ReadDataFile("trafficlights")
	
	if data then
		data = util.JSONToTable(data)
	
		for k,v in ipairs(ents.FindByClass("trolleybus_trafficlight")) do
			v:Remove()
		end
	
		for i=1,#data do
			local ent = ents.Create("trolleybus_trafficlight")
			ent:SetPos(data[i].pos)
			ent:SetAngles(data[i].ang)
			ent:Spawn()
			ent:LoadBehaviour(data[i].data)
		end
	end
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.SaveInformators
	Desc: Saves informators data to data file for current map and sync it with players.
	Arg1:
	Ret1: 
--]]------------------------------------
function Trolleybus_System.SaveInformators()
	local str = util.TableToJSON(Trolleybus_System.Informators,true)
	Trolleybus_System.WriteDataFile("informators",str)
	
	str = util.Compress(str)
	
	net.Start("TrolleybusSystem_Informators")
		net.WriteUInt(#str,32)
		net.WriteData(str,#str)
	net.Broadcast()
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.LoadInformators
	Desc: Loads informators data from data file for current map. If no player given, saves data to server memory, else will send data to player(s).
	Arg1: (optional) Player | ply | Player to send data to. Can also be table of players. If `true`, sends to all players.
	Arg2: (optional) bool | force | If set and data cannot be read, this will try to use existing data.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.LoadInformators(ply,force)
	local str = Trolleybus_System.ReadDataFile("informators")
	if !str and !force then return end

	if !ply then
		local data = util.JSONToTable(str)
		
		Trolleybus_System.Informators = data
	else
		str = util.Compress(str or util.TableToJSON(Trolleybus_System.Informators))
		
		net.Start("TrolleybusSystem_Informators")
			net.WriteUInt(#str,32)
			net.WriteData(str,#str)
		if ply!=true then net.Send(ply) else net.Broadcast() end
	end
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.ForceFlyOffPole
	Desc: Forcing trolleybus pole to fly off.
	Arg1: Entity | self | Trolleybus entity.
	Arg2: bool | right | If `true` - use right pole, else - use left pole.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.ForceFlyOffPole(self,right)
	if self:GetPoleState(right)!=0 then return end

	self:SetPoleState(1,right)
	self:SetPoleStateTime(CurTime(),right)

	local t = self.PolesData[right and "Right" or "Left"]
	self:SetPoleMoveAng(t.LastPoleAng or self:GetPoleMoveAng(right),right)

	local contact,wire = self:GetPoleContactWire(right)
	local object = Trolleybus_System.ContactNetwork.GetObject(contact)
	
	if object then
		object:OnWheelLeave(self,wire)
	end
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.ElectricSpark
	Desc: Sends signal to players fo generating electric spark effect on given position.
	Arg1: Vector | pos | Position where spark will be generated.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.ElectricSpark(pos)
	net.Start("TrolleybusSystem_ElecSpark",true)
		net.WriteVector(pos)
	net.SendPVS(pos)
end

--[[------------------------------------
	Type: Main API Function
	Name: Trolleybus_System.IsButtonDown
	Desc: Returns is given button down by player or not.
	Arg1: Player | ply | Player to check.
	Arg2: int | button | Button to check. See Enums/BUTTON_CODE.
	Ret1: bool | Whenever given button is down or not.
--]]------------------------------------
function Trolleybus_System.IsButtonDown(ply,button)
	return ply.TrolleybusSystem_ButtonsActive and ply.TrolleybusSystem_ButtonsActive[button] and true or false
end

--[[------------------------------------
	Type: Main API Hook
	Name: InitPostEntity::Trolleybus_System
	Desc: Loads traffic lights, traffic tracks and informators for current map when map is loaded.
--]]------------------------------------
hook.Add("InitPostEntity","Trolleybus_System",function()
	Trolleybus_System.LoadTrafficTracks()
	Trolleybus_System.LoadTrafficLights()
	Trolleybus_System.LoadInformators()
end)

--[[------------------------------------
	Type: Main API Hook
	Name: PlayerInitialSpawn::Trolleybus_System
	Desc: Sends data of traffic tracks and informators for current map on connected player.
--]]------------------------------------
hook.Add("PlayerInitialSpawn","Trolleybus_System",function(ply)
	Trolleybus_System.LoadTrafficTracks(ply)
	Trolleybus_System.LoadInformators(ply)
end)

--[[------------------------------------
	Type: Main API Hook
	Name: KeyPress::Trolleybus_System
	Desc: Handles left mouse button press for button pressing in trolleybuses.
--]]------------------------------------
hook.Add("KeyPress","Trolleybus_System",function(ply,key)
	if key==IN_ATTACK then
		local bus = ply.TrolleybusButtons_lastbus
		local button = ply.TrolleybusButtons_lastbutton
		
		if button and IsValid(bus) and bus.IsTrolleybus then
			bus:TryPressButtonBy(ply,button,ply:InVehicle() and 2 or 1)
		end
	end
end)

--[[------------------------------------
	Type: Main API Hook
	Name: PlayerButtonDown::Trolleybus_System
	Desc: Handles buttons presses and hot key presses for button pressing in trolleybuses.
--]]------------------------------------
hook.Add("PlayerButtonDown","Trolleybus_System",function(ply,key)
	ply.TrolleybusSystem_ButtonsActive = ply.TrolleybusSystem_ButtonsActive or {}
	ply.TrolleybusSystem_ButtonsActive[key] = true
	
	if Trolleybus_System.PlayerInDriverPlace(nil,ply) then
		local bus = Trolleybus_System.GetSeatTrolleybus(ply:GetVehicle())
		local btn,count
		
		for k,v in pairs(bus.m_ButtonsData) do
			if v.hotkey and bus:CanButtonBePressedBy(ply,k) and bus:CanButtonBePressedByType(ply,k,4) then
				local keys = Trolleybus_System.GetHotkeyButtons(ply,bus,k)
				local c = 1

				if istable(keys) then
					if !table.HasValue(keys,key) then continue end

					c = #keys
				else
					if keys!=key then continue end
				end

				if !count or c>count then
					btn,count = k,c
				end
			end
		end

		if btn then
			bus:TryPressButtonBy(ply,btn,4)
		end
	end
end)

--[[------------------------------------
	Type: Main API Hook
	Name: PlayerButtonUp::Trolleybus_System
	Desc: Handles buttons releases.
--]]------------------------------------
hook.Add("PlayerButtonUp","Trolleybus_System",function(ply,key)
	ply.TrolleybusSystem_ButtonsActive = ply.TrolleybusSystem_ButtonsActive or {}
	ply.TrolleybusSystem_ButtonsActive[key] = false
end)

--[[------------------------------------
	Type: Main API Hook
	Name: PlayerLeaveVehicle::Trolleybus_System
	Desc: Corrects exit position and eye angles when player leaves trolleybus seat.
--]]------------------------------------
hook.Add("PlayerLeaveVehicle","Trolleybus_System",function(ply,veh)
	if IsValid(veh) then
		local bus = Trolleybus_System.GetSeatTrolleybus(veh)
		
		if IsValid(bus) then
			local pos = veh.ExitPos and bus:LocalToWorld(veh.ExitPos) or util.TraceLine({start = veh:GetPos(),endpos = veh:GetPos()-Vector(0,0,100),filter = {ply,veh}}).HitPos
			ply:SetPos(pos)
			
			local ang = bus:GetAngles()
			ang.r = 0
			ply:SetEyeAngles(ang)
		end
	end
end)

--[[------------------------------------
	Type: Main API Hook
	Name: PostCleanupMap::Trolleybus_System.ReloadData
	Desc: Reloads trolleybus map objects from contact network, routes and traffic lights data.
--]]------------------------------------
hook.Add("PostCleanupMap","Trolleybus_System.ReloadData",function()
	Trolleybus_System.ContactNetwork.Load()
	Trolleybus_System.ContactNetwork.Load(true,true)
	
	Trolleybus_System.Routes.Load()
	Trolleybus_System.Routes.Load(true,true)

	Trolleybus_System.LoadTrafficLights()
end)

--[[------------------------------------
	Type: Network receiver
	Name: TrolleybusSystem_Buttons
	Desc: Handles player information about current button and position aimed in trolleybus.
--]]------------------------------------
net.Receive("TrolleybusSystem_Buttons",function(len,ply)
	local tick = net.ReadUInt(32)
	local bus = net.ReadEntity()
	local button = net.ReadBool() and net.ReadString() or nil
	local x = net.ReadBool() and net.ReadFloat() or nil
	local y = net.ReadBool() and net.ReadFloat() or nil
	
	if ply.TrolleybusButtons_lasttick==tick then return end
	
	ply.TrolleybusButtons_lasttick = tick
	ply.TrolleybusButtons_lastbus = bus
	ply.TrolleybusButtons_lastbutton = button
	ply.TrolleybusButtons_lastx = x
	ply.TrolleybusButtons_lasty = y
	
	net.Start("TrolleybusSystem_Buttons",true)
		net.WriteUInt(tick,32)
	net.Send(ply)
end)

--[[------------------------------------
	Type: Network receiver
	Name: TrolleybusSystem_CreateBus
	Desc: Handles trolleybus creation from creation tab and updating trolleybuses from settings menu.
--]]------------------------------------
net.Receive("TrolleybusSystem_CreateBus",function(len,ply)
	local updating = net.ReadBool()
	local class = net.ReadString()
	local customsettings = {}
	
	while true do
		local setting = net.ReadUInt(8)
		if setting==0 then break end
		
		customsettings[setting] = net.ReadType()
	end
	
	local ENT = scripted_ents.GetStored(class)
	if !ENT or !Trolleybus_System.IsTrolleybusMetatable(ENT) then return end
	
	if updating then
		if ply.Trolleybus_System_UpdateBusTime and CurTime()-ply.Trolleybus_System_UpdateBusTime<1 then return end
		if !ply:InVehicle() then return end
		
		local bus = Trolleybus_System.GetSeatTrolleybus(ply:GetVehicle())
		if !IsValid(bus) or bus:GetClass()!=class or bus.Owner!=ply or !Trolleybus_System.PlayerInDriverPlace(bus,ply) then return end
		
		ply.Trolleybus_System_UpdateBusTime = CurTime()
		
		bus.CustomSpawnSettings = customsettings
		bus:SetupSpawnSettings()
		
		if IsValid(bus:GetTrailer()) then
			bus:GetTrailer().CustomSpawnSettings = customsettings
			bus:GetTrailer():SetupSpawnSettings()
		end
		
		return
	end
	
	if !hook.Run("PlayerSpawnSENT",ply,class) then return end
	
	local count = 0
	local max = Trolleybus_System.GetAdminSetting("trolleybus_max_trolleybuses")
	
	for k,v in ipairs(ents.GetAll()) do
		if v.IsTrolleybus then
			count = count+1
			
			if count>=max then
				Trolleybus_System.PlayerMessage(ply,1,"%s","#trolleybus_limit_reached")
				
				return
			end
		end
	end
	
	local pos = Trolleybus_System.EyePos(ply)
	local dir = ply:GetAimVector()
	local tr = util.TraceLine({start = pos,endpos = pos+dir*4096,filter = ply})
	if !tr.Hit then return end

	local ent = ents.Create(class)
	ent:SetPos(tr.HitPos)
	ent:SetAngles(Angle(0,ply:EyeAngles().y+180,0))
	
	Trolleybus_System.SetOwner(ent,ply)
	ent.CustomSpawnSettings = customsettings
	
	if ent.PreInitialize then ent:PreInitialize(ply,tr) end
	
	ent:Spawn()
	ent:SetCreator(ply)
	ent:SetBortNumber(Trolleybus_System.GetPlayerSetting(ply,"BortNumber"))
	
	hook.Run("PlayerSpawnedSENT",ply,ent)

	undo.Create("SENT")
		undo.SetPlayer(ply)
		undo.AddEntity(ent)
		if ENT.PrintName then
			undo.SetCustomUndoText("Undone "..ENT.PrintName)
		end
	undo.Finish("Trolleybus "..(ENT.PrintName or class))

	ply:AddCleanup("sents",ent)
	ent:SetVar("Player",ply)
end)

--[[------------------------------------
	Type: Console command
	Name: trolleybus_reload_data
	Desc: Allows reload all trolleybus system data for current map.
--]]------------------------------------
concommand.Add("trolleybus_reload_data",function(ply,cmd,args,str)
	if IsValid(ply) and !Trolleybus_System.RunEvent("HasAccessToAdminSettings",ply) then return end
	
	Trolleybus_System.ContactNetwork.Load()
	Trolleybus_System.ContactNetwork.Load(true)
	
	Trolleybus_System.Routes.Load()
	Trolleybus_System.Routes.Load(true)

	Trolleybus_System.TrafficTracks = {}
	Trolleybus_System.LoadTrafficTracks()
	Trolleybus_System.LoadTrafficTracks(true,true)
	
	Trolleybus_System.LoadTrafficLights()
	
	Trolleybus_System.Informators = {}
	Trolleybus_System.LoadInformators()
	Trolleybus_System.LoadInformators(true,true)
end)