-- Copyright © Platunov I. M., 2021 All rights reserved

if !TOOL then return end

util.AddNetworkString("Trolleybus_System.ContactNetworkEditor")

function TOOL:LeftClick(trace)
	return false
end

function TOOL:RightClick(trace)
	return false
end

function TOOL:Reload(trace)
	return false
end

local function GetChanges(olddata,newdata)
	local changes

	for k,v in pairs(newdata) do
		if istable(v) and istable(olddata[k]) then
			local inchanges = GetChanges(olddata[k],v)

			if inchanges then
				changes = changes or {}
				changes[k] = inchanges
			end
		elseif v!=olddata[k] then
			changes = changes or {}
			changes[k] = v
		end
	end
	
	for k,v in pairs(olddata) do
		if newdata[k]==nil then
			changes = changes or {}
			changes[k] = "#nil#"
		end
	end

	return changes
end

net.Receive("Trolleybus_System.ContactNetworkEditor",function(len,ply)
	local tool = ply:GetTool("trolleybus_cn_editor")
	if !tool or !tool:Allowed() or !IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass()!="gmod_tool" or ply:GetActiveWeapon().Mode!="trolleybus_cn_editor" then return end

	local cmd = net.ReadUInt(4)
	local upd = {}

	if cmd==0 then
		while net.ReadBool() do
			local name = net.ReadString()
			local object = Trolleybus_System.ContactNetwork.GetObject(name)
			local pos = net.ReadVector()
			local ang = net.ReadAngle()

			if IsValid(object) then
				local olddata = Trolleybus_System.CopyValue(Trolleybus_System.ContactNetwork.GetObjectData(name))

				object:SetPos(pos)
				object:SetAngles(ang)

				upd[name] = GetChanges(olddata,Trolleybus_System.ContactNetwork.GetObjectData(name))
			end
		end
	elseif cmd==1 then
		while net.ReadBool() do
			local name = net.ReadString()
			local object = Trolleybus_System.ContactNetwork.GetObject(name)
			local id = net.ReadUInt(8)
			local pos = net.ReadVector()
			local ang = net.ReadAngle()

			if IsValid(object) then
				local mobj,mid,mname = object:GetMainConnectable(id)

				if mobj!=object or mid!=id then
					mname = Trolleybus_System.ContactNetwork.GetObjectName(mobj)
				else
					mobj,mid,mname = object,id,name
				end

				local olddata = Trolleybus_System.CopyValue(Trolleybus_System.ContactNetwork.GetObjectData(mname))

				mobj:SetConnectablePos(mid,pos)
				mobj:SetConnectableAngles(mid,ang)

				upd[mname] = GetChanges(olddata,Trolleybus_System.ContactNetwork.GetObjectData(mname))
			end
		end
	elseif cmd==2 then
		local class = net.ReadUInt(8)
		local type = net.ReadString()
		local pos = net.ReadVector()
		local ang = net.ReadAngle()

		local object,name = Trolleybus_System.ContactNetwork.NewObject(class,type,pos,ang)
		if object then
			upd[name] = Trolleybus_System.ContactNetwork.GetObjectData(name)
		end
	elseif cmd==3 then
		local name = net.ReadString()
		local object = Trolleybus_System.ContactNetwork.GetObject(name)

		if object then
			Trolleybus_System.ContactNetwork.RemoveObject(name)
			upd[name] = false
		end
	elseif cmd==4 then
		local name = net.ReadString()
		local object = Trolleybus_System.ContactNetwork.GetObject(name)
		local id = net.ReadUInt(8)
		local name2 = net.ReadString()
		local object2 = Trolleybus_System.ContactNetwork.GetObject(name2)
		local id2 = net.ReadUInt(8)

		if IsValid(object) and IsValid(object2) then
			local olddata = Trolleybus_System.CopyValue(Trolleybus_System.ContactNetwork.GetObjectData(name))

			object:ConnectConnectableTo(id,object2,id2)

			upd[name] = GetChanges(olddata,Trolleybus_System.ContactNetwork.GetObjectData(name))
		end
	elseif cmd==5 then
		local name = net.ReadString()
		local object = Trolleybus_System.ContactNetwork.GetObject(name)
		local id = net.ReadUInt(8)

		if IsValid(object) then
			local olddata = Trolleybus_System.CopyValue(Trolleybus_System.ContactNetwork.GetObjectData(name))

			object:DisconnectConnectable(id)

			upd[name] = GetChanges(olddata,Trolleybus_System.ContactNetwork.GetObjectData(name))
		end
	elseif cmd==6 then
		local property = net.ReadString()
		local value = net.ReadType()

		local objs = {}
		while true do
			local name = net.ReadString()
			if #name==0 then break end

			local obj = Trolleybus_System.ContactNetwork.GetObject(name)
			if IsValid(obj) then objs[name] = obj end
		end

		for k,v in pairs(objs) do
			local olddata = Trolleybus_System.CopyValue(Trolleybus_System.ContactNetwork.GetObjectData(k))

			v:SetProperty(property,value)

			upd[k] = GetChanges(olddata,Trolleybus_System.ContactNetwork.GetObjectData(k))
		end
	elseif cmd==7 then
		local data = {}

		while net.ReadBool() do
			local name = net.ReadString()

			data[name] = {
				Data = net.ReadTable(),
				Pos = net.ReadVector(),
				Ang = net.ReadAngle(),
				Connectables = {},
			}

			while true do
				local con = net.ReadUInt(8)
				if con==0 then break end

				data[name].Connectables[con] = {net.ReadVector(),net.ReadAngle()}

				if net.ReadBool() then
					data[name].Connectables[con][3] = net.ReadString()
					data[name].Connectables[con][4] = net.ReadUInt(8)
				end
			end
		end

		for k,v in pairs(data) do
			local object,name = Trolleybus_System.ContactNetwork.NewObject(v.Data.Class,v.Data.Type,Vector(),Angle())

			for k,v in pairs(v.Data.Properties) do
				object:SetProperty(k,v)
			end
			
			object:UpdateData(v.Data.Data)

			object:SetPos(v.Pos)
			object:SetAngles(v.Ang)

			v.Object = object
			v.ObjectName = name

			for k2,v2 in pairs(v.Connectables) do
				object:SetConnectablePos(k2,v2[1])
				object:SetConnectableAngles(k2,v2[2])
			end
		end

		for k,v in pairs(data) do
			for k2,v2 in pairs(v.Connectables) do
				if v2[3] then
					v.Object:ConnectConnectableTo(k2,data[v2[3]].Object,v2[4])
				end
			end
		end

		for k,v in pairs(data) do
			upd[v.ObjectName] = Trolleybus_System.ContactNetwork.GetObjectData(v.ObjectName)
		end
	end

	if !table.IsEmpty(upd) then
		Trolleybus_System.SendMassiveData(nil,upd,"ContactNetworkUpdate")

		timer.Create("TrolleybusSystem_ContactNetworkEditorSave",1.5,1,function()
			Trolleybus_System.ContactNetwork.UpdateWiresVoltageLinks()
			Trolleybus_System.ContactNetwork.Save()
		end)
	end
end)
