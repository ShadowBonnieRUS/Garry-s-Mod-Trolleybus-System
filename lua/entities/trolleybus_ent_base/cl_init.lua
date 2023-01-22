-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.RenderGroup = RENDERGROUP_BOTH

include("shared.lua")

local function CreatePassenger(self)
	for k,v in RandomPairs(self.PassPositionSeats) do
		if !IsValid(self.PassSeats[k]) then
			local pass = Trolleybus_System.CreatePassenger()
			pass:SetParent(self)
		
			self.PassSeats[k] = pass
			
			pass:SetLocalPos(v[1])
			pass:SetLocalAngles(v[2])
			pass:SetSequence(pass:LookupSequence("sit"))
		
			return pass
		end
	end
	
	for k,v in RandomPairs(self.PassPositions) do
		if !IsValid(v) then
			local pass = Trolleybus_System.CreatePassenger()
			pass:SetParent(self)
		
			self.PassPositions[k] = pass
			
			pass:SetLocalPos(k)
			pass:SetLocalAngles(Angle(0,math.Rand(-180,180),0))
			
			return pass
		end
	end
end

function ENT:ProcessCfgSound(cent,data,state)
	if isstring(data) then
		Trolleybus_System.PlayBassSound(cent,data)
	elseif istable(data) and data.On and data.Off then
		local t = data[state and "On" or "Off"]
		
		if istable(t) then
			Trolleybus_System.PlayBassSound(cent,unpack(t))
		elseif isfunction(t) then
			Trolleybus_System.PlayBassSound(cent,t(self))
		end
	elseif istable(data) then
		Trolleybus_System.PlayBassSound(cent,unpack(data))
	elseif isfunction(data) then
		Trolleybus_System.PlayBassSound(cent,data(self,state))
	end
end

function ENT:Initialize()
	self.SpawnTime = self:GetCreationTime()
	self.UpdateTime = CurTime()
	self.DeltaTime = 0
	self.SpawnSettingsReceive = 0
	self.BortNumber = 0
	
	self.CustomClientEnts = {}
	self.ClientEntsDistanceControl = {}
	
	self.m_PanelsData = {}
	for k,v in pairs(self.PanelsData or {}) do self.m_PanelsData[k] = v end
	
	self.m_ButtonsData = {}
	for k,v in pairs(self.ButtonsData or {}) do self.m_ButtonsData[k] = v end
	
	self.m_OtherPanelEntsData = {}
	for k,v in pairs(self.OtherPanelEntsData or {}) do self.m_OtherPanelEntsData[k] = v end
	
	self.pix_viss = {left = {},right = {},profile = {},roadtrain = {},head = {},brake = {},backmove = {}}
	self.HeadLamps = {}
	self.SkinsToUpdate = {}
	
	self.PassPositions = {}
	
	local bounds = self.PassPositionBounds
	if isvector(bounds[1]) then bounds = {bounds} end
	
	local passsize = Trolleybus_System.PassengerSize*0.75
	
	for k,v in ipairs(bounds) do
		local v1,v2 = Vector(v[1]),Vector(v[2])
		OrderVectors(v1,v2)
		
		local l,w = v2.x-v1.x,v2.y-v1.y
		if l<=0 or w<=0 then continue end
		
		local z = (v1.z+v2.z)/2
		
		local lcount = math.floor(l/passsize)
		local wcount = math.floor(w/passsize)
		local maxloffset = (l-lcount*passsize)/2/lcount
		local maxwoffset = (w-wcount*passsize)/2/wcount
		
		if lcount<=0 then lcount,maxloffset = 1,0 end
		if wcount<=0 then wcount,maxwoffset = 1,0 end
		
		for i=1,lcount do
			for j=1,wcount do
				local x = v1.x+l/(lcount+1)*i+math.Rand(-maxloffset,maxloffset)
				local y = v1.y+w/(wcount+1)*j+math.Rand(-maxwoffset,maxwoffset)
				
				self.PassPositions[Vector(x,y,z)] = false
			end
		end
	end
end

function ENT:ShouldRenderClientEnts(transmit)
	return transmit and self:GetPos():DistToSqr(Trolleybus_System.EyePos())<Trolleybus_System.GetPlayerSetting("TrolleybusDetailsDrawDistance")^2 and !Trolleybus_System.RunEvent("Trolleybus_PreventRenderClientEnts",self)
end

