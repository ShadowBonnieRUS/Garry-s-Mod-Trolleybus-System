-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System = Trolleybus_System or {}

AddCSLuaFile("trolleybus_system/trolleybus_system_init.lua")
include("trolleybus_system/trolleybus_system_init.lua")

hook.Run("Trolleybus_System.PostInit")