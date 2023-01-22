-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.Systems = Trolleybus_System.Systems or {}

local SYSTEM_BASE = {
	SetNWVar = function(self,name,var)
		self.UsedNWVars[name] = var!=nil or nil
		self.Trolleybus:SetNWVar("sys."..self.Name..":"..self.Index.."."..name,var)
	end,
	GetNWVar = function(self,name,default)
		return self.Trolleybus:GetNWVar("sys."..self.Name..":"..self.Index.."."..name,default)
	end,
	ClearNWVars = function(self)
		for k,v in pairs(self.UsedNWVars) do
			self:SetNWVar(k,nil)
		end
	end,
	Unload = function(self)
		self:ClearNWVars()
	end,
}

function Trolleybus_System.RegisterSystem(name,data)
	Trolleybus_System.Systems[name] = setmetatable(data,{__index = SYSTEM_BASE})
	
	for k,v in ipairs(ents.GetAll()) do
		if v.IsTrolleybus and v.Systems then
			for k2,v2 in pairs(v.Systems) do
				if v2.Name==name then
					setmetatable(v2,{__index = Trolleybus_System.Systems[name]})

					if v2.OnReload then v2:OnReload() end
				end
			end
		end
	end
end

function Trolleybus_System.LoadSystem(bus,name,defvalues,index)
	local data = Trolleybus_System.Systems[name]
	
	if !data then
		ErrorNoHalt("Failed to load system '"..name.."' for trolleybus "..tostring(bus).."!\n")
		
		return
	end

	index = index or "0"
	
	local system = setmetatable({
		Name = name,
		Index = index,
		Trolleybus = bus,
		UsedNWVars = {},
		Base = SYSTEM_BASE,
	},{__index = data})
	
	bus.Systems[name..":"..index] = system
	
	if defvalues then
		for k,v in pairs(defvalues) do
			system[k] = v
		end
	end
	
	if system.Initialize then system:Initialize() end
	
	return system
end

function Trolleybus_System.UnloadSystem(bus,name,index)
	local data = Trolleybus_System.Systems[name]
	
	if !data then
		ErrorNoHalt("Failed to unload system '"..name.."' for trolleybus "..tostring(bus).."!\n")
		
		return
	end

	index = index or "0"
	
	local system = bus.Systems[name..":"..index]
	
	if system then
		system:Unload()
		
		bus.Systems[name..":"..index] = nil
	end
end

local files,folders = file.Find("trolleybus_system/systems/*","LUA")

for k,v in ipairs(files) do
	if string.GetExtensionFromFilename(v)!="lua" then continue end
	
	AddCSLuaFile("systems/"..v)
	include("systems/"..v)
end

for k,v in ipairs(folders) do
	AddCSLuaFile("systems/"..v.."/cl_init.lua")
	
	if SERVER then
		include("systems/"..v.."/init.lua")
	else
		include("systems/"..v.."/cl_init.lua")
	end
end