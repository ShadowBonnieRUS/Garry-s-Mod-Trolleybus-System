-- Copyright © Platunov I. M., 2021 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase

TOOL.ClientConVar = {
	["stop_name"] = "",
	["stop_svname"] = "",
	["stop_pavilion"] = 1,
	["stop_length"] = 500,
	["stop_width"] = 70,
	["stop_passperc"] = 100,
	["help_height"] = 215,
	["route"] = 0,
}

TOOL.Informations = {
	["nopanel"] = {name = "nopanel",icon = "gui/info.png"},
	{name = "info",icon = "gui/info.png",visible = function(self) return true end},
	{name = "changemode",icon = "gui/r.png",visible = function(self) return true end},
	{name = "changedir",icon = "gui/r.png",icon2 = "gui/e.png",visible = function(self) return true end},
	{name = "stopmode",icon = "gui/info.png",visible = function(self) return self:IsStopMode() end},
	{name = "routemode",icon = "gui/info.png",visible = function(self) return self:IsRouteMode() end},
	{name = "routestopmode",icon = "gui/info.png",visible = function(self) return self:IsRouteStopMode() end},
	{name = "stopselect",icon = "gui/lmb.png",visible = function(self) return self:IsStopMode() end},
	{name = "stopunselect",icon = "gui/rmb.png",visible = function(self) return self:IsStopMode() end},
	{name = "stopcreate",icon = "gui/lmb.png",icon2 = "gui/e.png",visible = function(self) return self:IsStopMode() end},
	{name = "stopremove",icon = "gui/rmb.png",icon2 = "gui/e.png",visible = function(self) return self:IsStopMode() end},
	{name = "routepointselect",icon = "gui/lmb.png",visible = function(self) return self:IsRouteMode() end},
	{name = "routepointunselect",icon = "gui/rmb.png",visible = function(self) return self:IsRouteMode() end},
	{name = "routepointcreate",icon = "gui/lmb.png",icon2 = "gui/e.png",visible = function(self) return self:IsRouteMode() end},
	{name = "routepointremove",icon = "gui/rmb.png",icon2 = "gui/e.png",visible = function(self) return self:IsRouteMode() end},
	{name = "routestopselect",icon = "gui/lmb.png",visible = function(self) return self:IsRouteStopMode() end},
	{name = "routestopunselect",icon = "gui/rmb.png",visible = function(self) return self:IsRouteStopMode() end},
	{name = "routestopcreate",icon = "gui/lmb.png",icon2 = "gui/e.png",visible = function(self) return self:IsRouteStopMode() end},
	{name = "routestopremove",icon = "gui/rmb.png",icon2 = "gui/e.png",visible = function(self) return self:IsRouteStopMode() end},
}

TOOL.ElementSize = 10

language.Add("tool.trolleybus_routes_editor.name",L"tool.trolleybus_routes_editor.name")
language.Add("tool.trolleybus_routes_editor.desc",L"tool.trolleybus_routes_editor.desc")

for k,v in pairs(TOOL.Informations) do
	if v.name=="help" then continue end

	language.Add("tool.trolleybus_routes_editor."..v.name,L("tool.trolleybus_routes_editor."..v.name))
end

function TOOL:LeftClick()
	return false
end

function TOOL:RightClick()
	return false
end

function TOOL:Reload(trace)
	return false
end

function TOOL:StartLeftClick()
	if self:IsStopMode() then
		if self:EActive() then
			local tr = util.TraceLine({start = self:GetCachedData("EyePos"),endpos = self:GetCachedData("EyePos")+self:GetCachedData("EyeVector")*10000,mask = MASK_NPCWORLDSTATIC})
			
			net.Start("Trolleybus_System.RoutesEditor")
				net.WriteUInt(3,4)
				net.WriteVector(tr.HitPos)
				net.WriteAngle(Angle(0,self:GetCachedData("EyeAngles").y+180,0))
				net.WriteString(self:GetClientInfo("stop_name"))
				net.WriteString(self:GetClientInfo("stop_svname"))
				net.WriteBool(self:GetClientBool("stop_pavilion"))
				net.WriteUInt(self:GetClientNumber("stop_length"),16)
				net.WriteUInt(self:GetClientNumber("stop_width"),16)
				net.WriteUInt(self:GetClientNumber("stop_passperc"),8)
			net.SendToServer()

			self:GetCPanel().SelectedStop = nil
		else
			local name,data = self:GetCachedData("HoveredStop")

			if name then
				self:GetCPanel().SelectedStop = name

				GetConVar("trolleybus_routes_editor_stop_name"):SetString(data.Name)
				GetConVar("trolleybus_routes_editor_stop_svname"):SetString(data.SVName)
				GetConVar("trolleybus_routes_editor_stop_pavilion"):SetBool(data.Pavilion)
				GetConVar("trolleybus_routes_editor_stop_length"):SetInt(data.Length)
				GetConVar("trolleybus_routes_editor_stop_width"):SetInt(data.Width)
				GetConVar("trolleybus_routes_editor_stop_passperc"):SetInt(data.PassPercent)
			end
		end
	elseif self:IsRouteMode() and self:GetRouteData(true) then
		if self:EActive() then
			local cur = self:GetSelectedRoutePoint() or #self:GetRouteData(true).Points
			local tr = util.TraceLine({start = self:GetCachedData("EyePos"),endpos = self:GetCachedData("EyePos")+self:GetCachedData("EyeVector")*10000,mask = MASK_NPCWORLDSTATIC})
			local pos = tr.HitPos+Vector(0,0,self:GetClientNumber("help_height"))

			net.Start("Trolleybus_System.RoutesEditor")
				net.WriteUInt(4,4)
				net.WriteUInt(self:GetClientNumber("route"),8)
				net.WriteUInt(self:GetRouteDir(),4)
				net.WriteUInt(cur,32)
				net.WriteVector(pos)
			net.SendToServer()

			self:GetCPanel().SelectedRoutePoint = nil
		else
			local id = self:GetCachedData("HoveredRoutePoint")

			if id then
				self:GetCPanel().SelectedRoutePoint = id
			end
		end
	elseif self:IsRouteStopMode() and self:GetRouteData(true) then
		if self:EActive() then
			local cur = self:GetSelectedRouteStopPoint() or #self:GetRouteData(true).Stops
			local name,data = self:GetCachedData("HoveredStopNotInRoute")

			if name then
				net.Start("Trolleybus_System.RoutesEditor")
					net.WriteUInt(5,4)
					net.WriteUInt(self:GetClientNumber("route"),8)
					net.WriteUInt(self:GetRouteDir(),4)
					net.WriteUInt(cur,32)
					net.WriteUInt(name,32)
				net.SendToServer()

				self:GetCPanel().SelectedRouteStopPoint = nil
			end
		else
			local id = self:GetCachedData("HoveredRouteStopPoint")

			if id then
				self:GetCPanel().SelectedRouteStopPoint = id
			end
		end
	end
