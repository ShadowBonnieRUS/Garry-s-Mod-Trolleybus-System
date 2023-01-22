-- Copyright © Platunov I. M., 2021 All rights reserved

ENT.RenderGroup = RENDERGROUP_BOTH

include("shared.lua")

function ENT:Initialize()
	self.SpawnTime = self:GetCreationTime()
	
	self:UpdateClientEnts(true)
end

function ENT:Think()
	local data = self:GetVehicleData()
	
	if self:UpdateClientEnts(!self:IsDormant()) then
		local speed = self:GetVelocity():Length()
		local pdata = data.EngineSoundPitch
		local pitch = pdata[1]+math.Clamp(speed/data.MaxSpeed,0,1)*(pdata[2]-pdata[1])
		
		self.EngineSound:ChangePitch(pitch)
		
		local fr = math.Clamp(math.Remap(speed,50,500,0,1),0,1)
		self.RollSound:ChangeVolume(fr)
		
		if !Trolleybus_System.TrafficWheelDebug then
			local spd = self:GetMoveSpeed()
			
			for k,v in ipairs(self.Wheels) do
				for k,v in ipairs(v) do
					local spd = v.Left and spd or -spd
					
					local whdata = v.Data
					v.Rotate = (v.Rotate+spd*FrameTime()/math.pi/whdata.Radius*360/2)%360
					
					local turn = v.Turn and self:GetTurn() or 0
					v:SetLocalAngles(Angle(0,v.Left and 90 or -90,0)+whdata.Ang+whdata.RotateAxis*v.Rotate+whdata.TurnAxis*turn)
				end
			end
		end
	end
end

function ENT:UpdateClientEnts(transmit)
	local data = self:GetVehicleData()

	if !transmit or self:GetPos():DistToSqr(Trolleybus_System.EyePos())>Trolleybus_System.GetPlayerSetting("TrafficDetailsDrawDistance")^2 then
		if self.EngineSound then
			self.EngineSound:Stop()
			self.EngineSound = nil
		end
		
		if self.RollSound then
			self.RollSound:Stop()
			self.RollSound = nil
		end
		
		if self.DriverEnt then
			SafeRemoveEntity(self.DriverEnt)
			self.DriverEnt = nil
		end
		
		if self.Wheels then
			for k,v in ipairs(self.Wheels) do
				for k,v in ipairs(v) do
					SafeRemoveEntity(v)
				end
			end
			
			self.Wheels = nil
		end
		
		return false
	else
		if !self.EngineSound then
			self.EngineSound = CreateSound(self,"<"..data.EngineSound)
			self.EngineSound:SetSoundLevel(65)
			self.EngineSound:ChangeVolume(1)
			self.EngineSound:Play()
		end
		
		local pdata = data.EngineSoundPitch
		
		if !self.DriverEnt then
			self.DriverEnt = ClientsideModel(table.Random(Trolleybus_System.PassModels),RENDERGROUP_BOTH)
			self.DriverEnt:CreateShadow()
			self.DriverEnt:SetParent(self)
			self.DriverEnt:SetLocalPos(data.DriverPos)
			self.DriverEnt:SetLocalAngles(data.DriverAng)
			self.DriverEnt:SetSequence(self.DriverEnt:LookupSequence("drive_jeep"))

			local vec = VectorRand(0,1)
			self.DriverEnt.GetPlayerColor = function() return vec end
		end
		
		if !self.RollSound then
			self.RollSound = CreateSound(self,"trolleybus/roll.wav")
			self.RollSound:SetSoundLevel(80)
			self.RollSound:PlayEx(1,100)
		end
		
		self.Wheels = self.Wheels or {}
		
		local spd = self:GetMoveSpeed()
		
		if !Trolleybus_System.TrafficWheelDebug then
			for k,v in ipairs(data.Wheels) do
				for k2,v2 in ipairs(v.Wheels) do
					local wh = self.Wheels[k] and self.Wheels[k][k2]
					
					if !IsValid(wh) then
						local whdata = Trolleybus_System.WheelTypes[v2.Type]
					
						wh = ClientsideModel(whdata.Model,RENDERGROUP_BOTH)
						//wh:CreateShadow()
						wh:SetParent(self)
						wh:SetLocalPos(v2.Pos)
						wh.Rotate = 0
						wh.Data = whdata
						wh.Left = !v2.Right
						wh.Turn = v.Turn
						
						self.Wheels[k] = self.Wheels[k] or {}
						self.Wheels[k][k2] = wh
					end
				end
			end
		end
		
		return true
	end
end

function ENT:OnRemove()
	self:UpdateClientEnts(false)
end

local sprites = {}
local function DrawSprite(self,tab,key,pos,mat,size,col)
	tab[key] = tab[key] or Trolleybus_System.CreatePixVisUHandle()
	
	pos = self:LocalToWorld(pos)
	sprites[mat] = sprites[mat] or Material(mat)
	
	local vis = tab[key]:PixelVisible(pos,1)
	if vis==0 then return end
	
	render.SetMaterial(sprites[mat])
	render.DrawSprite(pos,size,size,ColorAlpha(col,vis*255))
end

function ENT:Draw(flags)
	self:DrawModel(flags)
end

function ENT:DrawTranslucent(flags)
	self:DrawModel(flags)

	Trolleybus_System.MarkEntityAsDrawnThisFrame(self,true)
end

function ENT:DrawSprites()
	local class = self:GetVehicleData()
	
	if class and EyePos():Distance(self:GetPos())<Trolleybus_System.GetPlayerSetting("TrafficDetailsDrawDistance") then
		self.pixviss = self.pixviss or {}
		
		for i=1,#class.Sprites do
			local data = class.Sprites[i]
			
			DrawSprite(self,self.pixviss,i,data[1],data[2],data[3],data[4])
		end
		
		if self:GetTurnSignal()>0 and Trolleybus_System.TurnSignalTickActive(self) then
			if self:GetTurnSignal()==1 then
				self.pixviss_left = self.pixviss_left or {}
				
				for i=1,#class.SpritesTurnLeft do
					local data = class.SpritesTurnLeft[i]
					
					DrawSprite(self,self.pixviss_left,i,data[1],data[2],data[3],data[4])
				end
			else
				self.pixviss_right = self.pixviss_right or {}
				
				for i=1,#class.SpritesTurnRight do
					local data = class.SpritesTurnRight[i]
					
					DrawSprite(self,self.pixviss_right,i,data[1],data[2],data[3],data[4])
				end
			end
		end
	end
end

function ENT:NotifyShouldTransmit(should)
	self:UpdateClientEnts(should)
end