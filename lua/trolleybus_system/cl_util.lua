-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.PassengerSize = 25

local eyepos,eyeang,eyedir,eyefov = EyePos(),EyeAngles(),EyeVector(),75

hook.Add("RenderScene","Trolleybus_System",function(pos,ang,fov)
	eyepos,eyeang,eyedir,eyefov = pos,ang,ang:Forward(),fov
	
	Trolleybus_System.RunEvent("EyeDataUpdate",eyepos,eyeang,eyedir,eyefov)
end)

function Trolleybus_System.EyePos()
	return Vector(eyepos)
end

function Trolleybus_System.EyeAngles()
	return Angle(eyeang)
end

function Trolleybus_System.EyeVector()
	return Vector(eyedir)
end

function Trolleybus_System.EyeFOV()
	return eyefov
end

function Trolleybus_System.CreatePassenger()
	local ent = ClientsideModel(table.Random(Trolleybus_System.PassModels),RENDERGROUP_BOTH)
	ent:SetSequence(ent:LookupSequence(table.Random(Trolleybus_System.PassStaySequences)) or 0)
	ent.RenderOverride = function(self)
		if EyePos():DistToSqr(self:GetPos())<Trolleybus_System.GetPlayerSetting("PassengersDrawDistance")^2 then
			self:DrawModel()
		end
	end
	
	local col = VectorRand(0,1)
	ent.GetPlayerColor = function(self) return col end
	
	return ent
end

local PIXVIS_UHANDLE = {
	Initialize = function(self)
		self.handle = util.GetPixelVisibleHandle()
		self.target = 1
		self.lastvisible = 0
		self.uselastvisible = 0
		
		self.handles = {}
		self.lasthandle = nil
	end,
	GetHandle = function(self,mirror)
		if mirror then
			if !self.handles[mirror] then
				self.handles[mirror] = util.GetPixelVisibleHandle()
			end
			
			return self.handles[mirror]
		end
		
		return self.handle
	end,
	PixelVisible = function(self,pos,size)
		local mirror = Trolleybus_System._RenderedMirror
		local handle = self:GetHandle(mirror)
		
		local visible = util.PixelVisible(pos,size,handle)
		//local vis = visible
		
		if handle!=self.lasthandle then
			self.lasthandle = handle
		end
		
		if self.handle==handle then
			if self.uselastvisible>0 then
				if visible>0 then
					self.uselastvisible = 0
					self.target = visible
				else
					self.uselastvisible = self.uselastvisible-1
					visible = self.lastvisible
				end
			else
				visible = math.min(visible/self.target,1)
			end
		
			self.lastvisible = visible
			
			if self.target<1 and self.uselastvisible<=0 then
				self.target = math.min(1,self.target+FrameTime()/0.125*2)
			end
		end
		
		return visible
	end,
	PostRenderView = function(self)
		self.target = 0
		self.uselastvisible = 2
	end,
}

Trolleybus_System.PixVisUHandles = Trolleybus_System.PixVisUHandles or setmetatable({},{__mode = "k"})

for k,v in pairs(Trolleybus_System.PixVisUHandles) do
	setmetatable(k,{__index = PIXVIS_UHANDLE})
end

function Trolleybus_System.CreatePixVisUHandle()
	local uhandle = setmetatable({},{__index = PIXVIS_UHANDLE})
	uhandle:Initialize()
	
	Trolleybus_System.PixVisUHandles[uhandle] = true
	
	return uhandle
end

function Trolleybus_System.PixVisUHandle_PostRenderView()
	for k,v in pairs(Trolleybus_System.PixVisUHandles) do
		k:PostRenderView()
	end
end

