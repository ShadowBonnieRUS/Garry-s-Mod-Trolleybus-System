-- Copyright © Platunov I. M., 2021 All rights reserved

if !SYSTEM then return end

SYSTEM.Types = {}
SYSTEM.Positions = {}

function SYSTEM:Initialize()
	local bus = self.Trolleybus
	
	for k,v in ipairs(self.Positions) do
		local td = self.Types[v.type]
		
		bus:AddDynamicPanel("Nameplates."..k,{
			pos = v.pos,
			ang = v.ang,
			size = {td.width,td.height},
		})
		
		bus:AddDynamicButton("Nameplates.l"..k,{
			name = "nameplate_prev",
			model = table.Merge(table.Copy(td.model),{
				think = function(bus,ent)
					ent:SetNoDraw(bus:ButtonIsDown("Nameplates.p"..k))
					
					if v.think then v.think(self,bus,ent) end
				end,
				initialize = function(bus,ent)
					ent:SetBodyGroups(td.model.bg or "")
					ent:SetSkin(td.model.skin or 0)
				end,
			}),
			panel = {
				name = "Nameplates."..k,
				pos = {0,0},
				size = {td.width/3,td.height},
				drawscale = td.drawscale,
				drawtranslucent = function(bus,drawscale,x,y,w,h)
					if bus:ButtonIsDown("Nameplates.p"..k) then return end
					
					self:DrawRoute(0,0,w*3,h,td.nfont,td.font,td.type,self:GetRoute(k))
				end,
			},
			nameplatebtn = k,
			think_sv = v.shouldbeactive and function(bus,on)
				local active = v.shouldbeactive(self,bus)
				
				if active==bus:IsButtonDisabled("Nameplates.l"..k) then
					bus:SetButtonDisabled("Nameplates.l"..k,!active)
				end
			end,
			func = function(bus,on)
				if on then
					bus:ToggleButton("Nameplates.p"..k,false)
					
					local prev = self:GetPrevRoute(self:GetRoute(k))
					self:SetRoute(k,prev)
					
					if k==1 then bus:SetRouteNum(prev) end
				end
			end,
		})
		
		bus:AddDynamicButton("Nameplates.p"..k,{
			name = "nameplate_set",
			panel = {
				name = "Nameplates."..k,
				pos = {td.width/3,0},
				size = {td.width/3,td.height},
			},
			toggle = true,
			nameplatebtn = k,
			func = function(bus,on)
				if on then
					self:SetRoute(k,0)
					
					if k==1 then bus:SetRouteNum(0) end
				end
			end,
			think_sv = v.shouldbeactive and function(bus,on)
				local active = v.shouldbeactive(self,bus)
				
				if active==bus:IsButtonDisabled("Nameplates.p"..k) then
					bus:SetButtonDisabled("Nameplates.p"..k,!active)
				end
			end,
		})
		
		bus:AddDynamicButton("Nameplates.r"..k,{
			name = "nameplate_next",
			panel = {
				name = "Nameplates."..k,
				pos = {td.width/3*2,0},
				size = {td.width/3,td.height},
				drawscale = td.drawscale,
			},
			nameplatebtn = k,
			think_sv = v.shouldbeactive and function(bus,on)
				local active = v.shouldbeactive(self,bus)
				
				if active==bus:IsButtonDisabled("Nameplates.r"..k) then
					bus:SetButtonDisabled("Nameplates.r"..k,!active)
				end
			end,
			func = function(bus,on)
				if on then
					bus:ToggleButton("Nameplates.p"..k,false)
					
					local next = self:GetNextRoute(self:GetRoute(k))
					self:SetRoute(k,next)
					
					if k==1 then bus:SetRouteNum(next) end
				end
			end,
		})
	end
end

function SYSTEM:GetNextRoute(route)
	local routes = Trolleybus_System.Routes.Routes
	local prev = 0
	
	for k,v in pairs(routes) do
		if route==prev then return k end
		
		prev = k
	end
	
	return 0
end

function SYSTEM:GetPrevRoute(route)
	local routes = Trolleybus_System.Routes.Routes
	local prev = 0
	
	for k,v in pairs(routes) do
		if route==k then return prev end
		
		prev = k
	end
	
	return prev
end

function SYSTEM:GetRoute(nameplate)
	return self:GetNWVar("Routes."..nameplate,0)
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	local bus = self.Trolleybus
	
	for k,v in ipairs(self.Positions) do
		bus:RemoveDynamicPanel("Nameplates."..k)
		
		bus:RemoveDynamicButton("Nameplates.p"..k)
		bus:RemoveDynamicButton("Nameplates.l"..k)
		bus:RemoveDynamicButton("Nameplates.r"..k)
	end
end