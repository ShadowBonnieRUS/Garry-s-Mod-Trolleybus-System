-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.BassSounds = Trolleybus_System.BassSounds or {}
Trolleybus_System.BassSoundsSimple = Trolleybus_System.BassSoundsSimple or {}
Trolleybus_System.BassSoundsWait = Trolleybus_System.BassSoundsWait or {}

local function SetupSound(self,snd,data)
	local sound = data.sound
	
	if !Trolleybus_System.IsBassSoundPlaying(self,snd) then
		if sound:GetState()!=GMOD_CHANNEL_PAUSED then
			sound:Pause()
		end
		
		return
	end
	
	if sound:GetState()!=GMOD_CHANNEL_PLAYING then
		sound:Play()
	end
	
	local pos = data.lpos and self:LocalToWorld(data.lpos) or self:GetPos()
	local eyepos = Trolleybus_System.EyePos()
	
	local dstvlm = 1-math.Clamp(pos:Distance(eyepos)/data.dist,0,1)
	local volume = dstvlm^1.5*data.volume
	local prate = data.prate
	
	if prate<0.0001 then
		volume = 0
		prate = 0.0001
	end
	
	sound:SetPos(pos)
	sound:SetVolume(volume)
	sound:EnableLooping(data.loop)
	sound:Set3DFadeDistance(32000,32000)
	sound:SetPlaybackRate(prate)
	
	/*if data.loop then	-- todo: playbackrate support
		local time = (CurTime()-data.time)%sound:GetLength()
	
		if math.abs(sound:GetTime()-time)>0.5 then
			sound:SetTime(time)
		end
	end*/
end

local function SetupSimpleSound(self,data)
	local sound = data.sound
	
	if self:IsDormant() or sound:GetTime()>=sound:GetLength() then
		sound:Stop()
		data.sound = nil
		
		return
	end
	
	local pos = data.lpos and self:LocalToWorld(data.lpos) or self:GetPos()
	local eyepos = Trolleybus_System.EyePos()
	local volume = (1-math.Clamp(pos:Distance(eyepos)/data.dist,0,1))*data.volume
	
	sound:SetPos(pos)
	sound:SetVolume(volume)
	sound:EnableLooping(false)
	sound:Set3DFadeDistance(32000,32000)
end

function Trolleybus_System.IsBassSoundPlaying(self,snd)
	if FrameTime()==0 then return end
	
	local dt = Trolleybus_System.BassSounds[self] and Trolleybus_System.BassSounds[self][snd]
	if !dt or !dt.shouldplay then return false end
	
	if self:IsDormant() then return false end
	if !IsValid(dt.sound) then return false end
	
	local len = dt.sound:GetLength()/dt.sound:GetPlaybackRate()
	local time = CurTime()-dt.time
	if !dt.loop and time>=len then return false end
	
	return true
end

function Trolleybus_System.PlayBassSound(self,snd,dist,volume,loop,time,lpos,prate)
	Trolleybus_System.StopBassSound(self,snd)

	Trolleybus_System.BassSounds[self] = Trolleybus_System.BassSounds[self] or {}
	Trolleybus_System.BassSounds[self][snd] = Trolleybus_System.BassSounds[self][snd] or {}
	
	local dt = Trolleybus_System.BassSounds[self][snd]
	
	dt.dist = dist or 1000
	dt.volume = volume or 1
	dt.loop = loop or false
	dt.time = time or CurTime()
	dt.lpos = lpos
	dt.prate = prate or 1
	dt.shouldplay = true
	
	if !IsValid(dt.sound) then
		if dt.sound==false then return dt end
		dt.sound = false
		
		local function PrepareSound(attempt)
			sound.PlayFile("sound/"..snd,"3d noplay noblock",function(sound,errid,err)
				if !IsValid(self) or !Trolleybus_System.BassSounds[self] then return end
				-- IsValid(self) is shit on first client tick, should use self==NULL
				
				local dt = Trolleybus_System.BassSounds[self][snd]
				if !dt then return end
				
				if !sound then
					MsgC(Color(255,100,100),"Trolleybus System:\n Cannot play BASS sound -> ",snd,"\n Error ID: ",errid,", Error: ",err,"\n")
					
					if errid==41 and attempt<=5 then
						MsgC(Color(200,200,50)," Trying play again (attempt "..attempt..")...\n")
						
						PrepareSound(attempt+1)
					end
					
					return
				end
				
				dt.sound = sound
				SetupSound(self,snd,dt)
			end)
		end
		
		PrepareSound(1)
	else
		SetupSound(self,snd,dt)
	end
	
	return dt
