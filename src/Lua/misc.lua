
-- everything that i dont think warrants its own file

---@diagnostic disable: missing-fields

local SMW = RealSMWLuigi

RealSMWLuigi.replacementMusic = {
	["_INV"] = {"SMWINV", [3] = true},
	["_MINV"] = {"SMWINV", [3] = true},
	["_BOSS"] = {"SMWBB"},
	["_CLEAR"] = {"SMWCC"},
	["_GOVER"] = {"SMWGO"}
}

---@param new string
addHook("MusicChange", function(_, new, ...)
	if not consoleplayer
	or skins[consoleplayer.skin].name ~= "realsmwluigi" then return end
	
	local old_music = {new:upper(), ...}

	if SMW.replacementMusic[old_music[1]] then
		for key, value in pairs(SMW.replacementMusic[old_music[1]]) do
			old_music[key] = value
		end
	end
	
	return unpack(old_music) ---@diagnostic disable-line
end)

local dead_jumpTime = TICRATE/2 -- when u jump up super star
local invulnColors = {
	{SKINCOLOR_SMWRED},
	{SKINCOLOR_SMWGREEN},
	{SKINCOLOR_SMWWHITE, SKINCOLOR_SMWFIRERED},
	{SKINCOLOR_SMWWHITE, SKINCOLOR_SMWFIREGREEN}
}

sfxinfo[freeslot("sfx_smwslw")].caption = "Star Running Out"

---@param p player_t
addHook("PlayerThink", function(p)
	if not SMW.luigiCheck(p) then return end

	if p.mo.health <= 0
	and p.mo.fuse then -- you're in the dead anim
		if p.deadtimer == 1 then
			S_StopSound(p.mo)
			P_PlayJingleMusic(p, "SMWDED", 0, false, JT_MASTER)
		end

		if p.deadtimer < dead_jumpTime then
			if (p.mo.sprite == SPR_PLAY and p.mo.sprite2 == SPR2_DEAD) then
				p.mo.frame = A
			end

			if (p.mo.movedir == DMG_DROWNED) then
				P_SetObjectMomZ(p.mo, FU/2)
			else
				P_SetObjectMomZ(p.mo, 2*FU/3)
			end
		elseif p.deadtimer == dead_jumpTime then
			P_SetObjectMomZ(p.mo, 14*FU)
		else
			if (p.mo.movedir == DMG_DROWNED) then -- make it consistent, as you're not supposed to drown anyways
				P_SetObjectMomZ(p.mo, -(2*FU/3 - FU/2), true)
			end
			p.mo.frame = (p.smw.deadtimer / 4) % 2
		end

		if not multiplayer
		and p.smw.deadtimer < 5*TICRATE then
			p.deadtimer = min($, 2*TICRATE - 1)
		end
		p.smw.deadtimer = $ + 1
	end

    -- the "go flashing when you're invincible as thats how it works" thing
    if p.powers[pw_invulnerability] then
		local invulnColor = invulnColors[((leveltime / 2) % #invulnColors) + 1]
		p.mo.color = invulnColor[1]
		p.smw.forceOverlayColor = invulnColor[2]
		
		if p.powers[pw_invulnerability] == 1 then
			p.mo.color = p.skincolor
			p.smw.forceOverlayColor = 0
		elseif p.powers[pw_invulnerability] == TICRATE
		and not S_SoundPlaying(p.mo, sfx_smwslw) then
			S_StartSound(p.mo, sfx_smwslw)
		end
	end
end)

-- overlay stuff

freeslot("MT_SMWOVERLAY")

mobjinfo[MT_SMWOVERLAY] = {
	spawnstate = S_INVISIBLE,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOGRAVITY -- just making sure
}

---@param mo mobj_t
addHook("MobjThinker", function(mo)
	if not (mo.tracer and mo.tracer.valid)
	or mo.tracer.skin ~= "realsmwluigi" then
		P_RemoveMobj(mo)
		return
	end
	local tracer = mo.tracer

	mo.sprite = tracer.sprite
	mo.sprite2 = tracer.sprite2
	mo.skin = "realoverluigi"
	mo.frame = tracer.frame
	mo.flags2 = (tracer.flags2 & MF2_DONTDRAW) | MF2_LINKDRAW
	
	mo.colorized = tracer.colorized
	if mo.colorized then
		mo.color = tracer.color
	else
		mo.color = SMW.getOverlayColor(tracer.player, tracer.color)
	end

	-- A_CapeChase makes us kill ourselves if the player's dead, overwrite that
	P_MoveOrigin(mo, tracer.x, tracer.y, tracer.z)
	mo.scale = tracer.scale
	mo.destscale = tracer.destscale

	if (tracer.eflags & MFE_VERTICALFLIP) then -- copy A_CapeChase
		mo.eflags = $|MFE_VERTICALFLIP;
		mo.flags2 = $|MF2_OBJECTFLIP;
		mo.z = tracer.z + tracer.height - mo.height;
	else
		mo.eflags = $ & ~MFE_VERTICALFLIP;
		mo.flags2 = $ & ~MF2_OBJECTFLIP;
		mo.z = tracer.z;
	end

	if (tracer.player and tracer.player.valid) then
		mo.angle = tracer.player.drawangle
	else
		mo.angle = tracer.angle
	end
end, MT_SMWOVERLAY)

---@param v videolib
---@param x fixed_t
---@param y fixed_t
---@param scale fixed_t
---@param skin string
---@param spr2 integer
---@param frame integer
---@param rot integer
---@param color skincolornum_t
local function drawOverlay(v, _, x, y, scale, skin, spr2, frame, rot, color)
	if skin ~= "realsmwluigi" then return end
	
	local cmap = v.getColormap("realoverluigi", SMW.getOverlayColor(consoleplayer, color))
	local ovSpr2, ovFlip = v.getSprite2Patch("realoverluigi", spr2, false, frame, rot)

	if (ovSpr2 and ovSpr2.valid) then
		v.drawScaled(x, y, scale, ovSpr2, (ovFlip and V_FLIP or 0), cmap)
	end
end

addHook("HUD", drawOverlay, "continue")
addHook("HUD", drawOverlay, "playersetup")