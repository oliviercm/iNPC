include("inpc_setup.lua")

--Store the values from the include in locals.
local INPC_HEALTH_REGEN_COOLDOWN = INPC_HEALTH_REGEN_COOLDOWN
local INPC_FRENZY_BUILD_RATE = INPC_FRENZY_BUILD_RATE
local INPC_FRENZY_DECAY_RATE = INPC_FRENZY_DECAY_RATE
local INPC_FRENZY_DIVISOR = INPC_FRENZY_DIVISOR
local INPC_ANTLION_CHARGE_ACCELERATION = INPC_ANTLION_CHARGE_ACCELERATION
local INPC_ANTLION_CHARGE_DIVISOR = INPC_ANTLION_CHARGE_DIVISOR
local INPC_COND_SEE_ENEMY = INPC_COND_SEE_ENEMY
local INPC_COND_FLOATING_OFF_GROUND = INPC_COND_FLOATING_OFF_GROUND
local INPC_ENEMY_TOO_CLOSE_DISTANCE = INPC_ENEMY_TOO_CLOSE_DISTANCE
local INPC_ENEMY_TOO_FAR_DISTANCE = INPC_ENEMY_TOO_FAR_DISTANCE
local INPC_NEXT_FOLLOW_TIME = INPC_NEXT_FOLLOW_TIME
local INPC_MAX_FOLLOW_DISTANCE = INPC_MAX_FOLLOW_DISTANCE
local INPC_MAX_FOLLOW_DISTANCE_IN_BATTLE = INPC_MAX_FOLLOW_DISTANCE_IN_BATTLE

local inpcHealthTable = inpcHealthTable
local inpcCanUseSquads = inpcCanUseSquads
local inpcIsInfantry = inpcIsInfantry
local inpcUseAI = inpcUseAI
local inpcNpcDefaultFaction = inpcNpcDefaultFaction
local inpcPlayermodelFaction = inpcPlayermodelFaction

-------------------------------------------------------------
---------------------------MAIN------------------------------
-------------------------------------------------------------

function inpcThink()
	
	if not GetConVar("inpc_enabled"):GetBool() or GetConVar("ai_disabled"):GetBool() then
		return
	end
	
	for k, v in pairs(ents.FindByClass("npc_*")) do
		
		if not v.inpcIgnore then
		
			if not v.inpcFaction then
		
				inpcInitializeNPC(v)
				
			end
			
			if GetConVar("inpc_health_regeneration"):GetBool() then
			
				inpcHealthRegeneration(v)
			
			end
			
			if v.inpcUseAI then
				
				inpcAI(v)
				
			end

			if v:HasCondition(INPC_COND_TASK_FAILED) then

				v.inpcStopAIUntil = CurTime() + 2

			end

			if v.inpcStopAIUntil and CurTime() < v.inpcStopAIUntil then

				return

			end

			local cl = v:GetClass()
		
			if v.inpcIsInfantry and GetConVar("inpc_ai_infantry"):GetBool()then
				inpcInfantryAI(v)
			elseif (cl == "npc_zombie" or cl == "npc_poisonzombie" or cl == "npc_zombine") and GetConVar("inpc_ai_zombie"):GetBool() then
				inpcZombieAI(v)
			elseif cl == "npc_fastzombie" and GetConVar("inpc_ai_fastzombie"):GetBool() then
				inpcFastZombieAI(v)
			elseif cl == "npc_hunter" and GetConVar("inpc_ai_hunter"):GetBool() then
				inpcHunterAI(v)
			elseif cl == "npc_antlion" and GetConVar("inpc_ai_antlion"):GetBool() then
				inpcAntlionAI(v)
			elseif cl == "npc_antlion_worker" and GetConVar("inpc_ai_antlion_worker"):GetBool() then
				inpcAntlionWorkerAI(v)
			elseif cl == "npc_antlionguard" and GetConVar("inpc_ai_antlion_guard"):GetBool() then
				inpcAntlionGuardAI(v)
			elseif cl == "npc_vortigaunt" and GetConVar("inpc_ai_vortigaunt"):GetBool() then
				inpcVortigauntAI(v)
			end
			
		end
		
	end
	