end

function TOOL:StartRightClick()
	if self:IsStopMode() then
		if self:EActive() then
			local sel = self:GetSelectedStop()
			
			if sel then
				net.Start("Trolleybus_System.RoutesEditor")
					net.WriteUInt(6,4)
					net.WriteUInt(sel,32)
				net.SendToServer()

				self:GetCPanel().SelectedStop = nil
			end
		else
			local name,data = self:GetCachedData("HoveredStopOnlySelected")

			if name==self:GetSelectedStop() then
				self:GetCPanel().SelectedStop = nil
			end
		end
	elseif self:IsRouteMode() and self:GetRouteData(true) then
		if self:EActive() then
			local cur = self:GetSelectedRoutePoint()

			if cur then
				net.Start("Trolleybus_System.RoutesEditor")
					net.WriteUInt(7,4)
					net.WriteUInt(self:GetClientNumber("route"),8)
					net.WriteUInt(self:GetRouteDir(),4)
					net.WriteUInt(cur,32)
				net.SendToServer()

				self:GetCPanel().SelectedRoutePoint = nil
			end
		else
			local id = self:GetCachedData("HoveredRoutePointOnlySelected")

			if id==self:GetSelectedRoutePoint() then
				self:GetCPanel().SelectedRoutePoint = nil
			end
		end
	elseif self:IsRouteStopMode() and self:GetRouteData(true) then
		if self:EActive() then
			local cur = self:GetSelectedRouteStopPoint()

			if cur then
				net.Start("Trolleybus_System.RoutesEditor")
					net.WriteUInt(8,4)
					net.WriteUInt(self:GetClientNumber("route"),8)
					net.WriteUInt(self:GetRouteDir(),4)
					net.WriteUInt(cur,32)
				net.SendToServer()

				self:GetCPanel().SelectedRouteStopPoint = nil
			end
		else
			local id = self:GetCachedData("HoveredRouteStopPointOnlySelected")

			if id==self:GetSelectedRouteStopPoint() then
				self:GetCPanel().SelectedRouteStopPoint = nil
			end
		end
	end
end

