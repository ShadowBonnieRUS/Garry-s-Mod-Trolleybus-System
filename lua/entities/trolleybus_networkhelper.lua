-- Copyright © Platunov I. M., 2022 All rights reserved

AddCSLuaFile()

ENT.Type = "point"

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"HelperIndex")
end

if SERVER then
	function ENT:Initialize()
		self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end