local WORK_SOUND = {
	Init = function(self,ent,lpos,dist,volume,prate,startsnds,loopsnd,endsnds)
		self.StartSnds = {}
		self.EndSnds = {}
		
		self.StartLens = 0
		self.EndLens = 0
		
		self.m_Ent = ent
		self.m_StartLen = 0
		self.m_EndLen = 0
		self.m_CurTime = math.huge
		self.m_PlaybackRate = prate
		self.m_Volume = volume
		self.m_Active = false
		self.m_Removed = false
		self.m_CurSound = nil
		self.m_ShouldPlay = true
		
		for k,v in ipairs(!istable(startsnds) and {startsnds} or startsnds) do
			self.StartSnds[k] = {
				sound = v,
				data = Trolleybus_System.PlayBassSound(ent,v,dist,volume,false,nil,lpos,prate),
			}
			
			self.StartSnds[k].data.shouldplay = false
		end
		
		self.LoopSnd = {
			sound = loopsnd,
			data = Trolleybus_System.PlayBassSound(ent,loopsnd,dist,volume,true,nil,lpos,prate),
		}
		self.LoopSnd.data.shouldplay = false
		
		for k,v in ipairs(!istable(endsnds) and {endsnds} or endsnds) do
			self.EndSnds[k] = {
				sound = v,
				data = Trolleybus_System.PlayBassSound(ent,v,dist,volume,false,nil,lpos,prate),
			}
			
			self.EndSnds[k].data.shouldplay = false
		end
		
		hook.Add("Think",self,self.Think)
	end,
	SetPlaybackRate = function(self,prate)
		self.m_PlaybackRate = prate
	end,
	GetPlaybackRate = function(self)
		return self.m_PlaybackRate
	end,
	IsValid = function(self)
		if self.m_Removed then return false end
		
		if !IsValid(self.m_Ent) then
			self:Remove()
			
			return false
		end
		
		return true
	end,
	Think = function(self)
		if self.StartLens<#self.StartSnds then
			for k,v in ipairs(self.StartSnds) do
				if v.len then continue end
				
				local snd = v.data.sound
				if snd then
					local len = math.max(0,snd:GetLength()-0.05)
				
					v.len = len
					self.m_StartLen = self.m_StartLen+len
					
					self.StartLens = self.StartLens+1
				end
			end
		end
		
		if self.EndLens<#self.EndSnds then
			for k,v in ipairs(self.EndSnds) do
				if v.len then continue end
				
				local snd = v.data.sound
				if snd then
					local len = math.max(0,snd:GetLength()-0.05)
					
					v.len = len
					self.m_EndLen = self.m_EndLen+len
					
					self.EndLens = self.EndLens+1
				end
			end
		end
		
		if !self.LoopSnd.len then
			local snd = self.LoopSnd.data.sound
			
			if snd then
				self.LoopSnd.len = math.max(0,snd:GetLength()-0.05)
			end
		end
		
		self.m_CurTime = self.m_CurTime+RealFrameTime()*self.m_PlaybackRate
		
		if self.m_ShouldPlay and !self.m_Ent:IsDormant() then
			local snd,ct = self:SelectCurrentSoundByCurTime()
			local csnd = self.m_CurSound
			
			if csnd!=snd then
				self.m_CurSound = snd
				
				if csnd then
					csnd.data.shouldplay = false
				end
				
				if snd then
					snd.data.shouldplay = true
					snd.data.time = CurTime()+ct%(snd.len or 0)
					
					if snd.data.sound then
						snd.data.sound:SetTime(ct%snd.len)
					end
				end
			end
			
			if snd then
				snd.data.prate = self.m_PlaybackRate
				snd.data.volume = self.m_Volume
			end
		else
			if self.m_CurSound then
				self.m_CurSound.data.shouldplay = false
				self.m_CurSound = nil
			end
		end
	end,
	SelectCurrentSoundByCurTime = function(self)
		local ct = self.m_CurTime
		
		if self.m_Active then
			if ct>self.m_StartLen then
				return self.LoopSnd,ct-self.m_StartLen
			end
			
			local len = 0
			
			for k,v in ipairs(self.StartSnds) do
				if !v.len then continue end

				if ct>=len and ct<len+v.len then
					return v,ct-len
				end
				
				len = len+v.len
			end
		else
			if ct<self.m_EndLen then
				local len = 0
				
				for k,v in ipairs(self.EndSnds) do
					if !v.len then continue end

					if ct>=len and ct<len+v.len then
						return v,ct-len
					end
					
					len = len+v.len
				end
			end
		end
	end,
	SetActive = function(self,active)
		active = active and true or false
		
		if self.m_Active!=active then
			self.m_Active = active
			
			self:SetupCurTimeOnActiveChange()
		end
	end,
	SetupCurTimeOnActiveChange = function(self)
		local ct = self.m_CurTime
		
		if self.m_Active then
			self.m_CurTime = self.m_StartLen*(ct>=self.m_EndLen and 0 or 1-ct/self.m_EndLen)
		else
			self.m_CurTime = self.m_EndLen*(ct>=self.m_StartLen and 0 or 1-ct/self.m_StartLen)
		end
	end,
	IsActive = function(self)
		return self.m_Active
	end,
	Remove = function(self)
		self.m_Removed = true
		
		if IsValid(self.m_Ent) then
			for k,v in ipairs(self.StartSnds) do
				Trolleybus_System.StopBassSound(self.m_Ent,v.sound)
			end
			
			Trolleybus_System.StopBassSound(self.m_Ent,self.LoopSnd.sound)
			
			for k,v in ipairs(self.EndSnds) do
				Trolleybus_System.StopBassSound(self.m_Ent,v.sound)
			end
		end
		
		if self.m_CurSound then
			self.m_CurSound.data.shouldplay = false
			self.m_CurSound = nil
		end
	end,
	IsPlaying = function(self)
		return self.m_ShouldPlay
	end,
	Play = function(self)
		self.m_ShouldPlay = true
		self.m_CurTime = 0
	end,
	Stop = function(self)
		self.m_ShouldPlay = false
		self:SetActive(false)
	end,
	SetVolume = function(self,volume)
		self.m_Volume = volume
	end,
	GetVolume = function(self)
		return self.m_Volume
	end,
}