function ENT:CreateClientEnts()
	self:ClearClientEnts()
	
	if self.HasPoles then
		self.PolesData = {}
	
		for i=1,2 do
			local t = {}
		
			t.TrolleyPole = ClientsideModel(self.TrolleyPoleModel,RENDERGROUP_BOTH)
			t.TrolleyWheel = ClientsideModel(self.TrolleyPoleWheelModel,RENDERGROUP_BOTH)
			
			t.TrolleyPole:CreateShadow()
			t.TrolleyWheel:CreateShadow()
			
			t.TrolleyPole:SetParent(self)
			t.TrolleyPole:SetLocalPos(self:GetPolePos(i==2,true))
			
			t.TrolleyWheel:SetParent(self)
			
			self.PolesData[i==1 and "Left" or "Right"] = t
		end
	end
	
	self.RollSoundPatch = CreateSound(self,"trolleybus/roll.wav")
	self.RollSoundPatch:SetSoundLevel(80)
	self.RollSoundPatch:ChangeVolume(0)
	
	self.Buttons = {}
	self.OtherPanelEnts = {}
	
	for k,v in pairs(self.m_ButtonsData) do
		local panel = self.m_PanelsData[v.panel.name]
		local button = {index = k}
		
		self.Buttons[k] = button
		
		if v.model then
			local pos,ang = LocalToWorld(Vector(0,v.panel.pos[1],-v.panel.pos[2])+(v.model.offset_pos or vector_origin),v.model.offset_ang or angle_zero,panel.pos,panel.ang)
			
			table.insert(self.ClientEntsDistanceControl,{
				model = v.model.model,
				pos = pos,
				ang = ang,
				initialize = v.model.initialize,
				think = v.model.think,
				distance = v.model.maxdrawdistance,
				button = button,
			})
		end
		
		button.Cfg = v
		button.LastState = self:ButtonIsDown(k)
		button.Panel = v.panel.name
		
		if v.model then
			button.MoveState = button.LastState and 1 or 0
		end
	end
	
	for k,v in pairs(self.m_OtherPanelEntsData) do
		local panel = self.m_PanelsData[v.panel.name]
		local pos,ang = LocalToWorld(Vector(0,v.panel.pos[1],-v.panel.pos[2])+(v.offset_pos or vector_origin),v.offset_ang or angle_zero,panel.pos,panel.ang)
		
		local data = {index = k}
		data.Cfg = v
		data.Panel = v.panel.name
		
		table.insert(self.ClientEntsDistanceControl,{
			model = v.model,
			pos = pos,
			ang = ang,
			initialize = v.initialize,
			think = v.think,
			distance = v.maxdrawdistance,
			otherent = data,
		})
		
		self.OtherPanelEnts[k] = data
	end
	
	if !self.IsTrailer then
		local data = self.SteerData
		local LP = LocalPlayer()
	
		self.Steer = ClientsideModel(data.model,RENDERGROUP_BOTH)
		self.Steer.startang = data.ang
		self.Steer.rollmult = data.rollmult
		self.Steer.RenderOverride = function(s,flags)
			if s.transparent then render.SetBlend(0.5) end
		
			s:DrawModel(flags)
			
			if transparent then render.SetBlend(1) end
		end
		self.Steer:CreateShadow()
		self.Steer:SetParent(self)
		self.Steer:SetLocalPos(data.pos)
		self.Steer:SetLocalAngles(data.ang)
	end
	
	self.Doors = {}
	for k,v in pairs(self.DoorsData) do
		local door = ClientsideModel(v.model,RENDERGROUP_BOTH)
		self.Doors[k] = door
		
		door:CreateShadow()
		door:SetParent(self)
		door:SetLocalPos(v.pos)
		door:SetLocalAngles(v.ang)
		
		door.Cfg = v
		door.State = self:DoorIsOpened(k)
		door.MoveState = door.State and 1 or 0
		
		if v.poseparameter then
			local paramstart = v.poseparamstart or 0
			local paramend = v.poseparamend or 1
			
			door:SetPoseParameter(v.poseparameter,paramstart+(paramend-paramstart)*door.MoveState)
		elseif v.anim then
			door:SetPlaybackRate(0)
		
			local start = v.animstart or 0
			local aend = v.animend or 1
			
			door:SetCycle(start+(aend-start)*door.MoveState)
		end
	end
	
	self.PassSeats = {}
	self.Passengers = {}
	self.PassengersCount = 0
	
	for i=1,math.min(self:GetPassCount(),Trolleybus_System.GetPlayerSetting("TrolleybusMaxPassengers")) do
		local pass = CreatePassenger(self)
		
		if pass then
			table.insert(self.Passengers,pass)
		end
		
		self.PassengersCount = self.PassengersCount+1
	end
	
	if self.TrailerData then
		local dt = self.TrailerData.joint
		
		self.Joint = ClientsideModel(dt.model,RENDERGROUP_BOTH)
		self.Joint:CreateShadow()
		self.Joint:SetParent(self)
		self.Joint:SetLocalPos(dt.modelpos or dt.pos)
		self.Joint:SetLocalAngles(dt.modelang or angle_zero)
		
		if dt.creaksound then
			self.Joint.CreakSnd = Trolleybus_System.PlayBassSound(self.Joint,dt.creaksound,300,0,true)
			self.Joint.CreakSndFr = 0
			
			hook.Add("Think",self.Joint,function(ent)
				if !ent.LastCurvature then return end
				
				local dt = FrameTime()
				local ang = ent.LastCurvature
				
				ent.PrevCurvature = ent.PrevCurvature or ang
				
				local spd = math.abs(ang-ent.PrevCurvature)/dt
				ent.PrevCurvature = ang
				
				local desfr = math.Clamp(spd/20,0,1)
				ent.CreakSndFr = ent.CreakSndFr<desfr and math.min(ent.CreakSndFr+dt*4,desfr) or math.max(ent.CreakSndFr-dt*4,desfr)
				
				ent.CreakSnd.volume = ent.CreakSndFr*0.3
				ent.CreakSnd.prate = 0.75+ent.CreakSndFr*0.25
			end)
		end
		
		hook.Add("PreRender",self.Joint,function(ent)
			ent.ShouldDraw = IsValid(self) and IsValid(self:GetTrailer()) and !self:IsDormant() and !self:GetTrailer():IsDormant()
			ent:SetNoDraw(!ent.ShouldDraw)
		end)
		
		self.Joint:CallOnRemove("removejointfunc",function(ent)
			hook.Remove("PreRender",ent)
			hook.Remove("Think",ent)
		end)
		
		self.Joint:AddCallback("BuildBonePositions",function(ent,count)
			if !ent.ShouldDraw then return end
			
			local pricep = self:GetTrailer()
			local bone1id = ent:LookupBone(dt.bone)
			local bone2id = ent:LookupBone(dt.trailerbone)
			
			if bone1id and bone2id then
				local p1,a1 = LocalToWorld(dt.pos,dt.ang,self:GetPos(),self:GetAngles())
				local p2,a2 = LocalToWorld(dt.trailerpos,dt.trailerang,pricep:GetPos(),pricep:GetAngles())
				
				local m1,m2 = Matrix(),Matrix()
				
				m1:SetTranslation(p1)
				m1:SetAngles(a1)
				
				m2:SetTranslation(p2)
				m2:SetAngles(a2)
				
				ent:SetBoneMatrix(bone1id,m1)
				ent:SetBoneMatrix(bone2id,m2)
				
				ent.LastCurvature = math.abs(math.NormalizeAngle(a1.p-a2.p))+math.abs(math.NormalizeAngle(a1.y-a2.y))+math.abs(math.NormalizeAngle(a1.r-a2.r))
			end
		end)
	end
	
	self.Mirrors = {}
	if self.MirrorsData then
		for k,v in pairs(self.MirrorsData) do
			if v.otherent then continue end
			
			local mirror = Trolleybus_System.CreateMirror()
			mirror:SetWidth(v.width)
			mirror:SetHeight(v.height)
			mirror:SetParent(self)
			mirror:SetLocalPos(v.pos)
			mirror:SetLocalAngles(v.ang)
			mirror.Trolleybus = self
			
			self.Mirrors[k] = mirror
			
			if v.initialize then v.initialize(self,mirror) end
		end
	end
	
	self:UpdateClientEntsDistanceControl()
