-- Copyright © Platunov I. M., 2021 All rights reserved

local L = SERVER and function() end or Trolleybus_System.GetLanguagePhrase

Trolleybus_System.ContactNetwork = Trolleybus_System.ContactNetwork or {}
Trolleybus_System.ContactNetwork.Objects = Trolleybus_System.ContactNetwork.Objects or {Contacts = {},SuspensionAndOther = {}}

local ACCURATE_COMPENSATION = 1

local function WheelPosOnLine(start,endp,polepos,polelen,endpos)
	local lpos = WorldToLocal(polepos,angle_zero,start,(endp-start):Angle())

	local ldist = lpos.y*lpos.y+lpos.z*lpos.z
	if ldist>polelen*polelen then return end

	local xdst = polelen*polelen-ldist
	local x = lpos.x+(endpos and math.sqrt(xdst) or -math.sqrt(xdst))

	if x<-ACCURATE_COMPENSATION then return false end

	local dist = endp:Distance(start)
	if x>dist+ACCURATE_COMPENSATION then return true end

	return nil,start+(endp-start):GetNormalized()*x,endpos and (start-endp):Angle() or (endp-start):Angle()
end

local function GetCurveData(pos,ang,left,len,angle)
	local radius = len/math.rad(angle)
	local center = pos+ang:Right()*(left and -1 or 1)*radius

	local ang2 = Angle(ang)
	ang2:RotateAroundAxis(ang2:Up(),left and -angle/2 or angle/2)
	local start = center+ang2:Right()*(left and 1 or -1)*radius

	local ang3 = Angle(ang)
	ang3:RotateAroundAxis(ang3:Up(),left and angle/2 or -angle/2)
	local endp = center+ang3:Right()*(left and 1 or -1)*radius

	return radius,center,start,ang2,endp,ang3
end

local function WheelPosAngOnCurve(center,radius,left,ang,start,startang,polepos,polelen,endpos,simplepos)
	local fail = false
	local distcenter = polepos:Distance(center)
	
	local angtostart = Angle(startang)
	angtostart:RotateAroundAxis(angtostart:Up(),left and -90 or 90)
	
	local angle
	if distcenter>polelen+radius or polelen>distcenter+radius or radius>polelen+distcenter then
		fail = true
		angle = 0

		if simplepos then return end
	else
		angle = math.acos((distcenter*distcenter+radius*radius-polelen*polelen)/(2*distcenter*radius))
	end
	
	local lpolepos = WorldToLocal(polepos,angle_zero,center,angtostart)
	local lpoledist = math.sqrt(lpolepos.x*lpolepos.x+lpolepos.y*lpolepos.y)
	local lrpolepos = lpolepos/lpoledist*radius
	local lrpolelen = lrpolepos:Length()
	
	local trihgt = math.abs(lrpolepos.z)
	local trihyp = math.sqrt(radius*radius+lrpolelen*lrpolelen-2*lrpolelen*radius*math.cos(angle))
	
	local range
	if trihgt>trihyp then
		fail = true
		range = 0

		if simplepos then return end
	else
		range = math.sqrt(trihyp*trihyp-trihgt*trihgt)
	end
	
	local rotate = math.deg(math.acos((radius*radius*2-range*range)/(2*radius*radius)))
	if rotate!=rotate then
		fail = true
		rotate = 0

		if simplepos then return end
	end

	local angrot = Vector(lpolepos.x,lpolepos.y):Angle()
	
	local rotateleft = Either(left,endpos,!endpos)
	angrot:RotateAroundAxis(angrot:Up(),rotateleft and rotate or -rotate)
	
	local ACCURATE_COMPENSATION = ACCURATE_COMPENSATION/(2*math.pi*radius)*360

	if Either(left,angrot.y<-ACCURATE_COMPENSATION,angrot.y>ACCURATE_COMPENSATION) then return false end
	
	local lfinalpos = angrot:Forward()*radius
	local angdiff = math.deg(math.acos((radius*radius*2-lfinalpos:DistToSqr(Vector(radius,0,0)))/(2*radius*radius)))
	
	if angdiff!=angdiff then
		fail = true
		angdiff = 0

		if simplepos then return end
	end

	if angdiff>ang+ACCURATE_COMPENSATION then return true end
	
	if fail then return end
	
	return nil,LocalToWorld(lfinalpos,Angle(0,(endpos and 180 or 0)+(left and 90+angdiff or -90-angdiff),0),center,angtostart)
end

local function SetupBonesToCurve(ent,bonesinfo,center,radius,startang,angle,left)
	for k,v in ipairs(bonesinfo) do
		local bone = ent:LookupBone(v[1])
		if !bone then continue end

		local m = ent:GetBoneMatrix(bone)
		if !m then continue end
 
		local a = Angle(startang)
		a:RotateAroundAxis(a:Up(),left and angle*v[2] or -angle*v[2])

		m:SetTranslation(center+a:Right()*(left and 1 or -1)*radius)
		m:SetAngles(a)

		ent:SetBoneMatrix(bone,m)
	end
end

local function ChangeMainPosByChangingLocalPos(mpos,mang,opos,oang,npos,nang)
	local lmpos,lmang = WorldToLocal(mpos,mang,opos,oang)
	return LocalToWorld(lmpos,lmang,npos or opos,nang or oang)
end

local function ChangeMainPosByChangingLocalPosLocal(mpos,mang,lpos,lang,npos,nang)
	local opos,oang = LocalToWorld(lpos,lang,mpos,mang)
	return ChangeMainPosByChangingLocalPos(mpos,mang,opos,oang,npos,nang)
end

local function PlayContactSound(bus,pos,snd)
	local speed = math.abs(bus:GetMoveSpeed())
	
	if speed>1 then
		local pitch = math.Clamp(math.Remap(speed,1,30,90,150),90,150)

		sound.Play("trolleybus/contactnetwork/"..snd..".ogg",pos,60,pitch,1)
	end
end

local function GetChanceToFlyOffOnSwitch(speed)
	return Trolleybus_System.GetAdminSetting("trolleybus_poles_speed_check") and math.Clamp(math.Remap(speed,15,25,0,100),0,100) or 0
end

local function GetChanceToFlyOffOnCross(speed)
	return Trolleybus_System.GetAdminSetting("trolleybus_poles_speed_check") and math.Clamp(math.Remap(speed,20,30,0,100),0,100) or 0
end