function Trolleybus_System.CreateWorkSound(...)
	local obj = setmetatable({},{__index = WORK_SOUND})
	obj:Init(...)
	
	return obj
end

local INSIDE_OUTSIDE_SOUND = {
	Init = function(self,ent,lpos,dist,volume1,volume2,prate,startsnds1,loopsnd1,endsnds1,startsnds2,loopsnd2,endsnds2,swaptime)
		self.m_Ent = ent
		self.m_Removed = false
		
		self.m_WorkSnd1 = Trolleybus_System.CreateWorkSound(ent,lpos,dist,volume1,prate,startsnds1,loopsnd1,endsnds1)
		self.m_Snd1Volume = volume1
		
		self.m_WorkSnd2 = Trolleybus_System.CreateWorkSound(ent,lpos,dist,volume2,prate,startsnds2,loopsnd2,endsnds2)
		self.m_Snd2Volume = volume2
		
		self.m_SwapProgress = self:IsInside() and 1 or 0
		self.m_SwapTime = swaptime or 1
		
		hook.Add("Think",self,self.Think)
	end,
	Think = function(self)
		local inside = self:IsInside()
		
		if inside then
			self.m_SwapProgress = math.min(1,self.m_SwapProgress+FrameTime()/self.m_SwapTime)
		else
			self.m_SwapProgress = math.max(0,self.m_SwapProgress-FrameTime()/self.m_SwapTime)
		end
		
		if self.m_Ent:IsDormant() then return end
		
		self:SetupSwap()
	end,
	SetPlaybackRate = function(self,prate)
		self.m_WorkSnd1:SetPlaybackRate(prate)
		self.m_WorkSnd2:SetPlaybackRate(prate)
	end,
	GetPlaybackRate = function(self)
		return self.m_WorkSnd1:GetPlaybackRate()
	end,
	SetVolume1 = function(self,volume)
		self.m_Snd1Volume = volume
	end,
	GetVolume1 = function(self,volume)
		return self.m_Snd1Volume
	end,
	SetVolume2 = function(self,volume)
		self.m_Snd2Volume = volume
	end,
	GetVolume2 = function(self,volume)
		return self.m_Snd2Volume
	end,
	IsInside = function(self)
		local pos = Trolleybus_System.EyePos()
		local b1,b2 = self.m_Ent:GetModelBounds()
		
		if self.m_Ent:WorldToLocal(pos):WithinAABox(b1,b2) then return true end
		
		if self.m_Ent.IsTrolleybus then
			local other = self.m_Ent.IsTrailer and self.m_Ent:GetTrolleybus() or self.m_Ent:GetTrailer()
			
			if IsValid(other) then
				local b1,b2 = other:GetModelBounds()
				
				if other:WorldToLocal(pos):WithinAABox(b1,b2) then return true end
			end
		end
		
		return false
	end,
	SetupSwap = function(self)
		local fr = self.m_SwapProgress
		
		self.m_WorkSnd1:SetVolume((1-fr)*self.m_Snd1Volume)
		self.m_WorkSnd2:SetVolume(fr*self.m_Snd2Volume)
	end,
	IsValid = function(self)
		if self.m_Removed then return false end
		
		if !IsValid(self.m_Ent) or !self.m_WorkSnd1:IsValid() or !self.m_WorkSnd2:IsValid() then
			self:Remove()
			
			return false
		end
		
		return true
	end,
	Remove = function(self)
		self.m_Removed = true
		
		if self.m_WorkSnd1:IsValid() then self.m_WorkSnd1:Remove() end
		if self.m_WorkSnd2:IsValid() then self.m_WorkSnd2:Remove() end
	end,
	SetActive = function(self,active)
		self.m_WorkSnd1:SetActive(active)
		self.m_WorkSnd2:SetActive(active)
	end,
	IsActive = function(self)
		return self.m_WorkSnd1:IsActive()
	end,
}

