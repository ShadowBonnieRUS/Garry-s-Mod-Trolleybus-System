-- Copyright © Platunov I. M., 2020 All rights reserved

function Trolleybus_System:TrolleybusSystem_RegisterTrafficVehicles(vehs,wheels)
	vehs["vaz_2109"] = {
		Model = "models/trolleybus/trafficcars/vaz_2109.mdl",

		Mass = 1500,
		Wheels = {
			{
				Drive = true,
				Turn = true,
				Wheels = {
					{Type = "vaz_2109", Pos = Vector(52,24,-18), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "vaz_2109", Pos = Vector(52,-27,-18), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			},
			{
				Drive = false,
				Turn = false,
				Wheels = {
					{Type = "vaz_2109", Pos = Vector(-45,24,-18), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "vaz_2109", Pos = Vector(-45,-27,-18), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 500,
		Deceleration = 2500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 30,
		SpawnSelectWeight = 1,
		IsService = false,
		
		DriverPos = Vector(-8,14,-17),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(77.29,16.87,-3.85),"sprites/light_ignorez",40,color_white},
			{Vector(77.29,-18.93,-3.85),"sprites/light_ignorez",40,color_white},
			
			{Vector(-70.4,17.55,-4.57),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-70.4,-20.55,-4.57),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(75.94,24.51,-3.85),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-69.45,25.46,-4.7),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(36.73,-29.83,-4.95),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(75.94,-27.25,-3.85),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-69.45,-28.56,-4.7),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(36.73,-32.75,-4.95),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["vaz_2106"] = {
		Model = "models/trolleybus/trafficcars/vaz_2106.mdl",

		Mass = 1500,
		Wheels = {
			{
				Drive = false,
				Turn = true,
				Wheels = {
					{Type = "vaz_2106", Pos = Vector(49,26,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "vaz_2106", Pos = Vector(49,-27,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			},
			{
				Drive = true,
				Turn = false,
				Wheels = {
					{Type = "vaz_2106", Pos = Vector(-44,26,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "vaz_2106", Pos = Vector(-44,-27,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 500,
		Deceleration = 2500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 23,
		SpawnSelectWeight = 1,
		IsService = true,
		
		DriverPos = Vector(-10,14,-10),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(67.8,22.36,2.46),"sprites/light_ignorez",40,color_white},
			{Vector(67.8,-22.96,2.46),"sprites/light_ignorez",40,color_white},
			
			{Vector(-79.86,18.63,2.46),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-79.86,-19.77,2.46),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(67.8,24.01,-3.18),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(64.68,28.25,5.35),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-79.86,23.03,2.46),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(67.8,-24.75,-3.18),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(64.68,-29.19,5.35),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-79.86,-24.01,2.46),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["gazel"] = {
		Model = "models/trolleybus/trafficcars/gazel.mdl",

		Mass = 3500,
		Wheels = {
			{
				Drive = false,
				Turn = true,
				Wheels = {
					{Type = "gazel", Pos = Vector(52,31,-20), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 2, Right = false},
					{Type = "gazel", Pos = Vector(52,-33,-20), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 2, Right = true},
				},
			},
			{
				Drive = true,
				Turn = false,
				Wheels = {
					{Type = "gazel2", Pos = Vector(-62,27,-20), Height = 4, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 3, Right = false},
					{Type = "gazel2", Pos = Vector(-62,-29,-20), Height = 4, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 3, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 400,
		Deceleration = 2000,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 35,
		SpawnSelectWeight = 0.25,
		IsService = false,
		
		DriverPos = Vector(12,19,-1),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(79.33,25.41,-1.15),"sprites/light_ignorez",40,color_white},
			{Vector(79.33,-27.29,-1.15),"sprites/light_ignorez",40,color_white},
			
			{Vector(-103.42,29.41,-12.55),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-103.42,-31.41,-12.55),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(78.52,26.97,2.82),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(57.18,33.27,6.85),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-103.42,33.73,-12.55),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(78.52,-28.98,2.82),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(57.18,-35.34,6.85),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-103.42,-35.79,-12.55),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["focus"] = {
		Model = "models/trolleybus/trafficcars/focus.mdl",

		Mass = 1500,
		Wheels = {
			{
				Drive = true,
				Turn = true,
				Wheels = {
					{Type = "focus", Pos = Vector(49,24,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "focus", Pos = Vector(49,-25,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			},
			{
				Drive = false,
				Turn = false,
				Wheels = {
					{Type = "focus", Pos = Vector(-50,24,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "focus", Pos = Vector(-50,-25,-11), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 500,
		Deceleration = 2500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 23,
		SpawnSelectWeight = 1,
		IsService = false,
		
		DriverPos = Vector(-10,12,-10),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(75.27,19.4,2.23),"sprites/light_ignorez",40,color_white},
			{Vector(75.27,-20.45,2.23),"sprites/light_ignorez",40,color_white},
			
			{Vector(-78.91,19.96,7.94),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-78.91,-21.01,7.94),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(79.11,9.38,-0.2),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(70.59,25.44,-3.94),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-77.91,23.12,7.94),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(79.11,-10.4,-0.2),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(70.59,-26.53,-3.94),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-77.91,-24.17,7.94),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["kamaz"] = {
		Model = "models/trolleybus/trafficcars/kamaz.mdl",

		Mass = 14000,
		Wheels = {
			{
				Drive = false,
				Turn = true,
				Wheels = {
					{Type = "kamaz", Pos = Vector(81,39,-25), Height = 4, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 5, Right = false},
					{Type = "kamaz", Pos = Vector(81,-38,-25), Height = 4, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 5, Right = true},
				},
			},
			{
				Drive = true,
				Turn = false,
				Wheels = {
					{Type = "kamaz2", Pos = Vector(-45,35,-25), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 4, Right = false},
					{Type = "kamaz2", Pos = Vector(-45,-35,-25), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 4, Right = true},
				},
			},
			{
				Drive = true,
				Turn = false,
				Wheels = {
					{Type = "kamaz2", Pos = Vector(-99,35,-25), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 4, Right = false},
					{Type = "kamaz2", Pos = Vector(-99,-35,-25), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 4, Right = true},
				},
			},
		},
		
		MaxSpeed = 1500,
		Acceleration = 300,
		Deceleration = 1500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 45,
		SpawnSelectWeight = 0.2,
		IsService = true,
		
		DriverPos = Vector(80,24,10),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic_kamaz.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(131.41,33.86,-12.27),"sprites/light_ignorez",40,color_white},
			{Vector(131.41,-33.9,-12.27),"sprites/light_ignorez",40,color_white},
			
			{Vector(-123.29,34.99,-11.54),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-123.29,-34.68,-11.54),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(130.36,40.57,-12.27),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(125.69,44.06,7.02),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-123.29,39.6,-11.54),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(130.36,-40.39,-12.27),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(125.69,-43.83,7.02),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-123.29,-39.28,-11.54),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["lexus"] = {
		Model = "models/trolleybus/trafficcars/lexus.mdl",

		Mass = 1500,
		Wheels = {
			{
				Drive = true,
				Turn = true,
				Wheels = {
					{Type = "lexus", Pos = Vector(52,27,-14), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "lexus", Pos = Vector(52,-27,-14), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			},
			{
				Drive = false,
				Turn = false,
				Wheels = {
					{Type = "lexus", Pos = Vector(-47,27,-14), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "lexus", Pos = Vector(-47,-27,-14), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 500,
		Deceleration = 2500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 28,
		SpawnSelectWeight = 1,
		IsService = false,
		
		DriverPos = Vector(-6,13,-10),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(76.32,26.46,1.36),"sprites/light_ignorez",40,color_white},
			{Vector(76.32,-26.52,1.36),"sprites/light_ignorez",40,color_white},
			
			{Vector(-74.76,25.42,14.17),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-74.76,-25.46,14.17),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(72.3,27.88,4.75),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-75.2,27.04,10.88),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(72.3,-27.94,4.75),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-75.2,-27.15,10.88),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["mercedes"] = {
		Model = "models/trolleybus/trafficcars/mercedes.mdl",

		Mass = 1500,
		Wheels = {
			{
				Drive = true,
				Turn = true,
				Wheels = {
					{Type = "mercedes", Pos = Vector(54,26,-13), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "mercedes", Pos = Vector(54,-27,-13), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			},
			{
				Drive = true,
				Turn = false,
				Wheels = {
					{Type = "mercedes", Pos = Vector(-43,26,-13), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "mercedes", Pos = Vector(-43,-27,-13), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 500,
		Deceleration = 2500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 25,
		SpawnSelectWeight = 1,
		IsService = false,
		
		DriverPos = Vector(-10,12,-10),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(74.09,21.01,1.43),"sprites/light_ignorez",40,color_white},
			{Vector(74.09,-22.12,1.43),"sprites/light_ignorez",40,color_white},
			
			{Vector(-69.53,22.73,6.21),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-69.53,-24.1,6.21),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(74.09,25.69,-0.83),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(26.7,33.16,11.22),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-69.53,22.73,3.76),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(74.09,-26.77,-0.83),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(26.7,-34.54,11.22),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-69.53,-24.1,3.76),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["vaz_2110"] = {
		Model = "models/trolleybus/trafficcars/vaz_2110.mdl",

		Mass = 1500,
		Wheels = {
			{
				Drive = true,
				Turn = true,
				Wheels = {
					{Type = "vaz_2110", Pos = Vector(53,27,-15), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "vaz_2110", Pos = Vector(53,-28,-15), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			},
			{
				Drive = false,
				Turn = false,
				Wheels = {
					{Type = "vaz_2110", Pos = Vector(-42,27,-15), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = false},
					{Type = "vaz_2110", Pos = Vector(-42,-28,-15), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 1, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 500,
		Deceleration = 2500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 25,
		SpawnSelectWeight = 1,
		IsService = false,
		
		DriverPos = Vector(-8,14,-12),
		DriverAng = Angle(),
		
		EngineSound = "trolleybus/engine_traffic.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(76.61,20.45,-0.64),"sprites/light_ignorez",40,color_white},
			{Vector(76.61,-21.39,-0.64),"sprites/light_ignorez",40,color_white},
			
			{Vector(-73.34,22.23,0.39),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-73.34,-24.08,0.39),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(75.25,26.81,-0.64),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(40.1,32.68,1.41),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-73.34,22.23,3.24),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(75.25,-27.97,-0.64),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(40.1,-33.77,1.41),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-73.34,-24.07,3.24),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}
	vehs["paz3205"] = {
		Model = "models/trolleybus/trafficcars/paz3205.mdl",

		Mass = 5500,
		Wheels = {
			{
				Drive = false,
				Turn = true,
				Wheels = {
					{Type = "paz3205", Pos = Vector(79,35,-40), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 3, Right = false},
					{Type = "paz3205", Pos = Vector(79,-35,-40), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 3, Right = true},
				},
			},
			{
				Drive = true,
				Turn = false,
				Wheels = {
					{Type = "paz32052", Pos = Vector(-57,33,-40), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 4, Right = false},
					{Type = "paz32052", Pos = Vector(-57,-33,-40), Height = 3, Constant = 50000, Damping = 1300, RDamping = 1300, Times = 4, Right = true},
				},
			}
		},
		
		MaxSpeed = 1500,
		Acceleration = 300,
		Deceleration = 1500,
		
		TraceDistance = 1000,
		SpawnHeightOffset = 55,
		SpawnSelectWeight = 0.2,
		IsService = true,
		
		DriverPos = Vector(75,28,-10),
		DriverAng = Angle(10,0,0),
		
		EngineSound = "trolleybus/engine_traffic_paz.wav",
		EngineSoundPitch = {100,150},
		
		Sprites = {
			{Vector(124.33,28.09,-23.67),"sprites/light_ignorez",40,color_white},
			{Vector(124.33,-28.27,-23.67),"sprites/light_ignorez",40,color_white},
			
			{Vector(-134.30,30.21,-19.64),"sprites/light_ignorez",40,Color(255,0,0)},
			{Vector(-134.30,-30.10,-19.64),"sprites/light_ignorez",40,Color(255,0,0)},
		},
		SpritesTurnLeft = {
			{Vector(122.22,36.71,-22.42),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(54.27,45.83,-19.85),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-134.3,35.12,-19.64),"sprites/light_ignorez",40,Color(255,155,0)},
		},
		SpritesTurnRight = {
			{Vector(122.22,-36.61,-22.42),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(54.27,-45.62,-19.85),"sprites/light_ignorez",40,Color(255,155,0)},
			{Vector(-134.3,-35.02,-19.64),"sprites/light_ignorez",40,Color(255,155,0)},
		},
	}

	wheels["vaz_2109"] = {
		Model = "models/trolleybus/trafficcars/vaz_2109_wheel.mdl",
		Ang = Angle(0,90,0),
		Radius = 11.3,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["vaz_2106"] = {
		Model = "models/trolleybus/trafficcars/vaz_2106_wheel.mdl",
		Ang = Angle(0,90,0),
		Radius = 11,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["gazel"] = {
		Model = "models/trolleybus/trafficcars/gazel_wheel_f.mdl",
		Ang = Angle(0,-90,0),
		Radius = 13.8,
		RotateAxis = Angle(1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["gazel2"] = {
		Model = "models/trolleybus/trafficcars/gazel_wheel_r.mdl",
		Ang = Angle(0,-90,0),
		Radius = 13.8,
		RotateAxis = Angle(1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["focus"] = {
		Model = "models/trolleybus/trafficcars/focus_wheel.mdl",
		Ang = Angle(0,90,0),
		Radius = 11.3,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["kamaz"] = {
		Model = "models/trolleybus/trafficcars/kamaz_wheel_f.mdl",
		Ang = Angle(0,90,0),
		Radius = 19.6,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["kamaz2"] = {
		Model = "models/trolleybus/trafficcars/kamaz_wheel_r.mdl",
		Ang = Angle(0,90,0),
		Radius = 19.6,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["lexus"] = {
		Model = "models/trolleybus/trafficcars/lexus_wheel.mdl",
		Ang = Angle(0,-90,0),
		Radius = 13.4,
		RotateAxis = Angle(1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["mercedes"] = {
		Model = "models/trolleybus/trafficcars/mercedes_wheel.mdl",
		Ang = Angle(0,90,0),
		Radius = 12.5,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["vaz_2110"] = {
		Model = "models/trolleybus/trafficcars/vaz_2110_wheel.mdl",
		Ang = Angle(0,90,0),
		Radius = 10.9,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["paz3205"] = {
		Model = "models/trolleybus/trafficcars/paz3205_wheel_front.mdl",
		Ang = Angle(0,90,0),
		Radius = 18.3,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
	wheels["paz32052"] = {
		Model = "models/trolleybus/trafficcars/paz3205_wheel_rear.mdl",
		Ang = Angle(0,90,0),
		Radius = 18.3,
		RotateAxis = Angle(-1,0,0),
		TurnAxis = Angle(0,1,0),
	}
end