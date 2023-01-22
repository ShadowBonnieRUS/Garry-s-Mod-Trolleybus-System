-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.NetworkSystem = Trolleybus_System.NetworkSystem or {}
local System = Trolleybus_System.NetworkSystem

System.DataTypes = {
	[TYPE_STRING] = {
		ID = 0,
		Write = function(value) net.WriteString(value) end,
		Read = function() return net.ReadString() end,
	},
	[TYPE_NUMBER] = {
		ID = 1,
		Write = function(value) net.WriteFloat(value) end,
		Read = function() return net.ReadFloat() end,
	},
	[TYPE_ANGLE] = {
		ID = 2,
		Write = function(value) net.WriteAngle(value) end,
		Read = function() return net.ReadAngle() end,
	},
	[TYPE_VECTOR] = {
		ID = 3,
		Write = function(value) net.WriteVector(value) end,
		Read = function() return net.ReadVector() end,
	},
	[TYPE_BOOL] = {
		ID = 4,
		Write = function(value) net.WriteBit(value) end,
		Read = function() return net.ReadBit()==1 end,
	},
	[TYPE_NIL] = {
		ID = 5,
		Write = function(value) end,
		Read = function() return nil end,
	},
}

System.DataTypesIDs = {}
System.DataTypesBits = 0

do
	local max = 0
	
	for k,v in pairs(System.DataTypes) do
		System.DataTypesIDs[v.ID] = k
	
		if max<v.ID then max = v.ID end
	end
	
	System.DataTypesBits = math.ceil(math.log(max+1,2))
end

function System.GetEntIndex(ent)
	return ent:EntIndex()
end

function System.EntFromIndex(index)
	return Entity(index)
end

function System.CopyTable(tab)
	local copy = {}
	
	for k,v in pairs(tab) do
		copy[k] = System.CopyValue(v)
	end
	
	return copy
end

function System.CopyValue(value)
	if isvector(value) then
		return Vector(value)
	elseif isangle(value) then
		return Angle(value)
	end

	return value
end
