-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.StartSounds = {}
SYSTEM.LoopSound = Sound("trolleybus/buzzer_default.ogg")
SYSTEM.StopSounds = {}
SYSTEM.SoundPos = Vector()
SYSTEM.Volume = 1
SYSTEM.Distance = 100

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,self.Distance,self.Volume,1,self.StartSounds,self.LoopSound,self.StopSounds)
	end
	
	self.m_Sound:SetActive(self:IsActive())
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("Buzzer",SYSTEM)
SYSTEM = nil