end

hook.Add("Tick", "iNPCTickHook", inpcThink)

function inpcAI(npc)

	if IsValid(npc) then

		state = npc:GetNPCState()
		
		local dead = state == NPC_STATE_DEAD or npc:Health() <= 0
		if dead then
			return
		end
		
		if npc.inpcPlayerSquad and GetConVar("inpc_allow_adding_npcs_to_squad"):GetBool() then
			inpcFollowAI(npc)
			return
		end
		
		local enemy = npc:GetEnemy()
		if IsValid(enemy) then

			if npc.inpcLastEnemy ~= enemy then

				npc.inpcLastEnemy = enemy
				npc:UpdateEnemyMemory(enemy, enemy:GetPos())

			end
			
		else
		
			if GetConVar("inpc_unlimited_vision"):GetBool() and inpcCheckForEnemies(npc) then
			
				return
				
			end
			
			local idleState = state == NPC_STATE_IDLE
			local idleSchedule = npc:IsCurrentSchedule(SCHED_IDLE_STAND)
			local isIdle = idleState and idleSchedule
			
			if GetConVar("inpc_patrol"):GetBool() and isIdle then

				if math.random() < 0.8 then
					npc:SetSchedule(SCHED_PATROL_WALK)
					return
				else
					npc:SetSchedule(SCHED_PATROL_RUN)
					return
				end
			
			end
			
			local alertState = state == NPC_STATE_ALERT
			
			if alertState then

				npc:SetNPCState(NPC_STATE_IDLE)
				return
			
			end
		
		end
		
		if npc:WaterLevel() == 3 then
		
			local world = game.GetWorld()
			npc:TakeDamage(1, world, world)
		
		end
		
	end

end

function inpcInitializeNPC(npc)
	
	if not npc:IsNPC() then
		npc.inpcIgnore = true
		return
	end
	
	--COMPATIBILITY WITH VJ BASE
	local isVJNPC = npc.IsVJBaseSNPC
	if isVJNPC then
		npc.inpcIgnore = true
		return
	end
	
	--ATTEMPT AT COMPATIBILITY WITH FILZO'S OTHER SNPCS (COMBINE UNITS +PLUS)
	local isCUPSNPC = npc.InvasionNPC
	if isCUPSNPC then
		npc.inpcIgnore = true
		return
	end
	
	--COMPATIBILITY WITH FILZO'S BIOHAZARD MOD
	local isBiohazardZombie = npc.ZombieBA
	if isBiohazardZombie then
		npc.inpcIgnore = true
		return
	end
	
	--If the npc doesn't have a faction and can't be given a default one then return.
	if not npc.inpcFaction and not inpcSetNPCDefaultFaction(npc) then
		npc.inpcIgnore = true
		return
	end
	
	inpcSetSquad(npc, npc.inpcFaction)
	
	local cl = npc:GetClass()
	
	if GetConVar("inpc_custom_health"):GetBool() then
		
		inpcSetCustomHealth(npc, cl)
		
	end
	
	if inpcUseAI[cl] then
	
		npc.inpcUseAI = true
		
		npc:SetNPCState(NPC_STATE_IDLE)
		
	end

	if inpcIsInfantry[cl] then
		
		npc.inpcIsInfantry = true
		
		local proficiency = GetConVar("inpc_weaponproficiency"):GetInt()
		
		if proficiency >= 0 and proficiency <= 4 then
			npc:SetCurrentWeaponProficiency(proficiency)
		end
	
	end
	
	if cl == "npc_poisonzombie" and GetConVar("inpc_ai_poisonzombie_disablethrowheadcrabs"):GetBool() then
	
		npc:CapabilitiesClear()
		npc:CapabilitiesAdd(CAP_MOVE_GROUND)
		npc:CapabilitiesAdd(CAP_INNATE_MELEE_ATTACK1)
		
	end