end

function ENT:ClearClientEnts()
	if self.HasPoles and self.PolesData then
		for i=1,2 do
			local t = self.PolesData[i==1 and "Left" or "Right"]
		
			SafeRemoveEntity(t.TrolleyPole)
			SafeRemoveEntity(t.TrolleyWheel)
		end
		
		self.PolesData = nil
	end
	
	if self.RollSoundPatch then
		self.RollSoundPatch:Stop()
		self.RollSoundPatch = nil
	end

	self.Buttons = nil
	self.OtherPanelEnts = nil
	
	if !self.IsTrailer then
		SafeRemoveEntity(self.Steer)
	end
	
	if self.Doors then
		for k,v in pairs(self.Doors) do
			SafeRemoveEntity(v)
		end
		
		self.Doors = nil
	end
	
	self.PassSeats = nil
	
	if self.Passengers then
		for k,v in pairs(self.Passengers) do
			SafeRemoveEntity(v)
		end
		
		self.Passengers = nil
		self.PassengersCount = nil
	end
	
	if self.TrailerData then
		SafeRemoveEntity(self.Joint)
	end
	
	if self.Mirrors then
		for k,v in pairs(self.Mirrors) do
			v:Remove()
		end
	
		self.Mirrors = nil
	end
	
	for k,v in pairs(self.CustomClientEnts) do
		SafeRemoveEntity(v)
	end
	self.CustomClientEnts = {}
	
	self:UpdateClientEntsDistanceControl(true)
end

function ENT:UpdateClientEnts(transmit)
	if transmit==nil then transmit = !self:IsDormant() end

	local oldrender = self.RenderClientEnts
	local newrender = self:ShouldRenderClientEnts(transmit)
	
	if oldrender!=newrender then
		self.RenderClientEnts = newrender
		self:RenderClientEntsChanged(newrender)
	end

	Trolleybus_System.RunChangeEvent("Trolleybus_RenderClientEnts",oldrender,newrender,self)
end

function ENT:NotifyShouldTransmit(should)
	self:UpdateClientEnts(should)
end

