-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.BassSounds = Trolleybus_System.BassSounds or {}

util.AddNetworkString("Trolleybus_System.BassSounds")
	
--[[------------------------------------
	Type: Bass sounds API Function
	Name: Trolleybus_System.PlayBassSound
	Desc: Plays sound file for all players on give entity using Bass sound system.
	Arg1: Entity | self | Entity to play sound from.
	Arg2: string | snd | Path to sound file (relative garrysmod/sound).
	Arg3: (optional) number | dist | Custom maximum distance to hear sound.
	Arg4: (optional) number | volume | Custom maximum sound volume.
	Arg5: (optional) bool | loop | Marks sound as looping.
	Arg6: (optional) number | time | CurTime() based time to be used as point of start of playing.
	Arg7: (optional) Vector | lpos | Local position of sound relative to entity.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.PlayBassSound(self,snd,dist,volume,loop,time,lpos)
	net.Start("Trolleybus_System.BassSounds")
		net.WriteUInt(0,3)
		net.WriteUInt(self:EntIndex(),16)
		net.WriteString(snd)
		net.WriteBool(tobool(dist))
		if dist then net.WriteFloat(dist) end
		net.WriteBool(tobool(volume))
		if volume then net.WriteFloat(volume) end
		net.WriteBool(tobool(loop))
		net.WriteBool(tobool(time))
		if time then net.WriteFloat(time) end
		net.WriteBool(tobool(lpos))
		if lpos then net.WriteVector(lpos) end
	net.Broadcast()
	
	Trolleybus_System.BassSounds[self] = Trolleybus_System.BassSounds[self] or {}
	Trolleybus_System.BassSounds[self][snd] = {
		dist = dist,
		volume = volume,
		loop = loop,
		time = time,
		lpos = lpos,
	}
end

--[[------------------------------------
	Type: Bass sounds API Function
	Name: Trolleybus_System.PlayBassSoundSimple
	Desc: Plays simple unnecessary sound file for all players on give entity using Bass sound system.
	Arg1: Entity | self | Entity to play sound from.
	Arg2: string | snd | Path to sound file (relative garrysmod/sound).
	Arg3: (optional) number | dist | Custom maximum distance to hear sound.
	Arg4: (optional) number | volume | Custom maximum sound volume.
	Arg5: (optional) number | time | CurTime() based time to be used as point of start of playing.
	Arg6: (optional) Vector | lpos | Local position of sound relative to entity.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.PlayBassSoundSimple(self,snd,dist,volume,time,lpos)
	net.Start("Trolleybus_System.BassSounds",true)
		net.WriteUInt(1,3)
		net.WriteUInt(self:EntIndex(),16)
		net.WriteString(snd)
		net.WriteBool(tobool(dist))
		if dist then net.WriteFloat(dist) end
		net.WriteBool(tobool(volume))
		if volume then net.WriteFloat(volume) end
		net.WriteBool(tobool(time))
		if time then net.WriteFloat(time) end
		net.WriteBool(tobool(lpos))
		if lpos then net.WriteVector(lpos) end
	net.SendPAS(lpos and self:LocalToWorld(lpos) or self:GetPos())
end

--[[------------------------------------
	Type: Bass sounds API Function
	Name: Trolleybus_System.StopBassSound
	Desc: Stops playing sound file from give entity using Bass sound system.
	Arg1: Entity | self | Entity to stop sound from.
	Arg2: string | snd | Path to sound file (relative garrysmod/sound).
	Ret1: 
--]]------------------------------------
function Trolleybus_System.StopBassSound(self,snd)
	if Trolleybus_System.BassSounds[self] and Trolleybus_System.BassSounds[self][snd] then
		Trolleybus_System.BassSounds[self][snd] = nil
		
		net.Start("Trolleybus_System.BassSounds")
			net.WriteUInt(2,3)
			net.WriteUInt(self:EntIndex(),16)
			net.WriteString(snd)
		net.Broadcast()
	end
end

--[[------------------------------------
	Type: Bass sounds API Function
	Name: Trolleybus_System.StopAllBassSounds
	Desc: Stops all playing sound files from give entity using Bass sound system.
	Arg1: Entity | self | Entity to stop sounds from.
	Ret1: 
--]]------------------------------------
function Trolleybus_System.StopAllBassSounds(self)
	if Trolleybus_System.BassSounds[self] then
		Trolleybus_System.BassSounds[self] = nil
		
		net.Start("Trolleybus_System.BassSounds")
			net.WriteUInt(3,3)
			net.WriteUInt(k:EntIndex(),16)
		net.Broadcast()
	end
end

--[[------------------------------------
	Type: Bass sounds API Hook
	Name: PlayerInitialSpawn::Trolleybus_System.BassSounds
	Desc: Sends all currently active bass sounds to connected player.
--]]------------------------------------
hook.Add("PlayerInitialSpawn","Trolleybus_System.BassSounds",function(ply)
	if table.IsEmpty(Trolleybus_System.BassSounds) then return end

	net.Start("Trolleybus_System.BassSounds")
		net.WriteUInt(4,3)
		
		for k,v in pairs(Trolleybus_System.BassSounds) do
			net.WriteBool(true)
			net.WriteUInt(k:EntIndex(),16)
			
			for k2,v2 in pairs(v) do
				net.WriteBool(true)
				net.WriteString(k2)
				net.WriteBool(tobool(v2.dist))
				if v2.dist then net.WriteFloat(v2.dist) end
				net.WriteBool(tobool(v2.volume))
				if v2.volume then net.WriteFloat(v2.volume) end
				net.WriteBool(tobool(v2.loop))
				net.WriteBool(tobool(v2.time))
				if v2.time then net.WriteFloat(v2.time) end
				net.WriteBool(tobool(v2.lpos))
				if v2.lpos then net.WriteVector(v2.lpos) end
			end
			
			net.WriteBool(false)
		end
		
		net.WriteBool(false)
	net.Send(ply)
end)
