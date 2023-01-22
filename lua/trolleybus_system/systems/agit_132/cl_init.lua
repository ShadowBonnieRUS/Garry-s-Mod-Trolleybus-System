-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

surface.CreateFont("Trolleybus_agit_132",{
	font = "Minecart LCD",
	size = 46,
	extended = true,
})

function SYSTEM:Initialize()
	self:Setup()
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	self:SetupUnload()
end

local L = Trolleybus_System.GetLanguagePhrase
local LN = Trolleybus_System.GetLanguagePhraseName

function SYSTEM:DrawScreen(drawscale,x,y)
	x = x+2.29*drawscale
	y = y+0.1*drawscale
	
	local w = 6.79*drawscale-x
	local h = 1.86*drawscale-y
	
	local route = Trolleybus_System.GetInformators()[self:GetRoute()]
	local text
	
	local prefix = "informator."..game.GetMap()..".route."
	
	if self:IsRouteState() then
		text = L("system.agit132.screen.selectroute",self:GetRoute()).."\n"..(route and LN(prefix,route.name) or L"system.agit132.screen.routeunavailable")
	elseif route then
		local playline = self:GetNWVar("Playline",1)
	
		text = L"system.agit132.screen.currentroute".."\n"..LN(prefix,route.name).."\n"..L("system.agit132.screen.currentstop",playline,#route.playlines).."\n"..(self:GetStopText() or "")
	end
	
	if text then
		render.ClearStencil()
		render.SetStencilEnable(true)
		
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(1)
			
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
				
				surface.SetDrawColor(175,255,0)
				surface.DrawRect(x,y,w,h)
				
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilPassOperation(STENCIL_KEEP)
				
				draw.DrawText(text,"Trolleybus_agit_132",x+0.05*drawscale+10,y+10,color_black)
				
		render.SetStencilEnable(false)
	else
		surface.SetDrawColor(175,255,0)
		surface.DrawRect(x,y,w,h)
	end
end

function SYSTEM:GetStopText(inttext)
	if self:IsRouteState() then return end
	
	local route = Trolleybus_System.GetInformators()[self:GetRoute()]
	if !route then return end
	
	local playline = self:GetNWVar("Playline",1)
	
	if inttext and !self:GetNWVar("Playing",false) then
		playline = playline==1 and #route.playlines or playline-1
	end

	local dt = route.playlines[playline]
	if !dt then return end

	return LN("informator."..game.GetMap()..".playline.",inttext and dt.inttext or dt.name)
end

Trolleybus_System.RegisterSystem("Agit-132",SYSTEM)
SYSTEM = nil