end

function inpcSetRelations()

	if not GetConVar("inpc_enable_factions"):GetBool() then
		return
	end
	
	local allNpcs = ents.FindByClass("npc_*")
	local allPlayersAndNpcs = table.Add(player.GetAll(), allNpcs)
	
	for k, f in pairs(allNpcs) do
		
		if IsValid(f) and f.inpcFaction then
		
			local fFaction = f.inpcFaction
		
			for k, s in pairs(allPlayersAndNpcs) do
				
				if IsValid(s) and s.inpcFaction then
				
					local sFaction = s.inpcFaction
					
					if sFaction == "neutral" then
					
						f:AddEntityRelationship(s, D_NU)
					
					elseif fFaction == sFaction then
					
						f:AddEntityRelationship(s, D_LI)
						
					else
					
						f:AddEntityRelationship(s, D_HT)
						
					end
				
				end
				
			end
			
		end
	
	end
	
end

function inpcSetNPCDefaultFaction(npc)

	if not GetConVar("inpc_enable_factions"):GetBool() then
		return
	end

	local defaultFaction = inpcNpcDefaultFaction[npc:GetClass()]
	
	if defaultFaction then
	
		npc.inpcFaction = defaultFaction
		inpcSetRelations()
		return true
		
	else
	
		npc.inpcIgnore = true
		return false
		
	end

end

function inpcSetNPCFaction(npc, faction)

	if not GetConVar("inpc_enable_factions"):GetBool() then
		return
	end
	
	local defaultFaction = inpcNpcDefaultFaction[npc:GetClass()]
	
	if defaultFaction then
	
		if faction == "default" or not faction then
		
			npc.inpcFaction = defaultFaction
			
		else
		
			npc.inpcFaction = faction
		
		end
		
		inpcSetRelations()
		
	else
	
		npc.inpcIgnore = true
		
	end

end

function inpcSetPlayerFaction(ply)

	if not GetConVar("inpc_enabled"):GetBool() or not GetConVar("inpc_enable_factions"):GetBool()  then
		return
	end

	local forcedPlayerFaction = GetConVar("inpc_force_player_faction"):GetString()
	
	if forcedPlayerFaction == "default" then
	
		timer.Simple(0, function()
		
			local mdl = string.sub(ply:GetModel(), 15, -5)
			local faction = inpcPlayermodelFaction[mdl]
			
			ply.inpcFaction = faction or GetConVar("inpc_custom_playermodel_faction"):GetString()
			
			inpcSetRelations()
			
		end)

	else
	
		timer.Simple(0, function()
		
			ply.inpcFaction = forcedPlayerFaction
			inpcSetRelations()
			
		end)
	
	end

end

hook.Add("PlayerSpawn", "iNPCPlayerSpawnHook", inpcSetPlayerFaction)

function inpcPlayerSpawnedNPC(ply, npc)
	
	if not GetConVar("inpc_enabled"):GetBool() then
		return
	end

	if GetConVar("inpc_metropolice_manhacks"):GetBool() and npc:GetClass() == "npc_metropolice" then
		npc:SetKeyValue("manhacks", "1")
		npc:SetBodygroup(1, 1)
	end
	
	inpcSetNPCFaction(npc, ply:GetInfo("inpc_forcefaction"))
	inpcInitializeNPC(npc)

end

hook.Add("PlayerSpawnedNPC", "iNPCPlayerSpawnedNPCHook", inpcPlayerSpawnedNPC)

