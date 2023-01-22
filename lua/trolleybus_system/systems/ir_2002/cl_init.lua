-- Copyright © Platunov I. M., 2020 All rights reserved

SYSTEM = {}

include("shared.lua")

surface.CreateFont("Trolleybus_System.IR2002",{
	font = "Electronica-Normal",
	size = 60,
})

function SYSTEM:DrawDigits(drawscale,x,y)
	if !self:IsActive() then return end
	
	local text = "00"
	
	if self:IsRouteState() then
		text = tostring(self:GetRoute())
	else
		text = tostring(self:GetNWVar("Playline",0))
	end
	
	if #text!=2 then
		if #text>2 then
			text = text:sub(-2,-1)
		else
			while #text<2 do
				text = "0"..text
			end
		end
	end
	
	draw.SimpleText(text,"Trolleybus_System.IR2002",drawscale*0.03,0,Color(200,200,0))
end

function SYSTEM:Unload()
	self.Base.Unload(self)
	
	self:SetupUnload()
end

Trolleybus_System.RegisterSystem("IR-2002",SYSTEM)
SYSTEM = nil