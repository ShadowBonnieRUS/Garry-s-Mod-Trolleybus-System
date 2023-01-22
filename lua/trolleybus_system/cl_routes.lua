-- Copyright © Platunov I. M., 2021 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase
local LN = Trolleybus_System.GetLanguagePhraseName

function Trolleybus_System.Routes.GetRouteName(route)
    local dt = Trolleybus_System.Routes.Routes[route]

    if dt then
        return dt.CustomName and LN("route."..game.GetMap()..".",dt.CustomName) or route
    end
end

function Trolleybus_System.Routes.GetRouteStart(route)
	local dt = Trolleybus_System.Routes.Routes[route]

    if dt then
		if dt.CustomStart then
        	return LN("route."..game.GetMap()..".",dt.CustomStart)
		else
			local dir = dt.Dirs[1]
			if dir then
				local stop = Trolleybus_System.Routes.Stops[dir.Stops[1]]

				if stop then
					return LN("stop."..game.GetMap()..".",stop.Name)
				end
			end

			return ""
		end
    end
end

function Trolleybus_System.Routes.GetRouteEnd(route)
	local dt = Trolleybus_System.Routes.Routes[route]

    if dt then
		if dt.CustomEnd then
        	return LN("route."..game.GetMap()..".",dt.CustomEnd)
		elseif dt.Circular then
			return L"CircularRoute"
		else
			local dir = dt.Dirs[1]
			if dir then
				local stop = Trolleybus_System.Routes.Stops[dir.Stops[#dir.Stops]]

				if stop then
					return LN("stop."..game.GetMap()..".",stop.Name)
				end
			end

			return ""
		end
    end
end

Trolleybus_System.ReceiveMassiveData("Routes",function(data)
	Trolleybus_System.Routes.Routes = data[1]
	Trolleybus_System.Routes.Stops = data[2]
end)

Trolleybus_System.ReceiveMassiveData("RoutesUpdate",function(data)
	if data[1] then
		for k,v in pairs(data[1]) do
			Trolleybus_System.Routes.Routes[k] = v or nil
		end
	end

	if data[2] then
		Trolleybus_System.Routes.Stops[data[2]] = data[3]
	end
end)