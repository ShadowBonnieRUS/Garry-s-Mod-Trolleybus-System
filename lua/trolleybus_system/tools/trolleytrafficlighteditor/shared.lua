-- Copyright © Platunov I. M., 2021 All rights reserved

TOOL.Category = "Trolleybus"
TOOL.Name = "#tool.trolleytrafficlighteditor.name"

TOOL.Information = {
	{name = "left",icon = "gui/lmb.png",icon2 = ""},
	{name = "left_use",icon = "gui/lmb.png",icon2 = "gui/e.png"},
	{name = "right",icon = "gui/rmb.png",icon2 = ""},
	{name = "reload",icon = "gui/r.png",icon2 = ""},
	{name = "reload_use",icon = "gui/r.png",icon2 = "gui/e.png"},
}

function TOOL:GetLightPos(ply,trace,type,num)
	local data = Trolleybus_System.TrafficLightTypes[type]

	if data and data.PartOfLight and trace.Hit then
		local light = self:GetMainTrafficLight(trace.Entity)
		
		if light then
			local parts = data.PartOfLight[light:GetType()]
			
			if parts then
				local pos = parts[(num-1)%#parts+1]
				
				if pos then
					return LocalToWorld(pos[1],pos[2],light:GetPos(),light:GetAngles())
				end
			end
		end
	end
	
	return Trolleybus_System.EyePos(ply)+ply:GetAimVector()*50,Angle(0,ply:EyeAngles().y+180,0)
end

function TOOL:GetMainTrafficLight(ent)
	if !IsValid(ent) then return end
	
	if ent:GetClass()!="trolleybus_trafficlight" then
		local index = Trolleybus_System.NetworkSystem.GetNWVar(ent,"TrafficLight")
		if !index then return end
		
		ent = Entity(index)
		if !IsValid(ent) or ent:GetClass()!="trolleybus_trafficlight" then return end
	end
	
	return ent
end
