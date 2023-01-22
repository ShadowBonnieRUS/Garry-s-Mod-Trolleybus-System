-- Copyright © Platunov I. M., 2020 All rights reserved
local L = Trolleybus_System.GetLanguagePhrase
local icon = "trolleybus/creationtab.png"

spawnmenu.AddContentType("entity_trolleybus",function(parent,data)
	local icon = vgui.Create("ContentIcon",parent)
	icon:SetSpawnName(data.class)
	icon:SetName(data.name)
	icon:SetMaterial(data.icon)
	icon:SetAdminOnly(data.admin)
	icon:SetColor(Color(205,92,92))
	icon.DoClick = function()
		surface.PlaySound("ui/buttonclickrelease.wav")
		
		local ENT = scripted_ents.GetStored(data.class)
		if !ENT then return end
		
		ENT = ENT.t
		
		net.Start("TrolleybusSystem_CreateBus")
			net.WriteBool(false)
			net.WriteString(data.class)
			
			if Trolleybus_System.TrolleybusSpawnSettings[data.class] then
				for k,v in pairs(Trolleybus_System.TrolleybusSpawnSettings[data.class]) do
					local id = k
					
					if isstring(id) then
						if !ENT.SpawnSettings then continue end
						
						for k,v in ipairs(ENT.SpawnSettings) do
							if v.alias==id then
								id = k
								
								break
							end
						end
						
						if isstring(id) then continue end
					end
					
					net.WriteUInt(id,8)
					net.WriteType(v)
				end
			end
			
			net.WriteUInt(0,8)
		net.SendToServer()
	end
	icon.OpenMenu = function(self)
		local menu = DermaMenu()
		
		menu:AddOption("#spawnmenu.menu.copy",function()
			SetClipboardText(self:GetSpawnName())
		end):SetIcon("icon16/page_copy.png")
		
		menu:Open()
	end

	parent:Add(icon)

	return icon
end)

spawnmenu.AddCreationTab(L"spawnmenu_creationtab",function()
	local panel = vgui.Create("SpawnmenuContentPanel")
	panel:CallPopulateHook("PopulateTrolleybuses")
	
	return panel
end,icon,51)

hook.Add("PopulateTrolleybuses","PopulateTrolleybuses",function(content,tree,node)
	local cats = {{},{}}
	
	for k,v in pairs(scripted_ents.GetList()) do
		local ENT = v.t
		
		if Trolleybus_System.IsTrolleybusMetatable(ENT) then
			local cat = ENT.Category or "creationtab_category.default"
			if !istable(cat) then cat = {cat} end
			
			local curcats = cats
			
			for k2,v2 in ipairs(cat) do
				local cat = L(v2)
				
				curcats[2][cat] = curcats[2][cat] or {{},{}}
				curcats = curcats[2][cat]
			end
			
			table.insert(curcats[1],{
				PrintName = ENT.PrintName,
				Class = k,
				IconOverride = ENT.IconOverride,
				AdminOnly = ENT.AdminSpawnable,
			})
		end
	end
	
	local order = {{cats,tree:Root()}}
	while #order>0 do
		local cur = table.remove(order,1)
		
		for k,v in pairs(cur[1][2]) do
			local node = cur[2]:AddNode(k,icon)
			
			node.DoPopulate = function(self)
				if self.PropPanel then return end
				
				self.PropPanel = vgui.Create("ContentContainer",content)
				self.PropPanel:SetVisible(false)
				self.PropPanel:SetTriggerSpawnlistChange(false)
				
				for k,data in SortedPairsByMemberValue(v[1],"PrintName") do
					spawnmenu.CreateContentIcon("entity_trolleybus",self.PropPanel,{
						name = data.PrintName or data.Class,
						class = data.Class,
						icon = data.IconOverride or "entities/"..data.Class..".png",
						admin = data.AdminOnly,
					})
				end
			end
			
			node.DoClick = function(self)
				self:DoPopulate()
				content:SwitchPanel(self.PropPanel)
			end
			
			order[#order+1] = {v,node}
		end
	end
	
	local FirstNode = tree:Root():GetChildNode(0)
	if IsValid(FirstNode) then
		FirstNode:InternalDoClick()
	end
end)