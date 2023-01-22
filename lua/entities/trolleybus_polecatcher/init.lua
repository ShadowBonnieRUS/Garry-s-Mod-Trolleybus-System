-- Copyright © Platunov I. M., 2021 All rights reserved

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if !IsValid(self.Trolleybus) then
		self:Remove()
		return
	end
	
	self:SetModel("models/props_c17/pulleywheels_small01.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.NextUse = CurTime()
	
	self:SetTrolleybus(self.Trolleybus)
	self:SetLeft(self.Left)
	
	self:SetParent(self.Trolleybus)
	
	Trolleybus_System.UpdateTransmit(self,"TrolleybusDrawDistance")
	
	self:DrawShadow(false)
end

function ENT:Use(ply)
	local bus = self.Trolleybus
	local right = !self:GetLeft()
	local state = bus:GetPoleState(right)
	
	if CurTime()<self.NextUse or state==3 or Trolleybus_System.NetworkSystem.GetNWVar(ply,"TrolleybusPoleCatcher") then return end
	
	self.NextUse = CurTime()+0.5
	
	local pdata = bus.PolesData[right and "Right" or "Left"]
	local defang = state==0 and pdata.LastPoleAng or bus:GetPoleMoveAng(right)
	
	bus:SetPoleState(3,right)
	bus:SetPoleStateTime(CurTime(),right)
	bus:SetPoleMoveAng(defang,right)
	bus:SetNWVar("CatcherNearestWire"..(right and "R" or "L").."Contact",nil)
	bus:SetNWVar("CatcherNearestWire"..(right and "R" or "L").."Wire",nil)
	bus:SetNWVar("CatcherNearestWire"..(right and "R" or "L").."EndPos",nil)
	
	Trolleybus_System.NetworkSystem.SetNWVar(ply,"TrolleybusPoleCatcher",self:EntIndex())
	Trolleybus_System.NetworkSystem.SetNWVar(self,"MovingPly",ply:EntIndex())

	self.PlyPressedUse = true
	self.MovingLen = bus:WorldToLocal(ply:EyePos()+ply:GetAimVector()*15):Distance(bus:GetPolePos(right,true)+defang:Forward()*bus.TrolleyPoleLength)
	self.MovingNear = {}
	self.StartMoving = CurTime()

	self.UpdateTask = Trolleybus_System.CreatePseudoAsyncTask(function(task)
		while self:IsValid() and Trolleybus_System.NetworkSystem.GetNWVar(self,"MovingPly",0)>0 do
			self:UpdateMoveNearAng()

			task:Sleep(0.1)
		end
	end)
end

function ENT:SetupMovePole()
	local ply = Entity(Trolleybus_System.NetworkSystem.GetNWVar(self,"MovingPly",0))
	
	if IsValid(ply) then
		Trolleybus_System.NetworkSystem.SetNWVar(ply,"TrolleybusPoleCatcher",nil)
	end
	
	Trolleybus_System.NetworkSystem.SetNWVar(self,"MovingPly",nil)
	self.MovingLen = nil
	
	local connectdata = self.MovingNear.WireData
	self.MovingNear = nil
	
	local bus = self.Trolleybus
	local right = !self:GetLeft()
	local ang = bus:GetPoleMoveAng(right)
	local angleback = right and bus.TrolleyPoleDownedAngleRight or bus.TrolleyPoleDownedAngleLeft
	
	bus:SetPoleState(1,right)
	bus:SetPoleStateTime(CurTime(),right)
	
	if angleback==ang or math.deg(math.acos(ang:Forward():Dot(angleback:Forward())))<=2 then
		bus:SetPoleState(2,right)
		
		local wheelpos = bus:GetPolePos(right)+bus:LocalToWorldAngles(ang):Forward()*bus.TrolleyPoleLength
		sound.Play("trolleybus/pole_downed.ogg",wheelpos,70,math.random(95,105))
	else
		if connectdata then
			local pdata = bus.PolesData[right and "Right" or "Left"]
		
			bus:SetPoleState(0,right)
			bus:SetPoleContactWire(connectdata.Contact,connectdata.Wire,right)
			bus:SetPoleAngInversion(connectdata.EndPos,right)
			
			sound.Play("trolleybus/pole_connected.ogg",connectdata.Pos,50,math.random(95,105))

			local object = Trolleybus_System.ContactNetwork.GetObject(connectdata.Contact)
			if object then
				object:OnWheelEntered(self,connectdata.Pos,connectdata.Wire)
			end
		end
	end

	self.UpdateTask:Cancel()
end

function ENT:ComputeDesiredPoleAngle()
	local ply = Entity(Trolleybus_System.NetworkSystem.GetNWVar(self,"MovingPly",0))
	local bus = self.Trolleybus
	
	local plypos = bus:WorldToLocal(ply:EyePos()+ply:GetAimVector()*15)
	local polepos = bus:GetPolePos(!self:GetLeft(),true)
	
	local polelen = bus.TrolleyPoleLength
	local mlen = self.MovingLen
	local poledist = plypos:Distance(polepos)
	
	local ang = math.deg(math.acos((polelen*polelen+poledist*poledist-mlen*mlen)/(2*polelen*poledist)))
	if ang!=ang then ang = 0 end
	
	local lang = (plypos-polepos):Angle()
	lang:RotateAroundAxis(lang:Right(),ang)
	
	return Angle(
		math.Clamp(lang.p,Trolleybus_System.MaxTrolleybusPolesUpAng,bus.TrolleyPoleAngleLimits[1]),
		math.NormalizeAngle(math.Clamp(math.NormalizeAngle(lang.y+180),bus.TrolleyPoleAngleLimits[2],bus.TrolleyPoleAngleLimits[3])+180),
		0
	)
end

function ENT:CheckRopeCollision()
	local ply = Entity(Trolleybus_System.NetworkSystem.GetNWVar(self,"MovingPly",0))
	local bus = self.Trolleybus
	
	local plypos = ply:EyePos()+ply:GetAimVector()*15
	local polepos = bus:GetPolePos(!self:GetLeft())
	local poleang = bus:LocalToWorldAngles(bus:GetPoleMoveAng(!self:GetLeft()))
	local wheelpos = bus.TrolleyPoleCatcherWirePos and LocalToWorld(bus.TrolleyPoleCatcherWirePos,angle_zero,polepos,poleang) or polepos+poleang:Forward()*bus.TrolleyPoleLength
	
	local tr = util.TraceLine({start = wheelpos,endpos = plypos,filter = ply})
	return tr.Hit and !tr.StartSolid
end

function ENT:Think()
	Trolleybus_System.UpdateTransmit(self,"TrolleybusDrawDistance")
	
	local ply = Entity(Trolleybus_System.NetworkSystem.GetNWVar(self,"MovingPly",0))
	local bus = self.Trolleybus
	local right = !self:GetLeft()
	
	if bus:GetPoleState(right)==3 and IsValid(ply) then
		if self.PlyPressedUse and !ply:KeyDown(IN_USE) then
			self.PlyPressedUse = false
		end
	
		if !ply:Alive() or Trolleybus_System.EyePos(ply):Distance(self:GetPos())>300 or !self.PlyPressedUse and ply:KeyDown(IN_USE) or CurTime()-self.StartMoving>1 and self:CheckRopeCollision() then
			self:SetupMovePole()
			
			return
		end
		
		if ply:KeyDown(IN_WALK) then
			if ply:KeyDown(IN_FORWARD) then
				self.MovingLen = self.MovingLen+FrameTime()*100
			elseif ply:KeyDown(IN_BACK) then
				self.MovingLen = self.MovingLen-FrameTime()*100
			end
			
			if self.MovingLen<0 then self.MovingLen = 0 end
		end

		local dang = self.MovingNear.WireData and self.MovingNear.WireData.DesiredAng or self:ComputeDesiredPoleAngle()
		local ang = LerpAngle(FrameTime()*5,bus:GetPoleMoveAng(right),dang)
		bus:SetPoleMoveAng(ang,right)
		bus.PolesData[right and "Right" or "Left"].LastPoleAng = ang
		
		self:NextThink(CurTime())
		return true
	end
end

function ENT:UpdateMoveNearAng()
	local ply = Entity(Trolleybus_System.NetworkSystem.GetNWVar(self,"MovingPly",0))
	local bus = self.Trolleybus
	local right = !self:GetLeft()
	
	local desiredang = self:ComputeDesiredPoleAngle()
	local polepos = bus:GetPolePos(right)
	local wheelpos = polepos+bus:LocalToWorldAngles(desiredang):Forward()*bus.TrolleyPoleLength
	local data = Trolleybus_System.ContactNetwork.GetNearestContactWire(polepos,bus.TrolleyPoleLength,wheelpos)
	local p = desiredang.p

	if !data and self.MovingNear.WireData and self.MovingNear.WireData.CatchPitch and p<self.MovingNear.WireData.CatchPitch then
		p = self.MovingNear.WireData.CatchPitch
		desiredang.p = p
		
		wheelpos = polepos+bus:LocalToWorldAngles(desiredang):Forward()*bus.TrolleyPoleLength
		data = Trolleybus_System.ContactNetwork.GetNearestContactWire(polepos,bus.TrolleyPoleLength,wheelpos)
	end
	
	self.MovingNear.WireData = nil
		
	if data then
		desiredang = bus:WorldToLocalAngles((data.Pos-polepos):Angle())
		desiredang.p = (desiredang.p+p)/2
		
		self.MovingNear.WireData = data
		data.CatchPitch = p
		data.DesiredAng = desiredang
	end
	
	bus:SetNWVar("CatcherNearestWire"..(right and "R" or "L").."Contact",data and data.Contact or nil)
	bus:SetNWVar("CatcherNearestWire"..(right and "R" or "L").."Wire",data and data.Wire or nil)
	bus:SetNWVar("CatcherNearestWire"..(right and "R" or "L").."EndPos",data and data.EndPos or nil)

	if !data then
		local ang = bus:GetPoleMoveAng(right)
		local angleback = right and bus.TrolleyPoleDownedAngleRight or bus.TrolleyPoleDownedAngleLeft

		bus:SetNWVar("CatcherNearestWire"..(right and "R" or "L").."Contact",angleback==ang or math.deg(math.acos(ang:Forward():Dot(angleback:Forward())))<=2)
	end
end

function ENT:OnRemove()
	if IsValid(self.MovingPly) then
		Trolleybus_System.NetworkSystem.SetNWVar(self.MovingPly,"TrolleybusPoleCatcher",nil)
	end
end

hook.Add("GravGunPickupAllowed","Trolleybus_System.PoleCatchers",function(ply,ent)
	if IsValid(ent) and ent:GetClass()=="trolleybus_polecatcher" then return false end
end)