-- Copyright © Platunov I. M., 2021 All rights reserved

ENT.RenderGroup = RENDERGROUP_BOTH

include("shared.lua")

surface.CreateFont("TrolleybusTrafficLightTimer",{
	font = "Electronica-Normal",
	size = 34,
})

function ENT:Initialize()
	self.pixvis = {}
	self.LastLenses = {}
end

function ENT:DrawFullLense()
	local x,y,r = 0,0,20
	local seg = 18
	local ang = 360/seg
	
	for j=1,seg do
		surface.DrawPoly({
			{x = x,y = y},
			{x = x+math.sin(math.rad((j-1)*ang))*r,y = y-math.cos(math.rad((j-1)*ang))*r},
			{x = x+math.sin(math.rad(j*ang))*r,y = y-math.cos(math.rad(j*ang))*r},
		})
	end
end

local sprite = Material("sprites/light_ignorez")
function ENT:DrawLenseSprite(index,pos,ang,size,color,brightness)
	local pixvis = self.pixvis[index]
	if !pixvis then
		pixvis = Trolleybus_System.CreatePixVisUHandle()
		self.pixvis[index] = pixvis
	end
	
	local eyepos = EyePos()
	local dot = (eyepos-pos):GetNormalized():Dot(ang:Forward())
	if dot<0 then return end

	local visibility = pixvis:PixelVisible(pos,1)
	if visibility==0 then return end

	visibility = visibility*math.Clamp(eyepos:Distance(pos)/2000*brightness,0,1)
	
	render.SetMaterial(sprite)
	render.DrawSprite(pos,size,size,ColorAlpha(color,visibility*255))
end

local function CallDrawRender(self,translucent)
	local data = self:LightType()
	if !data then return end
	
	local pos = self:GetPos()
	if EyePos():DistToSqr(pos)>5000^2 then return end
	
	local ang = self:GetAngles()

	for k,v in ipairs(data.Lenses) do
		local lense,ldata = self:GetLenseData(k)
		
		local Render = Either(translucent,ldata.RenderTranslucent,ldata.Render)
		if Render then
			Render(self,LocalToWorld(v[1],v[2],pos,ang))
		end
		
		local Draw = Either(translucent,ldata.DrawTranslucent,ldata.Draw)
		if Draw then
			local pos,ang = LocalToWorld(v[1]+(ldata.DrawOffsetPos or vector_origin),v[2]+(ldata.DrawOffsetAng or angle_zero)+Angle(0,90,90),pos,ang)
	
			cam.Start3D2D(pos,ang,v[3])
				surface.SetTexture(0)
				
				Draw(self)
			cam.End3D2D()
		end
	end
end

function ENT:Draw(flags)
	self:DrawModel(flags)
	
	CallDrawRender(self,false)
end

function ENT:DrawTranslucent(flags)
	self:DrawModel(flags)
	
	CallDrawRender(self,true)
	Trolleybus_System.MarkEntityAsDrawnThisFrame(self,true)
end

function ENT:DrawSprites()
	local data = self:LightType()
	if !data then return end
	
	if EyePos():DistToSqr(self:GetPos())>5000^2 then return end
	
	local pos,ang = self:GetPos(),self:GetAngles()

	for k,v in ipairs(data.Lenses) do
		local lense,ldata = self:GetLenseData(k)
		
		if ldata.DrawSprites then
			ldata.DrawSprites(self,LocalToWorld(v[1],v[2],pos,ang))
		end
	end
end

function ENT:Think()
	if !self:IsDormant() then
		local data = self:LightType()
		
		if data then
			for k,v in ipairs(data.Lenses) do
				local lense,ldata = self:GetLenseData(k)
				
				if lense!=self.LastLenses[k] then
					self:OnLenseUpdate(k,self.LastLenses[k],lense)
					self.LastLenses[k] = lense
				end
			end
		end
	end
	
	self:UpdateClientEnts()

	self:SetNextClientThink(CurTime()+0.1)
	return true
end

function ENT:OnRemove()
	self:UpdateClientEnts(false)
end

function ENT:UpdateClientEnts(transmit)
	if transmit==nil then
		transmit = !self:IsDormant()
	end
	
	transmit = transmit and true or false
	
	if self.RenderClientEnts!=transmit then
		self.RenderClientEnts = transmit
		
		if transmit then
			self:CreateClientEnts()
		else
			self:ClearClientEnts()
		end
	end
	
	if transmit then
		self:UpdateLenseModels()
	end
end

function ENT:CreateClientEnts()
	self:ClearClientEnts()
	
	self.LenseModels = {}
end

function ENT:ClearClientEnts()
	if self.LenseModels then
		for k,v in pairs(self.LenseModels) do
			for k,v in pairs(v) do
				SafeRemoveEntity(v)
			end
		end
		
		self.LenseModels = nil
	end
end

function ENT:ClearLenseModels(num)
	local ents = self.LenseModels and self.LenseModels[num]
	
	if ents then
		for k,v in pairs(ents) do
			SafeRemoveEntity(v)
		end
		
		self.LenseModels[num] = nil
	end
end

function ENT:UpdateLenseModels()
	local data = self:LightType()
	if !data then return end
	
	local lenses = data.Lenses
	for i=1,#lenses do
		local k,v = i,lenses[i]
		
		local lense,ldata = self:GetLenseData(k)
		if !ldata.ClientEnts then continue end
		
		local clents = ldata.ClientEnts
		for j=1,#clents do
			local k2,v2 = j,clents[j]
			
			if !v2.ShouldDraw or v2.ShouldDraw(self) then
				self.LenseModels[k] = self.LenseModels[k] or {}
				
				local ent = self.LenseModels[k][k2]
				
				if !IsValid(ent) then
					ent = ClientsideModel(v2.Model,RENDERGROUP_BOTH)
					ent:SetParent(self)
					ent:SetLocalPos(v2.Pos or v[1])
					ent:SetLocalAngles(v2.Ang or v[2])
					ent:SetSkin(v2.Skin or 0)
					
					if v2.BG then
						for k,v in ipairs(v2.BG) do
							ent:SetBodygroup(k-1,v)
						end
					end
					
					self.LenseModels[k][k2] = ent
					
					if v2.Initialize then
						v2.Initialize(self,ent)
					end
				end
				
				if v2.Update then
					v2.Update(self,ent)
				end
			elseif self.LenseModels[k] and IsValid(self.LenseModels[k][k2]) then
				self.LenseModels[k][k2]:Remove()
			end
		end
	end
end

function ENT:OnLenseUpdate(num,old,new)
	if self.RenderClientEnts then
		self:ClearLenseModels(num)
	end
end