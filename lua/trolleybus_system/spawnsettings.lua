-- Copyright © Platunov I. M., 2020 All rights reserved

Trolleybus_System.TrolleybusSpawnSettings = Trolleybus_System.TrolleybusSpawnSettings or util.JSONToTable(file.Read("trolleybus_bus_settings.txt") or "[]") or {}
