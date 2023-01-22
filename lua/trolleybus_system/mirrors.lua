-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.Mirrors = Trolleybus_System.Mirrors or {}
Trolleybus_System.MirrorIndeces = Trolleybus_System.MirrorIndeces or {}

Trolleybus_System.MirrorMaterial = Trolleybus_System.MirrorMaterial or CreateMaterial("Trolleybus_System_Mirror","UnlitGeneric",{})

local copymat = Material("pp/copy")
local copytex = GetRenderTarget("Trolleybus_System_Mirror",ScrW(),ScrH())

local MIRROR_TEXTURE_SCALE = 0.5

local MIRROR = {
	Init = function(self,pos,ang,w,h,maxdist)
		local index = 0
		
		while Trolleybus_System.MirrorIndeces[index] do
			index = index+1
		end
		
		Trolleybus_System.MirrorIndeces[index] = true
		Trolleybus_System.Mirrors[self] = true
		
		self.Index = index
		self.m_Pos = pos
		self.m_Ang = ang
		self.W = w
		self.H = h
		self.Distance = maxdist or 500
	end,
	MakeComplex = function(self,verts)
		self.m_ComplexPoly = Trolleybus_System.CreateTexturedPoly(verts)
		self.m_ComplexPoly:SetUV(0,1,1,-1)
		
		self.W = self.m_ComplexPoly.m_UVSize[3]
		self.H = self.m_ComplexPoly.m_UVSize[4]
	end,
	SetPos = function(self,pos)
		self.m_Pos = Vector(pos)
	end,
	GetPos = function(self)
		if IsValid(self.m_Parent) then
			if self.m_ParentBone then
				local m = self.m_Parent:GetBoneMatrix(isstring(self.m_ParentBone) and (self.m_Parent:LookupBone(self.m_ParentBone) or 0) or self.m_ParentBone)
				
				if m then
					local pos,_ = LocalToWorld(self:GetLocalPos(),angle_zero,m:GetTranslation(),m:GetAngles())
				
					return pos
				else
					return self.m_Parent:LocalToWorld(self:GetLocalPos())
				end
			else
				return self.m_Parent:LocalToWorld(self:GetLocalPos())
			end
		else
			return Vector(self.m_Pos)
		end
	end,
	SetAngles = function(self,ang)
		self.m_Ang = Angle(ang)
	end,
	GetAngles = function(self)
		if IsValid(self.m_Parent) then
			if self.m_ParentBone then
				local m = self.m_Parent:GetBoneMatrix(isstring(self.m_ParentBone) and (self.m_Parent:LookupBone(self.m_ParentBone) or 0) or self.m_ParentBone)
				
				if m then
					local _,ang = LocalToWorld(vector_origin,self:GetLocalAngles(),m:GetTranslation(),m:GetAngles())
				
					return ang
				else
					return self.m_Parent:LocalToWorldAngles(self:GetLocalAngles())
				end
			else
				return self.m_Parent:LocalToWorldAngles(self:GetLocalAngles())
			end
		else
			return Angle(self.m_Ang)
		end
	end,
	SetParent = function(self,parent,bone)
		self.m_Parent = parent
		self.m_ParentBone = bone
	end,
	GetParent = function(self)
		return self.m_Parent
	end,
	SetLocalPos = function(self,lpos)
		self.m_LPos = lpos
	end,
	GetLocalPos = function(self)
		return Vector(self.m_LPos)
	end,
	SetLocalAngles = function(self,lang)
		self.m_LAng = lang
	end,
	GetLocalAngles = function(self)
		return Angle(self.m_LAng)
	end,
	Remove = function(self)
		if !self:IsValid() then return end
	
		self.m_Removed = true
	
		Trolleybus_System.Mirrors[self] = nil
		Trolleybus_System.MirrorIndeces[self.Index] = nil
	end,
	IsValid = function(self)
		return !self.m_Removed
	end,
	SetWidth = function(self,w)
		self.W = w
	end,
	SetHeight = function(self,h)
		self.H = h
	end,
	GetWidth = function(self)
		return self.W
	end,
	GetHeight = function(self)
		return self.H
	end,
	Draw = function(self)
		if self.DRAWING or !self.Texture then return end
		
		Trolleybus_System.MirrorMaterial:SetTexture("$basetexture",self.Texture)
		
		local pos,ang = self:GetPos(),self:GetAngles()
		
		if self.m_ComplexPoly then
			self.m_ComplexPoly:SetPos(pos)
			self.m_ComplexPoly:SetAngles(ang)
			self.m_ComplexPoly:SetMaterial(Trolleybus_System.MirrorMaterial)
			self.m_ComplexPoly:Draw(true)
		else
			local p = pos+ang:Up()*self.H/2+ang:Right()*self.W/2
			local w,h = self.TW,self.TH
			
			local a = Angle(ang)
			a:RotateAroundAxis(a:Up(),90)
			a:RotateAroundAxis(a:Forward(),90)
			
			cam.Start3D2D(p,a,self.W/w)
			
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Trolleybus_System.MirrorMaterial)
				surface.DrawTexturedRectUV(0,0,w,h,0,1,1,0)
			
			cam.End3D2D()
		end
	end,
	Update = function(self)
		local W,H = ScrW(),ScrH()
		local w,h = self.W,self.H
		local mp = w/h>W/H and W/w or H/h
		
		w = w*mp
		h = h*mp
		
		self.TW = w
		self.TH = h
		self.Texture = GetRenderTarget("Trolleybus_System_Mirror"..self.Index.."_"..W.."x"..H,W*MIRROR_TEXTURE_SCALE,H*MIRROR_TEXTURE_SCALE)
		
		local fpos = Trolleybus_System.EyePos()
		local pos = self:GetPos()
		
		local ang = (fpos-pos):Angle()
		ang:Normalize()
		ang:RotateAroundAxis(self:GetAngles():Forward(),180)
		
		local fov = math.deg(math.atan((w+h)/2/fpos:Distance(pos)))
		
		render.PushRenderTarget(self.Texture)
			self.DRAWING = true
			Trolleybus_System._RenderedMirror = self.Index
			
			render.RenderView({
				x = 0,y = 0,
				w = W*MIRROR_TEXTURE_SCALE,h = H*MIRROR_TEXTURE_SCALE,
				origin = self:GetPos(),
				angles = ang,
				aspectratio = w/h,
				drawviewmodel = false,
				fov = fov*0.5,
				zfar = 5000,
				dopostprocess = false,
			})
			
			Trolleybus_System.PixVisUHandle_PostRenderView()
			Trolleybus_System._RenderedMirror = nil
			self.DRAWING = false
		
		render.PopRenderTarget()
	end,
	ShouldDraw = function(self)
		if !self:IsValid() or !self.W or !self.H then return false end
		if Trolleybus_System.EyePos():Distance(self:GetPos())>self.Distance then return false end
		if (Trolleybus_System.EyePos()-self:GetPos()):GetNormalized():Dot(self:GetAngles():Forward())<=0 then return false end
		
		local p,a = self:GetPos(),self:GetAngles()
		local r,u = a:Right(),a:Up()
		local w,h = self.W/2,self.H/2
		
		cam.Start3D(Trolleybus_System.EyePos(),Trolleybus_System.EyeAngles(),Trolleybus_System.EyeFOV())
		
		local p1 = (p+u*h+r*w):ToScreen()
		local p2 = (p+u*h-r*w):ToScreen()
		local p3 = (p-u*h+r*w):ToScreen()
		local p4 = (p-u*h-r*w):ToScreen()
		
		cam.End3D()
		
		local minx = math.min(p1.x,p2.x,p3.x,p4.x)
		local maxx = math.max(p1.x,p2.x,p3.x,p4.x)
		local miny = math.min(p1.y,p2.y,p3.y,p4.y)
		local maxy = math.max(p1.y,p2.y,p3.y,p4.y)
		
		if maxx<0 or maxy<0 then return false end
		
		local W,H = ScrW(),ScrH()
		
		if minx>W or miny>H then return false end
		
		return true
	end,
}

