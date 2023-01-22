-- Copyright © Platunov I. M., 2021 All rights reserved

ENT.RenderGroup = RENDERGROUP_BOTH

include("shared.lua")

function ENT:Initialize()
	self:NotifyShouldTransmit(!self:IsDormant())
end

function ENT:Draw(flags) end
function ENT:DrawTranslucent(flags) end

function ENT:NotifyShouldTransmit(transmit)
	SafeRemoveEntity(self.WheelModel)
	
	if transmit then
		local data = self:GetWheelData()
		
		self.WheelModel = ClientsideModel(data.Model,RENDERGROUP_BOTH)
		self.WheelModel:SetParent(self)
		self.WheelModel:SetLocalPos(vector_origin)
		self.WheelModel.Rotate = 0
		//self.WheelModel:CreateShadow()
		//self.WheelModel:SetNoDraw(true)
	end
end

function ENT:Think()
	if IsValid(self.WheelModel) and IsValid(self:GetVehicle()) then
		self.WheelModel.Rotate = (self.WheelModel.Rotate+self:GetRotationSpeed()*FrameTime())%360
		
		local inv = self:GetInvertRotation() and -1 or 1
		local data = self:GetWheelData()
		
		self.WheelModel:SetAngles(self:GetVehicle():LocalToWorldAngles(data.Ang+Angle(0,90*inv,0)+data.RotateAxis*self.WheelModel.Rotate*inv+data.TurnAxis*self:GetRotate()))
		
		for i=0,4 do
			self.WheelModel:SetBodygroup(i,self:GetBodyGroup(i))
		end
	end
end

function ENT:OnRemove()
	SafeRemoveEntity(self.WheelModel)
end