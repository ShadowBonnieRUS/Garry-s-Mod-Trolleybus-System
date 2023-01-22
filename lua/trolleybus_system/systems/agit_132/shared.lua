-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

SYSTEM.Pos = Vector(181,6,-13.8)
SYSTEM.Ang = Angle(0,135,0)

SYSTEM.ButtonsHotKeys = {
	["Agit-132_Button1"] = {
		name = "system.agit132.btns.btn1",
		hotkey = KEY_MINUS,
	},
	["Agit-132_Button4"] = {
		name = "system.agit132.btns.btn4",
		hotkey = KEY_EQUAL,
	},
}

function SYSTEM:OnReload()
	self:Setup()
end

function SYSTEM:Setup()
	local bus = self.Trolleybus
	local pnlpos,pnlang = LocalToWorld(Vector(2.4,-3,1),angle_zero,self.Pos,self.Ang)
	
	bus:AddDynamicPanel("Agit-132",{
		pos = pnlpos,
		ang = pnlang,
		size = {7.75,2},
	})
	
	bus:AddDynamicOtherPanelEnt("Agit-132",{
		model = "models/trolleybus/agit_132.mdl",
		panel = {
			name = "Agit-132",
			pos = {0,0},
			drawscale = 150,
			draw2d = function(bus,drawscale,x,y)
				if self:IsActive() then
					self:DrawScreen(drawscale,x,y)
				end
			end
		},
		maxdrawdistance = 300,
		offset_pos = Vector(-2.4,3,-1),
	})
	
	local lamp = function(index,name,x,y,glow)
		bus:AddDynamicOtherPanelEnt(index,{
			name = name,
			model = "models/trolleybus/agit_132_lamp.mdl",
			panel = {
				name = "Agit-132",
				pos = {x,y},
				radius = 0.15,
			},
			maxdrawdistance = 200,
			offset_ang = Angle(90,0,0),
			think = function(bus,ent)
				ent:SetSkin(self:IsActive() and glow() and 1 or 0)
			end,
		})
	end
	
	lamp("Agit-132_Lamp1","system.agit132.lamps.lamp1",7.38,0.43,function() return self:IsPlaying() end)
	lamp("Agit-132_Lamp2","system.agit132.lamps.lamp2",7.38,0.99,function() return self:IsRouteState() or !self:IsPlaying() and CurTime()%0.66>0.33 end)
	lamp("Agit-132_Lamp3","system.agit132.lamps.lamp3",7.38,1.55,function() return true end)
	
	local btnmodel = function(skin)
		return {
			model = "models/trolleybus/agit_132_btn.mdl",
			offset_ang = Angle(90,0,0),
			poseparameter = "state",
			sounds = function(self,on)
				return on and "trolleybus/tumbler2_on.mp3" or "trolleybus/tumbler2_off.mp3",100
			end,
			maxdrawdistance = 200,
			initialize = function(bus,ent)
				ent:SetSkin(skin)
			end,
		}
	end
	
	bus:AddDynamicButton("Agit-132_Button1",{
		name = "system.agit132.btns.btn1",
		model = btnmodel(0),
		panel = {
			name = "Agit-132",
			pos = {0.63,0.59},
			radius = 0.4,
		},
		hotkey = KEY_MINUS,
		hotkey_system = "Agit-132",
		func = function(bus,on)
			if !on or !self:IsActive() then return end
		
			self:OnPlayButtonPressed()
		end,
	})
	bus:AddDynamicButton("Agit-132_Button4",{
		name = "system.agit132.btns.btn4",
		model = btnmodel(3),
		panel = {
			name = "Agit-132",
			pos = {1.57,0.59},
			radius = 0.4,
		},
		hotkey = KEY_EQUAL,
		hotkey_system = "Agit-132",
		func = function(bus,on)
			if !on or !self:IsActive() then return end
			
			self:OnEditButtonPressed()
		end,
	})
	bus:AddDynamicButton("Agit-132_Button2",{
		name = "system.agit132.btns.btn2",
		model = btnmodel(2),
		panel = {
			name = "Agit-132",
			pos = {0.63,1.38},
			radius = 0.4,
		},
		func = function(bus,on)
			if !on or !self:IsActive() then return end
			
			self:OnChangeButtonPressed(false)
		end,
	})
	bus:AddDynamicButton("Agit-132_Button3",{
		name = "system.agit132.btns.btn3",
		model = btnmodel(1),
		panel = {
			name = "Agit-132",
			pos = {1.57,1.38},
			radius = 0.4,
		},
		func = function(bus,on)
			if !on or !self:IsActive() then return end
			
			self:OnChangeButtonPressed(true)
		end,
	})
end

function SYSTEM:SetupUnload()
	local bus = self.Trolleybus
	
	bus:RemoveDynamicPanel("Agit-132")
	bus:RemoveDynamicOtherPanelEnt("Agit-132")
	bus:RemoveDynamicOtherPanelEnt("Agit-132_Lamp1")
	bus:RemoveDynamicOtherPanelEnt("Agit-132_Lamp2")
	bus:RemoveDynamicOtherPanelEnt("Agit-132_Lamp3")
	
	bus:RemoveDynamicButton("Agit-132_Button1")
	bus:RemoveDynamicButton("Agit-132_Button2")
	bus:RemoveDynamicButton("Agit-132_Button3")
	bus:RemoveDynamicButton("Agit-132_Button4")
	
	if CLIENT then bus:ReloadClientEnts() end
end

function SYSTEM:IsPlaying()
	return self:GetNWVar("Playing",false)
end

function SYSTEM:IsRouteState()
	return self:GetNWVar("State",false)
end

function SYSTEM:IsActive()
	return self:GetNWVar("Active",false)
end

function SYSTEM:GetRoute()
	return self:GetNWVar("Route",0)
end