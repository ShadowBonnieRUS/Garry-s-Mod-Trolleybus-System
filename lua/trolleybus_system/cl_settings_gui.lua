-- Copyright © Platunov I. M., 2021 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase
local AdminSettingCallback = function() end

surface.CreateFont("Trolleybus_System.Settings.18",{
	font = "Calibri",
	extended = true,
	size = 18,
})

surface.CreateFont("Trolleybus_System.Settings.20",{
	font = "Calibri",
	extended = true,
	size = 20,
})

surface.CreateFont("Trolleybus_System.Settings.22",{
	font = "Calibri",
	extended = true,
	size = 22,
})

Trolleybus_System.OpenSettings = function()
	if IsValid(Trolleybus_System.SettingsMenu) then
		if !Trolleybus_System.SettingsMenu:IsVisible() then
			Trolleybus_System.SettingsMenu:Show()
			
			return
		else
			Trolleybus_System.SettingsMenu:Remove()
		end
	end
	
	local menu = Trolleybus_System.GUI.Frame(L"settings",ScrW()*0.75,ScrH()*0.75)
	Trolleybus_System.SettingsMenu = menu
	
	local sheet = Trolleybus_System.GUI.Sheet2(menu)
	sheet:Dock(FILL)
	
	local systemsheet = sheet:AddSheet(L"settings.system",true)
	local system = Trolleybus_System.GUI.Sheet(systemsheet)
	system:Dock(FILL)
	
	local system_user = system:AddSheet(L"settings.system.user",true)
	system_user:DockPadding(5,5,5,5)
	
	local info = Trolleybus_System.GUI.Label(system_user,"Trolleybus_System.Settings.20",L"settings.system.user.info")
	info:Dock(TOP)
	info:DockMargin(0,0,0,20)
	
	local system_usersheet = Trolleybus_System.GUI.Sheet(system_user)
	system_usersheet:Dock(FILL)
	
	local system_user_client = system_usersheet:AddSheet(L"settings.system.user.client",false)
	
	local lbl = Trolleybus_System.GUI.Label(system_user_client,"Trolleybus_System.Settings.20",L"settings.system.user.client.info")
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,20)
	
	local function CreateUserClientSetting(setting)
		local data = Trolleybus_System.Settings[setting]
		local curval = Trolleybus_System.GetPlayerSetting(setting)

		local settingp = Trolleybus_System.GUI.Setting(system_user_client,data)
		settingp:Dock(TOP)
		settingp:DockMargin(5,5,5,10)
		settingp.Title:SetFont("Trolleybus_System.Settings.22")
		settingp.Title:SetText(L("settings.system.user.client."..setting:lower()))
		settingp.Description:SetFont("Trolleybus_System.Settings.18")
		settingp.Description:SetText(L("settings.system.user.client."..setting:lower().."_help"))
		settingp.Reset:SetFont("Trolleybus_System.Settings.20")
		settingp.Reset:SetText(L"settings.reset")

		if data.Type=="CheckBox" then settingp.Configurator:SetText(L"settings.checkbox") end

		settingp:SetValue(curval)

		settingp.OnChange = function(s,value)
			if !Trolleybus_System.Settings[setting] then return end
			
			Trolleybus_System.SettingsData[setting] = value
			file.Write("trolleybus_settings.txt",util.TableToJSON(Trolleybus_System.SettingsData))
		end
	end
	
	for k,v in SortedPairsByMemberValue(Trolleybus_System.Settings,"Order") do
		if !v.Network then
			CreateUserClientSetting(k)
		end
	end
	
	local system_user_network = system_usersheet:AddSheet(L"settings.system.user.network",false)
	
	local lbl = Trolleybus_System.GUI.Label(system_user_network,"Trolleybus_System.Settings.20",L"settings.system.user.network.info")
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,5)
	
	local SystemUserNetworkChanges = {}
	
	local save = Trolleybus_System.GUI.Button(system_user_network,L"settings.system.user.network.save")
	save:SetFont("Trolleybus_System.Settings.20")
	save:SetTall(30)
	save:Dock(TOP)
	save:DockMargin(5,5,5,20)
	save.DoClick = function(s)
		if table.IsEmpty(SystemUserNetworkChanges) then return end
		
		for k,v in pairs(SystemUserNetworkChanges) do
			if !Trolleybus_System.Settings[k] then continue end
			
			Trolleybus_System.SettingsData[k] = v
			
			net.Start("Trolleybus_System.PlayerSettings")
				net.WriteString(k)
				net.WriteType(v)
			net.SendToServer()
		end
		
		file.Write("trolleybus_settings.txt",util.TableToJSON(Trolleybus_System.SettingsData))
		SystemUserNetworkChanges = {}
	end
	save.bgcolored = true
	
	local function CreateUserNetworkSetting(setting)
		local data = Trolleybus_System.Settings[setting]
		local curval = Trolleybus_System.GetPlayerSetting(setting)
		
		local settingp = Trolleybus_System.GUI.Setting(system_user_network,data)
		settingp:Dock(TOP)
		settingp:DockMargin(5,5,5,10)
		settingp.Title:SetFont("Trolleybus_System.Settings.22")
		settingp.Title:SetText(L("settings.system.user.network."..setting:lower()))
		settingp.Description:SetFont("Trolleybus_System.Settings.18")
		settingp.Description:SetText(L("settings.system.user.network."..setting:lower().."_help"))
		settingp.Reset:SetFont("Trolleybus_System.Settings.20")
		settingp.Reset:SetText(L"settings.reset")

		if data.Type=="CheckBox" then settingp.Configurator:SetText(L"settings.checkbox") end

		settingp:SetValue(curval)

		settingp.OnChange = function(s,value)
			if !Trolleybus_System.Settings[setting] then return end
			
			SystemUserNetworkChanges[setting] = value
		end
	end
	
	for k,v in SortedPairsByMemberValue(Trolleybus_System.Settings,"Order") do
		if v.Network then
			CreateUserNetworkSetting(k)
		end
	end
	
	net.Start("Trolleybus_System.AdminSettings")
		net.WriteBool(false)
	net.SendToServer()
	
	local AdminSettingsSheet
	AdminSettingCallback = function()
		if !IsValid(system) then return end
		
		if AdminSettingsSheet then
			AdminSettingsSheet:Clear()
		end
		
		if net.ReadBool() then
			local values = net.ReadTable()
			
			if !AdminSettingsSheet then
				AdminSettingsSheet = system:AddSheet(L"settings.system.admin",false)
			end
			
			local lbl = Trolleybus_System.GUI.Label(AdminSettingsSheet,"Trolleybus_System.Settings.20",L"settings.system.admin.info")
			lbl:Dock(TOP)
			lbl:DockMargin(5,5,5,5)
			
			local update = Trolleybus_System.GUI.Button(AdminSettingsSheet,L"settings.system.admin.update")
			update:SetFont("Trolleybus_System.Settings.20")
			update:SetTall(30)
			update:Dock(TOP)
			update:DockMargin(5,5,5,5)
			update.DoClick = function(s)
				AdminSettingsSheet:Clear()
				
				net.Start("Trolleybus_System.AdminSettings")
					net.WriteBool(false)
				net.SendToServer()
			end
			update.bgcolored = true
			
			local send = Trolleybus_System.GUI.Button(AdminSettingsSheet,L"settings.system.admin.send")
			send:SetFont("Trolleybus_System.Settings.20")
			send:SetTall(30)
			send:Dock(TOP)
			send:DockMargin(5,5,5,20)
			send.DoClick = function(s)
				net.Start("Trolleybus_System.AdminSettings")
					net.WriteBool(true)
					net.WriteTable(values)
				net.SendToServer()
				
				AdminSettingsSheet:Clear()
			end
			send.bgcolored = true
			
			local function CreateAdminSetting(setting)
				local data = Trolleybus_System.AdminSettings[setting]
				local curval = values[setting]

				local settingp = Trolleybus_System.GUI.Setting(AdminSettingsSheet,data)
				settingp:Dock(TOP)
				settingp:DockMargin(5,5,5,10)
				settingp.Title:SetFont("Trolleybus_System.Settings.22")
				settingp.Title:SetText(L("settings.system.admin."..setting:lower()))
				settingp.Description:SetFont("Trolleybus_System.Settings.18")
				settingp.Description:SetText(L("settings.system.admin."..setting:lower().."_help"))
				settingp.Reset:SetFont("Trolleybus_System.Settings.20")
				settingp.Reset:SetText(L"settings.reset")

				if data.Type=="CheckBox" then settingp.Configurator:SetText(L"settings.checkbox") end

				settingp:SetValue(curval)

				settingp.OnChange = function(s,value)
					if !Trolleybus_System.AdminSettings[setting] then return end
					
					values[setting] = value
				end
			end
			
			for k,v in SortedPairsByMemberValue( Trolleybus_System.AdminSettings,"Order") do
				if values[k]!=nil or v.Type=="ConCommand" then
					CreateAdminSetting(k)
				end
			end
		else
			if AdminSettingsSheet then
				local lbl = Trolleybus_System.GUI.Label(AdminSettingsSheet,"Trolleybus_System.Settings.20",L"settings.system.admin.noaccess")
				lbl:Dock(TOP)
				lbl:DockMargin(5,5,5,0)
			end
		end
	end
	
	local controls = sheet:AddSheet(L"settings.controls",true)
	local lbl = Trolleybus_System.GUI.Label(controls,"Trolleybus_System.Settings.20",L"settings.controls.info")
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,20)
	
	local controlssheet = Trolleybus_System.GUI.Sheet(controls)
	controlssheet:Dock(FILL)
	
	local controls_general = controlssheet:AddSheet(L"settings.controls.general",false)
	
	local function CreateBindButton(parent,button,troll_or_sys,issystem)
		local p = vgui.Create("DPanel",parent)
		p:Dock(TOP)
		p:DockMargin(5,0,5,0)
		p:SetTall(50)
		p.Paint = function(s,w,h)
			surface.SetDrawColor(15,15,15)
			surface.DrawRect(0,0,w,h)
			
			surface.SetDrawColor(255,255,255)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		
		local curval = Trolleybus_System.Controls.Controls[button]
		local btndata
		
		if troll_or_sys then
			if issystem then
				btndata = Trolleybus_System.Systems[troll_or_sys].ButtonsHotKeys[button]
				curval = Trolleybus_System.Controls.Systems[troll_or_sys]
			else
				btndata = scripted_ents.GetStored(troll_or_sys).t.ButtonsData[button]
				curval = Trolleybus_System.Controls.Trolleybuses[troll_or_sys]
			end
			
			if curval and curval[button] then
				curval = curval[button]
			else
				curval = btndata.hotkey
			end
		end
		
		local defval = btndata and btndata.hotkey or Trolleybus_System.DefaultControls.Controls[button]
		
		local reset = Trolleybus_System.GUI.Button(p,L"settings.reset")
		reset:SetFont("Trolleybus_System.Settings.20")
		reset:Dock(RIGHT)
		reset:SetWide(100)
		reset.bgcolored = true
		
		local bind = vgui.Create("DButton",p)
		bind:Dock(RIGHT)
		bind:SetWide(150)
		bind.SetButtons = function(s,btns)
			s.Selecting = nil

			local oldbtns = s.btns

			s.btns = btns
			s:SetText(btns and btns!=0 and Trolleybus_System.ButtonsToString(btns) or "NONE")

			if s.OnChange and oldbtns!=btns then s:OnChange(btns) end
		end
		bind.DoClick = function(s)
			s.Selecting = {}
			s.ClearTrapping = false
			input.StartKeyTrapping()

			s:SetText("PRESS A KEY(s)")
		end
		bind.Think = function(s)
			if input.IsKeyTrapping() then
				if s.Selecting then
					local key = input.CheckKeyTrapping()

					if key then
						if key==KEY_ESCAPE then
							s:SetButtons(s.btns)
						else
							s.Selecting[#s.Selecting+1] = key
							input.StartKeyTrapping()
						end
					else
						for k,v in ipairs(s.Selecting) do
							if !input.IsButtonDown(v) then
								s.ClearTrapping = true

								s:SetButtons(s.Selecting)
								break
							end
						end
					end
				elseif s.ClearTrapping and input.CheckKeyTrapping() then
					s.ClearTrapping = false
				end
			end
		end
		bind.DoRightClick = function(s)
			s:SetButtons(0)
		end
		bind.OnKeyCodePressed = function(s,key)
			if s.Selecting and !table.HasValue(s.Selecting,key) then
				s.Selecting[#s.Selecting+1] = key
			end
		end
		bind.OnKeyCodeReleased = function(s,key)
			if s.Selecting and table.HasValue(s.Selecting,key) then
				s:SetButtons(s.Selecting)
			end
		end
		bind.Paint = function(s,w,h)
			local c = s.Depressed and 100 or s.Hovered and 50 or 25
			surface.SetDrawColor(c,c,c)
			surface.DrawRect(0,0,w,h)
			
			surface.SetDrawColor(255,255,255)
			surface.DrawOutlinedRect(0,0,w,h)
			
			draw.SimpleText(s:GetText(),"Trolleybus_System.Settings.20",w/2,h/2,color_white,1,1)
			
			return true
		end
		bind:SetButtons(curval)

		bind.OnChange = function(s,btns)
			if btns==def and troll_or_sys then
				btns = nil
			end
			
			if troll_or_sys then
				if issystem then
					Trolleybus_System.Controls.Systems[troll_or_sys] = Trolleybus_System.Controls.Systems[troll_or_sys] or {}
					Trolleybus_System.Controls.Systems[troll_or_sys][button] = btns
				else
					Trolleybus_System.Controls.Trolleybuses[troll_or_sys] = Trolleybus_System.Controls.Trolleybuses[troll_or_sys] or {}
					Trolleybus_System.Controls.Trolleybuses[troll_or_sys][button] = btns
				end
			else
				Trolleybus_System.Controls.Controls[button] = btns
			end
			
			file.Write("trolleybus_controls.txt",util.TableToJSON(Trolleybus_System.Controls))
			
			net.Start("Trolleybus_System_ClientControls")
				net.WriteTable(Trolleybus_System.Controls)
			net.SendToServer()
		end
		
		reset.DoClick = function(s)
			bind:SetButtons(defval)
		end
		
		local desc = btndata and btndata.name or "settings.controls.general."..button
		local name = Trolleybus_System.GUI.Label(p,"Trolleybus_System.Settings.20",L(desc))
		name:Dock(FILL)
		name:DockMargin(5,5,5,5)
	end
	
	for k,v in pairs(Trolleybus_System.DefaultControls.Controls) do
		CreateBindButton(controls_general,k)
	end
	
	local controls_trolls = controlssheet:AddSheet(L"settings.controls.trolleybuses",true)
	local controls_trollssheet = Trolleybus_System.GUI.Sheet2(controls_trolls)
	controls_trollssheet:Dock(FILL)
	
	local buses = {}
	
	for troll,data in pairs(scripted_ents.GetList()) do
		if Trolleybus_System.IsTrolleybusMetatable(data.t) then
			buses[#buses+1] = {troll,data.t,data.t.PrintName}
		end
	end
	
	for _,dt in SortedPairsByMemberValue(buses,3) do
		local ENT = dt[2]
		local sheet
		
		for k,v in pairs(ENT.ButtonsData) do
			if v.hotkey then
				if !sheet then
					sheet = controls_trollssheet:AddSheet(dt[3],false)
				end
				
				CreateBindButton(sheet,k,dt[1])
			end
		end
	end
	
	local controls_systems = controlssheet:AddSheet(L"settings.controls.systems",true)
	local controls_systemssheet = Trolleybus_System.GUI.Sheet2(controls_systems)
	controls_systemssheet:Dock(FILL)
	
	for system,data in SortedPairs(Trolleybus_System.Systems) do
		if data.ButtonsHotKeys then
			local sheet = controls_systemssheet:AddSheet(system,false)
			
			for k,v in pairs(data.ButtonsHotKeys) do
				CreateBindButton(sheet,k,system,true)
			end
		end
	end
	
	local bussettings = sheet:AddSheet(L"settings.bussettings",true)
	
	local updateinfo = Trolleybus_System.GUI.Label(bussettings,"Trolleybus_System.Settings.20",L"settings.bussettings.updateinfo")
	updateinfo:Dock(TOP)
	updateinfo:DockMargin(5,5,5,5)
	
	local update = Trolleybus_System.GUI.Button(bussettings,L"settings.bussettings.update")
	update:SetFont("Trolleybus_System.Settings.20")
	update:Dock(TOP)
	update:DockMargin(5,5,5,10)
	update:SetTall(30)
	update.DoClick = function(s)
		if s.wait or !LocalPlayer():InVehicle() then return end
		
		local bus = Trolleybus_System.GetSeatTrolleybus(LocalPlayer():GetVehicle())
		if !IsValid(bus) or !Trolleybus_System.PlayerInDriverPlace(bus,LocalPlayer()) then return end
		
		s:SetText("...")
		s.wait = true
		s.bgcolored = false
		s.bgcolor = Color(0,0,0)
		
		timer.Simple(1.5,function()
			if IsValid(s) then
				s:SetText(L"settings.bussettings.update")
				s.wait = false
				s.bgcolored = true
			end
		end)
		
		local class = bus:GetClass()
		
		net.Start("TrolleybusSystem_CreateBus")
			net.WriteBool(true)
			net.WriteString(class)
			
			if Trolleybus_System.TrolleybusSpawnSettings[class] then
				for k,v in pairs(Trolleybus_System.TrolleybusSpawnSettings[class]) do
					local id = k
					
					if isstring(id) then
						if !bus.SpawnSettings then continue end
						
						for k,v in ipairs(bus.SpawnSettings) do
							if v.alias==id then
								id = k
								
								break
							end
						end
						
						if isstring(id) then continue end
					end
					
					net.WriteUInt(id,8)
					net.WriteType(v)
				end
			end
			
			net.WriteUInt(0,8)
		net.SendToServer()
	end
	update.bgcolored = true
	
	local bussettings_sheet = Trolleybus_System.GUI.Sheet2(bussettings)
	bussettings_sheet:Dock(FILL)
	
	local function CreateSpawnSetting(parent,troll,setting,data)
		local curval = Trolleybus_System.TrolleybusSpawnSettings[troll]
		
		if curval then
			if data.alias and curval[data.alias]!=nil then
				curval = curval[data.alias]
			else
				curval = curval[setting]
			end

			if curval==nil then curval = data.default end
		else
			curval = data.default
		end
		
		local p = data.type=="Skin" and Trolleybus_System.GUI.Scroll(parent) or vgui.Create("DPanel",parent)
		p:Dock(TOP)
		p:DockMargin(5,5,5,5)
		p:DockPadding(5,5,5,5)
		p:SetTall(150)
		p.Paint = function(s,w,h)
			surface.SetDrawColor(25,25,25)
			surface.DrawRect(0,0,w,h)
			
			surface.SetDrawColor(255,255,255)
			surface.DrawOutlinedRect(0,0,w,h)
		end

		local configurators = {}

		p.OnChange = function(s,value)
			Trolleybus_System.TrolleybusSpawnSettings[troll] = Trolleybus_System.TrolleybusSpawnSettings[troll] or {}
			Trolleybus_System.TrolleybusSpawnSettings[troll][data.alias or setting] = value
			
			file.Write("trolleybus_bus_settings.txt",util.TableToJSON(Trolleybus_System.TrolleybusSpawnSettings))
		end

		local addconfigurator = function(skingroup,groupdata)
			local parent = skingroup and vgui.Create("DPanel",p) or p
			if skingroup then
				parent:Dock(TOP)
				parent:DockMargin(5,5,5,5)
				parent:SetTall(150)
				parent.Paint = nil
				parent.skingroup = skingroup

				local valitems = isstring(curval) and string.Explode("&",curval)
				
				for k,v in pairs(groupdata.skins) do
					if valitems and table.HasValue(valitems,skingroup.."="..k) then
						parent.skin = k
					end
				end
			end

			local preview
			if !data.nopreview and data.soundpreview then
				preview = vgui.Create("DImageButton",parent)
				preview:Dock(RIGHT)
				preview:DockMargin(5,0,0,0)
				preview:SetWide(140)
				preview:SetImage("icon32/muted.png")
				local paint = preview.Paint
				preview.Paint = function(s,w,h)
					surface.SetDrawColor(15,15,15)
					surface.DrawRect(0,0,w,h)
					
					paint(s,w,h)
					
					surface.SetDrawColor(255,255,255)
					surface.DrawOutlinedRect(0,0,w,h)
					
					return true
				end
				preview.SetupSound = function(s,value)
					if s.snd then
						s.snd:Stop()
						s:SetImage("icon32/muted.png")
					end
					s.snd = nil
					
					local snd
					
					if data.type=="CheckBox" then
						snd = Either(value,data.preview_on,data.preview_off)
					elseif data.type=="ComboBox" then
						if !isnumber(value) then
							for k,v in ipairs(data.choices) do
								if v.value==value then
									value = k
								end
							end
						end
						
						snd = data.choices[value] and data.choices[value].preview
					elseif data.type=="Slider" then
						snd = data.preview
					end
					
					if snd then
						s.snd = data.type=="Slider" and snd(value) or CreateSound(LocalPlayer(),snd)
					end
				end
				preview:SetupSound(curval)
				preview.DoClick = function(s)
					if s.snd then
						if s.snd:IsPlaying() then
							s.snd:Stop()
							s:SetImage("icon32/muted.png")
						else
							s.snd:Play()
							s:SetImage("icon32/unmuted.png")
						end
					end
				end
				preview.OnRemove = function(s)
					if s.snd then s.snd:Stop() end
				end
			elseif !data.nopreview then
				preview = Trolleybus_System.GUI.Image(parent,true)
				preview:Dock(RIGHT)
				preview:DockMargin(5,0,0,0)
				preview:SetWide(140)
				preview.AspectType = 0
				preview.SetupImage = function(s,value)
					local img = "vgui/avatar_default"
					
					if data.type=="CheckBox" then
						img = Either(value,data.preview_on,data.preview_off) or img
					elseif data.type=="ComboBox" then
						if !isnumber(value) then
							for k,v in ipairs(data.choices) do
								if v.value==value then
									value = k
								end
							end
						end
						
						img = data.choices[value] and data.choices[value].preview or img
					elseif data.type=="Slider" then
						img = data.preview and data.preview[1] or img
					elseif data.type=="Skin" then
						img = groupdata.skins[value] and groupdata.skins[value].preview or img
					end
					
					local mat = Material(img,"smooth")
					
					if data.type=="Slider" and data.preview and data.preview[1] and mat and !mat:IsError() then
						local fr = (math.Clamp(tonumber(value) or data.default,data.min,data.max)-data.min)/(data.max-data.min)
						local frame = math.Round(data.preview[2]+(data.preview[3]-data.preview[2])*fr)
						
						mat:SetInt("$frame",math.Clamp(frame,data.preview[2],data.preview[3]))
					end
					
					s:SetImage(mat)
				end
				preview:SetupImage(Either(data.type=="Skin",parent.skin,curval))
				
				preview.DoClick = function(s)
					if !s.mat or s.mat:IsError() then return end
					
					local w,h = s.mat:Width(),s.mat:Height()
					local dpl,dpt,dpr,dpb = 5,30,5,5
					
					local fw,fh = w+dpl+dpr,h+dpt+dpb
					
					if fw>ScrW() or fh>ScrH() then
						local mp = fw/fh>ScrW()/ScrH() and ScrW()/fw or ScrH()/fh
						
						fw = fw*mp
						fh = fh*mp
					end
					
					local fr = Trolleybus_System.GUI.Frame(L"settings.bussettings.previewtitle",fw,fh)
					fr.hide:Hide()
					fr:DockPadding(dpl,dpt,dpr,dpb)
					
					local img = Trolleybus_System.GUI.Image(fr)
					img:Dock(FILL)
					img:SetImage(s.mat)
					img.AspectType = 1
				end
			end

			local lblp = vgui.Create("DPanel",parent)
			lblp:Dock(TOP)
			lblp:DockMargin(0,0,5,5)
			lblp:SetTall(70)
			lblp.Paint = nil
			
			local lbl = Trolleybus_System.GUI.Label(lblp,"Trolleybus_System.Settings.22",L(skingroup or data.name))
			lbl:Dock(FILL)
			
			local reset = Trolleybus_System.GUI.Button(parent,L"settings.reset")
			reset:SetFont("Trolleybus_System.Settings.18")
			reset:Dock(RIGHT)
			reset:DockMargin(5,0,0,0)
			reset:SetWide(150)
			reset.bgcolored = true
			
			local onchange = function(value)
				if preview and data.soundpreview then
					preview:SetupSound(value)
				elseif preview then
					preview:SetupImage(value)
				end

				if data.type=="Skin" then
					parent.skin = value

					local values = {}
					for k,v in ipairs(configurators) do
						if v.skin then
							values[#values+1] = v.skingroup.."="..v.skin
						end
					end

					value = table.concat(values,"&")
				end

				p:OnChange(value)
			end
			
			local configurator
			if data.type=="CheckBox" then
				configurator = Trolleybus_System.GUI.CheckBox(parent,L"settings.checkbox",tobool(curval))
				configurator:Dock(FILL)
				configurator:SetChecked(tobool(curval))
				configurator.OnChange = function(s,value) onchange(value) end
				reset.DoClick = function(s) configurator:SetValue(data.default) end
			elseif data.type=="Slider" then
				configurator = Trolleybus_System.GUI.Slider(parent,data.min,data.max,data.decimals or 0)
				configurator:Dock(FILL)
				configurator:SetValue(tonumber(curval) or data.default)
				configurator.OnValueChanged = function(s,value) onchange(value) end
				reset.DoClick = function(s) configurator:SetValue(data.default) end
			elseif data.type=="ComboBox" then
				configurator = Trolleybus_System.GUI.ComboBox(parent)
				configurator:Dock(FILL)
				
				configurator.AddChoice = function(self,value,data,select)
					local i = table.insert(self.Choices,value)
					
					if data!=nil then self.Data[i] = data end
					if select then self:ChooseOption(value,i) end
					
					return i
				end
				
				for k,v in ipairs(data.choices) do
					local val = Either(v.value==nil,k,v.value)
					configurator:AddChoice(k..". "..L(v.name),val,curval==val)
				end
				
				configurator.OnSelect = function(s,index,name,value) onchange(value) end
				reset.DoClick = function(s) configurator:ChooseOptionID(data.default) end
			elseif data.type=="Skin" then
				configurator = Trolleybus_System.GUI.ComboBox(parent)
				configurator:Dock(FILL)

				for k,v in ipairs(groupdata.seq) do
					local skindata = groupdata.skins[v]

					configurator:AddChoice(k..". "..L(skindata.name),v,parent.skin==v,nil)
				end

				configurator.OnSelect = function(s,index,name,value) onchange(value) end
				reset.DoClick = function(s) configurator:ChooseOptionID(1) end
			end

			configurators[#configurators+1] = parent
		end

		if data.type=="Skin" then
			local lbl = Trolleybus_System.GUI.Label(p,"Trolleybus_System.Settings.22",skingroup or L(data.name))
			lbl:Dock(TOP)
			lbl:DockMargin(5,5,5,5)

			local skins = Trolleybus_System.TrolleybusSkins
			local skintypeskins = skins and skins[data.skintype]

			for group,groupdata in pairs(skintypeskins or {}) do
				addconfigurator(group,groupdata)
			end
		else
			addconfigurator()
		end
	end
	
	for _,dt in SortedPairsByMemberValue(buses,3) do
		local ENT = dt[2]
		
		if ENT.SpawnSettings then
			local sheet = bussettings_sheet:AddSheet(dt[3],false)
			
			for k,v in ipairs(ENT.SpawnSettings) do
				CreateSpawnSetting(sheet,dt[1],k,v)
			end
		end
	end
	
	local externaldevices = sheet:AddSheet(L"settings.externaldevices",true)
	local info = Trolleybus_System.GUI.Label(externaldevices,"Trolleybus_System.Settings.20",L"settings.externaldevices.info")
	info:Dock(TOP)
	info:DockMargin(5,5,5,10)
	
	local externaldevices_panel = vgui.Create("DPanel",externaldevices)
	externaldevices_panel:Dock(FILL)
	externaldevices_panel.Paint = nil
	
	local function ReloadExternalDevicesPanel()
		externaldevices_panel:Clear()
		
		if Trolleybus_System.DeviceInputModule.ModuleLoaded() then
			local settings = Trolleybus_System.DeviceInputModule.GetSettings()
			
			local update = Trolleybus_System.GUI.Button(externaldevices_panel,L"settings.externaldevices.updatedevices")
			update:SetFont("Trolleybus_System.Settings.20")
			update:Dock(TOP)
			update:DockMargin(5,5,5,10)
			update:SetTall(30)
			update.DoClick = function(s)
				Trolleybus_System.DeviceInputModule.UpdateDevices()
				ReloadExternalDevicesPanel()
			end
			update.bgcolored = true
			
			local sheet = Trolleybus_System.GUI.Sheet(externaldevices_panel)
			sheet:Dock(FILL)
			
			local function CreateAdjustmentPanel(parent,type)
				local devicelbl = Trolleybus_System.GUI.Label(parent,"Trolleybus_System.Settings.20",L"settings.externaldevices.selectdevice")
				devicelbl:Dock(TOP)
				devicelbl:DockMargin(5,5,5,5)
				
				local deviceselect = Trolleybus_System.GUI.ComboBox(parent)
				deviceselect:Dock(TOP)
				deviceselect:DockMargin(5,5,5,10)
				deviceselect:SetTall(30)
				
				for k,v in ipairs(Trolleybus_System.DeviceInputModule.GetDevices()) do
					deviceselect:AddChoice(v:GetName(),v,v:GetGUID()==settings[
						type==0 and "Steer" or
						type==1 and "StartPedal" or
						type==2 and "BrakePedal"
					])
				end
				
				local inputlbl = Trolleybus_System.GUI.Label(parent,"Trolleybus_System.Settings.20",L"settings.externaldevices.selectinput")
				inputlbl:Dock(TOP)
				inputlbl:DockMargin(5,5,5,5)
				
				local inputselect = Trolleybus_System.GUI.ComboBox(parent)
				inputselect:Dock(TOP)
				inputselect:DockMargin(5,5,5,10)
				inputselect:SetTall(30)
				inputselect.UpdateInputs = function(s)
					s:Clear()
					
					local _,device = deviceselect:GetSelected()
					if !IsValid(device) then return end
					
					for k,v in ipairs(device:GetAxles()) do
						s:AddChoice(v:GetName(),{id = k,input = v},k==settings[
							type==0 and "SteerObject" or
							type==1 and "StartPedalObject" or
							type==2 and "BrakePedalObject"
						])
					end
					
					s.OnSelect = function(s,index,name,data)
						if !IsValid(device) then return end
						
						settings[
							type==0 and "SteerObject" or
							type==1 and "StartPedalObject" or
							type==2 and "BrakePedalObject"
						] = data.id
						
						Trolleybus_System.DeviceInputModule.SaveSettings()
						Trolleybus_System.DeviceInputModule.PushSettingsData()
					end
				end
				inputselect:UpdateInputs()
				
				deviceselect.OnSelect = function(s,index,name,device)
					settings[
						type==0 and "Steer" or
						type==1 and "StartPedal" or
						type==2 and "BrakePedal"
					] = IsValid(device) and device:GetGUID() or nil
					
					Trolleybus_System.DeviceInputModule.SaveSettings()
					Trolleybus_System.DeviceInputModule.PushSettingsData()
					
					inputselect:UpdateInputs()
				end
				
				local info = Trolleybus_System.GUI.Label(parent,"Trolleybus_System.Settings.20",
					type==0 and L"settings.externaldevices.adjustment_steer" or
					type==1 and L"settings.externaldevices.adjustment_startpedal" or
					type==2 and L"settings.externaldevices.adjustment_brakepedal"
				)
				info:Dock(TOP)
				info:DockMargin(5,5,5,10)
				
				local cur = Trolleybus_System.GUI.Label(parent,"Trolleybus_System.Settings.20","")
				cur:Dock(TOP)
				cur:DockMargin(5,5,5,15)
				cur.Think = function(s)
					local _,device = deviceselect:GetSelected()
					local value
					
					if IsValid(device) then
						local _,inputdata = inputselect:GetSelected()
						local input = inputdata and inputdata.input
						
						if IsValid(input) then
							value = input:GetState()
						end
					end
					
					if value then
						s:SetText(L("settings.externaldevices.adjustment_cur",value))
					else
						s:SetText(L"settings.externaldevices.adjustment_connectionlost")
					end
				end
				
				local p = vgui.Create("DPanel",parent)
				p.Paint = nil
				p:Dock(TOP)
				p:DockMargin(5,5,5,10)
				p:SetTall(30)
				
				local updatemin = Trolleybus_System.GUI.Button(p,L"settings.externaldevices.adjustment_update")
				updatemin:SetFont("Trolleybus_System.Settings.18")
				updatemin:Dock(RIGHT)
				updatemin:SetWide(150)
				updatemin.bgcolored = true
				
				local min = Trolleybus_System.GUI.Label(p,"Trolleybus_System.Settings.20",L("settings.externaldevices.adjustment_min",
					type==0 and (settings.SteerMin or 0) or
					type==1 and (settings.StartPedalMin or 0) or
					type==2 and (settings.BrakePedalMin or 0)
				))
				min:Dock(FILL)
				min:DockMargin(0,5,5,5)
				
				updatemin.DoClick = function(s)
					local _,device = deviceselect:GetSelected()
					local value
					
					if IsValid(device) then
						local _,inputdata = inputselect:GetSelected()
						local input = inputdata and inputdata.input
						
						if IsValid(input) then
							value = input:GetState()
						end
					end
					
					if value then
						settings[
							type==0 and "SteerMin" or
							type==1 and "StartPedalMin" or
							type==2 and "BrakePedalMin"
						] = value
						
						Trolleybus_System.DeviceInputModule.SaveSettings()
						
						min:SetText(L("settings.externaldevices.adjustment_min",value))
					else
						min:SetText(L"settings.externaldevices.adjustment_connectionlost")
					end
				end
				
				local p = vgui.Create("DPanel",parent)
				p.Paint = nil
				p:Dock(TOP)
				p:DockMargin(5,5,5,5)
				p:SetTall(30)
				
				local updatemax = Trolleybus_System.GUI.Button(p,L"settings.externaldevices.adjustment_update")
				updatemax:SetFont("Trolleybus_System.Settings.18")
				updatemax:Dock(RIGHT)
				updatemax:SetWide(150)
				updatemax.bgcolored = true
				
				local max = Trolleybus_System.GUI.Label(p,"Trolleybus_System.Settings.20",L("settings.externaldevices.adjustment_max",
					type==0 and (settings.SteerMax or 0) or
					type==1 and (settings.StartPedalMax or 0) or
					type==2 and (settings.BrakePedalMax or 0)
				))
				max:Dock(FILL)
				max:DockMargin(0,5,5,5)
				
				updatemax.DoClick = function(s)
					local _,device = deviceselect:GetSelected()
					local value
					
					if IsValid(device) then
						local _,inputdata = inputselect:GetSelected()
						local input = inputdata and inputdata.input
						
						if IsValid(input) then
							value = input:GetState()
						end
					end
					
					if value then
						settings[
							type==0 and "SteerMax" or
							type==1 and "StartPedalMax" or
							type==2 and "BrakePedalMax"
						] = value
						
						Trolleybus_System.DeviceInputModule.SaveSettings()
						
						max:SetText(L("settings.externaldevices.adjustment_max",value))
					else
						max:SetText(L"settings.externaldevices.adjustment_connectionlost")
					end
				end
			end
			
			local steersheet = sheet:AddSheet(L"settings.externaldevices.steer",false)
			CreateAdjustmentPanel(steersheet,0)
			
			local startpedalsheet = sheet:AddSheet(L"settings.externaldevices.startpedal",false)
			CreateAdjustmentPanel(startpedalsheet,1)
			
			local brakepedalsheet = sheet:AddSheet(L"settings.externaldevices.brakepedal",false)
			CreateAdjustmentPanel(brakepedalsheet,2)
			
			local buttonssheet = sheet:AddSheet(L"settings.externaldevices.buttons",false)
			
			local devicelbl = Trolleybus_System.GUI.Label(buttonssheet,"Trolleybus_System.Settings.20",L"settings.externaldevices.selectdevice")
			devicelbl:Dock(TOP)
			devicelbl:DockMargin(5,5,5,5)
			
			local deviceselect = Trolleybus_System.GUI.ComboBox(buttonssheet)
			deviceselect:Dock(TOP)
			deviceselect:DockMargin(5,5,5,10)
			deviceselect:SetTall(30)
			
			for k,v in ipairs(Trolleybus_System.DeviceInputModule.GetDevices()) do
				deviceselect:AddChoice(v:GetName(),v,v:GetGUID()==settings.Buttons)
			end
			
			deviceselect.OnSelect = function(s,index,name,device)
				settings.Buttons = IsValid(device) and device:GetGUID() or nil
				Trolleybus_System.DeviceInputModule.SaveSettings()
			end
			
			local function CreateBindButton(button)
				local p = vgui.Create("DPanel",buttonssheet)
				p:Dock(TOP)
				p:DockMargin(5,0,5,0)
				p:SetTall(50)
				p.Paint = function(s,w,h)
					surface.SetDrawColor(15,15,15)
					surface.DrawRect(0,0,w,h)
					
					surface.SetDrawColor(255,255,255)
					surface.DrawOutlinedRect(0,0,w,h)
				end
				
				local reset = Trolleybus_System.GUI.Button(p,L"settings.reset")
				reset:SetFont("Trolleybus_System.Settings.20")
				reset:Dock(RIGHT)
				reset:SetWide(100)
				reset.bgcolored = true
				
				local bind = Trolleybus_System.GUI.Button(p,"")
				bind:SetFont("Trolleybus_System.Settings.20")
				bind:Dock(RIGHT)
				bind:SetWide(150)
				bind.bgcolored = true
				bind.SetButton = function(s,btn)
					local _,device = deviceselect:GetSelected()
					if !IsValid(device) then btn = nil end
					
					local object = btn and device:GetButtons()[btn]
					if !IsValid(object) then btn = nil end
					
					s.btn = btn
					s:SetText(btn and object:GetName():upper() or "NONE")
				end
				bind:SetButton(settings["Buttons_"..button])
				bind.DoClick = function(s)
					if !s.Selecting then
						local _,device = deviceselect:GetSelected()
						
						if IsValid(device) then
							s.Selecting = true
							s.SelDevice = device
							s.SelObjects = device:GetButtons()
							s.SelObjStates = {}
							s.SelMouse = input.IsMouseDown(MOUSE_LEFT)
							
							for k,v in ipairs(s.SelObjects) do
								s.SelObjStates[k] = v:GetButtonState()
							end
							
							s:SetText("PRESS A KEY")
						end
					end
				end
				bind.Think = function(s)
					if s.Selecting then
						s.SelMouse = s.SelMouse and input.IsMouseDown(MOUSE_LEFT)
						
						if !IsValid(s.SelDevice) or vgui.GetHoveredPanel()!=s or !s.SelMouse and input.IsMouseDown(MOUSE_LEFT) or input.IsKeyDown(KEY_ESCAPE) then
							s.Selecting = false
							s:SetButton(s.btn)
						else
							for k,v in ipairs(s.SelObjects) do
								if !IsValid(v) then continue end
								
								if v:GetButtonState()!=s.SelObjStates[k] then
									s.Selecting = false
									s:SetButton(k)
									
									settings["Buttons_"..button] = k
									
									Trolleybus_System.DeviceInputModule.SaveSettings()
									Trolleybus_System.DeviceInputModule.PushSettingsData()
									
									break
								end
							end
						end
					end
				end
				
				reset.DoClick = function(s)
					bind:SetButton()
					
					settings["Buttons_"..button] = nil
					
					Trolleybus_System.DeviceInputModule.SaveSettings()
					Trolleybus_System.DeviceInputModule.PushSettingsData()
				end
				
				local lbl = Trolleybus_System.GUI.Label(p,"Trolleybus_System.Settings.18",L("settings.externaldevices.button_"..button:lower()))
				lbl:Dock(FILL)
				lbl:DockMargin(5,5,5,5)
			end
			
			for k,v in pairs(Trolleybus_System.ExternalButtons) do
				CreateBindButton(k)
			end
		else
			local lbl = Trolleybus_System.GUI.Label(externaldevices_panel,"Trolleybus_System.Settings.20",L"settings.externaldevices.modulenotloaded")
			lbl:Dock(TOP)
			lbl:DockMargin(5,5,5,10)
			
			local load = Trolleybus_System.GUI.Button(externaldevices_panel,L"settings.externaldevices.loadmodule")
			load:SetFont("Trolleybus_System.Settings.20")
			load:Dock(TOP)
			load:DockMargin(5,5,5,5)
			load:SetTall(30)
			load.DoClick = function(s)
				local s,e = Trolleybus_System.DeviceInputModule.LoadModule()
				
				if s then
					Trolleybus_System.DeviceInputModule.UpdateDevices()
					ReloadExternalDevicesPanel()
				else
					lbl:SetText(L("settings.externaldevices.loadfailed",e))
				end
			end
			load.bgcolored = true
		end
	end
	ReloadExternalDevicesPanel()
end

net.Receive("Trolleybus_System.AdminSettings",function(len)
	AdminSettingCallback()
end)

hook.Add("PopulateToolMenu","Trolleybus_System.Settings",function()
	spawnmenu.AddToolMenuOption("Utilities",L"settings.spawnmenu.category","Trolleybus_System_Settings",L"settings.spawnmenu.title","","",function(pnl)
		pnl:Button(L"settings.spawnmenu.open","trolleybus_settings")
	end)
end)

concommand.Add("trolleybus_settings",function(ply,cmd,args,str)
	Trolleybus_System.OpenSettings()
end)