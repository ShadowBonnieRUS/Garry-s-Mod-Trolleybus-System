-- Copyright © Platunov I. M., 2020 All rights reserved

local System = Trolleybus_System.NetworkSystem

System.Ents = System.Ents or {}
System.StringPool = System.StringPool or {}
System.StringPoolIDs = System.StringPoolIDs or {}
System.Helpers = System.Helpers or {}

net.Receive("TrolleybusSystem_NetworkSystem",function(len)
	local received
	local stringpool
	
	while net.ReadBool() do
		local index = net.ReadUInt(32)
		local tick = net.ReadUInt(32)
		local ptick = net.ReadUInt(32)
		
		local data = System.Ents[index]
		
		if data then
			for k,v in pairs(data.snapshots) do
				if k<ptick then
					data.snapshots[k] = nil
				end
			end
		else
			data = {snapshots = {}}
			System.Ents[index] = data
		end
		
		stringpool = stringpool or {}

		local psnapshot = data.snapshots[ptick]
		local snapshot = System.ReadEntMessage(stringpool,psnapshot,System.EntFromIndex(index))
		
		data.snapshots[tick] = snapshot
		data.tick = tick
		
		received = received or {}
		received[index] = tick
	end
	
	if received then
		net.Start("TrolleybusSystem_NetworkSystem",true)
			for index,tick in pairs(received) do
				net.WriteBool(true)
				net.WriteUInt(index,32)
				net.WriteUInt(tick,32)
			end
			
			net.WriteBool(false)

			for str,index in pairs(stringpool) do
				net.WriteBool(true)
				net.WriteString(str)
				net.WriteUInt(index,32)
			end

			net.WriteBool(false)
		net.SendToServer()
	end
end)

net.Receive("TrolleybusSystem_NetworkSystem_Clear",function(len)
	local index = net.ReadUInt(32)

	System.Ents[index] = nil

	net.Start("TrolleybusSystem_NetworkSystem_Clear")
		net.WriteUInt(index,32)
	net.SendToServer()
end)

function System.ReadEntMessage(stringpool,psnapshot,ent)
	local valid = (IsValid(ent) or ent:IsWorld()) and ent.Trolleybus_System_NWVars
	local snapshot = psnapshot and Trolleybus_System.CopyValue(psnapshot) or {}
	
	while net.ReadBool() do
		local k,v = System.ReadEntVar(stringpool,psnapshot)
		
		snapshot[k] = v
		
		if valid then
			ent.Trolleybus_System_NWVars[k] = nil
		end
	end
	
	return snapshot
end

function System.ReadEntVar(stringpool,psnapshot)
	local k

	if net.ReadBool() then
		local id = net.ReadUInt(32)
		k = System.StringPool[id]
	else
		k = net.ReadString()

		if System.StringPoolIDs[k] then
			stringpool[k] = System.StringPoolIDs[k]
		else
			local id = 0
			while System.StringPool[id] do id = id+1 end

			System.StringPoolIDs[k] = id
			System.StringPool[id] = k

			stringpool[k] = id
		end
	end

	local id = net.ReadUInt(System.DataTypesBits)
	
	local dt = System.DataTypes[System.DataTypesIDs[id]]
	local v = dt.Read(psnapshot and psnapshot[k])
	
	return k,v
end

function System.SetNWVar(ent,var,value)
	assert(isentity(ent),"Bad argument #1 (expected Entity)")
	assert(isstring(var),"Bad argument #2 (expected string)")
	assert(System.DataTypes[TypeID(value)],"Bad argument #3 (unsupported data type of value)")
	assert(IsValid(ent) or ent:IsWorld(),"Bad argument #1 (invalid Entity)")
	
	ent.Trolleybus_System_NWVars = ent.Trolleybus_System_NWVars or {}
	ent.Trolleybus_System_NWVars[var] = Trolleybus_System.CopyValue(value)
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
	
	local data = System.Ents[System.GetEntIndex(ent)]
	if !data then return default end
	
	local snapshot = data.snapshots[data.tick]
	if !snapshot then return default end
	
	value = snapshot[var]
	
	if value!=nil then
		return Trolleybus_System.CopyValue(value)
	end
	
	return default
end

function System.SetHelperVar(index,var,value)
	assert(isstring(index),"Bad argument #1 (expected string)")

	local helper = System.Helpers[index]
	if !IsValid(helper) then return end

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

hook.Add("NetworkEntityCreated","Trolleybus_System.NetworkSystem.Helpers",function(ent)
	if ent:GetClass()=="trolleybus_networkhelper" then
		timer.Simple(0,function()
			if IsValid(ent) then
				System.Helpers[ent:GetHelperIndex()] = ent
			end
		end)
	end
end)