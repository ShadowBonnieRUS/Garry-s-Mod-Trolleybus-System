-- Copyright © Platunov I. M., 2021 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase

TOOL.ClientConVar = {
	["gridsize"] = 1,
	["networkheight"] = 215,
	["snapangle"] = 5,
	["localpos"] = 0,
	["localang"] = 0,
	["pivotsize"] = 100,
}

TOOL.Informations = {
	["nopanel"] = {name = "nopanel",icon = "gui/info.png"},
	["notloaded"] = {name = "notloaded",icon = "gui/info.png"},
	{name = "ignoredist",icon = "gui/r.png",icon2 = "gui/e.png",visible = function(self) return self:CanSelectObject() end},
	{name = "selectobj",icon = "gui/lmb.png",visible = function(self) return self:CanSelectObject() and table.IsEmpty(self:GetSelectedObjects()) end},
	{name = "selectobj",icon = "gui/lmb.png",icon2 = "gui/e.png",visible = function(self) return !self:IsPivotMoving() and !table.IsEmpty(self:GetSelectedObjects()) and table.IsEmpty(self:GetSelectedConnectables()) end},
	{name = "unselectobj",icon = "gui/rmb.png",visible = function(self) return !self:IsPivotMoving() and table.IsEmpty(self:GetSelectedConnectables()) and !table.IsEmpty(self:GetSelectedObjects()) end},
	{name = "deleteobj",icon = "gui/rmb.png",icon2 = "gui/e.png",visible = function(self) return !self:IsPivotMoving() and table.IsEmpty(self:GetSelectedConnectables()) and !table.IsEmpty(self:GetSelectedObjects()) end},
	{name = "selectcon",icon = "gui/lmb.png",visible = function(self) return self:CanSelectConnectable() and table.IsEmpty(self:GetSelectedConnectables()) and !self:CanConnectConnectables() end},
	{name = "selectcon",icon = "gui/lmb.png",icon2 = "gui/e.png",visible = function(self) return !self:IsPivotMoving() and !table.IsEmpty(self:GetSelectedConnectables()) and !self:CanConnectConnectables() end},
	{name = "unselectcon",icon = "gui/rmb.png",visible = function(self) return !self:IsPivotMoving() and !table.IsEmpty(self:GetSelectedConnectables()) and !self:CanConnectConnectables() end},
	{name = "connectcon",icon = "gui/r.png",icon2 = "gui/e.png",visible = function(self) return !self:IsPivotMoving() and (!self:EActive() or !self:RActive(true)) and self:CanConnectSelectedConnectable() end},
	{name = "connectcon2",icon = "gui/lmb.png",visible = function(self) return !self:IsPivotMoving() and self:CanConnectConnectables() end},
	{name = "disconnectcon",icon = "gui/rmb.png",visible = function(self) return !self:IsPivotMoving() and self:CanConnectConnectables() end},
	{name = "pivotrotmode",icon = "gui/r.png",visible = function(self) return !self:IsPivotMoving() and self:IsPivotActive() end},
	{name = "pivotmove",icon = "gui/lmb.png",visible = function(self) return !self:IsPivotMoving() and self:IsPivotActive() and !self:GetCPanel().PivotRotateMode and self:GetCachedData("GetPivotHovered") and self:GetCachedData("GetPivotHovered")!=3 end},
	{name = "pivotrotate",icon = "gui/lmb.png",visible = function(self) return !self:IsPivotMoving() and self:IsPivotActive() and self:GetCPanel().PivotRotateMode and self:GetCachedData("GetPivotHovered") and self:GetCachedData("GetPivotHovered")!=3 end},
	{name = "cancelmoverotate",icon = "gui/rmb.png",visible = function(self) return self:IsPivotMoving() and !self:GetCPanel().MoveData.NewObject and !self:GetCPanel().MoveData.CopyObjects end},
	{name = "movepivot",icon = "gui/lmb.png",visible = function(self) return !self:IsPivotMoving() and self:IsPivotActive() and self:GetCachedData("GetPivotHovered")==3 and !self:GetCPanel().PivotMove end},
	{name = "moveselect",icon = "gui/lmb.png",visible = function(self) return !self:IsPivotMoving() and self:IsPivotActive() and self:GetCachedData("GetPivotHovered")==3 and self:GetCPanel().PivotMove end},
	{name = "createobj",icon = "gui/lmb.png",visible = function(self) return self:IsPivotMoving() and self:GetCPanel().MoveData.NewObject end},
	{name = "cancelcreateobj",icon = "gui/rmb.png",visible = function(self) return self:IsPivotMoving() and self:GetCPanel().MoveData.NewObject end},
	{name = "copyobjs",icon = "gui/lmb.png",visible = function(self) return self:IsPivotMoving() and self:GetCPanel().MoveData.CopyObjects end},
	{name = "cancelcopyobjs",icon = "gui/rmb.png",visible = function(self) return self:IsPivotMoving() and self:GetCPanel().MoveData.CopyObjects end},
	{name = "groundprojection",icon = "gui/e.png",visible = function(self) return self:IsPivotMoving() end},
	{name = "ignorenetworkheight",icon = "gui/r.png",icon2 = "gui/e.png",visible = function(self) return self:IsPivotMoving() end},
}

language.Add("tool.trolleybus_cn_editor.name",L"tool.trolleybus_cn_editor.name")
language.Add("tool.trolleybus_cn_editor.desc",L"tool.trolleybus_cn_editor.desc")

for k,v in pairs(TOOL.Informations) do
	language.Add("tool.trolleybus_cn_editor."..v.name,L("tool.trolleybus_cn_editor."..v.name))
end

TOOL.PivotSize = 15
TOOL.PivotArrowSize = 3
TOOL.GridCells = 10
TOOL.GridRotCellSize = TOOL.PivotSize*2
TOOL.ElementSize = 10

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
	if !self:IsPivotMoving() then
		if self:IsPivotActive() and self:GetCachedData("GetPivotHovered") then
			local hovered = self:GetCachedData("GetPivotHovered")
			
			if hovered==6 then
				self:GetCPanel().PivotMove = !self:GetCPanel().PivotMove
			else
				if self:GetCPanel().PivotMove then
					self:StartMovingPivot("Object",{next(self:GetSelectedObjects())})
				elseif !table.IsEmpty(self:GetSelectedConnectables()) then
					local connectables = {}
					local pivotpos,pivotang = self:GetCachedData("GetPivotPosition")
					
					for k,v in pairs(self:GetSelectedConnectables()) do
						for k2,v2 in pairs(v) do
							local pos,ang = WorldToLocal(v2:GetConnectablePos(k2),v2:GetConnectableAngles(k2),pivotpos,pivotang)
							
							connectables[{k,k2}] = {Object = v2,LPos = pos,LAng = ang}
						end
					end
					
					self:StartMovingPivot("Connectables",connectables)
				else
					local objects = {}
					local pivotpos,pivotang = self:GetCachedData("GetPivotPosition")
					
					for k,v in pairs(self:GetSelectedObjects()) do
						local pos,ang = WorldToLocal(v:GetPos(),v:GetAngles(),pivotpos,pivotang)
						
						objects[k] = {Object = v,LPos = pos,LAng = ang}
					end
				
					self:StartMovingPivot("Objects",objects)
				end
			end
		elseif self:CanSelectObject() and self:GetCachedData("GetHoveredObjectIgnoreSelected") then
			local object,name = self:GetCachedData("GetHoveredObjectIgnoreSelected")
			
			self:SelectObject(name,object)
		elseif self:CanSelectConnectable() and self:GetCachedData("GetHoveredConnectableIgnoreSelectedOnlyMovable") then
			local name,object,id = self:GetCachedData("GetHoveredConnectableIgnoreSelectedOnlyMovable")
			
			self:SelectConnectable(name,id)
		elseif self:CanConnectConnectables() and self:GetCachedData("GetHoveredConnectableIgnoreSelected") then
			local name,object,id = self:GetCachedData("GetHoveredConnectableIgnoreSelected")
			local cname,cons = next(self:GetSelectedConnectables())
			local cid,obj = next(cons)

			if obj:IsConnectableConnectingAllowedTo(cid,object,id) then
				table.Empty(self:GetSelectedConnectables())
				obj:ConnectConnectableTo(cid,object,id)

				net.Start("Trolleybus_System.ContactNetworkEditor")
					net.WriteUInt(4,4)
					net.WriteString(cname)
					net.WriteUInt(cid,8)
					net.WriteString(name)
					net.WriteUInt(id,8)
				net.SendToServer()
			end
		end
	end
end

function TOOL:StartRightClick()
	if self:IsPivotMoving() then
		local move = self:GetCPanel().MoveData
		if !move.NewObject and !move.CopyObjects then
			self:PivotMoveUpdate(move,move.Pos,move.Ang)
		end

		self:GetCPanel().MoveData = nil
	elseif !table.IsEmpty(self:GetSelectedConnectables()) then
		if self:GetCachedData("GetHoveredConnectableOnlySelected") then
			local name,object,id = self:GetCachedData("GetHoveredConnectableOnlySelected")

			if self:CanConnectConnectables() then
				object:DisconnectConnectable(id)
				table.Empty(self:GetSelectedConnectables())

				net.Start("Trolleybus_System.ContactNetworkEditor")
					net.WriteUInt(5,4)
					net.WriteString(name)
					net.WriteUInt(id,8)
				net.SendToServer()
			else
				self:UnselectConnectable(name,id)
			end
		end
	elseif self:GetCachedData("GetHoveredObjectOnlySelected") then
		local object,name = self:GetCachedData("GetHoveredObjectOnlySelected")
		
		if self:EActive() then
			net.Start("Trolleybus_System.ContactNetworkEditor")
				net.WriteUInt(3,4)
				net.WriteString(name)
			net.SendToServer()
		else
			self:UnselectObject(name)
		end
	end
end

