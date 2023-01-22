-- Copyright © Platunov I. M., 2020 All rights reserved

function Trolleybus_System.BuildRotationPositions(p1,p2,ang,segments,curvature,invert)
	local t = {}
	local p = WorldToLocal(p2,angle_zero,p1,ang)
	
	for i=0,segments do
		local fr = i/segments
		local frx = invert and 1-(1-fr)^curvature or fr^curvature
		local fry = invert and fr^curvature or 1-(1-fr)^curvature
		
		local p = LocalToWorld(Vector(frx*p.x,fry*p.y,fr*p.z),angle_zero,p1,ang)
		
		table.insert(t,p)
	end
	
	return t
end

function Trolleybus_System.BuildNameplatePanel(ENT,index,pos,ang,w,h,type,font,font2,drawscale,glowcolor,glowonly)
	local paneldata = {
		pos = pos,
		ang = ang,
		size = {w,h},
	}
	
	glowcolor = glowcolor or Color(255,155,0)
	
	local function Next(t,cur)
		local prev = 0
		
		for k,v in pairs(t) do
			if prev==cur then
				return k
			end
			
			prev = k
		end
		
		return 0
	end
	
	local function Prev(t,cur)
		local prev = 0
		
		for k,v in pairs(t) do
			if k==cur then
				return prev
			end
			
			prev = k
		end
		
		return prev
	end
	
	local function ShouldGlow(self)
		local bus = self:GetMainTrolleybus()
		bus = IsValid(bus) and bus or self
	
		return bus:GetScheduleLight()>0
	end
	
	local function GetColor(self)
		return ShouldGlow(self) and glowcolor or color_black
	end
	
	local prevbtndata = {
		name = "nameplate_prev",
		panel = {
			name = index,
			pos = {0,0},
			size = {w/2,h},
			drawscale = drawscale,
			draw = function(self,scale,x,y,w,h)
				if glowonly and !ShouldGlow(self) then return end
				
				local w = w*2
			
				local num = self:GetRouteNum()
				local data = Trolleybus_System.Routes.Routes[num]
				local L = Trolleybus_System.GetLanguagePhrase
				local LN = Trolleybus_System.GetLanguagePhraseName
				local route = data and Trolleybus_System.Routes.GetRouteName(num) or ""
			
				if type==0 then
					draw.SimpleText(route,font,w/2,h/2,GetColor(self),1,1)
				elseif type==1 then
					draw.SimpleText(data and Trolleybus_System.Routes.GetRouteStart(num) or L"GoingToPark1",font,w/2,h/4,GetColor(self),1,1)
					draw.SimpleText(data and Trolleybus_System.Routes.GetRouteEnd(num) or L"GoingToPark2",font,w/2,h/4*3,GetColor(self),1,1)
				elseif type==2 then
					local w = w-h
				
					draw.SimpleText(route,font,h/2,h/2,GetColor(self),1,1)
					draw.SimpleText(data and Trolleybus_System.Routes.GetRouteStart(num) or L"GoingToPark1",font2,h+w/2,h/2,GetColor(self),1,4)
					draw.SimpleText(data and Trolleybus_System.Routes.GetRouteEnd(num) or L"GoingToPark2",font2,h+w/2,h/2,GetColor(self),1,0)
				end
			end,
		},
		func = function(self,on)
			if on then
				local num = tonumber(Prev(Trolleybus_System.Routes.Routes,self:GetRouteNum())) or 0
				self:SetRouteNum(num)

				local otherbus = self.IsTrailer and self:GetTrolleybus() or self:GetTrailer()
				if IsValid(otherbus) then
					otherbus:SetRouteNum(num)
				end
			end
		end,
	}
	
	local nextbtndata = {
		name = "nameplate_next",
		panel = {
			name = index,
			pos = {w/2,0},
			size = {w/2,h},
		},
		func = function(self,on)
			if on then
				local num = tonumber(Next(Trolleybus_System.Routes.Routes,self:GetRouteNum())) or 0
				self:SetRouteNum(num)

				local otherbus = self.IsTrailer and self:GetTrolleybus() or self:GetTrailer()
				if IsValid(otherbus) then
					otherbus:SetRouteNum(num)
				end
			end
		end,
	}
	
	if istable(ENT) then
		ENT.PanelsData[index] = paneldata
		ENT.ButtonsData[index.."_prev"] = prevbtndata
		ENT.ButtonsData[index.."_next"] = nextbtndata
	elseif isentity(ENT) then
		ENT:AddDynamicPanel(index,paneldata)
		ENT:AddDynamicButton(index.."_prev",prevbtndata)
		ENT:AddDynamicButton(index.."_next",nextbtndata)
		
		return function()
			ENT:RemoveDynamicPanel(index)
			ENT:RemoveDynamicButton(index.."_prev")
			ENT:RemoveDynamicButton(index.."_next")
		end
	end
end

function Trolleybus_System.BuildDialGauge(ENT,index,name,panel,x,y,radius,startang,addang,model,offsetang,offsetpos,scale,color,skin,bg)
	local data = {
		name = name,
		model = model or "models/trolleybus/strspeed.mdl",
		panel = {
			name = panel,
			pos = {x,y},
			radius = radius,
		},
		offset_ang = offsetang or Angle(90,0,0),
		offset_pos = offsetpos,
		initialize = function(self,ent)
			if scale then ent:SetModelScale(scale) end
			if color then ent:SetColor(color) ent:SetRenderMode(RENDERMODE_TRANSCOLOR) end
			if skin then ent:SetSkin(skin) end
			if bg then ent:SetBodyGroups(bg) end
		
			local ang = ent:GetLocalAngles()
			ang:RotateAroundAxis(ang:Up(),startang)
			ent:SetLocalAngles(ang)
			ent.startang = ang
			
			local curang = addang(self,ent)
			
			hook.Add("Think",ent,function(s)
				local actang = addang(self,ent)
				local diff = math.NormalizeAngle(actang-curang)
				
				curang = curang+diff*math.Clamp(FrameTime()*10,0,1)
				
				local ang = Angle(s.startang)
				ang:RotateAroundAxis(ang:Up(),curang)
				
				s:SetLocalAngles(ang)
			end)
		end,
		maxdrawdistance = 200,
	}
	
	if istable(ENT) then
		ENT.OtherPanelEntsData[index] = data
	elseif isentity(ENT) then
		ENT:AddDynamicOtherPanelEnt(index,data)
		
		return function() ENT:RemoveDynamicOtherPanelEnt(index) end
	end
