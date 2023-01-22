-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

local L = Trolleybus_System.GetLanguagePhrase

SYSTEM.RCSounds = nil
SYSTEM.RCSoundPos = Vector()
SYSTEM.RCSoundVolume = 0.5
SYSTEM.RCSoundDistance = 200

function SYSTEM:Think(dt)
	if self.RCSounds then
		if !IsValid(self.m_SoundCool) then
			self.m_SoundCool = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.RCSoundPos,self.RCSoundDistance,self.RCSoundVolume,1,self.RCSounds.StartSoundsCool,self.RCSounds.LoopSoundCool,self.RCSounds.StopSoundsCool)
		end
		
		if !IsValid(self.m_SoundUncool) then
			self.m_SoundUncool = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.RCSoundPos,self.RCSoundDistance,self.RCSoundVolume,1,self.RCSounds.StartSoundsUncool,self.RCSounds.LoopSoundUncool,self.RCSounds.StopSoundsUncool)
		end
	end
	
	if self.m_SoundCool and self.m_SoundUncool then
		local state = self:GetNWVar("RCState",0)
		
		if state==0 then
			if self.m_SoundCool:IsPlaying() then self.m_SoundCool:Stop() end
			if self.m_SoundUncool:IsPlaying() then self.m_SoundUncool:Stop() end
		elseif state==1 then
			if !self.m_SoundCool:IsPlaying() then self.m_SoundCool:Play() end
			if self.m_SoundUncool:IsPlaying() then self.m_SoundUncool:Stop() end
			
			self.m_SoundCool:SetActive(true)
		elseif state==2 then
			if self.m_SoundCool:IsPlaying() then self.m_SoundCool:Stop() end
			if !self.m_SoundUncool:IsPlaying() then self.m_SoundUncool:Play() end
			
			self.m_SoundUncool:SetActive(true)
		end
	end
end

function SYSTEM:OnRemove()
	if IsValid(self.m_SoundCool) then self.m_SoundCool:Remove() end
	if IsValid(self.m_SoundUncool) then self.m_SoundUncool:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_SoundCool) then self.m_SoundCool:Remove() end
	if IsValid(self.m_SoundUncool) then self.m_SoundUncool:Remove() end
end

function SYSTEM:HUDPaint(DrawText)
	local pos = self:GetPosition()
	local pedal = self:GetNWVar("PedalPos",0)

	DrawText(L("system.rksu.rc",pos),nil)
	DrawText(L("system.rksu.pedal",L("system.rksu.pedalpos"..pedal)),nil)
end

function SYSTEM:GetPosition()
	return self:GetNWVar("Position",0)
end

Trolleybus_System.RegisterSystem("RKSU",SYSTEM)
SYSTEM = nil