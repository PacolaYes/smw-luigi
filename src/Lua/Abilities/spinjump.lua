
-- you'd never
-- believe what
-- this one is for

local SMW = RealSMWLuigi
local heist = SMW.dofile("Compatibility/fangs heist.lua")

local function shouldSJump(p)
	return not (
		not SMW.abilityCheck(p)
		or heist.shouldNerf(p)
		or p.smw.crouched and not (p.smw.flags & SMWF_SLIDING)
	)
end

--80 = 5px
--74 = 4.625

local srb2jump = FixedMul(39*(FU/4), FU+FU/10)
local sJumpHeight = SMW.convertValue("B6", srb2jump, 5*FU)
local function doSJump(p, soundandstate)
	
	P_DoJump(p, false) -- do a jump
	
	if p.powers[pw_carry] then return end -- if we're being carried after having jumped then don't continue
	
	--P_SetObjectMomZ(p.mo, -srb2jump+sJumpHeight, true)
	SMW.ZLaunch(p.mo, sJumpHeight)
	p.pflags = $ & ~PF_STARTJUMP -- remove startjump, that'll make us go lower if we don't hold jump
	p.smw.sjangle = p.mo.angle
	p.smw.flags = $|SMWF_SJUMPED|SMWF_STARTSJUMP -- add the spinjumped and startspinjump flags, startspinjump hopefully being just startjump for custom 1 instead of jump
	
	if soundandstate then -- if we should apply the sound and state
		p.mo.state = S_PLAY_FLY -- then apply both the state
		S_StartSound(p.mo, sfx_smwspj) -- & the sound
	end
end

local function pthink(p)
	if (p.cmd.buttons & BT_CUSTOM1)
	and not (p.lastbuttons & BT_CUSTOM1) -- if you've pressed custom 1
	and (P_IsObjectOnGround(p.mo) or p.powers[pw_carry])
	and shouldSJump(p) then -- i think this function is pretty self-explanatory
		if not SMW.executeHook("SpinJumpSpecial", p) then
			doSJump(p, true)
		end
	end
	
	if (p.smw.flags & (SMWF_SJUMPED|SMWF_STARTSJUMP)) == (SMWF_SJUMPED|SMWF_STARTSJUMP)
	and not (p.cmd.buttons & BT_CUSTOM1)
	and P_MobjFlip(p.mo)*p.mo.momz > 0 then
		p.mo.momz = $/2
		p.smw.flags = $ & ~SMWF_STARTSJUMP
	end
	
	if P_IsObjectOnGround(p.mo)
	and (p.smw.flags & SMWF_STARTSJUMP) then -- maybe figure out a way to merge this with the one above? 
		p.smw.flags = $ & ~SMWF_STARTSJUMP
	end
	
	if (p.smw.flags & SMWF_SJUMPED) then
		p.smw.sjangle = $+ANGLE_22h
		if P_IsObjectOnGround(p.mo)
		or not shouldSJump(p)
		or not (p.pflags & PF_JUMPED) then
			p.smw.flags = $ & ~SMWF_SJUMPED
			return
		end
		
		p.drawangle = p.smw.sjangle
		--print("i'm spin jumping!")
	end
end

local function thinkframe(p) -- i kind of want the enemies to shut up :P
	if p.smwshutuplist == nil then
		p.smwshutuplist = {}
	end
	
	if not #p.smwshutuplist then return end
	
	for k, v in ipairs(p.smwshutuplist) do -- go through every enemy in the list
		if not (v[1] and v[1].valid) then -- remove it from the table if the enemy doesn't exist
			table.remove(p.smwshutuplist, k)
			continue
		end
		
		if v[2] -- if there's a specific sound
		and S_SoundPlaying(v[1], v[2]) then -- and the sound is playing
			S_StopSoundByID(v[1], v[2]) -- then stop it
		elseif not v[2] then -- or if there's no specific sound
			S_StopSound(v[1]) -- just stop every sound
		end
	end
end

local function sjChecks(mo, pmo)
	return not (
		not (mo.flags & MF_ENEMY)
		or not (pmo and pmo.valid)
		or not (pmo.player and pmo.player.valid)
		or pmo.skin ~= "realsmwluigi"
		or not (pmo.player.smw.flags & SMWF_SJUMPED)
	)
end

addHook("MobjDamage", function(mo, pmo, src, dmg)
	if not sjChecks(mo, pmo)
	or (mo.player and mo.player.valid) then return end
	
	print(pmo == src)
	
	mo.health = $-1
	print(dmg+1)
end)

addHook("MobjDeath", function(mo, pmo)
	if not sjChecks(mo, pmo) then return end
	
	pmo.momz = 0
	table.insert(pmo.player.smwshutuplist, 1, {mo, mo.info.deathsound}) -- make the enemy SHUT UP
	S_StartSound(mo, sfx_smwssp) -- play our own death sound!!
end)

addHook("ShouldDamage", function(pmo, inf, _, _, dmgtype)
	if pmo.skin ~= "realsmwluigi"
	or not (pmo.player and pmo.player.valid)
	or not (pmo.player.smw.flags & SMWF_SJUMPED)
	or pmo.momz*P_MobjFlip(pmo) > 0 then return end
	
	if not (inf and inf.valid)
	and dmgtype ~= DMG_SPIKE
	or (dmgtype & DMG_DEATHMASK) then return end
	
	-- insert check
	-- that allows luigi t obounce on stuff
	-- only if hes higher than half of their height
	/*if (inf and inf.valid) then
		pmo.z = inf.z+inf.height
	end*/
	pmo.player.pflags = $ & ~PF_JUMPED
	doSJump(pmo.player, false) -- bounce on the thingie
	pmo.state = S_PLAY_FLY -- reapply the spinjump state, since it gets removed
	S_StartSound(pmo, sfx_smwbsp) -- play the bouncing sfx
	return false
end, MT_PLAYER)

return {pthink, thinkframe}