function Trolleybus_System.CreateInsideOutsideSound(...)
	local obj = setmetatable({},{__index = INSIDE_OUTSIDE_SOUND})
	obj:Init(...)
	
	return obj
end

local MULTI_SOUND = {
	Init = function(self,ent,lpos,dist,volumemp,soundscfg,getspd)
		self.m_Ent = ent
		self.m_Removed = false
		self.m_Sounds = {}
		self.m_VolumeMultiplier = volumemp
		self.m_GetSpeed = getspd
		
		for k,v in ipairs(soundscfg) do
			local volume = v.volume or 1
			local prate = v.prate or 1
			local data = Trolleybus_System.PlayBassSound(ent,v.sound,dist,(isfunction(volume) and volume(self,self.m_Ent) or volume)*volumemp,true,nil,lpos,prate)
			data.shouldplay = false
			
			self.m_Sounds[k] = {
				sound = v.sound,
				data = data,
				volume = volume,
				prate = prate,
				startspd = v.startspd or 0,
				fadein = v.fadein or 0,
				endspd = v.endspd,
				fadeout = v.fadeout or 0,
				pratemp = v.pratemp or 0,
				pratestart = v.pratestart or 1,
			}
		end
		
		hook.Add("Think",self,self.Think)
	end,
	Think = function(self)
		if self.m_Ent:IsDormant() then return end
		
		local curspd = self:m_GetSpeed(self.m_Ent)
		
		for k,v in ipairs(self.m_Sounds) do
			v.data.shouldplay = curspd>=v.startspd and (!v.endspd or curspd<v.endspd)
			
			if v.data.shouldplay then
				local volumemp = (curspd-v.startspd>=v.fadein and 1 or (curspd-v.startspd)/v.fadein)*(!v.endspd and 1 or v.endspd-curspd>=v.fadeout and 1 or (v.endspd-curspd)/v.fadeout)
				local pratemp = v.pratestart+(curspd-v.startspd)*v.pratemp
				
				v.data.volume = (isfunction(v.volume) and v.volume(self,self.m_Ent) or v.volume)*volumemp*self.m_VolumeMultiplier
				v.data.prate = v.prate*pratemp
			end
		end
	end,
	SetVolume = function(self,volumemp)
		self.m_VolumeMultiplier = volumemp
	end,
	GetVolume = function(self)
		return self.m_VolumeMultiplier
	end,
	IsValid = function(self)
		if self.m_Removed then return false end
		
		if !IsValid(self.m_Ent) then
			self:Remove()
			
			return false
		end
		
		return true
	end,
	Remove = function(self)
		self.m_Removed = true
		
		for k,v in ipairs(self.m_Sounds) do
			v.data.shouldplay = false
		end
		
		if IsValid(self.m_Ent) then
			for k,v in ipairs(self.m_Sounds) do
				Trolleybus_System.StopBassSound(self.m_Ent,v.sound)
			end
		end
	end,
}

