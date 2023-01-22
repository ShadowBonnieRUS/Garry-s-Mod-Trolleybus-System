-- Copyright © Platunov I. M., 2021 All rights reserved

local L = SERVER and function() end or Trolleybus_System.GetLanguagePhrase

function Trolleybus_System:TrolleybusSystem_RegisterTrafficLightTypes(lighttypes,addlense)
	lighttypes["default"] = {
		Name = L"trafficlight_type_default",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		OtherParts = {
			Base = 1,
		
			{"models/trolleybus/trafficlight/post1.mdl",Vector(9.3,0,94),Angle()},
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	lighttypes["default_black"] = {
		Name = L"trafficlight_type_default_black",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		OtherParts = {
			Base = 1,
		
			{"models/trolleybus/trafficlight/post2.mdl",Vector(8.3,0,93),Angle()},
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	lighttypes["default_left"] = {
		Name = L"trafficlight_type_default_left",
		Model = "models/trolleybus/trafficlight/1segmenttrafficlight.mdl",
		Lenses = {
			{Vector(0,0,0),Angle(0,0,0),0.25,"noarrowleft"},
		},
		PartOfLight = {
			["default"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
			["default_black"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
			["default_nocolumn"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_768_short"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_768"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_512_short"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_512"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_256"] = {
				{Vector(0,-11.5,0),Angle(0,0,0)},
			},
		},
		OtherParts = {
			{"models/trolleybus/trafficlight/connector.mdl",Vector(0,0,0),Angle()},
		},
	}
	lighttypes["default_right"] = {
		Name = L"trafficlight_type_default_right",
		Model = "models/trolleybus/trafficlight/1segmenttrafficlight.mdl",
		Lenses = {
			{Vector(0,0,0),Angle(0,0,0),0.25,"noarrowright"},
		},
		PartOfLight = {
			["default"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
			["default_black"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
			["default_nocolumn"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_768_short"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_768"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_512_short"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_512"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
			["default_horcolumn_256"] = {
				{Vector(0,11.5,0),Angle(0,0,0)},
			},
		},
		OtherParts = {
			{"models/trolleybus/trafficlight/connector.mdl",Vector(0,-11.5,0),Angle()},
		},
	}
	lighttypes["default_nocolumn"] = {
		Name = L"trafficlight_type_default_nocolumn",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		PartOfLight = {
			["default"] = {
				{Vector(-9.3,9.3,0),Angle(0,90,0)},
				{Vector(-9.3,-9.3,0),Angle(0,-90,0)},
				{Vector(-18.6,0,0),Angle(0,180,0)},
			},
			["default_black"] = {
				{Vector(-9.3,9.3,0),Angle(0,90,0)},
				{Vector(-9.3,-9.3,0),Angle(0,-90,0)},
				{Vector(-18.6,0,0),Angle(0,180,0)},
			},
			["default_horcolumn_768_short"] = {
				{Vector(-23,0,0),Angle(0,180,0)},
			},
			["default_horcolumn_768"] = {
				{Vector(-23,0,0),Angle(0,180,0)},
				{Vector(0,-896,0),Angle(0,0,0)},
				{Vector(-23,-896,0),Angle(0,180,0)},
			},
			["default_horcolumn_512_short"] = {
				{Vector(-23,0,0),Angle(0,180,0)},
			},
			["default_horcolumn_512"] = {
				{Vector(-23,0,0),Angle(0,180,0)},
				{Vector(0,-640,0),Angle(0,0,0)},
				{Vector(-23,-640,0),Angle(0,180,0)},
			},
			["default_horcolumn_256"] = {
				{Vector(-23,0,0),Angle(0,180,0)},
				{Vector(0,-384,0),Angle(0,0,0)},
				{Vector(-23,-384,0),Angle(0,180,0)},
			},
		},
		OtherParts = {
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	
	lighttypes["default_horizontal3"] = {
		Name = L"trafficlight_type_default_horizontal3",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight_horizontal.mdl",
		Lenses = {
			{Vector(0,-11,0),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,11,0),Angle(0,0,0),0.25,"nolense"},
		},
		PartOfLight = {
			["default_horcolumn_768_short"] = {
				{Vector(-2.5,-180,166.5),Angle(0,0,0)},
				{Vector(-2.5,-270,166.5),Angle(0,0,0)},
				{Vector(-2.5,-360,166.5),Angle(0,0,0)},
				{Vector(-20.5,-180,166.5),Angle(0,180,0)},
				{Vector(-20.5,-270,166.5),Angle(0,180,0)},
				{Vector(-20.5,-360,166.5),Angle(0,180,0)},
			},
			["default_horcolumn_768"] = {
				{Vector(-2.5,-180,166.5),Angle(0,0,0)},
				{Vector(-2.5,-270,166.5),Angle(0,0,0)},
				{Vector(-2.5,-360,166.5),Angle(0,0,0)},
				{Vector(-20.5,-180,166.5),Angle(0,180,0)},
				{Vector(-20.5,-270,166.5),Angle(0,180,0)},
				{Vector(-20.5,-360,166.5),Angle(0,180,0)},
				{Vector(-2.5,-896+180,166.5),Angle(0,0,0)},
				{Vector(-2.5,-896+270,166.5),Angle(0,0,0)},
				{Vector(-2.5,-896+360,166.5),Angle(0,0,0)},
				{Vector(-20.5,-896+180,166.5),Angle(0,180,0)},
				{Vector(-20.5,-896+270,166.5),Angle(0,180,0)},
				{Vector(-20.5,-896+360,166.5),Angle(0,180,0)},
			},
			["default_horcolumn_512_short"] = {
				{Vector(-2.5,-150,166.5),Angle(0,0,0)},
				{Vector(-2.5,-240,166.5),Angle(0,0,0)},
				{Vector(-20.5,-150,166.5),Angle(0,180,0)},
				{Vector(-20.5,-240,166.5),Angle(0,180,0)},
			},
			["default_horcolumn_512"] = {
				{Vector(-2.5,-150,166.5),Angle(0,0,0)},
				{Vector(-2.5,-240,166.5),Angle(0,0,0)},
				{Vector(-20.5,-150,166.5),Angle(0,180,0)},
				{Vector(-20.5,-240,166.5),Angle(0,180,0)},
				{Vector(-2.5,-640+150,166.5),Angle(0,0,0)},
				{Vector(-2.5,-640+240,166.5),Angle(0,0,0)},
				{Vector(-20.5,-640+150,166.5),Angle(0,180,0)},
				{Vector(-20.5,-640+240,166.5),Angle(0,180,0)},
			},
			["default_horcolumn_256"] = {
				{Vector(-2.5,-150,166.5),Angle(0,0,0)},
				{Vector(-20.5,-150,166.5),Angle(0,180,0)},
				{Vector(-2.5,-384+150,166.5),Angle(0,0,0)},
				{Vector(-20.5,-384+150,166.5),Angle(0,180,0)},
			},
		},
		OtherParts = {
			{"models/trolleybus/trafficlight/standholdertrafficlight_horizontal.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	lighttypes["default_horizontal1"] = {
		Name = L"trafficlight_type_default_horizontal1",
		Model = "models/trolleybus/trafficlight/1segmenttrafficlight_horizontal.mdl",
		Lenses = {
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
	}
	
	lighttypes["default_horcolumn_768_short"] = {
		Name = L"trafficlight_type_default_horcolumn_768_short",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		ToolPosOffset = Vector(0,-448,0),
		ToolAngOffset = Angle(0,-90,0),
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		OtherParts = {
			Base = 1,
			
			{"models/trolleybus/trafficlight/trafficlightpost_768_short_horizontal.mdl",Vector(-448,11.5,94),Angle(0,90,0)},
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	lighttypes["default_horcolumn_768"] = {
		Name = L"trafficlight_type_default_horcolumn_768",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		ToolPosOffset = Vector(0,-448,0),
		ToolAngOffset = Angle(0,-90,0),
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		OtherParts = {
			Base = 1,
			
			{"models/trolleybus/trafficlight/trafficlightpost_768_horizontal.mdl",Vector(-448,11.5,94),Angle(0,90,0)},
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	lighttypes["default_horcolumn_512_short"] = {
		Name = L"trafficlight_type_default_horcolumn_512_short",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		ToolPosOffset = Vector(0,-320,0),
		ToolAngOffset = Angle(0,-90,0),
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		OtherParts = {
			Base = 1,
			
			{"models/trolleybus/trafficlight/trafficlightpost_512_short_horizontal.mdl",Vector(-320,11.5,94),Angle(0,90,0)},
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	lighttypes["default_horcolumn_512"] = {
		Name = L"trafficlight_type_default_horcolumn_512",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		ToolPosOffset = Vector(0,-320,0),
		ToolAngOffset = Angle(0,-90,0),
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		OtherParts = {
			Base = 1,
			
			{"models/trolleybus/trafficlight/trafficlightpost_512_horizontal.mdl",Vector(-320,11.5,94),Angle(0,90,0)},
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	lighttypes["default_horcolumn_256"] = {
		Name = L"trafficlight_type_default_horcolumn_256",
		Model = "models/trolleybus/trafficlight/3segmenttrafficlight.mdl",
		ToolPosOffset = Vector(0,-192,0),
		ToolAngOffset = Angle(0,-90,0),
		Lenses = {
			{Vector(0,0,22),Angle(0,0,0),0.25,"nolense"},
			{Vector(0,0,11),Angle(0,0,0),0.25,"ylensef"},
			{Vector(0,0,0),Angle(0,0,0),0.25,"nolense"},
		},
		OtherParts = {
			Base = 1,
			
			{"models/trolleybus/trafficlight/trafficlightpost_256_horizontal.mdl",Vector(-192,11.5,94),Angle(0,90,0)},
			{"models/trolleybus/trafficlight/standholder.mdl",Vector(0,0,0),Angle(0,0,0)},
		},
	}
	
	local COLOR_RED			= Color(255,0,0)
	local COLOR_YELLOW		= Color(255,200,0)
	local COLOR_GREEN		= Color(0,255,120)
	
	local TIMER_DISTANCE	= 300^2
	local LIGHT_SIZE		= 100
	local LIGHT_SIZE_ARROW	= 50
	
	local Allowed = {
		"default","default_black","default_left","default_right","default_nocolumn","default_horizontal3",
		"default_horizontal1","default_horcolumn_768_short","default_horcolumn_768","default_horcolumn_512_short",
		"default_horcolumn_512","default_horcolumn_256",
	}
	
	addlense("nolense",{
		Name = L"trafficlight_lense_nolense",
		Categories = {"default","nolense"},
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,1}},
		},
	})
	addlense("noarrowleft",{
		Name = L"trafficlight_lense_noarrowleft",
		Categories = {"default","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,3}},
		},
	})
	addlense("noarrowright",{
		Name = L"trafficlight_lense_noarrowright",
		Categories = {"default","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,2}},
		},
	})
	addlense("rlense",{
		Name = L"trafficlight_lense_redlense",
		Categories = {"default","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,1},Skin = 1},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rlense",pos+ang:Forward()*6,ang,LIGHT_SIZE,COLOR_RED,1)
		end,
	})
	addlense("rarrowleft",{
		Name = L"trafficlight_lense_redarrowleft",
		Categories = {"default","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 1,BG = {0,3}},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowleft",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_RED,1)
		end,
	})
	addlense("rarrowright",{
		Name = L"trafficlight_lense_redarrowright",
		Categories = {"default","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 1,BG = {0,2}},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowright",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_RED,1)
		end,
	})
	addlense("ylense",{
		Name = L"trafficlight_lense_yellowlense",
		Categories = {"default","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,1},Skin = 2},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("ylense",pos+ang:Forward()*6,ang,LIGHT_SIZE,COLOR_YELLOW,1)
		end,
	})
	addlense("ylensef",{
		Name = L"trafficlight_lense_yellowlensef",
		Categories = {"default","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,1},Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 2 or 0)
			end},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("ylensef",pos+ang:Forward()*6,ang,LIGHT_SIZE,COLOR_YELLOW,1)
			end
		end,
	})
	addlense("yarrowleft",{
		Name = L"trafficlight_lense_yellowarrowleft",
		Categories = {"default","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 2,BG = {0,3}},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowleft",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
		end,
	})
	addlense("yarrowleftf",{
		Name = L"trafficlight_lense_yellowarrowleftf",
		Categories = {"default","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,3},Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 2 or 0)
			end},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("yarrowleftf",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
			end
		end,
	})
	addlense("yarrowright",{
		Name = L"trafficlight_lense_yellowarrowright",
		Categories = {"default","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 2,BG = {0,2}},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowright",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
		end,
	})
	addlense("yarrowrightf",{
		Name = L"trafficlight_lense_yellowarrowrightf",
		Categories = {"default","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,2},Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 2 or 0)
			end},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("yarrowrightf",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
			end
		end,
	})
	addlense("rtimerlense",{
		Name = L"trafficlight_lense_rtimerlense",
		Categories = {"default","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 1,Update = function(self,ent)
				if Trolleybus_System.EyePos():DistToSqr(self:GetPos())>=TIMER_DISTANCE then
					ent:SetBodygroup(2,0)
					ent:SetBodygroup(3,0)
					
					return
				end
			
				local t = math.ceil(self:GetTime()-CurTime())
				if t<=0 then t = 0 end
				if t>99 then t = 99 end
				
				ent:SetBodygroup(2,1+t%10)
				ent:SetBodygroup(3,1+math.floor(t/10))
			end},
		},
		DrawOffsetPos = Vector(6,0,0),
		DrawTranslucent = function(self)
			if Trolleybus_System.EyePos():DistToSqr(self:GetPos())<TIMER_DISTANCE then return end
			
			local t = math.ceil(self:GetTime()-CurTime())
			if t<=0 then t = 0 end
			if t>99 then t = 99 end
			
			draw.SimpleText((t<10 and "0" or "")..t,"TrolleybusTrafficLightTimer",0,0,COLOR_RED,1,1)
		end,
	})
	addlense("timerlense",{
		Name = L"trafficlight_lense_timerlense",
		Categories = {"default","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 2,Update = function(self,ent)
				if Trolleybus_System.EyePos():DistToSqr(self:GetPos())>=TIMER_DISTANCE then
					ent:SetBodygroup(2,0)
					ent:SetBodygroup(3,0)
					
					return
				end
			
				local t = math.ceil(self:GetTime()-CurTime())
				if t<=0 then t = 0 end
				if t>99 then t = 99 end
				
				ent:SetBodygroup(2,1+t%10)
				ent:SetBodygroup(3,1+math.floor(t/10))
			end},
		},
		DrawOffsetPos = Vector(6,0,0),
		DrawTranslucent = function(self)
			if Trolleybus_System.EyePos():DistToSqr(self:GetPos())<TIMER_DISTANCE then return end
			
			local t = math.ceil(self:GetTime()-CurTime())
			if t<=0 then t = 0 end
			if t>99 then t = 99 end
			
			draw.SimpleText((t<10 and "0" or "")..t,"TrolleybusTrafficLightTimer",0,0,COLOR_YELLOW,1,1)
		end,
	})
	addlense("gtimerlense",{
		Name = L"trafficlight_lense_gtimerlense",
		Categories = {"default","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 3,Update = function(self,ent)
				if Trolleybus_System.EyePos():DistToSqr(self:GetPos())>=TIMER_DISTANCE then
					ent:SetBodygroup(2,0)
					ent:SetBodygroup(3,0)
					
					return
				end
			
				local t = math.ceil(self:GetTime()-CurTime())
				if t<=0 then t = 0 end
				if t>99 then t = 99 end
				
				ent:SetBodygroup(2,1+t%10)
				ent:SetBodygroup(3,1+math.floor(t/10))
			end},
		},
		DrawOffsetPos = Vector(6,0,0),
		DrawTranslucent = function(self)
			if Trolleybus_System.EyePos():DistToSqr(self:GetPos())<TIMER_DISTANCE then return end
			
			local t = math.ceil(self:GetTime()-CurTime())
			if t<=0 then t = 0 end
			if t>99 then t = 99 end
			
			draw.SimpleText((t<10 and "0" or "")..t,"TrolleybusTrafficLightTimer",0,0,COLOR_GREEN,1,1)
		end,
	})
	addlense("glense",{
		Name = L"trafficlight_lense_greenlense",
		Categories = {"default","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,1},Skin = 3},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("glense",pos+ang:Forward()*6,ang,LIGHT_SIZE,COLOR_GREEN,1)
		end,
	})
	addlense("glensef",{
		Name = L"trafficlight_lense_greenlensef",
		Categories = {"default","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,1},Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("glensef",pos+ang:Forward()*6,ang,LIGHT_SIZE,COLOR_GREEN,1)
			end
		end,
	})
	addlense("garrowleft",{
		Name = L"trafficlight_lense_greenarrowleft",
		Categories = {"default","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 3,BG = {0,3}},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowleft",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
		end,
	})
	addlense("garrowleftf",{
		Name = L"trafficlight_lense_greenarrowleftf",
		Categories = {"default","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,3},Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowleftf",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
			end
		end,
	})
	addlense("garrowright",{
		Name = L"trafficlight_lense_greenarrowright",
		Categories = {"default","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",Skin = 3,BG = {0,2}},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowright",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
		end,
	})
	addlense("garrowrightf",{
		Name = L"trafficlight_lense_greenarrowrightf",
		Categories = {"default","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_led.mdl",BG = {0,2},Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowrightf",pos+ang:Forward()*6,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
			end
		end,
	})
	
	addlense("nolense_lamp",{
		Name = L"trafficlight_lense_nolense_lamp",
		Categories = {"lamp","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl"},
			{Model = "models/trolleybus/trafficlight/lense.mdl"},
		},
	})
	addlense("noarrowleft_lamp",{
		Name = L"trafficlight_lense_noarrowleft_lamp",
		Categories = {"lamp","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl"},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 2},
		},
	})
	addlense("noarrowright_lamp",{
		Name = L"trafficlight_lense_noarrowright_lamp",
		Categories = {"lamp","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl"},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 1},
		},
	})
	addlense("noarrowforward_lamp",{
		Name = L"trafficlight_lense_noarrowforward_lamp",
		Categories = {"lamp","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl"},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 3},
		},
	})
	addlense("noarrowforwardleft_lamp",{
		Name = L"trafficlight_lense_noarrowforwardleft_lamp",
		Categories = {"lamp","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl"},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 4},
		},
	})
	addlense("noarrowforwardright_lamp",{
		Name = L"trafficlight_lense_noarrowforwardright_lamp",
		Categories = {"lamp","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl"},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 5},
		},
	})
	addlense("noarrowbicycle_lamp",{
		Name = L"trafficlight_lense_noarrowbicycle_lamp",
		Categories = {"lamp","nolense"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl"},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 6},
		},
	})
	addlense("rlense_lamp",{
		Name = L"trafficlight_lense_redlense_lamp",
		Categories = {"lamp","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 1},
			{Model = "models/trolleybus/trafficlight/lense.mdl"},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rlense_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_RED,1)
		end,
	})
	addlense("rarrowleft_lamp",{
		Name = L"trafficlight_lense_redarrowleft_lamp",
		Categories = {"lamp","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 1},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 2},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowleft_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_RED,1)
		end,
	})
	addlense("rarrowright_lamp",{
		Name = L"trafficlight_lense_redarrowright_lamp",
		Categories = {"lamp","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 1},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 1},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowright_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_RED,1)
		end,
	})
	addlense("ylense_lamp",{
		Name = L"trafficlight_lense_yellowlense_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 2},
			{Model = "models/trolleybus/trafficlight/lense.mdl"},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("ylense_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_YELLOW,1)
		end,
	})
	addlense("ylensef_lamp",{
		Name = L"trafficlight_lense_yellowlensef_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 2 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl"},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("ylense_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_YELLOW,1)
			end
		end,
	})
	addlense("yarrowleft_lamp",{
		Name = L"trafficlight_lense_yellowarrowleft_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 2},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 2},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowleft_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
		end,
	})
	addlense("yarrowleftf_lamp",{
		Name = L"trafficlight_lense_yellowarrowleftf_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 2 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 2},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("yarrowleftf_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
			end
		end,
	})
	addlense("yarrowright_lamp",{
		Name = L"trafficlight_lense_yellowarrowright_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 2},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 1},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowright_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
		end,
	})
	addlense("yarrowrightf_lamp",{
		Name = L"trafficlight_lense_yellowarrowrightf_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 2 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 1},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("yarrowrightf_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_YELLOW,1)
			end
		end,
	})
	addlense("glense_lamp",{
		Name = L"trafficlight_lense_greenlense_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 3},
			{Model = "models/trolleybus/trafficlight/lense.mdl"},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("glense_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
		end,
	})
	addlense("glensef_lamp",{
		Name = L"trafficlight_lense_greenlensef_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl"},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("glensef_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
			end
		end,
	})
	addlense("garrowleft_lamp",{
		Name = L"trafficlight_lense_greenarrowleft_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 3},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 2},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowleft_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
		end,
	})
	addlense("garrowleftf_lamp",{
		Name = L"trafficlight_lense_greenarrowleftf_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 2},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowleftf_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
			end
		end,
	})
	addlense("garrowright_lamp",{
		Name = L"trafficlight_lense_greenarrowright_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 3},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 1},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowright_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
		end,
	})
	addlense("garrowrightf_lamp",{
		Name = L"trafficlight_lense_greenarrowrightf_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 1},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowrightf_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE_ARROW,COLOR_GREEN,1)
			end
		end,
	})
	addlense("rarrowforward_lamp",{
		Name = L"trafficlight_lense_rarrowforward_lamp",
		Categories = {"lamp","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 1},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 3},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowforward_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_RED,1)
		end,
	})
	addlense("yarrowforward_lamp",{
		Name = L"trafficlight_lense_yarrowforward_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 2},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 3},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowforward_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_YELLOW,1)
		end,
	})
	addlense("garrowforward_lamp",{
		Name = L"trafficlight_lense_garrowforward_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 3},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 3},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowforward_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
		end,
	})
	addlense("garrowforwardf_lamp",{
		Name = L"trafficlight_lense_garrowforwardf_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 3},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowforwardf_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
			end
		end,
	})
	addlense("rarrowforwardleft_lamp",{
		Name = L"trafficlight_lense_rarrowforwardleft_lamp",
		Categories = {"lamp","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 1},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 4},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowforwardleft_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_RED,1)
		end,
	})
	addlense("yarrowforwardleft_lamp",{
		Name = L"trafficlight_lense_yarrowforwardleft_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 2},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 4},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowforwardleft_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_YELLOW,1)
		end,
	})
	addlense("garrowforwardleft_lamp",{
		Name = L"trafficlight_lense_garrowforwardleft_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 3},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 4},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowforwardleft_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
		end,
	})
	addlense("garrowforwardleftf_lamp",{
		Name = L"trafficlight_lense_garrowforwardleftf_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 4},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowforwardleftf_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
			end
		end,
	})
	addlense("rarrowforwardright_lamp",{
		Name = L"trafficlight_lense_rarrowforwardright_lamp",
		Categories = {"lamp","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 1},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 5},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowforwardright_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_RED,1)
		end,
	})
	addlense("yarrowforwardright_lamp",{
		Name = L"trafficlight_lense_yarrowforwardright_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 2},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 5},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowforwardright_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_YELLOW,1)
		end,
	})
	addlense("garrowforwardright_lamp",{
		Name = L"trafficlight_lense_garrowforwardright_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 3},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 5},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowforwardright_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
		end,
	})
	addlense("garrowforwardrightf_lamp",{
		Name = L"trafficlight_lense_garrowforwardrightf_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 5},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowforwardrightf_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
			end
		end,
	})
	addlense("rarrowbicycle_lamp",{
		Name = L"trafficlight_lense_rarrowbicycle_lamp",
		Categories = {"lamp","red"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 1},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 6},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("rarrowbicycle_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_RED,1)
		end,
	})
	addlense("yarrowbicycle_lamp",{
		Name = L"trafficlight_lense_yarrowbicycle_lamp",
		Categories = {"lamp","yellow"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 2},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 6},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("yarrowbicycle_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_YELLOW,1)
		end,
	})
	addlense("garrowbicycle_lamp",{
		Name = L"trafficlight_lense_garrowbicycle_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Skin = 3},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 6},
		},
		DrawSprites = function(self,pos,ang)
			self:DrawLenseSprite("garrowbicycle_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
		end,
	})
	addlense("garrowbicyclef_lamp",{
		Name = L"trafficlight_lense_garrowbicyclef_lamp",
		Categories = {"lamp","green"},
		Allowed = Allowed,
		ClientEnts = {
			{Model = "models/trolleybus/trafficlight/lense_reflector.mdl",Update = function(self,ent)
				ent:SetSkin(CurTime()%1>0.5 and 3 or 0)
			end},
			{Model = "models/trolleybus/trafficlight/lense.mdl",Skin = 6},
		},
		DrawSprites = function(self,pos,ang)
			if CurTime()%1>0.5 then
				self:DrawLenseSprite("garrowbicyclef_lamp",pos+ang:Forward()*7,ang,LIGHT_SIZE,COLOR_GREEN,1)
			end
		end,
	})
end