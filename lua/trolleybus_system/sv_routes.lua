-- Copyright © Platunov I. M., 2021 All rights reserved

Trolleybus_System.Routes.StopEnts = Trolleybus_System.Routes.StopEnts or {}

function Trolleybus_System.Routes.Load(ply)
	local str = Trolleybus_System.ReadDataFile("routes")
	
	if !ply then
		Trolleybus_System.Routes.Routes = {}
		Trolleybus_System.Routes.Stops = {}
		if !str then return end

		local data = util.JSONToTable(str)

		Trolleybus_System.Routes.Routes = data[1]
		Trolleybus_System.Routes.Stops = data[2]

		Trolleybus_System.Routes.UpdateStops()
	else
		Trolleybus_System.SendMassiveData(ply!=true and ply,str and util.JSONToTable(str) or {{},{}},"Routes")
	end
end

function Trolleybus_System.Routes.Save()
	local data = {Trolleybus_System.Routes.Routes,Trolleybus_System.Routes.Stops}

	Trolleybus_System.WriteDataFile("routes",util.TableToJSON(data,true))
end

function Trolleybus_System.Routes.UpdateStops()
	local stops = {}

	for k,v in ipairs(ents.FindByClass("trolleybus_stop")) do
		local dt = Trolleybus_System.Routes.Stops[v:GetID()]

		if !dt then
			v:Remove()

			Trolleybus_System.Routes.StopEnts[v:GetID()] = nil
		else
			v:UpdateData(dt)
			stops[v:GetID()] = true
		end
	end

	for k,v in pairs(Trolleybus_System.Routes.Stops) do
		if !stops[k] then
			local stop = ents.Create("trolleybus_stop")
			stop:SetID(k)
			stop:SetPos(v.Pos)
			stop:SetAngles(v.Ang)
			stop:Spawn()
			stop:UpdateData(v)

			Trolleybus_System.Routes.StopEnts[k] = stop
		end
	end
end

hook.Add("PlayerInitialSpawn","Trolleybus_System.Routes",function(ply)
	Trolleybus_System.Routes.Load(ply)
end)

hook.Add("InitPostEntity","Trolleybus_System.Routes",function()
	Trolleybus_System.Routes.Load()
end)