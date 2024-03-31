Config.DefaultWeaponTints = {
	[0] = 'standard',
	[1] = 'grün',
	[2] = 'gold',
	[3] = 'pink',
	[4] = 'camouflage',
	[5] = 'blau',
	[6] = 'orange',
	[7] = 'platin'
}

Config.MkWeaponTints = {
	 
	[0] = 'Klassisches Schwarz',
	[1] = 'Klassisches Grau',
	[2] = 'Klassisch Schwarz weiß',
	[3] = 'Klassisches Weiß',
	[4] = 'Klassisches Beige',
	[5] = 'Classic Green',
	[6] = 'Klassisches Blau',
	[7] = 'Classic Earth',
	[8] = 'Klassisches Braun und Schwarz',
	[9] = 'Roter Kontrast',
	[10] = 'Blauer Kontrast',
	[11] = 'Gelber Kontrast',
	[12] = 'Orange Kontrast',
	[13] = 'Bold Pink',
	[14] = 'Kräftiges Lila und Gelb',
	[15] = 'Fettes Orange',
	[16] = 'Kräftiges Grün und Lila',
	[17] = 'Rot Features',
	[18] = 'Grün Features',
	[19] = 'Cyan Features',
	[20] = 'Fettgelbe Merkmale',
	[21] = 'Kräftiges Rot und Weiß',
	[22] = 'Kräftiges Blau und Weiß',
	[23] = 'Metallisches Gold',
	[24] = 'Metallic Platinum',
	[25] = 'Metallic Grau und Lila',
	[26] = 'Metallic Purple & Lime',
	[27] = 'Metallic Rot',
	[28] = 'Metallic Grün',
	[29] = 'Metallic Blau',
	[30] = 'Metallic Weiß und Aqua',
	[31] = 'Metallic Rot und Gelb'	
}

