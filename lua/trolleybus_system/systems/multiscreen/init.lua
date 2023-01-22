-- Copyright © Platunov I. M., 2022 All rights reserved

SYSTEM = {}

AddCSLuaFile("shared.lua")
include("shared.lua")

function SYSTEM:EnableScreen(name)
	if self.Screens[name] and self:IsScreenDisabled(name) then
		self.ScreensData[name].NW._Disabled = false

		if self.Screens[name].OnEnable then
			self.Screens[name].OnEnable(self.Trolleybus,self.ScreensData[name])
		end
	end
end

function SYSTEM:DisableScreen(name)
	if self.Screens[name] and !self:IsScreenDisabled(name) then
		self.ScreensData[name].NW._Disabled = true

		if self.Screens[name].OnDisable then
			self.Screens[name].OnDisable(self.Trolleybus,self.ScreensData[name])
		end
	end
end

function SYSTEM:Think(dt)
	for k,v in pairs(self.Screens) do
		if v.ShouldBeDisabled then
			local sdata = self.ScreensData[k]

			local old = self:IsScreenDisabled(k)
			local new = v.ShouldBeDisabled(self.Trolleybus,sdata) and true or false

			if old!=new then
				if new then self:DisableScreen(k) else self:EnableScreen(k) end
			end
		end
	end
end

Trolleybus_System.RegisterSystem("MultiScreen",SYSTEM)
SYSTEM = nil