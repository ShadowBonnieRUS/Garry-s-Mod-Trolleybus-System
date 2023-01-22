-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.StartSounds = Sound("trolleybus/hydrbooster_on.ogg")
SYSTEM.LoopSound = Sound("trolleybus/hydrbooster.ogg")
SYSTEM.StopSounds = Sound("trolleybus/hydrbooster_off.ogg")
SYSTEM.InsideStartSounds = {}
SYSTEM.InsideLoopSound = nil
SYSTEM.InsideStopSounds = {}

SYSTEM.SoundPos = Vector()
SYSTEM.SoundDistance = 200
SYSTEM.SoundVolume = 0.75
SYSTEM.SoundVolumeInside = 0.5
SYSTEM.SwapInsideTime = 0.5

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		if self.InsideLoopSound then
			self.m_Sound = Trolleybus_System.CreateInsideOutsideSound(self.Trolleybus,self.SoundPos,self.SoundDistance,self.SoundVolume,self.SoundVolumeInside,1,self.StartSounds,self.LoopSound,self.StopSounds,self.InsideStartSounds,self.InsideLoopSound,self.InsideStopSounds,self.SwapInsideTime)
		else
			self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,self.SoundDistance,self.SoundVolume,1,self.StartSounds,self.LoopSound,self.StopSounds)
		end
	end
	
	local powerfr = self:GetPowerFraction()
	self.m_Sound:SetActive(powerfr>0)
	
	if powerfr>0 then
		local steer = self.Trolleybus:GetSteerAngle()
		
		self.powerfr = Lerp(dt*5,self.powerfr or powerfr,powerfr)
		self.m_Sound:SetPlaybackRate((1-(1-(1-math.abs(steer))^2)*0.2)*self.powerfr)
	end
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("HydraulicBooster",SYSTEM)
SYSTEM = nil