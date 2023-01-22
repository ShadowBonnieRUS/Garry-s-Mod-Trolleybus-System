-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.StartSounds = Sound("trolleybus/heater_on.ogg")
SYSTEM.LoopSound = Sound("trolleybus/heater.ogg")
SYSTEM.EndSounds = Sound("trolleybus/heater_off.ogg")
SYSTEM.SoundPos = Vector()
SYSTEM.SoundVolume = 1
SYSTEM.SoundDistance = 100

function SYSTEM:Initialize()
	self.LastState = self:GetState()
end

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateWorkSound(self.Trolleybus,self.SoundPos,self.SoundDistance,self.SoundVolume,1,self.StartSounds,self.LoopSound,self.EndSounds)
	end
	
	self.m_Sound:SetActive(self:IsVentActive())
	
	if self:GetState()!=self.LastState then
		if self.LastState==0 and self.HeaterOnSound then
			Trolleybus_System.PlayBassSound(self.Trolleybus,self.HeaterOnSound,100,1,false,nil,self.SoundPos)
		elseif self:GetState()==0 and self.HeaterOffSound then
			Trolleybus_System.PlayBassSound(self.Trolleybus,self.HeaterOffSound,100,1,false,nil,self.SoundPos)
		end
		
		self.LastState = self:GetState()
	end
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("Heater",SYSTEM)
SYSTEM = nil