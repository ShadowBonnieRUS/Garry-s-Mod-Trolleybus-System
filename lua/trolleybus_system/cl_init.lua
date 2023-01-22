-- Copyright © Platunov I. M., 2020 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase

Trolleybus_System.TargetButtonData = Trolleybus_System.TargetButtonData or {}

local ANG_RIGHT = Angle(0,-90,0)
local COLOR_ORANGE = Color(255,150,0)
local COLOR_RED = Color(255,0,0)
local COLOR_GREEN = Color(0,255,0)
local COLOR_YELLOW = Color(255,255,0)
local COLOR_PURPLE = Color(200,0,200)
local COLORA_ORANGE = ColorAlpha(COLOR_ORANGE,150)
local COLORA_RED = ColorAlpha(COLOR_RED,150)
local COLORA_GREEN = ColorAlpha(COLOR_GREEN,150)
local COLORA_YELLOW = ColorAlpha(COLOR_YELLOW,150)
local COLORA_PURPLE = ColorAlpha(COLOR_PURPLE,150)

local function DrawSprite(self,pos,size,color,alpha,tab,index)
	tab[index] = tab[index] or Trolleybus_System.CreatePixVisUHandle()
	
	local pos = self:LocalToWorld(pos)
	alpha = tab[index]:PixelVisible(pos,1)*alpha
	
	render.DrawSprite(pos,size,size,Color(color.r,color.g,color.b,alpha))
end

function Trolleybus_System.GetNearestButtonPanel(self,nameplate)
	local btn,clent,pnl,x,y
	
	local eyepos,eyedir = Trolleybus_System.EyePos(),Trolleybus_System.EyeVector()
	local selfpos,selfang = self:GetPos(),self:GetAngles()
	local dist

	local pnlcache = {}
	local function GetPanelData(panel)
		if pnlcache[panel]==nil then
			local dt = self.m_PanelsData[panel]
			local result = false
			
			if dt then
				local pos,ang = LocalToWorld(dt.pos,dt.ang,selfpos,selfang)
				local hitpos = util.IntersectRayWithPlane(eyepos,eyedir,pos,ang:Forward())
				
				if hitpos then
					local lpos = WorldToLocal(hitpos,angle_zero,pos,ang)
					local _x,_y = lpos.y,-lpos.z
					
					if _x<=dt.size[1] and _x>=0 and _y<=dt.size[2] and _y>=0 then
						result = {x = _x,y = _y,dist = hitpos:DistToSqr(eyepos)}
					end
				end
			end
			
			pnlcache[panel] = result
		end
		
		return pnlcache[panel] and (!dist or pnlcache[panel].dist<dist) and pnlcache[panel]
	end
	
	for k,v in pairs(self.m_ButtonsData) do
		if self:IsButtonDisabled(k) or Either(nameplate,!v.nameplatebtn,v.nameplatebtn) then continue end
		
		local dt = v.panel
		if !dt then continue end
		
		local panel = dt.name
		if !panel then continue end
		
		local pdt = GetPanelData(panel)
		if !pdt then continue end
		
		if dt.radius and math.Distance(pdt.x,pdt.y,dt.pos[1],dt.pos[2])<=dt.radius or dt.size and pdt.x>=dt.pos[1] and pdt.y>=dt.pos[2] and pdt.x<dt.pos[1]+dt.size[1] and pdt.y<dt.pos[2]+dt.size[2] then
			pnl,x,y,dist = panel,pdt.x,pdt.y,pdt.dist
			btn = k
		end
	end
	
	if !nameplate then
		for k,v in pairs(self.m_OtherPanelEntsData) do
			local dt = v.panel
			if !dt then continue end
			
			local panel = dt.name
			if !panel then continue end
			
			local pdt = GetPanelData(panel)
			if !pdt then continue end

			if dt.radius and math.Distance(pdt.x,pdt.y,dt.pos[1],dt.pos[2])<=dt.radius or dt.size and pdt.x>=dt.pos[1] and pdt.y>=dt.pos[2] and pdt.x<dt.pos[1]+dt.size[1] and pdt.y<dt.pos[2]+dt.size[2] then
				pnl,x,y,dist = panel,pdt.x,pdt.y,pdt.dist
				btn,clent = nil,k
			end
		end
	end

	if !pnl then
		for k,v in pairs(self.m_PanelsData) do
			local pdt = GetPanelData(k)
			if !pdt then continue end

			pnl,x,y,dist = k,pdt.x,pdt.y,pdt.dist
		end
	end
	
	return btn,clent,pnl,x,y
