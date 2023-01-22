-- Copyright © Platunov I. M., 2021 All rights reserved

TOOL.ClientConVar["trackid"] = 1
TOOL.ClientConVar["rotation_curvature"] = 2
TOOL.ClientConVar["rotation_segments"] = 5
TOOL.ClientConVar["maxspeed"] = 35
TOOL.ClientConVar["spawnchance"] = 100
TOOL.ClientConVar["dirweight"] = 100
TOOL.ClientConVar["noservice"] = 0

TOOL.Category = "Trolleybus"
TOOL.Name = "#tool.trolleytrafficeditor.name"

TOOL.Information = {
	{name = "left",op = 0,icon = "gui/lmb.png",icon2 = ""},
	{name = "right",op = 0,icon = "gui/rmb.png",icon2 = ""},
	{name = "right_use",op = 0,icon = "gui/rmb.png",icon2 = "gui/e.png"},
	{name = "reload",op = 0,icon = "gui/r.png",icon2 = ""},
	
	{name = "left1",op = 1,icon = "gui/lmb.png",icon2 = ""},
	{name = "right1",op = 1,icon = "gui/rmb.png",icon2 = ""},
	{name = "reload2",op = 1,icon = "gui/r.png",icon2 = ""},
	
	{name = "left2",op = 2,stage = 0,icon = "gui/lmb.png",icon2 = ""},
	{name = "left3",op = 2,stage = 1,icon = "gui/lmb.png",icon2 = ""},
	{name = "left4",op = 2,stage = 2,icon = "gui/lmb.png",icon2 = ""},
	{name = "reload2",op = 2,stage = 0,icon = "gui/r.png",icon2 = ""},
	{name = "reload2",op = 2,stage = 1,icon = "gui/r.png",icon2 = ""},
	{name = "reload1",op = 2,stage = 2,icon = "gui/r.png",icon2 = ""},
	{name = "left_use",op = 2,stage = 2,icon = "gui/lmb.png",icon2 = "gui/e.png"},
	{name = "right_use2",op = 2,stage = 2,icon = "gui/rmb.png",icon2 = "gui/e.png"},
	{name = "right1",op = 2,icon = "gui/rmb.png",icon2 = ""},
	
	{name = "left5",op = 3,icon = "gui/lmb.png",icon2 = ""},
	{name = "right1",op = 3,icon = "gui/rmb.png",icon2 = ""},
}

function TOOL:GetNearestConnectPos()
	local tr = self:GetOwner():GetEyeTrace()
	local pos = tr.HitPos
	
	if self:GetOwner():KeyDown(IN_RELOAD) then
		for k,v in pairs(Trolleybus_System.GetTrafficTracks()) do
			if v.Start:DistToSqr(pos)<20^2 then
				pos = v.Start
				break
			elseif v.End:DistToSqr(pos)<20^2 then
				pos = v.End
				break
			end
		end
	end
	
	return pos
end

function TOOL:GetNearestTrack(id)
	local lastdot = 0

	for k,v in pairs(Trolleybus_System.GetTrafficTracks()) do
		local center = v.Start+(v.End-v.Start)/2
		local dot = self:GetOwner():GetAimVector():Dot((center-Trolleybus_System.EyePos(self:GetOwner())):GetNormalized())
		
		if dot<0.75 or dot<=lastdot then continue end
		
		lastdot,id = dot,k
	end
	
	return id
end

function TOOL:BuildRotation(pos1,pos2,ang,segments,curvature,reverse,iteration)
	local poss = Trolleybus_System.BuildRotationPositions(pos1,pos2,ang,segments,curvature,reverse)
	local prevp
	
	for i=1,#poss do
		local p = poss[i]
		
		iteration(i,#poss,p,prevp)
		
		prevp = p
	end
end