function inpcFollowAI(npc)
	
	if IsValid(npc) and IsValid(npc.inpcFollowEnt) then
	
		local leader = npc.inpcFollowEnt
		local leaderPos = leader:GetPos()
		local distanceFromLeader = npc:GetPos():Distance(leaderPos)
		local forcedRunning = npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN)
		local followTime = npc.inpcNextFollowTime
		local currentTime = CurTime()
		local inBattle = IsValid(npc:GetEnemy())
		
		if inBattle and distanceFromLeader <= INPC_MAX_FOLLOW_DISTANCE_IN_BATTLE then
			return
		end
		
		if distanceFromLeader >= INPC_MAX_FOLLOW_DISTANCE and followTime < currentTime then
		
			npc:SetLastPosition(leaderPos)
			npc:SetNPCState(NPC_STATE_ALERT)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
			
			npc:ClearEnemyMemory()
			npc:MarkEnemyAsEluded()
			
			npc.inpcNextFollowTime = currentTime + INPC_NEXT_FOLLOW_TIME
			
		end
		
	end

end

function inpcCheckForEnemies(npc)

	for k, v in pairs(ents.FindByClass("npc_*")) do
	
		if IsValid(v) and npc:Visible(v) and v:Health() > 0 and npc:Disposition(v) == D_HT then

			npc:SetEnemy(v)
			return true
		
		end
	
	end
	
	if not GetConVar("ai_ignoreplayers"):GetBool() then
	
		for k, v in pairs(player.GetAll()) do

			if IsValid(v) and npc:Visible(v) and v:Health() > 0 and npc:Disposition(v) == D_HT then
			
				npc:SetEnemy(v)
				return true
			
			end
		
		end
		
	end
	
	return false

end

function inpcDamageInvulnerable(victim, dmg)

	if not GetConVar("inpc_enabled"):GetBool() or not GetConVar("inpc_damage_invulnerable"):GetBool() then
		return
	end
	
	if IsValid(victim) and (victim:GetClass() == "npc_turret_floor" or victim:GetClass() == "npc_turret_ceiling" or victim:GetClass() == "npc_strider") then
	
		local health = victim:Health()
		local damage = dmg:GetDamage()
		
		if health > damage then
		
			victim:SetHealth(health - damage)
		
		elseif health > 0 then
			
			if victim:GetClass() == "npc_turret_floor" then
			
				victim:SetHealth(0)
				victim:Fire("SelfDestruct")
				
			elseif victim:GetClass() == "npc_strider" then
			
				victim:SetHealth(0)
				
			elseif victim:GetClass() == "npc_turret_ceiling" then
			
				local effect = EffectData()
				effect:SetStart(victim:WorldSpaceCenter())
				effect:SetOrigin(victim:WorldSpaceCenter())
				util.Effect("Explosion", effect)
				victim:Remove()
				
			end
		
		end

	end

end

hook.Add("EntityTakeDamage", "iNPCDamageInvulnerableHook", inpcDamageInvulnerable)

function inpcFriendlyFire(ent, dmg)

	if not GetConVar("inpc_enabled"):GetBool() or not GetConVar("inpc_nofriendlyfire"):GetBool() then
		return
	end
	
	local attacker = dmg:GetAttacker()
	local victim = ent
	
	if IsValid(attacker) and IsValid(victim) and attacker.inpcFaction and victim.inpcFaction and attacker.inpcFaction == victim.inpcFaction and not attacker:IsPlayer() then
		dmg:SetDamage(0)
		return true
	end

end

hook.Add("EntityTakeDamage", "iNPCFriendlyfireHook", inpcFriendlyFire)

