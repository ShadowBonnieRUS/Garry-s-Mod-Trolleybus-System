-- Copyright © Platunov I. M., 2021 All rights reserved

Trolleybus_System.GUI = Trolleybus_System.GUI or {}

surface.CreateFont("Trolleybus_System.GUI.18",{
	font = "Calibri",
	extended = true,
	size = 18,
})

surface.CreateFont("Trolleybus_System.GUI.24",{
	font = "Calibri",
	extended = true,
	size = 24,
})

local function PaintBackground(s,w,h)
	surface.SetDrawColor(s.bgcolor)
	surface.DrawRect(0,0,w,h)
	
	surface.SetDrawColor(255,255,255)
	surface.DrawOutlinedRect(0,0,w,h)
end

Trolleybus_System.GUI.Frame = function(title,w,h)
	local frame = vgui.Create("DFrame")
	frame:ShowCloseButton(false)
	frame:SetSizable(true)
	frame:SetMinWidth(math.min(100,w))
	frame:SetMinHeight(math.min(100,h))
	frame:SetSize(w,h)
	frame:Center()
	frame:MakePopup()
	frame.Paint = function(s,w,h)
		PaintBackground(s,w,h)
	end
	frame.bgcolor = Color(0,0,0,200)
	frame.PerformLayout = function(s,w,h)
		s.close:SetPos(w-s.close:GetWide(),0)
		s.hide:SetPos(w-s.close:GetWide()-s.hide:GetWide()+1,0)
	end
	frame.lblTitle:SetFont("Trolleybus_System.GUI.24")
	frame.lblTitle:SetTextColor(color_white)
	frame:SetTitle(title)
	
	frame.close = vgui.Create("DButton",frame)
	frame.close:SetSize(30,26)
	frame.close:SetText("")
	frame.close.Paint = function(s,w,h)
		s.bgcolor.r = (s.Hovered or s.Depressed) and 255 or 200
		PaintBackground(s,w,h)
		
		surface.DrawLine(w/2-5,h/2-5,w/2+5,h/2+5)
		surface.DrawLine(w/2+5,h/2-5,w/2-5,h/2+5)
	end
	frame.close.bgcolor = Color(255,0,0)
	frame.close.DoClick = function(s)
		frame:Remove()
	end
	
	frame.hide = vgui.Create("DButton",frame)
	frame.hide:SetSize(30,26)
	frame.hide:SetText("")
	frame.hide.Paint = function(s,w,h)
		local c = s.Depressed and 100 or s.Hovered and 75 or 50
		s.bgcolor.r = c
		s.bgcolor.g = c
		s.bgcolor.b = c
		PaintBackground(s,w,h)
		
		surface.DrawLine(w/2-5,h/2,w/2+5,h/2)
	end
	frame.hide.bgcolor = Color(0,0,0)
	frame.hide.DoClick = function(s)
		frame:Hide()
	end
	
	return frame
end

Trolleybus_System.GUI.Scroll = function(parent)
	local scroll = vgui.Create("DScrollPanel",parent)
	scroll.Paint = function(s,w,h)
		PaintBackground(s,w,h)
	end
	scroll.bgcolor = Color(0,0,0,200)
	
	scroll.VBar.Paint = function(s,w,h)
		PaintBackground(s,w,h)
	end
	scroll.VBar.bgcolor = color_black
	
	scroll.VBar.btnUp.Paint = function(s,w,h)
		local c = (s.Hovered or s.Depressed) and 100 or 25
		s.bgcolor.r = c
		s.bgcolor.g = c
		s.bgcolor.b = c
		PaintBackground(s,w,h)
		
		surface.SetTexture(0)
		surface.DrawPoly({
			{x = w/2-4,y = h/2},
			{x = w/2,y = h/2-4},
			{x = w/2+4,y = h/2},
		})
	end
	scroll.VBar.btnUp.bgcolor = Color(0,0,0)
	
	scroll.VBar.btnDown.Paint = function(s,w,h)
		local c = (s.Hovered or s.Depressed) and 100 or 25
		s.bgcolor.r = c
		s.bgcolor.g = c
		s.bgcolor.b = c
		PaintBackground(s,w,h)
		
		surface.SetTexture(0)
		surface.DrawPoly({
			{x = w/2-4,y = h/2},
			{x = w/2+4,y = h/2},
			{x = w/2,y = h/2+4},
		})
	end
	scroll.VBar.btnDown.bgcolor = Color(0,0,0)
	
	scroll.VBar.btnGrip.Paint = function(s,w,h)
		local c = s.Depressed and 100 or s.Hovered and 50 or 35
		s.bgcolor.r = c
		s.bgcolor.g = c
		s.bgcolor.b = c
		PaintBackground(s,w,h)
		
		surface.DrawLine(w/2-4,h/2,w/2+4,h/2)
	end
	scroll.VBar.btnGrip.bgcolor = Color(0,0,0)
	
	return scroll
