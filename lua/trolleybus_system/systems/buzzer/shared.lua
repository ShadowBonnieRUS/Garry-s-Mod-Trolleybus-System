-- Copyright © Platunov I. M., 2020 All rights reserved

if !SYSTEM then return end

function SYSTEM:IsActive()
	return self:GetNWVar("Active",false)
end
