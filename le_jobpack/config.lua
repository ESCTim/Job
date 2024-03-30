Config = {}

Config.WhitelistMedicItems = {'headlights', 'bankcard', 'levelup', 'phone', 'simcard', 'licenseplate', 'case', 'containerkey'}

local vehicleSpawns = {
    -- PD
    {
        Spawner = vector3(-572.23, -93.15, 33.75),
        InsideShop = vector3(-597.86, -100.6, 33.75),
        SpawnPoints = {
            {coords = vector3(-584.6, -94.92, 33.75), heading = 113.03, radius = 6.0}
        }
    },

    -- FIB Tower
    {
        Spawner = vector3(124.62, -740.77, 33.13),
        InsideShop = vector3(119.11, -727.49, 32.74),
        SpawnPoints = {
            {coords = vector3(119.11, -727.49, 32.74), heading = 247.58, radius = 6.0}
        }
    },


    -- Medic
    {
        Spawner = vector3(301.04, -603.32, 43.41),
        InsideShop = vector3(292.4, -613.28, 43.41),
        SpawnPoints = {
            {coords = vector3(292.4, -613.28, 43.41), heading = 74.59, radius = 4.0}
        }
    },

    -- FIB
    {
        Spawner = vector3(95.49, -724.99, 33.13),
        InsideShop = vector3(100.08, -729.38, 32.71),
        SpawnPoints = {
            {coords = vector3(100.08, -729.38, 32.71), heading = 340.51, radius = 4.0}
        }
    },

    -- DOJ
    {
        Spawner = vector3(-573.51, -147.93, 38.04),
        InsideShop = vector3(-568.85, -154.6, 37.98),
        SpawnPoints = {
            {coords = vector3(-568.85, -154.6, 37.98), heading = 109.12, radius = 4.0}
        }
    },

    -- -- Sheriff
    -- {
    --     Spawner = vector3(-478.61, 6015.25, 31.34),
    --     InsideShop = vector3(-482.52, 6024.64, 31.34),
    --     SpawnPoints = {
    --         {coords = vector3(-482.52, 6024.64, 31.34), heading = 224.29, radius = 4.0}
    --     }
    -- },
}

local helicopterSpawns = {
    -- PD
    {
        Spawner = vector3(-542.04, -116.59, 51.99),
        InsideShop = vector3(-547.09, -121.93, 51.99),
        SpawnPoints = {
            {coords = vector3(-547.09, -121.93, 51.99), heading = 204.88, radius = 10.0}
        }
    },

    -- Medic
    {
        Spawner = vector3(355.39, -577.12, 74.16),
        InsideShop = vector3(351.99, -588.23, 74.16),
        SpawnPoints = {
            {coords = vector3(351.99, -588.23, 74.16), heading = 162.05 , radius = 10.0}
        }
    },

    -- DOJ
    {
        Spawner = vector3(-535.01, -250.74, 35.84),
        InsideShop = vector3(-544.42, -251.04, 37.49),
        SpawnPoints = {
            {coords = vector3(-544.42, -251.04, 37.49), heading = 100.75, radius = 4.0}
        }
    },

    -- -- Sheriff
    -- {
    --     Spawner = vector3(-477.77, 6007.61, 31.3),
    --     InsideShop = vector3(-474.68, 5989.2, 31.34),
    --     SpawnPoints = {
    --         {coords = vector3(-474.68, 5989.2, 31.34), heading = 133.48, radius = 4.0}
    --     }
    -- },

    -- FIB
    {
        Spawner = vector3(116.36, -740.33, 262.85),
        InsideShop = vector3(123.43, -744.36, 262.85),
        SpawnPoints = {
            {coords = vector3(123.43, -744.36, 262.85), heading = 339.58, radius = 7.0}
        }
    },
}

