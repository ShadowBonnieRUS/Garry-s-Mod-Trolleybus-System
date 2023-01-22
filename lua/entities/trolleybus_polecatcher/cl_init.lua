-- Copyright © Platunov I. M., 2021 All rights reserved

local L = Trolleybus_System.GetLanguagePhrase

ENT.RenderGroup = RENDERGROUP_BOTH

include("shared.lua")

function ENT:Initialize()	
	self:DrawShadow(false)
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end

local COLOR_RED = Color(255,0,0)
local COLOR_GREEN = Color(0,255,0)

hook.Add("HUDPaint","Trolleybus_System.PoleCatcherHelp",function()
	if !Trolleybus_System.GetPlayerSetting("DrawHUDInfo") then return end
	
	local catcher = Entity(Trolleybus_System.NetworkSystem.GetNWVar(LocalPlayer(),"TrolleybusPoleCatcher",0))
	if !IsValid(catcher) then return end
	
	local bus = catcher:GetTrolleybus()
	if !IsValid(bus) then return end
	
	local w,h = draw.SimpleTextOutlined(L"HUD_PoleCatcher_Help","Trolleybus_System.HUDFont",ScrW()/2,ScrH()/2+10,color_white,1,0,1,color_black)
	local wiredata = bus:GetNWVar("CatcherNearestWire"..(catcher:GetLeft() and "L" or "R").."Contact",false)
	
	local walk,frwd,bkwd = input.LookupBinding("walk") or "?",input.LookupBinding("forward") or "?",input.LookupBinding("back") or "?"
	local w2,h2 = draw.SimpleTextOutlined(L("HUD_PoleCatcher_PullHelp",walk:upper(),frwd:upper(),walk:upper(),bkwd:upper()),"Trolleybus_System.HUDFont",ScrW()/2,ScrH()/2+10+h,color_white,1,0,1,color_black)
	
	draw.SimpleTextOutlined(L("HUD_PoleCatcher_CollectorState",L(wiredata and "HUD_PoleCatcher_CollectorStateInstalled" or "HUD_PoleCatcher_CollectorStateNotInstalled")),"Trolleybus_System.HUDFont",ScrW()/2,ScrH()/2+10+h+h2,wiredata and COLOR_GREEN or COLOR_RED,1,0,1,color_black)
end)