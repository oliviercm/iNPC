local function populateInpcAdminToolPanel(dform)
	
	dform:CheckBox("Enabled", "inpc_enabled")
	
	dform:Help("NPC Proficiency: How accurate should NPCs be?")
	local cbox = dform:ComboBox("NPC Proficiency", "inpc_weaponproficiency")
	cbox:AddChoice("Default", -1)
	cbox:AddChoice("0 - Poor", 0)
	cbox:AddChoice("1 - Average", 1)
	cbox:AddChoice("2 - Good", 2)
	cbox:AddChoice("3 - Very Good", 3)
	cbox:AddChoice("4 - Perfect", 4)

	dform:Help("Enable Factions: Enable/disable all NPC factions features.")
	dform:CheckBox("Enable Factions", "inpc_enable_factions")
	
	dform:Help("Custom Playermodel Faction: What faction should custom playermodels be?")
	dform:ControlHelp("Outsider: All NPCs are hostile.")
	dform:ControlHelp("Neutral: All NPCs are neutral/friendly.")
	local cbox = dform:ComboBox("Custom Playermodel Faction", "inpc_custom_playermodel_faction")
	cbox:AddChoice("Resistance", "resistance")
	cbox:AddChoice("Overwatch", "overwatch")
	cbox:AddChoice("Zombies", "zombies")
	cbox:AddChoice("Antlions", "antlions")
	cbox:AddChoice("Outsider", "outsider")
	cbox:AddChoice("Neutral", "neutral")
	
	dform:Help("Force Player Faction: If not default, forces ALL players to be this faction.")
	dform:ControlHelp("Default: Faction depends on playermodel.")
	dform:ControlHelp("Outsider: All NPCs are hostile.")
	dform:ControlHelp("Neutral: All NPCs are neutral/friendly.")
	local cbox = dform:ComboBox("Force Player Faction", "inpc_force_player_faction")
	cbox:AddChoice("Default", "default")
	cbox:AddChoice("Resistance", "resistance")
	cbox:AddChoice("Overwatch", "overwatch")
	cbox:AddChoice("Zombies", "zombies")
	cbox:AddChoice("Antlions", "antlions")
	cbox:AddChoice("Outsider", "outsider")
	cbox:AddChoice("Neutral", "neutral")
	
	dform:CheckBox("Enable Ragdoll & Decal Cleanup", "inpc_cleanup")
	dform:CheckBox("Enable Custom NPC Health Values", "inpc_custom_health")
	dform:CheckBox("Enable NPC Health Regeneration", "inpc_health_regeneration")
	dform:CheckBox("Enable Floor Turret/Ceiling Turret/Strider Damageable", "inpc_damage_invulnerable")
	dform:CheckBox("Enable Adding NPCs to Squad", "inpc_allow_adding_npcs_to_squad")
	
end

local function populateInpcClientToolPanel(dform)
	
	dform:Help("Force NPC Faction: What faction should NPCs you spawn be?")
	
	local cbox = dform:ComboBox("Force NPC Faction", "inpc_forcefaction")
	cbox:AddChoice("Default", "default")
	cbox:AddChoice("Resistance", "resistance")
	cbox:AddChoice("Overwatch", "overwatch")
	cbox:AddChoice("Zombies", "zombies")
	cbox:AddChoice("Antlions", "antlions")
	
end

local function populateInpcAIOptionsToolPanel(dform)

	dform:Help("Enable and disable general AI overrides.")
	dform:CheckBox("Enable No Friendly Fire", "inpc_nofriendlyfire")
	dform:CheckBox("Enable Unlimited Vision", "inpc_unlimited_vision")
	dform:CheckBox("Enable Idle Patrolling", "inpc_patrol")
	dform:CheckBox("Enable AI Attack Frenzy", "inpc_ai_frenzy")

	dform:Help("Enable and disable specific AI overrides.")
	dform:CheckBox("Enable Custom Infantry AI", "inpc_ai_infantry")
	dform:CheckBox("Enable Metropolice Manhacks", "inpc_metropolice_manhacks")
	dform:CheckBox("Enable Custom Zombie AI", "inpc_ai_zombie")
	dform:CheckBox("Enable Custom Fast Zombie AI", "inpc_ai_fastzombie")
	dform:CheckBox("Enable Poison Zombies Don't Throw Headcrabs", "inpc_ai_poisonzombie_disablethrowheadcrabs")
	dform:CheckBox("Enable Custom Antlion AI", "inpc_ai_antlion")
	dform:CheckBox("Enable Custom Antlion Worker AI", "inpc_ai_antlion_worker")
	dform:CheckBox("Enable Custom Antlion Guard AI", "inpc_ai_antlion_guard")
	dform:CheckBox("Enable Antlion Guards Charge Acceleration", "inpc_ai_antlion_guard_chargeacceleration")
	dform:CheckBox("Enable Custom Hunter AI", "inpc_ai_hunter")
	dform:CheckBox("Enable Custom Vortigaunt AI", "inpc_ai_vortigaunt")
	
end

hook.Add("PopulateToolMenu", "iNPC Options", function()

    spawnmenu.AddToolMenuOption("Options", "iNPC", "iNPCAdminToolMenu", "Admin", "", "", populateInpcAdminToolPanel)
	spawnmenu.AddToolMenuOption("Options", "iNPC", "iNPCClientToolMenu", "Client", "", "", populateInpcClientToolPanel)
	spawnmenu.AddToolMenuOption("Options", "iNPC", "iNPCAIOptionsToolMenu", "AI Overrides", "", "", populateInpcAIOptionsToolPanel)
	
end)

net.Receive("iNPCPlayerChangedFaction", function()
	local newFaction = net.ReadString()
	local factionForced = net.ReadBool()
	chat.AddText(
		Color(255, 165, 0),
		"[iNPC] ",
		Color(255, 255, 255),
		factionForced and "Your faction has been forced to \"" or "Based on your playermodel, your faction has been set to \"",
		Color(255, 165, 0),
		newFaction,
		Color(255, 255, 255),
		"\"."
	)
	timer.Simple(0, function()
		notification.AddLegacy("[iNPC] Your faction is now \""..newFaction.."\".", NOTIFY_GENERIC, 10)
		surface.PlaySound("ambient/levels/canals/drip"..math.random(1, 4)..".wav")
	end)
end)