end

function Trolleybus_System.BuildMultiButton(ENT,index,panel,leftname,rightname,model,x,y,w,h,posestatefunc,onleft,onright,reset,lefthotkey,righthotkey,leftmax,rightmax,leftexternalkey,rightexternalkey,vertical)
	leftmax = leftmax or -1
	rightmax = rightmax or 1

	ENT.ButtonsData[index.."_left"] = {
		name = leftname,
		panel = {
			name = panel,
			pos = {x,y},
			size = {vertical and w or w/2,vertical and h/2 or h},
		},
		hotkey = lefthotkey,
		externalhotkey = leftexternalkey,
		func = function(self,on)
			if reset and self:ButtonIsDown(index.."_right") then return end
		
			if on then
				local state = self:GetNWVar("MultiBtns."..index,0)
			
				if state>leftmax then
					local val = onleft and onleft(self,on,state-1)
					
					if val!=false then
						self:SetNWVar("MultiBtns."..index,state-1)
					end
				end
			elseif reset then
				local val = onleft and onleft(self,on,0)
				
				if val!=false then
					self:SetNWVar("MultiBtns."..index,0)
				end
			end
		end,
	}
	
	ENT.ButtonsData[index.."_right"] = {
		name = rightname,
		panel = {
			name = panel,
			pos = {vertical and x or x+w/2,vertical and y+h/2 or y},
			size = {vertical and w or w/2,vertical and h/2 or h},
		},
		hotkey = righthotkey,
		externalhotkey = rightexternalkey,
		func = function(self,on)
			if reset and self:ButtonIsDown(index.."_left") then return end
			
			if on then
				local state = self:GetNWVar("MultiBtns."..index,0)
			
				if state<rightmax then
					local onright = onright==true and onleft or onright
					local val = onright and onright(self,on,state+1)
					
					if val!=false then
						self:SetNWVar("MultiBtns."..index,state+1)
					end
				end
			elseif reset then
				local onright = onright==true and onleft or onright
				local val = onright and onright(self,on,0)
				
				if val!=false then
					self:SetNWVar("MultiBtns."..index,0)
				end
			end
		end,
	}
	
	ENT.OtherPanelEntsData[index] = {
		name = "",
		model = model.model,
		panel = {
			name = panel,
			pos = {x+w/2,y+h/2},
			radius = 0,
		},
		offset_ang = model.offset_ang,
		offset_pos = model.offset_pos,
		maxdrawdistance = model.maxdrawdistance,
		initialize = function(self,ent)
			ent.State = posestatefunc(self,ent,self:GetNWVar("MultiBtns."..index,0))
			ent.MoveState = ent.State
			
			if model.anim then
				ent:SetCycle(ent.MoveState)
			else
				ent:SetPoseParameter(model.poseparameter,ent.MoveState)
			end
			
			if model.initialize then model.initialize(self,ent) end
		end,
		think = function(self,ent)
			local bstate = self:GetNWVar("MultiBtns."..index,0)
			local state = posestatefunc(self,ent,bstate)
			
			if ent.State!=state then
				self:ProcessCfgSound(ent,model.sounds,bstate!=0)
				ent.State = state
			end
			
			if ent.MoveState!=state then
				if state>ent.MoveState then
					ent.MoveState = math.min(state,ent.MoveState+self.DeltaTime*5)
				else
					ent.MoveState = math.max(state,ent.MoveState-self.DeltaTime*5)
				end
				
				if model.anim then
					ent:SetCycle(ent.MoveState)
				else
					ent:SetPoseParameter(model.poseparameter,ent.MoveState)
				end
			end
			
			if model.think then model.think(self,ent) end
		end,
	}
end