end

function Trolleybus_System.PlayBassSoundSimple(self,snd,dist,volume,time,lpos,prate)
	Trolleybus_System.PlayBassSound(self,snd,dist,volume,false,time,lpos,prate)

	/*Trolleybus_System.BassSoundsSimple[self] = Trolleybus_System.BassSoundsSimple[self] or {}
	
	local t = {
		sound = false,
		snd = snd,
		dist = dist or 1000,
		volume = volume or 1,
		time = time or CurTime(),
		lpos = lpos,
	}
	
	table.insert(Trolleybus_System.BassSoundsSimple[self],t)
	
	sound.PlayFile("sound/"..snd,"3d",function(sound,errid,err)
		if !IsValid(self) or !Trolleybus_System.BassSoundsSimple[self] then return end
		
		if !sound then
			MsgC(Color(255,100,100),"Trolleybus System:\n Cannot play BASS sound -> ",snd,"\n Error ID: ",errid,", Error: ",err,"\n")
			
			--[[if errid==41 then
				MsgC(Color(200,200,50)," Trying play again...\n")
				
				Trolleybus_System.PlayBassSoundSimple(self,snd,dt.dist,dt.volume,dt.loop,dt.time,dt.lpos)
			end]]
			
			return
		end
		
		t.sound = sound
		
		SetupSimpleSound(self,t)
	end)*/
end

function Trolleybus_System.StopBassSound(self,snd,fullremove)
	local dt = Trolleybus_System.BassSounds[self] and Trolleybus_System.BassSounds[self][snd]
	
	if dt then
		if !fullremove then
			if dt.shouldplay and IsValid(dt.sound) then dt.sound:Pause() dt.sound:SetTime(0) end
			dt.shouldplay = false
		else
			if IsValid(dt.sound) then dt.sound:Stop() end
			Trolleybus_System.BassSounds[self][snd] = nil
		end
	end
end

function Trolleybus_System.StopAllBassSounds(self)
	local dt = Trolleybus_System.BassSounds[self]
	
	if dt then
		Trolleybus_System.BassSounds[self] = nil
	
		for k,v in pairs(dt) do
			if IsValid(v.sound) then v.sound:Stop() end
		end
	end
end

function Trolleybus_System.GetBassSoundData(self,snd)
	return Trolleybus_System.BassSounds[self] and Trolleybus_System.BassSounds[self][snd]
end

hook.Add("PreRender","Trolleybus_System.BassSounds",function()
	for k,v in pairs(Trolleybus_System.BassSounds) do
		if !IsValid(k) then continue end
		
		for k2,v2 in pairs(v) do
			if !IsValid(v2.sound) then continue end
			
			SetupSound(k,k2,v2)
		end
	end
	
	for k,v in pairs(Trolleybus_System.BassSoundsSimple) do
		if !IsValid(k) then continue end
		
		local k2 = 1
		while true do
			local v2 = v[k2]
			if !v2 then break end
			
			if v2.sound==nil then
				table.remove(v,k2)
				continue
			end
			
			if IsValid(v2.sound) then
				SetupSimpleSound(k,v2)
			end
			
			k2 = k2+1
		end
	end
end)

hook.Add("EntityRemoved","Trolleybus_System.BassSounds",function(ent)
	local dt = Trolleybus_System.BassSounds[ent]
	if dt then
		Trolleybus_System.BassSounds[ent] = nil
	
		for k,v in pairs(dt) do
			if IsValid(v.sound) then v.sound:Stop() end
		end
		
		ent.Trolleybus_System_BassSounds = dt	--If removed by full updating, we can restore sounds
	end
	
	local dt = Trolleybus_System.BassSoundsSimple[ent]
	if dt then
		Trolleybus_System.BassSoundsSimple[ent] = nil
	
		for k,v in pairs(dt) do
			if IsValid(v.sound) then v.sound:Stop() end
		end
	end
end)

