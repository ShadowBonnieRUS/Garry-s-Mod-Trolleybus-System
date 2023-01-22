-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.Pos = Vector(262,23,30)
SYSTEM.Ang = Angle(0,180,0)

SYSTEM.ButtonsHotKeys = {
	["IR-2002_Button3"] = {
		name = "system.ir2002.btns.btn3",
		hotkey = KEY_MINUS,
	},
	["IR-2002_PlayButton"] = {
		name = "system.ir2002.btns.playbtn",
		hotkey = KEY_EQUAL,
	},
}

function SYSTEM:Initialize()
	self:Setup()
end

function SYSTEM:OnReload()
	self:Setup()
end

local L = Trolleybus_System.GetLanguagePhrase
local LN = Trolleybus_System.GetLanguagePhraseName

function SYSTEM:Setup()
	local bus = self.Trolleybus
	local mppos,mpang = Vector(-1.14,-1.25,2.57),Angle(-90,0,0)
	
	local p,a = LocalToWorld(mppos,mpang,self.Pos,self.Ang)
	bus:AddDynamicPanel("IR-2002_Main",{
		pos = p,
		ang = a,
		size = {2.4,4},
	})
	
	local p,a = LocalToWorld(Vector(1,2.23,1.85),Angle(0,90,0),self.Pos,self.Ang)
	bus:AddDynamicPanel("IR-2002_OnOffButton",{
		pos = p,
		ang = a,
		size = {1,1},
	})
	
	local p,a = LocalToWorld(Vector(-1,-9,2),Angle(0,0,0),self.Pos,self.Ang)
	bus:AddDynamicPanel("IR-2002_PlayButton",{
		pos = p,
		ang = a,
		size = {3,2},
	})
	
	bus:AddDynamicOtherPanelEnt("IR-2002",{
		name = "",
		dynamicname = function(bus)
			if !self:IsActive() then return end

			local route = Trolleybus_System.GetInformators()[self:GetRoute()]
			local prefix = "informator."..game.GetMap()..".route."
	
			if self:IsRouteState() then
				return L("system.ir2002.info.selectroute",self:GetRoute()).." - "..(route and LN(prefix,route.name) or L"system.ir2002.info.routeunavailable")
			elseif route then
				local playline = self:GetNWVar("Playline",1)
				local dt = route.playlines[playline]

				return L"system.ir2002.info.currentroute".." - "..LN(prefix,route.name).."\n"..L("system.ir2002.info.currentstop",playline,#route.playlines).." - "..(dt and LN("informator."..game.GetMap()..".playline.",dt.name) or "")
			end
		end,
		model = "models/trolleybus/ir2002/ir2002.mdl",
		panel = {
			name = "IR-2002_Main",
			pos = {0,0},
			size = {2.4,1},
			drawscale = 72,
			draw2d = function(bus,drawscale,x,y)
				self:DrawDigits(drawscale,x,y)
			end,
		},
		maxdrawdistance = 300,
		offset_pos = Vector(-mppos.z,-mppos.y,mppos.x),
		offset_ang = -mpang,
	})
	
	local btnmodel = {
		model = "models/trolleybus/ir2002/ir2002_button.mdl",
		offset_ang = Angle(90,0,0),
		offset_pos = Vector(0.05,0,0),
		anim = true,
		maxdrawdistance = 200,
	}
	local playbtn = {
		model = "models/trolleybus/ir2002/ir2002_playbutton.mdl",
		offset_ang = Angle(90,180,0),
		offset_pos = Vector(0.1,2.11,-1.07),
		anim = true,
		maxdrawdistance = 200,
	}
	local onoffbtn = {
		model = "models/trolleybus/ir2002/ir2002_toggle.mdl",
		offset_ang = Angle(0,90,90),
		anim = true,
		sounds = {
			On = {"trolleybus/tumbler2_on.mp3",100},
			Off = {"trolleybus/tumbler2_off.mp3",100},
		},
		maxdrawdistance = 200,
	}
	
	bus:AddDynamicButton("IR-2002_Button1",{
		name = "system.ir2002.btns.btn1",
		model = btnmodel,
		panel = {
			name = "IR-2002_Main",
			pos = {0.36,3.39},
			radius = 0.4,
		},
		func = function(bus,on)
			if !on then return end
			
			self:OnChangeButtonPressed(false)
		end,
	})
	bus:AddDynamicButton("IR-2002_Button2",{
		name = "system.ir2002.btns.btn2",
		model = btnmodel,
		panel = {
			name = "IR-2002_Main",
			pos = {1,3.39},
			radius = 0.4,
		},
		func = function(bus,on)
			if !on then return end
			
			self:OnChangeButtonPressed(true)
		end,
	})
	bus:AddDynamicButton("IR-2002_Button3",{
		name = "system.ir2002.btns.btn3",
		model = btnmodel,
		panel = {
			name = "IR-2002_Main",
			pos = {1.68,3.39},
			radius = 0.4,
		},
		hotkey = KEY_EQUAL,
		hotkey_system = "IR-2002",
		func = function(bus,on)
			if !on or !self:IsActive() then return end
			
			if self:IsRouteState() then
				local data = Trolleybus_System.GetInformators()[self:GetRoute()]
			
				if data then
					self:SetRouteState(false)
				
					self.CurrentData = {
						Playlines = data.playlines,
						CurrentPlayline = 1,
						CurrentSound = nil,
						CurrentSoundID = 1,
						Playing = false,
						PlayEndTime = 0,
					}
					
					self:SetNWVar("Playline",1)
				end
			else
				self:StopSound()
				self:SetRouteState(true)
			end
		end,
	})
	bus:AddDynamicButton("IR-2002_PlayButton",{
		name = "system.ir2002.btns.playbtn",
		model = playbtn,
		panel = {
			name = "IR-2002_PlayButton",
			pos = {0,0},
			size = {3,2},
		},
		hotkey = KEY_MINUS,
		hotkey_system = "IR-2002",
		func = function(bus,on)
			if !on or self:IsRouteState() or !self:IsActive() then return end
			
			local data = self.CurrentData
			if data.Playing then return end
			
			self:PlaySound()
		end,
	})
	bus:AddDynamicButton("IR-2002_OnOffButton",{
		name = "system.ir2002.btns.onoffbtn",
		model = onoffbtn,
		panel = {
			name = "IR-2002_OnOffButton",
			pos = {0.5,0.5},
			radius = 0.5,
		},
		toggle = true,
		func = function(bus,on)
			self:StopSound()
			self:SetActive(on)
			
			self:SetRouteState(true)
			self:SetRoute(0)
			
			self.CurrentData = nil
		end,
	})
end

function SYSTEM:SetupUnload()
	bus:RemoveDynamicPanel("IR-2002_Main")
	bus:RemoveDynamicPanel("IR-2002_OnOffButton")
	bus:RemoveDynamicPanel("IR-2002_PlayButton")
	bus:RemoveDynamicOtherPanelEnt("IR-2002")
	bus:RemoveDynamicButton("IR-2002_Button1")
	bus:RemoveDynamicButton("IR-2002_Button2")
	bus:RemoveDynamicButton("IR-2002_Button3")
	bus:RemoveDynamicButton("IR-2002_PlayButton")
	bus:RemoveDynamicButton("IR-2002_OnOffButton")
end

function SYSTEM:IsActive()
	return self:GetNWVar("Active",false)
end

function SYSTEM:IsRouteState()
	return self:GetNWVar("State",false)
end

function SYSTEM:GetRoute()
	return self:GetNWVar("Route",0)
end