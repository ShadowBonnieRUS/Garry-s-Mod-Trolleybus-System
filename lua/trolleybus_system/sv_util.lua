-- Copyright © Platunov I. M., 2020 All rights reserved

util.AddNetworkString("Trolleybus_System.MassiveDataTransfer")
util.AddNetworkString("Trolleybus_System.PlayerMessage")

Trolleybus_System.MassiveDataSends = Trolleybus_System.MassiveDataSends or {}

function Trolleybus_System.SetPreventTransmit(ent,ply,stop)
	ent:SetPreventTransmit(ply,stop)
	
	ply.Trolleybus_System_PreventTransmit = ply.Trolleybus_System_PreventTransmit or {}
	ply.Trolleybus_System_PreventTransmit[ent] = stop
end

function Trolleybus_System.GetPreventTransmit(ent,ply)
	return ply.Trolleybus_System_PreventTransmit and ply.Trolleybus_System_PreventTransmit[ent] or false
end

function Trolleybus_System.EyePos(ply)
	return ply:EyePos()//ply:GetPos()+ply:GetCurrentViewOffset()
end

function Trolleybus_System.CreateWheel(self,wheeltype,pos,ang,height,constant,damping,rdamping,times,isdrive,invert,mass)
	local w = ents.Create("trolleybus_wheel")
	w:SetVehicle(self)
	w.IsDrive = isdrive
	w:SetRotate(0)
	w:SetInvertRotation(invert or false)
	w:SetType(wheeltype)
	
	w:SetPos(self:LocalToWorld(pos-Vector(0,0,height)))
	w:SetAngles(self:LocalToWorldAngles(ang))
	
	w:Spawn()
	w:GetPhysicsObject():SetMass(mass or self:GetPhysicsObject():GetMass()/4)
	self:DeleteOnRemove(w)

	Trolleybus_System.SetOwner(w,self.Owner)
	
	local len = -pos.y*2//pos.y<0 and 150 or -150
	
	local p = pos+Vector(len/2,len)
	local c = constraint.Rope(w,self,0,0,Vector(),p,self:LocalToWorld(p):Distance(w:GetPos()),0,0,0,"cable/cable2",true)
	c:DeleteOnRemove(w)
	
	local p = pos+Vector(-len/2,len)
	local c = constraint.Rope(w,self,0,0,Vector(),p,self:LocalToWorld(p):Distance(w:GetPos()),0,0,0,"cable/cable2",true)
	c:DeleteOnRemove(w)
	
	local p = pos+Vector(0,len)
	local c = constraint.Rope(w,self,0,0,Vector(),p,self:LocalToWorld(p):Distance(w:GetPos()),0,0,0,"cable/cable2",false)
	c:DeleteOnRemove(w)
	
	for i=1,times or 1 do
		local c = constraint.Elastic(w,self,0,0,vector_origin,pos-Vector(0,0,height),constant,damping,rdamping,"cable/cable2",0,false)
		c:DeleteOnRemove(w)
	end
	
	constraint.NoCollide(w,self,0,0)
	
	w:SetPos(self:LocalToWorld(pos))
	
	return w
end

function Trolleybus_System.MultiplyWheelConstant(self,wheel,mp)
	if !self.Constraints then return end
	
	for k,v in ipairs(self.Constraints) do
		local data = v:GetTable()
		
		if data.Type!="Elastic" then continue end
		
		if data.Ent1==self and data.Ent2==wheel or data.Ent2==self and data.Ent1==wheel then
			v:Fire("SetSpringConstant",data.constant*mp)
		end
	end
end

local function SendNextPart(ply)
	local data = Trolleybus_System.MassiveDataSends[ply]
	if !data or data.sending then return end

	local dt = data[1]
	if !dt then return end

	net.Start("Trolleybus_System.MassiveDataTransfer")
		local succ,callback = coroutine.resume(dt)
		if !succ then error(callback) end

		if callback then
			table.remove(data,1)

			net.WriteBool(true)
			net.WriteString(callback)
		else
			net.WriteBool(false)
		end
	net.Send(ply)

	data.sending = true
end

function Trolleybus_System.SendMassiveData(plys,data,callback)
	plys = plys or player.GetHumans()
	if !istable(plys) then plys = {plys} end

	local tosend = Trolleybus_System.CopyValue(data)

	for k,v in ipairs(plys) do
		Trolleybus_System.MassiveDataSends[v] = Trolleybus_System.MassiveDataSends[v] or {}

		local thread = coroutine.create(function()
			local stack = {data}
			local size = #stack

			while size>0 do
				local value = stack[size]

				stack[size] = nil
				size = size-1

				net.WriteBool(true)

				if istable(value) then
					net.WriteBool(true)

					size = size+1

					for k,v in pairs(value) do
						size = size+1
						stack[size] = v

						size = size+1
						stack[size] = k
					end
				else
					net.WriteBool(false)

					if !pcall(function() net.WriteType(value) end) then
						net.WriteType(nil)
					end
				end

				if net.BytesWritten()>60000 then
					net.WriteBool(false)
					coroutine.yield()
				end
			end

			net.WriteBool(false)
			return callback
		end)

		table.insert(Trolleybus_System.MassiveDataSends[v],thread)

		SendNextPart(v)
	end
end

hook.Add("PlayerDisconnected","Trolleybus_System.SendMassiveData",function(ply)
	Trolleybus_System.MassiveDataSends[ply] = nil
end)

net.Receive("Trolleybus_System.MassiveDataTransfer",function(len,ply)
	local data = Trolleybus_System.MassiveDataSends[ply]
	if !data then return end
	
	data.sending = false
	SendNextPart(ply)
end)

function Trolleybus_System.PlayerMessage(ply,type,format,...)
	net.Start("Trolleybus_System.PlayerMessage")
		net.WriteUInt(type or NOTIFY_GENERIC,4)
		net.WriteString(format)

		for k,v in ipairs({...}) do
			net.WriteBool(true)
			net.WriteType(v)
		end

		net.WriteBool(false)

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function Trolleybus_System.IsButtonsDown(ply,btns,any)
	if istable(btns) then
		for i=1,#btns do
			if !Trolleybus_System.IsButtonDown(ply,btns[i]) then
				if !any then return false end
			else
				if any then return true end
			end
		end

		return !any
	end

	return Trolleybus_System.IsButtonDown(ply,btns)
end