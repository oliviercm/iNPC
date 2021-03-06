util.AddNetworkString("iNPCPlayerChangedFaction")

RunConsoleCommand("sk_antlion_swipe_damage", "10")
RunConsoleCommand("sk_antlion_worker_spit_speed", "1200")
RunConsoleCommand("sk_antlion_worker_burst_radius", "0")
RunConsoleCommand("sk_antlion_worker_burst_damage", "0")

INPC_HEALTH_REGEN_COOLDOWN = 150

INPC_COND_SEE_ENEMY = 10
INPC_COND_TASK_FAILED = 35
INPC_COND_FLOATING_OFF_GROUND = 61

INPC_ENEMY_TOO_CLOSE_DISTANCE = 128
INPC_ENEMY_TOO_FAR_DISTANCE = 1400

INPC_NEXT_FOLLOW_TIME = 1.5
INPC_MAX_FOLLOW_DISTANCE = 256
INPC_MAX_FOLLOW_DISTANCE_IN_BATTLE = 512

inpcHealthTable = inpcHealthTable or {}
inpcHealthTable["npc_antlion"] = 60
inpcHealthTable["npc_antlion_worker"] = 120
inpcHealthTable["npc_hunter"] = 100
inpcHealthTable["npc_strider"] = 2000
inpcHealthTable["npc_turret_ceiling"] = 250

inpcCanUseSquads = inpcCanUseSquads or {}
inpcCanUseSquads["npc_clawscanner"] = true
inpcCanUseSquads["npc_combine_s"] = true
inpcCanUseSquads["npc_combinegunship"] = true
inpcCanUseSquads["npc_cscanner"] = true
inpcCanUseSquads["npc_hunter"] = true
inpcCanUseSquads["npc_manhack"] = true
inpcCanUseSquads["npc_metropolice"] = true
inpcCanUseSquads["npc_rollermine"] = true
inpcCanUseSquads["npc_stalker"] = true
inpcCanUseSquads["npc_strider"] = true
inpcCanUseSquads["npc_alyx"] = true
inpcCanUseSquads["npc_barney"] = true
inpcCanUseSquads["npc_citizen"] = true
inpcCanUseSquads["npc_eli"] = true
inpcCanUseSquads["npc_kleiner"] = true
inpcCanUseSquads["npc_magnusson"] = true
inpcCanUseSquads["npc_monk"] = true
inpcCanUseSquads["npc_mossman"] = true
inpcCanUseSquads["npc_vortigaunt"] = true
inpcCanUseSquads["npc_fastzombie"] = true
inpcCanUseSquads["npc_fastzombie_torso"] = true
inpcCanUseSquads["npc_headcrab"] = true
inpcCanUseSquads["npc_headcrab_black"] = true
inpcCanUseSquads["npc_headcrab_fast"] = true
inpcCanUseSquads["npc_zombie"] = true
inpcCanUseSquads["npc_zombie_torso"] = true
inpcCanUseSquads["npc_zombine"] = true
inpcCanUseSquads["npc_antlionguard"] = true

inpcIsInfantry = inpcIsInfantry or {}
inpcIsInfantry["npc_citizen"] = true
inpcIsInfantry["npc_combine_s"] = true
inpcIsInfantry["npc_metropolice"] = true
inpcIsInfantry["npc_alyx"] = true
inpcIsInfantry["npc_barney"] = true
inpcIsInfantry["npc_monk"] = true

inpcUseAI = inpcUseAI or {}
inpcUseAI["npc_breen"] = true
inpcUseAI["npc_clawscanner"] = true
inpcUseAI["npc_combine_s"] = true
inpcUseAI["npc_combinedropship"] = true
inpcUseAI["npc_combinegunship"] = true
inpcUseAI["npc_cscanner"] = true
inpcUseAI["npc_helicopter"] = true
inpcUseAI["npc_hunter"] = true
inpcUseAI["npc_manhack"] = true
inpcUseAI["npc_metropolice"] = true
inpcUseAI["npc_stalker"] = true
inpcUseAI["npc_strider"] = true
inpcUseAI["npc_alyx"] = true
inpcUseAI["npc_barney"] = true
inpcUseAI["npc_citizen"] = true
inpcUseAI["npc_dog"] = true
inpcUseAI["npc_eli"] = true
inpcUseAI["npc_kleiner"] = true
inpcUseAI["npc_magnusson"] = true
inpcUseAI["npc_monk"] = true
inpcUseAI["npc_mossman"] = true
inpcUseAI["npc_vortigaunt"] = true
inpcUseAI["npc_fastzombie"] = true
inpcUseAI["npc_fastzombie_torso"] = true
inpcUseAI["npc_headcrab"] = true
inpcUseAI["npc_headcrab_black"] = true
inpcUseAI["npc_headcrab_fast"] = true
inpcUseAI["npc_poisonzombie"] = true
inpcUseAI["npc_zombie"] = true
inpcUseAI["npc_zombie_torso"] = true
inpcUseAI["npc_zombine"] = true
inpcUseAI["npc_antlion"] = true
inpcUseAI["npc_antlion_worker"] = true
inpcUseAI["npc_antlionguard"] = true
inpcUseAI["npc_gman"] = true