function inpcCleanup()

	if not GetConVar("inpc_enabled"):GetBool() then
		return
	end
	
	if GetConVar("inpc_cleanup"):GetBool() then
		RunConsoleCommand("g_ragdoll_fadespeed", "1")
		RunConsoleCommand("g_ragdoll_important_maxcount", "0")
		RunConsoleCommand("g_ragdoll_lvfadespeed", "1")
		RunConsoleCommand("g_ragdoll_maxcount", "0")
	elseif GetConVar("g_ragdoll_fadespeed"):GetInt() == 1 and GetConVar("g_ragdoll_important_maxcount"):GetInt() == 0 and GetConVar("g_ragdoll_lvfadespeed"):GetInt() == 1 and GetConVar("g_ragdoll_maxcount"):GetInt() == 0 then
		RunConsoleCommand("g_ragdoll_fadespeed", "600")
		RunConsoleCommand("g_ragdoll_important_maxcount", "2")
		RunConsoleCommand("g_ragdoll_lvfadespeed", "100")
		RunConsoleCommand("g_ragdoll_maxcount", "8")
		return
	end
	
	if not GetConVar("inpc_cleanup"):GetBool() then
		return
	end
	
	timer.Simple(0, function()
		
		for k, v in pairs(table.Add(ents.FindByClass("weapon_*"), ents.FindByClass("ai_weapon_*"))) do

			if IsValid(v) and v:GetOwner() == NULL then
				v:Remove()
			end

		end
		for k, v in pairs(table.Add(ents.FindByClass("item_ammo_ar2_altfire"), ents.FindByClass("item_healthvial"))) do

			if IsValid(v) then
				v:Remove()
			end

		end
		
		RunConsoleCommand("r_cleardecals")
		
	end)
	
end

hook.Add("OnNPCKilled", "iNPCOnNPCKilledHook", inpcCleanup)

function inpcPlayerAddToSquad(ply, key)

	if not GetConVar("inpc_enabled"):GetBool() or not GetConVar("inpc_allow_adding_npcs_to_squad"):GetBool() then
		return
	end
	
	if key == IN_USE then
		
		local tr = ply:GetEyeTraceNoCursor()
		
		local playerPos = ply:GetPos()
		local trPos = tr.HitPos
		local distance = playerPos:Distance(trPos)
		
		if distance > INPC_MAX_FOLLOW_DISTANCE then
			return
		end
		
		local ent = tr.Entity
	
		if ent:IsNPC() and ply.inpcFaction and ent.inpcFaction and ply.inpcFaction == ent.inpcFaction and not ent.inpcPlayerSquad then
		
			ent.inpcFollowEnt = ply
			ent.inpcPlayerSquad = true
			ent.inpcNextFollowTime = CurTime()
			
			inpcSetSquad(ent, ply:GetName())
			
			ply:PrintMessage(HUD_PRINTTALK, "Added NPC to squad.")
		
		elseif ent:IsNPC() and ply.inpcFaction and ent.inpcFaction and ply.inpcFaction == ent.inpcFaction and ent.inpcPlayerSquad then
		
			ent.inpcFollowEnt = nil
			ent.inpcPlayerSquad = nil
			ent.inpcNextFollowTime = nil
			
			inpcSetSquad(ent, ent.inpcFaction)
			
			ply:PrintMessage(HUD_PRINTTALK, "Removed NPC from squad.")
		
		end

	end
	
end

hook.Add("KeyPress", "iINPCPlayerAddToSquadHook", inpcPlayerAddToSquad)

-------------------------------------------------------------
------------------------AI MODULES---------------------------
-------------------------------------------------------------