function TOOL:StartRClick()
	if self:IsPivotActive() and !self:IsPivotMoving() and !self:CanConnectConnectables() then
		self:GetCPanel().PivotRotateMode = !self:GetCPanel().PivotRotateMode
	end
end

function TOOL:EndLeftClick()
	if self:IsPivotActive() and self:IsPivotMoving() then
		self:ApplyPivotMove(self:GetCPanel().MoveData,self:GetCachedData("GetPivotPosition"))
		
		self:GetCPanel().MoveData = nil
	end
end

function TOOL:EndRightClick()
end

function TOOL:EndRClick()
end

function TOOL:DrawHUD()
	if !IsValid(self:GetCPanel()) then return end
	
	if self:CanSelectObject() then
		if !self._hudobjpointst or RealTime()-self._hudobjpointst>0.5 then
			self._hudobjpoints = {{},{}}

			for i=1,2 do
				for k,v in pairs(Trolleybus_System.ContactNetwork.Objects[i==1 and "Contacts" or "SuspensionAndOther"]) do
					local p = v:GetPos()

					if self:DistanceCheck(p) and (p-self:GetCachedData("EyePos")):GetNormalized():Dot(self:GetCachedData("EyeVector"))>0 then
						self._hudobjpoints[i][#self._hudobjpoints[i]+1] = {k,p}
					end
				end
			end

			self._hudobjpointst = RealTime()
		end

		surface.SetDrawColor(0,200,200)
		
		for k,v in ipairs(self._hudobjpoints[1]) do
			self:DrawPoint(v[2],nil,false)
			debugoverlay.Text(v[2],v[1],0.1,false)
		end
		
		surface.SetDrawColor(200,0,200)
		
		for k,v in pairs(self._hudobjpoints[2]) do
			self:DrawPoint(v[2],nil,false)
			debugoverlay.Text(v[2],v[1],0.1,false)
		end
		
		local hovered = self:GetCachedData("GetHoveredObjectIgnoreSelected")
		if hovered then
			surface.SetDrawColor(200,200,0)
			self:DrawPoint(hovered:GetPos())
		end
	end
	
	for k,v in pairs(self:GetSelectedObjects()) do
		if v.Class.Id==0 then
			surface.SetDrawColor(0,255,255)
		elseif v.Class.Id==1 then
			surface.SetDrawColor(255,0,255)
		end
		
		self:DrawPoint(v:GetPos())
		
		if self:CanSelectConnectable() then
			surface.SetDrawColor(180,180,180)
			
			for i=1,v:GetConnectableCount() do
				self:DrawPoint(v:GetConnectablePos(i),nil,true)
				debugoverlay.Text(v:GetConnectablePos(i),i,0.1,false)
			end
			
			local name,object,id = self:GetCachedData("GetHoveredConnectableIgnoreSelectedOnlyMovable")
			if name then
				surface.SetDrawColor(200,200,0)
				self:DrawPoint(object:GetConnectablePos(id),nil,true)
			end
		end
	end
	
	local hovered = self:GetCachedData("GetHoveredObjectOnlySelected")
	if hovered and table.IsEmpty(self:GetSelectedConnectables()) then
		surface.SetDrawColor(255,255,0)
		self:DrawPoint(hovered:GetPos())
	end
	
	surface.SetDrawColor(255,255,255)
	
	for k,v in pairs(self:GetSelectedConnectables()) do
		for k2,v2 in pairs(v) do
			self:DrawPoint(v2:GetConnectablePos(k2),nil,true)
		end
	end
	
	local name,object,id = self:GetCachedData("GetHoveredConnectableOnlySelected")
	if name then
		surface.SetDrawColor(255,255,0)
		self:DrawPoint(object:GetConnectablePos(id),nil,true)
	end
	
	if self:CanConnectConnectables() then
		local id,obj = next(select(2,next(self:GetSelectedConnectables())))
		
		surface.SetDrawColor(255,255,255)
		
		for k,v in pairs(self:GetSelectedObjects()) do
			for i=1,v:GetConnectableCount() do
				local mobj,mid = v:GetMainConnectable(i)
				if obj==mobj and id==mid then continue end
				
				self:DrawPoint(mobj:GetConnectablePos(mid),nil,true)
			end
		end
		
		local name,object,mid = self:GetCachedData("GetHoveredConnectableIgnoreSelected")
		if name and obj:IsConnectableConnectingAllowedTo(id,object,mid) then
			surface.SetDrawColor(255,255,0)
			self:DrawPoint(object:GetConnectablePos(mid),nil,true)
		end
	end
	
	if self:IsPivotMoving() then
		local move = self:GetCPanel().MoveData
		local pos,ang = self:GetCachedData("GetPivotPosition")
		local opos,oang = move.Pos,move.Ang
		
		if move.Rotation then
			ang:Normalize()
			local w,h = draw.SimpleText(Format("%.6f %.6f %.6f",ang.p,ang.y,ang.r),"BudgetLabel",ScrW()/2,ScrH()/2,nil,1)
			local delta = ang-oang
			delta:Normalize()
			
			draw.SimpleText(Format("%.6f %.6f %.6f",delta.p,delta.y,delta.r),"BudgetLabel",ScrW()/2,ScrH()/2+h,nil,1)
		else
			local w,h = draw.SimpleText(Format("%.6f %.6f %.6f",pos.x,pos.y,pos.z),"BudgetLabel",ScrW()/2,ScrH()/2,nil,1)
			local delta = WorldToLocal(pos,angle_zero,opos,oang)

			draw.SimpleText(Format("%.6f %.6f %.6f",delta.x,delta.y,delta.z),"BudgetLabel",ScrW()/2,ScrH()/2+h,nil,1)
		end
	end
end

function TOOL:Think()
	if !IsFirstTimePredicted() and !game.SinglePlayer() then return end

	self.Information = {self.Informations["nopanel"]}

	if !IsValid(self:GetCPanel()) then return end

	if Trolleybus_System.ContactNetwork.NotLoaded then
		self.Information[1] = self.Informations["notloaded"]

		return
	end
	
	for k,v in pairs(self:GetSelectedObjects()) do
		if !v:IsValid() then
			self:UnselectObject(k)
		end
	end

	for k,v in pairs(self:GetSelectedConnectables()) do
		for k2,v2 in pairs(v) do
			local mobj,mid = v2:GetMainConnectable(k2)

			if mobj!=v2 or mid!=k2 then
				local mname = table.KeyFromValue(self:GetSelectedObjects(),mobj)

				if mname then
					self:UnselectConnectable(k,k2)
					self:SelectConnectable(mname,mid)
				end
			end
		end
	end
	
	if self:IsPivotMoving() then
		local move = self:GetCPanel().MoveData
		local pos,ang = self:GetPivotPosition()
		
		if (move.Rotation and ang or pos)!=move.Last then
			self:PivotMoveUpdate(move,pos,ang)
			move.Last = move.Rotation and ang or pos
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

function TOOL:StartMovingPivot(k,v)
	local hovered = self:GetCachedData("GetPivotHovered")
	local pivotpos,pivotang = self:GetCachedData("GetPivotPosition")
	local starts = {self:GetCachedData("GetPivotHoverPos")}
	
	if self:GetCPanel().PivotRotateMode then
		local ang = Angle(pivotang)
		if hovered==0 then ang:RotateAroundAxis(ang:Up(),90) end
		if hovered==1 then ang:RotateAroundAxis(-ang:Right(),90) end
		
		self:GetCPanel().MoveData = {Rotation = true,Pos = pivotpos,Ang = pivotang,Plane = {pivotpos,ang},Hovered = hovered,Start = self:GetRotateToPosition(starts[hovered+1])}
	else
		local ang
		local dir = hovered==0 and pivotang:Forward() or hovered==1 and -pivotang:Right() or hovered==2 and pivotang:Up()

		if dir then
			ang = self:LineToPlane(pivotpos,dir,self:GetCachedData("EyePos"))
		else
			ang = Angle(pivotang)
			if hovered==4 then ang:RotateAroundAxis(ang:Up(),90) ang:RotateAroundAxis(ang:Forward(),90) end
			if hovered==5 then ang:RotateAroundAxis(-ang:Right(),-90) ang:RotateAroundAxis(ang:Forward(),-90) end
		end
		
		self:GetCPanel().MoveData = {Rotation = false,Pos = pivotpos,Ang = pivotang,Plane = {pivotpos,dir and ang:Forward() or ang},Hovered = hovered,Start = starts[hovered+1]}
	end
	
	self:GetCPanel().MoveData.Last = self:GetCPanel().MoveData.Start
	
	if k then self:GetCPanel().MoveData[k] = v end
end

function TOOL:PivotMoveUpdate(move,pos,ang)
	if move.Objects then
		for k,v in pairs(move.Objects) do
			if v.Object:IsValid() and v.Object:IsMovable() then
				local pos,ang = LocalToWorld(v.LPos,v.LAng,pos,ang)
				
				v.Object:SetPos(pos)
				v.Object:SetAngles(ang)
			end
		end
	elseif self:GetCPanel().PivotMove and move.Object then
		if move.Rotation then
			self:GetCPanel().ObjectsLocalPivotAng[move.Object[1]] = select(2,WorldToLocal(vector_origin,ang,move.Object[2]:GetPos(),move.Object[2]:GetAngles()))
		else
			self:GetCPanel().ObjectsLocalPivotPos[move.Object[1]] = WorldToLocal(pos,angle_zero,move.Object[2]:GetPos(),move.Object[2]:GetAngles())
		end
	elseif move.Connectables then
		for k,v in pairs(move.Connectables) do
			local obj,id = v.Object:GetMainConnectable(k[2])
			local pos,ang = LocalToWorld(v.LPos,v.LAng,pos,ang)
			
			obj:SetConnectablePos(id,pos)
			obj:SetConnectableAngles(id,ang)
		end
	elseif move.NewObject then
		move.NewObject:Update(pos,ang)
	elseif move.CopyObjects then
		move.CopyObjects:Update(pos,ang)
	end
end

function TOOL:ApplyPivotMove(move,pos,ang)
	if move.Objects then
		net.Start("Trolleybus_System.ContactNetworkEditor")
			net.WriteUInt(0,4)
			
			for k,v in pairs(move.Objects) do
				if !v.Object:IsMovable() then continue end

				net.WriteBool(true)
				net.WriteString(k)
				net.WriteVector(v.Object:GetPos())
				net.WriteAngle(v.Object:GetAngles())
			end

			net.WriteBool(false)

		net.SendToServer()
	elseif move.Connectables then
		net.Start("Trolleybus_System.ContactNetworkEditor")
			net.WriteUInt(1,4)
			
			for k,v in pairs(move.Connectables) do
				if !v.Object:IsConnectableMovable(k[2]) then continue end

				net.WriteBool(true)
				net.WriteString(k[1])
				net.WriteUInt(k[2],8)
				net.WriteVector(v.Object:GetConnectablePos(k[2]))
				net.WriteAngle(v.Object:GetConnectableAngles(k[2]))
			end

			net.WriteBool(false)

		net.SendToServer()
	elseif move.NewObject then
		net.Start("Trolleybus_System.ContactNetworkEditor")
			net.WriteUInt(2,4)
			net.WriteUInt(move.NewObject.Class,8)
			net.WriteString(move.NewObject.Type)
			net.WriteVector(pos)
			net.WriteAngle(ang)
		net.SendToServer()
	elseif move.CopyObjects then
		net.Start("Trolleybus_System.ContactNetworkEditor")
			net.WriteUInt(7,4)

			for k,v in pairs(move.CopyObjects.CopyData) do
				net.WriteBool(true)
				net.WriteString(k)
				net.WriteTable(v.Data)

				local p,a = LocalToWorld(v.Pos,v.Ang,pos,ang)
				net.WriteVector(p)
				net.WriteAngle(a)

				for k,v in ipairs(v.Connectables) do
					net.WriteUInt(k,8)

					local p,a = LocalToWorld(v[1],v[2],pos,ang)
					net.WriteVector(p)
					net.WriteAngle(a)

					if v[3] then
						net.WriteBool(true)
						net.WriteString(v[3])
						net.WriteUInt(v[4],8)
					else
						net.WriteBool(false)
					end
				end

				net.WriteUInt(0,8)
			end

			net.WriteBool(false)

		net.SendToServer()
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

function TOOL:CanSelectObject()
	return !self:IsPivotMoving() and !self:CanConnectConnectables() and (self:EActive() or table.IsEmpty(self:GetSelectedObjects())) and table.IsEmpty(self:GetSelectedConnectables())
end

function TOOL:CanSelectConnectable()
	return !self:IsPivotMoving() and !self:CanConnectConnectables() and !table.IsEmpty(self:GetSelectedObjects()) and (table.IsEmpty(self:GetSelectedConnectables()) or self:EActive())
end

function TOOL:SelectObject(name,object)
	self:GetSelectedObjects()[name] = object

	self:GetCPanel():SetupProperties(self:GetSelectedObjects())
end

function TOOL:UnselectObject(name)
	self:GetSelectedObjects()[name] = nil
	self:GetSelectedConnectables()[name] = nil
	
	if table.IsEmpty(self:GetSelectedObjects()) then
		self:GetCPanel().PivotMove = nil
		self:GetCPanel().MoveData = nil
	end
		
	self:GetCPanel():SetupProperties(self:GetSelectedObjects())
end

function TOOL:SelectConnectable(name,id)
	self:GetSelectedConnectables()[name] = self:GetSelectedConnectables()[name] or {}
	self:GetSelectedConnectables()[name][id] = self:GetSelectedObjects()[name]
	
	self:GetCPanel().PivotMove = false
end

function TOOL:UnselectConnectable(name,id)
	if self:GetSelectedConnectables()[name] then
		self:GetSelectedConnectables()[name][id] = nil
		
		if table.IsEmpty(self:GetSelectedConnectables()[name]) then
			self:GetSelectedConnectables()[name] = nil
		end
	end
end

function TOOL:GetSelectedObjects()
	return self:GetCPanel().SelectedObjects
end

function TOOL:GetSelectedConnectables()
	return self:GetCPanel().SelectedConnectables
end

function TOOL:GetCachedData(data)
	self.CachedDataTypes = self.CachedDataTypes or {
		["EyePos"] = {function() return Trolleybus_System.EyePos() end,false},
		["EyeAngles"] = {function() return Trolleybus_System.EyeAngles() end,false},
		["EyeVector"] = {function() return Trolleybus_System.EyeVector() end,false},
		["CNObjectsDrawDistance"] = {function() return Trolleybus_System.GetPlayerSetting("CNObjectsDrawDistance") or 1000 end,false},
		["GetPivotPosition"] = {function() return {self:GetPivotPosition()} end,true},
		["GetPivotHoverPos"] = {function() return {self:GetPivotHoverPos(self:GetCachedData("GetPivotPosition"))} end,true},
		["GetPivotHovered"] = {function() return self:GetPivotHovered(self:GetCachedData("GetPivotPosition")) end,false},
		["GetHoveredObject"] = {function() return {self:GetHoveredObject()} end,true},
		["GetHoveredObjectIgnoreSelected"] = {function() return {self:GetHoveredObject(true)} end,true},
		["GetHoveredObjectOnlySelected"] = {function() return {self:GetHoveredObject(false,true)} end,true},
		["GetHoveredConnectable"] = {function() return {self:GetHoveredConnectable()} end,true},
		["GetHoveredConnectableIgnoreSelected"] = {function() return {self:GetHoveredConnectable(true)} end,true},
		["GetHoveredConnectableIgnoreSelectedOnlyMovable"] = {function() return {self:GetHoveredConnectable(true,true)} end,true},
		["GetHoveredConnectableOnlySelected"] = {function() return {self:GetHoveredConnectable(false)} end,true},
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

function TOOL:GetHoveredObject(ignoretype,ignoredist)
	if !ignoredist and self:EActive() and self:RActive(true) then ignoredist = true end

	local eyepos = self:GetCachedData("EyePos")
	local eyedir = self:GetCachedData("EyeVector")
	local maxdist = !ignoredist and self:GetCachedData("CNObjectsDrawDistance")
	local selected = ignoretype!=nil and self:GetSelectedObjects()
	
	local name,object,dot

	if ignoretype==nil then
		for k,v in pairs(self:GetSelectedObjects()) do
			local pos = v:GetPos()
			if !ignoredist and eyepos:DistToSqr(pos)>maxdist*maxdist then continue end
			
			local ang = math.deg(math.acos((pos-eyepos):GetNormalized():Dot(eyedir)))
			if ang<5 and (!dot or ang<dot) then
				name,object,dot = k,v,ang
			end
		end

		if name then return object,name end
	end

	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
		if ignoretype!=nil and Either(ignoretype,selected[k],!selected[k]) then continue end
		
		local pos = v:GetPos()
		if !ignoredist and eyepos:DistToSqr(pos)>maxdist*maxdist then continue end
		
		local ang = math.deg(math.acos((pos-eyepos):GetNormalized():Dot(eyedir)))
		if ang<5 and (!dot or ang<dot) then
			name,object,dot = k,v,ang
		end
	end
	
	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.SuspensionAndOther) do
		if ignoretype!=nil and Either(ignoretype,selected[k],!selected[k]) then continue end
		
		local pos = v:GetPos()
		if !ignoredist and eyepos:DistToSqr(pos)>maxdist*maxdist then continue end
		
		local ang = math.deg(math.acos((pos-eyepos):GetNormalized():Dot(eyedir)))
		if ang<5 and (!dot or ang<dot) then
			name,object,dot = k,v,ang
		end
	end
	
	return object,name
end

function TOOL:GetHoveredConnectable(ignoretype,movable)
	local eyepos = self:GetCachedData("EyePos")
	local eyedir = self:GetCachedData("EyeVector")
	
	local name,object,id,dot

	if ignoretype==nil then
		for k,v in pairs(self:GetSelectedConnectables()) do
			for k2,v2 in pairs(v) do
				local /*mobj,mid = v2:GetMainConnectable(k2)
				local mname = k
				
				if mobj!=v2 or mid!=k2 then
					mname = table.KeyFromValue(self:GetSelectedObjects(),mobj)
					
					if !mname then
						*/mobj,mid,mname = v2,k2,k
					/*end
				end*/

				if movable and !mobj:IsConnectableMovable(mid) then continue end

				local ang = math.deg(math.acos((mobj:GetConnectablePos(mid)-eyepos):GetNormalized():Dot(eyedir)))
				if ang<5 and (!dot or ang<dot) then
					name,object,id,dot = mname,mobj,mid,ang
				end
			end
		end

		if name then return name,object,id end
	end
	
	for k,v in pairs(self:GetSelectedObjects()) do
		for i=1,v:GetConnectableCount() do
			local /*mobj,mid = v:GetMainConnectable(i)
			local mname = k
			
			if mobj!=v or mid!=i then
				mname = table.KeyFromValue(self:GetSelectedObjects(),mobj)
				
				if !mname then
					*/mobj,mid,mname = v,i,k
				/*end
			end*/

			if movable and !mobj:IsConnectableMovable(mid) then continue end
			if ignoretype!=nil and Either(ignoretype,self:GetSelectedConnectables()[mname] and self:GetSelectedConnectables()[mname][mid],!self:GetSelectedConnectables()[mname] or !self:GetSelectedConnectables()[mname][mid]) then continue end

			local ang = math.deg(math.acos((mobj:GetConnectablePos(mid)-eyepos):GetNormalized():Dot(eyedir)))
			if ang<5 and (!dot or ang<dot) then
				name,object,id,dot = mname,mobj,mid,ang
			end
		end
	end
	
	return name,object,id
end

function TOOL:Render()
	if !IsValid(self:GetCPanel()) then return end
	
	if table.IsEmpty(self:GetSelectedConnectables()) then
		local name,obj = next(self:GetSelectedObjects())
		local color = Color(100,200,0)
		
		if obj and obj.Class.Id==0 and !next(self:GetSelectedObjects(),name) then
			for i=1,obj:GetWiresCount() do
				local starti = obj.Cfg.VoltageSource and 1 or obj:GetConnectableByWire(i,false)
				local endi = obj.Cfg.VoltageSource and 2 or obj:GetConnectableByWire(i,true)

				if starti and endi then
					local voltage,positive = obj:GetWireVoltage(i)
					local start = obj:GetConnectablePos(starti)
					local endp = obj:GetConnectablePos(endi)

					self:DrawLine(start,endp,color)

					local voltsrc = obj:GetWireLinkedVoltageSource(i)
					local voltname = voltsrc and Trolleybus_System.ContactNetwork.GetObjectName(voltsrc) or "-"

					debugoverlay.Text((start+endp)/2,Format("%i. %s%.1f V (source: %s)",i,obj:GetWirePolarity(i) and "+" or "-",positive and voltage or -voltage,voltname),0.1,false)
				end
			end
		end
	end

	if self:IsPivotActive() then
		local pivotpos,pivotang = self:GetCachedData("GetPivotPosition")
		
		if self:IsPivotMoving() then
			local move = self:GetCPanel().MoveData
			local _,ang = WorldToLocal(vector_origin,self:GetCachedData("EyeAngles"),pivotpos,pivotang)
			local lgang = math.abs(ang.p)>45 and Angle(0,0,0) or math.abs(ang.y)>45 and math.abs(ang.y)<135 and Angle(90,90,0) or Angle(90,0,0)
			local _,gang = LocalToWorld(vector_origin,lgang,pivotpos,pivotang)
			
			self:DrawGrid(pivotpos,gang)
		end
		
		if pivotpos then
			self:DrawPivot(pivotpos,pivotang,self:IsPivotMoving() and self:GetCPanel().MoveData.Hovered or self:GetCachedData("GetPivotHovered"),self:IsPivotMoving(),self:GetCPanel().PivotMove,self:GetCPanel().PivotRotateMode)
		end
	end
	
	if self:CanConnectConnectables() then
		local cid,obj = next(select(2,next(self:GetSelectedConnectables())))
		local name,object,id = self:GetCachedData("GetHoveredConnectableIgnoreSelected")
		local pos = name and obj:IsConnectableConnectingAllowedTo(cid,object,id) and object:GetConnectablePos(id) or self:GetCachedData("EyePos")+self:GetCachedData("EyeVector")*5
		
		self:DrawLine(obj:GetConnectablePos(cid),pos,Color(255,0,255))
	end
	
	if self:IsPivotMoving() and (self:EActive() or self:GetCPanel().MoveData.NewObject or self:GetCPanel().MoveData.CopyObjects) then
		local tr = self:GetPlayerTrace()
		
		self:DrawLine(tr.HitPos,tr.HitPos+tr.HitNormal*self:GetClientNumber("networkheight"),color_white)
	end
end

function TOOL:DrawOutlines()
	if !IsValid(self:GetCPanel()) then return end
	
	local contacts,suspension = {},{}
	
	for k,v in pairs(self:GetSelectedObjects()) do
		if v:IsValid() and IsValid(v.CModel) then
			if v.Class.Id==0 then
				contacts[#contacts+1] = v.CModel
			elseif v.Class.Id==1 then
				suspension[#suspension+1] = v.CModel
			end
		end
	end
	
	if #contacts>0 then
		self:DrawOutline(contacts,Color(0,255,255))
	end

	if #suspension>0 then
		self:DrawOutline(suspension,Color(255,0,255))
	end
	
	if self:CanSelectObject() then
		local obj = self:GetCachedData("GetHoveredObjectIgnoreSelected")
		
		if obj and IsValid(obj.CModel) then
			if obj.Class.Id==0 then
				self:DrawOutline({obj.CModel},Color(0,155,155))
			elseif obj.Class.Id==1 then
				self:DrawOutline({obj.CModel},Color(155,0,155))
			end
		end
	end

	if self:IsPivotMoving() and self:GetCPanel().MoveData.CopyObjects then
		local models = {}

		for k,v in ipairs(self:GetCPanel().MoveData.CopyObjects.Models) do
			if IsValid(v) and IsValid(v.CModel) then
				models[#models+1] = v.CModel
			end
		end

		if #models>0 then
			self:DrawOutline(models,Color(0,155,0))
		end
	end
end

function TOOL:DrawOutline(ents,color)
	//for k,v in ipairs(ents) do
	//	local min,max = v:GetRenderBounds()
	//	render.DrawWireframeBox(v:GetPos(),v:GetAngles(),min,max,color)
	//end

	local w,h = ScrW(),ScrH()
	
	self.OutlineStoreTex = self.OutlineStoreTex or render.GetScreenEffectTexture(0)
	self.OutlineStoreMat = self.OutlineStoreMat or Material("pp/copy")
	self.OutlineTex = self.OutlineTex or GetRenderTarget("trolleybus_cn_editor_outline",w,h)
	self.OutlineMat = selfOutlineMat or CreateMaterial("trolleybus_cn_editor_outline","UnlitGeneric",{["$ignorez"] = "1",["$alphatest"] = "1",["$basetexture"] = self.OutlineTex:GetName()})
	
	render.CopyRenderTargetToTexture(self.OutlineStoreTex)
	render.Clear(0,0,0,0,false,true)
	
	render.SetStencilEnable(true)
	
		render.SetStencilWriteMask(255)
		render.SetStencilTestMask(255)
		render.SetStencilReferenceValue(1)
		
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_REPLACE)
		
		cam.IgnoreZ(true)
		
		for k,v in ipairs(ents) do
			v:DrawModel()
		end
		
		cam.IgnoreZ(false)
		
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilFailOperation(STENCIL_KEEP)
		
		cam.Start2D()
			surface.SetDrawColor(color)
			surface.DrawRect(0,0,w,h)
		cam.End2D()
	
	render.SetStencilEnable(false)
	
	render.CopyRenderTargetToTexture(self.OutlineTex)
	
	self.OutlineStoreMat:SetTexture("$basetexture",self.OutlineStoreTex)
	render.SetMaterial(self.OutlineStoreMat)
	render.DrawScreenQuad()
	
	render.SetStencilEnable(true)
		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		
		self.OutlineMat:SetTexture("$basetexture",self.OutlineTex)
		render.SetMaterial(self.OutlineMat)
		
		render.DrawScreenQuadEx(-1,-1,w,h)
		render.DrawScreenQuadEx(-1,0,w,h)
		render.DrawScreenQuadEx(-1,1,w,h)
		render.DrawScreenQuadEx(0,-1,w,h)
		render.DrawScreenQuadEx(0,1,w,h)
		render.DrawScreenQuadEx(1,-1,w,h)
		render.DrawScreenQuadEx(1,0,w,h)
		render.DrawScreenQuadEx(1,1,w,h)
		
	render.SetStencilEnable(false)
end

function TOOL:GetPivotPosition()
	if !self:IsPivotActive() then return end
	
	if self:IsPivotMoving() then
		local move = self:GetCPanel().MoveData
		
		if self:EActive() or move.NewObject or move.CopyObjects then
			local tr = self:GetPlayerTrace()
			local ang

			if move.Rotation then
				ang = tr.HitNormal:Angle()
			else
				ang = Angle(move.Ang)
				ang:RotateAroundAxis(ang:Up(),self:GetCachedData("EyeAngles").y)
			end

			local ignoreheight = self:EActive() and self:RActive(true)
			if move.CopyObjects then ignoreheight = !ignoreheight end

			return move.Rotation and move.Pos or tr.HitPos+tr.HitNormal*(ignoreheight and 0 or self:GetClientNumber("networkheight")),ang
		elseif move.Rotation then
			local hit = util.IntersectRayWithPlane(self:GetCachedData("EyePos"),self:GetCachedData("EyeVector"),move.Plane[1],move.Plane[2]:Forward())
			
			if hit then
				local pos = WorldToLocal(hit,angle_zero,move.Plane[1],move.Plane[2])
				local angle = self:GetRotateToPosition(pos)
				local diff = math.NormalizeAngle(angle-move.Start)
				local ang = Angle(move.Ang)
				local axis = move.Hovered==0 and -ang:Right() or move.Hovered==1 and -ang:Up() or move.Hovered==2 and ang:Forward()
				
				if self:GetClientBool("localang") and self:GetClientNumber("snapangle")>0 then
					diff = math.Round(diff/self:GetClientNumber("snapangle"))*self:GetClientNumber("snapangle")
				end
				
				ang:RotateAroundAxis(axis,-diff)
				
				if !self:GetClientBool("localang") and self:GetClientNumber("snapangle")>0 then
					local axis = move.Hovered==0 and "p" or move.Hovered==1 and "y" or move.Hovered==2 and "r"
					
					ang[axis] = math.Round(ang[axis]/self:GetClientNumber("snapangle"))*self:GetClientNumber("snapangle")
				end
				
				return move.Pos,ang
			end
		else
			local multi = move.Hovered==3 and "y" or (move.Hovered==4 or move.Hovered==5) and "z"
			local ang = multi and move.Plane[2] or self:LineToPlane(move.Plane[1],move.Plane[2],self:GetCachedData("EyePos"))
			local hit = util.IntersectRayWithPlane(self:GetCachedData("EyePos"),self:GetCachedData("EyeVector"),move.Plane[1],ang:Up())
			
			if hit then
				local pos = WorldToLocal(hit,angle_zero,move.Plane[1],ang)
				local diff,diff2 = math.Clamp(pos.x-move.Start.x,-16000,16000)
				local dir,dir2

				if multi then
					diff2 = math.Clamp(pos.y-move.Start.y,-16000,16000)

					dir = move.Hovered==3 and move.Ang:Forward() or move.Hovered==4 and -move.Ang:Right() or move.Ang:Up()
					dir2 = move.Hovered==3 and -move.Ang:Right() or move.Hovered==4 and move.Ang:Up() or move.Ang:Forward()
				else
					dir = move.Hovered==0 and move.Ang:Forward() or move.Hovered==1 and -move.Ang:Right() or move.Hovered==2 and move.Ang:Up()
				end
				
				if self:GetClientBool("localang") and self:GetClientNumber("gridsize")>0 then
					diff = math.Round(diff/self:GetClientNumber("gridsize"))*self:GetClientNumber("gridsize")
					diff2 = multi and math.Round(diff2/self:GetClientNumber("gridsize"))*self:GetClientNumber("gridsize")
				end
				
				local ppos = multi and move.Pos+dir*diff+dir2*diff2 or move.Pos+dir*diff
				
				if !self:GetClientBool("localang") and self:GetClientNumber("gridsize")>0 then
					for i=1,3 do
						ppos[i] = math.Round(ppos[i]/self:GetClientNumber("gridsize"))*self:GetClientNumber("gridsize")
					end
				end
				
				return ppos,move.Ang
			end
		end
		
		return move.Pos,move.Ang
	else
		if !table.IsEmpty(self:GetSelectedConnectables()) then
			local allpos,count,ang = Vector(),0
			
			for k,v in pairs(self:GetSelectedConnectables()) do
				for k2,v2 in pairs(v) do
					allpos = allpos+v2:GetConnectablePos(k2)
					ang = ang or v2:GetConnectableAngles(k2)
					count = count+1
				end
			end
			
			return allpos/count,self:GetClientBool("localang") and ang or Angle()
		else
			local allpos,count,ang = Vector(),0
			
			for k,v in pairs(self:GetSelectedObjects()) do
				local lpos,lang = LocalToWorld(self:GetCPanel().ObjectsLocalPivotPos[k] or vector_origin,self:GetCPanel().ObjectsLocalPivotAng[k] or angle_zero,v:GetPos(),v:GetAngles())
				
				allpos = allpos+((self:GetCPanel().PivotMove or self:GetClientBool("localpos")) and lpos or v:GetPos())
				ang = ang or (self:GetCPanel().PivotMove or self:GetClientBool("localang")) and lang or v:GetAngles()
				count = count+1
			end
			
			return allpos/count,(self:GetCPanel().PivotMove or self:GetClientBool("localang")) and ang or Angle()
		end
	end
end

function TOOL:IsPivotActive()
	if self:IsPivotMoving() and (self:GetCPanel().MoveData.NewObject or self:GetCPanel().MoveData.CopyObjects) then return true end
	
	if !self:CanConnectConnectables() and !table.IsEmpty(self:GetSelectedObjects()) then
		if table.IsEmpty(self:GetSelectedConnectables()) then
			for k,v in pairs(self:GetSelectedObjects()) do
				if !v:IsMovable() then return false end
			end
		else
			for k,v in pairs(self:GetSelectedConnectables()) do
				for k2,v2 in pairs(v) do
					local mobj,mid = v2:GetMainConnectable(k2)

					if !mobj:IsConnectableMovable(mid) then return false end
				end
			end
		end

		return true
	end

	return false
end

function TOOL:CanConnectConnectables()
	return self:EActive() and self:RActive(true) and !self:IsPivotMoving() and self:CanConnectSelectedConnectable()
end

function TOOL:CanConnectSelectedConnectable()
	if table.Count(self:GetSelectedConnectables())!=1 then return false end
	
	local name,cons = next(self:GetSelectedConnectables())
	if table.Count(cons)!=1 then return false end

	local con,obj = next(cons)
	if obj:IsConnectableForModelChangeOnly(con) then return false end

	return true
end

function TOOL:IsPivotMoving()
	return self:GetCPanel().MoveData and true or false
end

function TOOL:DistanceCheck(pos)
	if !self:EActive() or !self:RActive(true) then
		local eyepos = self:GetCachedData("EyePos")
		local maxdist = self:GetCachedData("CNObjectsDrawDistance")
		
		return eyepos:DistToSqr(pos)<maxdist*maxdist
	end

	return true
end

function TOOL:DrawPoint(pos,color,outlined,distcheck)
	if distcheck and !self:DistanceCheck(pos) then return end
	if color then surface.SetDrawColor(color) end
	
	local p = pos:ToScreen()
	if !p.visible then return end
	
	if outlined then
		surface.DrawOutlinedRect(p.x-self.ElementSize/2,p.y-self.ElementSize/2,self.ElementSize,self.ElementSize)
	else
		surface.DrawRect(p.x-self.ElementSize/2,p.y-self.ElementSize/2,self.ElementSize,self.ElementSize)
	end
	
	return true
end

function TOOL:DrawPivot(pos,ang,hovered,moving,pivotmove,rottype)
	render.SetColorMaterial()
	
	local addcol = moving and 50 or 0
	local redcolor = Color(255,hovered==0 and 150+addcol or 0,hovered==0 and 150+addcol or 0)
	local redcolora = ColorAlpha(redcolor,20)
	local greencolor = Color(hovered==1 and 150+addcol or 0,255,hovered==1 and 150+addcol or 0)
	local greencolora = ColorAlpha(greencolor,20)
	local bluecolor = Color(hovered==2 and 150+addcol or 0,hovered==2 and 150+addcol or 0,255)
	local bluecolora = ColorAlpha(bluecolor,20)
	
	local sizemp = self:GetClientNumber("pivotsize")/100
	local pivotsize = self.PivotSize*sizemp
	local pivotarrowsize = self.PivotArrowSize*sizemp

	if rottype then
		local segments = 16
		local angle = math.rad(360/segments)
		local frwd,left,up = ang:Forward(),-ang:Right(),ang:Up()
		
		self:DrawLine(pos,pos+frwd*pivotsize,redcolor,redcolora)
		self:DrawLine(pos,pos+left*pivotsize,greencolor,greencolora)
		self:DrawLine(pos,pos+up*pivotsize,bluecolor,bluecolora)
		
		for i=1,segments do
			local from,to = angle*(i-1),angle*i
			local x1,y1 = math.sin(from)*pivotsize,math.cos(from)*pivotsize
			local x2,y2 = math.sin(to)*pivotsize,math.cos(to)*pivotsize
			
			self:DrawLine(pos+frwd*x1+up*y1,pos+frwd*x2+up*y2,redcolor,redcolora)
			self:DrawLine(pos+left*x1+frwd*y1,pos+left*x2+frwd*y2,greencolor,greencolora)
			self:DrawLine(pos+left*x1+up*y1,pos+left*x2+up*y2,bluecolor,bluecolora)
		end
	else
		local eyepos = Trolleybus_System.EyePos()
		local redang = self:LineToPlane(pos,ang:Forward(),eyepos)
		local greenang = self:LineToPlane(pos,-ang:Right(),eyepos)
		local blueang = self:LineToPlane(pos,ang:Up(),eyepos)
		
		local multidist = pivotarrowsize*2
		local redgreencolor = Color(255,255,hovered==3 and 150+addcol or 0)
		local redgreencolora = ColorAlpha(redgreencolor,20)
		local greenbluecolor = Color(hovered==4 and 150+addcol or 0,255,255)
		local greenbluecolora = ColorAlpha(greenbluecolor,20)
		local redbluecolor = Color(255,hovered==5 and 150+addcol or 0,255)
		local redbluecolora = ColorAlpha(redbluecolor,20)

		for i=1,3 do
			local ang1 = i==2 and greenang or redang
			local ang2 = i==1 and greenang or blueang
			local col = i==1 and redgreencolor or i==2 and greenbluecolor or redbluecolor
			local cola = i==1 and redgreencolora or i==2 and greenbluecolora or redbluecolora

			local pos2 = pos+ang1:Forward()*multidist
			local pos3 = pos+ang2:Forward()*multidist
			local pos4 = pos3+(pos2-pos)

			self:DrawLine(pos2,pos4,col,cola)
			self:DrawLine(pos3,pos4,col,cola)

			local ang = i==1 and redang or i==2 and greenang or blueang
			local col,cola = i==1 and redcolor or i==2 and greencolor or bluecolor,i==1 and redcolora or i==2 and greencolora or bluecolora

			self:DrawLine(pos,pos+ang:Forward()*pivotsize,col,cola)
			self:DrawLine(pos+ang:Forward()*pivotsize,pos+ang:Forward()*(pivotsize-pivotarrowsize)+ang:Right()*pivotarrowsize,col,cola)
			self:DrawLine(pos+ang:Forward()*pivotsize,pos+ang:Forward()*(pivotsize-pivotarrowsize)-ang:Right()*pivotarrowsize,col,cola)
		end
	end
	
	if pivotmove or table.Count(self:GetSelectedObjects())==1 and table.IsEmpty(self:GetSelectedConnectables()) then
		self:DrawBox(pos,ang,pivotarrowsize,hovered==6 and Color(255,255,0) or color_white,nil,!pivotmove)
	end
end

function TOOL:DrawBox(pos,ang,size,color,colora,wireframe)
	size = size/2
	if !colora then colora = ColorAlpha(color,20) end
	
	local min,max = Vector(-size,-size,-size),Vector(size,size,size)
	
	if wireframe then
		render.DrawWireframeBox(pos,ang,min,max,colora)
		render.DrawWireframeBox(pos,ang,min,max,color,true)
	else
		cam.IgnoreZ(true)
			render.DrawBox(pos,ang,min,max,colora)
		cam.IgnoreZ(false)
		
		render.DrawBox(pos,ang,min,max,color)
	end
end

function TOOL:DrawGrid(pos,ang)
	local color = Color(255,255,255,50)
	local colora = ColorAlpha(color,20)
	local forward,right = ang:Forward(),ang:Right()
	
	if self:GetCPanel().PivotRotateMode then
		/*local snapangle = self:GetClientNumber("snapangle")
		if snapangle==0 then return end
		
		local color = color_white
		local colora = ColorAlpha(color,20)
		
		for i=0,360-snapangle,snapangle do
			local x1,y1 = math.cos(math.rad(i)),math.sin(math.rad(i))
			local x2,y2 = math.cos(math.rad(i+snapangle)),math.sin(math.rad(i+snapangle))
			
			self:DrawLine(pos+forward*x1*self.GridRotCellSize-right*y1*self.GridRotCellSize,pos+forward*x2*self.GridRotCellSize-right*y2*self.GridRotCellSize,color,colora)
			self:DrawLine(pos,pos+forward*x1*self.GridRotCellSize-right*y1*self.GridRotCellSize,color,colora)
		end*/
	else
		local gridsize = self:GetClientNumber("gridsize")
		if gridsize==0 then return end
		
		for i=-self.GridCells,self.GridCells do
			self:DrawLine(pos+forward*i*gridsize-right*gridsize*self.GridCells,pos+forward*i*gridsize+right*gridsize*self.GridCells,color,colora)
			self:DrawLine(pos+right*i*gridsize-forward*gridsize*self.GridCells,pos+right*i*gridsize+forward*gridsize*self.GridCells,color,colora)
		end
	end
end

function TOOL:DrawLine(pos1,pos2,color,colora)
	if !colora then colora = ColorAlpha(color,20) end
	
	render.DrawLine(pos1,pos2,colora)
	render.DrawLine(pos1,pos2,color,true)
end

function TOOL:GetPivotHoverPos(pos,ang)
	local eyepos = self:GetCachedData("EyePos")
	local eyedir = self:GetCachedData("EyeVector")
	
	if self:GetCPanel().PivotRotateMode then
		local redang = Angle(ang)
		redang:RotateAroundAxis(ang:Up(),90)
		local greenang = Angle(ang)
		greenang:RotateAroundAxis(-ang:Right(),90)
		local blueang = Angle(ang)
		
		local redhit = util.IntersectRayWithPlane(eyepos,eyedir,pos,redang:Forward())
		local greenhit = util.IntersectRayWithPlane(eyepos,eyedir,pos,greenang:Forward())
		local bluehit = util.IntersectRayWithPlane(eyepos,eyedir,pos,blueang:Forward())
		
		return
			redhit and WorldToLocal(redhit,angle_zero,pos,redang),
			greenhit and WorldToLocal(greenhit,angle_zero,pos,greenang),
			bluehit and WorldToLocal(bluehit,angle_zero,pos,blueang)
	else
		local redang = self:LineToPlane(pos,ang:Forward(),eyepos)
		local greenang = self:LineToPlane(pos,-ang:Right(),eyepos)
		local blueang = self:LineToPlane(pos,ang:Up(),eyepos)
		local redgreenang = Angle(ang)
		local greenblueang = Angle(ang)
		greenblueang:RotateAroundAxis(greenblueang:Up(),90)
		greenblueang:RotateAroundAxis(greenblueang:Forward(),90)
		local redblueang = Angle(ang)
		redblueang:RotateAroundAxis(-redblueang:Right(),-90)
		redblueang:RotateAroundAxis(redblueang:Forward(),-90)
		
		local redhit = util.IntersectRayWithPlane(eyepos,eyedir,pos,redang:Up())
		local greenhit = util.IntersectRayWithPlane(eyepos,eyedir,pos,greenang:Up())
		local bluehit = util.IntersectRayWithPlane(eyepos,eyedir,pos,blueang:Up())
		local redgreenhit = util.IntersectRayWithPlane(eyepos,eyedir,pos,redgreenang:Up())
		local greenbluehit = util.IntersectRayWithPlane(eyepos,eyedir,pos,greenblueang:Up())
		local redbluehit = util.IntersectRayWithPlane(eyepos,eyedir,pos,redblueang:Up())
		
		return
			redhit and WorldToLocal(redhit,angle_zero,pos,redang),
			greenhit and WorldToLocal(greenhit,angle_zero,pos,greenang),
			bluehit and WorldToLocal(bluehit,angle_zero,pos,blueang),
			redgreenhit and WorldToLocal(redgreenhit,angle_zero,pos,redgreenang),
			greenbluehit and WorldToLocal(greenbluehit,angle_zero,pos,greenblueang),
			redbluehit and WorldToLocal(redbluehit,angle_zero,pos,redblueang)
	end
end

function TOOL:GetPivotHovered(pos,ang)
	local sizemp = self:GetClientNumber("pivotsize")/100
	local pivotsize = self.PivotSize*sizemp
	local pivotarrowsize = self.PivotArrowSize*sizemp

	if table.Count(self:GetSelectedObjects())==1 and table.IsEmpty(self:GetSelectedConnectables()) then
		local centerhit = util.IntersectRayWithPlane(self:GetCachedData("EyePos"),self:GetCachedData("EyeVector"),pos,(pos-self:GetCachedData("EyePos")):GetNormalized())
		if centerhit and centerhit:DistToSqr(pos)<pivotarrowsize*pivotarrowsize then return 6 end
	end
	
	local redpos,greenpos,bluepos,redgreenpos,greenbluepos,redbluepos = self:GetCachedData("GetPivotHoverPos")
	
	if self:GetCPanel().PivotRotateMode then
		local reddist = redpos and redpos.y*redpos.y+redpos.z*redpos.z
		local greendist = greenpos and greenpos.y*greenpos.y+greenpos.z*greenpos.z
		local bluedist = bluepos and bluepos.y*bluepos.y+bluepos.z*bluepos.z
		local centerdist = pivotsize*pivotsize
		local maxdist = (pivotarrowsize+pivotsize)^2
		
		local pos = {}
		if reddist and reddist<maxdist then pos[#pos+1] = {redpos,math.abs(reddist-centerdist)} end
		if greendist and greendist<maxdist then pos[#pos+1] = {greenpos,math.abs(greendist-centerdist)} end
		if bluedist and bluedist<maxdist then pos[#pos+1] = {bluepos,math.abs(bluedist-centerdist)} end
		
		local min
		for i=1,#pos do
			if !min or pos[i][2]<min[2] then min = pos[i] end
		end
		
		return min and (min[1]==redpos and 0 or min[1]==greenpos and 1 or min[1]==bluepos and 2) or nil
	else
		local multidist = pivotarrowsize*2
		local maxdist = multidist*multidist*2

		local pos = {}
		if redgreenpos and redgreenpos.x>=0 and redgreenpos.x<multidist and redgreenpos.y>=0 and redgreenpos.y<multidist  then pos[#pos+1] = redgreenpos end
		if greenbluepos and greenbluepos.x>=0 and greenbluepos.x<multidist and greenbluepos.y>=0 and greenbluepos.y<multidist then pos[#pos+1] = greenbluepos end
		if redbluepos and redbluepos.x>=0 and redbluepos.x<multidist and redbluepos.y>=0 and redbluepos.y<multidist then pos[#pos+1] = redbluepos end
		
		local min
		for i=1,#pos do
			if !min or pos[i].x*pos[i].x+pos[i].y*pos[i].y<min.x*min.x+min.y*min.y then min = pos[i] end
		end
		
		if min then
			return min==redgreenpos and 3 or min==greenbluepos and 4 or min==redbluepos and 5
		end
		
		local pos = {}
		if redpos and redpos.x>=0 and redpos.x<pivotsize and redpos.y<pivotarrowsize and redpos.y>-pivotarrowsize then pos[#pos+1] = redpos end
		if greenpos and greenpos.x>=0 and greenpos.x<pivotsize and greenpos.y<pivotarrowsize and greenpos.y>-pivotarrowsize then pos[#pos+1] = greenpos end
		if bluepos and bluepos.x>=0 and bluepos.x<pivotsize and bluepos.y<pivotarrowsize and bluepos.y>-pivotarrowsize then pos[#pos+1] = bluepos end
		
		local min
		for i=1,#pos do
			if !min or math.abs(pos[i].y)<min.y then min = pos[i] end
		end
		
		return min and (min==redpos and 0 or min==greenpos and 1 or min==bluepos and 2) or nil
	end
end

function TOOL:LineToPlane(pos,dir,topos)
	local ang = dir:Angle()
	local lpos = WorldToLocal(topos,angle_zero,pos,ang)
	
	ang:RotateAroundAxis(dir,-self:GetRotateToPosition(lpos))
	
	return ang
end

function TOOL:GetRotateToPosition(lpos)
	local rot = lpos.z==0 and 0 or math.deg(math.atan(math.abs(lpos.y)/math.abs(lpos.z)))
	
	if lpos.z<0 then rot = 180-rot end
	if lpos.y<0 then rot = -rot end
	
	return rot
end

function TOOL:GetClientBool(var)
	return tobool(self:GetClientInfo(var))
end

function TOOL:GetCPanel()
	local pnl = controlpanel.Get("trolleybus_cn_editor")
	if !pnl.SelectedObjects then pnl = nil end
	
	return pnl
end

function TOOL:GetPlayerTrace()
	return util.TraceLine({start = self:GetCachedData("EyePos"),endpos = self:GetCachedData("EyePos")+self:GetCachedData("EyeVector")*10000,mask = MASK_NPCWORLDSTATIC})
end

local function StartCopyObjects(pnl,data)
	local wep = pnl:GetWep()
	local tool = pnl:GetTool()

	if tool and !tool:IsPivotMoving() then
		data = table.Copy(data)

		for k,v in pairs(data) do
			if !Trolleybus_System.ContactNetwork.Types.Contacts[v.Data.Type] and !Trolleybus_System.ContactNetwork.Types.SuspensionAndOther[v.Data.Type] then
				data[k] = nil

				for k2,v2 in pairs(data) do
					for k3,v3 in pairs(v2.Connectables) do
						if v3[3] and v3[3]==k then
							v3[3] = nil
							v3[4] = nil
						end
					end
				end
			end
		end

		local dt = {CopyData = data,Models = {},Update = function(self,pos,ang)
			for k,v in ipairs(self.Models) do
				if IsValid(v) then v:Remove() end
			end

			self.Models = {}

			for k,v in pairs(data) do
				local model = Trolleybus_System.ContactNetwork.CreateFromTransmitData(v.Data)
				if !model then continue end

				table.insert(self.Models,model)

				local p,a = LocalToWorld(v.Pos,v.Ang,pos,ang)
				model:SetPos(p)
				model:SetAngles(a)

				for k,v in ipairs(v.Connectables) do
					local p,a = LocalToWorld(v[1],v[2],pos,ang)

					model:SetConnectablePos(k,p)
					model:SetConnectableAngles(k,a)
				end

				model:UpdateVisibility()
			end

			hook.Add("Think","trolleybus_cn_editor_copyobjects",function()
				if !IsValid(wep) or !IsValid(pnl) or wep!=pnl:GetWep() or !IsValid(tool:GetCPanel()) or !tool:IsPivotMoving() or pnl.MoveData.CopyObjects!=self then
					hook.Remove("Think","trolleybus_cn_editor_copyobjects")

					for k,v in ipairs(self.Models) do
						if IsValid(v) then v:Remove() end
					end
				end
			end)
		end}

		pnl.MoveData = {Rotation = false,Pos = Vector(),Ang = Angle(),CopyObjects = dt}
		table.Empty(pnl.SelectedObjects)
		table.Empty(pnl.SelectedConnectables)
	end
end

function TOOL.BuildCPanel(pnl)
	pnl.SelectedObjects = {}
	pnl.SelectedConnectables = {}
	pnl.ObjectsLocalPivotPos = {}
	pnl.ObjectsLocalPivotAng = {}

	pnl.GetWep = function(self)
		local wep = LocalPlayer():GetActiveWeapon()

		if IsValid(wep) and wep:GetClass()=="gmod_tool" and wep.Mode=="trolleybus_cn_editor" then
			return wep
		end
	end
	pnl.GetTool = function(self)
		local wep = self:GetWep()
		if wep then
			local tool = wep:GetToolObject()

			if tool:Allowed() then return tool end
		end
	end
	
	local create = vgui.Create("DForm",pnl)
	create:Dock(TOP)
	create:DockMargin(5,5,5,0)
	create:SetName(L"tool.trolleybus_cn_editor.ui.create")
	
	local create_sheet = vgui.Create("DPropertySheet",create)
	create_sheet:Dock(TOP)
	create_sheet:DockMargin(5,5,5,5)
	create_sheet:SetTall(200)
	
	local create_sheet_contacts = vgui.Create("DScrollPanel")
	create_sheet_contacts.Paint = nil
	
	for k,v in SortedPairsByMemberValue(Trolleybus_System.ContactNetwork.Types.Contacts,"Name") do
		local btn = vgui.Create("DButton",create_sheet_contacts)
		btn:Dock(TOP)
		btn:DockMargin(5,5,5,0)
		btn:SetText(v.Name)
		btn.DoClick = function(s)
			if Trolleybus_System.ContactNetwork.NotLoaded then return end

			local wep = pnl:GetWep()
			local tool = pnl:GetTool()

			if tool then
				local data = {Class = 0,Type = k,Update = function(self,pos,ang)
					if IsValid(self.Model) then self.Model:Remove() end
					
					self.Model = Trolleybus_System.ContactNetwork.CreateContact(k,pos,ang)
					hook.Add("Think",self.Model,function(ent) if !IsValid(wep) or wep!=pnl:GetWep() or !IsValid(tool:GetCPanel()) or !tool:IsPivotMoving() or pnl.MoveData.NewObject!=self then ent:Remove() end end)
				end}
				
				pnl.MoveData = {Rotation = false,Pos = Vector(),Ang = Angle(),NewObject = data}
				table.Empty(pnl.SelectedObjects)
				table.Empty(pnl.SelectedConnectables)
			end
		end
	end
	
	create_sheet:AddSheet(L"tool.trolleybus_cn_editor.ui.create.contacts",create_sheet_contacts)
	
	local create_sheet_other = vgui.Create("DScrollPanel")
	create_sheet_other.Paint = nil
	
	for k,v in SortedPairsByMemberValue(Trolleybus_System.ContactNetwork.Types.SuspensionAndOther,"Name") do
		local btn = vgui.Create("DButton",create_sheet_other)
		btn:Dock(TOP)
		btn:DockMargin(5,5,5,0)
		btn:SetText(v.Name)
		btn.DoClick = function(s)
			if Trolleybus_System.ContactNetwork.NotLoaded then return end

			local wep = pnl:GetWep()
			local tool = pnl:GetTool()

			if tool then
				local data = {Class = 1,Type = k,Update = function(self,pos,ang)
					if IsValid(self.Model) then self.Model:Remove() end
					
					self.Model = Trolleybus_System.ContactNetwork.CreateSuspensionAndOther(k,pos,ang)
					hook.Add("Think",self.Model,function(ent) if !IsValid(wep) or wep!=pnl:GetWep() or !IsValid(tool:GetCPanel()) or !tool:IsPivotMoving() or pnl.MoveData.NewObject!=self then ent:Remove() end end)
				end}
				
				pnl.MoveData = {Rotation = false,Pos = Vector(),Ang = Angle(),NewObject = data}
				table.Empty(pnl.SelectedObjects)
				table.Empty(pnl.SelectedConnectables)
			end
		end
	end
	
	create_sheet:AddSheet(L"tool.trolleybus_cn_editor.ui.create.suspensionandother",create_sheet_other)
	
	local copyobjects = vgui.Create("DButton",pnl)
	copyobjects:Dock(TOP)
	copyobjects:DockMargin(5,5,5,0)
	copyobjects:SetText(L"tool.trolleybus_cn_editor.ui.copy_objects")
	copyobjects.DoClick = function(s)
		if table.IsEmpty(pnl.SelectedObjects) then return end
		if Trolleybus_System.ContactNetwork.NotLoaded then return end

		local wep = pnl:GetWep()
		local tool = pnl:GetTool()

		if tool and !tool:IsPivotMoving() then
			local data = {}

			local tr = tool:GetPlayerTrace()
			local pos = tr.HitPos
			local ang = Angle(0,tool:GetCachedData("EyeAngles").y,0)

			for k,v in pairs(pnl.SelectedObjects) do
				local lpos,lang = WorldToLocal(v:GetPos(),v:GetAngles(),pos,ang)

				data[k] = {
					Data = Trolleybus_System.ContactNetwork.GetObjectData(k),
					Pos = lpos,
					Ang = lang,
					Connectables = {},
				}

				for i=1,v:GetConnectableCount() do
					local lpos,lang = WorldToLocal(v:GetConnectablePos(i),v:GetConnectableAngles(i),pos,ang)
					data[k].Connectables[i] = {lpos,lang}

					local cobj,cid = v:GetConnectableConnect(i)
					if cobj and pnl.SelectedObjects[Trolleybus_System.ContactNetwork.GetObjectName(cobj)] then
						data[k].Connectables[i][3] = Trolleybus_System.ContactNetwork.GetObjectName(cobj)
						data[k].Connectables[i][4] = cid
					end
				end
			end

			StartCopyObjects(pnl,data)
		end
	end

	local saveobjects = vgui.Create("DButton",pnl)
	saveobjects:Dock(TOP)
	saveobjects:DockMargin(5,5,5,0)
	saveobjects:SetText(L"tool.trolleybus_cn_editor.ui.save_objects")
	saveobjects.DoClick = function(s)
		if Trolleybus_System.ContactNetwork.NotLoaded then return end

		local tool = pnl:GetTool()

		if tool and tool:IsPivotMoving() and pnl.MoveData.CopyObjects then
			local data = pnl.MoveData.CopyObjects.CopyData
			local str = util.Compress(util.TableToJSON(data))
			if !str then return end

			Derma_StringRequest(L"tool.trolleybus_cn_editor.ui.save_objects.title",L"tool.trolleybus_cn_editor.ui.save_objects.desc","",function(text)
				if !file.Exists("trolleybus_cn_editor_savedobjects","DATA") then file.CreateDir("trolleybus_cn_editor_savedobjects") end

				local function save(id)
					local f = file.Open("trolleybus_cn_editor_savedobjects/"..id..".txt","wb","DATA")
					if f then
						f:WriteUShort(#text)
						f:Write(text)
						f:WriteULong(#str)
						f:Write(str)
						f:Close()
					else
						Derma_Query(L"tool.trolleybus_cn_editor.ui.save_objects.failed",L"tool.trolleybus_cn_editor.ui.save_objects.failedtitle","OK")
					end
				end

				local ids = {}

				for k,v in ipairs(file.Find("trolleybus_cn_editor_savedobjects/*.txt","DATA")) do
					local cid = tonumber(string.StripExtension(v))

					if cid then
						ids[#ids+1] = cid
					end
				end

				table.sort(ids,function(a,b) return a<b end)

				for k,v in ipairs(ids) do
					local f = file.Open("trolleybus_cn_editor_savedobjects/"..v..".txt","rb","DATA")

					if f then
						local len = f:ReadUShort()
						local name = f:Read(len)
						f:Close()

						if name==text then
							Derma_Query(L"tool.trolleybus_cn_editor.ui.save_objects.overridedesc",L"tool.trolleybus_cn_editor.ui.save_objects.overridetitle",L"tool.trolleybus_cn_editor.ui.save_objects.overrideyes",function()
								save(v)
							end,L"tool.trolleybus_cn_editor.ui.save_objects.overrideno")

							return
						end
					end
				end

				save((ids[#ids] or 0)+1)
			end)
		end
	end

	local loadobjects = vgui.Create("DButton",pnl)
	loadobjects:Dock(TOP)
	loadobjects:DockMargin(5,5,5,0)
	loadobjects:SetText(L"tool.trolleybus_cn_editor.ui.load_objects")
	loadobjects.DoClick = function(s)
		if Trolleybus_System.ContactNetwork.NotLoaded then return end

		local tool = pnl:GetTool()

		if tool and !tool:IsPivotMoving() then
			local frame = vgui.Create("DFrame")
			frame:SetSize(300,400)
			frame:Center()
			frame:MakePopup()
			frame:SetTitle(L"tool.trolleybus_cn_editor.ui.load_objects.title")
			frame:SetSizable(true)

			local scroll = vgui.Create("DScrollPanel",frame)
			scroll:Dock(FILL)

			if file.Exists("trolleybus_cn_editor_savedobjects","DATA") then
				for k,v in ipairs(file.Find("trolleybus_cn_editor_savedobjects/*.txt","DATA","nameasc")) do
					local f = file.Open("trolleybus_cn_editor_savedobjects/"..v,"rb","DATA")

					if f then
						local len = f:ReadUShort()
						local name = f:Read(len)

						f:Close()

						local p = vgui.Create("Panel",scroll)
						p:Dock(TOP)
						p:SetTall(24)
						
						local rb = vgui.Create("DButton",p)
						rb:Dock(RIGHT)
						rb:SetWide(24)
						rb:SetImage("icon16/bin.png")
						rb:SetText("")
						rb.DoClick = function()
							p:Remove()

							if file.Exists("trolleybus_cn_editor_savedobjects","DATA") then
								file.Delete("trolleybus_cn_editor_savedobjects/"..v)
							end
						end

						local b = vgui.Create("DButton",p)
						b:Dock(FILL)
						b:SetText(name)
						b.DoClick = function()
							local tool = pnl:GetTool()

							if tool and !tool:IsPivotMoving() and file.Exists("trolleybus_cn_editor_savedobjects","DATA") then
								local f = file.Open("trolleybus_cn_editor_savedobjects/"..v,"rb","DATA")
								if f then
									local len = f:ReadUShort()
									local name = f:Read(len)
									local strlen = f:ReadULong()
									local strdata = f:Read(strlen)
									local data = util.JSONToTable(util.Decompress(strdata))

									if data then
										frame:Remove()
										StartCopyObjects(pnl,data)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local orientation = vgui.Create("DForm",pnl)
	orientation:Dock(TOP)
	orientation:DockMargin(5,5,5,0)
	orientation:SetName(L"tool.trolleybus_cn_editor.ui.object_orientation")
	
	local orientation_localpos = vgui.Create("DCheckBoxLabel",orientation)
	orientation_localpos:Dock(TOP)
	orientation_localpos:DockMargin(5,5,5,0)
	orientation_localpos:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.localpos")
	orientation_localpos:SetTextColor(color_black)
	orientation_localpos:SetConVar("trolleybus_cn_editor_localpos")
	orientation_localpos:SetChecked(GetConVar("trolleybus_cn_editor_localpos"):GetBool())
	
	local orientation_localpos_reset = vgui.Create("DButton",orientation)
	orientation_localpos_reset:Dock(TOP)
	orientation_localpos_reset:DockMargin(5,5,5,0)
	orientation_localpos_reset:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.localpos_reset")
	orientation_localpos_reset.DoClick = function()
		for k,v in pairs(pnl.SelectedObjects) do
			pnl.ObjectsLocalPivotPos[k] = nil
		end
	end
	
	local orientation_posgrid = vgui.Create("DNumSlider",orientation)
	orientation_posgrid:Dock(TOP)
	orientation_posgrid:DockMargin(5,5,5,0)
	orientation_posgrid:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.gridsize")
	orientation_posgrid.Label:SetTextColor(color_black)
	orientation_posgrid:SetMinMax(0,50)
	orientation_posgrid:SetDecimals(1)
	orientation_posgrid:SetConVar("trolleybus_cn_editor_gridsize")
	orientation_posgrid:SetValue(GetConVar("trolleybus_cn_editor_gridsize"):GetFloat())
	
	local orientation_netheight = vgui.Create("DNumSlider",orientation)
	orientation_netheight:Dock(TOP)
	orientation_netheight:DockMargin(5,5,5,0)
	orientation_netheight:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.network_height")
	orientation_netheight.Label:SetTextColor(color_black)
	orientation_netheight:SetMinMax(50,300)
	orientation_netheight:SetDecimals(0)
	orientation_netheight:SetConVar("trolleybus_cn_editor_networkheight")
	orientation_netheight:SetValue(GetConVar("trolleybus_cn_editor_networkheight"):GetInt())
	
	local orientation_localang = vgui.Create("DCheckBoxLabel",orientation)
	orientation_localang:Dock(TOP)
	orientation_localang:DockMargin(5,5,5,0)
	orientation_localang:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.localang")
	orientation_localang:SetTextColor(color_black)
	orientation_localang:SetConVar("trolleybus_cn_editor_localang")
	orientation_localang:SetChecked(GetConVar("trolleybus_cn_editor_localang"):GetBool())
	
	local orientation_localang_reset = vgui.Create("DButton",orientation)
	orientation_localang_reset:Dock(TOP)
	orientation_localang_reset:DockMargin(5,5,5,0)
	orientation_localang_reset:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.localang_reset")
	orientation_localang_reset.DoClick = function()
		for k,v in pairs(pnl.SelectedObjects) do
			pnl.ObjectsLocalPivotAng[k] = nil
		end
	end
	
	local orientation_snapang = vgui.Create("DNumSlider",orientation)
	orientation_snapang:Dock(TOP)
	orientation_snapang:DockMargin(5,5,5,0)
	orientation_snapang:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.snapang")
	orientation_snapang.Label:SetTextColor(color_black)
	orientation_snapang:SetMinMax(0,45)
	orientation_snapang:SetDecimals(0)
	orientation_snapang:SetConVar("trolleybus_cn_editor_snapangle")
	orientation_snapang:SetValue(GetConVar("trolleybus_cn_editor_snapangle"):GetInt())

	local orientation_pivotsize = vgui.Create("DNumSlider",orientation)
	orientation_pivotsize:Dock(TOP)
	orientation_pivotsize:DockMargin(5,5,5,0)
	orientation_pivotsize:SetText(L"tool.trolleybus_cn_editor.ui.object_orientation.pivotsize")
	orientation_pivotsize.Label:SetTextColor(color_black)
	orientation_pivotsize:SetMinMax(1,100)
	orientation_pivotsize:SetDecimals(0)
	orientation_pivotsize:SetConVar("trolleybus_cn_editor_pivotsize")
	orientation_pivotsize:SetValue(GetConVar("trolleybus_cn_editor_pivotsize"):GetInt())

	local properties = vgui.Create("DForm",pnl)
	properties:Dock(TOP)
	properties:DockMargin(5,5,5,0)
	properties:SetName(L"tool.trolleybus_cn_editor.ui.properties")
	properties.Properties = {}
	properties.ClearProperties = function(self)
		for k,v in ipairs(self.Properties) do
			v:Remove()
			self.Properties[k] = nil
		end
	end
	properties.SetupProperties = function(self,objs)
		self:ClearProperties()

		local types = {}

		for name,obj in pairs(objs) do
			if table.IsEmpty(obj.Cfg.Properties) then continue end

			types[obj.Type] = types[obj.Type] or {}
			types[obj.Type][name] = obj
		end

		for type,objs in pairs(types) do
			local name,obj = next(objs)

			local form = vgui.Create("DForm",self)
			table.insert(self.Properties,form)
			form:Dock(TOP)
			form:DockMargin(5,5,0,0)
			form:SetName("("..table.Count(objs)..") "..obj.Cfg.Name)

			local ValueChanged = function(property,value)
				if !pnl:GetTool() then self:ClearProperties() return end

				local upd = false

				for k,v in pairs(objs) do
					if !IsValid(v) then objs[k] = nil upd = true end
				end

				if upd then
					if table.IsEmpty(objs) then
						form:Remove()
						table.RemoveByValue(self.Properties,form)

						return
					end

					form:SetName("("..table.Count(objs)..") "..obj.Cfg.Name)
				end

				local toupd = {}

				for k,v in pairs(objs) do
					if v:GetProperty(property)==value then continue end

					toupd[#toupd+1] = k
				end

				if #toupd>0 then
					net.Start("Trolleybus_System.ContactNetworkEditor")
						net.WriteUInt(6,4)
						net.WriteString(property)
						net.WriteType(value)

						for k,v in ipairs(toupd) do
							net.WriteString(v)
						end

						net.WriteString("")
					net.SendToServer()
				end
			end

			for k,v in pairs(obj.Cfg.Properties) do
				if v.Type=="Slider" then
					local slider = vgui.Create("DNumSlider",form)
					slider:Dock(TOP)
					slider:DockMargin(5,5,5,0)
					slider:SetText(v.Name)
					slider.Label:SetTextColor(color_black)
					slider:SetMinMax(v.Min,v.Max)
					slider:SetDecimals(v.Decimals)
					slider:SetValue(obj:GetProperty(k))
					slider.OnValueChanged = function(self,value)
						ValueChanged(k,math.Round(value,v.Decimals))
					end
				elseif v.Type=="CheckBox" then
					local checkbox = vgui.Create("DCheckBoxLabel",form)
					checkbox:Dock(TOP)
					checkbox:DockMargin(5,5,5,0)
					checkbox:SetText(v.Name)
					checkbox:SetTextColor(color_black)
					checkbox:SetValue(obj:GetProperty(k))
					checkbox.OnChange = function(self,value)
						ValueChanged(k,value)
					end
				end
			end
		end
	end

	pnl.SetupProperties = function(self,objs)
		properties:SetupProperties(objs)
	end
end

hook.Add("PreDrawEffects","Trolleybus_System.ContactNetworkEditor",function()
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep:GetClass()=="gmod_tool" and wep.Mode=="trolleybus_cn_editor" then
		wep:GetToolObject():DrawOutlines()
	end
end)

hook.Add("PostDrawTranslucentRenderables","Trolleybus_System.ContactNetworkEditor",function(depth,skybox,skybox3d)
	if skybox and skybox3d then return end
	
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) and wep:GetClass()=="gmod_tool" and wep.Mode=="trolleybus_cn_editor" then
		wep:GetToolObject():Render()
	end
end)