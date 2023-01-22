-- Copyright © Platunov I. M., 2021 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.SoundName = "trolleybus/trsu.ogg"
SYSTEM.SoundPos = Vector()
SYSTEM.SoundMaxPitchRotation = 300
SYSTEM.SoundAccMaxVolumeAmperage = 150
SYSTEM.SoundDecMaxVolumeAmperage = 70
SYSTEM.SoundVolumePerRotation = 1/1000
SYSTEM.SoundPitchRange = {0.25,1}

function SYSTEM:Initialize()
	self.SoundVolume = 0
	self.SoundPitch = 0
end

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,750,0,1,{},self.SoundName)
		self.m_Sound:SetActive(true)
	end
	
	local rotation = math.abs(self:GetEngineRotation())
	local amperage = math.abs(self:GetEngineAmperage())
	local volume,pitch = 0,0
	
	if amperage>0 then
		volume = math.max(0,math.min(1,amperage/(self:IsEngineAsGenerator() and self.SoundDecMaxVolumeAmperage or self.SoundAccMaxVolumeAmperage))-math.min(1,rotation*self.SoundVolumePerRotation))
		pitch = math.min(1,rotation/self.SoundMaxPitchRotation)
	end
	
	self.SoundVolume = self.SoundVolume<volume and math.min(self.SoundVolume+dt*2,volume) or math.max(self.SoundVolume-dt*2,volume)
	self.SoundPitch = self.SoundPitch<pitch and math.min(self.SoundPitch+dt*2,pitch) or math.max(self.SoundPitch-dt*2,pitch)
	
	self.m_Sound:SetVolume(self.SoundVolume*math.min(1,self.SoundPitch))
	self.m_Sound:SetPlaybackRate(self.SoundPitchRange[1]+self.SoundPitch*(self.SoundPitchRange[2]-self.SoundPitchRange[1]))
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("TISU",SYSTEM)
SYSTEM = nil