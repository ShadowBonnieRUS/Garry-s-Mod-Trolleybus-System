-- Copyright © Platunov I. M., 2020 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase

language.Add("tool.trolleytrafficeditor.name",L"tool.trolleytrafficeditor.name")
language.Add("tool.trolleytrafficeditor.desc",L"tool.trolleytrafficeditor.desc")
language.Add("tool.trolleytrafficeditor.left",L"tool.trolleytrafficeditor.left")
language.Add("tool.trolleytrafficeditor.right",L"tool.trolleytrafficeditor.right")
language.Add("tool.trolleytrafficeditor.right_use",L"tool.trolleytrafficeditor.right_use")
language.Add("tool.trolleytrafficeditor.reload",L"tool.trolleytrafficeditor.reload")
language.Add("tool.trolleytrafficeditor.left1",L"tool.trolleytrafficeditor.left1")
language.Add("tool.trolleytrafficeditor.right1",L"tool.trolleytrafficeditor.right1")
language.Add("tool.trolleytrafficeditor.left2",L"tool.trolleytrafficeditor.left2")
language.Add("tool.trolleytrafficeditor.left3",L"tool.trolleytrafficeditor.left3")
language.Add("tool.trolleytrafficeditor.left4",L"tool.trolleytrafficeditor.left4")
language.Add("tool.trolleytrafficeditor.reload1",L"tool.trolleytrafficeditor.reload1")
language.Add("tool.trolleytrafficeditor.reload2",L"tool.trolleytrafficeditor.reload2")
language.Add("tool.trolleytrafficeditor.left5",L"tool.trolleytrafficeditor.left5")
language.Add("tool.trolleytrafficeditor.left_use",L"tool.trolleytrafficeditor.left_use")
language.Add("tool.trolleytrafficeditor.right_use2",L"tool.trolleytrafficeditor.right_use2")

local function drawtrack(pos1,pos2,color)
	local center = pos1+(pos2-pos1)/2
	local ang = (pos2-pos1):Angle()
	
	render.DrawLine(pos1,pos2,color)
	render.DrawLine(center,center-ang:Right()*20-ang:Forward()*20,color)
	render.DrawLine(center,center+ang:Right()*20-ang:Forward()*20,color)
	render.DrawLine(pos1+ang:Right()*10,pos1-ang:Right()*10,color)
	render.DrawLine(pos2+ang:Right()*20,pos2-ang:Right()*20,color)
end

function TOOL:LeftClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficeditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	local op = self:GetOperation()
	
	if op==3 and (!IsValid(trace.Entity) or trace.Entity:GetClass()!="trolleybus_trafficlight") then
		return false
	end
	
	return true
end

function TOOL:RightClick(trace)
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficeditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	return true
end

function TOOL:Reload()
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleytrafficeditor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner()) then return false end
	
	local op = self:GetOperation()
	
	if op==0 then
		local id = self:GetNearestTrack()
		
		if !Trolleybus_System.GetTrafficTracks()[id] then
			return false
		end
	end
	
	return true
end

local col,pnl = Color(0,255,0),controlpanel.Get("trolleytrafficeditor")
pnl = pnl and pnl.TrackIDLabel and pnl