function Trolleybus_System.BuildReverseButton(ENT,index,panel,leftname,middlename,rightname,model,x,y,w,h,lefthotkey,mainhotkey,righthotkey,customfunc)
	ENT.ButtonsData[index.."_left"] = {
		name = leftname,
		panel = {
			name = panel,
			pos = {x,y},
			size = {w/3,h},
		},
		hotkey = lefthotkey,
		func = function(self,on)
			if on and self:GetNWVar("ReverseData.Active."..index,false) then
				local state = self:GetNWVar("ReverseState."..index,0)
			
				if state>-1 and (customfunc and customfunc(self,state-1) or !customfunc and self:ChangeReverse(state-1)) then
					self:SetNWVar("ReverseState."..index,state-1)
				end
			end
		end,
	}
	
	ENT.ButtonsData[index] = {
		name = middlename,
		panel = {
			name = panel,
			pos = {x+w/3,y},
			size = {w/3,h},
		},
		hotkey = mainhotkey,
		onpressby = function(self,ply,released)
			if !released then
				if self:GetNWVar("ReverseData.Active."..index,false) then
					if !ply:HasWeapon("trolleybus_clicker") or !ply:GetWeapon("trolleybus_clicker"):GetReverse() then
						local wep = ply:HasWeapon("trolleybus_clicker") and ply:GetWeapon("trolleybus_clicker") or ply:Give("trolleybus_clicker")
						wep:SetReverse(true)
						wep:SetReverseNumber(self:GetNWVar("ReverseData.Number."..index,0))
						wep:SetReverseType(self:GetNWVar("ReverseData.Type."..index,0))
						wep.IsReverseOwner = self["ReverseData.Owner."..index]==ply
						
						self:SetNWVar("ReverseData.Active."..index,false)
					elseif !Trolleybus_System.GetAdminSetting("trolleybus_remove_reverse") then
						self:SetNWVar("ReverseData.Active."..index,false)
					end
				else
					if ply:HasWeapon("trolleybus_clicker") and ply:GetWeapon("trolleybus_clicker"):GetReverse() then
						local wep = ply:GetWeapon("trolleybus_clicker")
						
						if Trolleybus_System.GetAdminSetting("trolleybus_remove_reverse") then
							wep:SetReverse(false)
						end
						
						self:SetNWVar("ReverseData.Active."..index,true)
						self:SetNWVar("ReverseData.Number."..index,wep:GetReverseNumber())
						self:SetNWVar("ReverseData.Type."..index,wep:GetReverseType())
						self["ReverseData.Owner."..index] = ply
					end
				end
			end
		end,
	}
	
	ENT.ButtonsData[index.."_right"] = {
		name = rightname,
		panel = {
			name = panel,
			pos = {x+w/3*2,y},
			size = {w/3,h},
		},
		hotkey = righthotkey,
		func = function(self,on)
			if on and self:GetNWVar("ReverseData.Active."..index,false) then
				local state = self:GetNWVar("ReverseState."..index,0)
			
				if state<1 and (customfunc and customfunc(self,state+1) or !customfunc and self:ChangeReverse(state+1)) then
					self:SetNWVar("ReverseState."..index,state+1)
				end
			end
		end,
	}
	
	ENT.OtherPanelEntsData[index] = {
		name = "",
		model = "models/trolleybus/reverse/reverse.mdl",
		panel = {
			name = panel,
			pos = {x+w/2,y+h/2},
			radius = 0,
		},
		offset_ang = model.offset_ang,
		offset_pos = model.offset_pos,
		maxdrawdistance = model.maxdrawdistance,
		initialize = function(self,ent)
			if model.initialize then model.initialize(self,ent) end
			
			ent.State = self:GetNWVar("ReverseState."..index,0)
			ent.MoveState = ent.State
			
			ent.SetupReverse = function(ent,init)
				local active = self:GetNWVar("ReverseData.Active."..index,false)
				local number = self:GetNWVar("ReverseData.Number."..index,0)
				local type = self:GetNWVar("ReverseData.Type."..index,0)
				
				if active!=ent.Active then
					ent.Active = active
					
					if !init then self:ProcessCfgSound(ent,model.reversesounds,active) end
				end
				
				ent:SetPoseParameter(model.poseparameter,ent.MoveState)
				ent:SetNoDraw(!active)
				
				if ent.Number!=number then
					ent.Number = number
				
					local dig1 = math.floor(number/100)%10
					local dig2 = math.floor(number/10)%10
					local dig3 = math.floor(number)%10
					
					ent:SetBodygroup(1,dig1)
					ent:SetBodygroup(2,dig2)
					ent:SetBodygroup(3,dig3)
				end
				
				if ent.ReverseType!=type then
					ent.ReverseType = type
					ent:SetSkin(type)
				end
			end
			
			ent:SetupReverse(true)
		end,
		think = function(self,ent)
			if model.think then model.think(self,ent) end
			
			local state = self:GetNWVar("ReverseState."..index,0)
			
			if ent.State!=state then
				self:ProcessCfgSound(ent,model.sounds,state>ent.State)
				ent.State = state
			end
			
			if ent.MoveState!=state then
				if state>ent.MoveState then
					ent.MoveState = math.min(state,ent.MoveState+self.DeltaTime*5)
				else
					ent.MoveState = math.max(state,ent.MoveState-self.DeltaTime*5)
				end
			end
			
			if ent.SetupReverse then
				ent:SetupReverse()
			end
		end,
	}
end

function Trolleybus_System.BuildInteriorNameplate(ENT,index,pos,ang,w,h,gettext,font,speed,color,scale)
	local paneldata = {
		pos = pos,
		ang = ang,
		size = {w,h},
	}
	
	local btndata = {
		name = "",
		panel = {
			name = index,
			pos = {0,0},
			radius = 0,
			drawscale = scale,
			draw = function(self,scale,x,y,_w,_h)
				local data = self.Buttons[index]
			
				if !data.text then
					surface.SetDrawColor(0,0,0)
					surface.DrawRect(x,y,w*scale,h*scale)
					
					return
				end
			
				render.ClearStencil()
				
				render.SetStencilEnable(true)
					
					render.SetStencilWriteMask(255)
					render.SetStencilTestMask(255)
					render.SetStencilReferenceValue(1)
					
					render.SetStencilCompareFunction(STENCIL_ALWAYS)
					render.SetStencilPassOperation(STENCIL_REPLACE)
					render.SetStencilFailOperation(STENCIL_KEEP)
					render.SetStencilZFailOperation(STENCIL_KEEP)
					
						surface.SetDrawColor(0,0,0)
						surface.DrawRect(x,y,w*scale,h*scale)
					
					render.SetStencilCompareFunction(STENCIL_EQUAL)
					render.SetStencilPassOperation(STENCIL_KEEP)
					
						draw.SimpleText(data.text,font,data.textpos,h*scale/2,color,2,1)
					
				render.SetStencilEnable(false)
			end,
		},
		think = function(self,state)
			local text = gettext(self)
			local data = self.Buttons[index]
			
			if !text then
				data.text = nil
				
				return
			end
			
			surface.SetFont(font)
			local tw,th = surface.GetTextSize(text)
			
			if data.text!=text or data.textpos<=0 then
				data.textpos = w*scale+tw
				data.text = text
			else
				data.textpos = data.textpos-speed*self.DeltaTime
			end
		end,
	}
	
	if istable(ENT) then
		ENT.PanelsData[index] = paneldata
		ENT.ButtonsData[index] = btndata
	elseif isentity(ENT) then
		ENT:AddDynamicPanel(index,paneldata)
		ENT:AddDynamicButton(index,btndata)
		
		return function()
			ENT:RemoveDynamicPanel(index)
			ENT:RemoveDynamicButton(index)
		end
	end
