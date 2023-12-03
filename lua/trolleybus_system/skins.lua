-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.TrolleybusUserSkinsFonts = Trolleybus_System.TrolleybusUserSkinsFonts or {}

function Trolleybus_System.AddTrolleybusSkin(troll,group,name,textures,preview,bortnums)
	Trolleybus_System.TrolleybusSkins[troll] = Trolleybus_System.TrolleybusSkins[troll] or {}
	Trolleybus_System.TrolleybusSkins[troll][group] = Trolleybus_System.TrolleybusSkins[troll][group] or {skins = {},seq = {}}
	
	local groupdata = Trolleybus_System.TrolleybusSkins[troll][group]
	local index = table.IsEmpty(textures) and "default" or name
	
	if !groupdata.skins[index] then
		table.insert(groupdata.seq,index=="default" and 1 or #groupdata.seq+1,index)
	end
	
	groupdata.skins[index] = {
		name = name,
		textures = textures,
		preview = preview,
		bortnums = bortnums,
	}
end

function Trolleybus_System.BuildSkinSpawnSetting(troll,name)
	if !Trolleybus_System.TrolleybusSkins then
		Trolleybus_System.TrolleybusSkins = {}
		Trolleybus_System.RunEvent("AddTrolleybusSkins",Trolleybus_System.AddTrolleybusSkin)
		Trolleybus_System.RunEvent("AddTrolleybusSkinsG017",Trolleybus_System.AddTrolleybusSkin)
	end
	
	local function ChangeTextures(self,ent,skins)
		if !skins then
			ent:SetSubMaterial()
			
			return
		end

		local trolldata = Trolleybus_System.TrolleybusSkins[troll]
		if trolldata then
			for group,groupdata in pairs(trolldata) do
				if !skins[group] then
					skins[group] = groupdata.skins.default and "default" or groupdata.seq[1]
				end
			end
		end
		
		for group,skin in pairs(skins) do
			local groupdata = trolldata and trolldata[group]
			local skindata = groupdata and groupdata.skins[skin]
			if !skindata then continue end
			
			if !ent.m_matids then
				ent.m_matids = {}
			
				for k,v in ipairs(ent:GetMaterials()) do
					ent.m_matids[v] = k-1
				end
			end

			local bortnums = skindata.bortnums
			local textures = skindata.textures

			if bortnums then
				textures = table.Copy(skindata.textures)
				for k,v in pairs(bortnums) do textures[k] = textures[k] or k end
			end
			
			for k,v in pairs(textures) do
				local texid = ent.m_matids[k]
				if !texid then continue end

				local borttex = CLIENT and bortnums and bortnums[k] and Trolleybus_System.GetPlayerSetting("EnableBortNumbers") and Trolleybus_System.GetTrolleybusBortNumberSkinTexture(self,troll,group,skin,k,v) or v
				
				local curtex = ent:GetSubMaterial(texid)
				if curtex=="" then curtex = k end
				
				if CLIENT and self==ent or curtex!=borttex then
					ent:SetSubMaterial(texid,borttex)
				end
			end
		end
	end
	
	local function SetupSkins(self,value)
		local skins

		if value then
			skins = {}

			for _,group in pairs(string.Explode("&",value)) do
				local kv = string.Explode("=",group)
				skins[kv[1]] = kv[2]
			end
		end

		if SERVER then
			ChangeTextures(self,self,skins)
			
			return
		end
		
		self.SkinsToUpdate[troll] = {function(svmdlupd)
			if svmdlupd then
				ChangeTextures(self,self,skins)
				
				return
			end
			
			if !self.RenderClientEnts then return end
			
			if self.PolesData then
				ChangeTextures(self,self.PolesData.Left.TrolleyPole,skins)
				ChangeTextures(self,self.PolesData.Left.TrolleyWheel,skins)
				ChangeTextures(self,self.PolesData.Right.TrolleyPole,skins)
				ChangeTextures(self,self.PolesData.Right.TrolleyWheel,skins)
			end
			
			for k,v in ipairs(self.ClientEntsDistanceControl) do
				if v.m_ent then
					ChangeTextures(self,v.m_ent,skins)
				end
			end
			
			if !self.IsTrailer then
				ChangeTextures(self,self.Steer,skins)
			end
			
			for k,v in pairs(self.Doors) do
				ChangeTextures(self,v,skins)
			end
			
			if self.TrailerData then
				ChangeTextures(self,self.Joint,skins)
			end
			
			for k,v in pairs(self.CustomClientEnts) do
				ChangeTextures(self,v,skins)
			end
		end,function(ent) ChangeTextures(self,ent,skins) end}
	end
	
	local setting = {
		alias = "skins."..troll,
		name = name,
		type = "Skin",
		skintype = troll,
		default = "",
		setup = function(self,value)
			SetupSkins(self,value)
		end,
		unload = function(self,value)
			SetupSkins(self)
			
			if CLIENT then
				self:UpdateSkins()
				
				self.SkinsToUpdate[troll] = nil
			end
		end,
	}
	
	return setting
end

function Trolleybus_System.GetTrolleybusBortNumberSkinTexture(self,troll,group,skin,deftexpath,texpath)
	local trolldata = Trolleybus_System.TrolleybusSkins[troll]
	local groupdata = trolldata and trolldata[group]
	local skindata = groupdata and groupdata.skins[skin]

	if !skindata then return end
	
	local bortnums = skindata.bortnums
	if !bortnums or !bortnums[deftexpath] then return end
	
	local bus = self:GetMainTrolleybus()
	if !IsValid(bus) then return end
	
	local bortnum = bus:GetBortNumber()
	local texname = troll:gsub("[^%w_]","").."_"..group:gsub("[^%w_]","").."_"..skin:gsub("[^%w_]","").."_"..deftexpath:gsub("[^%w_]","").."_"..bortnum
	
	if !skindata.bortnummats or !skindata.bortnummats[deftexpath] or !skindata.bortnummats[deftexpath][bortnum] then
		skindata.bortnummats = skindata.bortnummats or {}
		skindata.bortnummats[deftexpath] = skindata.bortnummats[deftexpath] or {}
		
		local defmat = Material(texpath)
		local deftex = defmat:GetTexture("$basetexture")
		if !deftex then return end
		
		local w,h = deftex:GetMappingWidth(),deftex:GetMappingHeight()
		local borttex = GetRenderTarget(texname..".vtf",w,h)
		
		local utilmat = Trolleybus_System.TrolleybusBortNumberSkinUtilTexture
		if !utilmat then
			utilmat = CreateMaterial("TrolleybusBortNumberSkinUtilTexture","UnlitGeneric",{["$basetexture"] = deftex:GetName()})
			
			Trolleybus_System.TrolleybusBortNumberSkinUtilTexture = utilmat
		end
		
		local mat = CreateMaterial(texname,defmat:GetShader(),{["$basetexture"] = deftex:GetName()})
		
		local typefuncs = {[TYPE_NUMBER] = "Float",[TYPE_MATRIX] = "Matrix",[TYPE_STRING] = "String",[TYPE_TEXTURE] = "Texture",[TYPE_VECTOR] = "Vector"}
		for k,v in pairs(defmat:GetKeyValues()) do
			mat["Set"..typefuncs[TypeID(v)]](mat,k,k=="$basetexture" and borttex or v)
		end
		
		render.PushRenderTarget(borttex)
			cam.Start2D()
				local prev = DisableClipping(true)
		
				render.Clear(0,0,0,0,true)
			
				utilmat:SetTexture("$basetexture",deftex)
				
				render.PushFilterMin(TEXFILTER.LINEAR)
				render.PushFilterMag(TEXFILTER.LINEAR)
				
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(utilmat)
				surface.DrawTexturedRect(0,0,w,h)
				
				render.PopFilterMin()
				render.PopFilterMag()
				
				for k,v in ipairs(bortnums[deftexpath]) do
					surface.SetFont("Trolleybus_System.Skins.ziu62053")
					local tw,th = surface.GetTextSize(bortnum)
					
					local m = Matrix()
					m:SetTranslation(Vector(v.x,v.y))
					m:SetAngles(Angle(0,v.rotate,0))
					m:SetScale(Vector(v.scalex or 1,v.scaley or 1,1))
					
					render.PushFilterMin(TEXFILTER.ANISOTROPIC)
					render.PushFilterMag(TEXFILTER.ANISOTROPIC)
					
					cam.PushModelMatrix(m)
					
						if v.bounds then
							render.SetStencilEnable(true)
							render.ClearStencil()
							
							render.SetStencilReferenceValue(1)
							render.SetStencilWriteMask(0xFF)
							render.SetStencilTestMask(0xFF)
							
							render.SetStencilCompareFunction(STENCIL_ALWAYS)
							render.SetStencilPassOperation(STENCIL_REPLACE)
							render.SetStencilFailOperation(STENCIL_KEEP)
							render.SetStencilZFailOperation(STENCIL_KEEP)
							
							surface.SetDrawColor(0,0,0,1)
							surface.DrawRect(v.bounds[1],v.bounds[2],v.bounds[3],v.bounds[4])
							
							render.SetStencilCompareFunction(STENCIL_EQUAL)
							render.SetStencilPassOperation(STENCIL_KEEP)
						end
					
						draw.SimpleText(bortnum,v.font,0,0,v.color,v.alignx,v.aligny)
						
						if v.bounds then
							render.SetStencilEnable(false)
						end
						
					cam.PopModelMatrix()
					
					render.PopFilterMin()
					render.PopFilterMag()
				end
		
				DisableClipping(prev)
			cam.End2D()
		render.PopRenderTarget()
		
		skindata.bortnummats[deftexpath][bortnum] = mat
	end
	
	return "!"..texname
end

if CLIENT then
	concommand.Add("trolleybus_flushbortskins",function(ply,cmd,args,str)
		if !Trolleybus_System.TrolleybusSkins then return end
		
		for troll,trolldata in pairs(Trolleybus_System.TrolleybusSkins) do
			for group,groupdata in pairs(trolldata) do
				for skin,skindata in pairs(groupdata.skins) do
					skindata.bortnummats = nil
				end
			end
		end
		
		for k,v in ipairs(ents.FindByClass("trolleybus_ent_*")) do
			v:UpdateSkins()
		end
	end)
end

function Trolleybus_System:TrolleybusSystem_AddTrolleybusSkins(addskin)
	if CLIENT then
		surface.CreateFont("Trolleybus_System.Skins.ziu682v013",{font = "Agency FB Cyrillic",size = 60,extended = true,weight = 600})
		
		surface.CreateFont("Trolleybus_System.Skins.aksm321n",{font = "Bahnschrift SemiBold",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm321n2",{font = "Moscow Sans Regular",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm321n3",{font = "Arial",size = 60,extended = true,weight = 600})
		surface.CreateFont("Trolleybus_System.Skins.aksm321n4",{font = "Impact",size = 60,extended = true,weight = 500})
		
		surface.CreateFont("Trolleybus_System.Skins.aksm101ps",{font = "Depot_Gomel Depot_Gomel",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm101ps2",{font = "Depot_Cheboksary",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm101ps3",{font = "Arial",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm101ps4",{font = "Bahnschrift Light Condensed",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm101ps5",{font = "Sallenas Grandes",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm101ps6",{font = "Moscow_16ap_Numbers",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.aksm101ps7",{font = "Stencil",size = 60,extended = true,weight = 500})
		
		surface.CreateFont("Trolleybus_System.Skins.ziu6205",{font = "SPB_tbus",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.ziu62052",{font = "Bahnschrift SemiBold",size = 60,extended = true,weight = 600})
		surface.CreateFont("Trolleybus_System.Skins.ziu62053",{font = "Moscow_6tp",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.ziu62054",{font = "Agency FB",size = 60,extended = true,weight = 500})

		surface.CreateFont("Trolleybus_System.Skins.trolza5265",{font = "Arial Narrow",size = 60,extended = true,weight = 600})
		surface.CreateFont("Trolleybus_System.Skins.trolza52652",{font = "Verdana",size = 60,extended = true,weight = 600})
	end

	addskin("ziu682v013","trolleybus.ziu682v013.skins.bodyint","trolleybus.ziu682v013.skins.bodyint.default",{
	},"trolleybus/spawnsettings_previews/ziu682v013/skin_bodyint_default.png",{
		["models/trolleybus/ziu682v/body"] = {
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3708,y = 3756,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1420,y = 3696,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1500,y = 2792,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3520,y = 2804,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.default",{
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_default.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps",x = 1670,y = 1830,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(0,0,0),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps",x = 1670,y = 1376,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(0,0,0),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps",x = 1291,y = 1287,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
			{font = "Trolleybus_System.Skins.aksm101ps",x = 366,y = 1718,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
	})
	
	addskin("ziu6205","trolleybus.ziu6205.skins.body","trolleybus.ziu6205.skins.body.default",{
	},"trolleybus/spawnsettings_previews/ziu6205/skin_body_default.png",{
		["models/trolleybus/ziu6205/body"] = {
			{font = "Trolleybus_System.Skins.ziu6205",x = 3667,y = 3800,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255)},
			{font = "Trolleybus_System.Skins.ziu6205",x = 3654,y = 3124,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu6205",x = 1129,y = 3112,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu6205",x = 2051,y = 3808,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
		},
		["models/trolleybus/ziu6205/interior_body"] = {
			{font = "Trolleybus_System.Skins.ziu6205",x = 3500,y = 1400,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		},
	})
	
	addskin("aksm333","trolleybus.aksm333.skins.body","trolleybus.aksm333.skins.body.default",{
	},"trolleybus/spawnsettings_previews/aksm333/skin_body_default.png",{
		["models/trolleybus/aksm333/syabar"] = {
			{font = "Trolleybus_System.Skins.ziu62054",x = 1315,y = 1882,scalex = 0.9,scaley = 1,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62054",x = 1148,y = 1364,scalex = 0.7,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62054",x = 595,y = 880,scalex = 0.7,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})
	
	addskin("aksm333","trolleybus.aksm333.skins.handrails","trolleybus.aksm333.skins.handrails.default",{
	},"trolleybus/spawnsettings_previews/aksm333/skin_handrails_default.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.default",{
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_default.png",{
		["models/trolleybus/aksm321/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1144,y = 1852,scalex = 0.6,scaley = 0.7,rotate = 0,color = Color(0,0,0)},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1620,y = 1794,scalex = 0.6,scaley = 0.7,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1187,y = 1762,scalex = 0.6,scaley = 0.7,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})
	
	addskin("aksm321","trolleybus.aksm321.skins.handrails","trolleybus.aksm321.skins.handrails.default",{
	},"trolleybus/spawnsettings_previews/aksm321/skin_handrails_default.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.body","trolleybus.aksm333o.skins.body.default",{
	},"trolleybus/spawnsettings_previews/aksm333o/skin_body_default.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.handrails","trolleybus.aksm333o.skins.handrails.default",{
	},"trolleybus/spawnsettings_previews/aksm333o/skin_handrails_default.png")
	
	addskin("aksm321n","trolleybus.aksm321n.skins.body","trolleybus.aksm321n.skins.body.default",{
	},"trolleybus/spawnsettings_previews/aksm321n/skin_body_default.png",{
		["models/trolleybus/aksm321n/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n4",x = 1150,y = 1855,scalex = 1,scaley = 0.8,rotate = 0,color = Color(154,25,29)},
			{font = "Trolleybus_System.Skins.aksm321n4",x = 1655,y = 1812,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(154,25,29),alignx = 1,aligny = 1},
		},
	})
	
	addskin("aksm321n","trolleybus.aksm321n.skins.handrails","trolleybus.aksm321n.skins.handrails.default",{
	},"trolleybus/spawnsettings_previews/aksm321n/skin_handrails_default.png")

	addskin("trolza5265","trolleybus.trolza5265.skins.body","trolleybus.trolza5265.skins.body.default",{
	},"trolleybus/spawnsettings_previews/trolza5265/skin_body_default.png",{
		["models/trolleybus/trolza5265/body"] = {
			{font = "Trolleybus_System.Skins.ziu62053",x = 1302,y = 1248,scalex = 1,scaley = 1,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 1632,y = 2052,scalex = 1,scaley = 1,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 3686,y = 1192,scalex = 1.2,scaley = 1.2,rotate = 0,color = color_black,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 3443,y = 1760,scalex = 1.3,scaley = 1.3,rotate = 0,color = color_black,alignx = 1,aligny = 1},
		},
	})

	addskin("ziu682v013","trolleybus.ziu682v013.skins.bodyint","trolleybus.ziu682v013.skins.bodyint.2274",{
		["models/trolleybus/ziu682v/body"] = "models/trolleybus/ziu682v/skins/body_interior/2274/body",
		["models/trolleybus/ziu682v/interior"] = "models/trolleybus/ziu682v/skins/body_interior/2274/interior",
		["models/trolleybus/ziu682v/color_palette"] = "models/trolleybus/ziu682v/skins/body_interior/2274/color_palette",
		["models/trolleybus/ziu682v/moldings"] = "models/trolleybus/ziu682v/skins/body_interior/2274/moldings",
		["models/trolleybus/ziu682v/stuff2"] = "models/trolleybus/ziu682v/skins/body_interior/2274/stuff2",
	},"trolleybus/spawnsettings_previews/ziu682v013/skin_bodyint_2274.png",{
		["models/trolleybus/ziu682v/body"] = {
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3708,y = 3756,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(184,153,2),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1420,y = 3696,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(184,153,2),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1500,y = 2792,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(184,153,2),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3520,y = 2804,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(184,153,2),alignx = 1,aligny = 1},
		},
	})
	
	addskin("ziu682v013","trolleybus.ziu682v013.skins.bodyint","trolleybus.ziu682v013.skins.bodyint.274",{
		["models/trolleybus/ziu682v/body"] = "models/trolleybus/ziu682v/skins/body_interior/274/body",
	},"trolleybus/spawnsettings_previews/ziu682v013/skin_bodyint_274.png",{
		["models/trolleybus/ziu682v/body"] = {
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3708,y = 3756,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1420,y = 3696,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1500,y = 2792,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3520,y = 2804,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		},
	})
	
	addskin("ziu682v013","trolleybus.ziu682v013.skins.bodyint","trolleybus.ziu682v013.skins.bodyint.blue_darkblue",{
		["models/trolleybus/ziu682v/body"] = "models/trolleybus/ziu682v/skins/body_interior/blue_darkblue/body",
		["models/trolleybus/ziu682v/interior"] = "models/trolleybus/ziu682v/skins/body_interior/blue_darkblue/interior",
	},"trolleybus/spawnsettings_previews/ziu682v013/skin_bodyint_blue_darkblue.png",{
		["models/trolleybus/ziu682v/body"] = {
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3708,y = 3756,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1420,y = 3696,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1500,y = 2792,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3520,y = 2804,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
		},
	})
	
	addskin("ziu682v013","trolleybus.ziu682v013.skins.bodyint","trolleybus.ziu682v013.skins.bodyint.ohra",{
		["models/trolleybus/ziu682v/body"] = "models/trolleybus/ziu682v/skins/body_interior/ohra/body",
		["models/trolleybus/ziu682v/interior"] = "models/trolleybus/ziu682v/skins/body_interior/ohra/interior",
	},"trolleybus/spawnsettings_previews/ziu682v013/skin_bodyint_ohra.png",{
		["models/trolleybus/ziu682v/body"] = {
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3708,y = 3756,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1420,y = 3696,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1500,y = 2792,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3520,y = 2804,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		},
	})
	
	addskin("ziu682v013","trolleybus.ziu682v013.skins.bodyint","trolleybus.ziu682v013.skins.bodyint.1152",{
		["models/trolleybus/ziu682v/body"] = "models/trolleybus/ziu682v/skins/body_interior/1152/body",
		["models/trolleybus/ziu682v/color_palette"] = "models/trolleybus/ziu682v/skins/body_interior/1152/color_palette",
		["models/trolleybus/ziu682v/stuff2"] = "models/trolleybus/ziu682v/skins/body_interior/1152/stuff2",
	},"trolleybus/spawnsettings_previews/ziu682v013/skin_bodyint_1152.png",{
		["models/trolleybus/ziu682v/body"] = {
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3708,y = 3756,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1420,y = 3696,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1500,y = 2792,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3520,y = 2804,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
		},
	})
	
	addskin("ziu682v013","trolleybus.ziu682v013.skins.bodyint","trolleybus.ziu682v013.skins.bodyint.moscow_yellow_blue",{
		["models/trolleybus/ziu682v/body"] = "models/trolleybus/ziu682v/skins/body_interior/moscow_yellow_blue/body",
	},"trolleybus/spawnsettings_previews/ziu682v013/skin_bodyint_moscow_yellow_blue.png",{
		["models/trolleybus/ziu682v/body"] = {
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3708,y = 3756,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1420,y = 3730,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,84,126),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 1500,y = 2820,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,84,126),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682v013",x = 3520,y = 2825,scalex = 1.23,scaley = 1.5,rotate = 0,color = Color(0,84,126),alignx = 1,aligny = 1},
		},
	})

	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.cheboksary",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/cheboksary/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/cheboksary/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_cheboksary.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps2",x = 1665,y = 1832,scalex = 0.65,scaley = 0.65,rotate = 0,color = Color(255,255,255),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps2",x = 1886,y = 1435,scalex = 0.65,scaley = 0.65,rotate = 0,color = Color(255,255,255),aligny = 1,alignx = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps2",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.grodno",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/grodno/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/grodno/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_grodno.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps3",x = 1665,y = 1832,scalex = 0.5,scaley = 0.7,rotate = 0,color = Color(0,0,0),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps3",x = 1700,y = 1358,scalex = 0.4,scaley = 0.6,rotate = 0,color = Color(255,255,255),alignx = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps3",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.minsk_2td",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/minsk_2td/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/minsk_2td/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_minsk_2td.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps5",x = 1670,y = 1829,scalex = 0.9,scaley = 0.9,rotate = 0,color = Color(0,0,0),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps5",x = 1710,y = 1420,scalex = 0.9,scaley = 0.9,rotate = 0,color = Color(0,0,0),aligny = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps2",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(255,255,255),aligny = 1,alignx = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.minsk_3td",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/minsk_3td/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/minsk_3td/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_minsk_3td.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps3",x = 1665,y = 1825,scalex = 0.5,scaley = 0.6,rotate = 0,color = Color(0,0,0),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps3",x = 1720,y = 1355,scalex = 0.5,scaley = 0.6,rotate = 0,color = Color(0,0,0),alignx = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps3",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(255,255,255),aligny = 1,alignx = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.minsk_5td",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/minsk_5td/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/minsk_5td/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_minsk_5td.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps4",x = 1665,y = 1829,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps4",x = 1710,y = 1420,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),aligny = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps4",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.moscow_7841",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/moscow_7841/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/moscow_7841/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_moscow_7841.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps6",x = 1824,y = 1875,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(255,255,255),aligny = 1,alignx = 1},
			{font = "Trolleybus_System.Skins.aksm101ps6",x = 1710,y = 1430,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(255,255,255),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps6",x = 736,y = 1425,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(255,255,255),aligny = 1,alignx = 1},
			{font = "Trolleybus_System.Skins.aksm101ps6",x = 736,y = 1850,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(255,255,255),aligny = 1,alignx = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps2",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.murmansk",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/murmansk/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/murmansk/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_murmansk.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps7",x = 1995,y = 1800,scalex = 0.7,scaley = 0.7,rotate = 0,color = Color(154,25,29),alignx = 2},
			{font = "Trolleybus_System.Skins.aksm101ps7",x = 1665,y = 1350,scalex = 0.7,scaley = 0.7,rotate = 0,color = Color(154,25,29)},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps2",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
	})
	
	addskin("aksm101ps","trolleybus.aksm101ps.skins.bodyint","trolleybus.aksm101ps.skins.bodyint.vitebsk",{
		["models/trolleybus/aksm101ps/body"] = "models/trolleybus/aksm101ps/skins/bodyint/vitebsk/body",
		["models/trolleybus/aksm101ps/interior"] = "models/trolleybus/aksm101ps/skins/bodyint/vitebsk/interior",
	},"trolleybus/spawnsettings_previews/aksm101ps/skin_bodyint_vitebsk.png",{
		["models/trolleybus/aksm101ps/body"] = {
			{font = "Trolleybus_System.Skins.aksm101ps",x = 1665,y = 1832,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(154,25,29),aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps",x = 1665,y = 1360,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(124,25,29)},
			{font = "Trolleybus_System.Skins.aksm101ps",x = 617,y = 1848,scalex = 0.6,scaley = 0.6,rotate = 0,color = Color(154,25,29),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm101ps",x = 737,y = 1412,scalex = 0.6,scaley = 0.6,rotate = 0,color = Color(154,25,29),alignx = 1,aligny = 1},
		},
		["models/trolleybus/aksm101ps/interior"] = {
			{font = "Trolleybus_System.Skins.aksm101ps",x = 1654,y = 66,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),aligny = 1,alignx = 1},
		},
	})

	addskin("ziu6205","trolleybus.ziu6205.skins.body","trolleybus.ziu6205.skins.body.cherkassy",{
		["models/trolleybus/ziu6205/body"] = "models/trolleybus/ziu6205/skins/body/cherkassy/body",
		["models/trolleybus/ziu6205/interior_body"] = "models/trolleybus/ziu6205/skins/body/cherkassy/interior_body",
		["models/trolleybus/ziu6205/interior_trailer"] = "models/trolleybus/ziu6205/skins/body/cherkassy/interior_trailer",
	},"trolleybus/spawnsettings_previews/ziu6205/skin_body_cherkassy.png",{
		["models/trolleybus/ziu6205/body"] = {
			{font = "Trolleybus_System.Skins.ziu62052",x = 3584,y = 3748,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(57,91,140),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62052",x = 3587,y = 3028,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(57,91,140),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62052",x = 2009,y = 2908,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(57,91,140),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62052",x = 1526,y = 3636,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(57,91,140),alignx = 1,aligny = 1},
		},
		["models/trolleybus/ziu6205/interior_body"] = {
			{font = "Trolleybus_System.Skins.ziu62052",x = 3670,y = 1376,scalex = 0.4,scaley = 0.5,rotate = 0,color = Color(10,44,75),alignx = 1,aligny = 1},
		},
	})
	
	addskin("ziu6205","trolleybus.ziu6205.skins.body","trolleybus.ziu6205.skins.body.moscow_museum",{
		["models/trolleybus/ziu6205/body"] = "models/trolleybus/ziu6205/skins/body/moscow_museum/body",
		["models/trolleybus/ziu6205/interior_body"] = "models/trolleybus/ziu6205/skins/body/moscow_museum/interior_body",
		["models/trolleybus/ziu6205/interior_trailer"] = "models/trolleybus/ziu6205/skins/body/moscow_museum/interior_trailer",
	},"trolleybus/spawnsettings_previews/ziu6205/skin_body_moscow_museum.png",{
		["models/trolleybus/ziu6205/body"] = {
			{font = "Trolleybus_System.Skins.ziu62053",x = 3590,y = 3748,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 3600,y = 3025,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 868,y = 3341,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 2722,y = 3906,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})
	
	addskin("ziu6205","trolleybus.ziu6205.skins.body","trolleybus.ziu6205.skins.body.orange-white_uchebniy",{
		["models/trolleybus/ziu6205/body"] = "models/trolleybus/ziu6205/skins/body/orange-white_uchebniy/body",
	},"trolleybus/spawnsettings_previews/ziu6205/skin_body_orange-white_uchebniy.png",{
		["models/trolleybus/ziu6205/body"] = {
			{font = "Trolleybus_System.Skins.ziu62054",x = 3705,y = 3832,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62054",x = 3651,y = 3120,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62054",x = 1132,y = 3100,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62054",x = 2073,y = 3796,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		},
	})
	
	addskin("ziu6205","trolleybus.ziu6205.skins.body","trolleybus.ziu6205.skins.body.sumy",{
		["models/trolleybus/ziu6205/body"] = "models/trolleybus/ziu6205/skins/body/sumy/body",
		["models/trolleybus/ziu6205/interior_body"] = "models/trolleybus/ziu6205/skins/body/sumy/interior_body",
		["models/trolleybus/ziu6205/interior_trailer"] = "models/trolleybus/ziu6205/skins/body/sumy/interior_trailer",
	},"trolleybus/spawnsettings_previews/ziu6205/skin_body_sumy.png",{
		["models/trolleybus/ziu6205/body"] = {
			{font = "Trolleybus_System.Skins.ziu62052",x = 3667,y = 3820,scalex = 0.9,scaley = 0.9,rotate = 0,color = Color(192,195,206),alignx = 0,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62052",x = 3654,y = 3104,scalex = 0.9,scaley = 0.9,rotate = 0,color = Color(192,195,206),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62052",x = 2014,y = 2892,scalex = 0.9,scaley = 0.9,rotate = 0,color = Color(0,113,181),alignx = 1,aligny = 1},
		}
	})
	
	addskin("ziu6205","trolleybus.ziu6205.skins.body","trolleybus.ziu6205.skins.body.white-red",{
		["models/trolleybus/ziu6205/body"] = "models/trolleybus/ziu6205/skins/body/white-red/body",
	},"trolleybus/spawnsettings_previews/ziu6205/skin_body_white-red.png",{
		["models/trolleybus/ziu6205/body"] = {
			{font = "Trolleybus_System.Skins.ziu6205",x = 3667,y = 3800,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255)},
			{font = "Trolleybus_System.Skins.ziu6205",x = 3654,y = 3124,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu6205",x = 1129,y = 3112,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu6205",x = 2051,y = 3808,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
		},
		["models/trolleybus/ziu6205/interior_body"] = {
			{font = "Trolleybus_System.Skins.ziu6205",x = 3500,y = 1400,scalex = 0.5,scaley = 0.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		},
	})

	addskin("aksm333","trolleybus.aksm333.skins.body","trolleybus.aksm333.skins.body.minsk",{
		["models/trolleybus/aksm333/syabar"] = "models/trolleybus/aksm333/skins/body/minsk/syabar",
		["models/trolleybus/aksm333/syabar_lod"] = "models/trolleybus/aksm333/skins/body/minsk/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm333/skin_body_minsk.png",{
		["models/trolleybus/aksm333/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1144,y = 1852,scalex = 0.6,scaley = 0.8,rotate = 0,color = Color(0,0,0)},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1654,y = 1772,scalex = 0.6,scaley = 0.7,rotate = 0,color = Color(0,0,0),alignx = 1},
		}
	})
	
	addskin("aksm333","trolleybus.aksm333.skins.body","trolleybus.aksm333.skins.body.minsk_ad",{
		["models/trolleybus/aksm333/syabar"] = "models/trolleybus/aksm333/skins/body/minsk_ad/syabar",
		["models/trolleybus/aksm333/syabar_lod"] = "models/trolleybus/aksm333/skins/body/minsk_ad/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm333/skin_body_minsk_ad.png",{
		["models/trolleybus/aksm333/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1174,y = 1874,scalex = 0.5,scaley = 0.6,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1654,y = 1840,scalex = 0.6,scaley = 0.7,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})
	
	addskin("aksm333","trolleybus.aksm333.skins.body","trolleybus.aksm333.skins.body.minsk_default",{
		["models/trolleybus/aksm333/syabar"] = "models/trolleybus/aksm333/skins/body/minsk_default/syabar",
		["models/trolleybus/aksm333/syabar_lod"] = "models/trolleybus/aksm333/skins/body/minsk_default/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm333/skin_body_minsk_default.png",{
		["models/trolleybus/aksm333/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1144,y = 1852,scalex = 0.5,scaley = 0.6,rotate = 0,color = Color(0,0,0)},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1620,y = 1790,scalex = 0.5,scaley = 0.6,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})

	addskin("aksm333","trolleybus.aksm333.skins.handrails","trolleybus.aksm333.skins.handrails.yellow",{
		["models/trolleybus/aksm333/poruchni"] = "models/trolleybus/aksm333/skins/handrails/yellow/poruchni",
		["models/trolleybus/aksm333/porucni"] = "models/trolleybus/aksm333/skins/handrails/yellow/porucni",
	},"trolleybus/spawnsettings_previews/aksm333/skin_handrails_yellow.png")

	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.kaluga",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/kaluga/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/kaluga/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_kaluga_162.png",{
		["models/trolleybus/aksm321/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1168,y = 1872,scalex = 0.4,scaley = 0.6,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1168,y = 1764,scalex = 0.4,scaley = 0.6,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1633,y = 1792,scalex = 0.3,scaley = 0.5,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 704,y = 1326,scalex = 0.4,scaley = 0.6,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1313,y = 820,scalex = 0.5,scaley = 0.7,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.kursk",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/kursk/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/kursk/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_kursk_021.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.minsk_3080",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/minsk_3080/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/minsk_3080/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_minsk_3080.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.nizhniy_novgorod_2203",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/nizhniy_novgorod_2203/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/nizhniy_novgorod_2203/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_nizhniy_novgorod_2203.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.moscow_6851",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/moscow_6851/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/moscow_6851/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_moscow_6851.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.rostov_178",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/rostov_178/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/rostov_178/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_rostov_178.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.rostov_329",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/rostov_329/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/rostov_329/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_rostov_329.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.saint_peterburg_3405",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/saint_peterburg_3405/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/saint_peterburg_3405/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_saint_peterburg_3405.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.saint_peterburg_3432",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/saint_peterburg_3432/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/saint_peterburg_3432/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_saint_peterburg_3432.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.body","trolleybus.aksm321.skins.body.vitebsk_171",{
		["models/trolleybus/aksm321/syabar"] = "models/trolleybus/aksm321/skins/body/vitebsk_171/syabar",
		["models/trolleybus/aksm321/syabar_lod"] = "models/trolleybus/aksm321/skins/body/vitebsk_171/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321/skin_body_vitebsk_171.png")
	
	addskin("aksm321","trolleybus.aksm321.skins.handrails","trolleybus.aksm321.skins.handrails.yellow",{
		["models/trolleybus/aksm321/poruchni"] = "models/trolleybus/aksm321/skins/handrails/yellow/poruchni",
	},"trolleybus/spawnsettings_previews/aksm321/skin_handrails_yellow.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.body","trolleybus.aksm333o.skins.body.minsk_3602",{
		["models/trolleybus/aksm333o/syabar"] = "models/trolleybus/aksm333o/skins/body/minsk_3602/syabar",
	},"trolleybus/spawnsettings_previews/aksm333o/skin_body_minsk_3602.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.body","trolleybus.aksm333o.skins.body.minsk_3612",{
		["models/trolleybus/aksm333o/syabar"] = "models/trolleybus/aksm333o/skins/body/minsk_3612/syabar",
	},"trolleybus/spawnsettings_previews/aksm333o/skin_body_minsk_3612.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.body","trolleybus.aksm333o.skins.body.minsk_3618",{
		["models/trolleybus/aksm333o/syabar"] = "models/trolleybus/aksm333o/skins/body/minsk_3618/syabar",
	},"trolleybus/spawnsettings_previews/aksm333o/skin_body_minsk_3618.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.body","trolleybus.aksm333o.skins.body.moscow",{
		["models/trolleybus/aksm333o/syabar"] = "models/trolleybus/aksm333o/skins/body/moscow/syabar",
		["models/trolleybus/aksm333o/syabar_lod"] = "models/trolleybus/aksm333o/skins/body/moscow/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm333o/skin_body_moscow.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.body","trolleybus.aksm333o.skins.body.moscow_8612",{
		["models/trolleybus/aksm333o/syabar"] = "models/trolleybus/aksm333o/skins/body/moscow_8612/syabar",
		["models/trolleybus/aksm333o/syabar_lod"] = "models/trolleybus/aksm333o/skins/body/moscow_8612/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm333o/skin_body_moscow_8612.png")
	
	addskin("aksm333o","trolleybus.aksm333o.skins.body","trolleybus.aksm333o.skins.body.moscow_brand",{
		["models/trolleybus/aksm333o/syabar"] = "models/trolleybus/aksm333o/skins/body/moscow_brand/syabar",
		["models/trolleybus/aksm333o/syabar_lod"] = "models/trolleybus/aksm333o/skins/body/moscow_brand/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm333o/skin_body_moscow_brand.png")

	addskin("aksm333o","trolleybus.aksm333o.skins.handrails","trolleybus.aksm333o.skins.handrails.green",{
		["models/trolleybus/aksm333o/poruchni"] = "models/trolleybus/aksm333o/skins/handrails/green/poruchni",
		["models/trolleybus/aksm333o/porucni"] = "models/trolleybus/aksm333o/skins/handrails/green/porucni",
	},"trolleybus/spawnsettings_previews/aksm333o/skin_handrails_green.png")

	addskin("aksm321n","trolleybus.aksm321n.skins.body","trolleybus.aksm321n.skins.body.moscow_3tp",{
		["models/trolleybus/aksm321n/syabar"] = "models/trolleybus/aksm321n/skins/body/moscow_3tp/syabar",
		["models/trolleybus/aksm321n/syabar_lod"] = "models/trolleybus/aksm321n/skins/body/moscow_3tp/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321n/skin_body_moscow_3tp.png",{
		["models/trolleybus/aksm321n/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1155,y = 1855,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0)},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 2002,y = 1770,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 2},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 803,y = 1334,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 984,y = 830,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})
	
	addskin("aksm321n","trolleybus.aksm321n.skins.body","trolleybus.aksm321n.skins.body.moscow_5tp",{
		["models/trolleybus/aksm321n/syabar"] = "models/trolleybus/aksm321n/skins/body/moscow_5tp/syabar",
		["models/trolleybus/aksm321n/syabar_lod"] = "models/trolleybus/aksm321n/skins/body/moscow_5tp/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321n/skin_body_moscow_5tp.png",{
		["models/trolleybus/aksm321n/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n2",x = 1490,y = 1855,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),alignx = 2},
			{font = "Trolleybus_System.Skins.aksm321n2",x = 2002,y = 1776,scalex = 0.4,scaley = 0.4,rotate = 0,color = Color(0,0,0),alignx = 2},
			{font = "Trolleybus_System.Skins.aksm321n2",x = 803,y = 1334,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n2",x = 984,y = 830,scalex = 0.8,scaley = 0.8,rotate = 0,color = Color(0,0,0),alignx = 1,aligny = 1},
		}
	})
	
	addskin("aksm321n","trolleybus.aksm321n.skins.body","trolleybus.aksm321n.skins.body.moscow_brand",{
		["models/trolleybus/aksm321n/syabar"] = "models/trolleybus/aksm321n/skins/body/moscow_brand/syabar",
		["models/trolleybus/aksm321n/syabar_lod"] = "models/trolleybus/aksm321n/skins/body/moscow_brand/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321n/skin_body_moscow_brand.png",{
		["models/trolleybus/aksm321n/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n",x = 1148,y = 1855,scalex = 0.55,scaley = 0.5,rotate = 0,color = Color(255,255,255)},
			{font = "Trolleybus_System.Skins.aksm321n",x = 2002,y = 1776,scalex = 0.55,scaley = 0.5,rotate = 0,color = Color(255,255,255),alignx = 2},
			{font = "Trolleybus_System.Skins.aksm321n",x = 1355,y = 1355,scalex = 1.1,scaley = 1,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n",x = 777,y = 860,scalex = 1.1,scaley = 1,rotate = 0,color = Color(255,255,255),alignx = 1,aligny = 1},
		},
	})
	
	addskin("aksm321n","trolleybus.aksm321n.skins.body","trolleybus.aksm321n.skins.body.minsk",{
		["models/trolleybus/aksm321n/syabar"] = "models/trolleybus/aksm321n/skins/body/minsk/syabar",
		["models/trolleybus/aksm321n/syabar_lod"] = "models/trolleybus/aksm321n/skins/body/minsk/syabar_lod",
	},"trolleybus/spawnsettings_previews/aksm321n/skin_body_minsk.png",{
		["models/trolleybus/aksm321n/syabar"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1145,y = 1852,scalex = 0.75,scaley = 0.75,rotate = 0,color = Color(0,0,0)},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 1587,y = 1770,scalex = 0.75,scaley = 0.75,rotate = 0,color = Color(0,0,0)},
		},
	})

	addskin("aksm321n","trolleybus.aksm321n.skins.handrails","trolleybus.aksm321n.skins.handrails.yellow",{
		["models/trolleybus/aksm321n/poruchni"] = "models/trolleybus/aksm321n/skins/handrails/yellow/poruchni",
		["models/trolleybus/aksm321n/porucni"] = "models/trolleybus/aksm321n/skins/handrails/yellow/porucni",
	},"trolleybus/spawnsettings_previews/aksm321n/skin_handrails_yellow.png")

	addskin("trolza5265","trolleybus.trolza5265.skins.body","trolleybus.trolza5265.skins.body.moscow",{
		["models/trolleybus/trolza5265/body"] = "models/trolleybus/trolza5265/skins/body/moscow/body"
	},"trolleybus/spawnsettings_previews/trolza5265/skin_body_moscow.png",{
		["models/trolleybus/trolza5265/body"] = {
			{font = "Trolleybus_System.Skins.aksm321n",x = 2163,y = 1212,scalex = 1.3,scaley = 1.3,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n",x = 1158,y = 1996,scalex = 1.3,scaley = 1.3,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n",x = 3894,y = 1176,scalex = 1,scaley = 1,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n",x = 3926,y = 1752,scalex = 1,scaley = 1,rotate = 0,color = color_white,alignx = 1,aligny = 1},
		}
	})

	addskin("trolza5265","trolleybus.trolza5265.skins.body","trolleybus.trolza5265.skins.body.odessa",{
		["models/trolleybus/trolza5265/body"] = "models/trolleybus/trolza5265/skins/body/odessa/body"
	},"trolleybus/spawnsettings_previews/trolza5265/skin_body_odessa.png",{
		["models/trolleybus/trolza5265/body"] = {
			{font = "Trolleybus_System.Skins.trolza52652",x = 1276,y = 1256,scalex = 0.8,scaley = 0.8,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.trolza52652",x = 1571,y = 2048,scalex = 0.8,scaley = 0.8,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.trolza52652",x = 3488,y = 1208,scalex = 0.8,scaley = 0.8,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.trolza52652",x = 3440,y = 1760,scalex = 0.8,scaley = 0.8,rotate = 0,color = color_white,alignx = 1,aligny = 1},
		}
	})

	addskin("trolza5265","trolleybus.trolza5265.skins.body","trolleybus.trolza5265.skins.body.spb",{
		["models/trolleybus/trolza5265/body"] = "models/trolleybus/trolza5265/skins/body/spb/body"
	},"trolleybus/spawnsettings_previews/trolza5265/skin_body_spb.png",{
		["models/trolleybus/trolza5265/body"] = {
			{font = "Trolleybus_System.Skins.ziu6205",x = 3888,y = 1176,scalex = 1.1,scaley = 1.1,rotate = 0,color = color_black,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu6205",x = 3433,y = 1752,scalex = 1.1,scaley = 1.1,rotate = 0,color = color_black,alignx = 1,aligny = 1},
		}
	})

	addskin("trolza5265","trolleybus.trolza5265.skins.body","trolleybus.trolza5265.skins.body.whitegreen",{
		["models/trolleybus/trolza5265/body"] = "models/trolleybus/trolza5265/skins/body/white-green/body"
	},"trolleybus/spawnsettings_previews/trolza5265/skin_body_whitegreen.png",{
		["models/trolleybus/trolza5265/body"] = {
			{font = "Trolleybus_System.Skins.trolza5265",x = 1267,y = 1160,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(24,171,90),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.trolza5265",x = 1571,y = 1960,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(24,171,90),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.trolza5265",x = 3894,y = 1184,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(24,171,90),alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.trolza5265",x = 3440,y = 1764,scalex = 1.1,scaley = 1.1,rotate = 0,color = Color(24,171,90),alignx = 1,aligny = 1},
		}
	})

	addskin("trolza5265","trolleybus.trolza5265.skins.body","trolleybus.trolza5265.skins.body.himki",{
		["models/trolleybus/trolza5265/body"] = "models/trolleybus/trolza5265/skins/body/himki/body"
	},"trolleybus/spawnsettings_previews/trolza5265/skin_body_himki.png",{
		["models/trolleybus/trolza5265/body"] = {
			{font = "Trolleybus_System.Skins.aksm321n3",x = 2054,y = 1252,scalex = 1.1,scaley = 1.1,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 2076,y = 2054,scalex = 1.1,scaley = 1.1,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 3862,y = 1196,scalex = 1.1,scaley = 1.1,rotate = 0,color = color_black,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.aksm321n3",x = 3440,y = 1760,scalex = 1.1,scaley = 1.1,rotate = 0,color = color_black,alignx = 1,aligny = 1},
		}
	})

	addskin("trolza5265","trolleybus.trolza5265.skins.body","trolleybus.trolza5265.skins.body.yellow",{
		["models/trolleybus/trolza5265/body"] = "models/trolleybus/trolza5265/skins/body/yellow/body"
	},"trolleybus/spawnsettings_previews/trolza5265/skin_body_yellow.png",{
		["models/trolleybus/trolza5265/body"] = {
			{font = "Trolleybus_System.Skins.ziu62053",x = 1315,y = 1176,scalex = 1.3,scaley = 1.3,rotate = 0,color = color_black,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 1587,y = 1996,scalex = 1.3,scaley = 1.3,rotate = 0,color = color_black,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 3680,y = 1192,scalex = 1.3,scaley = 1.3,rotate = 0,color = color_black,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu62053",x = 3440,y = 1760,scalex = 1.3,scaley = 1.3,rotate = 0,color = color_black,alignx = 1,aligny = 1},
		}
	})

	if CLIENT then
		for k,v in pairs(file.Find("lua/trolleybus_system/userskins/*","GAME")) do
			local json = file.Read("lua/trolleybus_system/userskins/"..v,"GAME")
			if !json then continue end

			local data = util.JSONToTable(json)
			if !data then continue end

			for k2,v2 in ipairs(data) do
				local troll = v2.Trolleybus
				if !isstring(troll) then continue end

				local group = v2.GroupName
				if !isstring(group) then continue end

				local skin = v2.SkinName
				if !isstring(skin) then continue end

				local textures = v2.TextureOverrides
				if !istable(textures) or table.IsEmpty(textures) then continue end

				local preview = v2.Preview
				if preview and !isstring(preview) then continue end

				local bortnums = v2.BortNumbers
				if bortnums and !istable(bortnums) then continue end

				local skins = Trolleybus_System.TrolleybusSkins
				if skins and skins[troll] and skins[troll][group] and skins[troll][group].skins[skin] then continue end

				if bortnums then
					local cont = false

					for k,v in pairs(bortnums) do
						if !istable(v) then cont = true break end

						for k,v in ipairs(v) do
							if !v.font then cont = true break end

							local f,w = v.font,500
							if f[1]=="!" then f,w = f:sub(2,-1),700 end

							if !Trolleybus_System.TrolleybusUserSkinsFonts[f] then
								local name = "Trolleybus_System.TrolleybusUserSkinsFont"..(table.Count(Trolleybus_System.TrolleybusUserSkinsFonts)+1)
								surface.CreateFont(name,{
									font = f,
									weight = w,
									extended = true,
									size = 60,
								})

								Trolleybus_System.TrolleybusUserSkinsFonts[f] = name
							end

							v.font = Trolleybus_System.TrolleybusUserSkinsFonts[f]
							v.color = v.color and Color(v.color.r or 255,v.color.g or 255,v.color.b or 255,v.color.a or 255) or color_white
						end
					end

					if cont then continue end
				end

				Trolleybus_System.AddTrolleybusSkin(troll,group,skin,textures,preview,bortnums)
			end
		end
	end
end
