-- Copyright © Platunov I. M., 2020 All rights reserved

ENT.PrintName = "Trolleybus Pole Catcher"
ENT.Spawnable = false
ENT.Type = "anim"
ENT.Base = "base_entity"

function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Left")
	self:NetworkVar("Entity",0,"Trolleybus")
end

function ENT:CanProperty(ply,property)
	if property=="drive" then return false end
end

hook.Add("StartCommand","Trolleybus_System.TrolleybusPoleCatcher",function(ply,cmd)
	local index = Trolleybus_System.NetworkSystem.GetNWVar(ply,"TrolleybusPoleCatcher")
	
	if index then
		local catcher = Entity(index)
		
		if !IsValid(catcher) and SERVER then
			Trolleybus_System.NetworkSystem.SetNWVar(ply,"TrolleybusPoleCatcher",nil)
		end
	end
end)

hook.Add("SetupMove","Trolleybus_System.TrolleybusPoleCatcher",function(ply,mv,cmd)
	local index = Trolleybus_System.NetworkSystem.GetNWVar(ply,"TrolleybusPoleCatcher")
	
	if index then
		local btns = bit.bor(IN_JUMP)
		
		if mv:KeyDown(IN_WALK) then
			btns = bit.bor(btns,IN_WALK,IN_FORWARD,IN_BACK)
			
			mv:SetForwardSpeed(0)
		end
		
		mv:SetButtons(bit.bxor(bit.bor(mv:GetButtons(),btns),btns))
	end
end)

hook.Add("PhysgunPickup","Trolleybus_System_PickupPoleCatcher",function(ply,ent)
	if ent:GetClass()=="trolleybus_polecatcher" then return false end
end)