function ENT:ControlPoles()
	if self.RenderClientEnts then
		if self.HasPoles and self.PolesData then
			local TrolleyPolePos = self.TrolleyPolePos
			local TrolleyPoleLength = self.TrolleyPoleLength
			local TrolleyPoleWheelOffset = self.TrolleyPoleWheelOffset
			local TrolleyPoleWheelRotate = self.TrolleyPoleWheelRotate
			local TrolleyPoleDrawRotate = self.TrolleyPoleDrawRotate
			
			local selfpos,selfang = self:GetPos(),self:GetAngles()
		
			for i=1,2 do
				local right = i==2
				local t = self.PolesData[right and "Right" or "Left"]
				local angleback = right and self.TrolleyPoleDownedAngleRight or self.TrolleyPoleDownedAngleLeft
				local state = self:GetPoleState(right)
				local statetime = CurTime()-self:GetPoleStateTime(right)
				local statechange = false
				
				t.polelang = t.polelang or angleback
				
				if state!=t.laststate then
					statechange = true
					t.laststate = state
				end
				
				if statechange then
					t.polelaststateang = t.polelang
					t.clcontact,t.clwire,t.clendpos = nil,nil,nil
				end
				
				local wheelang,wheelsnd
			
				if state==0 then
					local svcontact,svwire = self:GetPoleContactWire(right)
					local svendpos = self:GetPoleAngInversion(right)
					local contact,wire,endpos = t.clcontact,t.clwire,t.clendpos

					if svcontact==contact and svwire==wire and svendpos==endpos then
						t.clcontactwiretime = RealTime()
					end

					if !contact or !t.clcontactwiretime or RealTime()-t.clcontactwiretime>0.3 then
						t.clcontact,t.clwire,t.clendpos = svcontact,svwire,svendpos
						contact,wire,endpos = t.clcontact,t.clwire,t.clendpos
					end

					local pos = self:GetPolePos(right)

					local data = Trolleybus_System.ContactNetwork.GetCurrentContactWire(pos,TrolleyPoleLength,contact,wire,endpos)
					
					if data then
						t.clcontact,t.clwire,t.clendpos = data.Contact,data.Wire,data.EndPos

						local wang = data.Ang
						t.polelang = self:WorldToLocalAngles((data.Pos-pos):Angle())
						
						wheelang = wang
						
						if statetime<0.25 then
							t.polelang = LerpAngle(statetime*4,t.polelaststateang,t.polelang)
						else
							local object = Trolleybus_System.ContactNetwork.GetObject(svcontact)
							if object then
								wheelsnd = object:GetWheelSlidingSound(svwire)
							end
						end
					end
				else
					t.polelang = LerpAngle(math.min(self.DeltaTime*15,1),t.polelang,self:GetPoleMoveAng(right))
					
					if state==3 then
						local contact = self:GetNWVar("CatcherNearestWire"..(right and "R" or "L").."Contact")

						if contact then
							local wire = self:GetNWVar("CatcherNearestWire"..(right and "R" or "L").."Wire")
							local endpos = self:GetNWVar("CatcherNearestWire"..(right and "R" or "L").."EndPos")
							
							if wire then
								local data = Trolleybus_System.ContactNetwork.GetCurrentContactWire(self:GetPolePos(right),TrolleyPoleLength,contact,wire,endpos)
								if data then
									wheelang = data.Ang
								end
							end
						end
					end
				end
				
				local pole = t.TrolleyPole
				local wheel = t.TrolleyWheel
				
				local poleang = Angle(t.polelang)
				
				if TrolleyPoleDrawRotate and !TrolleyPoleDrawRotate:IsZero() then
					poleang:RotateAroundAxis(poleang:Right(),TrolleyPoleDrawRotate.p)
					poleang:RotateAroundAxis(poleang:Up(),TrolleyPoleDrawRotate.y)
					poleang:RotateAroundAxis(poleang:Forward(),TrolleyPoleDrawRotate.r)
				end
				
				pole:SetLocalAngles(poleang)

				local anim = self.TrolleyPoleAnimation
				if anim then
					local lang = poleang

					for k,v in pairs(anim) do
						local bone = pole:LookupBone(k)
						if !bone then continue end

						local type,mp,add = v,1,angle_zero
						if istable(v) then
							type,mp,add = v[1],v[2] or mp,v[3] or add
						end

						if type=="Static" then
							local _,ang = WorldToLocal(vector_origin,Angle(0,0,lang.r/2),vector_origin,lang)

							pole:ManipulateBoneAngles(bone,ang)
						elseif type=="Base" then
							pole:ManipulateBoneAngles(bone,Angle(add.p,lang.y*mp+add.y,add.r))
						elseif type=="Pole" then
							pole:ManipulateBoneAngles(bone,Angle(lang.p*mp+add.p,add.y,add.r))
						elseif type=="Base+Pole" then
							pole:ManipulateBoneAngles(bone,Angle(lang.p*mp+add.p,lang.y*mp+add.y,add.r))
						end
					end
				end
				
				local wheellang = wheelang and self:WorldToLocalAngles(wheelang) or poleang
				if wheelang then wheellang.r = poleang.r end
				
				if TrolleyPoleWheelRotate and !wheelang and !TrolleyPoleWheelRotate:IsZero() then
					wheellang:RotateAroundAxis(wheellang:Right(),TrolleyPoleWheelRotate.p)
					wheellang:RotateAroundAxis(wheellang:Up(),TrolleyPoleWheelRotate.y)
					wheellang:RotateAroundAxis(wheellang:Forward(),TrolleyPoleWheelRotate.r)
				end
				
				local wheelpos = pole:GetLocalPos()+t.polelang:Forward()*TrolleyPoleLength
				
				if TrolleyPoleWheelOffset and !TrolleyPoleWheelOffset:IsZero() then
					wheelpos = wheelpos+wheellang:Forward()*TrolleyPoleWheelOffset.x-wheellang:Right()*TrolleyPoleWheelOffset.y+wheellang:Up()*TrolleyPoleWheelOffset.z
				end
				
				wheel:SetLocalPos(wheelpos)
				wheel:SetLocalAngles(wheellang)
				
				t.PolePos = pole:GetPos()
				t.PoleAng = self:LocalToWorldAngles(t.polelang)

				local oldwhpos = t.WheelPos
				t.WheelPos = wheel:GetPos()

				local oldwhsnd = t.WheelSound
				if oldwhsnd and wheelsnd!=oldwhsnd then Trolleybus_System.StopBassSound(wheel,oldwhsnd) end

				t.WheelSound = wheelsnd
				if wheelsnd then
					local snddata = Trolleybus_System.GetBassSoundData(wheel,wheelsnd) or Trolleybus_System.PlayBassSound(wheel,wheelsnd,500,0,true,self:GetCreationTime())
					local peakspd = 100

					local spd = oldwhpos and self:UPSToKPH(oldwhpos:Distance(t.WheelPos)/self.DeltaTime) or 0
					local fr = spd>peakspd and 1 or spd/peakspd

					snddata.volume = fr*0.5
					snddata.shouldplay = true
				end
			end
		end
	end
