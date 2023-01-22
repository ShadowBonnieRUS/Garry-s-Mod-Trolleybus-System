-- Copyright © Platunov I. M., 2021 All rights reserved

SYSTEM = {}

include("shared.lua")

local L = Trolleybus_System.GetLanguagePhrase
local LN = Trolleybus_System.GetLanguagePhraseName

local prefix = "route."..game.GetMap().."."

function SYSTEM:GetRouteName(route)
	return Trolleybus_System.Routes.GetRouteName(route) or ""
end

function SYSTEM:GetRouteStart(route)
	local start = Trolleybus_System.Routes.GetRouteStart(route)
	return start and start or L"GoingToPark1"
end

function SYSTEM:GetRouteEnd(route)
	local endn = Trolleybus_System.Routes.GetRouteEnd(route)
	return endn and endn or L"GoingToPark2"
end

function SYSTEM:DrawRoute(x,y,w,h,nfont,font,type,route)
	if type==0 then
		draw.SimpleText(self:GetRouteName(route),nfont,x+h/2,y+h/2,color_black,1,1)
		draw.SimpleText(self:GetRouteStart(route),font,x+h+(w-h)/2,y+h/3,color_black,1,1)
		draw.SimpleText(self:GetRouteEnd(route),font,x+h+(w-h)/2,y+h/3*2,color_black,1,1)
	elseif type==1 then
		draw.SimpleText(self:GetRouteStart(route),font,x+w/2,y+h/3,color_black,1,1)
		draw.SimpleText(self:GetRouteEnd(route),font,x+w/2,y+h/3*2,color_black,1,1)
	elseif type==2 then
		draw.SimpleText(self:GetRouteName(route),nfont,x+w/2,y+h/2,color_black,1,1)
	end
end

Trolleybus_System.RegisterSystem("Nameplates",SYSTEM)
SYSTEM = nil