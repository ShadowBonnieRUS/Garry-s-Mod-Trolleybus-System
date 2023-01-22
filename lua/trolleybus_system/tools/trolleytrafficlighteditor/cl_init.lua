-- Copyright © Platunov I. M., 2020 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase

language.Add("tool.trolleytrafficlighteditor.name",L"tool.trolleytrafficlighteditor.name")
language.Add("tool.trolleytrafficlighteditor.desc",L"tool.trolleytrafficlighteditor.desc")
language.Add("tool.trolleytrafficlighteditor.left",L"tool.trolleytrafficlighteditor.left")
language.Add("tool.trolleytrafficlighteditor.right",L"tool.trolleytrafficlighteditor.right")
language.Add("tool.trolleytrafficlighteditor.reload",L"tool.trolleytrafficlighteditor.reload")
language.Add("tool.trolleytrafficlighteditor.left_use",L"tool.trolleytrafficlighteditor.left_use")
language.Add("tool.trolleytrafficlighteditor.reload_use",L"tool.trolleytrafficlighteditor.reload_use")

local pnl = controlpanel.Get("trolleytrafficlighteditor")

function TOOL:LeftClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficlighteditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	return true
end

function TOOL:RightClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficlighteditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	if self:GetOwner():KeyDown(IN_USE) or !self:GetMainTrafficLight(trace.Entity) then
		return false
	end
	
	return true
end

