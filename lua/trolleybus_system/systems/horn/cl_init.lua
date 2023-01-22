-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.StartSounds = Sound("trolleybus/horn_start.ogg")
SYSTEM.LoopSound = Sound("trolleybus/horn.ogg")
SYSTEM.StopSounds = Sound("trolleybus/horn_end.ogg")
SYSTEM.SoundPos = Vector()

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,1000,1,1,self.StartSounds,self.LoopSound,self.StopSounds)
	end
	
	self.m_Sound:SetActive(self:GetNWVar("Active",false))
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("Horn",SYSTEM)
SYSTEM = nil