function Trolleybus_System.CreateMultiSound(...)
	local obj = setmetatable({},{__index = MULTI_SOUND})
	obj:Init(...)
	
	return obj
end

local TEXTURED_POLY = {
	Init = function(self,verts,mat)
		self.m_Material = mat
		self.m_VertsCount = #verts-2
		self.m_Verts = verts
		self.m_UV = {0,0,1,1}
		
		self.m_Pos = Vector()
		self.m_Ang = Angle()
		self.m_Color = color_white
		
		local umin,vmin,umax,vmax = 0,0,0,0
		
		for i=1,#verts do
			if verts[i].x<umin then umin = verts[i].x end
			if verts[i].x>umax then umax = verts[i].x end
			
			if verts[i].y<vmin then vmin = verts[i].y end
			if verts[i].y>vmax then vmax = verts[i].y end
		end
		
		self.m_UVSize = {umin,vmin,umax-umin,vmax-vmin}
	end,
	SetPos = function(self,pos)
		self.m_Pos = Vector(pos)
	end,
	GetPos = function(self)
		return Vector(self.m_Pos)
	end,
	SetAngles = function(self,ang)
		self.m_Ang = Angle(ang)
	end,
	GetAngles = function(self)
		return Angle(self.m_Ang)
	end,
	SetColor = function(self,color)
		self.m_Color = Color(color.r,color.g,color.b,color.a)
	end,
	GetColor = function(self)
		return Color(self.m_Color.r,self.m_Color.g,self.m_Color.b,self.m_Color.a)
	end,
	SetUV = function(self,su,sv,u,v)
		self.m_UV[1] = su
		self.m_UV[2] = sv
		self.m_UV[3] = u
		self.m_UV[4] = v
	end,
	GetUV = function(self)
		return self.m_UV[1],self.m_UV[2],self.m_UV[3],self.m_UV[4]
	end,
	SetMaterial = function(self,mat)
		self.m_Material = mat
	end,
	GetMaterial = function(self)
		return self.m_Material
	end,
	Draw = function(self,is3d)
		render.SetMaterial(self.m_Material)
		
		local axis_x,axis_y = is3d and -self.m_Ang:Right() or self.m_Ang:Forward(),is3d and self.m_Ang:Up() or self.m_Ang:Right()
		local pos = self.m_Pos
		local verts = self.m_Verts
		local uv,uvs = self.m_UV,self.m_UVSize
		local color = self.m_Color
		
		mesh.Begin(MATERIAL_TRIANGLES,self.m_VertsCount)
			
			for i=3,#verts do
				local v1,v2,v3 = verts[1],verts[i-1],verts[i]
				
				mesh.Color(color.r,color.g,color.b,color.a)
				mesh.Position(pos+axis_x*v1.x-axis_y*v1.y)
				mesh.TexCoord(0,uv[1]+(v1.x-uvs[1])/uvs[3]*uv[3],uv[2]+(v1.y-uvs[2])/uvs[4]*uv[4])
				mesh.AdvanceVertex()
				
				mesh.Color(color.r,color.g,color.b,color.a)
				mesh.Position(pos+axis_x*v2.x-axis_y*v2.y)
				mesh.TexCoord(0,uv[1]+(v2.x-uvs[1])/uvs[3]*uv[3],uv[2]+(v2.y-uvs[2])/uvs[4]*uv[4])
				mesh.AdvanceVertex()
				
				mesh.Color(color.r,color.g,color.b,color.a)
				mesh.Position(pos+axis_x*v3.x-axis_y*v3.y)
				mesh.TexCoord(0,uv[1]+(v3.x-uvs[1])/uvs[3]*uv[3],uv[2]+(v3.y-uvs[2])/uvs[4]*uv[4])
				mesh.AdvanceVertex()
			end
			
		mesh.End()
	end,
}

function Trolleybus_System.CreateTexturedPoly(...)
	local obj = setmetatable({},{__index = TEXTURED_POLY})
	obj:Init(...)
	
	return obj
end

Trolleybus_System.MassiveDataReceiving = Trolleybus_System.MassiveDataReceiving or nil
Trolleybus_System.MassiveDataReceivers = Trolleybus_System.MassiveDataReceivers or {}

