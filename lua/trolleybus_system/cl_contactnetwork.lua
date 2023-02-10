-- Copyright © Platunov I. M., 2021 All rights reserved

if Trolleybus_System.ContactNetwork.NotLoaded==nil then Trolleybus_System.ContactNetwork.NotLoaded = true end

local updatevisibility = 0
hook.Add("Think","Trolleybus_System.ContactNetwork",function()
	local ct = CurTime()
	
	if ct-updatevisibility<1 then return end
	updatevisibility = ct

	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
		v:UpdateVisibility()
	end

	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.SuspensionAndOther) do
		v:UpdateVisibility()
	end
end)

Trolleybus_System.ReceiveMassiveData("ContactNetwork",function(data)
	if data.Clear then
		Trolleybus_System.ContactNetwork.ClearObjects()

		local old = Trolleybus_System.ContactNetwork.NotLoaded
		Trolleybus_System.ContactNetwork.NotLoaded = true

		Trolleybus_System.RunChangeEvent("ContactNetwork_LoadedState",!old,false)
	end

	if data.Cluster then
		for k,v in pairs(data.Cluster) do
			Trolleybus_System.ContactNetwork.AddObject(k,v)
		end
	end

	if data.Connections then
		for k,v in pairs(data.Connections) do
			local obj = Trolleybus_System.ContactNetwork.GetObject(k)
			if !obj then continue end

			for k2,v2 in pairs(v) do
				local obj2 = Trolleybus_System.ContactNetwork.GetObject(v2[1])
				if !obj2 then continue end

				obj:ConnectConnectableTo(k2,obj2,v2[2])
			end
		end

		local old = Trolleybus_System.ContactNetwork.NotLoaded
		Trolleybus_System.ContactNetwork.NotLoaded = false

		Trolleybus_System.RunChangeEvent("ContactNetwork_LoadedState",!old,true)
	end
end)

local function MergeChanges(data,changes)
	for k,v in pairs(changes) do
		if istable(v) and istable(data[k]) then
			MergeChanges(data[k],v)
		else
			data[k] = Either(v=="#nil#",nil,v)
		end
	end
end

Trolleybus_System.ReceiveMassiveData("ContactNetworkUpdate",function(updates)
	for k,v in pairs(updates) do
		local object = Trolleybus_System.ContactNetwork.GetObject(k)

		if !v then
			Trolleybus_System.ContactNetwork.RemoveObject(k)
		else
			if !IsValid(object) then
				if !pcall(Trolleybus_System.ContactNetwork.AddObject,k,v) then
					Trolleybus_System.ContactNetwork.RemoveObject(k)

					net.Start("Trolleybus_System.ContactNetwork.FullUpdateRequest")
					net.SendToServer()

					return
				end
			end
		end
	end

	for k,v in pairs(updates) do
		if v then
			local data = Trolleybus_System.ContactNetwork.GetObjectData(k)
			MergeChanges(data,v)

			Trolleybus_System.ContactNetwork.ApplyObjectChanges(k,data)
		end
	end

	Trolleybus_System.RunEvent("ContactNetwork_OnUpdate")
end)