Config.Weapons = {
	{
		name = 'WEAPON_PISTOL',
		label = 'Pistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_PISTOL_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_PISTOL_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_PISTOL_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_PISTOL_MK2',
		label = 'Pistol MK2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH_02')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP_02')},
			{name = 'mounted_scope', label = 'Mounted Scope', hash = GetHashKey('COMPONENT_AT_PI_RAIL')},
			{name = 'compensator', label = 'Compensator', hash = GetHashKey('COMPONENT_AT_PI_COMP')}
		}
	},

	{
		name = 'WEAPON_COMBATPISTOL',
		label = 'Kampfpistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER')}
		}
	},

	{
		name = 'WEAPON_APPISTOL',
		label = 'AP Pistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_APPISTOL_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_APPISTOL_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_APPISTOL_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_PISTOL50',
		label = 'Pistole .50',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_PISTOL50_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_PISTOL50_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_PISTOL50_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_SNSPISTOL',
		label = 'SNS Pistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_SNSPISTOL_VARMOD_LOWRIDER')}
		}
	},

	{
		name = 'WEAPON_SNSPISTOL_MK2',
		label = 'SNS Pistole MK2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH_03')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP_02')},
			{name = 'mounted_scope', label = 'Mounted Scope', hash = GetHashKey('COMPONENT_AT_PI_RAIL_02')},
			{name = 'compensator', label = 'Compensator', hash = GetHashKey('COMPONENT_AT_PI_COMP_02')}
		}
	},

	{
		name = 'WEAPON_HEAVYPISTOL',
		label = 'Schwere Pistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_HEAVYPISTOL_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_VINTAGEPISTOL',
		label = 'Vintage Pistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_02')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP')}
		}
	},

	{
		name = 'WEAPON_MACHINEPISTOL',
		label = 'Maschinenpistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_02')},
			{name = 'clip_drum', label = 'trommelmagazin', hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_03')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP')}
		}
	},

	{
		name = 'WEAPON_REVOLVER_MK2',
		label = 'Heavy Revolver MK2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'default_rounds', label = 'Default Rounds', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_01')},
			{name = 'compensator', label = 'Compensator', hash = GetHashKey('COMPONENT_AT_PI_COMP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2')}
		}
	},

	{name = 'WEAPON_REVOLVER', label = 'Schwerer Revolver', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')}},
	{name = 'WEAPON_MARKSMANPISTOL', label = 'Marksman Pistole', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')}},
	{name = 'WEAPON_DOUBLEACTION', label = 'double-Action Revolver', components = {}, ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')}},

	{
		name = 'WEAPON_SMG',
		label = 'SMG',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SMG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_SMG_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_SMG_CLIP_02')},
			{name = 'clip_drum', label = 'trommelmagazin', hash = GetHashKey('COMPONENT_SMG_CLIP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_SMG_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_SMG_MK2',
		label = 'SMG MK2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SMG')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
			{name = 'heavy_barrel', label = 'Heavy Barrel', hash = GetHashKey('COMPONENT_AT_SB_BARREL_02')}
		}
	},

	{
		name = 'WEAPON_ASSAULTSMG',
		label = 'Kampf SMG',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SMG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER')}
		}
	},

	{
		name = 'WEAPON_MICROSMG',
		label = 'Mikro SMG',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SMG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_MICROSMG_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_MICROSMG_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_MICROSMG_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_MINISMG',
		label = 'Mini SMG',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SMG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_MINISMG_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_MINISMG_CLIP_02')}
		}
	},

	{
		name = 'WEAPON_COMBATPDW',
		label = 'Kampf PDW',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SMG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_01')},
			{name = 'clip_extended', label = 'Magazin', hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_02')},
			{name = 'clip_drum', label = 'trommelmagazin', hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')}
		}
	},

	{
		name = 'WEAPON_PUMPSHOTGUN',
		label = 'Pumpgun',
		ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_SR_SUPP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER')}
		}
	},
	
	{
		name = 'WEAPON_PUMPSHOTGUN_MK2',
		label = 'Pumpgun MK2',
		ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_SR_SUPP_03')}
		}
	},

	{
		name = 'WEAPON_SAWNOFFSHOTGUN',
		label = 'Abgesägte Schrotflinte',
		ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_ASSAULTSHOTGUN',
		label = 'Kampf Schrotflinte',
		ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')}
		}
	},

	{
		name = 'WEAPON_BULLPUPSHOTGUN',
		label = 'Bullpup Schrotflinte',
		ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')}
		}
	},

	{
		name = 'WEAPON_HEAVYSHOTGUN',
		label = 'Schwere Schrotflinte',
		ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_02')},
			{name = 'clip_drum', label = 'trommelmagazin', hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')}
		}
	},

	{name = 'WEAPON_DBSHOTGUN', label = 'Doppelläufige Schrotflinte', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')}},
	{name = 'WEAPON_AUTOSHOTGUN', label = 'Auto Schrotflinte', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'schrotpatrone(n)', hash = GetHashKey('AMMO_SHOTGUN')}},
	{name = 'WEAPON_MUSKET', label = 'Muskete', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SHOTGUN')}},

	{
		name = 'WEAPON_ASSAULTRIFLE',
		label = 'Kampfgewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02')},
			{name = 'clip_drum', label = 'trommelmagazin', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_MILITARYRIFLE',
		label = 'Militärgewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_MILITARYRIFLE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_MILITARYRIFLE_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_SPECIALCARBINE_MK2',
		label = 'Spezial Karabiner Mk2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SIGHTS')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO')}
		}
	},
	
	{
		name = 'WEAPON_HEAVYSNIPER_MK2',
		label = 'Schwere Sniper Mk2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_02')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_THERMAL')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_SR_SUPP_03')},
		}
	},

	{
		name = 'WEAPON_CARBINERIFLE',
		label = 'Karabinergewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02')},
			{name = 'clip_box', label = 'kastenmagazin', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_CARBINERIFLE_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_CARBINERIFLE_MK2',
		label = 'Karabinergewehr Mk2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_02')},
			-- {name = 'clip_box', label = 'kastenmagazin', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_CARBINERIFLE_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_ADVANCEDRIFLE',
		label = 'Advancedgewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_SPECIALCARBINE',
		label = 'Spezialkarabiner',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_02')},
			{name = 'clip_drum', label = 'trommelmagazin', hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_03')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER')}
		}
	},

	{
		name = 'WEAPON_BULLPUPRIFLE',
		label = 'Bullpupgewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_VARMOD_LOW')}
		}
	},
	{
		name = 'WEAPON_BULLPUPRIFLE_MK2',
		label = 'Bullpupgewehr Mk2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_VARMOD_LOW')}
		}
	},

	{
		name = 'WEAPON_COMPACTRIFLE',
		label = 'Kampfgewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_02')},
			{name = 'clip_drum', label = 'trommelmagazin', hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_03')}
		}
	},

	{
		name = 'WEAPON_HEAVYRIFLE',
		label = 'Schweres Gewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RIFLE')},
		tints = Config.DefaultWeaponTints,
		components = {}
	},

	{
		name = 'WEAPON_NAVYREVOLVER',
		label = 'Navy Revolver',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {}
	},

	{
		name = 'WEAPON_MG',
		label = 'MG',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_MG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_MG_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_MG_CLIP_02')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_MG_VARMOD_LOWRIDER')}
		}
	},

	{
		name = 'WEAPON_COMBATMG',
		label = 'Kampf MG',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_MG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_COMBATMG_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_COMBATMG_CLIP_02')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_COMBATMG_VARMOD_LOWRIDER')}
		}
	},

	{
		name = 'WEAPON_COMBATMG_MK2',
		label = 'Kampf MG MK2',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_MG')},
		tints = Config.MkWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_02')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
			{name = 'heavy_barrel', label = 'Heavy Barrel', hash = GetHashKey('COMPONENT_AT_MG_BARREL_02')}
		}
	},

	{
		name = 'WEAPON_GUSENBERG',
		label = 'Gusenberg',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_MG')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_02')},
		}
	},

	{
		name = 'WEAPON_SNIPERRIFLE',
		label = 'Scharfschützengewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SNIPER')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE')},
			{name = 'scope_advanced', label = 'erweitertes Zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MAX')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_SNIPERRIFLE_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_HEAVYSNIPER',
		label = 'Schweres Sniper',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SNIPER')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE')},
			{name = 'scope_advanced', label = 'erweitertes Zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_MAX')}
		}
	},

	{
		name = 'WEAPON_MARKSMANRIFLE',
		label = 'Marksmangewehr',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_SNIPER')},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = 'Standart Griff', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_01')},
			{name = 'clip_extended', label = 'Erweiterter Griff', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_02')},
			{name = 'flashlight', label = 'Taschenlampe', hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
			{name = 'scope', label = 'zielfernrohr', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM')},
			{name = 'suppressor', label = 'Schalldämpfer', hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
			{name = 'grip', label = 'griff', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
			{name = 'luxary_finish', label = 'Luxus Waffen Design', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_VARMOD_LUXE')}
		}
	},

	{
		name = 'WEAPON_RAYPISTOL',
		label = 'Alienpistole',
		ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_PISTOL')},
		tints = Config.DefaultWeaponTints,
		components = {}
	},

	{name = 'WEAPON_MINIGUN', label = 'Minigun', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_MINIGUN')}},
	{name = 'WEAPON_RAILGUN', label = 'Railgun', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'kugel(n)', hash = GetHashKey('AMMO_RAILGUN')}},
	{name = 'WEAPON_STUNGUN', label = 'Tazer', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_RPG', label = 'RPG', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'rakete(n)', hash = GetHashKey('AMMO_RPG')}},
	{name = 'WEAPON_HOMINGLAUNCHER', label = 'Homing Launcher', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'rakete(n)', hash = GetHashKey('AMMO_HOMINGLAUNCHER')}},
	{name = 'WEAPON_GRENADELAUNCHER', label = 'Granatwerfer', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'granate(n)', hash = GetHashKey('AMMO_GRENADELAUNCHER')}},
	{name = 'WEAPON_COMPACTLAUNCHER', label = 'Kompakt Granatwerfer', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'granate(n)', hash = GetHashKey('AMMO_GRENADELAUNCHER')}},
	{name = 'WEAPON_FLAREGUN', label = 'Leuchtpistole', tints = Config.DefaultWeaponTints, components = {}, ammo = {label = 'signalfackeln(munition)', hash = GetHashKey('AMMO_FLAREGUN')}},
	{name = 'WEAPON_FIREEXTINGUISHER', label = 'Feuerlöscher', components = {}, ammo = {label = 'Ladung', hash = GetHashKey('AMMO_FIREEXTINGUISHER')}},
	{name = 'WEAPON_PETROLCAN', label = 'Benzinkanister', components = {}, ammo = {label = 'liter Benzin', hash = GetHashKey('AMMO_PETROLCAN')}},
	{name = 'WEAPON_FIREWORK', label = 'Feuerwerk', components = {}, ammo = {label = 'feuerwerksrakete(n)', hash = GetHashKey('AMMO_FIREWORK')}},
	{name = 'WEAPON_FLASHLIGHT', label = 'Taschenlampe', components = {}},
	{name = 'GADGET_PARACHUTE', label = 'Fallschirm', components = {}},
	{name = 'WEAPON_KNUCKLE', label = 'Schlagring', components = {}},
	{name = 'WEAPON_HATCHET', label = 'Axt', components = {}},
	{name = 'WEAPON_MACHETE', label = 'Machete', components = {}},
	{name = 'WEAPON_SWITCHBLADE', label = 'Klappmesser', components = {}},
	{name = 'WEAPON_BOTTLE', label = 'Flasche', components = {}},
	{name = 'WEAPON_DAGGER', label = 'Dolch', components = {}},
	{name = 'WEAPON_POOLCUE', label = 'Billiard-Kö', components = {}},
	{name = 'WEAPON_WRENCH', label = 'Rohrzange', components = {}},
	{name = 'WEAPON_BATTLEAXE', label = 'Kampfaxt', components = {}},
	{name = 'WEAPON_KNIFE', label = 'Messer', components = {}},
	{name = 'WEAPON_NIGHTSTICK', label = 'Schlagstock', components = {}},
	{name = 'WEAPON_HAMMER', label = 'Hammer', components = {}},
	{name = 'WEAPON_BAT', label = 'Schläger', components = {}},
	{name = 'WEAPON_GOLFCLUB', label = 'Golfschläger', components = {}},
	{name = 'WEAPON_CROWBAR', label = 'Brecheisen', components = {}},
	{name = 'WEAPON_STONE_HATCHET', label = 'Stein Axt', components = {}},
	
	--Visky Addon Weapons Integration
	{name = 'APOKATANA', label = 'Katana', components = {}},
	{name = 'CHAINKNIFE', label = 'Altes Messer', components = {}},
	{name = 'HANDMADEAXE', label = 'Selbstgemachte Axt', components = {}},
	{name = 'TUBEAXE', label = 'Rohr Axt', components = {}},
	{name = 'TUBEPICKAXE', label = 'Eispickel', components = {}},

	{name = 'WEAPON_GRENADE', label = 'Granate', components = {}, ammo = {label = 'granate(n)', hash = GetHashKey('AMMO_GRENADE')}},
	{name = 'WEAPON_SMOKEGRENADE', label = 'Rauchgranate', components = {}, ammo = {label = 'bombe(n)', hash = GetHashKey('AMMO_SMOKEGRENADE')}},
	{name = 'WEAPON_STICKYBOMB', label = 'Haftbombe', components = {}, ammo = {label = 'bombe(n)', hash = GetHashKey('AMMO_STICKYBOMB')}},
	{name = 'WEAPON_PIPEBOMB', label = 'Rohrbombe', components = {}, ammo = {label = 'bombe(n)', hash = GetHashKey('AMMO_PIPEBOMB')}},
	{name = 'WEAPON_BZGAS', label = 'BZ Gas', components = {}, ammo = {label = 'can(n)', hash = GetHashKey('AMMO_BZGAS')}},
	{name = 'WEAPON_MOLOTOV', label = 'Molotov Cocktail', components = {}, ammo = {label = 'cocktail(s)', hash = GetHashKey('AMMO_MOLOTOV')}},
	{name = 'WEAPON_PROXMINE', label = 'Annäherungsmine', components = {}, ammo = {label = 'mine(n)', hash = GetHashKey('AMMO_PROXMINE')}},
	{name = 'WEAPON_SNOWBALL', label = 'Schneeball', components = {}, ammo = {label = 'schneebälle', hash = GetHashKey('AMMO_SNOWBALL')}},
	{name = 'WEAPON_BALL', label = 'Ball', components = {}, ammo = {label = 'ball', hash = GetHashKey('AMMO_BALL')}},
	{name = 'WEAPON_FLARE', label = 'Leuchtfakel', components = {}, ammo = {label = 'signalfackel(n)', hash = GetHashKey('AMMO_FLARE')}},
}