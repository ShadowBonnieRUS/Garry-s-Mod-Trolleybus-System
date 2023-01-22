-- Copyright © Platunov I. M., 2020 All rights reserved

util.AddNetworkString("TrolleybusSystem_NetworkSystem")
util.AddNetworkString("TrolleybusSystem_NetworkSystem_Clear")

local System = Trolleybus_System.NetworkSystem

System.Players = System.Players or {}
System.Ents = System.Ents or {}
System.StringPool = System.StringPool or {}
System.Helpers = System.Helpers or {}

local UpdateTime = 1/20
local LowUpdateTime = 1/5
local MaxSnapshotLifeTicks = 5/engine.TickInterval()
local ResendTime = 0.5

local function ShouldPreventTransmitEnt(ent,ply)
	if ent:IsPlayer() or ent:IsWorld() then return false end
	if Trolleybus_System.GetPreventTransmit(ent,ply) then return true end

	if ent.UpdateTransmitState then
		local state = ent:UpdateTransmitState()

		if state==TRANSMIT_ALWAYS then
			return false
		elseif state==TRANSMIT_NEVER then
			return true
		end
	end

	return !ply:TestPVS(ent)
end

local update,lagcount,lastlag,prevrt = CurTime(),0,CurTime(),RealTime()
hook.Add("Think","TrolleybusSystem_NetworkSystem",function()
	local rt = RealTime()
	if rt==prevrt then
		lagcount = lagcount+1

		if lagcount>=3 then
			lastlag = CurTime()
		end

		return
	end
	prevrt,lagcount = rt,0

	local CT = CurTime()
	if CT-update<(CT-lastlag<1 and LowUpdateTime or UpdateTime) then return end
	update = CT
	
	local plys = player.GetHumans()
	
	for p=1,#plys do
		local send = false
		local ply = plys[p]
		
		if System.UpdateEnts then
			local tick = engine.TickCount()
			
			for ent,vars in pairs(System.UpdateEnts) do
				if !IsValid(ent) and !ent:IsWorld() then continue end
				
				local index = System.GetEntIndex(ent)
				local dt = System.Ents[index]
				
				if !dt then
					dt = {snapshots = {},seq = {}}
					System.Ents[index] = dt
				else
					local i = 1
					while i<#dt.seq do
						local t = dt.seq[i]

						if tick-t>MaxSnapshotLifeTicks then
							table.remove(dt.seq,i)

							local nt = dt.seq[i]
							local prev = dt.snapshots[t]
							local cur = dt.snapshots[nt]

							for k,v in pairs(cur) do
								prev[k] = v
							end

							dt.snapshots[t] = nil
							dt.snapshots[nt] = prev
						else
							i = i+1
						end
					end
				end
				
				dt.tick = tick
				dt.snapshots[tick] = {}
				dt.seq[#dt.seq+1] = tick
				
				for k,v in pairs(vars) do
					dt.snapshots[tick][k] = v
				end
			end
		
			System.UpdateEnts = nil
		end
		
		local pdata = System.Players[ply]
		
		for index,data in pairs(System.Ents) do
			local ent = System.EntFromIndex(index)
			if ShouldPreventTransmitEnt(ent,ply) then continue end
			
			if !pdata then
				pdata = {}
				System.Players[ply] = pdata
			end
			
			local datap = pdata[index]
			
			local tick = data.tick
			local ptick = datap and datap.tick or 0
			
			if tick!=ptick then
				if datap and datap.sendedtick and datap.sendedtime and datap.sendedtick==tick and CT-datap.sendedtime<ResendTime then continue end
				
				if !send then
					send = true
					net.Start("TrolleybusSystem_NetworkSystem",true)
				end
				
				net.WriteBool(true)
				net.WriteUInt(index,32)
				net.WriteUInt(tick,32)
				net.WriteUInt(ptick,32)
				
				System.WriteEntMessage(ply,index,ptick)
				
				if !datap then
					datap = {}
					pdata[index] = datap
				end
				
				datap.sendedtick = tick
				datap.sendedtime = CT

				if net.BytesWritten()>30000 then break end
			end
		end
		
		if send then
			net.WriteBool(false)
			net.Send(ply)
		end
	end
end)

hook.Add("EntityRemoved","TrolleybusSystem_NetworkSystem",function(ent)
	local index = System.GetEntIndex(ent)
	
	if System.Ents[index] and (index!=0 or ent==game.GetWorld()) then
		System.Ents[index] = nil
		
		local delete = {}
		
		for ply,pdata in pairs(System.Players) do
			if pdata[index] then
				pdata[index] = nil
				delete[#delete+1] = ply
			end
		end

		if #delete>0 then
			net.Start("TrolleybusSystem_NetworkSystem_Clear")
				net.WriteUInt(index,32)
			net.Send(delete)
		end
	end
end)

hook.Add("PlayerDisconnected","TrolleybusSystem_NetworkSystem",function(ply)
	System.Players[ply] = nil
	System.StringPool[ply] = nil
end)

net.Receive("TrolleybusSystem_NetworkSystem",function(len,ply)
	while net.ReadBool() do
		local index = net.ReadUInt(32)
		local tick = net.ReadUInt(32)
		
		local pdata = System.Players[ply]
		
		if pdata and pdata[index] then
			pdata[index].tick = tick
		end
	end

	while net.ReadBool() do
		local str = net.ReadString()
		local index = net.ReadUInt(32)

		System.StringPool[ply] = System.StringPool[ply] or {}
		System.StringPool[ply][str] = index
	end
end)

net.Receive("TrolleybusSystem_NetworkSystem_Clear",function(len,ply)
	local index = net.ReadUInt(32)

	if System.Players[ply] and System.Players[ply][index] then
		System.Players[ply][index] = nil
	end
end)

function System.GetPooledStringID(ply,str)
	return System.StringPool[ply] and System.StringPool[ply][str]
end

function System.WriteEntMessage(ply,index,ptick)
	local dt = System.Ents[index]
	local writen = {}

	for i=#dt.seq,1,-1 do
		local t = dt.seq[i]

		for k,v in pairs(dt.snapshots[t]) do
			if writen[k] then continue end

			net.WriteBool(true)

			if v=="%nil%" then
				System.WriteEntVar(ply,k,nil)
			else
				System.WriteEntVar(ply,k,v)
			end

			writen[k] = true
		end

		if t<=ptick then break end
	end
	
	net.WriteBool(false)
end

function System.WriteEntVar(ply,key,value)
	local dt = System.DataTypes[TypeID(value)]
	local id = System.GetPooledStringID(ply,key)

	if id then
		net.WriteBool(true)
		net.WriteUInt(id,32)
	else
		net.WriteBool(false)
		net.WriteString(key)
	end

	net.WriteUInt(dt.ID,System.DataTypesBits)
	dt.Write(value)
end

function System.SetNWVar(ent,var,value)
	assert(isentity(ent),"Bad argument #1 (expected Entity)")
	assert(isstring(var),"Bad argument #2 (expected string)")
	assert(System.DataTypes[TypeID(value)],"Bad argument #3 (unsupported data type of value)")
	assert(IsValid(ent) or ent:IsWorld(),"Bad argument #1 (invalid Entity)")
	
	ent.Trolleybus_System_NWVars = ent.Trolleybus_System_NWVars or {}

	local oldvalue = ent.Trolleybus_System_NWVars[var]
	value = Trolleybus_System.CopyValue(value)
	
	if oldvalue!=value then
		ent.Trolleybus_System_NWVars[var] = value
		
		System.UpdateEnts = System.UpdateEnts or {}
		System.UpdateEnts[ent] = System.UpdateEnts[ent] or {}
		System.UpdateEnts[ent][var] = value==nil and "%nil%" or value
	end
end

function System.GetNWVar(ent,var,default)
	assert(isentity(ent),"Bad argument #1 (expected Entity)")
	assert(isstring(var),"Bad argument #2 (expected string)")
	assert(System.DataTypes[TypeID(default)],"Bad argument #3 (unsupported data type of default value)")
	assert(IsValid(ent) or ent:IsWorld(),"Bad argument #1 (invalid Entity)")
	
	local vars = ent.Trolleybus_System_NWVars
	local value = vars and vars[var]
	
	if value!=nil then
		return Trolleybus_System.CopyValue(value)
	end
	
	return default
end

function System.SetHelperVar(index,var,value)
	assert(isstring(index),"Bad argument #1 (expected string)")

	local helper = System.Helpers[index]
	if !IsValid(helper) then
		helper = ents.Create("trolleybus_networkhelper")

		if !IsValid(helper) then
			ErrorNoHalt("Trolleybus_System.NetworkSystem.SetHelperVar failed to create helper '"..index.."'!")
			return
		end

		System.Helpers[index] = helper
		helper:SetHelperIndex(index)
	end

	System.SetNWVar(helper,var,value)
end

function System.GetHelperVar(index,var,default)
	assert(isstring(index),"Bad argument #1 (expected string)")

	local helper = System.Helpers[index]
	if IsValid(helper) then
		return System.GetNWVar(helper,var,default)
	end

	return default
end

local savedhelpers
hook.Add("PreCleanupMap","Trolleybus_System.NetworkSystemHelpers",function()
	savedhelpers = {}

	for k,v in pairs(System.Helpers) do
		savedhelpers[k] = v.Trolleybus_System_NWVars
	end

	table.Empty(System.Helpers)
end)

hook.Add("PostCleanupMap","Trolleybus_System.NetworkSystemHelpers",function()
	if savedhelpers then
		for k,v in pairs(savedhelpers) do
			for k2,v2 in pairs(v) do
				System.SetHelperVar(k,k2,v2)
			end
		end

		savedhelpers = nil
	end
end)