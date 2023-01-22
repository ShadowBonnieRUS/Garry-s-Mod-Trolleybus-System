-- Copyright © Platunov I. M., 2021 All rights reserved

TOOL.Category = "Trolleybus"
TOOL.Name = "#tool.trolleybus_cn_editor.name"

TOOL.Information = {}

function TOOL:Allowed()
	if !Trolleybus_System.RunEvent("HasAccessToTool",self:GetOwner(),"trolleybus_cn_editor") then return false end
	if Trolleybus_System.ToolsDisallowed(self:GetOwner(),nil,true) then return false end
	
	return true
end