function TOOL:DrawHUD()
	local track = Trolleybus_System.GetTrafficTracks()[self:GetClientNumber("trackid")]
	
	for k,v in pairs(Trolleybus_System.GetTrafficTracks()) do
		if track!=v and util.DistanceToLine(v.Start,v.End,Trolleybus_System.EyePos())>Trolleybus_System.GetPlayerSetting("CNObjectsDrawDistance") then continue end
		
		local color = track and (
			track==v and Color(255,255,0) or
			track.LookBase==k and table.HasValue(track.Next,k) and Color(0,255,255) or
			table.HasValue(track.Next,k) and Color(0,255,0) or
			track.LookBase==k and table.HasValue(track.Prev,k) and Color(255,0,255) or
			table.HasValue(track.Prev,k) and Color(255,0,0) or
			track.Look and table.HasValue(track.Look,k) and Color(255,150,0) or
			track.LookBase==k and Color(0,150,255)
		) or color_white
		
		local center = (v.Start+v.End)/2
		local pos = center:ToScreen()
		
		cam.Start3D()
			drawtrack(v.Start,v.End,color)
		cam.End3D()
		
		draw.SimpleText(k,"BudgetLabel",pos.x,pos.y,color,1,1)
	end
	
	if track and track.TrafficLight then
		for k,v in ipairs(ents.FindByClass("trolleybus_trafficlight")) do
			if v:GetID()==track.TrafficLight then
				local p = v:LocalToWorld(v:OBBCenter())
				local pos = p:ToScreen()
				
				draw.SimpleText(L"tool.trolleytrafficeditor.linkedtrafficlight","BudgetLabel",pos.x,pos.y,color_white,1,1)
			
				break
			end
		end
	end
	
	local op,stage = self:GetOperation(),self:GetStage()
	
	if track and op==1 then
		local p,invert = track.End,false
		
		if IsValid(pnl) then
			local tr = Trolleybus_System.GetTrafficTracks()[tonumber(pnl.TrackIDTextEntry:GetText()) or 0]
			
			if tr==track then
				if stage==0 then
					invert = true
				elseif stage==1 then
					p = track.Start
				end
			end
		end
		
		local pos = self:GetNearestConnectPos()
		
		cam.Start3D()
			drawtrack(invert and pos or p,invert and p or pos,col)
		cam.End3D()
	elseif op==2 then
		if stage==2 then
			if IsValid(pnl) then
				local p1,p2 = pnl.RotationData[1],pnl.RotationData[2]
				
				local ang = self:GetOwner():EyeAngles()
				ang.p = 0
				ang.r = 0
				
				cam.Start3D()
					self:BuildRotation(p1,p2,ang,self:GetClientNumber("rotation_segments"),self:GetClientNumber("rotation_curvature"),self:GetOwner():KeyDown(IN_RELOAD),function(i,count,pos,prevpos)
						if !prevpos then return end
						
						drawtrack(prevpos,pos,col)
					end)
				cam.End3D()
			end
		else
			local pos = self:GetNearestConnectPos()
			
			cam.Start3D()
				render.DrawLine(pos-Vector(20,20),pos+Vector(20,20),col)
				render.DrawLine(pos-Vector(20,-20),pos+Vector(20,-20),col)
			
			
			if stage==1 and IsValid(pnl) and pnl.RotationData[1] then
				local ang = self:GetOwner():EyeAngles()
				ang.p = 0
				ang.r = 0
			
				self:BuildRotation(pnl.RotationData[1],pos,ang,self:GetClientNumber("rotation_segments"),self:GetClientNumber("rotation_curvature"),self:GetOwner():KeyDown(IN_RELOAD),function(i,count,pos,prevpos)
					if !prevpos then return end
				
					drawtrack(prevpos,pos,col)
				end)
			end
			
			cam.End3D()
		end
	end
end