function inpcInfantryAI(npc)
	
	local enemy = npc:GetEnemy()

	if not IsValid(enemy) then
		return
	end

	local strafing = npc:IsCurrentSchedule(SCHED_RUN_RANDOM)
	if strafing then
		return
	end
	
	local getLineOfFire = npc:IsCurrentSchedule(SCHED_ESTABLISH_LINE_OF_FIRE)
	if getLineOfFire then
		return
	end
	
	local currentActivity = npc:GetActivity()
	local reloading = npc:IsCurrentSchedule(SCHED_RELOAD) or npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) or currentActivity == ACT_RELOAD
	if reloading then
		return
	end
	
	local fallingBack = npc:IsCurrentSchedule(SCHED_RUN_FROM_ENEMY_FALLBACK)
	if fallingBack then
		return
	end
	
	local specialAttack = npc:IsCurrentSchedule(SCHED_RANGE_ATTACK2) or npc:IsCurrentSchedule(SCHED_MELEE_ATTACK1) or npc:IsCurrentSchedule(SCHED_MELEE_ATTACK2) or npc:IsCurrentSchedule(SCHED_SPECIAL_ATTACK1) or npc:IsCurrentSchedule(SCHED_SPECIAL_ATTACK2)
	if specialAttack then
		return
	end

	local weapon = npc:GetActiveWeapon()
	if IsValid(weapon) then

		local weapontype = weapon:GetHoldType()
		local weaponIsCloseRange = weapontype == "melee"
		if weaponIsCloseRange then
			return
		end
		
		if npc:Visible(enemy) then

			local distanceFromEnemy = npc:GetPos():Distance(enemy:GetPos())
			if distanceFromEnemy < INPC_ENEMY_TOO_CLOSE_DISTANCE then

				npc:SetSchedule(SCHED_RUN_FROM_ENEMY_FALLBACK)
				return
		
			elseif distanceFromEnemy < INPC_ENEMY_TOO_FAR_DISTANCE then

				if math.random() < 0.004 then

					npc:SetSchedule(SCHED_RUN_RANDOM)
					return

				end

			else

				npc:SetSchedule(SCHED_ESTABLISH_LINE_OF_FIRE)
				return

			end

		else

			npc:SetSchedule(SCHED_ESTABLISH_LINE_OF_FIRE)
			return

		end

	end
	
end

function inpcAntlionAI(npc)

	local enemy = npc:GetEnemy()
	
	if IsValid(enemy) then
	
		local enemyDistance = npc:GetPos():Distance(enemy:GetPos())
		local meleeAttacking = npc:IsCurrentSchedule(SCHED_MELEE_ATTACK1)
		
		if enemyDistance <= 100 and not meleeAttacking then
		
			npc:SetSchedule(SCHED_MELEE_ATTACK1)
		
		end
		
		if GetConVar("inpc_ai_frenzy"):GetBool() then
		
			if not npc.inpcFrenzyBonus then
				npc.inpcFrenzyBonus = 0
			end
		
			if enemyDistance <= 150 then
			
				if meleeAttacking then
					
					npc.inpcFrenzyBonus = npc.inpcFrenzyBonus + 1
					npc:SetKeyValue("playbackrate", tostring(1 + (npc.inpcFrenzyBonus / 100)))
					
				end
			
			else
			
				npc.inpcFrenzyBonus = 0
				npc:SetKeyValue("playbackrate", "1")
			
			end
			
		end
		
	end

end

