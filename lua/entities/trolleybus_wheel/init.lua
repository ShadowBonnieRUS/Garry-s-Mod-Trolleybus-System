-- Copyright © Platunov I. M., 2021 All rights reserved

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetupType(self:GetType())
	
	self.phys:EnableMotion(false)
	
	self:DrawShadow(false)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:StartMotionController()
	
	self:TransmitUpdate()
end

function ENT:PhysicsUpdate(phys)
	local dt = FrameTime()
	if dt==0 then return end

	local fr,friction,maxfr,vel = phys:GetFrictionSnapshot(),0
	
	if #fr>0 then
		for i=1,#fr do
			local data = util.GetSurfaceData(fr[i].MaterialOther)
			local frict = data and data.friction or 1

			if frict>friction then
				friction,maxfr = frict,fr[i]
			end
		end
	end
	
	self.LastFrictionSnapshot = fr
	self.LastFrictionPhys = maxfr and maxfr.Other
	self.LastFrictionPos = maxfr and maxfr.ContactPoint
	self.LastMaxFriction = friction

	local veh = self:GetVehicle()
	if !veh:IsValid() then return end

	local vphys = veh:GetPhysicsObject()
	if !vphys:IsValid() then return end

	local vehang = veh:GetAngles()
	if self:GetRotate()!=0 then vehang:RotateAroundAxis(vehang:Up(),self:GetRotate()) end
	
	self:SetRotationSpeed(self:CalcFinalRotationSpeed(self:GetRotationSpeed(),dt))

	self.LastVehAng = vehang

	local mat = math.abs(self:GetRotationSpeed())<1 and veh.IsWheelsFullStop and veh:IsWheelsFullStop() and "jeeptire" or "friction_00"
	if phys:GetMaterial()!=mat then
		phys:SetMaterial(mat)
		self.FullStop = mat=="jeeptire"
	end

	local vel = vphys:GetVelocityAtPoint(phys:GetPos())
	local gvel = IsValid(self.LastFrictionPhys) and self.LastFrictionPhys:GetVelocityAtPoint(self.LastFrictionPos) or vector_origin

	local lvel = WorldToLocal(vel,angle_zero,gvel,self.LastVehAng)
	local ovel = Vector(lvel)

	local mspeed = self:RotationSpeedToMovementSpeed(self:GetRotationSpeed())
	local frdamp = 100*self.LastMaxFriction

	if frdamp>0 then
		if !self.FullStop or lvel:Length2DSqr()>25 then
			local ospd = lvel.x
			lvel.x = lvel.x-mspeed

			local len = lvel:Length2D()
			local dlen = math.max(0,len-frdamp)

			lvel.x = dlen==0 and 0 or lvel.x/len*dlen
			lvel.y = dlen==0 and 0 or lvel.y/len*dlen

			lvel.x = lvel.x+mspeed
			mspeed = mspeed-(lvel.x-ospd)

			self:SetRotationSpeed(self:MovementSpeedToRotationSpeed(mspeed))
		else
			self:SetRotationSpeed(0)
		end
	end

	if !self.FullStop then
		phys:AddVelocity(LocalToWorld(lvel-ovel,angle_zero,vector_origin,self.LastVehAng))
	end
end

function ENT:PhysicsSimulate(phys,dt)
	if dt==0 then return end

	return -phys:GetAngleVelocity()/dt,vector_origin,SIM_LOCAL_ACCELERATION
end

function ENT:GetAllConnectedWheels()
	if !self.AllConnectedWheelsTime or CurTime()>=self.AllConnectedWheelsTime then
		self.AllConnectedWheelsTime = CurTime()+math.Rand(0.75,1.25)

		local wheels,checked = {},{[self] = true}
		local tocheck = {self}

		while #tocheck>0 do
			local ent = table.remove(tocheck,1)
			
			if ent:GetClass()=="trolleybus_wheel" then
				wheels[#wheels+1] = ent
			end

			if ent.Constraints then
				for k,v in ipairs(ent.Constraints) do
					local dt = v:GetTable()

					for i=1,6 do
						local ent2 = dt["Ent"..i]

						if IsValid(ent2) and !checked[ent2] then
							checked[ent2] = true
							tocheck[#tocheck+1] = ent2
						end
					end
				end
			end
		end

		self.LastAllConnectedWheels = wheels
	end

	return self.LastAllConnectedWheels
end

function ENT:CalcFinalRotationSpeed(rspeed,dt)
	local veh = self:GetVehicle()

	if IsValid(veh) and veh.CalcWheelFinalRotationSpeed then
		return veh:CalcWheelFinalRotationSpeed(self,rspeed,dt) or rspeed
	end
	
	return rspeed
end

function ENT:SetupType(type)
	local data = Trolleybus_System.WheelTypes[type]
	
	self:SetModel(data.Model)
	self:PhysicsInitSphere(data.Radius,"friction_00")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysWake()
	
	self.phys = self:GetPhysicsObject()
	self.phys:SetDamping(0,0)
	self.phys:SetDragCoefficient(0)
	self.phys:SetMass(1000)
	self.phys:EnableDrag(false)
	
	local v = Vector(data.Radius,data.Radius,data.Radius)
	self:SetCollisionBounds(-v,v)
end

function ENT:RotationSpeedToMovementSpeed(rspeed)	-- degrees/sec to units/sec
	return math.pi*self:GetWheelData().Radius*2*(rspeed/360)
end

function ENT:MovementSpeedToRotationSpeed(mspeed)	-- units/sec to degrees/sec
	return mspeed/(math.pi*self:GetWheelData().Radius*2)*360
end

function ENT:TransmitUpdate()
	if self.UpdateTransmit and CurTime()-self.UpdateTransmit<1 then return end
	self.UpdateTransmit = CurTime()

	if !IsValid(self:GetVehicle()) then return end
	
	if self:GetVehicle().IsTrolleybus or self:GetVehicle():GetClass()=="trolleybus_traffic_car" then
		local troll = self:GetVehicle().IsTrolleybus
	
		for k,v in ipairs(player.GetHumans()) do
			Trolleybus_System.SetPreventTransmit(self,v,(!Trolleybus_System.TrafficWheelDebug and !troll) or Trolleybus_System.EyePos(v):DistToSqr(self:GetPos())>Trolleybus_System.GetPlayerSetting(v,"TrolleybusDrawDistance")^2)
		end
	end
end

function ENT:SetBodyGroup(group,value)
	self:SetDTInt(group,value)
end

function ENT:Think()
	if self.phys:IsAsleep() then
		self.phys:Wake()
	end
	
	self:TransmitUpdate()
end

function ENT:OnRemove()
	if IsValid(self:GetVehicle()) then
		self:GetVehicle():Remove()
	end
end