Config.Jobs = {
    ["lspd"] = {
        Blip = {
            Coords = vector3(-545.8, -111.46, 37.87),
            blip = true,
			Sprite = 60,
			Display = 4,
			Scale = 0.8,
			Colour = 29,
            Text = 'Police'
        },

        -- Cloakrooms = {
        --     vector3(-1098.4225, -831.5955, 14.2828),
        --     vector3(1681.8079, 2574.3125, 45.9115)
        -- },

        Armories = {
            vector3(-545.8, -111.46, 37.87) -- Hauptgebäude
		},

		Vehicles = vehicleSpawns,

        Helicopters = helicopterSpawns,

        Boats = {},

		BossActions = {
            vector3(-574.39, -129.64, 42.26)
		},

        ActionMenu = {
            zivi = {
                enable = true,

                -- actions --

                identity_card = true,
                weapon_license = false,
                handcuff = true,
                search = true,
                maskoff = true,
                drag = true,
                putInVehicle = true,
                putOutVehicle = true,
                bills = true,
                speedcam = true,
                jail = true -- Jemanden ins Gefängnis bringen
            },

            ems_menu = {
                enable = false,

                -- actions --

                revive = false,
                small = false,
                big = false,
                putInVehicle = false,
                declareDead = false
            },

            object_spawner = {
                enable = true,

                -- actions --

                models = {
                    { label = 'Hütchen', model = 'prop_roadcone02a' },
                    { label = 'Barriere', model = 'prop_barrier_work05' },
                    { label = 'Nagelband', model = 'p_ld_stinger_s' },
                    { label = 'Sperre mit Pfeil', model = 'prop_mp_arrow_barrier_01' }
                }
            },

            vehicle_interaction = {
                enable = true,

                -- actions --

                vehicle_infos = true,
                hijack_vehicle = true,
                repair = false,
                wash = false,
                impound = true,
                beschlagnahmen = false,
                search_database = true,
                low_loader = false,
                see_registration = true -- Zulassung sehen
            },

            license_interaction = {
                enable = true,

                -- actions -- // rank = 8 bedeutet Rang 8 und höher

                add_weapon_license = {enable = true, ranks = 12},
                remove_weapon_license = {enable = true, ranks = 6},
                add_driver_license = {enable = true, ranks = 12},
                remove_driver_license = {enable = true, ranks = 4}
            },

            panicButton = false
        },

        permissions = {
            get_weapon = 10,
            get_object = 10
        },

        AuthorizedWeapons = {
            enable = true,

            
            rekrut = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
            },

            officer = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
            },
        
            officerii = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },
        
            sergeant = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },
        
            sergeantii = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 5000 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 7500 },
                { weapon = 'WEAPON_COMBATPDW', price = 20000 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },
        
            lieutenant = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },

            detective = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'WEAPON_SPECIALCARBINE', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },

            captain = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'WEAPON_SPECIALCARBINE', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },
                    
            commander = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'WEAPON_SPECIALCARBINE', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },
        
            dchief = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'WEAPON_SPECIALCARBINE', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            },
        
            boss = {
                { weapon = 'WEAPON_STUNGUN', price = 0 },
                { weapon = 'WEAPON_NIGHTSTICK', price = 0 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 0 },
                { weapon = 'WEAPON_COMBATPISTOL', price = 1 },
                { weapon = 'WEAPON_HEAVYPISTOL', price = 1 },
                {weapon = 'WEAPON_REVOLVER_MK2', price = 1 },
                { weapon = 'WEAPON_SMG', price = 1 },
                { weapon = 'WEAPON_COMBATPDW', price = 1 },
                { weapon = 'WEAPON_BZGAS', price = 1 },
                { weapon = 'WEAPON_SPECIALCARBINE', price = 1 },
                { weapon = 'GADGET_PARACHUTE', price = 0 }
            }
        },

        AuthorizedItems = {
            enable = true,

            rekrut = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },

            officer = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },

            officerii = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },

            sergeant = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },
        
            sergeantii = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },

            lieutenant = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'lockpick', label = 'Dietrich', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },

            detective = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'lockpick', label = 'Dietrich', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },

            captain = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'lockpick', label = 'Dietrich', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },
        
            commander = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'lockpick', label = 'Dietrich', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },
        
        
            dchief = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'lockpick', label = 'Dietrich', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            },

            boss = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproofpolice', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'nachtsicht', label = 'Nachtsichtgerät', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'gps', label = 'GPS', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'tracking_tablet', label = 'Tracking Tablet', price = 1 },
                { item = 'lockpick', label = 'Dietrich', price = 1 },
                { item = 'lunchpackage', label = 'Lunchpaket', price = 40}
            }
        },

        AuthorizedVehicles = {
            car = {

                rekrut = {
                    {model = 'pbus', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },

                officer = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },
        
                officerii = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },
        
                sergeant = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },
        
                sergeantii = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },
        
                lieutenant = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },

                detective = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },

                captain = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1}
                },
        
                commander = {
                    {model = 'pbus', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1},
                },
        
                dchief = {
                    {model = 'pbus', price = 1},
                    {model = 'as350', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1},
                    {model = 'insurgent2', price = 1}
                },
        
                boss = {
                    {model = 'pbus', price = 1},
                    {model = 'as350', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1},
                    {model = 's900unmarked', price = 1},
                    {model = 'polamggtr', price = 1},
                    {model = 'riot', price = 1},
                    {model = 'insurgent2', price = 1}
                }
            },

            heli = {

                rekrut = {},

                officer = {},

                officerii = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}
                },

                sergeant = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}
                },

                sergeantii = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}
                },

                lieutenant = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}
                },

                detective = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}
                },
                
                captain = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}

                },

                commander = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}

                },

                dchief = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}

                },

                boss = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}
                }
            }
        },
    },

    ["doj"] = {
        Blip = {
            Coords = vector3(-549.92, -195.79, 38.22),
            blip = true,
			Sprite = 419,
			Display = 4,
			Scale = 0.8,
			Colour = 0,
            Text = 'Department of Justice'
        },

        -- Cloakrooms = {
        --     vector3(-1098.4225, -831.5955, 14.2828),
        --     vector3(1681.8079, 2574.3125, 45.9115)
        -- },

        Armories = {
            vector3(-570.86, -195.18, 38.17)
		},

		Vehicles = vehicleSpawns,

        Helicopters = helicopterSpawns,

        Boats = {},

		BossActions = {
            vector3(-584.55, -202.49, 42.84)
		},

        ActionMenu = {
            zivi = {
                enable = true,

                -- actions --

                identity_card = true,
                weapon_license = true,
                handcuff = true,
                search = true,
                maskoff = true,
                drag = true,
                putInVehicle = true,
                putOutVehicle = true,
                bills = true,
                speedcam = false,
                jail = true -- Jemanden ins Gefängnis bringen
            },

            ems_menu = {
                enable = false,

                -- actions --

                revive = false,
                small = false,
                big = false,
                putInVehicle = false,
                declareDead = false
            },

            object_spawner = {
                enable = true,

                -- actions --

                models = {
                    { label = 'Hütchen', model = 'prop_roadcone02a' },
                    { label = 'Barriere', model = 'prop_barrier_work05' },
                    { label = 'Nagelband', model = 'p_ld_stinger_s' },
                    { label = 'Sperre mit Pfeil', model = 'prop_mp_arrow_barrier_01' }
                }
            },

            vehicle_interaction = {
                enable = true,

                -- actions --

                vehicle_infos = true,
                hijack_vehicle = true,
                repair = false,
                wash = true,
                impound = true,
                search_database = true,
                low_loader = false,
                see_registration = true -- Zulassung sehen
            },

            license_interaction = {
                enable = true,

                -- actions -- // rank = 8 bedeutet Rang 8 und höher

                add_weapon_license = {enable = true, ranks = 8},
                remove_weapon_license = {enable = true, ranks = 6},
                add_driver_license = {enable = true, ranks = 3},
                remove_driver_license = {enable = true, ranks = 3},
                add_anwalt_license = {enable = true, ranks = 9},
                remove_anwalt_license = {enable = true, ranks = 9},
            },

            panicButton = true
        },

        permissions = {
            get_weapon = 8,
            get_object = 8
        },

        AuthorizedWeapons = {
            enable = true,

            marshalkardett = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
            },

            deputyregistrar = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
            },

            deputyprosecutor = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            deputyjudge = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            marshaldeputy = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            registrar = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            prosecutor = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            marshalagent = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            sregistrar = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            sprosecutor = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },

            judge = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
            },
      
            boss = {
                { weapon = 'WEAPON_NIGHTSTICK', price = 100 },
                { weapon = 'WEAPON_STUNGUN', price = 100 },
                { weapon = 'WEAPON_FLASHLIGHT', price = 100 },
                { weapon = 'GADGET_PARACHUTE', price = 100 },
                {weapon = 'WEAPON_COMBATPISTOL', price = 0 },
                {weapon = 'WEAPON_COMBATPDW', price = 0 },
                {weapon = 'WEAPON_SMG', price = 1 },
                {weapon = 'WEAPON_SPECIALCARBINE', price = 1 },
            }
        },

        AuthorizedItems = {
            enable = true,

            marshalkardett = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            deputyregistrar = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            
            deputyprosecutor = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            deputyjudge = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            marshaldeputy = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            registrar = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            prosecutor = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            marshalagent = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            sregistrar = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            sprosecutor = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            judge = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
            },

            boss = {
                { item = 'clip_cop', label = 'Magazin', price = 1},
                { item = 'repairkit', label = 'Reparaturkasten', price = 1},
                { item = 'bulletproof', label = 'Schusssichere Weste', price = 1 }, 
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'radar', label = 'Radargerät', price = 1 },
                { item = 'panicbutton', label = 'Panicbutton', price = 1 },
                { item = 'clip_extended', label = 'Erweitertes Magazin', price = 10000 },
                { item = 'suppressor', label = 'Schalldämpfer', price = 10000 }
            }
        },

        AuthorizedVehicles = {
            car = {   
                marshalkardett = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                deputyregistrar = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                deputyprosecutor = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                deputyjudge = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                marshaldeputy = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                registrar = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                prosecutor = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },
                marshalagent = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                sregistrar = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                sprosecutor = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },

                judge = {
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1}
                },
                
                boss = {
                    {model = 'pbus', price = 1},
                    {model = '24humev', price = 1},
                    {model = '18charger21tr', price = 1},
                    {model = '18f15021tr', price = 1},
                    {model = 'fpiu21tr', price = 1},
                    {model = 's900unmarked', price = 1},
                    {model = 'polamggtr', price = 1},
                    {model = '21yuk', price = 1},
                    {model = 'rs5', price = 1},
                    {model = 'sspres', price = 1},
                    {model = 'ucg20', price = 1},
                    {model = 'insurgent2', price = 1}
                }
            },

            heli = {
                boss = {
                    {model = 'polmav', props = {modLivery = 0}, price = 1}

                }
            }
        },
    },

    ["lsmd"] = {
        Blip = {
            Coords = vector3(315.35, -590.93, 43.28),
            blip = true,
			Sprite = 61,
			Display = 4,
			Scale = 0.8,
			Colour = 2,
            Text = 'Medical Department'
        },

		-- Cloakrooms = {
		-- 	vector3(-824.3715, -1239.1903, 7.3375),
        --     vector3(1681.8079, 2574.3125, 45.9115)
		-- },

		Armories = {
			vector3(326.54, -584.06, 43.27)
		},

		Vehicles = vehicleSpawns,

		Helicopters = helicopterSpawns,

        Boats = {},

		BossActions = {
			vector3(310.39, -567.89, 43.27)
		},

        ActionMenu = {
            zivi = {
                enable = true,

                -- actions --

                show_id = true,
                weapon_license = false,
                handcuff = true,
                search = true,
                maskoff = true,
                drag = true,
                putInVehicle = true,
                putOutVehicle = true,
                bills = true,
                jail = false -- Jemanden ins Gefängnis bringen
            },

            ems_menu = {
                enable = true,

                -- actions --

                revive = true,
                small = true,
                big = true,
                putInVehicle = true,
                declareDead = true
            },

            object_spawner = {
                enable = true,

                -- actions --

                models = {
                    { label = 'Hütchen', model = 'prop_roadcone02a' },
                    { label = 'Barriere', model = 'prop_barrier_work05' },
                    { label = 'Nagelband', model = 'p_ld_stinger_s' },
                    { label = 'Sperre mit Pfeil', model = 'prop_mp_arrow_barrier_01' }
                }
            },

            vehicle_interaction = {
                enable = false,

                -- actions --

                vehicle_infos = true,
                hijack_vehicle = true,
                repair = false,
                wash = false,
                impound = true,
                beschlagnahmen = false,
                search_database = false,
                low_loader = false,
                see_registration = false, -- Zulassung sehen
            },

            license_interaction = {
                enable = false,

                -- actions -- // rank = 8 bedeutet Rang 8 und höher

                add_weapon_license = {enable = false, ranks = 8},
                remove_weapon_license = {enable = false, ranks = 8},
                add_driver_license = {enable = false, ranks = 8},
                remove_driver_license = {enable = false, ranks = 8}
            },

            panicButton = false
        },

        permissions = {
            get_weapon = 2,
            get_object = 9
        },

        AuthorizedWeapons = {
            enable = false,

            praktikant = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },
        
            azubi = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },

            mediziner = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },
        
            notfallsani= {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },
        
            student = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },
        
            assistenzarzt = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },
        
            facharzt = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },

            oberarzt = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },

            loberarzt = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },

            chefarzt = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            },
              
            boss = {
                {weapon = 'WEAPON_STUNGUN', price = 100},
                {weapon = 'WEAPON_FLASHLIGHT', price = 100}
            }
        },

        AuthorizedItems = {
            enable = true,

            praktikant = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },

            azubi = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },

            mediziner = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },
        
            notfallsani= {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },
        
            student = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },

            assistenzarzt = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },
        
            facharzt = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },
        
            oberarzt = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },
        
            loberarzt = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },
        
            chefarzt = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            },
        
            boss = {
                { item = 'medikit', label = 'Medikit', price = 1 },
                { item = 'bandage', label = 'Bandage', price = 1 },
                { item = 'salbe', label = 'Salbe', price = 1 },
                { item = 'schmerzmittel', label = 'Schmerzmittel', price = 1 },
                { item = 'tablette', label = 'Tablette', price = 1 },
                { item = 'phone', label = 'Handy', price = 1 },
                { item = 'tablet', label = 'Tablet', price = 1 },
                { item = 'Swimsuit', label = 'Taucheranzug', price = 1 },
                { item = 'repairkit', label = 'Repairkit', price = 1 }
            }
        },

        AuthorizedVehicles = {
            car = {

                praktikant = {
                    {model = 'emstahoe', price = 1}
                },

                azubi = {
                    {model = 'emstahoe', price = 1},
                },
        
                notfallsani = {
                    {model = 'emstahoe', price = 1},
                },
        
                student = {
                    {model = 'emstahoe', price = 1},
                    {model = 'emsfpiu', price = 1}
                },
        
                assistenzarzt = {
                    {model = 'emstahoe', price = 1},
                    {model = 'emsfpiu', price = 1}
                },
        
                facharzt = {
                    {model = 'emsfpiu', price = 1},
                    {model = 'emstahoe', price = 1}
                },
        
                oberarzt = {
                    {model = 'emsfpiu', price = 1},
                    {model = 'emstahoe', price = 1},
                    {model = 'emscharger', price = 1}
                },

                loberarzt = {
                    {model = 'emsfpiu', price = 1},
                    {model = 'emstahoe', price = 1},
                    {model = 'emscharger', price = 1}
                },

                chefarzt = {
                    {model = 'emsfpiu', price = 1},
                    {model = 'emstahoe', price = 1},
                    {model = 'emscharger', price = 1}
                },
        
                boss = {
                    {model = 'emsfpiu', price = 1},
                    {model = 'emstahoe', price = 1},
                    {model = 'emscharger', price = 1}
                }
            },
        
            heli = {

                loberarzt = {
                    {model = 'polmav', price = 1}
                },
        
                chefarzt = {
                    {model = 'polmav', price = 1}
                },
        
                boss = {
                    {model = 'polmav', price = 1}
                }
            }
        }
    },
}