function TOOL.BuildCPanel(panel)
	pnl = panel
	
	pnl.TrackIDLabel = vgui.Create("DLabel",pnl)
	pnl.TrackIDLabel:Dock(TOP)
	pnl.TrackIDLabel:SetText(L"tool.trolleytrafficeditor.ui.trackid")
	pnl.TrackIDLabel:SetWrap(true)
	pnl.TrackIDLabel:SetAutoStretchVertical(true)
	pnl.TrackIDLabel:SetColor(color_black)
	
	local fix = vgui.Create("DPanel",pnl)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(0,0,0,5)
	
	pnl.TrackIDTextEntry = vgui.Create("DTextEntry",fix)
	pnl.TrackIDTextEntry:Dock(FILL)
	pnl.TrackIDTextEntry:SetText(GetConVar("trolleytrafficeditor_trackid"):GetString())
	pnl.TrackIDTextEntry.AllowInput = function(s,c)
		return !c:find("%d")
	end
	
	pnl.StartPosLabel = vgui.Create("DLabel",pnl)
	pnl.StartPosLabel:Dock(TOP)
	pnl.StartPosLabel:SetText(L"tool.trolleytrafficeditor.ui.start")
	pnl.StartPosLabel:SetWrap(true)
	pnl.StartPosLabel:SetAutoStretchVertical(true)
	pnl.StartPosLabel:SetColor(color_black)
	
	local fix = vgui.Create("DPanel",pnl)
	fix:SetTall(20)
	fix:Dock(TOP)
	
	pnl.StartPosTextEntry = vgui.Create("DTextEntry",fix)
	pnl.StartPosTextEntry:Dock(FILL)
	pnl.StartPosTextEntry:SetText("")
	pnl.StartPosTextEntry:SetEnabled(false)
	
	pnl.StartPosButton = vgui.Create("DButton",pnl)
	pnl.StartPosButton:Dock(TOP)
	pnl.StartPosButton:DockMargin(0,0,0,5)
	pnl.StartPosButton:SetText(L"tool.trolleytrafficeditor.ui.setstart")
	pnl.StartPosButton:SetColor(color_black)
	pnl.StartPosButton.DoClick = function(s)
		net.Start("TrolleybusTrafficTrackEditor")
			net.WriteUInt(0,4)
			net.WriteBool(false)
		net.SendToServer()
	end
	
	pnl.EndPosLabel = vgui.Create("DLabel",pnl)
	pnl.EndPosLabel:Dock(TOP)
	pnl.EndPosLabel:SetText(L"tool.trolleytrafficeditor.ui.end")
	pnl.EndPosLabel:SetWrap(true)
	pnl.EndPosLabel:SetAutoStretchVertical(true)
	pnl.EndPosLabel:SetColor(color_black)
	
	local fix = vgui.Create("DPanel",pnl)
	fix:SetTall(20)
	fix:Dock(TOP)
	
	pnl.EndPosTextEntry = vgui.Create("DTextEntry",fix)
	pnl.EndPosTextEntry:Dock(FILL)
	pnl.EndPosTextEntry:SetText("")
	pnl.EndPosTextEntry:SetEnabled(false)
	
	pnl.EndPosButton = vgui.Create("DButton",pnl)
	pnl.EndPosButton:Dock(TOP)
	pnl.EndPosButton:DockMargin(0,0,0,5)
	pnl.EndPosButton:SetText(L"tool.trolleytrafficeditor.ui.setend")
	pnl.EndPosButton:SetColor(color_black)
	pnl.EndPosButton.DoClick = function(s)
		net.Start("TrolleybusTrafficTrackEditor")
			net.WriteUInt(0,4)
			net.WriteBool(true)
		net.SendToServer()
	end
	
	pnl.NextTracksLabel = vgui.Create("DLabel",pnl)
	pnl.NextTracksLabel:Dock(TOP)
	pnl.NextTracksLabel:SetText(L"tool.trolleytrafficeditor.ui.nexttracks")
	pnl.NextTracksLabel:SetWrap(true)
	pnl.NextTracksLabel:SetAutoStretchVertical(true)
	pnl.NextTracksLabel:SetColor(color_black)
	
	local fix = vgui.Create("DPanel",pnl)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(0,0,0,5)
	
	pnl.NextTracksTextEntry = vgui.Create("DTextEntry",fix)
	pnl.NextTracksTextEntry:Dock(FILL)
	pnl.NextTracksTextEntry:SetText("")
	pnl.NextTracksTextEntry.AllowInput = function(s,c)
		return !c:find("[%d,]")
	end
	
	pnl.PrevTracksLabel = vgui.Create("DLabel",pnl)
	pnl.PrevTracksLabel:Dock(TOP)
	pnl.PrevTracksLabel:SetText(L"tool.trolleytrafficeditor.ui.prevtracks")
	pnl.PrevTracksLabel:SetWrap(true)
	pnl.PrevTracksLabel:SetAutoStretchVertical(true)
	pnl.PrevTracksLabel:SetColor(color_black)
	
	local fix = vgui.Create("DPanel",pnl)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(0,0,0,5)
	
	pnl.PrevTracksTextEntry = vgui.Create("DTextEntry",fix)
	pnl.PrevTracksTextEntry:Dock(FILL)
	pnl.PrevTracksTextEntry:SetText("")
	pnl.PrevTracksTextEntry.AllowInput = function(s,c)
		return !c:find("[%d,]")
	end
	
	pnl.CreateRotation = vgui.Create("DButton",pnl)
	pnl.CreateRotation:Dock(TOP)
	pnl.CreateRotation:DockMargin(0,0,0,5)
	pnl.CreateRotation:SetText(L"tool.trolleytrafficeditor.ui.turn")
	pnl.CreateRotation:SetColor(color_black)
	pnl.CreateRotation.DoClick = function(s)
		net.Start("TrolleybusTrafficTrackEditor")
			net.WriteUInt(2,4)
		net.SendToServer()
	end
	
	pnl.RotationData = {Vector(),Vector()}
	
	pnl.RotationSegmentsSlider = vgui.Create("DNumSlider",pnl)
	pnl.RotationSegmentsSlider:Dock(TOP)
	pnl.RotationSegmentsSlider:DockMargin(0,0,0,5)
	pnl.RotationSegmentsSlider:SetText(L"tool.trolleytrafficeditor.ui.turnparts")
	pnl.RotationSegmentsSlider:SetMin(1)
	pnl.RotationSegmentsSlider:SetMax(10)
	pnl.RotationSegmentsSlider:SetDecimals(0)
	pnl.RotationSegmentsSlider:SetConVar("trolleytrafficeditor_rotation_segments")
	pnl.RotationSegmentsSlider.Label:SetColor(color_black)
	
	pnl.RotationCurvatureSlider = vgui.Create("DNumSlider",pnl)
	pnl.RotationCurvatureSlider:Dock(TOP)
	pnl.RotationCurvatureSlider:DockMargin(0,0,0,5)
	pnl.RotationCurvatureSlider:SetText(L"tool.trolleytrafficeditor.ui.turncurv")
	pnl.RotationCurvatureSlider:SetMin(1)
	pnl.RotationCurvatureSlider:SetMax(3)
	pnl.RotationCurvatureSlider:SetConVar("trolleytrafficeditor_rotation_curvature")
	pnl.RotationCurvatureSlider.Label:SetColor(color_black)
	
	pnl.LinkToLight = vgui.Create("DButton",pnl)
	pnl.LinkToLight:Dock(TOP)
	pnl.LinkToLight:DockMargin(0,0,0,5)
	pnl.LinkToLight:SetText(L"tool.trolleytrafficeditor.ui.lightlink")
	pnl.LinkToLight:SetColor(color_black)
	pnl.LinkToLight.DoClick = function(s)
		net.Start("TrolleybusTrafficTrackEditor")
			net.WriteUInt(4,4)
		net.SendToServer()
	end
	
	pnl.UnlinkFromLight = vgui.Create("DButton",pnl)
	pnl.UnlinkFromLight:Dock(TOP)
	pnl.UnlinkFromLight:DockMargin(0,0,0,5)
	pnl.UnlinkFromLight:SetText(L"tool.trolleytrafficeditor.ui.lightunlink")
	pnl.UnlinkFromLight:SetColor(color_black)
	pnl.UnlinkFromLight.DoClick = function(s)
		net.Start("TrolleybusTrafficTrackEditor")
			net.WriteUInt(5,4)
		net.SendToServer()
	end
	
	pnl.TurnSignalLeft = vgui.Create("DCheckBoxLabel",pnl)
	pnl.TurnSignalLeft:Dock(TOP)
	pnl.TurnSignalLeft:DockMargin(0,0,0,5)
	pnl.TurnSignalLeft:SetText(L"tool.trolleytrafficeditor.ui.turnsignalleft")
	pnl.TurnSignalLeft.OnChange = function(s,val)
		if val and pnl.TurnSignalRight:GetChecked() then
			pnl.TurnSignalRight:SetChecked(false)
		end
	end
	pnl.TurnSignalLeft:SetDark(true)
	
	pnl.TurnSignalRight = vgui.Create("DCheckBoxLabel",pnl)
	pnl.TurnSignalRight:Dock(TOP)
	pnl.TurnSignalRight:DockMargin(0,0,0,5)
	pnl.TurnSignalRight:SetText(L"tool.trolleytrafficeditor.ui.turnsignalright")
	pnl.TurnSignalRight.OnChange = function(s,val)
		if val and pnl.TurnSignalLeft:GetChecked() then
			pnl.TurnSignalLeft:SetChecked(false)
		end
	end
	pnl.TurnSignalRight:SetDark(true)
	
	pnl.LookAroundTracksLabel = vgui.Create("DLabel",pnl)
	pnl.LookAroundTracksLabel:Dock(TOP)
	pnl.LookAroundTracksLabel:SetText(L"tool.trolleytrafficeditor.ui.lookaroundtracks")
	pnl.LookAroundTracksLabel:SetWrap(true)
	pnl.LookAroundTracksLabel:SetAutoStretchVertical(true)
	pnl.LookAroundTracksLabel:SetColor(color_black)
	
	local fix = vgui.Create("DPanel",pnl)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(0,0,0,5)
	
	pnl.LookAroundTracks = vgui.Create("DTextEntry",fix)
	pnl.LookAroundTracks:Dock(FILL)
	pnl.LookAroundTracks:SetText("")
	pnl.LookAroundTracks.AllowInput = function(s,c)
		return !c:find("[%d,]")
	end
	pnl.LookAroundTracks.Think = function(s)
		s:SetEnabled(pnl.LookAroundBase:GetText()=="")
	end
	
	pnl.LookAroundBaseLabel = vgui.Create("DLabel",pnl)
	pnl.LookAroundBaseLabel:Dock(TOP)
	pnl.LookAroundBaseLabel:SetText(L"tool.trolleytrafficeditor.ui.lookaroundbase")
	pnl.LookAroundBaseLabel:SetWrap(true)
	pnl.LookAroundBaseLabel:SetAutoStretchVertical(true)
	pnl.LookAroundBaseLabel:SetColor(color_black)
	
	local fix = vgui.Create("DPanel",pnl)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(0,0,0,5)
	
	pnl.LookAroundBase = vgui.Create("DTextEntry",fix)
	pnl.LookAroundBase:Dock(FILL)
	pnl.LookAroundBase:SetText("")
	pnl.LookAroundBase.AllowInput = function(s,c)
		return !c:find("%d")
	end
	pnl.LookAroundBase.Think = function(s)
		s:SetEnabled(pnl.LookAroundTracks:GetText()=="")
	end
	
	pnl.MaxSpeedSlider = vgui.Create("DNumSlider",pnl)
	pnl.MaxSpeedSlider:Dock(TOP)
	pnl.MaxSpeedSlider:DockMargin(0,0,0,5)
	pnl.MaxSpeedSlider:SetText(L"tool.trolleytrafficeditor.ui.maxspeed")
	pnl.MaxSpeedSlider:SetDecimals(0)
	pnl.MaxSpeedSlider:SetMin(5)
	pnl.MaxSpeedSlider:SetMax(100)
	pnl.MaxSpeedSlider:SetConVar("trolleytrafficeditor_maxspeed")
	pnl.MaxSpeedSlider.Label:SetColor(color_black)

	pnl.SpawnChance = vgui.Create("DNumSlider",pnl)
	pnl.SpawnChance:Dock(TOP)
	pnl.SpawnChance:DockMargin(0,0,0,5)
	pnl.SpawnChance:SetText(L"tool.trolleytrafficeditor.ui.spawnchance")
	pnl.SpawnChance:SetDecimals(0)
	pnl.SpawnChance:SetMin(0)
	pnl.SpawnChance:SetMax(100)
	pnl.SpawnChance:SetConVar("trolleytrafficeditor_spawnchance")
	pnl.SpawnChance.Label:SetColor(color_black)

	pnl.WeightDirection = vgui.Create("DNumSlider",pnl)
	pnl.WeightDirection:Dock(TOP)
	pnl.WeightDirection:DockMargin(0,0,0,5)
	pnl.WeightDirection:SetText(L"tool.trolleytrafficeditor.ui.dirweight")
	pnl.WeightDirection:SetDecimals(0)
	pnl.WeightDirection:SetMin(0)
	pnl.WeightDirection:SetMax(100)
	pnl.WeightDirection:SetConVar("trolleytrafficeditor_dirweight")
	pnl.WeightDirection.Label:SetColor(color_black)

	pnl.NoService = vgui.Create("DCheckBoxLabel",pnl)
	pnl.NoService:Dock(TOP)
	pnl.NoService:DockMargin(0,0,0,5)
	pnl.NoService:SetText(L"tool.trolleytrafficeditor.ui.noservice")
	pnl.NoService:SetConVar("trolleytrafficeditor_noservice")
	pnl.NoService:SetDark(true)