local CurPartNum = {NULL,1}
function TOOL:Reload(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficlighteditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	local light = self:GetMainTrafficLight(trace.Entity)
	if !light then return false end
	
	return true
end

function TOOL:DrawHUD()
	local eyepos = Trolleybus_System.EyePos()
	local eyedir = Trolleybus_System.EyeVector()
	
	for k,v in ipairs(ents.FindByClass("trolleybus_trafficlight")) do
		if v:GetID()>0 and (v:GetPos():Distance(eyepos)<Trolleybus_System.GetPlayerSetting("TrafficLightDrawDistance") or self:GetOwner():KeyDown(IN_USE)) then
			local pos = v:WorldSpaceCenter()
			
			cam.Start3D()
				local p = pos:ToScreen()
			cam.End3D()
			
			if !p.visible or math.deg(math.acos((pos-eyepos):GetNormalized():Dot(eyedir)))>15 then continue end

			local time = v:GetTime()-CurTime()
			draw.SimpleText(Format("%i. %.1fs (%i, %ss)",v:GetID(),v:GetStatesDuration(),v:GetState(),time<0 and "?" or Format("%.1f",time)),"BudgetLabel",p.x,p.y,nil,1,1)
		end
	end
end

function TOOL.BuildCPanel(panel)
	pnl = panel
	
	pnl.AddNewLight = vgui.Create("DButton",pnl)
	pnl.AddNewLight:Dock(TOP)
	pnl.AddNewLight:DockMargin(0,5,5,5)
	pnl.AddNewLight:SetText(L"tool.trolleytrafficlighteditor.ui.create")
	pnl.AddNewLight:SetColor(color_black)
	pnl.AddNewLight.DoClick = function(s)
		pnl.LightData:LoadLight({
			Start = 1,
			OffsetTime = 0,
			States = {},
		})
	end
	
	pnl.LightData = vgui.Create("DForm",pnl)
	pnl.LightData:Dock(TOP)
	pnl.LightData:DockMargin(0,5,5,5)
	pnl.LightData:SetName(L"tool.trolleytrafficlighteditor.ui.data")
	pnl.LightData.LoadLight = function(s,data)
		if !s.Loaded then
			s.Loaded = true
			
			s.LightType = vgui.Create("DComboBox",s)
			s.LightType:Dock(TOP)
			s.LightType:DockMargin(5,5,5,5)
			s.LightType.OnSelect = function(c,index,name,type)
				for k,v in pairs(s.States.Items) do
					v.Lenses:ReloadType(type)
				end
			end
			s.LightType.Select = function(s,type)
				local defid,typeid
				
				for k,v in pairs(s.Choices) do
					if s:GetOptionData(k)=="default" then
						defid = k
					elseif s:GetOptionData(k)==type then
						typeid = k
						break
					end
				end
				
				s:ChooseOptionID(typeid or defid)
			end
			local LightType = s.LightType
			
			for k,v in pairs(Trolleybus_System.TrafficLightTypes) do
				LightType:AddChoice(v.Name or k,k)
			end
			
			s.StartStateLabel = vgui.Create("DLabel",s)
			s.StartStateLabel:SetWrap(true)
			s.StartStateLabel:SetAutoStretchVertical(true)
			s.StartStateLabel:Dock(TOP)
			s.StartStateLabel:DockMargin(5,5,5,5)
			s.StartStateLabel:SetText(L"tool.trolleytrafficlighteditor.ui.startstate")
			s.StartStateLabel:SetColor(color_black)
			
			local fix = vgui.Create("DPanel",s)
			fix:Dock(TOP)
			fix:DockMargin(5,5,5,5)
			fix:SetTall(20)
			
			s.StartStateTextEntry = vgui.Create("DTextEntry",fix)
			s.StartStateTextEntry:Dock(FILL)
			s.StartStateTextEntry:SetText("1")
			s.StartStateTextEntry.AllowInput = function(s,c)
				return !c:find("%d")
			end
			
			s.OffsetTime = vgui.Create("DNumSlider",s)
			s.OffsetTime:Dock(TOP)
			s.OffsetTime:DockMargin(5,5,5,5)
			s.OffsetTime:SetMin(0)
			s.OffsetTime:SetMax(120)
			s.OffsetTime:SetText(L"tool.trolleytrafficlighteditor.ui.timeoffset")
			s.OffsetTime:SetDark(true)
			s.OffsetTime:SetDecimals(0)
			s.OffsetTime:SetValue(0)
			
			s.NewState = vgui.Create("DButton",s)
			s.NewState:Dock(TOP)
			s.NewState:DockMargin(5,5,5,5)
			s.NewState:SetText(L"tool.trolleytrafficlighteditor.ui.createstate")
			s.NewState:SetColor(color_black)
			s.NewState.DoClick = function(b)
				s.States:AddState({
					Lenses = {},
					IsStopSignal = false,
					Time = 20,
				})
			end
			
			s.States = vgui.Create("DForm",s)
			s.States:Dock(TOP)
			s.States:DockMargin(5,5,5,5)
			s.States:SetName(L"tool.trolleytrafficlighteditor.ui.states")
			s.States.Items = {}
			s.States.AddState = function(s,data)
				local state = vgui.Create("DForm",s)
				state:Dock(TOP)
				state:DockMargin(5,5,5,5)
				state:SetZPos(table.insert(s.Items,state))
				state:SetName(state:GetZPos())

				local move = vgui.Create("DPanel",state)
				move:SetTall(20)
				move:Dock(TOP)
				move:DockMargin(5,5,5,5)

				local moveup = vgui.Create("DButton",move)
				moveup:SetText("↑")
				moveup.DoClick = function(b)
					local key = table.KeyFromValue(s.Items,state)
					if key>1 then
						s.Items[key] = s.Items[key-1]
						s.Items[key-1] = state

						s.Items[key]:SetZPos(key)
						s.Items[key]:SetName(key)
						state:SetZPos(key-1)
						state:SetName(key-1)

						s:InvalidateLayout()
					end
				end

				local movedown = vgui.Create("DButton",move)
				movedown:SetText("↓")
				movedown.DoClick = function(b)
					local key = table.KeyFromValue(s.Items,state)
					if key<#s.Items then
						s.Items[key] = s.Items[key+1]
						s.Items[key+1] = state

						s.Items[key]:SetZPos(key)
						s.Items[key]:SetName(key)
						state:SetZPos(key+1)
						state:SetName(key+1)

						s:InvalidateLayout()
					end
				end

				move.PerformLayout = function(s,w,h)
					moveup:SetPos(0,0)
					moveup:SetSize(w/2,h)
					movedown:SetPos(w/2,0)
					movedown:SetSize(w/2,h)
				end
				
				state.Lenses = vgui.Create("DForm",state)
				state.Lenses:Dock(TOP)
				state.Lenses:DockMargin(5,5,5,5)
				state.Lenses:SetName(L"tool.trolleytrafficlighteditor.ui.lenses")
				state.Lenses.Items = {}
				state.Lenses.CheckLense = function(s,lense)
					local data = Trolleybus_System.TrafficLightLenses[lense]
					local ltype = select(2,LightType:GetSelected())
					
					return data and ltype and (!data.Allowed or table.HasValue(data.Allowed,ltype)) and lense
				end
				state.Lenses.ReloadType = function(s,type)
					local ldata = Trolleybus_System.TrafficLightTypes[type].Lenses
					local prev = {}
					
					for k,v in ipairs(s.Items) do
						prev[k] = v.type
						v:Remove()
					end
					
					s.Items = {}
					
					for k,v in ipairs(ldata) do
						local lense = vgui.Create("DButton",s)
						lense:Dock(TOP)
						lense:DockMargin(5,5,5,5)
						lense.Select = function(b,type)
							b.type = type
							
							local data = Trolleybus_System.TrafficLightLenses[type]
							
							local prefix = ""
							if data.Categories then
								local key = ""
								
								for k,v in ipairs(data.Categories) do
									key = key..(key=="" and "" or "_")..v
									
									prefix = prefix..L("trafficlight_categories_"..key).."; "
								end
							end
							
							b:SetText(prefix..data.Name)
						end
						
						lense.DoClick = function(b)
							local menu = DermaMenu()
							local menus = {}
							
							for k,v in SortedPairs(Trolleybus_System.TrafficLightLenses) do
								if !s:CheckLense(k) then continue end
								
								local m = menu
								
								if v.Categories then
									local key = ""
									
									for k2,v2 in ipairs(v.Categories) do
										key = key..(key=="" and "" or "_")..v2
										
										menus[key] = menus[key] or m:AddSubMenu(L("trafficlight_categories_"..key),nil)
										
										m = menus[key]
									end
								end
								
								m:AddOption(v.Name,function()
									if IsValid(b) then b:Select(k) end
								end)
							end
							
							menu:Open(lense:LocalToScreen(0,lense:GetTall()))
						end
						
						lense:Select(s:CheckLense(prev[k]) or s:CheckLense(data.Lenses[k]) or s:CheckLense(v[4]) or "nolense")
						
						table.insert(s.Items,lense)
					end
				end
				state.Lenses:ReloadType(select(2,LightType:GetSelected()))
				
				state.Time = vgui.Create("DNumSlider",state)
				state.Time:Dock(TOP)
				state.Time:DockMargin(5,5,5,5)
				state.Time:SetMin(1)
				state.Time:SetMax(120)
				state.Time:SetText(L"tool.trolleytrafficlighteditor.ui.worktime")
				state.Time:SetDark(true)
				state.Time:SetDecimals(0)
				state.Time:SetValue(data.Time)
				
				state.IsStopSignal = vgui.Create("DCheckBoxLabel",state)
				state.IsStopSignal:Dock(TOP)
				state.IsStopSignal:DockMargin(5,5,5,5)
				state.IsStopSignal:SetText(L"tool.trolleytrafficlighteditor.ui.stopsignal")
				state.IsStopSignal:SetValue(data.IsStopSignal)
				state.IsStopSignal:SetDark(true)
				
				local delete = vgui.Create("DButton",state)
				delete:Dock(TOP)
				delete:DockMargin(5,5,5,5)
				delete:SetText(L"tool.trolleytrafficlighteditor.ui.removestate")
				delete:SetColor(color_black)
				delete.DoClick = function(b)
					state:Remove()
					table.RemoveByValue(s.Items,state)
					
					for k,v in ipairs(s.Items) do
						v:SetName(k)
					end
				end
			end
		end
		
		s.LightType:Select(data.Type)
		
		for k,v in pairs(s.States.Items) do
			v:Remove()
		end
		s.States.Items = {}
		
		s.StartStateTextEntry:SetText(data.Start)
		s.OffsetTime:SetValue(data.OffsetTime)
		
		for k,v in pairs(data.States) do
			s.States:AddState(v)
		end
	end
end

net.Receive("TrolleybusTrafficLightEditor",function(len)
	local cmd = net.ReadUInt(4)
	
	if cmd==0 then
		local id = net.ReadUInt(32)
	
		if IsValid(pnl) then
			pnl.LightData:LoadLight({
				ID = id,
				Start = 1,
				States = {},
			})
		end
	elseif cmd==1 then
		local E = net.ReadBool()
		
		if IsValid(pnl) and pnl.LightData.Loaded then
			local data = {
				Type = select(2,pnl.LightData.LightType:GetSelected()),
				OffsetTime = math.Clamp(math.Round(pnl.LightData.OffsetTime:GetValue(),pnl.LightData.OffsetTime:GetDecimals()),pnl.LightData.OffsetTime:GetMin(),pnl.LightData.OffsetTime:GetMax()),
				States = {},
			}
			
			for k,v in pairs(pnl.LightData.States.Items) do
				local state = {
					Lenses = {},
					IsStopSignal = v.IsStopSignal:GetChecked(),
					Time = math.Clamp(math.Round(v.Time:GetValue(),v.Time:GetDecimals()),v.Time:GetMin(),v.Time:GetMax()),
				}
				
				for k,v in ipairs(v.Lenses.Items) do
					state.Lenses[k] = v.type
				end
				
				table.insert(data.States,state)
			end
			
			data.Start = math.Clamp(tonumber(pnl.LightData.StartStateTextEntry:GetText()) or 1,1,#data.States)
			
			net.Start("TrolleybusTrafficLightEditor")
				net.WriteUInt(1,4)
				net.WriteBool(E)
				if E then net.WriteUInt(CurPartNum[2],8) end
				net.WriteTable(data)
			net.SendToServer()
		end
	elseif cmd==2 then
		local data = net.ReadTable()
		
		if IsValid(pnl) then
			pnl.LightData:LoadLight(data)
		end
	elseif cmd==3 then
		local light = LocalPlayer():GetActiveWeapon():GetToolObject():GetMainTrafficLight(LocalPlayer():GetEyeTrace().Entity)
		if !light then return end
		
		if !IsValid(pnl) or !pnl.LightData or !pnl.LightData.Loaded then return end
		
		local type = select(2,pnl.LightData.LightType:GetSelected())
		
		local data = Trolleybus_System.TrafficLightTypes[type]
		if !data or !data.PartOfLight or !data.PartOfLight[light:GetType()] then return end
		
		CurPartNum[2] = CurPartNum[2]%#data.PartOfLight[light:GetType()]+1
	end
end)

hook.Add("PostDrawTranslucentRenderables","trolleytrafficlighteditor",function(depth,sky)
	if sky or !IsValid(pnl) or !pnl.LightData or !pnl.LightData.Loaded then return end
	
	local ply = LocalPlayer()
	local self = ply:HasWeapon("gmod_tool") and ply:GetWeapon("gmod_tool"):GetMode()=="trolleytrafficlighteditor" and ply:GetWeapon("gmod_tool"):GetToolObject()
	if !self or ply:GetActiveWeapon()!=ply:GetWeapon("gmod_tool") then return end
	
	local type = select(2,pnl.LightData.LightType:GetSelected())
	
	local data = Trolleybus_System.TrafficLightTypes[type]
	if !data then return end
	
	local pos,ang
	local trace = ply:GetEyeTrace()
	
	if ply:KeyDown(IN_USE) then
		local light = self:GetMainTrafficLight(trace.Entity)
		
		if CurPartNum[1]!=light then
			CurPartNum[1] = light
			CurPartNum[2] = 1
		end
		
		pos,ang = self:GetLightPos(ply,trace,type,CurPartNum[2])
	else
		pos,ang = trace.HitPos,Angle(0,ply:EyeAngles().y+180,0)
	end
	
	pos,ang = LocalToWorld(data.ToolPosOffset or vector_origin,data.ToolAngOffset or angle_zero,pos,ang)
	
	local models = {{data.Model,vector_origin,angle_zero}}
	
	if data.OtherParts then
		local base = data.OtherParts.Base
		
		if base then
			local dt = data.OtherParts[base]
			models[1][2] = dt[2] or vector_origin
			models[1][3] = dt[3] or angle_zero
		end
		
		for k,v in ipairs(data.OtherParts) do
			local pos,ang = LocalToWorld(v[2] or vector_origin,v[3] or angle_zero,models[1][2],models[1][3])
			
			models[#models+1] = {v[1],base!=k and pos or vector_origin,base!=k and ang or angle_zero,v[4]}
		end
	end
	
	render.SetBlend(1)
	
	for k,v in ipairs(models) do
		local pos,ang = LocalToWorld(v[2],v[3],pos,ang)
		
		local mdl = ClientsideModel(v[1],RENDERGROUP_OTHER)
		mdl:SetPos(pos)
		mdl:SetAngles(ang)
		
		if v[4] then
			for k,v in ipairs(v[4]) do
				mdl:SetBodygroup(k-1,v)
			end
		end
		
		mdl:DrawModel()
		mdl:Remove()
	end
end)
