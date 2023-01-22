-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.SoundConfig = {}
SYSTEM.SoundPos = Vector()
SYSTEM.SoundDist = 1000

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateMultiSound(self.Trolleybus,self.SoundPos,self.SoundDist,1,self.SoundConfig,function(snd,ent)
			return math.abs(self:GetRotation())
		end)
	end
end

function SYSTEM:GetRotation()
	return self:GetNWVar("Rotation",0)
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("Engine",SYSTEM)
SYSTEM = nil