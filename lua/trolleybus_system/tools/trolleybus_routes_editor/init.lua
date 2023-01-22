-- Copyright © Platunov I. M., 2021 All rights reserved

if !TOOL then return end

util.AddNetworkString("Trolleybus_System.RoutesEditor")

function TOOL:LeftClick(trace)
	return false
end

function TOOL:RightClick(trace)
	return false
end

function TOOL:Reload(trace)
	return false
end

net.Receive("Trolleybus_System.RoutesEditor",function(len,ply)
	local tool = ply:GetTool("trolleybus_routes_editor")
	if !tool or !tool:Allowed() or !IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass()!="gmod_tool" or ply:GetActiveWeapon().Mode!="trolleybus_routes_editor" then return end

	local cmd = net.ReadUInt(4)
	local routesupd,stopupd = {}

	if cmd==0 then
		local route = net.ReadUInt(8)
		local customname = net.ReadString()
		local customstart = net.ReadString()
		local customend = net.ReadString()
		local dirs = net.ReadUInt(4)
		local circular = net.ReadBool()
		
		local data = Trolleybus_System.Routes.Routes[route]
		if data then
			data.CustomName = #customname!=0 and customname or nil
			data.CustomStart = #customstart!=0 and customstart or nil
			data.CustomEnd = #customend!=0 and customend or nil
			data.Circular = circular

			if #data.Dirs>dirs then
				for i=#data.Dirs,dirs+1,-1 do
					data.Dirs[i] = nil
				end
			elseif #data.Dirs<dirs then
				for i=#data.Dirs+1,dirs do
					data.Dirs[i] = {Points = {},Stops = {}}
				end
			end

			routesupd[route] = data
		end
	elseif cmd==1 then
		local route = net.ReadUInt(8)

		if Trolleybus_System.Routes.Routes[route] then
			Trolleybus_System.Routes.Routes[route] = nil

			routesupd[route] = false
		end
	elseif cmd==2 then
		local route = net.ReadUInt(8)
		local customname = net.ReadString()
		local customstart = net.ReadString()
		local customend = net.ReadString()
		local dirs = net.ReadUInt(4)
		local circular = net.ReadBool()

		if !Trolleybus_System.Routes.Routes[route] then
			Trolleybus_System.Routes.Routes[route] = {
				CustomName = #customname!=0 and customname or nil,
				CustomStart = #customstart!=0 and customstart or nil,
				CustomEnd = #customend!=0 and customend or nil,
				Dirs = {},
				Circular = circular,
			}

			for i=1,dirs do
				Trolleybus_System.Routes.Routes[route].Dirs[i] = {Points = {},Stops = {}}
			end

			routesupd[route] = Trolleybus_System.Routes.Routes[route]
		end
	elseif cmd==3 then
		local pos = net.ReadVector()
		local ang = net.ReadAngle()
		local name = net.ReadString()
		local svname = net.ReadString()
		local pavilion = net.ReadBool()
		local length = net.ReadUInt(16)
		local width = net.ReadUInt(16)
		local passperc = net.ReadUInt(8)

		local id = 1
		while Trolleybus_System.Routes.Stops[id] do
			id = id+1
		end

		Trolleybus_System.Routes.Stops[id] = {
			Pos = pos,
			Ang = ang,
			Name = name,
			SVName = svname,
			Pavilion = pavilion,
			Length = length,
			Width = width,
			PassPercent = passperc,
		}

		stopupd = id
	elseif cmd==4 then
		local route = net.ReadUInt(8)
		local dir = net.ReadUInt(4)
		local cur = net.ReadUInt(32)
		local pos = net.ReadVector()

		local dt = Trolleybus_System.Routes.Routes[route]
		if dt then
			dt = dt.Dirs[dir]

			if dt then
				table.insert(dt.Points,cur+1,pos)

				routesupd[route] = Trolleybus_System.Routes.Routes[route]
			end
		end
	elseif cmd==5 then
		local route = net.ReadUInt(8)
		local dir = net.ReadUInt(4)
		local cur = net.ReadUInt(32)
		local id = net.ReadUInt(32)

		local dt = Trolleybus_System.Routes.Routes[route]
		if dt then
			dt = dt.Dirs[dir]

			if dt then
				table.insert(dt.Stops,cur+1,id)

				routesupd[route] = Trolleybus_System.Routes.Routes[route]
			end
		end
	elseif cmd==6 then
		local id = net.ReadUInt(32)

		if Trolleybus_System.Routes.Stops[id] then
			Trolleybus_System.Routes.Stops[id] = nil

			stopupd = id

			for k,v in pairs(Trolleybus_System.Routes.Routes) do
				for k2,v2 in pairs(v.Dirs) do
					if table.RemoveByValue(v2.Stops,id) then
						routesupd[k] = v
					end
				end
			end
		end
	elseif cmd==7 then
		local route = net.ReadUInt(8)
		local dir = net.ReadUInt(4)
		local cur = net.ReadUInt(32)

		local dt = Trolleybus_System.Routes.Routes[route]
		if dt then
			dt = dt.Dirs[dir]

			if dt then
				if table.remove(dt.Points,cur) then
					routesupd[route] = Trolleybus_System.Routes.Routes[route]
				end
			end
		end
	elseif cmd==8 then
		local route = net.ReadUInt(8)
		local dir = net.ReadUInt(4)
		local cur = net.ReadUInt(32)

		local dt = Trolleybus_System.Routes.Routes[route]
		if dt then
			dt = dt.Dirs[dir]

			if dt then
				if table.remove(dt.Stops,cur) then
					routesupd[route] = Trolleybus_System.Routes.Routes[route]
				end
			end
		end
	elseif cmd==9 then
		local id = net.ReadUInt(32)
		local name = net.ReadString()
		local svname = net.ReadString()
		local pavilion = net.ReadBool()
		local length = net.ReadUInt(16)
		local width = net.ReadUInt(16)
		local passperc = net.ReadUInt(8)

		local dt = Trolleybus_System.Routes.Stops[id]
		if dt then
			dt.Name = name
			dt.SVName = svname
			dt.Pavilion = pavilion
			dt.Length = length
			dt.Width = width
			dt.PassPercent = passperc

			stopupd = id
		end
	end

	local upd

	if !table.IsEmpty(routesupd) then
		upd = upd or {}
		upd[1] = routesupd
	end

	if stopupd then
		upd = upd or {}
		upd[2] = stopupd
		upd[3] = Trolleybus_System.Routes.Stops[stopupd]
	end

	if upd then
		Trolleybus_System.SendMassiveData(nil,upd,"RoutesUpdate")

		Trolleybus_System.Routes.UpdateStops()
		Trolleybus_System.Routes.Save()
	end
end)