function inpcAntlionGuardAI(npc)

	if npc:Health() <= 0 then
		return
	end

	local enemy = npc:GetEnemy()

	if IsValid(enemy) then
		
		local enemyDistance = npc:GetPos():Distance(enemy:GetPos())
		local meleeAttacking = npc:IsCurrentSchedule(SCHED_MELEE_ATTACK1)
		local rangeAttacking = npc:IsCurrentSchedule(SCHED_RANGE_ATTACK1)
		local chasingEnemy = npc:IsCurrentSchedule(SCHED_CHASE_ENEMY)
		local currentActivity = npc:GetActivity()
		local currentSchedule = npc:GetCurrentSchedule()
		
		if enemyDistance <= 180 and enemyDistance > 140 and not meleeAttacking and currentSchedule < LAST_SHARED_SCHEDULE then
		
			npc:SetSchedule(SCHED_MELEE_ATTACK1)
			
		elseif enemyDistance <= 140 and not rangeAttacking and currentSchedule < LAST_SHARED_SCHEDULE then
		
			npc:SetSchedule(SCHED_RANGE_ATTACK1)

		end
		
		if GetConVar("inpc_ai_frenzy"):GetBool() then
			
			if not npc.inpcFrenzyBonus then
				npc.inpcFrenzyBonus = 0
			end
		
			if enemyDistance <= 200 then
			
				if meleeAttacking or rangeAttacking then
					
					npc.inpcFrenzyBonus = npc.inpcFrenzyBonus + 1
					
					
					
					npc:SetKeyValue("playbackrate", tostring(1 + (npc.inpcFrenzyBonus / 100)))
					
				end
			
			else
			
				npc.inpcFrenzyBonus = 0
				npc:SetKeyValue("playbackrate", "1")
			
			end
			
		end
		
		if GetConVar("inpc_ai_antlion_guard_chargeacceleration"):GetBool() then
		
			if not npc.inpcChargeSpeedBonus then
				npc.inpcChargeSpeedBonus = 0
			end
			
			local isCharging = npc:GetCurrentSchedule() >= LAST_SHARED_SCHEDULE and npc:GetActivity() >= LAST_SHARED_ACTIVITY
			
			if isCharging then
			
				npc.inpcChargeSpeedBonus = npc.inpcChargeSpeedBonus + 1
				npc:SetKeyValue("playbackrate", tostring(1 + (npc.inpcChargeSpeedBonus / 200)))
				
			else
			
				npc.inpcChargeSpeedBonus = 0
				
			end
		
		end
		
	end

end

function inpcAntlionWorkerAI(npc)

	local enemy = npc:GetEnemy()
	
	if IsValid(enemy) then
	
		local enemyDistance = npc:GetPos():Distance(enemy:GetPos())
		local meleeAttacking = npc:IsCurrentSchedule(SCHED_MELEE_ATTACK1)
		local rangeAttacking = npc:IsCurrentSchedule(SCHED_RANGE_ATTACK1)
		local chasingEnemy = npc:IsCurrentSchedule(SCHED_CHASE_ENEMY)
		
		if enemyDistance <= 100 and not meleeAttacking then
		
			npc:SetSchedule(SCHED_MELEE_ATTACK1)
		
		end
		
		if not meleeAttacking and not rangeAttacking and not chasingEnemy then
		
			npc:SetSchedule(SCHED_CHASE_ENEMY)
			
		end
		
		if GetConVar("inpc_ai_frenzy"):GetBool() then
		
			if not npc.inpcFrenzyBonus then
				npc.inpcFrenzyBonus = 0
			end
		
			if enemyDistance <= 150 then
			
				if meleeAttacking then
					
					npc.inpcFrenzyBonus = npc.inpcFrenzyBonus + 1
					npc:SetKeyValue("playbackrate", tostring(1 + (npc.inpcFrenzyBonus / 100)))
					
				end
			
			else
			
				npc.inpcFrenzyBonus = 0
				npc:SetKeyValue("playbackrate", "1")
			
			end
			
		end
		
	end

end

function inpcFastZombieAI(npc)
	
	if npc:Health() <= 0 then
		return
	end

	local enemy = npc:GetEnemy()
	
	if IsValid(enemy) then
		
		local enemyDistance = npc:GetPos():Distance(enemy:GetPos())
		local meleeAttacking = npc:GetActivity() == ACT_MELEE_ATTACK1
		local currentSchedule = npc:GetCurrentSchedule()
		local currentActivity = npc:GetActivity()
		local floatingOffGround = npc:HasCondition(INPC_COND_FLOATING_OFF_GROUND)
		local seeEnemy = npc:HasCondition(INPC_COND_SEE_ENEMY)
		
		if enemyDistance <= 90 and currentActivity >= LAST_SHARED_ACTIVITY and currentSchedule >= LAST_SHARED_SCHEDULE and not floatingOffGround then
		
			npc:SetSchedule(SCHED_MELEE_ATTACK1)
			
		elseif currentActivity >= LAST_SHARED_ACTIVITY and currentSchedule >= LAST_SHARED_SCHEDULE and not floatingOffGround and seeEnemy then
		
			npc:SetSchedule(SCHED_RANGE_ATTACK1)
		
		end
		
		if currentActivity == ACT_RUN and seeEnemy and enemyDistance > 90 and enemyDistance < 500 then
		
			npc:SetSchedule(SCHED_RANGE_ATTACK1)
		
		end

	end

