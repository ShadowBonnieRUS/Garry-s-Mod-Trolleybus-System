-- Copyright © Platunov I. M., 2020 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase

language.Add("tool.trolleyinformatoreditor.name",L"tool.trolleyinformatoreditor.name")
language.Add("tool.trolleyinformatoreditor.desc",L"tool.trolleyinformatoreditor.desc")

local pnl = controlpanel.Get("trolleyinformatoreditor")

function TOOL:DrawHUD()
end

function TOOL.BuildCPanel(panel)
	pnl = panel
	
	pnl.NewInf = vgui.Create("DButton",pnl)
	pnl.NewInf:Dock(TOP)
	pnl.NewInf:DockMargin(5,5,5,5)
	pnl.NewInf:SetText(L"tool.trolleyinformatoreditor.ui.new")
	pnl.NewInf.DoClick = function(s)
		local id = 1
		while Trolleybus_System.GetInformators()[id] do
			id = id+1
		end
	
		pnl.InfData:LoadInf({},id)
	end
	
	pnl.SelectInf = vgui.Create("DComboBox",pnl)
	pnl.SelectInf:Dock(TOP)
	pnl.SelectInf:DockMargin(0,5,5,15)
	pnl.SelectInf.Think = function(s)
		local data = Trolleybus_System.GetInformators()
		
		if data!=s.Infs then
			local selected = s:GetSelected()
		
			s.Infs = data
			s:Clear()
			
			for k,v in pairs(data) do
				s:AddChoice(k,k)
			end
			
			if !selected then
				s:SetValue(L"tool.trolleyinformatoreditor.ui.choose")
			end
		end
	end
	pnl.SelectInf.OnSelect = function(s,index,name,data)
		pnl.InfData:LoadInf(Trolleybus_System.GetInformators()[data],data)
	end
	
	local PlaySound = false
	
	pnl.InfData = vgui.Create("DForm",pnl)
	pnl.InfData:Dock(TOP)
	pnl.InfData:DockMargin(0,5,5,0)
	pnl.InfData:SetName(L"tool.trolleyinformatoreditor.ui.data")
	pnl.InfData.Items = {}
	pnl.InfData.LoadInf = function(s,data,id)
		if !data then return end
	
		if PlaySound and PlaySound!=true and IsValid(PlaySound) and PlaySound:GetState()==GMOD_CHANNEL_PLAYING then
			PlaySound:Stop()
		end
		
		PlaySound = false
	
		if !s.Loaded then
			s.Loaded = true
		
			local label = vgui.Create("DLabel",s)
			label:Dock(TOP)
			label:DockMargin(5,5,5,5)
			label:SetText(L"tool.trolleyinformatoreditor.ui.id")
			label:SetWrap(true)
			label:SetAutoStretchVertical(true)
			label:SetDark(true)
			label:SizeToContents()
			table.insert(s.Items,label)
			
			local fix = vgui.Create("DPanel",s)
			fix:Dock(TOP)
			fix:DockMargin(0,5,5,5)
			fix:SetTall(20)
			table.insert(s.Items,fix)
			
			s.ID = vgui.Create("DTextEntry",fix)
			s.ID:Dock(FILL)
			s.ID.AllowInput = function(s,c)
				return !c:find("%d")
			end
		
			local label = vgui.Create("DLabel",s)
			label:Dock(TOP)
			label:DockMargin(0,5,5,5)
			label:SetText(L"tool.trolleyinformatoreditor.ui.name")
			label:SetWrap(true)
			label:SetAutoStretchVertical(true)
			label:SetDark(true)
			label:SizeToContents()
			table.insert(s.Items,label)
			
			local p = vgui.Create("DPanel",s)
			p:Dock(TOP)
			p:DockMargin(0,5,5,5)
			p:SetTall(20)
			p.Paint = nil
			table.insert(s.Items,p)
			
			s.Name = vgui.Create("DTextEntry",p)
			s.Name:Dock(FILL)
			
			s.Save = vgui.Create("DButton",s)
			s.Save:Dock(TOP)
			s.Save:DockMargin(0,5,5,5)
			s.Save:SetText(L"tool.trolleyinformatoreditor.ui.save")
			s.Save.DoClick = function(b)
				local data = {
					name = s.Name:GetText(),
					playlines = {},
				}
				
				for k,v in ipairs(s.PlayLines.Items) do
					local pl = {
						name = v.Name:GetText(),
						inttext = #v.InteriorText:GetText()>0 and v.InteriorText:GetText() or nil,
						sounds = {},
					}
				
					data.playlines[k] = pl
					
					for k,v in ipairs(v.Sounds.Items) do
						pl.sounds[k] = {
							sound = v.Sound:GetText(),
							length = v.Length:GetValue(),
						}
					end
				end
			
				net.Start("TrolleybusInformatorEditor")
					net.WriteUInt(s.ID:GetValue(),8)
					net.WriteBool(true)
					net.WriteTable(data)
				net.SendToServer()
			end
			table.insert(s.Items,s.Save)
			
			s.Delete = vgui.Create("DButton",s)
			s.Delete:Dock(TOP)
			s.Delete:DockMargin(0,5,5,5)
			s.Delete:SetText(L"tool.trolleyinformatoreditor.ui.delete")
			s.Delete:SetColor(Color(200,0,0))
			s.Delete.DoClick = function(b)
				net.Start("TrolleybusInformatorEditor")
					net.WriteUInt(s.ID:GetValue(),8)
					net.WriteBool(false)
				net.SendToServer()
				
				s.Loaded = false
				for k,v in ipairs(s.Items) do
					v:Remove()
				end
				s.Items = {}
			end
			table.insert(s.Items,s.Delete)
			
			s.AddPlayLine = vgui.Create("DButton",s)
			s.AddPlayLine:Dock(TOP)
			s.AddPlayLine:DockMargin(0,5,5,5)
			s.AddPlayLine:SetText(L"tool.trolleyinformatoreditor.ui.addplayline")
			s.AddPlayLine.DoClick = function(b)
				s.PlayLines:AddPlayLine({})
			end
			table.insert(s.Items,s.AddPlayLine)
			
			s.PlayLines = vgui.Create("DForm",s)
			s.PlayLines:Dock(TOP)
			s.PlayLines:DockMargin(0,5,5,5)
			s.PlayLines:SetName(L"tool.trolleyinformatoreditor.ui.playlines")
			s.PlayLines.Items = {}
			s.PlayLines.AddPlayLine = function(s,data)
				local playline = vgui.Create("DForm",s)
				playline:Dock(TOP)
				playline:DockMargin(0,5,5,5)
				playline:SetZPos(table.insert(s.Items,playline))
				playline:SetName(playline:GetZPos())

				local move = vgui.Create("DPanel",playline)
				move:SetTall(20)
				move:Dock(TOP)
				move:DockMargin(5,5,5,5)

				local moveup = vgui.Create("DButton",move)
				moveup:SetText("↑")
				moveup.DoClick = function(b)
					local key = table.KeyFromValue(s.Items,playline)
					if key>1 then
						s.Items[key] = s.Items[key-1]
						s.Items[key-1] = playline

						s.Items[key]:SetZPos(key)
						s.Items[key]:SetName(key)
						playline:SetZPos(key-1)
						playline:SetName(key-1)

						s:InvalidateLayout()
					end
				end

				local movedown = vgui.Create("DButton",move)
				movedown:SetText("↓")
				movedown.DoClick = function(b)
					local key = table.KeyFromValue(s.Items,playline)
					if key<#s.Items then
						s.Items[key] = s.Items[key+1]
						s.Items[key+1] = playline

						s.Items[key]:SetZPos(key)
						s.Items[key]:SetName(key)
						playline:SetZPos(key+1)
						playline:SetName(key+1)

						s:InvalidateLayout()
					end
				end

				move.PerformLayout = function(s,w,h)
					moveup:SetPos(0,0)
					moveup:SetSize(w/2,h)
					movedown:SetPos(w/2,0)
					movedown:SetSize(w/2,h)
				end
				
				local label = vgui.Create("DLabel",playline)
				label:Dock(TOP)
				label:DockMargin(0,5,5,5)
				label:SetText(L"tool.trolleyinformatoreditor.ui.playlinename")
				label:SetWrap(true)
				label:SetAutoStretchVertical(true)
				label:SetDark(true)
				label:SizeToContents()
				
				local p = vgui.Create("DPanel",playline)
				p:Dock(TOP)
				p:DockMargin(0,5,5,5)
				p:SetTall(20)
				p.Paint = nil
				
				playline.Name = vgui.Create("DTextEntry",p)
				playline.Name:Dock(FILL)

				local label = vgui.Create("DLabel",playline)
				label:Dock(TOP)
				label:DockMargin(0,5,5,5)
				label:SetText(L"tool.trolleyinformatoreditor.ui.playlineinttext")
				label:SetWrap(true)
				label:SetAutoStretchVertical(true)
				label:SetDark(true)
				label:SizeToContents()
				
				local p = vgui.Create("DPanel",playline)
				p:Dock(TOP)
				p:DockMargin(0,5,5,5)
				p:SetTall(20)
				p.Paint = nil
				
				playline.InteriorText = vgui.Create("DTextEntry",p)
				playline.InteriorText:Dock(FILL)
				
				local remove = vgui.Create("DButton",playline)
				remove:Dock(TOP)
				remove:DockMargin(0,5,5,5)
				remove:SetText(L"tool.trolleyinformatoreditor.ui.removeplayline")
				remove.DoClick = function(b)
					playline:Remove()
					table.RemoveByValue(s.Items,playline)
					
					for k,v in ipairs(s.Items) do
						v:SetName(k)
					end
				end
				
				local addsound = vgui.Create("DButton",playline)
				addsound:Dock(TOP)
				addsound:DockMargin(0,5,5,5)
				addsound:SetText(L"tool.trolleyinformatoreditor.ui.playlineaddsound")
				addsound.DoClick = function(b)
					playline.Sounds:AddSound("")
				end
				
				playline.Sounds = vgui.Create("DForm",playline)
				playline.Sounds:SetName(L"tool.trolleyinformatoreditor.ui.playlinesounds")
				playline.Sounds:Dock(TOP)
				playline.Sounds:DockMargin(0,5,5,5)
				playline.Sounds.Items = {}
				playline.Sounds.AddSound = function(s,snd,length)
					local p = vgui.Create("DPanel",s)
					p:Dock(TOP)
					p:DockMargin(0,5,5,5)
					p:SetTall(40)
					p:SetZPos(table.insert(s.Items,p))
					
					local up = vgui.Create("DPanel",p)
					up:Dock(TOP)
					up:SetTall(20)
					
					local down = vgui.Create("DPanel",p)
					down:Dock(BOTTOM)
					down:SetTall(20)
					
					local remove = vgui.Create("DButton",up)
					remove:SetText("X")
					remove:SetWide(40)
					remove:Dock(RIGHT)
					remove.DoClick = function(b)
						p:Remove()
						table.RemoveByValue(s.Items,p)
					end

					local move = vgui.Create("DPanel",up)
					move:Dock(RIGHT)
					move:SetWide(40)
					
					local moveup = vgui.Create("DButton",move)
					moveup:SetText("↑")
					moveup:SetWide(20)
					moveup:Dock(LEFT)
					moveup.DoClick = function(b)
						local key = table.KeyFromValue(s.Items,p)
						if key>1 then
							s.Items[key] = s.Items[key-1]
							s.Items[key-1] = p

							s.Items[key]:SetZPos(key)
							p:SetZPos(key-1)

							s:InvalidateLayout()
						end
					end

					local movedown = vgui.Create("DButton",move)
					movedown:SetText("↓")
					movedown:SetWide(20)
					movedown:Dock(RIGHT)
					movedown.DoClick = function(b)
						local key = table.KeyFromValue(s.Items,p)
						if key<#s.Items then
							s.Items[key] = s.Items[key+1]
							s.Items[key+1] = p

							s.Items[key]:SetZPos(key)
							p:SetZPos(key+1)

							s:InvalidateLayout()
						end
					end
					
					local autolen = vgui.Create("DButton",down)
					autolen:SetText("Auto")
					autolen:SetWide(40)
					autolen:Dock(RIGHT)
					autolen.DoClick = function(b)
						local path = p.Sound:GetText()
					
						sound.PlayFile("sound/"..path,"noplay",function(snd,errid,err)
							if !IsValid(b) then return end
							
							if !snd then
								MsgC(Color(255,0,0),"Cannot load sound file "..path..". ErrID: "..errid..", Error: "..err.."\n")
								return
							end
							
							p.Length:SetValue(math.Round(snd:GetLength(),2))
						end)
					end
					
					local play = vgui.Create("DButton",down)
					play:SetText("Play")
					play:SetWide(40)
					play:Dock(RIGHT)
					play.DoClick = function(b)
						if PlaySound==true then return end
						
						local path = p.Sound:GetText()
						if path=="" then return end
						
						if PlaySound and IsValid(PlaySound) and PlaySound:GetState()==GMOD_CHANNEL_PLAYING then
							local spath = PlaySound:GetFileName():sub(7,-1)
						
							PlaySound:Stop()
							PlaySound = false
							
							if path==spath then return end
						end
						
						PlaySound = true
					
						sound.PlayFile("sound/"..path,"noplay",function(snd,errid,err)
							if !IsValid(b) then return end
						
							PlaySound = false
						
							if !snd then
								MsgC(Color(255,0,0),"Cannot load sound file "..path..". ErrID: "..errid..", Error: "..err.."\n")
								return
							end
							
							PlaySound = snd
							snd:Play()
						end)
					end
					
					p.Sound = vgui.Create("DTextEntry",up)
					p.Sound:Dock(FILL)
					p.Sound.PlaceholderText = L"tool.trolleyinformatoreditor.ui.playlinesoundpath"
					p.Sound:SetPlaceholderText(p.Sound.PlaceholderText)
					p.Sound:SetTooltip(p.Sound.PlaceholderText)
					
					p.Length = vgui.Create("DNumSlider",down)
					p.Length:Dock(FILL)
					p.Length:SetTall(20)
					p.Length:SetMin(0)
					p.Length:SetMax(30)
					p.Length:SetDecimals(2)
					p.Length:SetText(L"tool.trolleyinformatoreditor.ui.playlinesoundlen")
					p.Length:SetTooltip(p.Length:GetText())
					p.Length:SetDark(true)
					
					p.Sound:SetValue(snd)
					p.Length:SetValue(length)
				end
				
				playline.Name:SetText(data.name or "")
				playline.InteriorText:SetText(data.inttext or "")
				
				if data.sounds then
					for k,v in ipairs(data.sounds) do
						playline.Sounds:AddSound(v.sound,v.length)
					end
				end
			end
			table.insert(s.Items,s.PlayLines)
		end
		
		s.ID:SetText(id)
		
		s.Name:SetText(data.name or "")
		
		for k,v in pairs(s.PlayLines.Items) do
			v:Remove()
		end
		s.PlayLines.Items = {}
		
		if data.playlines then
			for k,v in ipairs(data.playlines) do
				s.PlayLines:AddPlayLine(v)
			end
		end
	end
	pnl.InfData.OnRemove = function(s)
		if PlaySound and PlaySound!=true and IsValid(PlaySound) and PlaySound:GetState()==GMOD_CHANNEL_PLAYING then
			PlaySound:Stop()
		end
	end
end