end

function Trolleybus_System.UpdateTargetButtonData()
	local lp = LocalPlayer()
	local dt = Trolleybus_System.TargetButtonData
	local wep = !lp:InVehicle() and lp:GetActiveWeapon()
	wep = IsValid(wep) and wep:GetClass()=="trolleybus_clicker" and wep
	
	local bus,btn,clent,pnl,x,y
	
	if wep then
		bus = wep:GetTrolleybus()
	else
		local veh = lp:GetVehicle()
		
		if IsValid(veh) then
			bus = Trolleybus_System.GetSeatTrolleybus(veh)
		end
	end
	
	if IsValid(bus) then
		btn,clent,pnl,x,y = Trolleybus_System.GetNearestButtonPanel(bus,wep and wep:GetNameplateState())
	end
	
	if dt.bus!=bus or dt.button!=btn or dt.x!=x or dt.y!=y then
		dt.send = {FrameNumber(),bus,btn,x,y}
	end
	
	local ResendTime = 0.25
	if dt.send and dt.servertick!=dt.send[1] and (!dt.lastsend or dt.lastsend[1]!=dt.send[1] or CurTime()-dt.lastsend[2]>ResendTime) then
		net.Start("TrolleybusSystem_Buttons",true)
			net.WriteUInt(dt.send[1],32)
			net.WriteEntity(dt.send[2] or NULL)
			net.WriteBool(tobool(dt.send[3]))
			if dt.send[3] then net.WriteString(dt.send[3]) end
			net.WriteBool(tobool(dt.send[4]))
			if dt.send[4] then net.WriteFloat(dt.send[4]) end
			net.WriteBool(tobool(dt.send[5]))
			if dt.send[5] then net.WriteFloat(dt.send[5]) end
		net.SendToServer()
		
		dt.lastsend = {dt.send[1],CurTime()}
	end
	
	dt.bus = bus
	dt.button = btn
	dt.panel = pnl
	dt.otherent = clent
	dt.x = x
	dt.y = y
end