end

function ENT:ControlLighting()
	if !self.IsTrailer then
		for k,v in ipairs(self.HeadLights) do
			if !v.ang then continue end
			
			if self.RenderClientEnts and self:GetHeadLights()>0 and !Trolleybus_System.GetPlayerSetting("DisableHeadlights") and (!v.shouldbeactive or v.shouldbeactive(self)) then
				if !self.HeadLamps[k] then
					self.HeadLamps[k] = ProjectedTexture()
					self.HeadLamps[k]:SetColor(v.color)
					self.HeadLamps[k]:SetEnableShadows(false)
					self.HeadLamps[k]:SetFarZ(v.farz)
					self.HeadLamps[k]:SetNearZ(v.nearz)
					self.HeadLamps[k]:SetFOV(v.fov)
					self.HeadLamps[k]:SetTexture(v.texture)
				end
				
				local p,a = LocalToWorld(v.pos,v.ang,self:GetPos(),self:GetAngles())
				
				self.HeadLamps[k]:SetPos(p)
				self.HeadLamps[k]:SetAngles(a)
				self.HeadLamps[k]:SetBrightness(v.brightness*self:GetHeadLights())
				self.HeadLamps[k]:Update()
			else
				if self.HeadLamps[k] then
					self.HeadLamps[k]:Remove()
					self.HeadLamps[k] = nil
				end
			end
		end
		
		local dlight = Trolleybus_System.GetPlayerSetting("OptimizedCabineLight")
		
		if !dlight and self.RenderClientEnts and self:GetCabineLight()>0 then
			local data = self.CabineLightData
		
			if !self.CabineLight then
				self.CabineLight = ProjectedTexture()
				self.CabineLight:SetColor(data.color)
				self.CabineLight:SetFarZ(data.farz)
				self.CabineLight:SetNearZ(data.nearz)
				self.CabineLight:SetTexture(data.texture)
				self.CabineLight:SetFOV(data.fov)
				self.CabineLight:SetEnableShadows(false)
			end
		
			local pos,ang = LocalToWorld(data.pos,data.ang,self:GetPos(),self:GetAngles())
			self.CabineLight:SetPos(pos)
			self.CabineLight:SetAngles(ang)
			self.CabineLight:SetBrightness(data.brightness*self:GetCabineLight())
			self.CabineLight:Update()
		else
			if self.CabineLight then
				self.CabineLight:Remove()
				self.CabineLight = nil
			end
		end
		
		if dlight and self.RenderClientEnts and self:GetCabineLight()>0 then
			local data = self.CabineLightData
		
			local light = DynamicLight(self:EntIndex(),true)
			light.Pos = self:LocalToWorld(data.dlight_pos)
			light.style = 0
			light.r = data.color.r
			light.g = data.color.g
			light.b = data.color.b
			light.Decay = 500
			light.Size = math.max(data.dlight_size,data.dlight_pos:Length()+10)
			light.DieTime = CurTime()+0.5
			light.Brightness = data.dlight_brightness*self:GetCabineLight()
		end
	end
	
	if self.RenderClientEnts and self:GetInteriorLight()>0 then
		for k,v in ipairs(self.InteriorLights) do
			local index = self:GetNWVar("InteriorLight"..k)
			
			if index then
				local light = DynamicLight(index,true)
				light.Pos = self:LocalToWorld(v.pos)
				light.style = 0
				light.r = v.color.r
				light.g = v.color.g
				light.b = v.color.b
				light.Decay = 500
				light.Size = v.size
				light.DieTime = CurTime()+0.5
				light.Brightness = v.brightness*self:GetInteriorLight()
			end
		end
	end
end

function ENT:ControlButtons()
	if self.Buttons then
		for k,v in pairs(self.Buttons) do
			local cfg = v.Cfg
		
			if v.LastState!=self:ButtonIsDown(k) then
				v.LastState = self:ButtonIsDown(k)
				
				if v.Ent then
					self:ProcessCfgSound(v.Ent,cfg.model.sounds,v.LastState)
				end
			end
			
			if cfg.think then cfg.think(self,v.LastState) end
			
			if cfg.model and (v.LastState and v.MoveState!=1 or !v.LastState and v.MoveState!=0) then
				local spd = 5*(cfg.model.speedmult or 1)
				
				v.MoveState = v.LastState and math.min(1,v.MoveState+self.DeltaTime*spd) or math.max(0,v.MoveState-self.DeltaTime*spd)
			end
		end
	end
end

function ENT:GetDoorsSpeed(name)
	local mp = 1
	
	if self.SystemsLoaded then
		for k,v in pairs(self.Systems) do
			if v.ModifyDoorsSpeed then
				mp = mp*(v:ModifyDoorsSpeed(name) or 1)
			end
		end
	end
	
	return mp
end