Trolleybus_System.ContactNetwork.Types = {
	Contacts = {
		["wire"] = {
			Name = L"contactnetwork.types.contacts.wire",
			MainContact = true,
			ConnectablePositions = {
				{
					Move = function(self,data,pos) data.Start[1] = pos end,
					Rotate = function(self,data,ang) data.Start[2] = ang end,
					GetPosition = function(self,data) return data.Start[1] end,
					GetAngles = function(self,data) return data.Start[2] end,
				},
				{
					Move = function(self,data,pos) data.End[1] = pos end,
					Rotate = function(self,data,ang) data.End[2] = ang end,
					GetPosition = function(self,data) return data.End[1] end,
					GetAngles = function(self,data) return data.End[2] end,
				},
			},
			Properties = {
				["invertstart"] = {
					Name = L"contactnetwork.types.contacts.wire.properties.invertstart",
					Default = false,
					Type = "CheckBox",
					Update = function(self,data,value)
						data.InvertStart = value
					end,
				},
				["invertend"] = {
					Name = L"contactnetwork.types.contacts.wire.properties.invertend",
					Default = false,
					Type = "CheckBox",
					Update = function(self,data,value)
						data.InvertEnd = value
					end,
				},
			},
			Wires = {
				{Start = 1,End = 2},
			},
			Initialize = function(self,data,pos,ang)
				data.Start = {pos,ang}
				data.End = {pos+ang:Forward()*10,ang}
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/wire.mdl",RENDERGROUP_BOTH)
				ent:SetupBones()
				ent.End = ent:LookupBone("End")
				
				if ent.End then
					ent:AddCallback("BuildBonePositions",function(ent,bones)
						local m = ent:GetBoneMatrix(ent.End)
						if m then
							m:SetTranslation(ent.EndPos[1])
							m:SetAngles(ent.EndPos[2])
							ent:SetBoneMatrix(ent.End,m)
						end
					end)
				end
				
				return ent
			end,
			UpdateModel = function(self,data,ent)
				local angstart = Angle(data.Start[2])
				local angend = Angle(data.End[2])

				if data.InvertStart then angstart:RotateAroundAxis(angstart:Up(),180) end
				if data.InvertEnd then angend:RotateAroundAxis(angend:Up(),180) end

				ent:SetPos(data.Start[1])
				ent:SetAngles(angstart)
				ent.EndPos = {data.End[1],angend}
				
				local b1,b2 = Vector(),ent:WorldToLocal(data.End[1])
				OrderVectors(b1,b2)
				
				ent:SetRenderBounds(b1,b2,Vector(2,2,2))
				ent:SetupBones()
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return util.DistanceToLine(data.Start[1],data.End[1],eyepos)<maxdist
			end,
			GetPosition = function(self,data)
				return (data.Start[1]+data.End[1])/2
			end,
			GetAngles = function(self,data)
				return (data.End[1]-data.Start[1]):Angle()
			end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {1}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return connectable==1 and {2} or {1}
			end,
		},
		["voltagewire"] = {
			Name = L"contactnetwork.types.contacts.voltagewire",
			upd = function(self,data,pos,isend)
				local pdist = (data.End-data.Start):Length()

				local fr1 = data.Middle1.x/pdist
				local fr2 = data.Middle2.x/pdist
				local fr3 = data.Middle3.x/pdist

				if isend then
					data.End = pos
				else
					data.Start = pos
				end

				local dist = (data.End-data.Start):Length()
				data.Middle1.x = fr1*dist
				data.Middle2.x = fr2*dist
				data.Middle3.x = fr3*dist
			end,
			ConnectablePositions = {
				{
					Move = function(self,data,pos) self:upd(data,pos,false) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return data.Start end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					Move = function(self,data,pos) self:upd(data,pos,true) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return data.End end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					Move = function(self,data,pos) data.Middle1 = WorldToLocal(pos,angle_zero,data.Start,self:GetAngles(data)) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return LocalToWorld(data.Middle1,angle_zero,data.Start,self:GetAngles(data)) end,
					GetAngles = function(self,data) return angle_zero end,
					ForModelChangeOnly = true,
				},
				{
					Move = function(self,data,pos) data.Middle2 = WorldToLocal(pos,angle_zero,data.End,self:GetAngles(data)) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return LocalToWorld(data.Middle2,angle_zero,data.End,self:GetAngles(data)) end,
					GetAngles = function(self,data) return angle_zero end,
					ForModelChangeOnly = true,
				},
				{
					Move = function(self,data,pos) data.Middle3 = WorldToLocal(pos,angle_zero,data.End,self:GetAngles(data)) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return LocalToWorld(data.Middle3,angle_zero,data.End,self:GetAngles(data)) end,
					GetAngles = function(self,data) return angle_zero end,
					ForModelChangeOnly = true,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = 2},
			},
			Initialize = function(self,data,pos,ang)
				data.Start = pos
				data.End = pos+ang:Forward()*20
				data.Middle1 = Vector(5,0,0)
				data.Middle2 = Vector(-10,0,0)
				data.Middle3 = Vector(-5,0,0)
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/rope.mdl",RENDERGROUP_BOTH)
				ent:SetupBones()
				ent.End = ent:LookupBone("End")
				ent.Middle1 = ent:LookupBone("Middle1")
				ent.Middle2 = ent:LookupBone("Middle2")
				ent.Middle3 = ent:LookupBone("Middle3")
				
				if ent.End and ent.Middle1 and ent.Middle2 and ent.Middle3 then
					ent:AddCallback("BuildBonePositions",function(ent,bones)
						local ang = ent:GetAngles()

						local m = ent:GetBoneMatrix(ent.End)
						if m then
							m:SetTranslation(data.End)
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.End,m)
						end

						local m = ent:GetBoneMatrix(ent.Middle1)
						if m then
							m:SetTranslation(ent:LocalToWorld(data.Middle1))
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.Middle1,m)
						end

						local m = ent:GetBoneMatrix(ent.Middle2)
						if m then
							m:SetTranslation(LocalToWorld(data.Middle2,angle_zero,data.End,ang))
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.Middle2,m)
						end

						local m = ent:GetBoneMatrix(ent.Middle3)
						if m then
							m:SetTranslation(LocalToWorld(data.Middle3,angle_zero,data.End,ang))
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.Middle3,m)
						end
					end)
				end
				
				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Start)
				ent:SetAngles(self:GetAngles(data))
				
				local b1,b2 = Vector(),ent:WorldToLocal(data.End)
				OrderVectors(b1,b2)
				
				ent:SetRenderBounds(b1,b2,Vector(2,2,2))
				ent:SetupBones()
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return util.DistanceToLine(data.Start,data.End,eyepos)<maxdist
			end,
			GetPosition = function(self,data)
				return (data.Start+data.End)/2
			end,
			GetAngles = function(self,data)
				return (data.End-data.Start):Angle()
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {1}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return connectable==1 and {2} or {1}
			end,
		},
		["voltsrc"] = {
			Name = L"contactnetwork.types.contacts.voltsrc",
			VoltageSource = true,
			ldata = {Vector(-2,-2.9,41.77),Vector(2,-2.9,41.77)},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					Move = function(self,data,pos) data.Pos = pos end,
					GetPosition = function(self,data) return data.Pos end,
					Rotate = function(self,data,ang) data.Ang = ang end,
					GetAngles = function(self,data) return data.Ang end,
					ConnectingFilter = {["pillar"] = {11}},
				},
			},
			Properties = {
				["power"] = {
					Name = L"contactnetwork.types.contacts.voltsrc.properties.power",
					Default = 100,
					Min = 0,
					Max = 100,
					Decimals = 0,
					Type = "Slider",
					Update = function(self,data,value)
						data.Power = value/100
					end,
				},
			},
			Wires = {},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/electric_box.mdl",RENDERGROUP_BOTH)
				local snd = "ambient/machines/electrical_hum_2.wav"

				hook.Add("Think",ent,function(ent)
					if !data.NW then return end

					if data.NW.GetVar("Disabled") or (data.Power or 1)==0 then
						if ent.snd then
							ent.snd:Stop()
							ent.snd = nil
						end
					elseif !ent.snd then
						ent.snd = CreateSound(ent,snd)
						ent.snd:SetSoundLevel(50)
						ent.snd:PlayEx(0.75,100)
					end
				end)

				ent:CallOnRemove("voltsrcsnd",function(ent)
					if ent.snd then
						ent.snd:Stop()
						ent.snd = nil
					end
				end)

				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			SetupCollision = function(self,data,ent)
				ent:SetModel("models/trolleybus/contactnetwork/electric_box.mdl")

				hook.Add("PlayerUse",ent,function(ent,ply,useent)
					if ent==useent and (!ent.LastUse or CurTime()-ent.LastUse>1) then
						ent.LastUse = CurTime()

						if Trolleybus_System.RunEvent("ContactNetwork_AllowToggleVoltageSources",ply) then
							local wasenabled = !data.NW.GetVar("Disabled")
							data.NW.SetVar("Disabled",wasenabled)

							local min,max = ent:GetCollisionBounds()
							local pos = ent:LocalToWorld((min+max)/2)

							if wasenabled then
								sound.Play("trolleybus/paketnik_off.ogg",pos,60,100,1)
							else
								sound.Play("trolleybus/paketnik_on.ogg",pos,60,100,1)
							end

							local voltsrck = "???"

							for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
								if v.Collision==ent then
									voltsrck = k
									break
								end
							end

							ServerLog("Trolleybus System: Voltage source toggled "..(wasenabled and "OFF" or "ON").." by "..ply:Nick().." ["..ply:SteamID().."] (id: "..voltsrck..")\n")
						end
					end
				end)
			end,
			UpdateCollision = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			GetPosition = function(self,data) return data.Pos end,
			GetAngles = function(self,data) return data.Ang end,
			GetVoltage = function(self,data)
				return data.NW.GetVar("Disabled") and 0 or Trolleybus_System.ContactNetwork.GetVoltage()*(data.Power or 1)
			end,
		},
		["switch<"] = {
			Name = L"contactnetwork.types.contacts.switch<",
			MainContact = true,
			ldata = {
				Vector(0,10.08),Vector(0,-9.14),Vector(69.49,16.61),Vector(101.55,0.44),Vector(130.55,-11.08),Vector(75.40,-17.14),
				Vector(37.53,10.08),Vector(37.53,-9.14),
				Vector(56.10,6.86),Vector(122.87,-9.35),
				Vector(46.82,11.02),Vector(46.82,9.17),Vector(46.81,-8.23),Vector(46.82,-10.06),
			},
			langs = {
				Angle(0,0,0),Angle(0,0,0),Angle(0,13.24,0),Angle(0,8.24,0),Angle(0,-13.94,0),Angle(0,-10.75,0),
			},
			lsusp = {
				Vector(35.12,14.05,1.66),Vector(35.10,-13.16,1.66),Vector(50.64,15.54,1.66),Vector(50.63,-14.65,1.66),
				Vector(89.73,2.21,1.43),Vector(89.73,-5.01,1.43)
			},
			lnwires = {
				{{9,10},{11,12,true},nil,nil,6,7,nil,nil,3,4,5,8},
				{nil,nil,9,11,10,5,6,12,{1,nil},{nil,1},{2,nil,true},{nil,2,true}},
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[1],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[2],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[3],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[4],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[5],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[6],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = function(self,data) return self.ldata[7],true end},
				{Start = 2,End = function(self,data) return self.ldata[8],true end},
				{Start = function(self,data) return self.ldata[11],true end,End = 3},
				{Start = function(self,data) return self.ldata[13],true end,End = 4},
				{Start = function(self,data) return self.ldata[12],true end,End = function(self,data) return self.ldata[9],true end},
				{Start = function(self,data) return self.ldata[9],true end,End = function(self,data) return self.ldata[10],true end},
				{Start = function(self,data) return self.ldata[10],true end,End = 5},
				{Start = function(self,data) return self.ldata[14],true end,End = 6},
				{Start = function(self,data) return self.ldata[7],true end,End = function(self,data) return self.ldata[11],true end},
				{Start = function(self,data) return self.ldata[7],true end,End = function(self,data) return self.ldata[12],true end},
				{Start = function(self,data) return self.ldata[8],true end,End = function(self,data) return self.ldata[13],true end},
				{Start = function(self,data) return self.ldata[8],true end,End = function(self,data) return self.ldata[14],true end},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/trolleybus_switch.mdl",RENDERGROUP_BOTH)
				
				hook.Add("Think",ent,function(s)
					if !data.NW then return end

					local ldir = data.NW.GetVar("LeftDir",false) and 1 or 0
					local rdir = data.NW.GetVar("RightDir",false) and 1 or 0

					s.LeftDir = s.LeftDir or 0
					s.RightDir = s.RightDir or 0

					if ldir!=s.LeftDir then
						s.LeftDir = ldir>s.LeftDir and math.min(ldir,s.LeftDir+FrameTime()*10) or math.max(ldir,s.LeftDir-FrameTime()*10)
						s:SetPoseParameter("state_left",s.LeftDir)
					end

					if rdir!=s.RightDir then
						s.RightDir = rdir>s.RightDir and math.min(rdir,s.RightDir+FrameTime()*10) or math.max(rdir,s.RightDir-FrameTime()*10)
						s:SetPoseParameter("state_right",s.RightDir)
					end
				end)
				
				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end

					local ndata = self.lnwires[errend and 1 or 2][wire]
					local nwire = ndata

					if istable(ndata) then
						local dir = data.NW.GetVar(ndata[3] and "RightDir" or "LeftDir",false)
						nwire = Either(dir,ndata[1],ndata[2])
					end
					
					if nwire then
						return nwire
					else
						return {error = 1,wire = wire,endpos = errend}
					end
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return
					(connectable==1 or connectable==3 or connectable==5) and {1,3,5,7,9,10} or
					(connectable==2 or connectable==4 or connectable==6) and {2,4,8,11,12} or
					{}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return
					connectable==1 and {3,5} or
					connectable==2 and {4,6} or
					connectable==3 and {1,5} or
					connectable==4 and {2,6} or
					connectable==5 and {1,3} or
					connectable==6 and {2,4}
			end,
			AmperageUpdate = function(self,data,wire,amperage)
				if wire==1 then
					data.NW.SetVar("LeftDir",math.abs(amperage)>90)
				elseif wire==2 then
					data.NW.SetVar("RightDir",math.abs(amperage)>90)
				end
			end,
			OnWheelChangedWire = function(self,data,bus,oldpos,pos,oldwire,wire)
				if
					oldwire==1 and wire==9 or wire==1 and oldwire==9 or
					oldwire==2 and wire==11 or wire==2 and oldwire==11
				then
					PlayContactSound(bus,pos,"switch_left_sep")
				elseif
					oldwire==1 and wire==10 or wire==1 and oldwire==10 or
					oldwire==2 and wire==12 or wire==2 and oldwire==12
				then
					PlayContactSound(bus,pos,"switch_right_sep")
				end
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				if wire==6 then return true end
			end,
			GetChanceToFlyOffPole = function(self,data,bus,oldwire,wire,speed)
				if
					oldwire==1 and (wire==9 or wire==10) or oldwire==2 and (wire==11 or wire==12) or
					wire==1 and (oldwire==9 or oldwire==10) or wire==2 and (oldwire==11 or oldwire==12)
				then
					return GetChanceToFlyOffOnSwitch(speed)
				end
			end,
		},
		["switch>"] = {
			Name = L"contactnetwork.types.contacts.switch>",
			MainContact = true,
			ldata = {
				Vector(0,10.05),Vector(0,-9.17),Vector(39.23,16.59),Vector(71.22,0.46),Vector(100.30,-11.10),Vector(44.84,-17.78),
				Vector(13.40,10.07),Vector(13.40,-9.11),
				Vector(25.66,6.89),Vector(92.40,-9.34),
			},
			langs = {
				Angle(0,180,0),Angle(0,180,0),Angle(0,-166.40,0),Angle(0,-171.31,0),Angle(0,166.05,0),Angle(0,165.96,0),
			},
			lsusp = {
				Vector(4.79,14.06,1.66),Vector(20.32,15.53,1.66),Vector(4.76,-13.11,1.66),Vector(20.31,-14.59,1.67)
			},
			lnwires = {
				{nil,nil,1,5,6,2,1,2},
				{{nil,3,7},{nil,6,8},nil,nil,4,5,nil,nil},
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[1],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[2],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[3],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[4],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[5],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.langs[6],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.lsusp[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return angle_zero end,
				},
			},
			Properties = {},
			Wires = {
				{Start = function(self,data) return self.ldata[8],true end,End = 2},
				{Start = function(self,data) return self.ldata[7],true end,End = 1},
				{Start = 6,End = function(self,data) return self.ldata[8],true end},
				{Start = 5,End = function(self,data) return self.ldata[10],true end},
				{Start = function(self,data) return self.ldata[10],true end,End = function(self,data) return self.ldata[9],true end},
				{Start = function(self,data) return self.ldata[9],true end,End = function(self,data) return self.ldata[7],true end},
				{Start = 4,End = function(self,data) return self.ldata[8],true end},
				{Start = 3,End = function(self,data) return self.ldata[7],true end},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/trolleybus_switch.mdl",RENDERGROUP_BOTH)
				ent:SetBodygroup(0,1)
				
				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end

					local ndata = self.lnwires[errend and 1 or 2][wire]
					local nwire = ndata

					if istable(ndata) then
						nwire = ndata[math.random(#ndata)]
					end
					
					if nwire then
						return nwire
					else
						return {error = 1,wire = wire,endpos = errend}
					end
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return
					(connectable==1 or connectable==3 or connectable==5) and {2,4,6,8} or
					(connectable==2 or connectable==4 or connectable==6) and {1,3,7} or
					{}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return
					connectable==1 and {3,5} or
					connectable==2 and {4,6} or
					connectable==3 and {1,5} or
					connectable==4 and {2,6} or
					connectable==5 and {1,3} or
					connectable==6 and {2,4}
			end,
			OnWheelChangedWire = function(self,data,bus,oldpos,pos,oldwire,wire)
				if
					oldwire==1 and wire==3 or wire==1 and oldwire==3 or
					oldwire==2 and wire==6 or wire==2 and oldwire==6
				then
					PlayContactSound(bus,pos,"switch_left_merg")
				elseif
					oldwire==1 and wire==7 or wire==1 and oldwire==7 or
					oldwire==2 and wire==8 or wire==2 and oldwire==8
				then
					PlayContactSound(bus,pos,"switch_right_merg")
				end
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				if wire==5 then return true end
			end,
			GetChanceToFlyOffPole = function(self,data,bus,oldwire,wire,speed)
				if
					oldwire==1 and (wire==3 or wire==7) or oldwire==2 and (wire==6 or wire==8) or
					wire==1 and (oldwire==3 or oldwire==7) or wire==2 and (oldwire==6 or oldwire==8)
				then
					return GetChanceToFlyOffOnSwitch(speed)
				end
			end,
		},
		["insulator"] = {
			Name = L"contactnetwork.types.contacts.insulator",
			MainContact = true,
			ldata = {Vector(29.6,0,0),Vector(18.47,0,1.91),Vector(4.61,1.67,2.83),Vector(24.91,1.67,2.83)},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return data.Pos end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					Move = function(self,data,pos) data.Pos,data.Ang = ChangeMainPosByChangingLocalPosLocal(data.Pos,data.Ang,self.ldata[2],angle_zero,pos) end,
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					Rotate = function(self,data,ang) data.Pos,data.Ang = ChangeMainPosByChangingLocalPosLocal(data.Pos,data.Ang,self.ldata[2],angle_zero,nil,ang) end,
					GetAngles = function(self,data) return data.Ang end,
					ConnectingFilter = {["suspension"] = {1,2}}
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = 2},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/insulator.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			GetPosition = function(self,data) return data.Pos end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {
					connectable==1 and 4 or connectable==4 and 1 or
					connectable==2 and 5 or connectable==5 and 2 or nil
				}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"insulator")
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				return true
			end,
		},
		["insulator2"] = {
			Name = L"contactnetwork.types.contacts.insulator2",
			MainContact = true,
			ldata = Vector(20.04,0,0),
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return data.Pos end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata,angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = 2},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/insulator_short.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"insulator")
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				return true
			end,
		},
		["smallcurve"] = {
			Name = L"contactnetwork.types.contacts.smallcurve",
			MainContact = true,
			ldata = {34,9.63,-9.63},
			susp = {Vector(0,0,4.4),Vector(0,17.3,0.9),Vector(0,-17.3,0.9)},
			bonesinfo = {
				{
					{"Left1",0},
					{"Left2",0.25},
					{"Left3",0.5},
					{"Left4",0.75},
					{"Left5",1},
				},
				{
					{"Right1",0},
					{"Right2",0.25},
					{"Right3",0.5},
					{"Right4",0.75},
					{"Right5",1},
				},
			},
			updateCurve = function(self,data)
				data.WiresData = {}

				for i=1,2 do
					local dt = {}
					dt.Radius,dt.Center,dt.Start,dt.StartAng,dt.End,dt.EndAng = GetCurveData(data.Pos-data.Ang:Right()*self.ldata[i==1 and 2 or 3],data.Ang,true,self.ldata[1],data.Angle)
					data.WiresData[i] = dt
				end
			end,
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return data.WiresData[1].Start end,
					GetAngles = function(self,data) return data.WiresData[1].StartAng end,
				},
				{
					GetPosition = function(self,data) return data.WiresData[1].End end,
					GetAngles = function(self,data) return data.WiresData[1].EndAng end,
				},
				{
					GetPosition = function(self,data) return data.WiresData[2].Start end,
					GetAngles = function(self,data) return data.WiresData[2].StartAng end,
				},
				{
					GetPosition = function(self,data) return data.WiresData[2].End end,
					GetAngles = function(self,data) return data.WiresData[2].EndAng end,
				},
				{
					GetPosition = function(self,data)
						local dt = data.WiresData[1]
						local a = Angle(dt.StartAng)
						a:RotateAroundAxis(a:Up(),data.Angle*0.5)

						return LocalToWorld(self.susp[1],angle_zero,dt.Center+a:Right()*dt.Radius,a)
					end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data)
						local dt = data.WiresData[1]
						local a = Angle(dt.StartAng)
						a:RotateAroundAxis(a:Up(),data.Angle*0.5)

						return LocalToWorld(self.susp[2],angle_zero,dt.Center+a:Right()*dt.Radius,a)
					end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data)
						local dt = data.WiresData[2]
						local a = Angle(dt.StartAng)
						a:RotateAroundAxis(a:Up(),data.Angle*0.5)

						return LocalToWorld(self.susp[1],angle_zero,dt.Center+a:Right()*dt.Radius,a)
					end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data)
						local dt = data.WiresData[2]
						local a = Angle(dt.StartAng)
						a:RotateAroundAxis(a:Up(),data.Angle*0.5)

						return LocalToWorld(self.susp[3],angle_zero,dt.Center+a:Right()*dt.Radius,a)
					end,
					GetAngles = function(self,data) return angle_zero end,
				},
			},
			Properties = {
				["ang"] = {
					Name = L"contactnetwork.types.contacts.smallcurve.properties.ang",
					Default = 5,
					Min = 5,
					Max = 30,
					Decimals = 0,
					Type = "Slider",
					Update = function(self,data,value)
						data.Angle = value
						self:updateCurve(data)
					end,
				},
			},
			Wires = {
				{Start = 1,End = 2},
				{Start = 3,End = 4},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/curve_small.mdl",RENDERGROUP_BOTH)
				ent:AddCallback("BuildBonePositions",function(ent,count)
					for i=1,2 do
						local dt = data.WiresData[i]
						SetupBonesToCurve(ent,self.bonesinfo[i],dt.Center,dt.Radius,dt.StartAng,data.Angle,true)
					end
				end)

				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos)
				data.Pos = pos
				self:updateCurve(data)
			end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang)
				data.Ang = ang
				self:updateCurve(data)
			end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local dt = data.WiresData[wire]
				local errend,pos,ang = WheelPosAngOnCurve(dt.Center,dt.Radius,true,data.Angle,dt.Start,dt.StartAng,polepos,polelen,endpos,simplepos)

				if simplepos then
					return errend==nil and pos and {pos = pos,ang = ang} or nil
				else
					if errend!=nil then return {error = 1,wire = wire,endpos = errend} end
					
					if pos then
						return {pos = pos,ang = ang,wire = wire}
					end
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {(connectable==1 or connectable==2) and 1 or 2}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {connectable==1 and 2 or connectable==2 and 1 or connectable==3 and 4 or 3}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"curve_start")
			end,
			OnWheelChangedContactFrom = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"curve_end")
			end,
			GetWheelSlidingSound = function(self,data,wire)
				return "trolleybus/contactnetwork/wheel_sliding_curve.ogg"
			end,
		},
		["curve"] = {
			Name = L"contactnetwork.types.contacts.curve",
			MainContact = true,
			ldata = {62.57,9.63,-9.63,23},
			susp = {Vector(1.8,3,1.6),Vector(1.8,-7,1.6)},
			bonesinfo = {
				{
					{"Left2",0},
					{"Left3",0.3},
					{"Left4",0.36},
					{"Left5",0.41},
					{"Left6",0.47},
					{"Left7",0.53},
					{"Left8",0.59},
					{"Left9",0.64},
					{"Left10",0.7},
					{"Left11",1},
					ends = {"Left1","Left12"},
				},
				{
					{"Right2",0},
					{"Right3",0.3},
					{"Right4",0.36},
					{"Right5",0.41},
					{"Right6",0.47},
					{"Right7",0.53},
					{"Right8",0.59},
					{"Right9",0.64},
					{"Right10",0.7},
					{"Right11",1},
					ends = {"Right1","Right12"},
				},
			},
			updateCurve = function(self,data)
				data.WiresData = {}

				for i=1,2 do
					local dt = {}
					dt.Radius,dt.Center,dt.Start,dt.StartAng,dt.End,dt.EndAng = GetCurveData(data.Pos-data.Ang:Right()*self.ldata[i==1 and 2 or 3],data.Ang,true,self.ldata[1],data.Angle)
					dt.Start2 = dt.Start-dt.StartAng:Forward()*self.ldata[4]
					dt.End2 = dt.End+dt.EndAng:Forward()*self.ldata[4]

					data.WiresData[i] = dt
				end
			end,
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return data.WiresData[1].Start2 end,
					GetAngles = function(self,data) return data.WiresData[1].StartAng end,
				},
				{
					GetPosition = function(self,data) return data.WiresData[1].End2 end,
					GetAngles = function(self,data) return data.WiresData[1].EndAng end,
				},
				{
					GetPosition = function(self,data) return data.WiresData[2].Start2 end,
					GetAngles = function(self,data) return data.WiresData[2].StartAng end,
				},
				{
					GetPosition = function(self,data) return data.WiresData[2].End2 end,
					GetAngles = function(self,data) return data.WiresData[2].EndAng end,
				},
				{
					GetPosition = function(self,data)
						local dt = data.WiresData[1]
						local a = Angle(dt.StartAng)
						a:RotateAroundAxis(a:Up(),data.Angle*0.47)

						return LocalToWorld(self.susp[1],angle_zero,dt.Center+a:Right()*dt.Radius,a)
					end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					GetPosition = function(self,data)
						local dt = data.WiresData[2]
						local a = Angle(dt.StartAng)
						a:RotateAroundAxis(a:Up(),data.Angle*0.47)

						return LocalToWorld(self.susp[2],angle_zero,dt.Center+a:Right()*dt.Radius,a)
					end,
					GetAngles = function(self,data) return angle_zero end,
				},
			},
			Properties = {
				["ang"] = {
					Name = L"contactnetwork.types.contacts.curve.properties.ang",
					Default = 25,
					Min = 25,
					Max = 45,
					Decimals = 0,
					Type = "Slider",
					Update = function(self,data,value)
						data.Angle = value
						self:updateCurve(data)
					end,
				},
			},
			Wires = {
				{Start = 1,End = function(self,data) return data.WiresData[1].Start end},
				{Start = 3,End = function(self,data) return data.WiresData[2].Start end},
				{Start = function(self,data) return data.WiresData[1].Start end,End = function(self,data) return data.WiresData[1].End end},
				{Start = function(self,data) return data.WiresData[2].Start end,End = function(self,data) return data.WiresData[2].End end},
				{Start = function(self,data) return data.WiresData[1].End end,End = 2},
				{Start = function(self,data) return data.WiresData[2].End end,End = 4},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/curve_big.mdl",RENDERGROUP_BOTH)
				ent:AddCallback("BuildBonePositions",function(ent,count)
					for i=1,2 do
						local dt = data.WiresData[i]
						SetupBonesToCurve(ent,self.bonesinfo[i],dt.Center,dt.Radius,dt.StartAng,data.Angle,true)

						for j=1,2 do
							local bone = ent:LookupBone(self.bonesinfo[i].ends[j])
							if !bone then continue end

							local m = ent:GetBoneMatrix(bone)
							if !m then continue end

							m:SetTranslation(j==1 and dt.Start2 or dt.End2)
							m:SetAngles(j==1 and dt.StartAng or dt.EndAng)
							ent:SetBoneMatrix(bone,m)
						end
					end
				end)

				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos)
				data.Pos = pos
				self:updateCurve(data)
			end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang)
				data.Ang = ang
				self:updateCurve(data)
			end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				if wire==3 or wire==4 then
					local dt = data.WiresData[wire==3 and 1 or 2]
					local errend,pos,ang = WheelPosAngOnCurve(dt.Center,dt.Radius,true,data.Angle,dt.Start,dt.StartAng,polepos,polelen,endpos,simplepos)

					if simplepos then
						return errend==nil and pos and {pos = pos,ang = ang} or nil
					else
						if errend!=nil then
							return errend and (wire==3 and 5 or 6) or (wire==3 and 1 or 2)
						end

						if pos then
							return {pos = pos,ang = ang,wire = wire}
						end
					end
				else
					local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)
					if !pos then
						if !simplepos then
							local nwire = 
							errend and (wire==1 and 3 or wire==2 and 4) or
							!errend and (wire==5 and 3 or wire==6 and 4)

							if nwire then return nwire end
						end

						return errend!=nil and {error = 1,wire = wire,endpos = errend} or nil
					end

					return {pos = pos,ang = ang,wire = wire}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return
					(connectable==1 or connectable==2) and {1,3,5} or
					(connectable==3 or connectable==4) and {2,4,6} or 
					{}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {connectable==1 and 2 or connectable==2 and 1 or connectable==3 and 4 or 3}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"curve_start")
			end,
			OnWheelChangedContactFrom = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"curve_end")
			end,
			GetWheelSlidingSound = function(self,data,wire)
				return "trolleybus/contactnetwork/wheel_sliding_curve.ogg"
			end,
		},
		["cross90"] = {
			Name = L"contactnetwork.types.contacts.cross90",
			MainContact = true,
			ldata = {
				Vector(-34.14,9.67,0),Vector(-34.14,-9.63,0),Vector(34,9.67,0),Vector(43.55,-9.65,0),
				Vector(9.57,34.3,0),Vector(-9.76,34.4,0),Vector(9.57,-34.37,0),Vector(-9.75,-43.83,0),
				Angle(0,0,0),Angle(0,-90,0),
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[7],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[8],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = 3},
				{Start = 2,End = 4},
				{Start = 5,End = 7},
				{Start = 6,End = 8},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/cross90.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {
					connectable==1 and 3 or connectable==2 and 4 or
					connectable==3 and 1 or connectable==4 and 2 or
					connectable==5 and 7 or connectable==6 and 8 or
					connectable==7 and 5 or connectable==8 and 6
				}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"cross")
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				return true
			end,
			GetChanceToFlyOffPole = function(self,data,bus,oldwire,wire,speed)
				return GetChanceToFlyOffOnCross(speed)
			end,
		},
		["cross45"] = {
			Name = L"contactnetwork.types.contacts.cross45",
			MainContact = true,
			ldata = {
				Vector(-55.36,9.55,0),Vector(-26.44,-9.75,0),Vector(26.67,9.56,0),Vector(46.04,-9.75,0),
				Vector(-21.94,33.8,0),Vector(-38.87,27.04,0),Vector(40.04,-28.19,0),Vector(16.3,-28.11,0),
				Angle(0,0,0),Angle(0,-45,0),
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[7],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[8],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = 3},
				{Start = 2,End = 4},
				{Start = 5,End = 7},
				{Start = 6,End = 8},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/cross45.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {
					connectable==1 and 3 or connectable==2 and 4 or
					connectable==3 and 1 or connectable==4 and 2 or
					connectable==5 and 7 or connectable==6 and 8 or
					connectable==7 and 5 or connectable==8 and 6
				}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"cross")
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				return true
			end,
			GetChanceToFlyOffPole = function(self,data,bus,oldwire,wire,speed)
				return GetChanceToFlyOffOnCross(speed)
			end,
		},
		["cross902"] = {
			Name = L"contactnetwork.types.contacts.cross902",
			MainContact = true,
			ldata = {
				Vector(-48.36,9.55,0),Vector(-48.36,-9.79,0),Vector(39.45,9.56,0.06),Vector(39.45,-9.78,0),
				Vector(16.39,11.1,0),Vector(-16.46,11.1,0),Vector(16.39,-11.22,0),Vector(-16.46,-11.22,0),
				Angle(0,0,0),Angle(0,-90,0),
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[9],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[7],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[8],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[10],data.Pos,data.Ang)) end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = 3},
				{Start = 2,End = 4},
				{Start = 5,End = 7},
				{Start = 6,End = 8},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/cross90_1side.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {(connectable==5 or connectable==7) and 3 or (connectable==6 or connectable==8) and 4 or nil}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {
					connectable==1 and 3 or connectable==2 and 4 or
					connectable==3 and 1 or connectable==4 and 2 or
					connectable==5 and 7 or connectable==6 and 8 or
					connectable==7 and 5 or connectable==8 and 6
				}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				if wire==1 or wire==2 then
					PlayContactSound(bus,pos,"cross")
				end
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				if wire==1 or wire==2 then
					return true
				end
			end,
			GetChanceToFlyOffPole = function(self,data,bus,oldwire,wire,speed)
				return GetChanceToFlyOffOnCross(speed)
			end,
		},
		["crosstram"] = {
			Name = L"contactnetwork.types.contacts.crosstram",
			MainContact = true,
			ldata = {
				Vector(0,12.39,1.71),Vector(0,-12.42,1.71),Vector(0.07,47.31,-0.48),Vector(0.07,-47.44,-0.48),
				Angle(0,0,0),Angle(0,-90,0),
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[5],data.Pos,data.Ang)) end,
					ConnectingFilter = {["clamp"] = {2}},
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[5],data.Pos,data.Ang)) end,
					ConnectingFilter = {["clamp"] = {2}},
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[6],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[6],data.Pos,data.Ang)) end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 3,End = 4},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/crosstram.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {connectable==3 and 4 or 3}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"cross")
			end,
			GetChanceToFlyOffPole = function(self,data,bus,oldwire,wire,speed)
				return GetChanceToFlyOffOnCross(speed)
			end,
		},
		["cross60"] = {
			Name = L"contactnetwork.types.contacts.cross60",
			MainContact = true,
			ldata = {
				Vector(-57.28,9.68,0),Vector(-35.51,-9.64,0),Vector(39,9.66,0),Vector(54.41,-9.64,0),
				Vector(9.68,51.26,0),Vector(-9.68,56.59,0),Vector(9.65,-45.65,0),Vector(-9.68,-35.02,0),
				Vector(-29.38,48.72,0),Vector(-39.05,39.04,0),Vector(54.16,-34.82,0),Vector(41.61,-41.6,0),
				Angle(0,0,0),Angle(0,-90,0),Angle(0,-45,0),
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[13],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[13],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[13],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[13],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[14],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[14],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[7],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[14],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[8],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[14],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[9],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[15],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[10],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[15],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[11],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[15],data.Pos,data.Ang)) end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[12],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[15],data.Pos,data.Ang)) end,
				},
			},
			Properties = {},
			Wires = {
				{Start = 1,End = 3},
				{Start = 2,End = 4},
				{Start = 5,End = 7},
				{Start = 6,End = 8},
				{Start = 9,End = 11},
				{Start = 10,End = 12},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/cross60.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
			CalculateWheelData = function(self,data,polepos,polelen,endpos,wire,start,endp,simplepos)
				local errend,pos,ang = WheelPosOnLine(start,endp,polepos,polelen,endpos)

				if simplepos then
					return pos and {pos = pos,ang = ang} or nil
				else
					if pos then return {pos = pos,ang = ang,wire = wire} end
					if errend==nil then return end
					
					return {error = 1,wire = wire,endpos = errend}
				end
			end,
			GetWiresToUpdateVoltage = function(self,connectable)
				return {}
			end,
			GetNextConnectablesToUpdateVoltage = function(self,connectable)
				return {
					connectable==1 and 3 or connectable==2 and 4 or
					connectable==3 and 1 or connectable==4 and 2 or
					connectable==5 and 7 or connectable==6 and 8 or
					connectable==7 and 5 or connectable==8 and 6 or
					connectable==9 and 11 or connectable==10 and 12 or
					connectable==11 and 9 or connectable==12 and 10 or nil
				}
			end,
			OnWheelChangedContactTo = function(self,data,bus,pos,wire)
				PlayContactSound(bus,pos,"cross")
			end,
			AllowElectricArcsOnWire = function(self,data,wire)
				return true
			end,
			GetChanceToFlyOffPole = function(self,data,bus,oldwire,wire,speed)
				return GetChanceToFlyOffOnCross(speed)
			end,
		},
	},
	SuspensionAndOther = {
		["rope"] = {
			Name = L"contactnetwork.types.suspensionandother.rope",
			upd = function(self,data,pos,isend)
				local pdist = (data.End-data.Start):Length()

				local fr1 = data.Middle1.x/pdist
				local fr2 = data.Middle2.x/pdist
				local fr3 = data.Middle3.x/pdist

				if isend then
					data.End = pos
				else
					data.Start = pos
				end

				local dist = (data.End-data.Start):Length()
				data.Middle1.x = fr1*dist
				data.Middle2.x = fr2*dist
				data.Middle3.x = fr3*dist
			end,
			ConnectablePositions = {
				{
					Move = function(self,data,pos) self:upd(data,pos,false) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return data.Start end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					Move = function(self,data,pos) self:upd(data,pos,true) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return data.End end,
					GetAngles = function(self,data) return angle_zero end,
				},
				{
					Move = function(self,data,pos) data.Middle1 = WorldToLocal(pos,angle_zero,data.Start,self:GetAngles(data)) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return LocalToWorld(data.Middle1,angle_zero,data.Start,self:GetAngles(data)) end,
					GetAngles = function(self,data) return angle_zero end,
					ForModelChangeOnly = true,
				},
				{
					Move = function(self,data,pos) data.Middle2 = WorldToLocal(pos,angle_zero,data.End,self:GetAngles(data)) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return LocalToWorld(data.Middle2,angle_zero,data.End,self:GetAngles(data)) end,
					GetAngles = function(self,data) return angle_zero end,
					ForModelChangeOnly = true,
				},
				{
					Move = function(self,data,pos) data.Middle3 = WorldToLocal(pos,angle_zero,data.End,self:GetAngles(data)) end,
					Rotate = function(self,data,ang) end,
					GetPosition = function(self,data) return LocalToWorld(data.Middle3,angle_zero,data.End,self:GetAngles(data)) end,
					GetAngles = function(self,data) return angle_zero end,
					ForModelChangeOnly = true,
				},
			},
			Properties = {},
			Initialize = function(self,data,pos,ang)
				data.Start = pos
				data.End = pos+ang:Forward()*20
				data.Middle1 = Vector(5,0,0)
				data.Middle2 = Vector(-10,0,0)
				data.Middle3 = Vector(-5,0,0)
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/rope.mdl",RENDERGROUP_BOTH)
				ent:SetupBones()
				ent.End = ent:LookupBone("End")
				ent.Middle1 = ent:LookupBone("Middle1")
				ent.Middle2 = ent:LookupBone("Middle2")
				ent.Middle3 = ent:LookupBone("Middle3")
				
				if ent.End and ent.Middle1 and ent.Middle2 and ent.Middle3 then
					ent:AddCallback("BuildBonePositions",function(ent,bones)
						local ang = ent:GetAngles()

						local m = ent:GetBoneMatrix(ent.End)
						if m then
							m:SetTranslation(data.End)
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.End,m)
						end

						local m = ent:GetBoneMatrix(ent.Middle1)
						if m then
							m:SetTranslation(ent:LocalToWorld(data.Middle1))
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.Middle1,m)
						end

						local m = ent:GetBoneMatrix(ent.Middle2)
						if m then
							m:SetTranslation(LocalToWorld(data.Middle2,angle_zero,data.End,ang))
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.Middle2,m)
						end

						local m = ent:GetBoneMatrix(ent.Middle3)
						if m then
							m:SetTranslation(LocalToWorld(data.Middle3,angle_zero,data.End,ang))
							m:SetAngles(ang)
							ent:SetBoneMatrix(ent.Middle3,m)
						end
					end)
				end
				
				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Start)
				ent:SetAngles(self:GetAngles(data))
				
				local b1,b2 = Vector(),ent:WorldToLocal(data.End)
				OrderVectors(b1,b2)
				
				ent:SetRenderBounds(b1,b2,Vector(2,2,2))
				ent:SetupBones()
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return util.DistanceToLine(data.Start,data.End,eyepos)<maxdist
			end,
			GetPosition = function(self,data)
				return (data.Start+data.End)/2
			end,
			GetAngles = function(self,data)
				return (data.End-data.Start):Angle()
			end,
		},
		["suspension"] = {
			Name = L"contactnetwork.types.suspensionandother.suspension",
			ldata = {
				Vector(0,11.04,1.28),Vector(0,-11.03,1.28),
				Vector(0,11.04,4.1),Vector(0,-11.03,4.1),
				Vector(0,28.46,0.6),Vector(0,-28.46,0.6),
				Vector(0,20.7,0.6),Vector(0,-20.7,0.6),
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[7],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[8],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {
				["variant"] = {
					Name = L"contactnetwork.types.suspensionandother.suspension.properties.variant",
					Default = 1,
					Min = 1,
					Max = 5,
					Decimals = 0,
					Type = "Slider",
					Update = function(self,data,value) data.Variant = value-1 end,
				},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/suspension.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetBodygroup(0,data.Variant)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["clamp"] = {
			Name = L"contactnetwork.types.suspensionandother.clamp",
			ldata = Vector(0,0,1.5),
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return data.Pos end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					Move = function(self,data,pos) data.Pos,data.Ang = ChangeMainPosByChangingLocalPosLocal(data.Pos,data.Ang,self.ldata,angle_zero,pos) end,
					Rotate = function(self,data,ang) data.Pos,data.Ang = ChangeMainPosByChangingLocalPosLocal(data.Pos,data.Ang,self.ldata,angle_zero,nil,ang) end,
					GetPosition = function(self,data) return LocalToWorld(self.ldata,angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {
				["rotation"] = {
					Name = L"contactnetwork.types.suspensionandother.clamp.properties.rotation",
					Default = 0,
					Min = -180,
					Max = 180,
					Decimals = 0,
					Type = "Slider",
					Update = function(self,data,value) data.Rot = value end,
				},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/clip.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)

				local ang = Angle(data.Ang)
				if data.Rot and math.abs(data.Rot)>0 then ang:RotateAroundAxis(ang:Up(),data.Rot) end

				ent:SetAngles(ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			GetPosition = function(self,data) return data.Pos end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["pillar"] = {
			Name = L"contactnetwork.types.suspensionandother.pillar",
			ldata = {
				Vector(0,6.88,255.52),Vector(-7,0,255.52),Vector(-0.13,-6.86,255.52),Vector(6.92,0.01,255.49),
				Vector(0.02,-6.94,326.23),Vector(0.02,6.95,326.23),
				Vector(-4.96,-199.39,247.84),Vector(-4.96,-218.62,247.84),Vector(4.87,-218.62,247.84),Vector(4.87,-199.42,247.84),
				Vector(2,6,204.8),Angle(0,180,0),
				Vector(0,0,339),
				Vector(0,-6.77,219.4),
			},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[3],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[4],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[5],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[6],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[7],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[8],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[9],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[10],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[11],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return select(2,LocalToWorld(vector_origin,self.ldata[12],data.Pos,data.Ang)) end,
					ConnectingFilter = {["voltsrc"] = {3}},
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[13],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[14],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {
				["type"] = {
					Name = L"contactnetwork.types.suspensionandother.pillar.properties.type",
					Default = 1,
					Min = 1,
					Max = 6,
					Decimals = 0,
					Type = "Slider",
					Update = function(self,data,value) data.Type = value end,
				},
				["bracing"] = {
					Name = L"contactnetwork.types.suspensionandother.pillar.properties.bracing",
					Default = false,
					Type = "CheckBox",
					Update = function(self,data,value) data.Bracing = value end,
				},
				["box"] = {
					Name = L"contactnetwork.types.suspensionandother.pillar.properties.box",
					Default = false,
					Type = "CheckBox",
					Update = function(self,data,value) data.Box = value end,
				},
			},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
				ang:RotateAroundAxis(ang:Up(),180)

				data.Type = 1
				data.Box = false
				data.Bracing = false
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/pillar.mdl",RENDERGROUP_BOTH)
				ent:CreateShadow()

				return ent
			end,
			SetupCollision = function(self,data,ent)
				ent:SetModel("models/trolleybus/contactnetwork/pillar.mdl")
				ent:DrawShadow(false)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)

				local t = data.Type
				ent:SetBodygroup(1,t==2 and 1 or (t==3 or t==4 or t==5 or t==6) and 2 or 0)
				ent:SetBodygroup(2,data.Bracing and 1 or 0)
				ent:SetBodygroup(3,(t==4 or t==5 or t==6) and 1 or 0)
				ent:SetBodygroup(4,data.Box and 1 or 0)
				ent:SetBodygroup(5,(t==5 or t==6) and 1 or 0)
				ent:SetBodygroup(6,t==5 and 1 or 0)
			end,
			UpdateCollision = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["deadend"] = {
			Name = L"contactnetwork.types.suspensionandother.deadend",
			ldata = {Vector(28,5.1,-0.15),Vector(28,-5.25,-0.15)},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return data.Pos end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/deadend.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["clamp2"] = {
			Name = L"contactnetwork.types.suspensionandother.clamp2",
			ldata = Vector(0,0,-0.25),
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata,angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/overheadwire_connector.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["plank"] = {
			Name = L"contactnetwork.types.suspensionandother.plank",
			ldata = {Vector(0,9.8,-0.25),Vector(0,-9.8,-0.25)},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/plank.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["suspconsole"] = {
			Name = L"contactnetwork.types.suspensionandother.suspconsole",
			ldata = {Vector(0,0,-0.25),Vector(0,0,9)},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/suspension_console.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["ropeconnector"] = {
			Name = L"contactnetwork.types.suspensionandother.ropeconnector",
			ldata = {Vector(7.6,0,0),Vector(-7.6,0,0)},
			ConnectablePositions = {
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
				{
					GetPosition = function(self,data) return LocalToWorld(self.ldata[2],angle_zero,data.Pos,data.Ang) end,
					GetAngles = function(self,data) return data.Ang end,
				},
			},
			Properties = {},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang
			end,
			SetupModel = function(self,data)
				return ClientsideModel("models/trolleybus/contactnetwork/wire_connector.mdl",RENDERGROUP_BOTH)
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			Move = function(self,data,pos) data.Pos = pos end,
			GetPosition = function(self,data) return data.Pos end,
			Rotate = function(self,data,ang) data.Ang = ang end,
			GetAngles = function(self,data) return data.Ang end,
		},
		["pillar_lamp"] = {
			Name = L"contactnetwork.types.suspensionandother.pillar_lamp",
			ldata = {Vector(0,0,30),Vector(0,-105,84),Angle(90,-90,0),Color(255,225,125),1500,3,40,100},
			lmat = Material("sprites/light_ignorez"),
			ConnectablePositions = {
				{
					Move = function(self,data,pos) data.Pos,data.Ang = ChangeMainPosByChangingLocalPosLocal(data.Pos,data.Ang,self.ldata[1],angle_zero,pos) end,
					GetPosition = function(self,data) return LocalToWorld(self.ldata[1],angle_zero,data.Pos,data.Ang) end,
					Rotate = function(self,data,ang) data.Pos,data.Ang = ChangeMainPosByChangingLocalPosLocal(data.Pos,data.Ang,self.ldata[1],angle_zero,nil,ang) end,
					GetAngles = function(self,data) return data.Ang end,
					ConnectingFilter = {["pillar"] = {12}},
				},
			},
			Properties = {},
			Initialize = function(self,data,pos,ang)
				data.Pos = pos
				data.Ang = ang

				if SERVER and !Trolleybus_System.ContactNetwork._PillarLampLightingHook then
					Trolleybus_System.ContactNetwork._PillarLampLightingHook = true

					local time = CurTime()

					hook.Add("Think","Trolleybus_System.ContactNetwork.PillarLampLighting",function()
						if CurTime()-time>1 then
							time = CurTime()

							local emit = Trolleybus_System.RunEvent("ContactNetwork_ShouldPillarLampEmitLight")
							Trolleybus_System.NetworkSystem.SetHelperVar("ContactNetwork.PillarLampLighting","Active",emit and true or false)
						end
					end)

					function Trolleybus_System:TrolleybusSystem_ContactNetwork_ShouldPillarLampEmitLight()
						if AtmosGlobal and (AtmosGlobal:GetTime()>=20 or AtmosGlobal:GetTime()<=6) then
							return true
						end

						return false
					end
				end
			end,
			NetworkInitialize = function(self,data)
				if SERVER then
					data.NW.SetVar("dlightID",math.random(1000,8000))
				end
			end,
			SetupModel = function(self,data)
				local ent = ClientsideModel("models/trolleybus/contactnetwork/pillar_lamp.mdl",RENDERGROUP_BOTH)
				ent.pixvis = Trolleybus_System.CreatePixVisUHandle()

				hook.Add("Think",ent,function(ent)
					local id = data.NW and data.NW.GetVar("dlightID")

					if id and Trolleybus_System.NetworkSystem.GetHelperVar("ContactNetwork.PillarLampLighting","Active") then
						local light = DynamicLight(id)

						if light then
							local pos,ang = LocalToWorld(self.ldata[2],self.ldata[3],data.Pos,data.Ang)

							light.pos = pos
							light.dir = ang:Forward()
							light.dietime = CurTime()+1
							light.decay = 1000
							light.r = self.ldata[4].r
							light.g = self.ldata[4].g
							light.b = self.ldata[4].b
							light.size = self.ldata[5]
							light.brightness = self.ldata[6]
							light.outerangle = self.ldata[7]
						end
					end
				end)
				hook.Add("PostDrawTranslucentRenderables",ent,function(ent,depth,skybox,sky3d)
					if sky3d and skybox then return end
					if !Trolleybus_System.NetworkSystem.GetHelperVar("ContactNetwork.PillarLampLighting","Active") then return end

					local p,a = LocalToWorld(self.ldata[2],self.ldata[3],data.Pos,data.Ang)
					local fr = ent.pixvis:PixelVisible(p,1)

					if fr>0 then
						render.SetMaterial(self.lmat)
						render.DrawSprite(p,self.ldata[8]*fr,self.ldata[8]*fr,ColorAlpha(self.ldata[4],fr*255))
					end
				end)

				return ent
			end,
			UpdateModel = function(self,data,ent)
				ent:SetPos(data.Pos)
				ent:SetAngles(data.Ang)
			end,
			ShouldBeVisible = function(self,data,eyepos,maxdist)
				return data.Pos:DistToSqr(eyepos)<maxdist*maxdist
			end,
			GetPosition = function(self,data) return data.Pos end,
			GetAngles = function(self,data) return data.Ang end,
		},
	},
}

local visframe,vistrace
local CONTACT_NETWORK_OBJECT = {
	Init = function(self,cfg,pos,ang)
		self.Cfg = cfg
		self.Data = {}
		self.Properties = {}
		self.ConnectedConnectables = {}
		self.OtherConnectedConnectables = {}
		
		cfg:Initialize(self.Data,pos,ang)
		
		for k,v in pairs(cfg.Properties) do
			self:SetProperty(k,v.Default)
		end
		
		if CLIENT then self:UpdateVisibility() end
		if SERVER then self:UpdateCollision() end
	end,
	SetProperty = function(self,property,value)
		if !self.Cfg.Properties[property] then return end

		self.Properties[property] = value
		self.Cfg.Properties[property].Update(self.Cfg,self.Data,value)
		
		self:Update()
		self:UpdateOtherConnectables()
	end,
	GetProperty = function(self,property)
		return self.Properties[property]
	end,
	IsMovable = function(self)
		return self.Cfg.Move and self.Cfg.Rotate and true or false
	end,
	SetPos = function(self,pos)
		if self:IsMovable() then
			self.Cfg:Move(self.Data,pos)
			self:Update()
			self:UpdateOtherConnectables()
		end
	end,
	GetPos = function(self)
		return self.Cfg:GetPosition(self.Data)
	end,
	SetAngles = function(self,ang)
		if self:IsMovable() then
			self.Cfg:Rotate(self.Data,ang)
			self:Update()
			self:UpdateOtherConnectables()
		end
	end,
	GetAngles = function(self)
		return self.Cfg:GetAngles(self.Data)
	end,
	SetConnectablePos = function(self,id,pos)
		if self:IsConnectableMovable(id) then
			self.Cfg.ConnectablePositions[id].Move(self.Cfg,self.Data,pos)
			self:Update()
			self:UpdateOtherConnectables()
		end
	end,
	GetConnectablePos = function(self,id)
		return self.Cfg.ConnectablePositions[id].GetPosition(self.Cfg,self.Data)
	end,
	SetConnectableAngles = function(self,id,ang)
		if self:IsConnectableMovable(id) then
			self.Cfg.ConnectablePositions[id].Rotate(self.Cfg,self.Data,ang)
			self:Update()
			self:UpdateOtherConnectables()
		end
	end,
	GetConnectableAngles = function(self,id)
		return self.Cfg.ConnectablePositions[id].GetAngles(self.Cfg,self.Data)
	end,
	GetConnectableCount = function(self)
		return self.Cfg.ConnectablePositions and #self.Cfg.ConnectablePositions or 0
	end,
	GetConnectableConnect = function(self,id)
		local dt = self.ConnectedConnectables[id]
		if !dt then return end
		
		return dt.Object,dt.Connectable
	end,
	GetOtherConnections = function(self,id)
		local mobj,mid = self:GetMainConnectable(id)
		local connections = {}

		if mobj!=self or id!=mid then
			connections[#connections+1] = {mobj,mid}
		end

		for k,v in pairs(mobj.OtherConnectedConnectables) do
			for k2,v2 in pairs(v) do
				if v2!=mid or k==self and k2==id then continue end

				connections[#connections+1] = {k,k2}
			end
		end

		return connections
	end,
	IsConnectableMovable = function(self,id)
		return self.Cfg.ConnectablePositions[id].Move and self.Cfg.ConnectablePositions[id].Rotate and true or false
	end,
	IsConnectableForModelChangeOnly = function(self,id)
		return self.Cfg.ConnectablePositions[id].ForModelChangeOnly and true or false
	end,
	GetMainConnectable = function(self,id)
		if !self.ConnectedConnectables[id] then return self,id end
		
		return self.ConnectedConnectables[id].Object,self.ConnectedConnectables[id].Connectable
	end,
	ConnectConnectableTo = function(self,id,obj,id2)
		if !self:IsConnectableMovable(id) then return end
		if !self:IsConnectableConnectingAllowedTo(id,obj,id2) then return end
		
		obj,id2 = obj:GetMainConnectable(id2)
		if obj==self and id2==id then return end
		
		local reconnect
		for k,v in pairs(self.OtherConnectedConnectables) do
			for k2,v2 in pairs(v) do
				if v2!=id then continue end

				reconnect = reconnect or {}
				reconnect[#reconnect+1] = {k,k2}
			end
		end
		
		self:DisconnectConnectable(id)
		self.ConnectedConnectables[id] = {Object = obj,Connectable = id2}
		
		obj.OtherConnectedConnectables[self] = obj.OtherConnectedConnectables[self] or {}
		obj.OtherConnectedConnectables[self][id] = id2
		
		if reconnect then
			for k,v in ipairs(reconnect) do
				v[1]:ConnectConnectableTo(v[2],obj,id2)
			end
		end
		
		self:UpdateConnectable(id)
	end,
	DisconnectConnectable = function(self,id)
		local dt = self.ConnectedConnectables[id]
		
		if dt then
			self.ConnectedConnectables[id] = nil
			dt.Object.OtherConnectedConnectables[self][id] = nil
		else
			local newmain

			for k,v in pairs(self.OtherConnectedConnectables) do
				for k2,v2 in pairs(v) do
					if v2!=id then continue end

					if !newmain then
						k:DisconnectConnectable(k2)
						newmain = {k,k2}
					else
						k:ConnectConnectableTo(k2,newmain[1],newmain[2])
					end
				end
			end
		end
	end,
	DisconnectAllConnectables = function(self,id)
		local obj,id = self:GetMainConnectable(id)
		local disconnected = {}

		for k,v in pairs(obj.OtherConnectedConnectables) do
			for k2,v2 in pairs(v) do
				if v2!=id then continue end

				k:DisconnectConnectable(k2)
				disconnected[#disconnected+1] = {k,k2}
			end
		end

		return disconnected
	end,
	IsConnectableConnectingAllowedTo = function(self,id,obj,id2,noobjcheck)
		if !obj then return false end

		local dt = self.Cfg.ConnectablePositions[id]
		if !dt then return false end

		if self:IsConnectableForModelChangeOnly(id) then return false end

		if obj==self then
			if !dt.CanBeConnectedToSelf then return false end
			if dt.SelfConnectingFilter and !dt.SelfConnectingFilter[id2] then return false end
		end

		if dt.ConnectingFilter and (!dt.ConnectingFilter[obj.Type] or istable(dt.ConnectingFilter[obj.Type]) and !table.HasValue(dt.ConnectingFilter[obj.Type],id2)) then
			return false
		end

		if !noobjcheck and obj.Type!=self.Type and !obj:IsConnectableConnectingAllowedTo(id2,self,id,true) then
			return false
		end

		return true
	end,
	UpdateConnectable = function(self,id)
		local dt = self.ConnectedConnectables[id]

		local dpos = dt.Object:GetConnectablePos(dt.Connectable)
		local dang = dt.Object:GetConnectableAngles(dt.Connectable)

		local posdelta = dpos-self:GetConnectablePos(id)
		local angdelta = dang-self:GetConnectableAngles(id)

		if
			math.abs(posdelta.x)>0.001 or math.abs(posdelta.y)>0.001 or math.abs(posdelta.z)>0.001 or
			math.abs(angdelta.p)>0.01 or math.abs(angdelta.y)>0.01 or math.abs(angdelta.r)>0.01
		then
			self:SetConnectablePos(id,dpos)
			self:SetConnectableAngles(id,dang)
		end
	end,
	UpdateOtherConnectables = function(self)
		for k,v in pairs(self.OtherConnectedConnectables) do
			for k2,v2 in pairs(v) do
				k:UpdateConnectable(k2)
			end
		end
	end,
	UpdateData = function(self,data)
		local upd = false
		local query = {{table = self,key = "Data",old = self.Data,new = data}}

		while #query>0 do
			local cur = table.remove(query,1)

			if istable(cur.old) and istable(cur.new) then
				for k,v in pairs(cur.old) do
					if cur.old==self.Data and k=="NW" then continue end

					query[#query+1] = {table = cur.old,key = k,old = v,new = cur.new[k]}
				end

				for k,v in pairs(cur.new) do
					if cur.old[k]!=nil then continue end

					query[#query+1] = {table = cur.old,key = k,old = nil,new = v}
				end
			elseif cur.old!=cur.new then
				upd = true
				cur.table[cur.key] = cur.new
			end
		end

		if upd then
			self:Update()
			self:UpdateOtherConnectables()
		end

		return upd
	end,
	Update = function(self)
		if CLIENT and IsValid(self.CModel) then
			self.Cfg:UpdateModel(self.Data,self.CModel)
		end

		if SERVER and IsValid(self.Collision) then
			self.Cfg:UpdateCollision(self.Data,self.Collision)
		end
	end,
	Remove = function(self)
		if self:IsValid() then
			self.m_Removed = true
			
			self:Dispose(true)
		end
	end,
	GetTransmitData = function(self)
		local data = {}

		for k,v in pairs(self.Data) do
			if k!="NW" then data[k] = v end
		end

		return {
			Properties = self.Properties,
			Data = data,
		}
	end,
	InitializeNetworkDataTable = function(self,name)
		self.Data.NW = {
			SetVar = function(k,v) return self:SetNWVar(k,v) end,
			GetVar = function(k,def) return self:GetNWVar(k,def) end,
		}
		self.NW = {
			Name = name,
			ID = tonumber(name:sub(2,-1)),
			ToClear = {},
		}

		if self.Cfg.NetworkInitialize then
			self.Cfg:NetworkInitialize(self.Data)
		end
	end,
	SetNWVar = function(self,k,v)
		Trolleybus_System.NetworkSystem.SetHelperVar("ContactNetwork."..math.floor(self.NW.ID/300),self.NW.Name.."|"..k,v)

		self.NW.ToClear[k] = v
	end,
	GetNWVar = function(self,k,def)
		return Trolleybus_System.NetworkSystem.GetHelperVar("ContactNetwork."..math.floor(self.NW.ID/300),self.NW.Name.."|"..k,def)
	end,
	UpdateVisibility = function(self)
		if !self.Cfg.SetupModel then return end

		local frame = FrameNumber()
		if visframe!=frame then
			local eyepos = Trolleybus_System.EyePos()
			local trace = util.TraceLine({start = eyepos,endpos = eyepos,mask = MASK_NPCWORLDSTATIC})

			visframe,vistrace = frame,trace
		end

		if vistrace and !vistrace.StartSolid and self.Cfg.ShouldBeVisible and self.Cfg:ShouldBeVisible(self.Data,Trolleybus_System.EyePos(),Trolleybus_System.GetPlayerSetting("CNObjectsDrawDistance")) then
			if !IsValid(self.CModel) then
				self.CModel = self.Cfg:SetupModel(self.Data)
				self.Cfg:UpdateModel(self.Data,self.CModel)
			end
		elseif IsValid(self.CModel) then
			self.CModel:Remove()
		end
	end,
	UpdateCollision = function(self)
		if !self.Cfg.SetupCollision then return end

		if !IsValid(self.Collision) then
			self.Collision = ents.Create("prop_dynamic")
			self.Cfg:SetupCollision(self.Data,self.Collision)
			self.Collision:PhysicsInit(SOLID_VPHYSICS)
			self.Collision:Spawn()
			self.Collision:SetRenderMode(RENDERMODE_NONE)
			Trolleybus_System.NetworkSystem.SetNWVar(self.Collision,"ContactNetworkObject",true)
		end

		self.Cfg:UpdateCollision(self.Data,self.Collision)
	end,
	IsValid = function(self)
		return !self.m_Removed
	end,
	Dispose = function(self,disposing)
		if CLIENT and IsValid(self.CModel) then
			self.CModel:SetNoDraw(true)
			self.CModel:Remove()
		end

		if SERVER and IsValid(self.Collision) then
			self.Collision:Remove()
		end
		
		for i=1,self:GetConnectableCount() do
			self:DisconnectConnectable(i)
		end

		if self.NW then
			for k,v in pairs(self.NW.ToClear) do
				self:SetNWVar(k,nil)
			end
		end

		if self.Cfg.OnRemove then
			self.Cfg:OnRemove(self.Data)
		end
	end,
	__gc = function(self)
		self:Dispose(false)
	end,
}
CONTACT_NETWORK_OBJECT.__index = CONTACT_NETWORK_OBJECT

local CONTACT_NETWORK_CONTACT_OBJECT = table.Inherit({
	Init = function(self,type,pos,ang)
		self.Type = type
		self.Class = {Id = 0,Name = "Contact"}

		self.BaseClass.Init(self,Trolleybus_System.ContactNetwork.Types.Contacts[type],pos,ang)

		self.contowire = {}
		self.wiretocon = {{},{}}

		for k,v in ipairs(self.Cfg.Wires) do
			if isnumber(v.Start) then
				self.contowire[v.Start] = {k,false}
				self.wiretocon[1][k] = v.Start
			end

			if isnumber(v.End) then
				self.contowire[v.End] = {k,true}
				self.wiretocon[2][k] = v.End
			end
		end
	end,
	GetTransmitData = function(self)
		return table.Merge(self.BaseClass.GetTransmitData(self),{
			Class = self.Class.Id,
			Type = self.Type,
		})
	end,
	GetOtherConnections = function(self,id,onlycontacts,onlymain)
		local connections = self.BaseClass.GetOtherConnections(self,id)

		if onlycontacts or onlymain then
			for i=#connections,1,-1 do
				if onlycontacts and (!connections[i][1].Class or connections[i][1].Class.Id!=0) or onlymain and !connections[i][1]:IsMainContact() then
					table.remove(connections,i)
				end
			end
		end

		return connections
	end,
	IsMainContact = function(self)
		return self.Cfg.MainContact
	end,
	CalculateWheelData = function(self,polepos,polelen,endpos,wire,simplepos)
		local loop = {}

		while !loop[wire] do
			loop[wire] = true

			local data = self.Cfg:CalculateWheelData(self.Data,polepos,polelen,endpos,wire,self:GetWirePos(wire,false),self:GetWirePos(wire,true),simplepos)
			if !isnumber(data) then return data end

			wire = data
		end
	end,
	GetWireByConnectable = function(self,connectable)
		local wdata = self.contowire[connectable]

		if wdata then
			return wdata[1],wdata[2]
		end
	end,
	GetConnectableByWire = function(self,wire,endpos)
		return self.wiretocon[endpos and 2 or 1][wire]
	end,
	GetWiresToUpdateVoltage = function(self,connectable)
		return self.Cfg:GetWiresToUpdateVoltage(connectable)
	end,
	GetNextConnectablesToUpdateVoltage = function(self,connectable)
		return self.Cfg:GetNextConnectablesToUpdateVoltage(connectable)
	end,
	GetWireVoltage = function(self,wire)
		local voltsrc = self:GetWireLinkedVoltageSource(wire)
		local voltage = voltsrc and voltsrc.Cfg.GetVoltage and voltsrc.Cfg:GetVoltage(voltsrc.Data)*(self:GetWirePolarity(wire) and 1 or -1) or 0

		return math.abs(voltage),voltage>=0
	end,
	GetWirePolarity = function(self,wire)
		return self:GetNWVar("polarity"..wire,false)
	end,
	SetWirePolarity = function(self,wire,positive)
		self:SetNWVar("polarity"..wire,positive and true or false)
	end,
	GetWireLinkedVoltageSource = function(self,wire)
		local voltsrcid = self:GetNWVar("voltsrc"..wire)
		return voltsrcid and Trolleybus_System.ContactNetwork.GetObject(voltsrcid)
	end,
	LinkWireToVoltageSource = function(self,wire,voltsrc)
		self:SetNWVar("voltsrc"..wire,voltsrc and Trolleybus_System.ContactNetwork.GetObjectName(voltsrc) or nil)
	end,
	GetWirePos = function(self,wire,endpos)
		local pos = self.Cfg.Wires[wire][endpos and "End" or "Start"]
		local loc = true

		if pos==true then
			pos,loc = self.Cfg:GetWirePos(self.Data,wire,endpos)
		elseif isfunction(pos) then
			pos,loc = pos(self.Cfg,self.Data)
		elseif isnumber(pos) then
			pos,loc = self:GetConnectablePos(pos),false
		end
		
		if loc then pos = LocalToWorld(pos,angle_zero,self:GetPos(),self:GetAngles()) end
		return pos
	end,
	GetWiresCount = function(self)
		return #self.Cfg.Wires
	end,
	AmperageUpdate = function(self,wire,amperage)
		if self.Cfg.AmperageUpdate then
			self.Cfg:AmperageUpdate(self.Data,wire,amperage)
		end
	end,
	OnWheelChangedContactFrom = function(self,bus,pos,wire)
		if self.Cfg.OnWheelChangedContactFrom then
			self.Cfg:OnWheelChangedContactFrom(self.Data,bus,pos,wire)
		end
	end,
	OnWheelChangedContactTo = function(self,bus,pos,wire)
		if self.Cfg.OnWheelChangedContactTo then
			self.Cfg:OnWheelChangedContactTo(self.Data,bus,pos,wire)
		end
	end,
	OnWheelChangedWire = function(self,bus,oldpos,pos,oldwire,wire)
		if self.Cfg.OnWheelChangedWire then
			self.Cfg:OnWheelChangedWire(self.Data,bus,oldpos,pos,oldwire,wire)
		end
	end,
	OnWheelLeave = function(self,bus,wire)
		if self.Cfg.OnWheelLeave then
			self.Cfg:OnWheelLeave(self.Data,bus,wire)
		end
	end,
	OnWheelEntered = function(self,bus,pos,wire)
		if self.Cfg.OnWheelLeave then
			self.Cfg:OnWheelLeave(self.Data,bus,pos,wire)
		end
	end,
	AllowElectricArcsOnWire = function(self,wire)
		return self.Cfg.AllowElectricArcsOnWire and self.Cfg:AllowElectricArcsOnWire(self.Data,wire) or false
	end,
	GetChanceToFlyOffPole = function(self,bus,oldwire,wire,speed)
		return self.Cfg.GetChanceToFlyOffPole and self.Cfg:GetChanceToFlyOffPole(self.Data,bus,oldwire,wire,speed)
	end,
	GetWheelSlidingSound = function(self,wire)
		return self.Cfg.GetWheelSlidingSound and self.Cfg:GetWheelSlidingSound(self.Data,wire) or "trolleybus/contactnetwork/wheel_sliding.ogg"
	end,
},CONTACT_NETWORK_OBJECT)
CONTACT_NETWORK_CONTACT_OBJECT.__index = CONTACT_NETWORK_CONTACT_OBJECT

local CONTACT_NETWORK_SUSPENSIONANDOTHER_OBJECT = table.Inherit({
	Init = function(self,type,pos,ang)
		self.Type = type
		self.Class = {Id = 1,Name = "Suspension/Other"}
		self.BaseClass.Init(self,Trolleybus_System.ContactNetwork.Types.SuspensionAndOther[type],pos,ang)
	end,
	GetTransmitData = function(self)
		return table.Merge(self.BaseClass.GetTransmitData(self),{
			Class = self.Class.Id,
			Type = self.Type,
		})
	end,
},CONTACT_NETWORK_OBJECT)
CONTACT_NETWORK_SUSPENSIONANDOTHER_OBJECT.__index = CONTACT_NETWORK_SUSPENSIONANDOTHER_OBJECT

function Trolleybus_System.ContactNetwork.CreateContact(type,pos,ang)
	if !Trolleybus_System.ContactNetwork.Types.Contacts[type] then return end

	local obj = setmetatable({},CONTACT_NETWORK_CONTACT_OBJECT)
	obj:Init(type,pos,ang)
	
	return obj
end

function Trolleybus_System.ContactNetwork.CreateSuspensionAndOther(type,pos,ang)
	if !Trolleybus_System.ContactNetwork.Types.SuspensionAndOther[type] then return end

	local obj = setmetatable({},CONTACT_NETWORK_SUSPENSIONANDOTHER_OBJECT)
	obj:Init(type,pos,ang)
	
	return obj
end

function Trolleybus_System.ContactNetwork.CreateFromTransmitData(data)
	local object
	
	if data.Class==0 then
		object = Trolleybus_System.ContactNetwork.CreateContact(data.Type,Vector(),Angle())
	elseif data.Class==1 then
		object = Trolleybus_System.ContactNetwork.CreateSuspensionAndOther(data.Type,Vector(),Angle())
	end

	if !object then return end
	
	for k,v in pairs(data.Properties) do
		object:SetProperty(k,v)
	end
	
	object:UpdateData(data.Data)
	
	return object
end

function Trolleybus_System.ContactNetwork.AddObject(name,data)
	Trolleybus_System.ContactNetwork.RemoveObject(name)

	local object = Trolleybus_System.ContactNetwork.CreateFromTransmitData(data)
	if !object then return end

	Trolleybus_System.ContactNetwork.Objects[data.Class==0 and "Contacts" or data.Class==1 and "SuspensionAndOther"][name] = object
	object:InitializeNetworkDataTable(name)

	return object
end

function Trolleybus_System.ContactNetwork.NewObject(class,type,pos,ang)
	local obj,prefix,objtype
	if class==0 then
		obj,prefix,objtype = Trolleybus_System.ContactNetwork.CreateContact(type,pos,ang),"c","Contacts"
	elseif class==1 then
		obj,prefix,objtype = Trolleybus_System.ContactNetwork.CreateSuspensionAndOther(type,pos,ang),"s","SuspensionAndOther"
	end

	if !obj then return end

	local id = 1
	while IsValid(Trolleybus_System.ContactNetwork.GetObject(prefix..id)) do
		id = id+1
	end

	local name = prefix..id
	Trolleybus_System.ContactNetwork.Objects[objtype][name] = obj

	obj:InitializeNetworkDataTable(name)

	return obj,name
end

function Trolleybus_System.ContactNetwork.RemoveObject(name)
	local objects = Trolleybus_System.ContactNetwork.Objects

	if IsValid(objects.Contacts[name]) then
		objects.Contacts[name]:Remove()
		objects.Contacts[name] = nil
	end

	if IsValid(objects.SuspensionAndOther[name]) then
		objects.SuspensionAndOther[name]:Remove()
		objects.SuspensionAndOther[name] = nil
	end
end

function Trolleybus_System.ContactNetwork.GetObject(name)
	local objects = Trolleybus_System.ContactNetwork.Objects

	return IsValid(objects.Contacts[name]) and objects.Contacts[name] or IsValid(objects.SuspensionAndOther[name]) and objects.SuspensionAndOther[name]
end

function Trolleybus_System.ContactNetwork.GetObjectData(name)
	local object = Trolleybus_System.ContactNetwork.GetObject(name)
	local data = object:GetTransmitData()
	data.Connections = {}

	for i=1,object:GetConnectableCount() do
		local obj,id = object:GetConnectableConnect(i)

		if obj then
			data.Connections[i] = {Trolleybus_System.ContactNetwork.GetObjectName(obj),id}
		end
	end

	return data
end

function Trolleybus_System.ContactNetwork.GetObjectName(object)
	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
		if v==object then return k end
	end

	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.SuspensionAndOther) do
		if v==object then return k end
	end
end

function Trolleybus_System.ContactNetwork.ApplyObjectChanges(name,data)
	local object = Trolleybus_System.ContactNetwork.GetObject(name)
	local updated = false

	for k,v in pairs(data.Properties) do
		if object:GetProperty(k)!=v then object:SetProperty(k,v) updated = true end
	end

	for i=1,object:GetConnectableCount() do
		local obj,id = object:GetConnectableConnect(i)
		local con = data.Connections[i]

		if obj and !con then
			object:DisconnectConnectable(i)
			obj,id = object:GetConnectableConnect(i)

			updated = true
		end

		if con and (!obj or con[2]!=id or Trolleybus_System.ContactNetwork.GetObject(con[1])!=obj) then
			object:ConnectConnectableTo(i,Trolleybus_System.ContactNetwork.GetObject(con[1]),con[2])
			obj,id = object:GetConnectableConnect(i)

			updated = true
		end
	end

	if object:UpdateData(data.Data) then
		updated = true
	end

	return updated
end

function Trolleybus_System.ContactNetwork.ClearObjects()
	local objects = Trolleybus_System.ContactNetwork.Objects

	for k,v in pairs(objects.Contacts) do
		v:Remove()
		objects.Contacts[k] = nil
	end

	for k,v in pairs(objects.SuspensionAndOther) do
		v:Remove()
		objects.SuspensionAndOther[k] = nil
	end
end

local loop
function Trolleybus_System.ContactNetwork.GetCurrentContactWire(polepos,polelen,contact,wire,endpos)
	local object = istable(contact) and contact or Trolleybus_System.ContactNetwork.GetObject(contact)
	if !object or object.Class.Id!=0 then return end

	local data = object:CalculateWheelData(polepos,polelen,endpos,wire,false)
	if !data then return end

	if data.error==1 then
		local connectable = object:GetConnectableByWire(data.wire,data.endpos)
		local connection = object:GetOtherConnections(connectable,true,true)[1]

		if !connection then return end

		local nobj,nid = connection[1],connection[2]

		local lop = loop
		if !lop then loop = {[object] = {[connectable] = true}} end

		local dt

		if !loop[nobj] or !loop[nobj][nid] then
			loop[nobj] = loop[nobj] or {}
			loop[nobj][nid] = true

			local nwire,nendpos = nobj:GetWireByConnectable(nid)
			if nendpos==data.endpos then endpos = !endpos end

			dt = Trolleybus_System.ContactNetwork.GetCurrentContactWire(polepos,polelen,nobj,nwire,endpos)
		end

		if !lop then loop = nil end

		return dt
	end

	if !data.error then
		if istable(contact) then
			contact = Trolleybus_System.ContactNetwork.GetObjectName(contact)

			if !contact then return end
		end

		return {Contact = contact,Wire = data.wire,Pos = data.pos,Ang = data.ang,EndPos = endpos}
	end
end

function Trolleybus_System.ContactNetwork.GetNearestContactWire(polepos,polelen,wheelpos)
	local contact,wire,pos,ang,endpos,dist
	local maxdist = 15^2

	for k,v in pairs(Trolleybus_System.ContactNetwork.Objects.Contacts) do
		if !v:IsMainContact() then continue end

		for i=1,v:GetWiresCount() do
			for j=1,2 do
				local data = v:CalculateWheelData(polepos,polelen,j==2,i,true)

				if data and !data.error then
					local dst = wheelpos:DistToSqr(data.pos)

					debugoverlay.Axis(data.pos,data.ang,10,0.5)

					if dst<maxdist and (!dist or dst<dist) then
						contact,wire,pos,ang,endpos,dist = k,i,data.pos,data.ang,j==2,dst
					end
				end
			end
		end
	end

	return contact and {Contact = contact,Wire = wire,Pos = pos,Ang = ang,EndPos = endpos}
end

function Trolleybus_System.ContactNetwork.GetContactWireVoltage(contact,wire)
	local object = Trolleybus_System.ContactNetwork.GetObject(contact)
	if !object then return end

	return object:GetWireVoltage(wire)
end

function Trolleybus_System.ContactNetwork.GetVoltage()
	return Trolleybus_System.NetworkSystem.GetNWVar(game.GetWorld(),"ContactNetworkVoltage",0)
end

function Trolleybus_System:TrolleybusSystem_ContactNetwork_AllowToggleVoltageSources(ply)
	return ply:IsAdmin()
end

hook.Add("PhysgunPickup","Trolleybus_System.ContactNetworkObjects",function(ply,ent)
	if Trolleybus_System.NetworkSystem.GetNWVar(ent,"ContactNetworkObject",false) then
		return false
	end
end)

hook.Add("CanProperty","Trolleybus_System.ContactNetworkObjects",function(ply,property,ent)
	if Trolleybus_System.NetworkSystem.GetNWVar(ent,"ContactNetworkObject",false) then
		return false
	end
end)

hook.Add("CanTool","Trolleybus_System.ContactNetworkObjects",function(ply,tr,toolname,tool,button)
	if IsValid(tr.Entity) and Trolleybus_System.NetworkSystem.GetNWVar(tr.Entity,"ContactNetworkObject",false) and toolname!="trolleytrafficlighteditor" then
		return false
	end
end)