end

Trolleybus_System.GUI.Sheet = function(parent)
	local sheet = vgui.Create("DPanel",parent)
	sheet.Paint = nil
	
	local btns = vgui.Create("DPanel",sheet)
	btns:SetTall(25)
	btns.Paint = nil
	btns.Btns = {}
	btns.Offset = 0
	
	local pnls = vgui.Create("DPanel",sheet)
	pnls:Dock(FILL)
	pnls:DockMargin(0,25,0,0)
	pnls.Paint = nil
	pnls.Pnls = {}
	
	local activebtn
	
	sheet.AddSheet = function(s,name,defaultpanel)
		surface.SetFont("Trolleybus_System.GUI.18")
		local tw,th = surface.GetTextSize(name)
		
		local btn = Trolleybus_System.GUI.Button(btns,name)
		btn:SetFont("Trolleybus_System.GUI.18")
		btn:SetSize(5+tw+5,26)
		btn.DoClick = function(s)
			if activebtn then
				activebtn.Pnl:Hide()
				activebtn.bgcolor = Color(50,50,50)
			end
			
			activebtn = s
			
			s.Pnl:Show()
			s.bgcolor = Color(100,100,100)
		end
		
		local pnl
		if defaultpanel then
			pnl = vgui.Create("DPanel",pnls)
			pnl.Paint = function(s,w,h)
				PaintBackground(s,w,h)
			end
			pnl.bgcolor = Color(0,0,0,200)
		else
			pnl = Trolleybus_System.GUI.Scroll(pnls)
		end
		pnl:Hide()
		
		btn.Pnl = pnl
		
		btns.Btns[#btns.Btns+1] = btn
		pnls.Pnls[#pnls.Pnls+1] = pnl
		
		if !activebtn then btn:DoClick() end
		
		sheet:InvalidateLayout()
		
		return pnl
	end
	
	local function GetBtnLen()
		local btnlen = 0
		
		for k,v in ipairs(btns.Btns) do
			btnlen = btnlen+(k==1 and v:GetWide() or v:GetWide()-1)
		end
		
		return btnlen
	end
	
	sheet.PerformLayout = function(s,w,h)
		local len = GetBtnLen()
	
		if len>w then
			if !s.OffsetBtnLeft then
				s.OffsetBtnLeft = Trolleybus_System.GUI.Button(s,"")
				s.OffsetBtnLeft:SetSize(10,26)
				local p = s.OffsetBtnLeft.Paint
				s.OffsetBtnLeft.Paint = function(s,w,h)
					p(s,w,h)
					
					surface.SetDrawColor(255,255,255)
					surface.SetTexture(0)
					surface.DrawPoly({
						{x = w/2,y = h/2-4},
						{x = w/2,y = h/2+4},
						{x = w/2-4,y = h/2},
					})
					
					return true
				end
				s.OffsetBtnLeft.Think = function(s)
					if !s.Depressed then return end
					
					btns.Offset = math.max(btns.Offset-RealFrameTime()*200,0)
					btns:InvalidateLayout()
				end
				s.OffsetBtnLeft.bgcolored = true
				
				s.OffsetBtnRight = Trolleybus_System.GUI.Button(s,"")
				s.OffsetBtnRight:SetSize(10,26)
				local p = s.OffsetBtnRight.Paint
				s.OffsetBtnRight.Paint = function(s,w,h)
					p(s,w,h)
					
					surface.SetDrawColor(255,255,255)
					surface.SetTexture(0)
					surface.DrawPoly({
						{x = w/2,y = h/2-4},
						{x = w/2+4,y = h/2},
						{x = w/2,y = h/2+4},
					})
					
					return true
				end
				s.OffsetBtnRight.Think = function(s)
					if !s.Depressed then return end
				
					btns.Offset = math.min(btns.Offset+RealFrameTime()*200,GetBtnLen()-btns:GetWide())
					btns:InvalidateLayout()
				end
				s.OffsetBtnRight.bgcolored = true
			end
			
			s.OffsetBtnLeft:SetPos(0,0)
			s.OffsetBtnRight:SetPos(w-s.OffsetBtnRight:GetWide(),0)
			
			btns:SetPos(s.OffsetBtnLeft:GetWide(),0)
			btns:SetWide(w-s.OffsetBtnLeft:GetWide()-s.OffsetBtnRight:GetWide())
			btns.Offset = math.min(btns.Offset,len-btns:GetWide())
		else
			if s.OffsetBtnLeft then
				s.OffsetBtnLeft:Remove()
				s.OffsetBtnRight:Remove()
				
				s.OffsetBtnLeft = nil
				s.OffsetBtnRight = nil
			end
			
			btns:SetPos(0,0)
			btns:SetWide(w)
			btns.Offset = 0
		end
	end
	
	btns.PerformLayout = function(s,w,h)
		local len = 0
		
		for k,v in ipairs(s.Btns) do
			v:SetPos(len-s.Offset,0)
			
			len = len+v:GetWide()-1
		end
	end
	
	pnls.PerformLayout = function(s,w,h)
		for k,v in ipairs(s.Pnls) do
			v:SetPos(0,0)
			v:SetSize(w,h)
		end
	end
	
	return sheet
end

Trolleybus_System.GUI.Sheet2 = function(parent)
	local sheet = vgui.Create("DPanel",parent)
	sheet.Paint = nil
	
	local btns = Trolleybus_System.GUI.Scroll(sheet)
	btns:Dock(RIGHT)
	btns:SetWide(150)
	btns.Btns = {}
	
	local pnls = vgui.Create("DPanel",sheet)
	pnls:Dock(FILL)
	pnls.Paint = nil
	pnls.Pnls = {}
	
	local activebtn
	
	sheet.AddSheet = function(s,name,defaultpanel)
		local btn = Trolleybus_System.GUI.Button(btns,name)
		btn:SetFont("Trolleybus_System.GUI.18")
		btn:Dock(TOP)
		btn:SetTall(30)
		btn.DoClick = function(s)
			if activebtn then
				activebtn.Pnl:Hide()
				activebtn.bgcolor = Color(50,50,50)
			end
			
			activebtn = s
			
			s.Pnl:Show()
			s.bgcolor = Color(100,100,100)
		end
		
		local pnl
		if defaultpanel then
			pnl = vgui.Create("DPanel",pnls)
			pnl.Paint = function(s,w,h)
				PaintBackground(s,w,h)
			end
			pnl.bgcolor = Color(0,0,0,200)
		else
			pnl = Trolleybus_System.GUI.Scroll(pnls)
		end
		pnl:Hide()
		
		btn.Pnl = pnl
		
		btns.Btns[#btns.Btns+1] = btn
		pnls.Pnls[#pnls.Pnls+1] = pnl
		
		if !activebtn then btn:DoClick() end
		
		return pnl
	end
	
	pnls.PerformLayout = function(s,w,h)
		for k,v in ipairs(s.Pnls) do
			v:SetPos(0,0)
			v:SetSize(w,h)
		end
	end
	
	return sheet
end

Trolleybus_System.GUI.Button = function(parent,text)
	local btn = vgui.Create("DButton",parent)
	btn:SetText(text)
	btn.Paint = function(s,w,h)
		if s.bgcolored then
			local c = s.Depressed and 100 or s.Hovered and 50 or 25
			s.bgcolor.r = c
			s.bgcolor.g = c
			s.bgcolor.b = c
		end
		
		PaintBackground(s,w,h)
		
		if s:GetText()=="" then return true end
		
		surface.SetFont(s:GetFont())
		local tw,th = surface.GetTextSize(s:GetText())
		
		draw.DrawText(s:GetText(),s:GetFont(),w/2,h/2-th/2,color_white,1)
		
		return true
	end
	btn.bgcolor = Color(50,50,50)
	
	return btn
end

Trolleybus_System.GUI.Label = function(parent,font,text)
	local lbl = vgui.Create("DLabel",parent)
	lbl:SetText(text)
	lbl:SetFont(font)
	lbl:SetTextColor(color_white)
	lbl:SetWrap(true)
	lbl:SetAutoStretchVertical(true)
	
	return lbl
end

Trolleybus_System.GUI.Slider = function(parent,min,max,decimals)
	local slider = vgui.Create("DNumSlider",parent)
	slider:SetMinMax(min,max)
	slider:SetDecimals(decimals)
	
	local p = slider.PerformLayout
	slider.PerformLayout = function(s,w,h)
		p(s,w,h)
		
		s.Label:SetWide(0)
	end
	
	slider.TextArea:SetFont("Trolleybus_System.GUI.18")
	slider.TextArea.Paint = function(s,w,h)
		s:DrawTextEntryText(color_white,Color(0,0,100),color_white)
	end
	
	return slider
end

Trolleybus_System.GUI.CheckBox = function(parent,text,value)
	local checkbox = vgui.Create("DCheckBoxLabel",parent)
	checkbox:SetText(text)
	checkbox:SetChecked(value)
	checkbox.Label:SetFont("Trolleybus_System.GUI.18")
	checkbox.Label:SetTextColor(color_white)
	
	return checkbox
end

Trolleybus_System.GUI.Image = function(parent,isbutton)
	local img = vgui.Create(isbutton and "DButton" or "DPanel",parent)
	if isbutton then img:SetText("") end
	img.AspectType = 0
	img.Paint = function(s,w,h)
		surface.SetDrawColor(25,25,25)
		surface.DrawRect(0,0,w,h)
		
		if s.mat and !s.mat:IsError() then
			local tw,th = w,h
			
			if s.AspectType!=0 then
				local mw,mh = s.mat:Width(),s.mat:Height()
				local md = mw/mh
				local td = tw/th
				local mp = md>td and (s.AspectType==1 and tw/mw or th/mh) or (s.AspectType==1 and th/mh or tw/mw)
				
				tw = mw*mp
				th = mh*mp
			end
			
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(s.mat)
			surface.DrawTexturedRect(w/2-tw/2,h/2-th/2,tw,th)
		end
		
		surface.SetDrawColor(255,255,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	
	img.SetImage = function(s,mat)
		s.mat = mat
	end
	
	return img
end

Trolleybus_System.GUI.ComboBox = function(parent)
	local box = vgui.Create("DComboBox",parent)
	box.DropButton.Paint = nil
	box:SetFont("Trolleybus_System.GUI.18")
	box.Paint = function(s,w,h)
		local c = s.Depressed and 100 or s.Hovered and 50 or 25
		s.bgcolor.r = c
		s.bgcolor.g = c
		s.bgcolor.b = c
		
		PaintBackground(s,w,h)
		
		surface.SetTexture(0)
		surface.DrawPoly({
			{x = w-10-4,y = h/2-2},
			{x = w-10+4,y = h/2-2},
			{x = w-10,y = h/2+2},
		})
		
		if s:GetText()=="" then return true end
		
		surface.SetFont(s:GetFont())
		local tw,th = surface.GetTextSize(s:GetText())
		
		draw.DrawText(s:GetText(),s:GetFont(),w/2,h/2-th/2,color_white,1)
		
		return true
	end
	box.bgcolor = Color(50,50,50)
	
	return box
end

Trolleybus_System.GUI.Setting = function(parent,data)
	local pnl = vgui.Create("DPanel",parent)
	pnl.Paint = PaintBackground
	pnl.bgcolor = Color(50,50,50)

	local pnl2 = vgui.Create("DPanel",pnl)
	pnl2.Paint = PaintBackground
	pnl2.bgcolor = Color(30,30,30)
	pnl2:Dock(BOTTOM)
	pnl2:SetTall(70)
	pnl2:DockPadding(5,5,5,5)

	local btn = vgui.Create("DButton",pnl)
	btn:Dock(TOP)
	btn:SetTall(40)
	btn:DockPadding(5,5,5,5)
	btn.Paint = function(s,w,h)
		PaintBackground(s,w,h)
		return true
	end
	btn.bgcolor = Color(50,50,50)
	btn.DoClick = function(s)
		pnl.expand = !pnl.expand
	end

	pnl.Think = function(s)
		local dest = btn:GetTall()+(s.expand and pnl2:GetTall()-1 or 0)

		if s:GetTall()<dest then
			s:SetTall(math.min(dest,s:GetTall()+300*RealFrameTime()))
		elseif s:GetTall()>dest then
			s:SetTall(math.max(dest,s:GetTall()-300*RealFrameTime()))
		end
	end
	pnl:SetTall(btn:GetTall())

	local cval = vgui.Create("DLabel",btn)
	cval:SetContentAlignment(6)
	cval:SetTextColor(color_white)
	cval:Dock(RIGHT)
	cval.Think = function(s)
		s:SetText(s.val)
		s:SetFont(pnl.Title:GetFont())
		s:SizeToContentsX()
	end
	cval.val = ""

	pnl.Title = Trolleybus_System.GUI.Label(btn,"Trolleybus_System.GUI.24","")
	pnl.Title:Dock(TOP)
	
	pnl.Description = Trolleybus_System.GUI.Label(pnl2,"Trolleybus_System.GUI.18","")
	pnl.Description:Dock(TOP)

	local control = vgui.Create("DPanel",pnl2)
	control:DockMargin(10,0,0,0)
	control:Dock(FILL)
	control.Paint = nil

	pnl.Reset = Trolleybus_System.GUI.Button(control,"")
	pnl.Reset:SetWide(150)
	pnl.Reset:Dock(RIGHT)
	pnl.Reset.bgcolored = true

	pnl.OnChange = function(s,value) end

	if data.Type=="Slider" then
		pnl.Configurator = Trolleybus_System.GUI.Slider(control,data.Min,data.Max,data.Decimals)
		pnl.Configurator:Dock(FILL)
		pnl.Configurator.OnValueChanged = function(s,value)
			value = math.Clamp(math.Round(value,data.Decimals),data.Min,data.Max)

			cval.val = value
			pnl:OnChange(value)
		end
	elseif data.Type=="CheckBox" then
		pnl.Configurator = Trolleybus_System.GUI.CheckBox(control,"",false)
		pnl.Configurator:Dock(FILL)
		pnl.Configurator.OnChange = function(s,value) cval.val = value and "+" or "-" pnl:OnChange(value) end
	elseif data.Type=="ComboBox" then
		pnl.Configurator = Trolleybus_System.GUI.ComboBox(control)

		for k,v in ipairs(data.Options) do
			pnl.Configurator:AddChoice(v,k)
		end

		pnl.Configurator:Dock(FILL)
		pnl.Configurator.OnSelect = function(s,index,value,data) cval.val = value pnl:OnChange(data) end
	elseif data.Type=="ConCommand" then
		pnl.Reset:Remove()
		pnl.Description:Remove()
		
		pnl.Configurator = Trolleybus_System.GUI.Button(control,"")
		pnl.Configurator:Dock(FILL)
		pnl.Configurator.DoClick = function(s) RunConsoleCommand(data.Command,unpack(data.Args or {})) end
		pnl.Configurator.bgcolored = true
		pnl.Description = pnl.Configurator
	end
	
	pnl.SetValue = function(s,value)
		if data.Type=="Slider" then
			pnl.Configurator:SetValue(tonumber(value) or data.DefaultValue)
		elseif data.Type=="CheckBox" then
			pnl.Configurator:SetValue(tobool(value))
		elseif data.Type=="ComboBox" then
			pnl.Configurator:ChooseOptionID(math.Clamp(tonumber(value) or data.DefaultValue,1,#data.Options))
		end
	end

	pnl.Reset.DoClick = function(s)
		pnl:SetValue(data.DefaultValue)
	end

	pnl.Reset:DoClick()

	return pnl
end