inpcNpcDefaultFaction = inpcNpcDefaultFaction or {}
inpcNpcDefaultFaction["npc_breen"] = "overwatch"
inpcNpcDefaultFaction["npc_clawscanner"] = "overwatch"
inpcNpcDefaultFaction["npc_combine_camera"] = "overwatch"
inpcNpcDefaultFaction["npc_combine_s"] = "overwatch"
inpcNpcDefaultFaction["npc_combinedropship"] = "overwatch"
inpcNpcDefaultFaction["npc_combinegunship"] = "overwatch"
inpcNpcDefaultFaction["npc_cscanner"] = "overwatch"
inpcNpcDefaultFaction["npc_helicopter"] = "overwatch"
inpcNpcDefaultFaction["npc_hunter"] = "overwatch"
inpcNpcDefaultFaction["npc_manhack"] = "overwatch"
inpcNpcDefaultFaction["npc_metropolice"] = "overwatch"
inpcNpcDefaultFaction["npc_rollermine"] = "overwatch"
inpcNpcDefaultFaction["npc_sniper"] = "overwatch"
inpcNpcDefaultFaction["npc_stalker"] = "overwatch"
inpcNpcDefaultFaction["npc_strider"] = "overwatch"
inpcNpcDefaultFaction["npc_turret_ceiling"] = "overwatch"
inpcNpcDefaultFaction["npc_turret_floor"] = "overwatch"
inpcNpcDefaultFaction["npc_turret_ground"] = "overwatch"
inpcNpcDefaultFaction["npc_alyx"] = "resistance"
inpcNpcDefaultFaction["npc_barney"] = "resistance"
inpcNpcDefaultFaction["npc_citizen"] = "resistance"
inpcNpcDefaultFaction["npc_dog"] = "resistance"
inpcNpcDefaultFaction["npc_eli"] = "resistance"
inpcNpcDefaultFaction["npc_kleiner"] = "resistance"
inpcNpcDefaultFaction["npc_magnusson"] = "resistance"
inpcNpcDefaultFaction["npc_monk"] = "resistance"
inpcNpcDefaultFaction["npc_mossman"] = "resistance"
inpcNpcDefaultFaction["npc_vortigaunt"] = "resistance"
inpcNpcDefaultFaction["npc_fastzombie"] = "zombies"
inpcNpcDefaultFaction["npc_fastzombie_torso"] = "zombies"
inpcNpcDefaultFaction["npc_headcrab"] = "zombies"
inpcNpcDefaultFaction["npc_headcrab_black"] = "zombies"
inpcNpcDefaultFaction["npc_headcrab_fast"] = "zombies"
inpcNpcDefaultFaction["npc_poisonzombie"] = "zombies"
inpcNpcDefaultFaction["npc_zombie"] = "zombies"
inpcNpcDefaultFaction["npc_zombie_torso"] = "zombies"
inpcNpcDefaultFaction["npc_zombine"] = "zombies"
inpcNpcDefaultFaction["npc_antlion"] = "antlions"
inpcNpcDefaultFaction["npc_antlion_worker"] = "antlions"
inpcNpcDefaultFaction["npc_antlionguard"] = "antlions"
inpcNpcDefaultFaction["npc_gman"] = "neutral"

