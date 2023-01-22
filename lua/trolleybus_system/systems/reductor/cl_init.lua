-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

local function Volume(self,ent)
	return math.Clamp(math.abs(ent:GetSystem("Reductor"):GetLastDifferenceLerped())/100,0.4,1)
end

SYSTEM.SoundConfig = {
	{sound = "trolleybus/raba1.ogg",startspd = 0,pratestart = 0,pratemp = 0.001974,volume = Volume,endspd = 930,fadeout = 620},
	{sound = "trolleybus/raba2.ogg",startspd = 311,pratestart = 0.5,pratemp = 0.001461,volume = Volume,fadein = 311,endspd = 1540,fadeout = 620},
	{sound = "trolleybus/raba3.ogg",startspd = 773,pratestart = 0.55,pratemp = 0.000422,volume = Volume,fadein = 460},
}

SYSTEM.SoundPos = Vector()
SYSTEM.SoundDist = 1000

function SYSTEM:Think(dt)
	if !IsValid(self.m_Sound) then
		self.m_Sound = Trolleybus_System.CreateMultiSound(self.Trolleybus,self.SoundPos,self.SoundDist,1,self.SoundConfig,function(snd,ent)
			return math.abs(self:GetRotation())
		end)
	end

	local diff = self:GetLastDifference()
	self.DiffLerp = Lerp(math.min(dt*20,1),self.DiffLerp or diff,diff)
end

function SYSTEM:GetLastDifferenceLerped()
	return self.DiffLerp or 0
end

function SYSTEM:OnRemove()
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_Sound) then self.m_Sound:Remove() end
end

Trolleybus_System.RegisterSystem("Reductor",SYSTEM)
SYSTEM = nil