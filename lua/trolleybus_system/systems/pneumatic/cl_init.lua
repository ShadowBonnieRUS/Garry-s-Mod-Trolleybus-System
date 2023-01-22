-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

SYSTEM.MotorCompressorSounds = {
	StartSounds = Sound("trolleybus/compress_start.mp3"),
	LoopSound = Sound("trolleybus/compress_loop.ogg"),
	EndSounds = Sound("trolleybus/compress_end.mp3"),
	SndVolume = 0.5,
	
	InsideStartSounds = {},
	InsideLoopSound = nil,
	InsideEndSounds = {},
	InsideSndVolume = 0.5,
	
	SoundPos = Vector(),
}

function SYSTEM:Think()
	if !IsValid(self.m_MCSound) then
		local mc = self.MotorCompressorSounds
		
		if mc.InsideLoopSound then
			self.m_MCSound = Trolleybus_System.CreateInsideOutsideSound(self.Trolleybus,mc.SoundPos,1000,mc.SndVolume or 0.5,mc.InsideSndVolume or 0.5,1,mc.StartSounds,mc.LoopSound,mc.EndSounds,mc.InsideStartSounds,mc.InsideLoopSound,mc.InsideEndSounds)
		else
			self.m_MCSound = Trolleybus_System.CreateWorkSound(self.Trolleybus,mc.SoundPos,1000,mc.SndVolume or 0.5,1,mc.StartSounds,mc.LoopSound,mc.EndSounds)
		end
	end
	
	self.m_MCSound:SetActive(self:GetNWVar("MCActive",false))
end

function SYSTEM:OnRemove()
	if IsValid(self.m_MCSound) then self.m_MCSound:Remove() end
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	if IsValid(self.m_MCSound) then self.m_MCSound:Remove() end
end

function SYSTEM:ModifyDoorsSpeed(name)
	for k,v in ipairs(self.Receivers) do
		if v.PneumaticDoors and v.PneumaticDoors[name] then
			local min,max = v.PneumaticDoors[name][1],v.PneumaticDoors[name][2]
			local air = self:GetAir(k)

			if air<=min then return 0.1 end
			if air>=max then return 1 end

			return math.Remap(air,min,max,0.1,1)
		end
	end
end

Trolleybus_System.RegisterSystem("Pneumatic",SYSTEM)
SYSTEM = nil