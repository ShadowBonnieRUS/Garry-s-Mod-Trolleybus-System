-- Copyright © Platunov I. M., 2020 All rights reserved

include("shared.lua")

local L = Trolleybus_System.GetLanguagePhrase
local LN = Trolleybus_System.GetLanguagePhraseName

surface.CreateFont("Trolleybus_System.Clicker.RouteDisplay",{
	font = "Aero Matics Stencil",
	size = 32,
	extended = true,
	weight = 600,
})

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:ShouldDrawViewModel()
	return self:GetReverse() or self:GetNameplateState()
end

function SWEP:DrawWorldModel(flags)
	if self:GetNameplateState() then
		local wm = self.WorldModel
		self.WorldModel = self.WorldModelNameplate
		self:SetModel(self.WorldModel)
		
		self:DrawModel(flags)
		
		self.WorldModel = wm
	elseif self:GetReverse() then
		self:SetupReverseModel(self,false)
		self:DrawModel(flags)
		self:SetupReverseModel(self,true)
	end
end

function SWEP:DrawWorldModelTranslucent(flags)
	self:DrawWorldModel(flags)
end

function SWEP:PreDrawViewModel(vm,weapon,ply)
	if self:GetReverse() and !self:GetNameplateState() then
		self:SetupReverseModel(vm,false)
	end
end

function SWEP:ViewModelDrawn(vm)
	if self:GetNameplateState() then
		local dt = Trolleybus_System.TargetButtonData
		
		if dt.button and dt.bus and dt.bus.m_ButtonsData and dt.bus.m_ButtonsData[dt.button] then
			local id = dt.bus.m_ButtonsData[dt.button].nameplatebtn
			local route = dt.bus:GetSystem("Nameplates"):GetRoute(id)
			local data = Trolleybus_System.Routes.Routes[route]
			
			local name = data and (Trolleybus_System.Routes.GetRouteName(route) or route) or nil
			local startname = data and Trolleybus_System.Routes.GetRouteStart(route) or L"GoingToPark1"
			local endname = data and Trolleybus_System.Routes.GetRouteEnd(route) or L"GoingToPark2"
			
			surface.SetFont("Trolleybus_System.Clicker.RouteDisplay")
			
			local w1,h1 = surface.GetTextSize(name or "")
			local w2,h2 = surface.GetTextSize(startname)
			local w3,h3 = surface.GetTextSize(endname)
			
			local w,h = math.max(w1,w2,w3),name and h1+h2+h3 or h2+h3
			local asp = w/h
			
			local pos,ang,bone = Vector(4.5,-4.7,0.3),Angle(171.5,-52,76),"ValveBiped.Bip01_R_Hand"
			local maxunitsx,maxunitsy = 7.2,4.2
			local maxunitsasp = maxunitsx/maxunitsy
			
			local m = vm:GetBoneMatrix(vm:LookupBone(bone))
			if m then
				local p,a = LocalToWorld(pos,ang,m:GetTranslation(),m:GetAngles())
				local scale = asp>maxunitsasp and maxunitsx/w or maxunitsy/h
				
				cam.Start3D2D(p,a,scale)
					/*surface.SetDrawColor(255,0,0,150)
					surface.DrawRect(-w/2,-h/2,w,h)
					surface.SetDrawColor(0,255,0)
					surface.DrawRect(-1,-1,2,2)*/
					
					if name then
						draw.SimpleText(name,"Trolleybus_System.Clicker.RouteDisplay",0,-h2/2,color_black,1,4)
						draw.SimpleText(startname,"Trolleybus_System.Clicker.RouteDisplay",0,0,color_black,1,1)
						draw.SimpleText(endname,"Trolleybus_System.Clicker.RouteDisplay",0,h2/2,color_black,1)
					else
						draw.SimpleText(startname,"Trolleybus_System.Clicker.RouteDisplay",0,0,color_black,1,4)
						draw.SimpleText(endname,"Trolleybus_System.Clicker.RouteDisplay",0,0,color_black,1)
					end
				cam.End3D2D()
			end
		end
	elseif self:GetReverse() then
		self:SetupReverseModel(vm,true)
	end
end

function SWEP:SetupReverseModel(ent,reset)
	if !reset then
		local type = self:GetReverseType()
		local number = self:GetReverseNumber()
		
		self.ReverseSkinToReset = ent:GetSkin()
		self.ReverseBG1ToReset = ent:GetBodygroup(1)
		self.ReverseBG2ToReset = ent:GetBodygroup(2)
		self.ReverseBG3ToReset = ent:GetBodygroup(3)
		
		ent:SetSkin(type)
		ent:SetBodygroup(1,math.floor(number/100)%10)
		ent:SetBodygroup(2,math.floor(number/10)%10)
		ent:SetBodygroup(3,math.floor(number)%10)
	else
		ent:SetSkin(self.ReverseSkinToReset)
		ent:SetBodygroup(1,self.ReverseBG1ToReset)
		ent:SetBodygroup(2,self.ReverseBG2ToReset)
		ent:SetBodygroup(3,self.ReverseBG3ToReset)
	end
end

function SWEP:DrawHUD()
	Trolleybus_System.DrawHUDSelectorData()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end