end

function Trolleybus_System.BuildMovingMirror(ENT,index,pos,ang,w,h,model,mpos,mang,handlebone,mirrorbone,lpos,lang,mw,mh,handlepitch,mirrorpitch,hymin,hymax,mymin,mymax,hpmin,hpmax,mpmin,mpmax,mverts,hdefy,mdefy,hdefp,mdefp)
	hdefp,hdefy,mdefp,mdefy = hdefp or 0,hdefy or 0,mdefp or 0,mdefy or 0
	
	ENT.PanelsData[index] = {
		pos = pos,
		ang = ang,
		size = {w,h},
	}
	
	ENT.ButtonsData[index] = {
		dynamicname = function(self)
			local dt = Trolleybus_System.TargetButtonData
			local x,y = dt.x,dt.y
			
			if y>h/2 then
				if handlepitch then
					if x>w/2 then
						return y>h/4*3 and "mirrormove_handledown" or "mirrormove_handleup"
					else
						return x>w/4 and "mirrormove_handleright" or "mirrormove_handleleft"
					end
				else
					return x>w/2 and "mirrormove_handleright" or "mirrormove_handleleft"
				end
			else
				if mirrorpitch then
					if x>w/2 then
						return y>h/4 and "mirrormove_mirrordown" or "mirrormove_mirrorup"
					else
						return x>w/4 and "mirrormove_mirrorright" or "mirrormove_mirrorleft"
					end
				else
					return x>w/2 and "mirrormove_mirrorright" or "mirrormove_mirrorleft"
				end
			end
		end,
		panel = {
			name = index,
			pos = {0,0},
			size = {w,h},
			drawscale = 20,
			drawtranslucent = function(self,ds,_x,_y,_w,_h)
				local dt = Trolleybus_System.TargetButtonData
				if dt.bus!=self or dt.button!=index then return end
				
				local x,y = dt.x,dt.y
				
				surface.SetDrawColor(0,0,0,150)
				surface.DrawRect(0,0,_w,_h)
				
				if LocalPlayer():KeyDown(IN_ATTACK) and !Trolleybus_System.IsControlButtonDown("mousesteer") and !Trolleybus_System.IsControlButtonDown("viewmove") then
					surface.SetDrawColor(200,255,0,150)
				else
					surface.SetDrawColor(100,255,0,150)
				end
				
				if y>h/2 then
					if handlepitch then
						if x>w/2 then
							if y>h/4*3 then
								surface.DrawRect(_w/2,_h/4*3,_w/2,_h/4)
							else
								surface.DrawRect(_w/2,_h/2,_w/2,_h/4)
							end
						else
							if x>w/4 then
								surface.DrawRect(_w/4,_h/2,_w/4,_h/2)
							else
								surface.DrawRect(0,_h/2,_w/4,_h/2)
							end
						end
					else
						if x>w/2 then
							surface.DrawRect(_w/2,_h/2,_w/2,_h/2)
						else
							surface.DrawRect(0,_h/2,_w/2,_h/2)
						end
					end
				else
					if mirrorpitch then
						if x>w/2 then
							if y>h/4 then
								surface.DrawRect(_w/2,_h/4,_w/2,_h/4)
							else
								surface.DrawRect(_w/2,0,_w/2,_h/4)
							end
						else
							if x>w/4 then
								surface.DrawRect(_w/4,0,_w/4,_h/2)
							else
								surface.DrawRect(0,0,_w/4,_h/2)
							end
						end
					else
						if x>w/2 then
							surface.DrawRect(_w/2,0,_w/2,_h/2)
						else
							surface.DrawRect(0,0,_w/2,_h/2)
						end
					end
				end
				
				surface.SetDrawColor(255,255,255)
				surface.DrawLine(0,0,_w,0)
				surface.DrawLine(0,0,0,_h)
				surface.DrawLine(_w,0,_w,_h)
				surface.DrawLine(0,_h,_w,_h)
				surface.DrawLine(_w/2,0,_w/2,_h)
				surface.DrawLine(0,_h/2,_w,_h/2)
				
				if mirrorpitch then
					surface.DrawLine(_w/4,0,_w/4,_h/2)
					surface.DrawLine(_w/2,_h/4,_w,_h/4)
				end
				
				if handlepitch then
					surface.DrawLine(_w/4,_h/2,_w/4,_h)
					surface.DrawLine(_w/2,_h/4*3,_w,_h/4*3)
				end
			end,
		},
		think_sv = function(self,on)
			if !on then return end
			
			local hleft,hright,hup,hdown
			local mleft,mright,mup,mdown
			
			for k,v in pairs(self.Buttons[index].PressedBy) do
				if k.TrolleybusButtons_lastbutton!=index then continue end
				
				local x = k.TrolleybusButtons_lastx
				local y = k.TrolleybusButtons_lasty
				
				if y>h/2 then
					if handlepitch then
						if x>w/2 then
							if y>h/4*3 then
								hdown = true
							else
								hup = true
							end
						else
							if x>w/4 then
								hright = true
							else
								hleft = true
							end
						end
					else
						if x>w/2 then
							hright = true
						else
							hleft = true 
						end
					end
				else
					if mirrorpitch then
						if x>w/2 then
							if y>h/4 then
								mdown = true
							else
								mup = true
							end
						else
							if x>w/4 then
								mright = true
							else
								mleft = true
							end
						end
					else
						if x>w/2 then
							mright = true
						else
							mleft = true
						end
					end
				end
			end
			
			local dt = FrameTime()
			
			if hleft then self:SetNWVar("mirror_"..index.."_hy",math.Clamp(self:GetNWVar("mirror_"..index.."_hy",hdefy)+dt*45,hymin,hymax)) end
			if hright then self:SetNWVar("mirror_"..index.."_hy",math.Clamp(self:GetNWVar("mirror_"..index.."_hy",hdefy)-dt*45,hymin,hymax)) end
			if mleft then self:SetNWVar("mirror_"..index.."_my",math.Clamp(self:GetNWVar("mirror_"..index.."_my",mdefy)-dt*45,mymin,mymax)) end
			if mright then self:SetNWVar("mirror_"..index.."_my",math.Clamp(self:GetNWVar("mirror_"..index.."_my",mdefy)+dt*45,mymin,mymax)) end
			
			if hup then self:SetNWVar("mirror_"..index.."_hp",math.Clamp(self:GetNWVar("mirror_"..index.."_hp",hdefp)+dt*45,hpmin,hpmax)) end
			if hdown then self:SetNWVar("mirror_"..index.."_hp",math.Clamp(self:GetNWVar("mirror_"..index.."_hp",hdefp)-dt*45,hpmin,hpmax)) end
			if mup then self:SetNWVar("mirror_"..index.."_mp",math.Clamp(self:GetNWVar("mirror_"..index.."_mp",mdefp)+dt*45,mpmin,mpmax)) end
			if mdown then self:SetNWVar("mirror_"..index.."_mp",math.Clamp(self:GetNWVar("mirror_"..index.."_mp",mdefp)-dt*45,mpmin,mpmax)) end
		end,
	}
	
	ENT.OtherPanelEntsData[index] = {
		name = "",
		model = model,
		panel = {
			name = index,
			pos = {0,0},
			radius = 0,
		},
		initialize = function(self,ent)
			ent:SetLocalPos(mpos)
			ent:SetLocalAngles(mang)
		end,
		think = function(self,ent)
			local hbone = self.hbone or ent:LookupBone(handlebone)
			
			if hbone then
				ent.hbone = hbone
				
				if !ent.hboneang then
					local m = ent:GetBoneMatrix(hbone)
					
					if m then
						local pos,ang = WorldToLocal(vector_origin,m:GetAngles(),ent:GetPos(),ent:GetAngles())
						ent.hboneang = ang
					end
				end
				
				if ent.hboneang then
					local handleang = Angle(self:GetNWVar("mirror_"..index.."_hp",hdefp),self:GetNWVar("mirror_"..index.."_hy",hdefy),0)
					ent.handleang = LerpAngle(FrameTime()*15,ent.handleang or handleang,handleang)
					
					local _,ang = WorldToLocal(vector_origin,ent.handleang,vector_origin,ent.hboneang)
					ent:ManipulateBoneAngles(hbone,ang)
				end
			end
			
			local mbone = self.mbone or ent:LookupBone(mirrorbone)
			
			if mbone then
				ent.mbone = mbone
				
				if !ent.mboneang then
					local m = ent:GetBoneMatrix(mbone)
					
					if m then
						local pos,ang = WorldToLocal(vector_origin,m:GetAngles(),ent:GetPos(),ent:GetAngles())
						ent.mboneang = ang
					end
				end
				
				if ent.mboneang then
					local mirrorang = Angle(self:GetNWVar("mirror_"..index.."_mp",mdefp),self:GetNWVar("mirror_"..index.."_my",mdefy),0)
					ent.mirrorang = LerpAngle(FrameTime()*15,ent.mirrorang or mirrorang,mirrorang)
					
					local _,ang = WorldToLocal(vector_origin,ent.mirrorang,vector_origin,ent.mboneang)
					ent:ManipulateBoneAngles(mbone,ang)
				end
			end
		end,
	}
	
	if CLIENT then
		ENT.MirrorsData[index] = {pos = lpos,ang = lang,width = mw,height = mh,otherent = index,initialize = function(self,mirror)
			mirror:SetParent(mirror:GetParent(),mirrorbone)
			
			if mverts then
				mirror:MakeComplex(mverts)
			end
		end}
	end