function Trolleybus_System.CreateMirror(...)
	local mirror = setmetatable({},{__index = MIRROR})
	mirror:Init(...)
	
	return mirror
end

local DrawLocalPlayer = false
hook.Add("ShouldDrawLocalPlayer","Trolleybus_System.Mirrors",function(ply)
	if DrawLocalPlayer then
		return DrawLocalPlayer
	end
end)

local LastUpdate = RealTime()
local ResetingView = false
hook.Add("PostRender","Trolleybus_System.Mirrors",function()
	local rendermirrors = Trolleybus_System.GetPlayerSetting("RenderMirrors")
	if rendermirrors==1 then return end
	
	local bus
	if rendermirrors==2 then
		local veh = LocalPlayer():GetVehicle()
		bus = IsValid(veh) and Trolleybus_System.GetSeatTrolleybus(veh)

		if !bus then return end
	end

	local time = RealTime()
	if time-LastUpdate<Trolleybus_System.GetPlayerSetting("MirrorsUpdateTime")/1000 then return end
	LastUpdate = time

	local started = false
	
	for k,v in pairs(Trolleybus_System.Mirrors) do
		if !k:ShouldDraw() or rendermirrors==2 and k.Trolleybus!=bus then continue end
	
		if !started then
			started = true
			render.CopyRenderTargetToTexture(copytex)
		
			DrawLocalPlayer = true
			cam.Start3D()
		end
		
		k:Update()
	end
	
	if started then
		DrawLocalPlayer = false
		cam.End3D()
		
		cam.Start3D()
			Trolleybus_System._RenderedMirror = -1
			ResetingView = true
			
			render.RenderView({
				x = 0,y = 0,
				w = 0,h = 0,
				znear = 0,zfar = 0,
				origin = Trolleybus_System.EyePos(),
				angles = Trolleybus_System.EyeAngles(),
				drawviewmodel = true,
				fov = 0,
				dopostprocess = false,
			})
			
			ResetingView = false
			Trolleybus_System.PixVisUHandle_PostRenderView()
			Trolleybus_System._RenderedMirror = nil
			
			copymat:SetTexture("$basetexture",copytex)
		
			render.SetMaterial(copymat)
			render.DrawScreenQuad()
		cam.End3D()
	end
end)

hook.Add("PreRender","Trolleybus_System.Mirrors",function()
	if ResetingView then
		return true
	end
end)

hook.Add("PostDrawOpaqueRenderables","Trolleybus_System.Mirrors",function()
	local rendermirrors = Trolleybus_System.GetPlayerSetting("RenderMirrors")
	if rendermirrors==1 then return end
	
	local bus
	if rendermirrors==2 then
		local veh = LocalPlayer():GetVehicle()
		bus = IsValid(veh) and Trolleybus_System.GetSeatTrolleybus(veh)

		if !bus then return end
	end

	for k,v in pairs(Trolleybus_System.Mirrors) do
		if !k:ShouldDraw() or rendermirrors==2 and k.Trolleybus!=bus then continue end
		
		k:Draw()
	end
end)