function Trolleybus_System.DrawHUDSelectorData()
	local ply = LocalPlayer()
	local w,h = ScrW(),ScrH()
	local dt = Trolleybus_System.TargetButtonData
	
	local pressed = ply:KeyDown(IN_ATTACK) and !Trolleybus_System.IsControlButtonDown("mousesteer") and !Trolleybus_System.IsControlButtonDown("viewmove")
	
	surface.SetDrawColor(dt.button and Color(255,pressed and 0 or 255,0) or color_white)
	surface.DrawLine(w/2-7,h/2,w/2+7,h/2)
	surface.DrawLine(w/2,h/2-7,w/2,h/2+7)
	
	local bus = dt.bus
	if !IsValid(bus) then return end
	
	local texty = h/2+20
	local round = 5
	
	if dt.button then
		local cfg = bus.m_ButtonsData[dt.button]
		local text = L(cfg.dynamicname and cfg.dynamicname(bus) or cfg.name) or dt.button
		local color = color_white
		
		if text[1]=="<" and text[#text]==">" then
			text = #text==2 and "???" or text:sub(2,#text-1)
			color = COLOR_RED
		end
		
		if cfg.hotkey then
			text = text.." "..L("buttons_hotkey",Trolleybus_System.ButtonsToString(Trolleybus_System.GetHotkeyButtons(bus,dt.button)))
		end
		
		surface.SetFont("DermaDefaultBold")
		local tw,th = surface.GetTextSize(text)
		
		draw.RoundedBox(round,w/2-tw/2-round,texty,round+tw+round,round+th+round,Color(0,0,0,150))
		draw.DrawText(text,"DermaDefaultBold",w/2,texty+round,color,1)
		
		texty = texty+round+th+round+5
	elseif dt.otherent then
		local cfg = bus.m_OtherPanelEntsData[dt.otherent]
		local text = L(cfg.dynamicname and cfg.dynamicname(bus) or cfg.name) or dt.otherent
		local color = color_white
		
		if text[1]=="<" and text[#text]==">" then
			text = #text==2 and "???" or text:sub(2,#text-1)
			color = COLOR_RED
		end
		
		surface.SetFont("DermaDefaultBold")
		local tw,th = surface.GetTextSize(text)
		
		draw.RoundedBox(round,w/2-tw/2-round,texty,round+tw+round,round+th+round,Color(0,0,0,150))
		draw.DrawText(text,"DermaDefaultBold",w/2,texty+round,color,1)
		
		texty = texty+round+th+round+5
	end
	
	if dt.panel and Trolleybus_System.GetPlayerSetting("DebugMode") then
		local text = "[Debug Info]\n"
		text = text.."\nPanel:  "..dt.panel
		text = text.."\nPos x:  "..math.Round(dt.x,2)
		text = text.."\nPos y:  "..math.Round(dt.y,2)
		
		if dt.button then
			text = text.."\nButton:  "..dt.button.." ("..(bus:ButtonIsDown(dt.button) and "Active" or "Not active")..")"
		elseif dt.otherent then
			text = text.."\nOther Ent:  "..dt.otherent
		end
		
		surface.SetFont("DermaDefaultBold")
		local tw,th = surface.GetTextSize(text)
		
		draw.RoundedBox(round,w/2-tw/2-round,texty,round+tw+round,round+th+round,Color(0,0,0,150))
		draw.DrawText(text,"DermaDefaultBold",w/2-tw/2,texty+round,color_white)
		
		texty = texty+round+th+round
	end
end

function Trolleybus_System:TrolleybusSystem_EyeDataUpdate(eyepos,eyeang,eyedir,eyefov)
	Trolleybus_System.UpdateTargetButtonData()
end

function Trolleybus_System.ElectricSpark(pos)
	local ef = EffectData()
	ef:SetOrigin(pos)
	ef:SetMagnitude(3)
	util.Effect("ElectricSpark",ef)
	
	sound.Play("ambient/energy/spark"..math.random(1,6)..".wav",pos,60)
	
	local light = DynamicLight(IsValid(LocalPlayer()) and LocalPlayer():EntIndex() or 0)
	light.pos = pos
	light.r = 150
	light.g = 150
	light.b = 255
	light.brightness = 7
	light.decay = 2000
	light.size = 500
	light.dietime = CurTime()+0.5
end

local mat = Material("color")
local mat_polecatcherwire = Material("cable/cable2")
local spritemat = Material("sprites/light_ignorez")

local function DrawRect(x,y,w,h)
	surface.SetTexture(0)
	surface.DrawPoly({
		{x = x,y = y},
		{x = x+w,y = y},
		{x = x+w,y = y+h},
		{x = x,y = y+h},
	})
end

local function DrawCircle(x,y,rad)
	surface.SetTexture(0)
	
	local seg = 16
	local ang = math.rad(360/seg)
	local t = {{x = x,y = y}}
	
	for i=0,seg do
		t[#t+1] = {x = x+math.sin(ang*i)*rad,y = y-math.cos(ang*i)*rad}
	end
	
	surface.DrawPoly(t)
end

local lastframe,lastinworldcheck,lastgetallents
local function DrawTrolleybusRenderables(depth,skybox,translucent)
	if skybox then return end
	
	local drawdist = Trolleybus_System.GetPlayerSetting("ContactWiresDrawDistance")
	local eyepos = EyePos()
	local LP = LocalPlayer()

	local frame = FrameNumber()
	local usecache = translucent and lastframe==frame
	lastframe = frame
	
	lastinworldcheck = usecache and lastinworldcheck or util.TraceLine({start = eyepos,endpos = eyepos,mask = MASK_NPCWORLDSTATIC}).Hit
	
	if !lastinworldcheck then
		render.SetMaterial(mat)
		render.SetBlend(1)
		
		local DrawScale = 5
		local tbdata = Trolleybus_System.TargetButtonData
		
		local debugdraw = translucent and Trolleybus_System.GetPlayerSetting("DebugMode")
		lastgetallents = usecache and lastgetallents or ents.GetAll()
		
		for _,self in ipairs(lastgetallents) do
			if self.IsTrolleybus then
				if !self.RenderClientEnts or !Trolleybus_System.IsEntityWasDrawnThisFrame(self,translucent) then continue end
				
				local selfpos,selfang = self:GetPos(),self:GetAngles()
				
				if debugdraw then
					for k,v in pairs(self.m_PanelsData) do
						local pos,ang = LocalToWorld(v.pos,v.ang,selfpos,selfang)
						ang:RotateAroundAxis(ang:Forward(),90)
						ang:RotateAroundAxis(-ang:Right(),90)
						
						cam.Start3D2D(pos,ang,1/DrawScale)
							surface.SetDrawColor(0,0,255,75)
							DrawRect(0,0,v.size[1]*DrawScale,v.size[2]*DrawScale)
						cam.End3D2D()
					end
				end
				
				for k,v in pairs(self.Buttons) do
					local cfg = v.Cfg
					local dt = cfg.panel
					local drawfunc = Either(translucent,dt.drawtranslucent,dt.draw)
					
					if !debugdraw and !drawfunc or cfg.model and !v.Ent then continue end
					
					local panel = self.m_PanelsData[v.Panel]
					local pos,ang = LocalToWorld(panel.pos,panel.ang,selfpos,selfang)
					
					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(-ang:Right(),90)
					
					local drawscale = dt.drawscale or DrawScale
					
					cam.Start3D2D(pos,ang,1/drawscale)
						local x = dt.radius and (dt.pos[1]-dt.radius)*drawscale or dt.pos[1]*drawscale
						local y = dt.radius and (dt.pos[2]-dt.radius)*drawscale or dt.pos[2]*drawscale
						
						local w = dt.radius and dt.radius*2*drawscale or dt.size and dt.size[1]*drawscale
						local h = dt.radius and w or dt.size and dt.size[2]*drawscale
						
						if drawfunc then
							drawfunc(self,drawscale,x,y,w,h)
						end
						
						if debugdraw then
							if self:IsButtonDisabled(k) then
								surface.SetDrawColor(128,128,128)
							else
								local pressed = LP:KeyDown(IN_ATTACK) and !Trolleybus_System.IsControlButtonDown("mousesteer") and !Trolleybus_System.IsControlButtonDown("viewmove")
								
								surface.SetDrawColor(tbdata.button==k and (pressed and COLORA_RED or COLORA_YELLOW) or COLORA_GREEN)
							end
							
							if dt.radius then
								DrawCircle(x+w/2,y+w/2,w/2)
							elseif dt.size then
								DrawRect(x,y,w,h)
							end
						end
					cam.End3D2D()
				end
				
				for k,v in pairs(self.OtherPanelEnts) do
					if !v.Ent then continue end
					
					local cfg = v.Cfg
					local dt = cfg.panel
					local drawfunc = Either(translucent,dt.draw2dtranslucent,dt.draw2d)
					
					if debugdraw or drawfunc then
						local panel = self.m_PanelsData[v.Panel]
						local pos,ang = LocalToWorld(panel.pos,panel.ang,selfpos,selfang)
						
						ang:RotateAroundAxis(ang:Forward(),90)
						ang:RotateAroundAxis(-ang:Right(),90)
						
						local drawscale = dt.drawscale or DrawScale
						
						cam.Start3D2D(pos,ang,1/drawscale)
							local x = dt.radius and (dt.pos[1]-dt.radius)*drawscale or dt.pos[1]*drawscale
							local y = dt.radius and (dt.pos[2]-dt.radius)*drawscale or dt.pos[2]*drawscale
							
							local w = dt.radius and dt.radius*2*drawscale or dt.size and dt.size[1]*drawscale
							local h = dt.radius and w or dt.size and dt.size[2]*drawscale
						
							if drawfunc then
								drawfunc(self,drawscale,x,y,w,h)
							end
							
							if debugdraw then
								surface.SetDrawColor(COLORA_PURPLE)
								
								if dt.radius then
									DrawCircle(x+w/2,y+w/2,w/2)
								elseif dt.size then
									DrawRect(x,y,w,h)
								end
							end
						cam.End3D2D()
					end
					
					local drawfunc = Either(translucent,cfg.drawtranslucent,cfg.draw)
					if drawfunc then drawfunc(self,v) end
				end
				
				if translucent then
					render.SetMaterial(spritemat)
					
					local turnlights = self:GetTurnSignalLights()
					if turnlights>0 then
						local turn = self:GetTurnSignal()
						local emergency = self:GetEmergencySignal()
					
						if (turn>0 or emergency) and Trolleybus_System.TurnSignalTickActive(self) then
							if (turn==1 or emergency) and #self.TurnSignalLeft>0 then
								local alpha = self.TurnSignalLeft.brightness*turnlights*255
							
								for k,v in ipairs(self.TurnSignalLeft) do
									DrawSprite(self,v.pos,v.size,COLOR_ORANGE,alpha,self.pix_viss.left,k)
								end
							end
							
							if (turn==2 or emergency) and #self.TurnSignalRight>0 then
								local alpha = self.TurnSignalRight.brightness*turnlights*255
							
								for k,v in ipairs(self.TurnSignalRight) do
									DrawSprite(self,v.pos,v.size,COLOR_ORANGE,alpha,self.pix_viss.right,k)
								end
							end
						end
					end
					
					local profilelights = self:GetProfileLights()
					if profilelights>0 and #self.ProfileLights>0 then
						local alpha = self.ProfileLights.brightness*profilelights*255
					
						for k,v in ipairs(self.ProfileLights) do
							if !v.active or v.active(self) then
								DrawSprite(self,v.pos,v.size,v.color,alpha,self.pix_viss.profile,k)
							end
						end
					end
					
					local headlights = self:GetHeadLights()
					if headlights>0 and self.HeadLights and #self.HeadLights>0 then
						local alpha = self.HeadLights.brightness*headlights*255
					
						for k,v in ipairs(self.HeadLights) do
							if !v.shouldbeactive or v.shouldbeactive(self) then
								DrawSprite(self,v.pos,v.size,v.color,alpha,self.pix_viss.head,k)
							end
						end
					end
					
					local roadtrainlights = self:GetRoadTrainLights()
					if roadtrainlights>0 and self.RoadTrainLights and #self.RoadTrainLights>0 then
						local alpha = self.RoadTrainLights.brightness*roadtrainlights*255
					
						for k,v in ipairs(self.RoadTrainLights) do
							DrawSprite(self,v.pos,v.size,v.color,alpha,self.pix_viss.roadtrain,k)
						end
					end
					
					local rearlight = self:GetRearLight()
					if rearlight>0 then
						local rear = self:GetRearLights()
						if rear>0 then
							if (rear==1 or rear==3) and #self.BrakeLights>0 then
								local alpha = self.BrakeLights.brightness*rearlight*255
							
								for k,v in ipairs(self.BrakeLights) do
									DrawSprite(self,v.pos,v.size,COLOR_RED,alpha,self.pix_viss.brake,k)
								end
							end
							
							if (rear==2 or rear==3) and #self.BackwardMoveLights>0 then
								local alpha = self.BackwardMoveLights.brightness*rearlight*255
							
								for k,v in ipairs(self.BackwardMoveLights) do
									DrawSprite(self,v.pos,v.size,color_white,alpha,self.pix_viss.backmove,k)
								end
							end
						end
					end
				end
			else
				local class = self:GetClass()

				if !translucent and class=="trolleybus_polecatcher" then
					if self:IsDormant() then continue end
					
					local bus = self:GetTrolleybus()
					
					if IsValid(bus) and bus.PolesData then
						local left = self:GetLeft()
						local dt = bus.PolesData[left and "Left" or "Right"]
						local endpos = dt.WheelPos
						
						if endpos then
							if bus.TrolleyPoleCatcherWirePos then
								endpos = LocalToWorld(bus.TrolleyPoleCatcherWirePos,angle_zero,dt.PolePos,dt.PoleAng)
							end
							
							local startpos = self:GetPos()
							local movingply = Entity(Trolleybus_System.NetworkSystem.GetNWVar(self,"MovingPly",0))
							local color = render.GetLightColor(startpos):ToColor()
							
							render.SetMaterial(mat_polecatcherwire)
							render.SetBlend(1)

							if IsValid(movingply) and movingply:IsPlayer() then
								local plypos = movingply:EyePos()+movingply:GetAimVector()*15
								
								if movingply!=LP then
									local m = movingply:GetBoneMatrix(movingply:LookupBone("ValveBiped.Bip01_R_Hand") or 0)
									
									if m then
										plypos = m:GetTranslation()+m:GetAngles():Forward()*3+m:GetAngles():Right()*2
									end
								end
								
								render.StartBeam(3)
									render.AddBeam(startpos,0.7,0,color)
									render.AddBeam(plypos,0.7,2.5,color)
									render.AddBeam(endpos,0.7,5,color)
								render.EndBeam()
							else
								local limits = bus.TrolleyPoleCatcherWiresLimits
								
								if limits then
									local center = limits.CenterPos+Vector(0,left and limits.CenterDist or -limits.CenterDist,0)
									local bmin,bmax = limits.BoundMin,limits.BoundMax
									
									local lstartpos = bus:WorldToLocal(startpos)
									local lendpos = bus:WorldToLocal(endpos)
									
									local deltah = lendpos.z-lstartpos.z
									local limit_deltah = limits.CenterPos.z-lstartpos.z
									local fr = limit_deltah/deltah
									
									local limitpos = lstartpos+(lendpos-lstartpos)*fr
									limitpos.x = math.Clamp(limitpos.x,center.x+bmin.x,center.x+bmax.x)
									limitpos.y = math.Clamp(limitpos.y,center.y+bmin.y,center.y+bmax.y)
									
									local wlimitpos = bus:LocalToWorld(limitpos)
									
									render.StartBeam(3)
										render.AddBeam(startpos,0.7,0,color)
										render.AddBeam(wlimitpos,0.7,2.5,color)
										render.AddBeam(endpos,0.7,5,color)
									render.EndBeam()
								else
									render.DrawBeam(startpos,endpos,0.7,0,5,color)
								end
							end
						end
					end
				elseif translucent and (class=="trolleybus_trafficlight" or class=="trolleybus_traffic_car") then
					if self.DrawSprites and Trolleybus_System.IsEntityWasDrawnThisFrame(self,translucent) then self:DrawSprites() end
				end
			end
		end
	end

	if translucent and Trolleybus_System.GetPlayerSetting("RouteDisplayEnabled") and Trolleybus_System.CanPressButtons(nil,LP) then
		local bus = Trolleybus_System.GetSeatTrolleybus(LP:GetVehicle())
		local data = Trolleybus_System.Routes.Routes[bus:GetRouteNum()]

		if data then
			for k,v in ipairs(data.Dirs) do
				for i=2,#v.Points do
					render.DrawLine(v.Points[i-1],v.Points[i],COLOR_GREEN,true)
				end

				if data.Circular and #v.Points>2 then
					render.DrawLine(v.Points[1],v.Points[#v.Points],COLOR_GREEN,true)
				end
			end
		end
	end
end

hook.Add("PostDrawOpaqueRenderables","Trolleybus_System",function(depth,skybox,sky3d)
	DrawTrolleybusRenderables(depth,sky3d and skybox,false)
end)

hook.Add("PostDrawTranslucentRenderables","Trolleybus_System",function(depth,skybox,sky3d)
	DrawTrolleybusRenderables(depth,sky3d and skybox,true)
end)

surface.CreateFont("Trolleybus_System.HUDFont",{
	font = "Arial",
	extended = true,
	size = 22,
})

local y
local function DrawText(text,color,x,_y)
	draw.SimpleTextOutlined(text,"Trolleybus_System.HUDFont",x or 20,_y or y,color,0,4,1,color_black)
	
	if !_y then y = y+25 end
end

hook.Add("HUDPaint","Trolleybus_System",function()
	local ply = LocalPlayer()
	local w,h = ScrW(),ScrH()
	
	if ply:InVehicle() and Trolleybus_System.CanPressButtons(nil,ply) then
		Trolleybus_System.DrawHUDSelectorData()
		
		if Trolleybus_System.GetPlayerSetting("DrawHUDInfo") then
			local bus = Trolleybus_System.GetSeatTrolleybus(ply:GetVehicle())
			local rstate = bus:GetReverseState()
			
			y = 150
			
			DrawText(L("HUD_Reverse",L(rstate==0 and "HUD_Reverse_Neutral" or rstate==1 and "HUD_Reverse_Forward" or "HUD_Reverse_Backward")),nil)
			DrawText(L("HUD_Handbrake",L(bus:GetHandbrakeActive() and "HUD_Handbrake_Active" or "HUD_Handbrake_NotActive")),bus:GetHandbrakeActive() and COLOR_GREEN or COLOR_RED)
			
			y = y+25
			
			DrawText(L("HUD_StartPedal",bus:GetStartPedal()),nil)
			DrawText(L("HUD_BrakePedal",bus:GetBrakePedal()),nil)
			
			y = y+25
			
			for k,v in pairs(bus.Systems) do
				if v.HUDPaint then v:HUDPaint(DrawText) end
			end
			
			y = y+25
			
			DrawText(L("HUD_Passengers",bus:GetPassCount(),bus.PassCapacity),nil)
			
			local pricep = bus:GetTrailer()
			
			if IsValid(pricep) and pricep.IsTrolleybus then
				DrawText(L("HUD_Passengers_Pricep",pricep:GetPassCount(),pricep.PassCapacity),nil)
			end
			
			y = y+25
			
			local polesbus = bus.HasPoles and bus or bus.IsTrailer and bus:GetTrolleybus() or bus:GetTrailer()
			
			if IsValid(polesbus) then
				for i=1,2 do
					local right = i==2
					local pstate = polesbus:GetPoleState(right)
					local voltage,positive

					if pstate==0 then
						voltage,positive = Trolleybus_System.ContactNetwork.GetContactWireVoltage(polesbus:GetPoleContactWire(right))
					end
					
					DrawText(L("HUD_Pole_"..(right and "Right" or "Left")),nil)
					
					local text =
						pstate==0 and L(voltage and voltage>0 and "HUD_Pole_Connected" or "HUD_Pole_NoElec",positive and "+" or "-") or
						pstate==1 and L"HUD_Pole_Flying" or
						pstate==2 and L"HUD_Pole_Downed" or
						pstate==3 and L"HUD_Pole_Controlled" or
						pstate==4 and L"HUD_Pole_Catched"
						
					local color = pstate==0 and (voltage and voltage>0 and COLOR_GREEN or COLOR_YELLOW) or COLOR_RED
					
					DrawText(" "..L("HUD_Pole_State",text),color)
					
					/*local tracks = Trolleybus_System.GetTracks()
					
					if pstate==0 and tracks[track] then
						local data = tracks[track]
						local switch = data.Switch
						
						if !data.ReversedSwitch then
							if !switch then
								for k,v in ipairs(data.Next) do
									if tracks[v] and tracks[v].Switch and !tracks[v].ReversedSwitch then
										switch = true
										break
									end
								end
							end
						
							if switch then
								local left = polesbus:GetSwitchDirLeft()
								local t = polesbus.PolesData and polesbus.PolesData[right and "Right" or "Left"]
							
								DrawText(" "..L("HUD_Pole_Switch",left and "<-" or "->",t and t.WheelPos and t.WheelPos:Distance(data.End[1])/Trolleybus_System.UnitsPerMeter or 0),COLOR_YELLOW)
							end
							if data.SwitchBase then
								local base = tracks[data.SwitchBase]
								
								if base and !base.ReversedSwitch then
									local left = base.Next[1]==track
									
									DrawText(" "..L("HUD_Pole_SwitchCompleted",left and "<-" or "->"),COLOR_GREEN)
								end
							end
						end
					end*/
					
					y = y+25
				end
			end
		end
	end
end)

local CameraViewPhysics
hook.Add("CalcVehicleView","Trolleybus_System",function(veh,ply,view)
	if ply:GetViewEntity()!=ply then return end
	
	local bus = Trolleybus_System.GetSeatTrolleybus(veh)
	if !IsValid(bus) or !bus.IsTrolleybus then return end
	
	local id = Trolleybus_System.NetworkSystem.GetNWVar(veh,"SeatID")
	if !id and !veh:GetThirdPersonMode() then return end
	
	local cdata = bus.CameraView
	local buspos,busang = bus:GetPos(),bus:GetAngles()
	
	if veh:GetThirdPersonMode() then
		view.drawviewer = true
	
		if Trolleybus_System.GetPlayerSetting("MirrorView") then
			if bus:WorldToLocalAngles(view.angles).y>0 then
				local left = cdata.MirrorLeft
				
				if isfunction(left) then
					view.origin,view.angles = left(bus)
				else
					view.origin,view.angles = LocalToWorld(cdata.MirrorLeft[1],cdata.MirrorLeft[2],buspos,busang)
				end
			else
				local right = cdata.MirrorRight
				
				if isfunction(right) then
					view.origin,view.angles = right(bus)
				else
					view.origin,view.angles = LocalToWorld(cdata.MirrorRight[1],cdata.MirrorRight[2],buspos,busang)
				end
			end
		else
			local dist = (1+veh:GetCameraDistance())/11
			local pos = bus:LocalToWorld(cdata.Pos)
			
			local tr = util.TraceHull({
				start = pos,
				endpos = pos-view.angles:Forward()*dist*cdata.MaxDistance,
				mins = Vector(-5,-5,-5),
				maxs = Vector(5,5,5),
				mask = MASK_NPCWORLDSTATIC,
			})
			
			
			view.origin = tr.HitPos
		end
	else
		local pos = id==-1 and cdata.DriverCameraPos or bus.OtherSeats[id].Camera
		if bus.ViewMoveOffset then pos = pos+bus.ViewMoveOffset end
	
		view.origin = bus:LocalToWorld(pos)
		
		if CameraViewPhysics then
			view.origin = view.origin+CameraViewPhysics.offset
		end
	end
	
	return view
end)

hook.Add("Think","Trolleybus_System.CameraViewPhysics",function()
	local ply = LocalPlayer()

	if ply:InVehicle() and Trolleybus_System.GetPlayerSetting("HeadMovingFromAcceleration") then
		local troll = Trolleybus_System.GetSeatTrolleybus(ply:GetVehicle())
		
		if IsValid(troll) and troll.IsTrolleybus then
			local curvel = troll:GetDriverSeatVelocity()
			
			local dt = FrameTime()
		
			CameraViewPhysics = CameraViewPhysics and CameraViewPhysics.bus==troll and CameraViewPhysics or {
				bus = troll,
				offset = Vector(),
				curvel = curvel,
			}
			
			if CameraViewPhysics.curvel!=curvel then
				local dir = curvel-CameraViewPhysics.curvel
				local len = dir:Length()
				local spd = 10*dt
				
				if len>spd then
					CameraViewPhysics.curvel = CameraViewPhysics.curvel+dir*spd
				else
					CameraViewPhysics.curvel = curvel
				end
			end
			
			CameraViewPhysics.offset = CameraViewPhysics.offset-(curvel-CameraViewPhysics.curvel)*dt
			
			local dir = -CameraViewPhysics.offset
			local len = dir:Length()
			local resetspd = 5*dt
			
			if len>resetspd then
				CameraViewPhysics.offset = CameraViewPhysics.offset+dir*resetspd
				
				local len = CameraViewPhysics.offset:Length()
				
				if len>7 then
					CameraViewPhysics.offset:Div(len)
					CameraViewPhysics.offset:Mul(7)
				end
			else
				CameraViewPhysics.offset = Vector()
			end
			
			return
		end
	end
	
	CameraViewPhysics = nil
end)

hook.Add("AdjustMouseSensitivity","Trolleybus_System",function(def)
	if Trolleybus_System.PlayerInDriverPlace(nil,LocalPlayer()) and Trolleybus_System.IsControlButtonDown("mousesteer") then
		return Trolleybus_System.GetPlayerSetting("SteerMouseSensitivityMult")/100
	end
end)

local NotifyShouldTransmitFix = {}
hook.Add("NotifyShouldTransmit","Trolleybus_System",function(ent,should)
	if !ent.NotifyShouldTransmit then return end

	if ent.IsTrolleybus or ent:GetClass()=="trolleybus_stop" or ent:GetClass()=="trolleybus_wheel" or ent:GetClass()=="trolleybus_traffic_car" or ent:GetClass()=="trolleybus_trafficlight" then
		if should and ent:GetPos()==vector_origin and ent:GetAngles()==angle_zero then
			table.insert(NotifyShouldTransmitFix,ent)
		else
			ent:NotifyShouldTransmit(should)
			
			if #NotifyShouldTransmitFix>0 then
				table.RemoveByValue(NotifyShouldTransmitFix,ent)
			end
		end
	end
end)

hook.Add("Think","Trolleybus_System.NotifyShouldTransmitFix",function()
	local ents = NotifyShouldTransmitFix

	if #ents>0 then
		NotifyShouldTransmitFix = {}
	
		for k,v in ipairs(ents) do
			v:NotifyShouldTransmit(true)
		end
	end
end)

hook.Add("UpdateAnimation","Trolleybus_System",function(ply,vel,maxseqgroundspeed)
	if ply:InVehicle() and (!ply:GetAllowWeaponsInVehicle() or !IsValid(ply:GetActiveWeapon())) then
		local seat = ply:GetVehicle()
		local seattype = Trolleybus_System.NetworkSystem.GetNWVar(seat,"SeatType")
		
		if seattype==1 then
			GAMEMODE:UpdateAnimation(ply,vel,maxseqgroundspeed)
			
			ply:SetPoseParameter("head_yaw",ply:EyeAngles().y)
			ply:SetPoseParameter("aim_yaw",ply:EyeAngles().y)
			
			return true
		end
	end
end)

net.Receive("TrolleybusSystem_Informators",function(len)
	Trolleybus_System.Informators = util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(32))))
end)

net.Receive("TrolleybusSystem_Buttons",function(len)
	local tick = net.ReadUInt(32)
	
	Trolleybus_System.TargetButtonData.servertick = tick
end)

net.Receive("TrolleybusSystem_ElecSpark",function(len)
	Trolleybus_System.ElectricSpark(net.ReadVector())
end)

Trolleybus_System.ReceiveMassiveData("Trolleybus_System.TrafficTracks",function(tracks)
	Trolleybus_System.TrafficTracks = tracks
end)

Trolleybus_System.ReceiveMassiveData("Trolleybus_System.TrafficTrackUpdate",function(data)
	Trolleybus_System.TrafficTracks[data.id] = data.track
end)