inpcPlayermodelFaction = inpcPlayermodelFaction or {}
inpcPlayermodelFaction["breen"] = "overwatch"
inpcPlayermodelFaction["combine_soldier"] = "overwatch"
inpcPlayermodelFaction["combine_soldier_prisonguard"] = "overwatch"
inpcPlayermodelFaction["combine_super_soldier"] = "overwatch"
inpcPlayermodelFaction["police"] = "overwatch"
inpcPlayermodelFaction["police_fem"] = "overwatch"
inpcPlayermodelFaction["soldier_stripped"] = "overwatch"
inpcPlayermodelFaction["alyx"] = "resistance"
inpcPlayermodelFaction["barney"] = "resistance"
inpcPlayermodelFaction["eli"] = "resistance"
inpcPlayermodelFaction["kleiner"] = "resistance"
inpcPlayermodelFaction["magnusson"] = "resistance"
inpcPlayermodelFaction["monk"] = "resistance"
inpcPlayermodelFaction["mossman"] = "resistance"
inpcPlayermodelFaction["mossman_arctic"] = "resistance"
inpcPlayermodelFaction["odessa"] = "resistance"
inpcPlayermodelFaction["group01/female_01"] = "resistance"
inpcPlayermodelFaction["group01/female_02"] = "resistance"
inpcPlayermodelFaction["group01/female_03"] = "resistance"
inpcPlayermodelFaction["group01/female_04"] = "resistance"
inpcPlayermodelFaction["group01/female_05"] = "resistance"
inpcPlayermodelFaction["group01/female_06"] = "resistance"
inpcPlayermodelFaction["group03/female_01"] = "resistance"
inpcPlayermodelFaction["group03/female_02"] = "resistance"
inpcPlayermodelFaction["group03/female_03"] = "resistance"
inpcPlayermodelFaction["group03/female_04"] = "resistance"
inpcPlayermodelFaction["group03/female_05"] = "resistance"
inpcPlayermodelFaction["group03/female_06"] = "resistance"
inpcPlayermodelFaction["group03m/female_01"] = "resistance"
inpcPlayermodelFaction["group03m/female_02"] = "resistance"
inpcPlayermodelFaction["group03m/female_03"] = "resistance"
inpcPlayermodelFaction["group03m/female_04"] = "resistance"
inpcPlayermodelFaction["group03m/female_05"] = "resistance"
inpcPlayermodelFaction["group03m/female_06"] = "resistance"
inpcPlayermodelFaction["group01/male_01"] = "resistance"
inpcPlayermodelFaction["group01/male_02"] = "resistance"
inpcPlayermodelFaction["group01/male_03"] = "resistance"
inpcPlayermodelFaction["group01/male_04"] = "resistance"
inpcPlayermodelFaction["group01/male_05"] = "resistance"
inpcPlayermodelFaction["group01/male_06"] = "resistance"
inpcPlayermodelFaction["group01/male_07"] = "resistance"
inpcPlayermodelFaction["group01/male_08"] = "resistance"
inpcPlayermodelFaction["group01/male_09"] = "resistance"
inpcPlayermodelFaction["group03/male_01"] = "resistance"
inpcPlayermodelFaction["group03/male_02"] = "resistance"
inpcPlayermodelFaction["group03/male_03"] = "resistance"
inpcPlayermodelFaction["group03/male_04"] = "resistance"
inpcPlayermodelFaction["group03/male_05"] = "resistance"
inpcPlayermodelFaction["group03/male_06"] = "resistance"
inpcPlayermodelFaction["group03/male_07"] = "resistance"
inpcPlayermodelFaction["group03/male_08"] = "resistance"
inpcPlayermodelFaction["group03/male_09"] = "resistance"
inpcPlayermodelFaction["group03m/male_01"] = "resistance"
inpcPlayermodelFaction["group03m/male_02"] = "resistance"
inpcPlayermodelFaction["group03m/male_03"] = "resistance"
inpcPlayermodelFaction["group03m/male_04"] = "resistance"
inpcPlayermodelFaction["group03m/male_05"] = "resistance"
inpcPlayermodelFaction["group03m/male_06"] = "resistance"
inpcPlayermodelFaction["group03m/male_07"] = "resistance"
inpcPlayermodelFaction["group03m/male_08"] = "resistance"
inpcPlayermodelFaction["group03m/male_09"] = "resistance"
inpcPlayermodelFaction["group02/male_02"] = "resistance"
inpcPlayermodelFaction["group02/male_04"] = "resistance"
inpcPlayermodelFaction["group02/male_06"] = "resistance"
inpcPlayermodelFaction["group02/male_08"] = "resistance"
inpcPlayermodelFaction["corpse1"] = "zombies"
inpcPlayermodelFaction["charple"] = "zombies"
inpcPlayermodelFaction["skeleton"] = "zombies"
inpcPlayermodelFaction["zombie_classic"] = "zombies"
inpcPlayermodelFaction["zombie_fast"] = "zombies"
inpcPlayermodelFaction["zombie_soldier"] = "zombies"
inpcPlayermodelFaction["gman_high"] = "neutral"