end

function Trolleybus_System.GetLinesIntersectPosition(l1x,l1y,l1dx,l1dy,l2x,l2y,l2dx,l2dy)
	if l1dx==0 and l1dy==0 or l2dx==0 and l2dy==0 then return end
	if l1dx==0 and l2dx==0 or l1dy==0 and l2dy==0 then return end
	
	if l1dx==l2dx and l1dy==l2dy then
		if l1x==l2x and l1y==l2y then return l1x,l1y end
	
		return
	end
	
	if l1dx==0 and l2dy==0 then return l1x,l2y end
	if l2dx==0 and l1dy==0 then return l2x,l1y end
	
	if l1dx==0 then return l1x,l2y+(l1x-l2x)/l2dx*l2dy end
	if l1dy==0 then return l2x+(l1y-l2y)/l2dy*l2dx,l1y end
	if l2dx==0 then return l2x,l1y+(l2x-l1x)/l1dx*l1dy end
	if l2dy==0 then return l1x+(l2y-l1y)/l1dy*l1dx,l2y end
	
	local mpx1 = l1dy/l1dx
	local add1 = l1y-l1x*mpx1
	
	local mpx2 = l2dy/l2dx
	local add2 = l2y-l2x*mpx2
	
	local x = (add1-add2)/(mpx2-mpx1)
	local y = mpx1*x+add1
	
	return x,y