end

function inpcHunterAI(npc)
	
	local enemy = npc:GetEnemy()

	if IsValid(enemy) then
		
		local enemyDistance = npc:GetPos():Distance(enemy:GetPos())
		local meleeAttacking = npc:GetActivity() == ACT_MELEE_ATTACK1
		local currentSchedule = npc:GetCurrentSchedule()
		local currentActivity = npc:GetActivity()
		
		if enemyDistance <= 80 and not meleeAttacking and currentSchedule < LAST_SHARED_SCHEDULE then
		
			npc:SetSchedule(SCHED_MELEE_ATTACK1)
		
		end
		
		if currentSchedule >= LAST_SHARED_SCHEDULE then
		
			npc:SetKeyValue("playbackrate", "1.5")

		elseif currentActivity == ACT_IDLE or currentActivity == ACT_TRANSITION then
		
			npc:SetKeyValue("playbackrate", "5")
		
		end
		
	end

end

function inpcVortigauntAI(npc)

	local enemy = npc:GetEnemy()
	
	if IsValid(enemy) then
		
		local enemyDistance = npc:GetPos():Distance(enemy:GetPos())
		local rangeAttacking = npc:IsCurrentSchedule(SCHED_RANGE_ATTACK1)
		
		if enemyDistance < 1200 and not rangeAttacking then
		
			npc:SetSchedule(SCHED_RANGE_ATTACK1)
		
		end
	
	end

end

function inpcZombieAI(npc)

	local enemy = npc:GetEnemy()

	if IsValid(enemy) then
		
		local enemyDistance = npc:GetPos():Distance(enemy:GetPos())
		local meleeAttacking = npc:GetActivity() == ACT_MELEE_ATTACK1
		
		if enemyDistance <= 75 and not meleeAttacking then
	
			npc:SetSchedule(SCHED_MELEE_ATTACK1)
		
		end
		
		if GetConVar("inpc_ai_frenzy"):GetBool() then
		
			if not npc.inpcFrenzyBonus then
				npc.inpcFrenzyBonus = 0
			end
		
			if enemyDistance <= 150 then
			
				if meleeAttacking then
					
					npc.inpcFrenzyBonus = npc.inpcFrenzyBonus + 1
					npc:SetKeyValue("playbackrate", tostring(1 + (npc.inpcFrenzyBonus / 100)))
					
				end
			
			else
			
				npc.inpcFrenzyBonus = 0
				npc:SetKeyValue("playbackrate", "1")
			
			end
			
		end

	end

end

-------------------------------------------------------------
---------------------HELPER FUNCTIONS------------------------
-------------------------------------------------------------

function inpcSetSquad(npc, faction)

	local cl = npc:GetClass()
	
	if inpcCanUseSquads[cl] then
	
		npc:SetKeyValue("SquadName", faction)
		return
		
	end
	
end

function inpcHealthRegeneration(npc)

	local health = npc:Health()
	local maxHealth = npc:GetMaxHealth()
	local regenCooldown = npc.inpcRegenCooldown
	
	if health < maxHealth and health > 0 then
		
		if not regenCooldown or regenCooldown <= 0 then
		
			npc.inpcRegenCooldown = INPC_HEALTH_REGEN_COOLDOWN
			npc:SetHealth(health + 1)
			
		else
		
			npc.inpcRegenCooldown = regenCooldown - 1
			
		end
	
	end
	
end

function inpcSetCustomHealth(npc, cl)

	local health = inpcHealthTable[cl]
	
	if health then
		
		npc:SetHealth(health)
		npc:SetMaxHealth(health)
		
	end

end