hook.Add("NetworkEntityCreated","Trolleybus_System.BassSounds",function(ent)
	local dt = ent.Trolleybus_System_BassSounds
	if dt then
		ent.Trolleybus_System_BassSounds = nil
		
		for k,v in pairs(dt) do
			Trolleybus_System.PlayBassSound(ent,k,v.dist,v.volume,v.loop,v.time,v.lpos).shouldplay = v.shouldplay
		end
	end

	local dt = Trolleybus_System.BassSoundsWait[ent]
	if dt then
		Trolleybus_System.BassSoundsWait[ent] = nil
		
		for k,v in pairs(dt) do
			Trolleybus_System.PlayBassSound(ent,k,v.dist,v.volume,v.loop,v.time,v.lpos)
		end
	end
end)

net.Receive("Trolleybus_System.BassSounds",function(len)
	local cmd = net.ReadUInt(3)
	
	if cmd==0 then	--Trolleybus_System.PlayBassSound
		local index = net.ReadUInt(16)
		local snd = net.ReadString()
		local dist
		if net.ReadBool() then dist = net.ReadFloat() end
		local volume
		if net.ReadBool() then volume = net.ReadFloat() end
		local loop = net.ReadBool()
		local time
		if net.ReadBool() then time = net.ReadFloat() end
		local lpos
		if net.ReadBool() then lpos = net.ReadVector() end
		
		local ent = Entity(index)
		
		if IsValid(ent) then
			Trolleybus_System.PlayBassSound(ent,snd,dist,volume,loop,time,lpos)
		else
			Trolleybus_System.BassSoundsWait[index] = Trolleybus_System.BassSoundsWait[index] or {}
			Trolleybus_System.BassSoundsWait[index][snd] = {
				dist = dist,
				volume = volume,
				loop = loop,
				time = time,
				lpos = lpos,
			}
		end
	elseif cmd==1 then	--Trolleybus_System.PlayBassSoundSimple
		local index = net.ReadUInt(16)
		local snd = net.ReadString()
		local dist
		if net.ReadBool() then dist = net.ReadFloat() end
		local volume
		if net.ReadBool() then volume = net.ReadFloat() end
		local time
		if net.ReadBool() then time = net.ReadFloat() end
		local lpos
		if net.ReadBool() then lpos = net.ReadVector() end
		
		local ent = Entity(index)
		
		if IsValid(ent) and !ent:IsDormant() then
			Trolleybus_System.PlayBassSoundSimple(ent,snd,dist,volume,time,lpos)
		end
	elseif cmd==2 then	--Trolleybus_System.StopBassSound
		local index = net.ReadUInt(16)
		local snd = net.ReadString()
		
		local ent = Entity(index)
		
		if IsValid(ent) then
			Trolleybus_System.StopBassSound(ent,snd)
		else
			if Trolleybus_System.BassSoundsWait[index] then
				Trolleybus_System.BassSoundsWait[index][snd] = nil
			end
		end
	elseif cmd==3 then	--Trolleybus_System.StopAllBassSounds
		local index = net.ReadUInt(16)
		
		local ent = Entity(index)
		
		if IsValid(ent) then
			Trolleybus_System.StopAllBassSounds(ent)
		else
			Trolleybus_System.BassSoundsWait[index] = nil
		end
	elseif cmd==4 then	--PlayerInitialSpawn
		while net.ReadBool() do
			local index = net.ReadUInt(16)
			
			local ent = Entity(index)
			local valid = IsValid(ent)
			
			while net.ReadBool() do
				local snd = net.ReadString()
				local dist
				if net.ReadBool() then dist = net.ReadFloat() end
				local volume
				if net.ReadBool() then volume = net.ReadFloat() end
				local loop = net.ReadBool()
				local time
				if net.ReadBool() then time = net.ReadFloat() end
				local lpos
				if net.ReadBool() then lpos = net.ReadVector() end
				
				if valid then
					Trolleybus_System.PlayBassSound(ent,snd,dist,volume,loop,time,lpos)
				else
					Trolleybus_System.BassSoundsWait[index] = Trolleybus_System.BassSoundsWait[index] or {}
					Trolleybus_System.BassSoundsWait[index][snd] = {
						dist = dist,
						volume = volume,
						loop = loop,
						time = time,
						lpos = lpos,
					}
				end
			end
		end
	end
end)