end

function Trolleybus_System.GetLinesIntersectPosition3D(pos1,ang1,pos2,ang2)
	local p1,p2
	
	do
		local lpos,lang = WorldToLocal(pos2,ang2,pos1,ang1)
		local dir = lang:Forward()
		
		local x,y = Trolleybus_System.GetLinesIntersectPosition(0,0,1,0,lpos.x,lpos.y,dir.x,dir.y)
		
		if x then
			p1 = LocalToWorld(Vector(x,y,0),angle_zero,pos1,ang1)
		end
	end
	
	do
		local lpos,lang = WorldToLocal(pos1,ang1,pos2,ang2)
		local dir = lang:Forward()
		
		local x,y = Trolleybus_System.GetLinesIntersectPosition(0,0,1,0,lpos.x,lpos.y,dir.x,dir.y)
		
		if x then
			p2 = LocalToWorld(Vector(x,y,0),angle_zero,pos2,ang2)
		end
	end
	
	return p1 and p2 and (p1+p2)/2 or p1 or p2
end

function Trolleybus_System.GetSeatTrolleybus(seat)
	local index = Trolleybus_System.NetworkSystem.GetNWVar(seat,"Trolleybus",-1)
	return index==-1 and NULL or Entity(index)
end

local loop
function Trolleybus_System.IsTrolleybusMetatable(ENT)
	local lop = loop
	if !lop then loop = {} end

	local result = false
	
	if ENT and !ENT.IsTrailer then
		if ENT.Base=="trolleybus_ent_base" then
			result = true
		elseif ENT.Base and !loop[ENT.Base] then
			loop[ENT.Base] = true
			
			local Base = scripted_ents.GetStored(ENT.Base)
		
			if Base then
				result = Trolleybus_System.IsTrolleybusMetatable(Base.t)
			end
		end
	end
	
	if !lop then loop = nil end
	
	return result
end

function Trolleybus_System:TrolleybusSystem_HasAccessToTool(ply,tool)
	return ply:IsSuperAdmin()
end

hook.Add("PhysgunPickup","Trolleybus_System_PickupSeats",function(ply,ent)
	if IsValid(Trolleybus_System.GetSeatTrolleybus(ent)) then return false end
end)

local ELECTRIC_CIRCUIT_ELEMENT = {
	Init = function(self,type,data)
		self.Data = data or {}
		self.Type = type

		self.NextElements = {}
		self.PrevElements = {}
	end,
	GetNextElements = function(self)
		return self.NextElements
	end,
	GetPrevElements = function(self)
		return self.PrevElements
	end,
	IsDirectionAllowed = function(self,positive)
		return self.Data.Direction==nil or self.Data.Direction==positive
	end,
	AddLinkToNext = function(self,element)
		if element==self then return end

		if
			#self.NextElements>=(self.Type=="Node" and #self.PrevElements<=1 and 2 or 1) or
			#element.PrevElements>=(element.Type=="Node" and #element.NextElements<=1 and 2 or 1)
		then
			error("Trolleybus System Electric circuit element: Can't add new links to element (links limit reached)",3)
		end

		table.insert(self.NextElements,element)
		table.insert(element.PrevElements,self)
	end,
	OnUpdate = function(self)
		if !self.Data.OnUpdate then return end

		self.Data.OnUpdate(self:GetAmperage(),self:GetVoltage(),self:HasPower())
	end,
	GetResistance = function(self)
		if isfunction(self.Data.State) then return self.Data.State() and 0 or math.huge end

		local r = self.Data.Resistance
		return isfunction(r) and r() or isnumber(r) and r or 0
	end,
	GetAmperage = function(self)
		return self.Amperage==self.Amperage and self.Amperage or 0
	end,
	GetVoltage = function(self)
		return math.abs((self.PDCVoltage or 0)-(self.NDCVoltage or 0))
	end,
	HasPower = function(self)
		return math.abs(self:GetAmperage())>0.001
	end,
	Remove = function(self)
		for k,v in pairs(self.NextElements) do
			table.RemoveByValue(v.PrevElements,self)
		end

		for k,v in pairs(self.PrevElements) do
			table.RemoveByValue(v.NextElements,self)
		end

		self.NextElements = {}
		self.PrevElements = {}
	end,
	__tostring = function(self)
		return "["..self.Type..", "..(self.Name or "")..", R "..self:GetResistance()..", A "..self:GetAmperage()..", V "..self:GetVoltage().."]"
	end,
}