end

net.Receive("TrolleybusTrafficTrackEditor",function(len)
	local cmd = net.ReadUInt(4)
	
	if cmd==0 then
		local isend = net.ReadBool()
		local pos = net.ReadVector()
		
		if IsValid(pnl) then
			if isend then
				pnl.EndPosTextEntry:SetText(pos.x.." "..pos.y.." "..pos.z)
			else
				pnl.StartPosTextEntry:SetText(pos.x.." "..pos.y.." "..pos.z)
			end
		end
	elseif cmd==1 then
		local id = net.ReadUInt(32)
		local track = Trolleybus_System.GetTrafficTracks()[id]
		
		if IsValid(pnl) and track then
			pnl.TrackIDTextEntry:SetText(id)
			pnl.StartPosTextEntry:SetText(track.Start.x.." "..track.Start.y.." "..track.Start.z)
			pnl.EndPosTextEntry:SetText(track.End.x.." "..track.End.y.." "..track.End.z)
			pnl.NextTracksTextEntry:SetText(table.concat(track.Next,","))
			pnl.PrevTracksTextEntry:SetText(table.concat(track.Prev,","))
			pnl.TurnSignalLeft:SetChecked(track.TurnSignal==1)
			pnl.TurnSignalRight:SetChecked(track.TurnSignal==2)
			pnl.LookAroundTracks:SetText(table.concat(track.Look or {},","))
			pnl.LookAroundBase:SetText(track.LookBase or "")
			pnl.MaxSpeedSlider:SetValue(math.Round((track.MaxSpeed or 500)/Trolleybus_System.UnitsPerMeter*3600/1000))
			pnl.SpawnChance:SetValue(track.SpawnChance or 100)
			pnl.WeightDirection:SetValue(track.DirWeight or 100)
			pnl.NoService:SetChecked(track.NoService)
		end
	elseif cmd==2 then
		if IsValid(pnl) then
			local id = tonumber(pnl.TrackIDTextEntry:GetText())
			
			if id then
				local t = Trolleybus_System.GetTrafficTracks()[id] or {}
				
				local p = string.Explode(" ",pnl.StartPosTextEntry:GetText())
				t.Start = Vector(tonumber(p[1]),tonumber(p[2]),tonumber(p[3]))
				
				local p = string.Explode(" ",pnl.EndPosTextEntry:GetText())
				t.End = Vector(tonumber(p[1]),tonumber(p[2]),tonumber(p[3]))
				
				t.Next = {}
				for k,v in ipairs(string.Explode(",",pnl.NextTracksTextEntry:GetText())) do
					table.insert(t.Next,tonumber(v))
				end
				
				t.Prev = {}
				for k,v in ipairs(string.Explode(",",pnl.PrevTracksTextEntry:GetText())) do
					table.insert(t.Prev,tonumber(v))
				end
				
				t.TurnSignal = pnl.TurnSignalLeft:GetChecked() and 1 or pnl.TurnSignalRight:GetChecked() and 2 or nil
				
				t.LookBase = tonumber(pnl.LookAroundBase:GetText())
				
				if !t.LookBase then
					local look = {}
					for k,v in ipairs(string.Explode(",",pnl.LookAroundTracks:GetText())) do
						table.insert(look,tonumber(v))
					end
					t.Look = #look>0 and look or nil
				else
					t.Look = nil
				end
				
				t.MaxSpeed = math.Round(math.Clamp(math.Round(pnl.MaxSpeedSlider:GetValue(),pnl.MaxSpeedSlider:GetDecimals()),pnl.MaxSpeedSlider:GetMin(),pnl.MaxSpeedSlider:GetMax())*1000/3600*Trolleybus_System.UnitsPerMeter)
				t.SpawnChance = math.Round(math.Clamp(pnl.SpawnChance:GetValue(),0,100))
				t.DirWeight = math.Round(math.Clamp(pnl.WeightDirection:GetValue(),0,100))
				t.NoService = pnl.NoService:GetChecked()
				
				net.Start("TrolleybusTrafficTrackEditor")
					net.WriteUInt(1,4)
					net.WriteUInt(id,32)
					net.WriteTable(t)
				net.SendToServer()
			end
		end
	elseif cmd==3 then
		local id = net.ReadUInt(32)
		local newid = net.ReadUInt(32)
		local track = Trolleybus_System.GetTrafficTracks()[id]
		
		if IsValid(pnl) and track then
			pnl.TrackIDTextEntry:SetText(newid)
			pnl.StartPosTextEntry:SetText(track.End.x.." "..track.End.y.." "..track.End.z)
			pnl.EndPosTextEntry:SetText("")
			pnl.NextTracksTextEntry:SetText("")
			pnl.PrevTracksTextEntry:SetText(id)
			pnl.TurnSignalLeft:SetChecked(false)
			pnl.TurnSignalRight:SetChecked(false)
			pnl.LookAroundTracks:SetText("")
			pnl.LookAroundBase:SetText("")
			pnl.MaxSpeedSlider:SetValue(math.Round((track.MaxSpeed or 500)/Trolleybus_System.UnitsPerMeter*3600/1000))
			pnl.SpawnChance:SetValue(track.SpawnChance or 100)
			pnl.WeightDirection:SetValue(track.DirWeight or 100)
			pnl.NoService:SetChecked(track.NoService)
		end
	elseif cmd==4 then
		local isend = net.ReadBool()
		local pos = net.ReadVector()
		
		if IsValid(pnl) then
			pnl.RotationData[isend and 2 or 1] = pos
		end
	elseif cmd==5 then
		local type = net.ReadUInt(2)
		local R = net.ReadBool()
	
		if IsValid(pnl) then
			net.Start("TrolleybusTrafficTrackEditor")
				net.WriteUInt(3,4)
				net.WriteUInt(type,2)
				net.WriteBool(R)
				net.WriteVector(pnl.RotationData[1])
				net.WriteVector(pnl.RotationData[2])
			net.SendToServer()
		end
	end
end)