function TOOL:StartRClick()
	if self:EActive() then
		self:GetCPanel().RouteDir = self:GetCPanel().RouteDir%(self:GetRouteData() and #self:GetRouteData().Dirs or 1)+1
	else
		self:GetCPanel().ToolMode = (self:GetCPanel().ToolMode+1)%3
	end

	self:GetCPanel().SelectedStop = nil
	self:GetCPanel().SelectedRoutePoint = nil
	self:GetCPanel().SelectedRouteStopPoint = nil
end

function TOOL:EndLeftClick()
end

function TOOL:EndRightClick()
end

function TOOL:EndRClick()
end

function TOOL:DrawHUD()
	if !IsValid(self:GetCPanel()) then return end

	if self:IsStopMode() then
		if !self:EActive() then
			surface.SetDrawColor(0,155,155)

			for k,v in pairs(Trolleybus_System.Routes.Stops) do
				self:DrawPoint(v.Pos)
			end
		end

		local hovered,data = self:GetCachedData(self:EActive() and "HoveredStopOnlySelected" or "HoveredStop")
		if hovered then
			surface.SetDrawColor(255,255,0)
			self:DrawPoint(data.Pos)
		end

		local sel = Trolleybus_System.Routes.Stops[self:GetSelectedStop()]
		if sel then
			surface.SetDrawColor(0,255,255)
			self:DrawPoint(sel.Pos)
		end
	elseif self:IsRouteMode() and self:GetRouteData(true) then
		if !self:EActive() then
			surface.SetDrawColor(0,155,0)

			for k,v in ipairs(self:GetRouteData(true).Points) do
				self:DrawPoint(v)
			end
		end

		local hovered = self:GetCachedData(self:EActive() and "HoveredRoutePointOnlySelected" or "HoveredRoutePoint")
		if hovered then
			surface.SetDrawColor(255,255,0)
			self:DrawPoint(self:GetRoutePointData(hovered))
		end

		local sel = self:GetRoutePointData(self:GetSelectedRoutePoint())
		if sel then
			surface.SetDrawColor(0,255,0)
			self:DrawPoint(sel)
		end
	elseif self:IsRouteStopMode() and self:GetRouteData(true) then
		if self:EActive() then
			surface.SetDrawColor(0,155,155)

			for k,v in pairs(Trolleybus_System.Routes.Stops) do
				self:DrawPoint(v.Pos)
			end
		end

		surface.SetDrawColor(155,0,155)

		for k,v in ipairs(self:GetRouteData(true).Stops) do
			local dt = self:GetRouteStopData(k)
			if dt then
				self:DrawPoint(dt.Pos)
			end
		end

		if self:EActive() then
			local hovered,data = self:GetCachedData("HoveredStopNotInRoute")
			if hovered then
				surface.SetDrawColor(255,255,0)
				self:DrawPoint(data.Pos)
			end
		end

		local hovered = self:GetRouteStopData(self:GetCachedData(self:EActive() and "HoveredRouteStopPointOnlySelected" or "HoveredRouteStopPoint"))
		if hovered then
			surface.SetDrawColor(255,255,0)
			self:DrawPoint(hovered.Pos)
		end

		local sel = self:GetRouteStopData(self:GetSelectedRouteStopPoint())
		if sel then
			surface.SetDrawColor(255,0,255)
			self:DrawPoint(sel.Pos)
		end

		if self:EActive() then
			surface.SetDrawColor(255,255,255)

			for k,v in ipairs(self:GetRouteData(true).Stops) do
				local dt = self:GetRouteStopData(k)

				if dt then
					self:DrawPoint(dt.Pos,nil,true)
				end
			end
		end
	end
end

function TOOL:Think()
	if !IsFirstTimePredicted() and !game.SinglePlayer() then return end

	self.Information = {self.Informations["nopanel"]}

	if !IsValid(self:GetCPanel()) then return end

	if self:GetCPanel().RouteDir!=1 then
		local dir = self:GetCPanel().RouteDir

		if !self:GetRouteData() then
			dir = 1
		elseif !self:GetRouteData().Dirs[dir] then
			dir = #self:GetRouteData().Dirs
		end

		if dir!=self:GetCPanel().RouteDir then
			self:GetCPanel().RouteDir = dir
			self:GetCPanel().SelectedRoutePoint = nil
			self:GetCPanel().SelectedRouteStopPoint = nil
		end
	end
	
	if (self.lactive or false)!=self:LActive() then
		self.lactive = self:LActive()
		
		if self.lactive then self:StartLeftClick() else self:EndLeftClick() end
	end
	
	if (self.ractive or false)!=self:RActive() then
		self.ractive = self:RActive()
		
		if self.ractive then self:StartRightClick() else self:EndRightClick() end
	end
	
	if (self.ractive2 or false)!=self:RActive(true) then
		self.ractive2 = self:RActive(true)
		
		if self.ractive2 then self:StartRClick() else self:EndRClick() end
	end

	self.Information[1] = nil

	for k,v in ipairs(self.Informations) do
		if v.visible(self) then
			self.Information[#self.Information+1] = v
		end
	end
end

function TOOL:EActive()
	return self:GetOwner():KeyDown(IN_USE)
end

function TOOL:LActive()
	return self:GetOwner():KeyDown(IN_ATTACK)
end

function TOOL:RActive(reload)
	return self:GetOwner():KeyDown(reload and IN_RELOAD or IN_ATTACK2)
end

function TOOL:GetCachedData(data)
	self.CachedDataTypes = self.CachedDataTypes or {
		["EyePos"] = {function() return Trolleybus_System.EyePos() end,false},
		["EyeAngles"] = {function() return Trolleybus_System.EyeAngles() end,false},
		["EyeVector"] = {function() return Trolleybus_System.EyeVector() end,false},
		["HoveredStop"] = {function() return {self:GetHoveredStop()} end,true},
		["HoveredStopIgnoreSelected"] = {function() return {self:GetHoveredStop(true)} end,true},
		["HoveredStopOnlySelected"] = {function() return {self:GetHoveredStop(false)} end,true},
		["HoveredStopNotInRoute"] = {function() return {self:GetHoveredStop(nil,true)} end,true},
		["HoveredRoutePoint"] = {function() return self:GetHoveredRoutePoint() end,false},
		["HoveredRoutePointIgnoreSelected"] = {function() return self:GetHoveredRoutePoint(true) end,false},
		["HoveredRoutePointOnlySelected"] = {function() return self:GetHoveredRoutePoint(false) end,false},
		["HoveredRouteStopPoint"] = {function() return self:GetHoveredRouteStopPoint() end,false},
		["HoveredRouteStopPointIgnoreSelected"] = {function() return self:GetHoveredRouteStopPoint(true) end,false},
		["HoveredRouteStopPointOnlySelected"] = {function() return self:GetHoveredRouteStopPoint(false) end,false},
	}
	
	self.CachedData = self.CachedData or {}
	self.CachedData[data] = self.CachedData[data] or {tick = 0,value = nil}

	if self.CachedData[data].tick!=FrameNumber() then
		self.CachedData[data].tick = FrameNumber()
		self.CachedData[data].value = self.CachedDataTypes[data][1]()
	end
	
	if self.CachedDataTypes[data][2] then
		return unpack(self.CachedData[data].value)
	else
		return self.CachedData[data].value
	end
end

function TOOL:Render()
	if !IsValid(self:GetCPanel()) then return end
	
	if self:IsStopMode() then
		if self:EActive() then
			local tr = util.TraceLine({start = self:GetCachedData("EyePos"),endpos = self:GetCachedData("EyePos")+self:GetCachedData("EyeVector")*10000,mask = MASK_NPCWORLDSTATIC})
			local ang = Angle(0,self:GetCachedData("EyeAngles").y+180,0)

			self:DrawStopSquare(tr.HitPos,ang,self:GetClientNumber("stop_length"),self:GetClientNumber("stop_width"),color_white)
		end

		local data = Trolleybus_System.Routes.Stops[self:GetSelectedStop()]
		if data then
			self:DrawStopSquare(data.Pos,data.Ang,data.Length,data.Width,Color(255,255,0))
		end
	elseif self:IsRouteMode() and self:GetRouteData(true) then
		local color = Color(0,255,0)
		local points = self:GetRouteData(true).Points

		if #points==1 then
			local p = points[1]

			self:DrawLine(p+Vector(10,0,0),p-Vector(10,0,0),color)
			self:DrawLine(p+Vector(0,10,0),p-Vector(0,10,0),color)
			self:DrawLine(p+Vector(0,0,10),p-Vector(0,0,10),color)
		else
			for k,v in ipairs(points) do
				if k>1 then
					self:DrawLine(points[k-1],v,color,nil,true)
				end
			end

			if #points>2 and self:GetRouteData().Circular then
				self:DrawLine(points[#points],points[1],Color(0,155,0),nil,true)
			end
		end

		if self:EActive() then
			local tr = util.TraceLine({start = self:GetCachedData("EyePos"),endpos = self:GetCachedData("EyePos")+self:GetCachedData("EyeVector")*10000,mask = MASK_NPCWORLDSTATIC})
			local pos = tr.HitPos+Vector(0,0,self:GetClientNumber("help_height"))

			self:DrawLine(pos,tr.HitPos,color_white)

			if #points==0 then
				self:DrawLine(pos+Vector(10,0,0),pos-Vector(10,0,0),color_white)
				self:DrawLine(pos+Vector(0,10,0),pos-Vector(0,10,0),color_white)
				self:DrawLine(pos+Vector(0,0,10),pos-Vector(0,0,10),color_white)
			else
				local point = self:GetSelectedRoutePoint() or #points

				self:DrawLine(points[point],pos,color_white,nil,true)

				if points[point+1] or #points>2 and self:GetRouteData().Circular then
					self:DrawLine(pos,points[point+1] or points[1],color_white,nil,true)
				end
			end
		end
	elseif self:IsRouteStopMode() and self:GetRouteData(true) then
		local color = Color(255,0,255)
		local stops = self:GetRouteData(true).Stops

		if #stops==1 then
			local dt = self:GetRouteStopData(1)

			if dt then
				self:DrawLine(dt.Pos+Vector(10,0,0),dt.Pos-Vector(10,0,0),color)
				self:DrawLine(dt.Pos+Vector(0,10,0),dt.Pos-Vector(0,10,0),color)
				self:DrawLine(dt.Pos+Vector(0,0,10),dt.Pos-Vector(0,0,10),color)
			end
		else
			for k,v in ipairs(stops) do
				if k>1 then
					local dt = self:GetRouteStopData(k)
					local dt2 = self:GetRouteStopData(k-1)

					if dt and dt2 then
						self:DrawLine(dt2.Pos,dt.Pos,color,nil,true)
					end
				end
			end

			if #stops>2 and self:GetRouteData().Circular then
				local dt = self:GetRouteStopData(1)
				local dt2 = self:GetRouteStopData(#stops)
				
				if dt and dt2 then
					self:DrawLine(dt2.Pos,dt.Pos,Color(155,0,155),nil,true)
				end
			end
		end

		if self:EActive() then
			local name,data = self:GetCachedData("HoveredStopNotInRoute")
			local pos = data and data.Pos or util.TraceLine({start = self:GetCachedData("EyePos"),endpos = self:GetCachedData("EyePos")+self:GetCachedData("EyeVector")*10000,mask = MASK_NPCWORLDSTATIC}).HitPos

			if #stops==0 then
				self:DrawLine(pos+Vector(10,0,0),pos-Vector(10,0,0),color_white)
				self:DrawLine(pos+Vector(0,10,0),pos-Vector(0,10,0),color_white)
				self:DrawLine(pos+Vector(0,0,10),pos-Vector(0,0,10),color_white)
			else
				local stop = self:GetSelectedRouteStopPoint() or #stops
				local dt = self:GetRouteStopData(stop)

				if dt then self:DrawLine(dt.Pos,pos,color_white,nil,true) end

				if stops[stop+1] or #stops>2 and self:GetRouteData().Circular then
					local dt2 = self:GetRouteStopData(stop+1) or self:GetRouteStopData(1)

					if dt2 then self:DrawLine(pos,dt2.Pos,color_white,nil,true) end
				end
			end
		end
	end
end

function TOOL:DrawPoint(pos,color,outlined)
	if color then surface.SetDrawColor(color) end
	
	local p = pos:ToScreen()
	if !p.visible then return end
	
	if outlined then
		surface.DrawOutlinedRect(p.x-self.ElementSize/2,p.y-self.ElementSize/2,self.ElementSize,self.ElementSize)
	else
		surface.DrawRect(p.x-self.ElementSize/2,p.y-self.ElementSize/2,self.ElementSize,self.ElementSize)
	end
end

function TOOL:DrawLine(pos1,pos2,color,colora,arrow)
	if !colora then colora = ColorAlpha(color,20) end
	
	render.DrawLine(pos1,pos2,colora)
	render.DrawLine(pos1,pos2,color,true)

	if arrow then
		local center = (pos1+pos2)/2
		local ang = (pos2-pos1):Angle()

		render.DrawLine(center,center-ang:Forward()*30+ang:Right()*30,colora)
		render.DrawLine(center,center-ang:Forward()*30-ang:Right()*30,colora)
		render.DrawLine(center,center-ang:Forward()*30+ang:Right()*30,color,true)
		render.DrawLine(center,center-ang:Forward()*30-ang:Right()*30,color,true)
	end
end

function TOOL:DrawStopSquare(pos,ang,length,width,color)
	local forward,right = ang:Forward(),ang:Right()

	self:DrawLine(pos+forward*width/2-right*length/2,pos+forward*width/2+right*length/2,color)
	self:DrawLine(pos-forward*width/2-right*length/2,pos-forward*width/2+right*length/2,color)
	self:DrawLine(pos+forward*width/2-right*length/2,pos-forward*width/2-right*length/2,color)
	self:DrawLine(pos+forward*width/2+right*length/2,pos-forward*width/2+right*length/2,color)
end

function TOOL:GetClientBool(var)
	return tobool(self:GetClientInfo(var))
end

function TOOL:IsStopMode()
	return self:GetCPanel().ToolMode==0
end

function TOOL:IsRouteMode()
	return self:GetCPanel().ToolMode==1
end

function TOOL:IsRouteStopMode()
	return self:GetCPanel().ToolMode==2
end

function TOOL:GetRouteData(dir)
	local data = Trolleybus_System.Routes.Routes[self:GetClientNumber("route")]
	if !data then return end

	if dir then data = data.Dirs[self:GetRouteDir()] end

	return data
end

function TOOL:GetHoveredStop(ignoretype,notinroute)
	local pos = self:GetCachedData("EyePos")
	local dir = self:GetCachedData("EyeVector")
	local selected = ignoretype!=nil and self:GetSelectedStop()
	local name,data,dot

	for k,v in pairs(Trolleybus_System.Routes.Stops) do
		if ignoretype!=nil and Either(ignoretype,k==selected,k!=selected) then continue end
		if notinroute and table.HasValue(self:GetRouteData(true).Stops,k) then continue end

		local d = math.deg(math.acos(dir:Dot((v.Pos-pos):GetNormalized())))

		if d<10 and (!dot or d<dot) then
			name,data,dot = k,v,d
		end
	end

	return name,data
end

function TOOL:GetHoveredRoutePoint(ignoretype)
	local pos = self:GetCachedData("EyePos")
	local dir = self:GetCachedData("EyeVector")
	local selected = ignoretype!=nil and self:GetSelectedRoutePoint()
	local id,dot

	for k,v in ipairs(self:GetRouteData(true).Points) do
		if ignoretype!=nil and Either(ignoretype,k==selected,k!=selected) then continue end

		local d = math.deg(math.acos(dir:Dot((v-pos):GetNormalized())))

		if d<10 and (!dot or d<dot) then
			id,dot = k,d
		end
	end

	return id
end

function TOOL:GetHoveredRouteStopPoint(ignoretype)
	local pos = self:GetCachedData("EyePos")
	local dir = self:GetCachedData("EyeVector")
	local selected = ignoretype!=nil and self:GetSelectedRouteStopPoint()
	local id,dot

	for k,v in ipairs(self:GetRouteData(true).Stops) do
		if ignoretype!=nil and Either(ignoretype,k==selected,k!=selected) then continue end

		local d = math.deg(math.acos(dir:Dot((self:GetRouteStopData(k).Pos-pos):GetNormalized())))

		if d<10 and (!dot or d<dot) then
			id,dot = k,d
		end
	end

	return id
end

function TOOL:GetSelectedStop()
	return self:GetCPanel().SelectedStop
end

function TOOL:GetSelectedRoutePoint()
	return self:GetRouteData(true) and self:GetCPanel().SelectedRoutePoint
end

function TOOL:GetSelectedRouteStopPoint()
	return self:GetRouteData(true) and self:GetCPanel().SelectedRouteStopPoint
end

function TOOL:GetRoutePointData(id)
	return self:GetRouteData(true).Points[id]
end

function TOOL:GetRouteStopData(id)
	return Trolleybus_System.Routes.Stops[self:GetRouteData(true).Stops[id]]
end

function TOOL:GetRouteDir()
	return self:GetCPanel().RouteDir
end

function TOOL:GetCPanel()
	local pnl = controlpanel.Get("trolleybus_routes_editor")
	if pnl.ToolMode then return pnl end

	return false
end

function TOOL:GetHelpText()
	return L("tool.trolleybus_routes_editor.dirnum",self:GetRouteDir())
end

local function IsToolActive()
	local ply = LocalPlayer()
	local tool = ply:GetTool("trolleybus_routes_editor")

	return tool and tool:Allowed() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()=="gmod_tool" and ply:GetActiveWeapon().Mode=="trolleybus_routes_editor"
end

function TOOL.BuildCPanel(pnl)
	pnl.ToolMode = 0
	pnl.RouteNum = 1

	local stops = vgui.Create("DForm",pnl)
	stops:Dock(TOP)
	stops:DockMargin(5,5,5,0)
	stops:SetName(L"tool.trolleybus_routes_editor.ui.stops")
	local stopupd

	local lbl = vgui.Create("DLabel",stops)
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,0)
	lbl:SetTextColor(color_black)
	lbl:SetText(L"tool.trolleybus_routes_editor.ui.stops.name")
	lbl:SetAutoStretchVertical(true)
	lbl:SetWrap(true)
	lbl:SizeToContents()

	local fix = vgui.Create("DPanel",stops)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(5,5,5,0)

	local stops_name = vgui.Create("DTextEntry",fix)
	stops_name:Dock(FILL)
	stops_name:SetValue(GetConVar("trolleybus_routes_editor_stop_name"):GetString())
	stops_name:SetConVar("trolleybus_routes_editor_stop_name")
	stops_name.OnValueChange = function(self)
		stopupd()
	end

	local lbl = vgui.Create("DLabel",stops)
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,0)
	lbl:SetTextColor(color_black)
	lbl:SetText(L"tool.trolleybus_routes_editor.ui.stops.svname")
	lbl:SetAutoStretchVertical(true)
	lbl:SetWrap(true)
	lbl:SizeToContents()

	local fix = vgui.Create("DPanel",stops)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(5,5,5,0)

	local stops_svname = vgui.Create("DTextEntry",fix)
	stops_svname:Dock(FILL)
	stops_svname:SetValue(GetConVar("trolleybus_routes_editor_stop_svname"):GetString())
	stops_svname:SetConVar("trolleybus_routes_editor_stop_svname")
	stops_svname.OnValueChange = function(self)
		stopupd()
	end

	local stops_pavilion = vgui.Create("DCheckBoxLabel",stops)
	stops_pavilion:Dock(TOP)
	stops_pavilion:DockMargin(5,5,5,0)
	stops_pavilion:SetText(L"tool.trolleybus_routes_editor.ui.stops.pavilion")
	stops_pavilion:SetTextColor(color_black)
	stops_pavilion:SetChecked(GetConVar("trolleybus_routes_editor_stop_pavilion"):GetBool())
	stops_pavilion:SetConVar("trolleybus_routes_editor_stop_pavilion")
	stops_pavilion.OnChange = function(self,val)
		stopupd()
	end

	local stops_length = vgui.Create("DNumSlider",stops)
	stops_length:Dock(TOP)
	stops_length:DockMargin(5,5,5,0)
	stops_length:SetText(L"tool.trolleybus_routes_editor.ui.stops.length")
	stops_length.Label:SetTextColor(color_black)
	stops_length:SetMinMax(50,5000)
	stops_length:SetDecimals(0)
	stops_length:SetValue(GetConVar("trolleybus_routes_editor_stop_length"):GetInt())
	stops_length:SetConVar("trolleybus_routes_editor_stop_length")
	stops_length.OnValueChanged = function(self,value)
		stopupd()
	end

	local stops_width = vgui.Create("DNumSlider",stops)
	stops_width:Dock(TOP)
	stops_width:DockMargin(5,5,5,0)
	stops_width:SetText(L"tool.trolleybus_routes_editor.ui.stops.width")
	stops_width.Label:SetTextColor(color_black)
	stops_width:SetMinMax(50,5000)
	stops_width:SetDecimals(0)
	stops_width:SetValue(GetConVar("trolleybus_routes_editor_stop_width"):GetInt())
	stops_width:SetConVar("trolleybus_routes_editor_stop_width")
	stops_width.OnValueChanged = function(self,value)
		stopupd()
	end

	local stops_passperc = vgui.Create("DNumSlider",stops)
	stops_passperc:Dock(TOP)
	stops_passperc:DockMargin(5,5,5,0)
	stops_passperc:SetText(L"tool.trolleybus_routes_editor.ui.stops.passperc")
	stops_passperc.Label:SetTextColor(color_black)
	stops_passperc:SetMinMax(0,100)
	stops_passperc:SetDecimals(0)
	stops_passperc:SetValue(GetConVar("trolleybus_routes_editor_stop_passperc"):GetInt())
	stops_passperc:SetConVar("trolleybus_routes_editor_stop_passperc")
	stops_passperc.OnValueChanged = function(self,value)
		stopupd()
	end

	stopupd = function()
		if pnl.ToolMode==0 and pnl.SelectedStop then
			net.Start("Trolleybus_System.RoutesEditor")
				net.WriteUInt(9,4)
				net.WriteUInt(pnl.SelectedStop,32)
				net.WriteString(stops_name:GetValue())
				net.WriteString(stops_svname:GetValue())
				net.WriteBool(stops_pavilion:GetChecked())
				net.WriteUInt(stops_length:GetValue(),16)
				net.WriteUInt(stops_width:GetValue(),16)
				net.WriteUInt(stops_passperc:GetValue(),8)
			net.SendToServer()
		end
	end

	local routes = vgui.Create("DForm",pnl)
	routes:Dock(TOP)
	routes:DockMargin(5,5,5,0)
	routes:SetName(L"tool.trolleybus_routes_editor.ui.routes")

	local routes_route = vgui.Create("DComboBox",routes)
	routes_route:Dock(TOP)
	routes_route:DockMargin(5,5,5,0)
	GetConVar("trolleybus_routes_editor_route"):SetInt(0)

	local lbl = vgui.Create("DLabel",routes)
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,0)
	lbl:SetTextColor(color_black)
	lbl:SetText(L"tool.trolleybus_routes_editor.ui.routes.num")
	lbl:SetAutoStretchVertical(true)
	lbl:SetWrap(true)
	lbl:SizeToContents()

	local fix = vgui.Create("DPanel",routes)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(5,5,5,0)

	local routes_num = vgui.Create("DTextEntry",fix)
	routes_num:Dock(FILL)
	routes_num:SetNumeric(true)

	local lbl = vgui.Create("DLabel",routes)
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,0)
	lbl:SetTextColor(color_black)
	lbl:SetText(L"tool.trolleybus_routes_editor.ui.routes.customname")
	lbl:SetAutoStretchVertical(true)
	lbl:SetWrap(true)
	lbl:SizeToContents()

	local fix = vgui.Create("DPanel",routes)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(5,5,5,0)

	local routes_customname = vgui.Create("DTextEntry",fix)
	routes_customname:Dock(FILL)

	local lbl = vgui.Create("DLabel",routes)
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,0)
	lbl:SetTextColor(color_black)
	lbl:SetText(L"tool.trolleybus_routes_editor.ui.routes.customstart")
	lbl:SetAutoStretchVertical(true)
	lbl:SetWrap(true)
	lbl:SizeToContents()

	local fix = vgui.Create("DPanel",routes)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(5,5,5,0)

	local routes_customstart = vgui.Create("DTextEntry",fix)
	routes_customstart:Dock(FILL)

	local lbl = vgui.Create("DLabel",routes)
	lbl:Dock(TOP)
	lbl:DockMargin(5,5,5,0)
	lbl:SetTextColor(color_black)
	lbl:SetText(L"tool.trolleybus_routes_editor.ui.routes.customend")
	lbl:SetAutoStretchVertical(true)
	lbl:SetWrap(true)
	lbl:SizeToContents()

	local fix = vgui.Create("DPanel",routes)
	fix:SetTall(20)
	fix:Dock(TOP)
	fix:DockMargin(5,5,5,0)

	local routes_customend = vgui.Create("DTextEntry",fix)
	routes_customend:Dock(FILL)

	local routes_dirs = vgui.Create("DNumSlider",routes)
	routes_dirs:Dock(TOP)
	routes_dirs:DockMargin(5,5,5,0)
	routes_dirs:SetText(L"tool.trolleybus_routes_editor.ui.routes.dirs")
	routes_dirs.Label:SetTextColor(color_black)
	routes_dirs:SetMinMax(1,10)
	routes_dirs:SetDecimals(0)
	routes_dirs:SetValue(1)

	local routes_circular = vgui.Create("DCheckBoxLabel",routes)
	routes_circular:Dock(TOP)
	routes_circular:DockMargin(5,5,5,0)
	routes_circular:SetText(L"tool.trolleybus_routes_editor.ui.routes.circular")
	routes_circular:SetTextColor(color_black)

	local routes_save = vgui.Create("DButton",routes)
	routes_save:SetEnabled(false)
	routes_save:Dock(TOP)
	routes_save:DockMargin(5,5,5,0)
	routes_save:SetText(L"tool.trolleybus_routes_editor.ui.routes.save")
	routes_save.DoClick = function(self)
		local route = routes_num.route
		local dt = Trolleybus_System.Routes.Routes[route]

		if dt then
			net.Start("Trolleybus_System.RoutesEditor")
				net.WriteUInt(0,4)
				net.WriteUInt(route,8)
				net.WriteString(routes_customname:GetValue())
				net.WriteString(routes_customstart:GetValue())
				net.WriteString(routes_customend:GetValue())
				net.WriteUInt(routes_dirs:GetValue(),4)
				net.WriteBool(routes_circular:GetChecked())
			net.SendToServer()
		end
	end

	local routes_delete = vgui.Create("DButton",routes)
	routes_delete:SetEnabled(false)
	routes_delete:Dock(TOP)
	routes_delete:DockMargin(5,5,5,0)
	routes_delete:SetTextColor(Color(255,0,0))
	routes_delete:SetText(L"tool.trolleybus_routes_editor.ui.routes.delete")
	routes_delete.DoClick = function(self)
		Trolleybus_System.ConfirmDialog(L"tool.trolleybus_routes_editor.ui.routed.confirmdelete", function()
			local route = routes_num.route
			local dt = Trolleybus_System.Routes.Routes[route]

			if dt then
				net.Start("Trolleybus_System.RoutesEditor")
				net.WriteUInt(1,4)
				net.WriteUInt(route,8)
				net.SendToServer()
			end
		end)
	end

	local routes_new = vgui.Create("DButton",routes)
	routes_new:SetEnabled(false)
	routes_new:Dock(TOP)
	routes_new:DockMargin(5,10,5,0)
	routes_new:SetText(L"tool.trolleybus_routes_editor.ui.routes.new")
	routes_new.DoClick = function(self)
		local route = routes_num.route
		local dt = Trolleybus_System.Routes.Routes[route]

		if !dt and route then
			net.Start("Trolleybus_System.RoutesEditor")
				net.WriteUInt(2,4)
				net.WriteUInt(route,8)
				net.WriteString(routes_customname:GetValue())
				net.WriteString(routes_customstart:GetValue())
				net.WriteString(routes_customend:GetValue())
				net.WriteUInt(routes_dirs:GetValue(),4)
				net.WriteBool(routes_circular:GetChecked())
			net.SendToServer()
		end
	end

	routes_num.OnChange = function(self)
		self.route = tonumber(self:GetValue())
		if self.route and (self.route%1!=0 or self.route<1 or self.route>100) then self.route = nil end

		if self.route and !self.NoUpd then
			local id = table.KeyFromValue(routes_route.Data,self.route)

			if id then
				routes_route:ChooseOptionID(id)
			end
		end

		local dt = Trolleybus_System.Routes.Routes[self.route]
		routes_save:SetEnabled(dt and true or false)
		routes_delete:SetEnabled(dt and true or false)
		routes_new:SetEnabled(!dt and self.route and true or false)

		pnl.SelectedRoutePoint = nil
		pnl.SelectedRouteStopPoint = nil
	end

	routes_route.Think = function(self)
		local routes = Trolleybus_System.Routes.Routes

		if self.Routes then
			for k,v in pairs(self.Routes) do
				if routes[k]!=v then self.Routes = nil break end
			end

			for k,v in pairs(routes) do
				if !self.Routes or self.Routes[k]!=v then self.Routes = nil break end
			end
		end

		if !self.Routes then
			local _,curroute = self:GetSelected()
			self:Clear()

			self.Routes = {}

			local has = false
			for k,v in pairs(routes) do
				self.Routes[k] = v
				self:AddChoice(k..(v.CustomName and " ("..v.CustomName..")" or ""),k,k==curroute)

				has = has or k==curroute
			end

			if !has then
				self:SetText(L"tool.trolleybus_routes_editor.ui.routes.selectroute")
			end
		end

		local toolactive = IsToolActive()
		local dt = Trolleybus_System.Routes.Routes[routes_num.route]

		routes_save:SetEnabled(dt and toolactive or false)
		routes_delete:SetEnabled(dt and toolactive or false)
		routes_new:SetEnabled(!dt and routes_num.route and toolactive or false)
	end

	routes_route.OnSelect = function(self,index,text,route)
		local dt = Trolleybus_System.Routes.Routes[route]
		if dt then
			GetConVar("trolleybus_routes_editor_route"):SetInt(route)

			routes_num.NoUpd = true
			routes_num:SetValue(route)
			routes_num.route = route
			routes_num.NoUpd = false

			local dt = Trolleybus_System.Routes.Routes[route]
			routes_save:SetEnabled(dt and true or false)
			routes_delete:SetEnabled(dt and true or false)
			routes_new:SetEnabled(!dt and route and true or false)

			routes_customname:SetValue(dt.CustomName or "")
			routes_customstart:SetValue(dt.CustomStart or "")
			routes_customend:SetValue(dt.CustomEnd or "")
			routes_dirs:SetValue(#dt.Dirs)
			routes_circular:SetChecked(dt.Circular)

			pnl.RouteNum = 1
		else
			GetConVar("trolleybus_routes_editor_route"):SetInt(0)
		end
	end

	local help_height = vgui.Create("DNumSlider",pnl)
	help_height:Dock(TOP)
	help_height:DockMargin(5,5,5,0)
	help_height:SetText(L"tool.trolleybus_routes_editor.ui.help_height")
	help_height.Label:SetTextColor(color_black)
	help_height:SetMinMax(0,500)
	help_height:SetDecimals(0)
	help_height:SetValue(GetConVar("trolleybus_routes_editor_help_height"):GetInt())
	help_height:SetConVar(L"trolleybus_routes_editor_help_height")
end

hook.Add("PostDrawTranslucentRenderables","Trolleybus_System.RoutesEditor",function(depth,skybox,skybox3d)
	if skybox and skybox3d then return end
	
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep:GetClass()=="gmod_tool" and wep.Mode=="trolleybus_routes_editor" then
		wep:GetToolObject():Render()
	end
end)