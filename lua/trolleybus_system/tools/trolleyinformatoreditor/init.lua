-- Copyright © Platunov I. M., 2020 All rights reserved

if !TOOL then return end

util.AddNetworkString("TrolleybusInformatorEditor")

net.Receive("TrolleybusInformatorEditor",function(len,ply)
	if !Trolleybus_System.RunEvent("HasAccessToTool",ply,"trolleyinformatoreditor") then return end
	if Trolleybus_System.ToolsDisallowed(ply) then return end
	
	local id = net.ReadUInt(8)
	
	if net.ReadBool() then
		Trolleybus_System.Informators[id] = net.ReadTable()
	else
		Trolleybus_System.Informators[id] = nil
	end
	
	Trolleybus_System.SaveInformators()
end)