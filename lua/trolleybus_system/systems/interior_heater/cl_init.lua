-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.StartSounds = Sound("trolleybus/heater_on.ogg")
SYSTEM.LoopSound = Sound("trolleybus/heater.ogg")
SYSTEM.EndSounds = Sound("trolleybus/heater_off.ogg")
SYSTEM.SoundPos = Vector()
SYSTEM.SoundVolume = 0.5
SYSTEM.SoundDistance = 250

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,self.SoundDistance,self.SoundVolume,1,self.StartSounds,self.LoopSound,self.EndSounds)
	end
	
	self.m_Sound:SetActive(self:IsVentActive())
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("InteriorHeater",SYSTEM)
SYSTEM = nil