function ENT:ControlDoors()
	if self.Doors then
		local bus = self:GetMainTrolleybus()
		
		for k,v in pairs(self.Doors) do
			local cfg = v.Cfg
			local handmove = self:GetNWVar("MoveDoorHand."..k)
		
			local oldstate,state = v.State,self:DoorIsOpened(k)
			local oldmove = v.MoveState
			v.State = state
			
			if v.State and v.MoveState!=1 or !v.State and v.MoveState!=0 then
				local spdmult = (cfg.speedmult or 1)*(handmove and 1.5 or bus:GetDoorsSpeed(k))
				v.MoveState = v.State and math.min(1,v.MoveState+self.DeltaTime*spdmult) or math.max(0,v.MoveState-self.DeltaTime*spdmult)
				
				if cfg.poseparameter then
					local paramstart = cfg.poseparamstart or 0
					local paramend = cfg.paseparamend or 1
				
					v:SetPoseParameter(cfg.poseparameter,paramstart+(paramend-paramstart)*v.MoveState)
				elseif cfg.anim then
					local start = cfg.animstart or 0
					local aend = cfg.animend or 1
					
					v:SetCycle(start+(aend-start)*v.MoveState)
				end
			end
			
			local opensoundstart = Either(handmove,cfg.openhandsoundstart,cfg.opensoundstart)
			local closesoundstart = Either(handmove,cfg.closehandsoundstart,cfg.closesoundstart)
			local movesound = Either(handmove,cfg.movehandsound,cfg.movesound)
			
			if state and oldmove==0 and opensoundstart then
				self:ProcessCfgSound(v,opensoundstart,state)
			end
			
			if !state and oldmove==1 and closesoundstart then
				self:ProcessCfgSound(v,closesoundstart,state)
			end
		
			if movesound and (state and oldmove==0 or !state and oldmove==1) then
				local mp = handmove and 1 or bus:GetDoorsSpeed(k)
				
				if istable(movesound) then
					Trolleybus_System.PlayBassSound(v,movesound[1],(movesound[2] or 1000)*mp,(movesound[3] or 1)*mp,true)
				else
					Trolleybus_System.PlayBassSound(v,movesound,1000*mp,mp,true)
				end
			end
			
			local opensoundend = handmove and cfg.openhandsoundend or cfg.opensoundend
			local closesoundend = handmove and cfg.closehandsoundend or cfg.closesoundend
			
			if state and oldmove!=1 and v.MoveState==1 and opensoundend then
				self:ProcessCfgSound(v,opensoundend,state)
			end
			
			if !state and oldmove!=0 and v.MoveState==0 and closesoundend then
				self:ProcessCfgSound(v,closesoundend,state)
			end
			
			if state and v.MoveState==1 and oldmove!=1 or !state and v.MoveState==0 and oldmove!=0 then
				if cfg.movesound then Trolleybus_System.StopBassSound(v,istable(cfg.movesound) and cfg.movesound[1] or cfg.movesound) end
				if cfg.movehandsound then Trolleybus_System.StopBassSound(v,istable(cfg.movehandsound) and cfg.movehandsound[1] or cfg.movehandsound) end
			end
		end
	end
end

function ENT:ControlSteer()
	local steer = self.Steer
	
	if IsValid(steer) then
		local ang = self:GetSteerAngle()
		steer.lerpang = Lerp(self.DeltaTime*15,steer.lerpang or ang,ang)
		
		local ang = Angle(steer.startang)
		ang:RotateAroundAxis(ang:Up(),steer.lerpang*steer.rollmult)
		
		steer:SetLocalAngles(ang)
		
		local ply = LocalPlayer()
		local transparent = ply:InVehicle() and ply:GetVehicle()==self:GetDriverSeat() and Trolleybus_System.GetPlayerSetting("SteerTransparent")
		
		if steer.transparent!=transparent then
			steer.transparent = transparent
			
			steer:SetRenderMode(transparent and RENDERMODE_TRANSCOLOR or RENDERMODE_NORMAL)
		end
	end
end

function ENT:ControlPassengers()
	if self.Passengers then
		local passcount = math.min(self:GetPassCount(),Trolleybus_System.GetPlayerSetting("TrolleybusMaxPassengers"))
	
		if self.PassengersCount!=passcount then
			while self.PassengersCount<passcount do
				local pass = CreatePassenger(self)
				if pass then
					table.insert(self.Passengers,pass)
				end
				
				self.PassengersCount = self.PassengersCount+1
			end
			
			while self.PassengersCount>passcount do
				if self.PassengersCount<=#self.Passengers then
					SafeRemoveEntity(self.Passengers[1])
					table.remove(self.Passengers,1)
				end
			
				self.PassengersCount = self.PassengersCount-1
			end
		end
	end
end

function ENT:ControlTurnSound()
	if self.IsTrailer then return end

	local oldstate = self.TurnSignalSoundState
	self.TurnSignalSoundState = self.RenderClientEnts and (self:GetTurnSignal()!=0 or self:GetEmergencySignal()) and Trolleybus_System.TurnSignalTickActive(self)
	
	if oldstate==nil then
		oldstate = self.TurnSignalSoundState
	end
	
	if !self.RenderClientEnts then return end
	
	local state = self.TurnSignalSoundState
	if oldstate!=state then
		Trolleybus_System.PlayBassSoundSimple(self,state and self.TurnSignalSoundOn or self.TurnSignalSoundOff,100,1,nil,self.DriverSeatData.Pos)
	end