local ELECTRIC_CIRCUIT = {
	Init = function(self)
		self.Elements = {}
		self.ElNames = {}
		self.LastUpdate = 0

		self.VoltageSource = self:AddElement({Resistance = function() return self.MainLine and self.MainLine.r or 0 end},"voltsrc")
	end,
	Build = function(self)
		self.MainLine = nil

		local mainline = {els = {},nel = self.VoltageSource:GetNextElements()[1]}

		local cline = mainline
		while cline.nel!=self.VoltageSource do
			local el = cline.nel
			if !el then error("Trolleybus System: Failed to build electric circuit.") end

			if el.Type=="Node" and (#el:GetNextElements()>1 or #el:GetPrevElements()>1) then
				if #el:GetNextElements()>1 then
					local lines = {node = el,line = cline,r = 0,num = #cline.els+1}
					
					for k,v in ipairs(el:GetNextElements()) do
						lines[#lines+1] = {els = {},r = 0,nel = v,lines = lines,num = #lines+1}
					end

					cline.els[#cline.els+1] = lines
					cline = lines[1]
				else
					if cline.num==#cline.lines then
						cline = cline.lines.line

						cline.els[#cline.els+1] = {el = el}
						cline.nel = el:GetNextElements()[1]
					else
						cline = cline.lines[cline.num+1]
					end
				end
			else
				cline.els[#cline.els+1] = {el = el}
				cline.nel = el:GetNextElements()[1]
			end
		end

		self.MainLine = mainline
	end,
	Update = function(self,voltage)
		if !self.MainLine then return end

		if CurTime()-self.LastUpdate>0.1 then
			self.LastUpdate = CurTime()

			self:UpdateResistance(voltage<0)
			self:UpdateCurrent(voltage)

			return true
		end
	end,
	UpdateResistance = function(self,negative)
		if !self.MainLine then return end

		local cline = self.MainLine
		local celn = 1
		cline.r = 0

		local direction = !negative

		while true do
			local dt = cline.els[celn]

			if !dt then
				if cline.lines then
					if cline.num==#cline.lines then
						local sum = 0
						for i=1,#cline.lines do sum = sum+1/cline.lines[i].r end

						cline.lines.r = 1/sum

						local line = cline.lines.line
						line.r = line.r+cline.lines.r

						celn = cline.lines.num+1
						cline = line
					else
						cline = cline.lines[cline.num+1]
						celn = 1
						cline.r = 0
					end
				else
					break
				end
			else
				if dt.el then
					dt.r = dt.el:IsDirectionAllowed(direction) and dt.el:GetResistance() or math.huge

					cline.r = cline.r+dt.r
					celn = celn+1
				elseif dt.node then
					cline = dt[1]
					celn = 1
					cline.r = 0
				end
			end
		end

		return self:GetResistance()
	end,
	UpdateCurrent = function(self,voltage)
		if !self.MainLine then return end

		local amperage = voltage/self.MainLine.r

		self.VoltageSource.Amperage = amperage
		self.VoltageSource.PDCVoltage = 0
		self.VoltageSource.NDCVoltage = voltage

		local lastvoltel = self.VoltageSource
		local cline = self.MainLine
		local celn = 1
		cline.a = amperage

		while true do
			local dt = cline.els[celn]

			if !dt then
				if cline.lines then
					if cline.num==#cline.lines then
						lastvoltel = cline.els[celn-1] and (cline.els[celn-1].el or cline.els[celn-1].node) or lastvoltel

						celn = cline.lines.num+1
						cline = cline.lines.line
					else
						cline = cline.lines[cline.num+1]
						celn = 1
					end
				else
					break
				end
			else
				local el = dt.el or dt.node

				el.Amperage = cline.a
				el.PDCVoltage = (celn==1 and lastvoltel or cline.els[celn-1].el or cline.els[celn-1].node).NDCVoltage
				el.NDCVoltage = el.Amperage==0 and el.PDCVoltage or el.PDCVoltage-el.Amperage*(dt.node and 0 or dt.r)*(voltage<0 and -1 or 1)

				el:OnUpdate()

				if dt.el then
					celn = celn+1
				elseif dt.node then
					lastvoltel = dt.node

					cline = dt[1]
					celn = 1

					local voltage = dt.node.Amperage*dt.r
					
					for i=1,#dt do
						dt[i].a = (voltage!=voltage or voltage==0) and 0 or voltage/dt[i].r
					end
				end
			end
		end

		return self:GetAmperage()
	end,
	AddNodeElement = function(self,name)
		self.MainLine = nil

		local obj = setmetatable({},{__index = ELECTRIC_CIRCUIT_ELEMENT,__tostring = ELECTRIC_CIRCUIT_ELEMENT.__tostring})
		obj:Init("Node")
		obj.Name = name

		table.insert(self.Elements,obj)
		if name then self.ElNames[name] = obj end

		return obj
	end,
	AddElement = function(self,data,name)
		self.MainLine = nil

		local obj = setmetatable({},{__index = ELECTRIC_CIRCUIT_ELEMENT,__tostring = ELECTRIC_CIRCUIT_ELEMENT.__tostring})
		obj:Init("Element",data)
		obj.Name = name

		table.insert(self.Elements,obj)
		if name then self.ElNames[name] = obj end

		return obj
	end,
	RemoveElement = function(self,element)
		if element==self.VoltageSource then return end

		self.MainLine = nil

		if table.RemoveByValue(self.Elements,element) then
			table.RemoveByValue(self.ElNames,element)

			element:Remove()
		end
	end,
	GetElement = function(self,name)
		return self.ElNames[name]
	end,
	GetVoltageSource = function(self,element)
		return self.VoltageSource
	end,
	GetAmperage = function(self,element)
		element = element or self.VoltageSource

		return element:GetAmperage()
	end,
	GetVoltage = function(self,element1,element2)
		element1 = element1 or self.VoltageSource

		if !element2 then return element1:GetVoltage() end

		return math.abs(element1.NDCVoltage-element2.PDCVoltage)
	end,
	GetResistance = function(self)
		return self.MainLine.r
	end,
	HasPower = function(self)
		return math.abs(self:GetAmperage())>0.01
	end,
	BuildFromData = function(self,data)
		local stack = {{data,1,self.VoltageSource,{}}}
		
		while true do
			local t = stack[#stack]
			local el = t[1][t[2]]

			if !el and #t[4]!=0 then
				el = true
			end

			if !el then
				//if #t[4]!=0 then error("Trolleybus System: Failed to build electric circuit from data (missing 'true').") end

				stack[#stack] = nil
				
				local nt = stack[#stack]

				if nt then
					local node2 = self:AddNodeElement(t[1].node2name)
					t[3]:AddLinkToNext(node2)

					nt[4][#nt[4]+1] = node2

					continue
				else
					t[3]:AddLinkToNext(self.VoltageSource)
					break
				end
			end

			if el==true then
				if #t[4]==0 then error("Trolleybus System: Failed to build electric circuit from data (unnecessary 'true').") end

				local node2 = table.remove(t[4])
				t[3]:AddLinkToNext(node2)

				t[3] = node2
			elseif istable(el) then
				if istable(el[1]) then
					local node1 = self:AddNodeElement(el.node1name)
					t[3]:AddLinkToNext(node1)

					t[3] = node1
					stack[#stack+1] = {el,1,node1,{}}
				else
					local obj = self:AddElement(el,el.name)
					t[3]:AddLinkToNext(obj)

					t[3] = obj
				end
			else
				error("Trolleybus System: Failed to build electric circuit from data (unknown element).")
			end

			t[2] = t[2]+1
		end
		
		/*print("\\\\\\\\\\\\\\\\\\///////////")
		for k,v in ipairs(self.Elements) do
			print(v.Name)

			print("Prev:")
			for k,v in ipairs(v.PrevElements) do
				print("\t",v.Name)
			end
			print("Next:")
			for k,v in ipairs(v.NextElements) do
				print("\t",v.Name)
			end
		end*/

		self:Build()
	end,
}

function Trolleybus_System.CreateElectricCircuit()
	local obj = setmetatable({},{__index = ELECTRIC_CIRCUIT})
	obj:Init()

	return obj
end

function Trolleybus_System.CopyValue(value)
	if istable(value) then
		local t = {}

		for k,v in pairs(value) do
			t[Trolleybus_System.CopyValue(k)] = Trolleybus_System.CopyValue(v)
		end

		return t
	elseif isvector(value) then
		return Vector(value)
	elseif isangle(value) then
		return Angle(value)
	end

	return value
end

Trolleybus_System.PseudoAsyncTasks = Trolleybus_System.PseudoAsyncTasks or {}
local PSEUDOASYNC_TASK = {
	Init = function(self,taskfunc)
		self.thread = coroutine.create(function() taskfunc(self) self:Cancel() end)
		
		self.paused = false
		self.removed = false
		self.priority = 1
		self.sleept = 0

		table.insert(Trolleybus_System.PseudoAsyncTasks,self)
	end,
	Pause = function(self)
		self.paused = true

		if coroutine.running()==self.thread then
			coroutine.yield()
		end
	end,
	UnPause = function(self)
		self.paused = false
	end,
	Cancel = function(self)
		if !self.removed then
			table.RemoveByValue(Trolleybus_System.PseudoAsyncTasks,self)
			self.removed = true

			if coroutine.running()==self.thread then
				coroutine.yield()
			end
		end
	end,
	Yield = function(self)
		coroutine.yield()
	end,
	Sleep = function(self,time)
		time = tonumber(time) or 0

		self.sleept = SysTime()+time
		coroutine.yield()
	end,
	SetPriority = function(self,pr)
		self.priority = math.max(0,tonumber(pr) or 1)
	end,
	GetPriority = function(self)
		return self.priority
	end,
	GetStatus = function(self)
		return coroutine.status(self.thread)
	end,
	IsPaused = function(self)
		return self.paused
	end,
	IsValid = function(self)
		return !self.removed
	end,
}

function Trolleybus_System.CreatePseudoAsyncTask(task,pr)
	assert(isfunction(task),"Bad 'task' argument for 'Trolleybus_System.CreatePseudoAsyncTask'")

	local obj = setmetatable({},{__index = PSEUDOASYNC_TASK})
	obj:Init(task)
	if pr then obj:SetPriority(pr) end

	return obj
end

local conttask,penalty,prevrt = nil,0,RealTime()
hook.Add("Think","Trolleybus_System.PseudoAsyncTasks",function()
	local rt = RealTime()

	if prevrt==rt then return end
	prevrt = rt

	local tasks = Trolleybus_System.PseudoAsyncTasks
	if #tasks==0 then return end

	local prs,prssum = {},0
	local contid = 1

	for i=1,#tasks do
		local task = tasks[i]

		if !task.paused and task.priority>0 and SysTime()>task.sleept then
			prs[#prs+1] = {task,task.priority}
			prssum = prssum+task.priority

			if task==conttask then contid = #prs end
		end
	end

	conttask = nil

	if prssum==0 then return end

	local maxtaskstime = SERVER and engine.TickInterval() or RealFrameTime()
	if maxtaskstime<0 then maxtaskstime = 0 end

	local maxtaskstimenow = maxtaskstime-penalty
	if maxtaskstimenow<0 then maxtaskstimenow = 0 end

	local prmp = maxtaskstimenow/prssum
	local starttime = SysTime()
	local maxtime = starttime

	local i = contid
	for c=1,#prs do
		local dt = prs[i]
		local task,pr = dt[1],dt[2]

		if !task.removed then
			if SysTime()-starttime>maxtaskstimenow then
				conttask = task
				break
			end

			maxtime = maxtime+pr*prmp

			repeat
				local suc,err = coroutine.resume(task.thread)
				if !suc then task:Cancel() ErrorNoHalt("Trolleybus_System: PseudoAsyncTask Error: "..err.."\n") end
			until task.removed or SysTime()>=maxtime or SysTime()<=task.sleept
		end

		i = i==#prs and 1 or i+1
	end

	penalty = penalty+SysTime()-starttime-maxtaskstime
	if penalty<0 then penalty = 0 end
end)