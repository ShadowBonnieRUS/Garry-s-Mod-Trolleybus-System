-- Copyright © Platunov I. M., 2020 All rights reserved

local Category = "Trolleybus"

local function LoadCommands()
	if !ulx then return end
	
	function ulx.trolleybus_tp(ply,stop,noforce)
		if !stop or stop=="" then
			ULib.tsayError(ply,"Available stops:",true)
			
			for k,v in pairs(ents.FindByClass("trolleybus_stop")) do
				ULib.tsayError(ply,k..". "..v:GetSVName(),true)
			end
			
			return
		end
	
		local found = {}
	
		for k,v in pairs(ents.FindByClass("trolleybus_stop")) do
			if v:GetSVName():lower():find(stop:lower()) then
				found[#found+1] = v
			end
		end
		
		if #found>=1 then
			if #found==1 or !noforce then
				ply:SetPos(found[1]:GetPos())
				
				ulx.fancyLogAdmin(ply,"#A has teleported to #s.",found[1]:GetSVName())
			end
			
			if #found>1 and noforce then
				ULib.tsayError(ply,"Founded "..#found.." stops:",true)
				
				for k,v in pairs(found) do
					ULib.tsayError(ply,k..". "..v:GetSVName(),true)
				end
			end
		elseif #found==0 then
			ULib.tsayError(ply,"Stop not found.",true)
		end
	end
	
	local tp = ulx.command(Category,"ulx tstop",ulx.trolleybus_tp,"!tstop")
	tp:addParam({type = ULib.cmds.StringArg,hint = "Part of name"})
	tp:addParam({type = ULib.cmds.BoolArg,hint = "Not force teleport",ULib.cmds.optional})
	tp:defaultAccess(ULib.ACCESS_ALL)
	tp:help("Teleport to trolleybus stop.")
end

LoadCommands()
hook.Add("Initialize","Trolleybus_System_Commands",LoadCommands)