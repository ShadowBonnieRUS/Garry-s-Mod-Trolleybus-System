function Trolleybus_System:TrolleybusSystem_AddTrolleybusSkinsG017(addskin)
    if CLIENT then
        surface.CreateFont("Trolleybus_System.Skins.ziu682g017",{font = "Moscow_6tp",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.ziu682g017_1",{font = "Moscow_6tp",size = 60,extended = true,weight = 500})
		surface.CreateFont("Trolleybus_System.Skins.ziu682g017_2",{font = "Arial",size = 60,extended = true,weight = 600})
		surface.CreateFont("Trolleybus_System.Skins.ziu682g017_3",{font = "Aero Matics Stencil",size = 60,extended = true,weight = 600})
		surface.CreateFont("Trolleybus_System.Skins.ziu682g017_4",{font = "Century",size = 60,extended = true,weight = 600})
		surface.CreateFont("Trolleybus_System.Skins.ziu682g017_5",{font = "Moscow_6tp",size = 60,extended = true,weight = 500})
    end

    addskin("ziu682g017","trolleybus.ziu682g017.skins.body","trolleybus.ziu682g017.skins.body.default",{
		["models/trolleybus/ziu682g017/body"] = "models/trolleybus/ziu682g017/body",
	},"trolleybus/spawnsettings_previews/ziu682g017/skin_body_default.png",{
		["models/trolleybus/ziu682g017/body"] = {
			{font = "Trolleybus_System.Skins.ziu682g017",x = 3698,y = 3784,scalex = 1.4,scaley = 1.4,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682g017",x = 1455,y = 3736,scalex = 1.4,scaley = 1.4,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682g017",x = 1523,y = 2843,scalex = 1.4,scaley = 1.4,rotate = 0,color = color_white,alignx = 1,aligny = 1},
			{font = "Trolleybus_System.Skins.ziu682g017",x = 3547,y = 2859,scalex = 1.4,scaley = 1.4,rotate = 0,color = color_white,alignx = 1,aligny = 1},
		},
	})
end