-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.StartSounds = Sound("trolleybus/motorvent_start.ogg")
SYSTEM.LoopSound = Sound("trolleybus/motorvent.ogg")
SYSTEM.StopSounds = Sound("trolleybus/motorvent_stop.ogg")
SYSTEM.InsideStartSounds = {}
SYSTEM.InsideLoopSound = nil
SYSTEM.InsideStopSounds = {}

SYSTEM.SoundDistance = 500
SYSTEM.SoundVolume = 0.5
SYSTEM.SoundVolumeInside = 0.5
SYSTEM.SoundPos = Vector(0,0,0)
SYSTEM.SwapInsideTime = 0.5

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		if self.InsideLoopSound then
			self.m_Sound = Trolleybus_System.CreateInsideOutsideSound(self.Trolleybus,self.SoundPos,self.SoundDistance,self.SoundVolume,self.SoundVolumeInside,1,self.StartSounds,self.LoopSound,self.StopSounds,self.InsideStartSounds,self.InsideLoopSound,self.InsideStopSounds,self.SwapInsideTime)
		else
			self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,self.SoundDistance,self.SoundVolume,1,self.StartSounds,self.LoopSound,self.StopSounds)
		end
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

Trolleybus_System.RegisterSystem("MotorVentilator",SYSTEM)
SYSTEM = nil