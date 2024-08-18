local cfg = {}

cfg.freeArmour = false -- set to true to disable armour cost

cfg.GunStores={
    ["policeLargeArms"]={
        ["_config"]={{vector3(1840.6104736328,3691.4741210938,33.350730895996),vector3(461.43179321289,-982.66412353516,29.689668655396),vector3(-437.9034, 5988.211, 30.73618),vector3(-1102.5059814453,-820.62091064453,13.282785415649)},110,5,"MET Police Large Arms",{"police.onduty.permission","police.loadshop2"},false,true}, 
        ["WEAPON_FLASHBANG"]={"Flashbang",0,0,"N/A","w_ex_flashbang"},
        ["WEAPON_G36K"]={"G36K",0,0,"N/A","w_ar_g36k"}, 
        ["WEAPON_M4A1"]={"M4 Carbine",0,0,"N/A","w_ar_m4a1"}, 
        ["WEAPON_MP5"]={"MP5",0,0,"N/A","w_sb_mp5"},
        ["WEAPON_REMINGTON700"]={"Remington 700",0,0,"N/A","w_sr_remington700"}, 
        ["WEAPON_SIGMCX"]={"SigMCX",0,0,"N/A","w_ar_sigmcx"},
        ["WEAPON_SMOKEGRENADE"]={"Smoke Grenade",0,0,"N/A","w_ex_smokegrenade"},
        ["WEAPON_SPAR17"]={"SPAR17",0,0,"N/A","w_ar_spar17"},
        ["WEAPON_STING"]={"Sting 9mm",0,0,"N/A","w_sb_sting"},
    },
    ["policeSmallArms"]={
        ["_config"]={{vector3(461.53082275391,-979.35876464844,29.689668655396),vector3(1842.9096679688,3690.7692871094,33.267082214355),vector3(-439.7851, 5992.254, 30.73618),vector3(-1104.5264892578,-821.70153808594,13.282785415649)},110,5,"MET Police Small Arms",{"police.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_REMINGTON870"]={"Remington 870",0,0,"N/A","w_sg_remington870"},
        ["WEAPON_STAFFGUN"]={"Speed Gun",0,0,"N/A","w_pi_staffgun"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
        -- ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
        ["item|pd_armour_plate"]={"Police Armour Plate",100000,0,"N/A","prop_armour_pickup"},
    },
    ["prisonArmoury"]={
        ["_config"]={{vector3(1779.3741455078,2542.5639648438,44.8177828979)},110,5,"Prison Armoury",{"prisonguard.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_NONLETHALSHOTGUN"]={"HMP NonLethal Shotgun",0,0,"N/A","w_sg_nonlethalmossberg"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
        -- ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
    },
    ["NHS"]={
        ["_config"]={{vector3(340.41757202148,-582.71209716797,27.973259765625),vector3(-435.27032470703,-318.29010009766,34.08971484375)},110,5,"NHS Armoury",{"nhs.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        -- ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
    },
    ["LFB"]={
        ["_config"]={{vector3(1210.193359375,-1484.1494140625,34.241326171875),vector3(216.63296508789,-1648.6680908203,29.0179375)},110,5,"LFB Armoury",{"lfb.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_FIREAXE"]={"Fireaxe",0,0,"N/A","w_me_fireaxe"},
        -- ["WEAPON_PAVA"]={"PAVA",0,0,"N/A","w_am_pava"},
    },
    ["VIP"]={
        ["_config"]={{vector3(-2151.5739746094,5191.2548828125,14.718822479248)},110,5,"VIP Gun Store",{"vip.gunstore"},true},
        ["WEAPON_GOLDAK"]={"Golden AK-47",750000,0,"N/A","w_ar_goldak"},
        ["WEAPON_FIREEXTINGUISHER"]={"Fire Extinguisher",10000,0,"N/A","prop_fire_exting_1b"},
        ["WEAPON_MJOLNIR"]={"Mjlonir",10000,0,"N/A","w_me_mjolnir"},
        --["WEAPON_MOLOTOV"]={"Molotov Cocktail",5000,0,"N/A","w_ex_molotov"},
        ["WEAPON_SMOKEGRENADE"]={"Smoke Grenade",5000,0,"N/A","w_ex_smokegrenade"},
        ["WEAPON_SNOWBALL"]={"Snowball",10000,0,"N/A","w_ex_snowball"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup",nil,25000},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02",nil,50000},
    },
    ["Rebel"]={
        ["_config"]={{vector3(1545.2521972656,6331.5615234375,23.07857131958),vector3(4925.6259765625,-5243.0908203125,1.524599313736)},110,5,"Rebel Gun Store",{"rebellicense.whitelisted"},true},
        ["GADGET_PARACHUTE"]={"Parachute",1000,0,"N/A","p_parachute_s"},
        ["WEAPON_AK200"]={"AK-200",750000,0,"N/A","w_ar_akkal"},
        ["WEAPON_AKM"]={"AKM",700000,0,"N/A","w_ar_akm"},
        ["WEAPON_REVOLVER357"]={"Rebel Revolver",200000,0,"N/A","w_pi_revolver357"},
        ["WEAPON_SPAZ"]={"Spaz 12",400000,0,"N/A","w_sg_spaz"},
        ["WEAPON_WINCHESTER12"]={"Winchester 12",350000,0,"N/A","w_sg_winchester12"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
        ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
        ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
        ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
    },
    ["LargeArmsDealer"]={
        ["_config"]={{vector3(-1108.3199462891,4934.7392578125,217.35540771484),vector3(5065.6201171875,-4591.3857421875,1.8652405738831)},110,1,"Large Arms Dealer",{"gang.whitelisted"},false},
        ["WEAPON_MOSIN"]={"Mosin Bolt-Action",950000,0,"N/A","w_ar_mosin",nil,950000},
        ["WEAPON_OLYMPIA"]={"Olympia Shotgun",400000,0,"N/A","w_sg_olympia",nil,400000},
        ["WEAPON_UMP45"]={"UMP45 SMG",300000,0,"N/A","w_sb_ump45",nil,300000},
        ["WEAPON_UZI"]={"Uzi SMG",250000,0,"N/A","w_sb_uzi",nil,250000},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup",nil,25000},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02",nil,50000},
    },
    ["SmallArmsDealer"]={
        ["_config"]={{vector3(2437.5708007813,4966.5610351563,41.34761428833),vector3(-1500.4978027344,-216.72758483887,46.889373779297),vector3(1242.791,-426.7525,67.93467)},110,1,"Small Arms Dealer",{""},true},
        ["WEAPON_BERETTA"]={"Berreta M9 Pistol",60000,0,"N/A","w_pi_beretta"},
        ["WEAPON_M1911"]={"M1911 Pistol",60000,0,"N/A","w_pi_m1911"},
        ["WEAPON_MPX"]={"MPX",300000,0,"N/A","w_ar_mpx"},
        ["WEAPON_PYTHON"]={"Python .357 Revolver",50000,0,"N/A","w_pi_python"},
        ["WEAPON_ROOK"]={"Rook 9mm",60000,0,"N/A","w_pi_rook"},
        ["WEAPON_TEC9"]={"Tec-9",50000,0,"N/A","w_sb_tec9"},
        ["WEAPON_UMP45"]={"UMP-45",300000,0,"N/A","w_sb_ump45"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
    },
    ["Legion"]={
        ["_config"]={{vector3(-3171.5241699219,1087.5402832031,19.838747024536),vector3(-330.56484985352,6083.6059570312,30.454759597778),vector3(2567.6704101562,294.36923217773,107.70868457031)},154,1,"B&Q Tool Shop",{""},true},
        ["WEAPON_BROOM"]={"Broom",2500,0,"N/A","w_me_broom"},
        ["WEAPON_BASEBALLBAT"]={"Baseball Bat",2500,0,"N/A","w_me_baseballbat"},
        ["WEAPON_MACHETE2"]={"Machete",7500,0,"N/A","w_me_machete2"},
        ["WEAPON_CLEAVER"]={"Cleaver",7500,0,"N/A","w_me_cleaver"},
        ["WEAPON_CRICKETBAT"]={"Cricket Bat",2500,0,"N/A","w_me_cricketbat"},
        ["WEAPON_DILDO"]={"Dildo",2500,0,"N/A","w_me_dildo"},
        ["WEAPON_FIREAXE"]={"Fireaxe",2500,0,"N/A","w_me_fireaxe"},
        ["WEAPON_GUITAR"]={"Guitar",2500,0,"N/A","w_me_guitar"},
        ["WEAPON_HAMAXEHAM"]={"Hammer Axe Hammer",2500,0,"N/A","w_me_hamaxeham"},
        ["WEAPON_KITCHENKNIFE"]={"Kitchen Knife",7500,0,"N/A","w_me_kitchenknife"},
        ["WEAPON_SHANK"]={"Shank",7500,0,"N/A","w_me_shank"},
        ["WEAPON_SLEDGEHAMMER"]={"Sledge Hammer",2500,0,"N/A","w_me_sledgehammer"},
        ["WEAPON_TOILETBRUSH"]={"Toilet Brush",2500,0,"N/A","w_me_toiletbrush"},
        ["WEAPON_TRAFFICSIGN"]={"Traffic Sign",2500,0,"N/A","w_me_trafficsign"},
        ["WEAPON_SHOVEL"]={"Shovel",2500,0,"N/A","w_me_shovel"},
        ["WEAPON_CROWBAR"]={"Crowbar",50000,0,"N/A","w_me_crowbar"},
    },
}

cfg.whitelistedGuns = {
    -- [gunstore] = 
    -- {
    --     [SPAWNCODE] = {NAME, Price, AmmoPrice, "N/A", Model, OwnerID}
    -- }
    ["policeLargeArms"]={
        ["WEAPON_AX50"]={"AX 50",0,0,"N/A","w_sr_ax50",1},
        ["WEAPON_MK18V2"]={"MK18 V2",0,0,"N/A","w_ar_mk18v2",33},
        ["WEAPON_NOVESKENSR9"]={"Noveske NSR-9",0,0,"N/A","w_ar_noveskensr9",1},
    },
    ["LargeArmsDealer"] = {
        ["WEAPON_MP5TEMPER"]={"Tempered MP5",400000,0,"N/A","w_sb_mp5temper",929,400000},
        ["WEAPON_VITYAZ"]={"Vityaz",400000,0,"N/A","w_sb_vityaz",778,400000},
        ["WEAPON_PQ15"]={"AN PQ-15",750000,0,"N/A","w_ar_pq15",2142,750000},
        ["WEAPON_CBHONEYBADGER"]={"CB Honey Badger",400000,0,"N/A","w_sb_cbhoneybadger",5,400000},
        ["WEAPON_ANIMEM16"]={"uwu ar",750000,0,"N/A","w_ar_animem16",1,750000},
        ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",750000,0,"N/A","w_ar_m4a1spurple",929,750000},
        ["WEAPON_MP5K"]={"MP5K",400000,0,"N/A","w_sb_mp5k",5,400000},
        ["WEAPON_UMPV2NEONOIR"]={"UMP-45 Neo Noir",400000,0,"N/A","w_sb_umpv2neonoir",3542,400000},
        ["WEAPON_WESTYARES"]={"Westy Ares",3000000,0,"N/A","w_mg_westyares",1098,3000000},
        ["WEAPON_KYVESINGULARITY"]={"Kyve Singularity",3000000,0,"N/A","w_mg_kyvesingularity",794,3000000},
        ["WEAPON_M249PLAYMAKER"]={"M249 Playmaker",3000000,0,"N/A","w_mg_m249playmaker",1,3000000},
        ["WEAPON_BARRET50"]={"Barret 50.CAL",4000000,0,"N/A","w_sr_barret50cal",2142,4000000},
        ["WEAPON_CYBERSMG"]={"Cyber SMG",400000,0,"N/A","w_sb_cybersmg",217,400000},
        ["WEAPON_TOYM16"]={"Toy M16",750000,0,"N/A","w_ar_toym16",1931,750000},
        ["WEAPON_LILUZI"]={"Lil Uzi",400000,0,"N/A","w_sb_liluzi",9,400000},
        ["WEAPON_BLACKICEMOSIN"]={"Black Ice Mosin",950000,0,"N/A","w_sr_blackicemosin",3,950000},
    },
    ["SmallArmsDealer"] = {
        ["WEAPON_SUPDEAGLE"]={"Supreme Deagle",100000,0,"N/A","w_pi_supdeagle",3},
        ["WEAPON_PUNISHER1911"]={"Punisher 1911",80000,0,"N/A","w_pi_punisher1911",778},
        ["WEAPON_PT92"]={"PT92",80000,0,"N/A","w_pi_pt92",116},
    },
    ["Legion"] = {
        ["WEAPON_LIGHTSABER"]={"Lightsaber",10000,0,"N/A","w_me_lightsaber",1},
        ["WEAPON_MEDIVALSWORD"]={"Medieval Sword",10000,0,"N/A","w_me_medivalsword",4519},
    },
}

cfg.VIPWithPlat = {
    ["item|civ_radio"]={"Civilian Radio",10000,0,"N/A",""},
    ["item|Morphine"]={"Morphine",50000,0,"N/A",""},
    ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
    ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
    ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
    ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
    ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
}

cfg.RebelWithAdvanced = {
    ["WEAPON_MXM"]={"MXM",850000,0,"N/A","w_ar_mxm"},
    ["WEAPON_MK1EMR"]={"MK1 EMR",850000,0,"N/A","w_ar_mk1emr"},
    ["WEAPON_SPAR16"]={"Spar 16",900000,0,"N/A","w_ar_spar16"},
    ["WEAPON_SVD"]={"Dragunov SVD",4000000,0,"N/A","w_sr_svd"},
    ["WEAPON_MK14"]={"MK14",2500000,0,"N/A","w_sr_mk14"},
    ["item|armour_plate"]={"Armour Plate",100000,0,"N/A","prop_armour_pickup"},
}

cfg.items = {
    {item = "armour_plate", weight = 15},
    {item = "pd_armour_plate", weight = 15},
    {item = "Morphine", weight = 1},
    {item = "civ_radio", weight = 0.2},
}

return cfg
