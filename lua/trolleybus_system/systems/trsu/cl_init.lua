-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.SoundName = "trolleybus/trsu.ogg"
SYSTEM.SoundPos = Vector()
SYSTEM.SoundAccAmperageVolumeMultiplier = 2/800
SYSTEM.SoundDecAmperageVolumeMultiplier = 4/150

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,1000,0,1,{},self.SoundName)
		self.m_Sound:SetActive(true)
	end
	
	local bus = self.Trolleybus
	local amperage = math.abs(self:GetEngineAmperage())
	local volume = 0
	
	if amperage>0 then
		volume = amperage*(self:IsEngineAsGenerator() and self.SoundDecAmperageVolumeMultiplier or self.SoundAccAmperageVolumeMultiplier)
	end
	
	self.m_Sound:SetVolume(math.min(1,volume))
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("TRSU",SYSTEM)
SYSTEM = nil