end

function ENT:ControlViewMove()
	if self.IsTrailer then return end

	local ply = LocalPlayer()
	if Trolleybus_System.IsControlButtonDown("viewmove") and Trolleybus_System.CanPressButtons(self,ply) then
		self.ViewMoveOffset = self.ViewMoveOffset or Vector()
		
		local offset = self.ViewMoveOffset
		local limits = self.CameraView.ViewMoveLimits
		
		local ang = Trolleybus_System.EyeAngles()
		local dir = Vector()
		
		if ply:KeyDown(IN_FORWARD) then
			dir:Add(ang:Forward())
		elseif ply:KeyDown(IN_BACK) then
			dir:Add(-ang:Forward())
		end
		
		if ply:KeyDown(IN_MOVELEFT) then
			dir:Add(-ang:Right())
		elseif ply:KeyDown(IN_MOVERIGHT) then
			dir:Add(ang:Right())
		end
		
		if ply:KeyDown(IN_JUMP) then
			dir:Add(ang:Up())
		end
		
		if !dir:IsZero() then
			local spd = Trolleybus_System.GetPlayerSetting("ViewMoveSpeed")
			if ply:KeyDown(IN_SPEED) then spd = spd*2 end
		
			offset:Add(self:WorldToLocalAngles(dir:Angle()):Forward()*self.DeltaTime*spd)
			offset.x = math.Clamp(offset.x,limits[1].x,limits[2].x)
			offset.y = math.Clamp(offset.y,limits[1].y,limits[2].y)
			offset.z = math.Clamp(offset.z,limits[1].z,limits[2].z)
		end
	elseif Trolleybus_System.IsControlButtonDown("viewmovereset") then
		self.ViewMoveOffset = nil
	end
end

function ENT:ControlRollSound()
	if self.RenderClientEnts then
		local speed = math.abs(self:GetMoveSpeed())
		
		local fr = math.Clamp(math.Remap(speed,10,60,0,1),0,1)
		
		if !self.RollSoundPatch:IsPlaying() then
			self.RollSoundPatch:PlayEx(fr,100)
		else
			self.RollSoundPatch:ChangeVolume(fr)
		end
	end
end

function ENT:RenderClientEntsChanged(state)
	if state then
		self:CreateClientEnts()
		
		if self.SpawnSettingsReceived then
			self:SetupSpawnSettingsOnClientEnts(self._SpawnSettings)
		end
		
		self:UpdateSkins()
	else
		self:ClearClientEnts()
	end
end

function ENT:SetupSpawnSettings()
	if self._SpawnSettings then
		for k,v in ipairs(self._SpawnSettings) do
			if self.SpawnSettings and self.SpawnSettings[k] and self.SpawnSettings[k].unload then
				self.SpawnSettings[k].unload(self,v)
			end
		end
	end
	
	self._SpawnSettings = {}
	self._SpawnSettingsNames = {}
	
	if self.SpawnSettings then
		for k,v in ipairs(self.SpawnSettings) do
			local default = v.default
			if v.type=="ComboBox" and v.choices[v.default].value!=nil then
				default = v.choices[v.default].value
			end
		
			local value = self:GetNWVar("SpawnSetting_"..k,default)
			self._SpawnSettings[k] = value
			
			if v.alias then
				self._SpawnSettingsNames[v.alias] = k
			end
			
			if self.SystemsLoaded and v.setup then v.setup(self,value) end
		end
	end
end

function ENT:OnSpawnSettingsReceived(settings)
	if !self.SystemsLoaded then
		self:SetupSystems()
	end

	if self.RenderClientEnts then
		self:ReloadClientEnts()
	end
end

function ENT:SetupSpawnSettingsOnClientEnts(settings)
	for k,v in ipairs(self.SpawnSettings) do
		if settings[k]==nil then continue end
	
		if v.setupclents then
			v.setupclents(self,settings[k])
		end
	end
end

function ENT:UpdateSkins(servermdl)
	self.LastSkinsUpdate = CurTime()

	for k,v in pairs(self.SkinsToUpdate) do
		v[1](servermdl)
	end
end

function ENT:ReloadClientEnts()
	self:RenderClientEntsChanged(self.RenderClientEnts)
end

