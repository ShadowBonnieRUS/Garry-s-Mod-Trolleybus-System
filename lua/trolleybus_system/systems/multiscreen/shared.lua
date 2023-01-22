-- Copyright © Platunov I. M., 2022 All rights reserved

if !SYSTEM then return end

SYSTEM.Screens = {}

function SYSTEM:Initialize()
	self.ScreensData = {}

	for k,v in pairs(self.Screens) do
		self:LoadScreen(k,v)
	end
end

function SYSTEM:Unload()
	self.Base.Unload(self)

	for k,v in pairs(self.Screens) do
		self:UnloadScreen(k)
	end
end

function SYSTEM:LoadScreen(name,data)
	local bus = self.Trolleybus
	local center = data.Pos-data.Ang:Right()*data.Size[1]/2-data.Ang:Up()*data.Size[2]/2

	local sdata sdata = {
		NW = setmetatable({},{__newindex = function(s,k,v)
			self:SetNWVar(name.."."..k,v)
		end,__index = function(s,k)
			return self:GetNWVar(name.."."..k)
		end}),
		Utils = {
			InBounds = function(x,y,fromx,fromy,tox,toy) return x and y and x>=fromx and y>=fromy and x<tox and y<toy end,
			InBounds2 = function(x,y,fromx,fromy,w,h) return x and y and x>=fromx and y>=fromy and x<fromx+w and y<fromy+h end,
			InRadius = function(x,y,cx,cy,radius) return x and y and (x-cx)^2+(y-cy)^2<radius*radius end,
			PlaySound = function(snd,dist,volume,prate)
				Trolleybus_System.PlayBassSound(bus,snd,dist or 100,volume or 1,nil,nil,center,prate or 1)
			end,
			DrawMat = function(x,y,w,h,mat,color,rotate)
				if w<0 then w = mat:Width()*-w end
				if h<0 then h = mat:Height()*-h end

				surface.SetDrawColor(color or color_white)
				surface.SetMaterial(mat)

				if rotate then
					surface.DrawTexturedRectRotated(x,y,w,h,rotate)
				else
					surface.DrawTexturedRect(x,y,w,h)
				end
			end,
			DrawText = function(text,font,x,y,color,alignx,aligny,scale,rotate)
				local m = Matrix()
				m:SetTranslation(Vector(x,y))
				if scale then m:SetScale(scale) end
				if rotate then m:SetAngles(Angle(0,rotate,0)) end

				cam.PushModelMatrix(m,true)
					draw.SimpleText(text,font,0,0,color,alignx,aligny)
				cam.PopModelMatrix()
			end,
		},
		Predefined = {
			Draw = function(name,x,y,pressed)
				local btndt = data.Predefined[name]
				if btndt then
					btndt.draw(bus,sdata,btndt.x,btndt.y,btndt.w,btndt.h,sdata.Predefined.State(name,x,y,pressed))
				end
			end,
			Press = function(name)
				local btndt = data.Predefined[name]
				if btndt then btndt.press(bus,sdata) end
			end,
			Think = function(name)
				local btndt = data.Predefined[name]
				if btndt then btndt.think(bus,sdata) end
			end,
			State = function(name,x,y,pressed)
				local btndt = data.Predefined[name]
				if btndt then
					return sdata.Utils.InBounds2(x,y,btndt.x,btndt.y,btndt.w,btndt.h) and (pressed and 2 or 1) or 0
				end
			end,
		},
	}
	self.ScreensData[name] = sdata

	local index = "MultiScreen."..name

	bus:AddDynamicPanel(index,{
		pos = data.Pos,
		ang = data.Ang,
		size = data.Size,
	})

	local scale = data.DrawScale or 1

	local function GetTargetInfo()
		local target = Trolleybus_System.TargetButtonData
		local x,y

		if target.bus==bus and target.panel==index and target.button==index then
			x,y = target.x,target.y

			if data.Scaled then x,y = x*scale,y*scale end
		end

		return x,y,x and LocalPlayer():KeyDown(IN_ATTACK)
	end

	bus:AddDynamicButton(index,{
		name = "MultiScreen - "..name,
		dynamicname = data.DisplayName and function(bus) return data.DisplayName(bus,sdata,GetTargetInfo()) end,
		panel = {
			name = index,
			pos = {0,0},
			size = data.Size,
			drawscale = scale,
			draw = function(bus,scale,x,y,w,h)
				local eyepos = Trolleybus_System.EyePos()

				if data.DrawDistance and eyepos:DistToSqr(bus:LocalToWorld(data.Pos))>data.DrawDistance*data.DrawDistance then
					return
				end

				render.SetStencilEnable(true)
					render.ClearStencil()

					render.SetStencilWriteMask(255)
					render.SetStencilTestMask(255)
					render.SetStencilReferenceValue(1)

					render.SetStencilCompareFunction(STENCIL_ALWAYS)
					render.SetStencilPassOperation(STENCIL_REPLACE)
					render.SetStencilFailOperation(STENCIL_KEEP)
					render.SetStencilZFailOperation(STENCIL_KEEP)

					surface.SetDrawColor(0,0,0)
					surface.DrawRect(0,0,w,h)

					render.SetStencilCompareFunction(STENCIL_EQUAL)
					render.SetStencilPassOperation(STENCIL_KEEP)

					if data.DrawScreen then
						local w,h = w,h
						if !data.Scaled then w,h = w/scale,h/scale end
						
						render.PushFilterMag(TEXFILTER.ANISOTROPIC)
						render.PushFilterMin(TEXFILTER.ANISOTROPIC)
						data.DrawScreen(bus,sdata,scale,w,h,GetTargetInfo())
						render.PopFilterMin()
						render.PopFilterMag()
					end

				render.SetStencilEnable(false)
			end,
		},
		onpressby = (data.OnReleased or data.OnPressed) and function(bus,ply,released)
			local func = Either(released,data.OnReleased,data.OnPressed)

			if func then
				local x = ply.TrolleybusButtons_lastx
				local y = ply.TrolleybusButtons_lasty
				if data.Scaled then x,y = x*scale,y*scale end

				func(bus,sdata,scale,x,y)
			end
		end,
		think = data.Think and function(bus,on)
			data.Think(bus,sdata)
		end,
		think_sv = data.Think and function(bus,on)
			data.Think(bus,sdata)
		end,
	})

	sdata.NW._Disabled = true

	if !data.ShouldBeDisabled then
		self:EnableScreen(name)
	end
end

function SYSTEM:UnloadScreen(name)
	local index = "MultiScreen."..name
	local bus = self.Trolleybus

	self.ScreensData[name] = nil

	bus:RemoveDynamicPanel(index)
	bus:RemoveDynamicButton(index)
end

function SYSTEM:IsScreenDisabled(name)
	return self.Screens[name] and self.ScreensData[name].NW._Disabled
end