function Trolleybus_System.ReceiveMassiveData(callback,func)
	Trolleybus_System.MassiveDataReceivers[callback] = func
end

net.Receive("Trolleybus_System.MassiveDataTransfer",function(len)
	local receiving = Trolleybus_System.MassiveDataReceiving
	if !receiving then
		receiving = coroutine.create(function()
			local stack,tstack = {},{}
			local size = #stack

			while true do
				while net.ReadBool() do
					if net.ReadBool() then
						size = size+1
						stack[size] = {}

						tstack[#tstack+1] = false
					else
						local data = net.ReadType()

						size = size+1
						stack[size] = data

						local t = tstack[#tstack]
						if t!=nil then
							if !t then
								if data==nil then
									tstack[#tstack] = nil
									size = size-1

									if tstack[#tstack] then
										local value = stack[size]
										stack[size] = nil
										size = size-1

										local key = stack[size]
										stack[size] = nil
										size = size-1

										local tab = stack[size]
										tab[key] = value

										tstack[#tstack] = false
									end
								else
									tstack[#tstack] = true
								end
							else
								local value = stack[size]
								stack[size] = nil
								size = size-1

								local key = stack[size]
								stack[size] = nil
								size = size-1

								local tab = stack[size]
								tab[key] = value

								tstack[#tstack] = false
							end
						end
					end
				end

				if coroutine.yield() then break end
			end

			return stack[1]
		end)

		Trolleybus_System.MassiveDataReceiving = receiving
	end

	coroutine.resume(receiving)

	if net.ReadBool() then
		local callback = net.ReadString()

		local succ,data = coroutine.resume(receiving,true)
		Trolleybus_System.MassiveDataReceiving = nil
		if !succ then error(data) end

		local callback = Trolleybus_System.MassiveDataReceivers[callback]
		if callback then
			ProtectedCall(function() callback(data) end)
		end
	end

	net.Start("Trolleybus_System.MassiveDataTransfer")
	net.SendToServer()
end)

net.Receive("Trolleybus_System.PlayerMessage",function(len)
	local type = net.ReadUInt(4)
	local format = net.ReadString()
	local args = {}

	while net.ReadBool() do
		local arg = net.ReadType()

		if isstring(arg) and arg[1]=="#" then
			arg = Trolleybus_System.GetLanguagePhrase(arg:sub(2,-1))
		end

		args[#args+1] = arg
	end

	notification.AddLegacy("Trolleybus System: "..Format(format,unpack(args)),type,5)
end)

Trolleybus_System.EntsDrawStateSaves = Trolleybus_System.EntsDrawStateSaves or {o = {},t = {}}

function Trolleybus_System.MarkEntityAsDrawnThisFrame(ent,translucent)
	if translucent then
		Trolleybus_System.EntsDrawStateSaves.t[ent] = FrameNumber()
	else
		Trolleybus_System.EntsDrawStateSaves.o[ent] = FrameNumber()
	end
end

function Trolleybus_System.IsEntityWasDrawnThisFrame(ent,translucent)
	if translucent then
		return Trolleybus_System.EntsDrawStateSaves.t[ent]==FrameNumber()
	else
		return Trolleybus_System.EntsDrawStateSaves.o[ent]==FrameNumber()
	end
end

hook.Add("EntityRemoved","Trolleybus_System.EntsDrawStateSaves",function(ent)
	Trolleybus_System.EntsDrawStateSaves.t[ent] = nil
	Trolleybus_System.EntsDrawStateSaves.o[ent] = nil
end)

function Trolleybus_System.IsButtonsDown(btns,any)
	if istable(btns) then
		for i=1,#btns do
			if !input.IsButtonDown(btns[i]) then
				if !any then return false end
			else
				if any then return true end
			end
		end

		return !any
	end

	return input.IsButtonDown(btns)
end

function Trolleybus_System.ButtonsToString(btns)
	if istable(btns) then
		local names = {}

		for i=1,#btns do
			local name = input.GetKeyName(btns[i])
			names[#names+1] = name and name:upper() or "?"
		end

		return table.concat(names,"+")
	end

	local name = input.GetKeyName(btns)
	return name and name:upper() or "?"
end