function ENT:UpdateClientEntsDistanceControl(clear)
	if #self.ClientEntsDistanceControl==0 then return end
	
	local eyepos = Trolleybus_System.EyePos()
	
	if clear==nil then
		clear = !self.RenderClientEnts
	end
	
	local i = 1
	while true do
		local data = self.ClientEntsDistanceControl[i]
		if !data then break end
		
		local ent = data.m_ent
		
		if clear or data.distance and eyepos:DistToSqr(ent and ent:GetPos() or self:LocalToWorld(data.pos))>data.distance^2 then
			if ent then
				ent:Remove()
				data.m_ent = nil
				
				if data.button then data.button.Ent = nil end
				if data.otherent then data.otherent.Ent = nil end
				
				if data.otherent and IsValid(data.m_mirror) then
					data.m_mirror:Remove()
				end
			end
			
			if clear then
				table.remove(self.ClientEntsDistanceControl,i)
				continue
			end
		else
			if !ent then
				ent = ClientsideModel(data.model,RENDERGROUP_BOTH)
				ent:SetParent(self)
				ent:SetLocalPos(data.pos)
				ent:SetLocalAngles(data.ang)
				ent:SetPlaybackRate(0)
				
				data.m_ent = ent
				
				if data.button then data.button.Ent = ent end
				if data.otherent then data.otherent.Ent = ent end
				
				if data.initialize then data.initialize(self,ent) end
				
				for k,v in pairs(self.SkinsToUpdate) do
					v[2](ent)
				end
				
				if data.otherent and self.MirrorsData then
					for k,v in pairs(self.MirrorsData) do
						if !v.otherent or v.otherent!=data.otherent.index then continue end
						
						local mirror = Trolleybus_System.CreateMirror()
						mirror:SetWidth(v.width)
						mirror:SetHeight(v.height)
						mirror:SetParent(ent)
						mirror:SetLocalPos(v.pos)
						mirror:SetLocalAngles(v.ang)
						mirror.Trolleybus = self
						
						data.m_mirror = mirror
						
						if v.initialize then v.initialize(self,mirror) end
					end
				end
			end
			
			if data.button then
				local dt = data.button
				local cfg = dt.Cfg
			
				if cfg.model.poseparameter then
					local paramstart = cfg.model.poseparamstart or 0
					local paramend = cfg.model.poseparamend or 1
					
					ent:SetPoseParameter(cfg.model.poseparameter,paramstart+(paramend-paramstart)*dt.MoveState)
				elseif cfg.model.anim then
					local start = cfg.model.animstart or 0
					local aend = cfg.model.animend or 1
					
					ent:SetCycle(start+(aend-start)*dt.MoveState)
				end
			end
			
			if data.think then data.think(self,ent) end
		end
		
		i = i+1
	end
end

function ENT:CreateCustomClientEnt(index,model)
	if IsValid(self.CustomClientEnts[index]) then
		self.CustomClientEnts[index]:Remove()
	end
	
	local ent = ClientsideModel(model,RENDERGROUP_BOTH)
	ent:CreateShadow()
	ent:SetParent(self)
	ent:SetLocalPos(vector_origin)
	ent:SetLocalAngles(angle_zero)
	
	self.CustomClientEnts[index] = ent
	
	return ent
end

function ENT:GetCustomClientEnt(index)
	return self.CustomClientEnts[index]
end

function ENT:AddDynamicButton(button,data)
	self.m_ButtonsData[button] = data
end

function ENT:RemoveDynamicButton(button)
	self.m_ButtonsData[button] = nil
end

function ENT:AddDynamicPanel(panel,data)
	self.m_PanelsData[panel] = data
end

function ENT:RemoveDynamicPanel(panel)
	self.m_PanelsData[panel] = nil
end

function ENT:AddDynamicOtherPanelEnt(ent,data)
	self.m_OtherPanelEntsData[ent] = data
end

function ENT:RemoveDynamicOtherPanelEnt(ent)
	self.m_OtherPanelEntsData[ent] = nil
end

function ENT:Think()
	local delta = CurTime()-self.UpdateTime
	self.UpdateTime = CurTime()
	self.DeltaTime = delta
	
	local spawnsettingsreceive = self:GetNWVar("SpawnSettingsReceive",0)
	if self.SpawnSettingsReceive!=spawnsettingsreceive and (!self.IsTrailer or IsValid(self:GetTrolleybus())) then
		self.SpawnSettingsReceive = spawnsettingsreceive
		
		if self.IsTrailer then
			self.SpawnSettings = self:GetTrolleybus().SpawnSettings
		end
		
		self:SetupSpawnSettings()
		self:OnSpawnSettingsReceived(self._SpawnSettings)
	end
	
	self:UpdateClientEnts()
	
	self:SystemsEvent(false,"Think",delta)
	
	self:ControlPoles()
	self:ControlLighting()
	self:ControlButtons()
	self:ControlDoors()
	self:ControlSteer()
	self:ControlPassengers()
	self:ControlTurnSound()
	self:ControlViewMove()
	self:ControlRollSound()
	
	self:UpdateClientEntsDistanceControl()
	
	if self.BortNumber!=self:GetBortNumber() then
		self.BortNumber = self:GetBortNumber()
		
		self:UpdateSkins()
	end
	
	if self.RenderClientEnts and self.LastSkinsUpdate and CurTime()-self.LastSkinsUpdate>0.25 then
		self:UpdateSkins(true)
	end
	
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:DrawTranslucent(flags)
	self:DrawModel(flags)

	Trolleybus_System.MarkEntityAsDrawnThisFrame(self,true)
end

function ENT:Draw(flags)
	self:DrawModel(flags)

	Trolleybus_System.MarkEntityAsDrawnThisFrame(self,false)
end

function ENT:OnRemove()
	if !self.IsTrailer then
		for k,v in ipairs(self.HeadLights) do
			if self.HeadLamps[k] then
				self.HeadLamps[k]:Remove()
				self.HeadLamps[k] = nil
			end
		end
	end
	
	if self.CabineLight then
		self.CabineLight:Remove()
		self.CabineLight = nil
	end
	
	local oldrender = self.RenderClientEnts
	self.RenderClientEnts = false
	
	if oldrender!=self.RenderClientEnts then
		self:RenderClientEntsChanged(self.RenderClientEnts)
	end
	
	if self.SystemsLoaded then
		for k,v in pairs(self.Systems) do
			if v.OnRemove then v:OnRemove() end
		end
	end
end