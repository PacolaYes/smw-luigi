
-- simple stuff related to colors
-- also includes the overlay
-- since it's related to the overalls' color :P

---@diagnostic disable: missing-fields

local SMW = RealSMWLuigi

local invulnColors = {
	{SKINCOLOR_SMWRED},
	{SKINCOLOR_SMWGREEN},
	{SKINCOLOR_SMWWHITE, SKINCOLOR_SMWFIRERED},
	{SKINCOLOR_SMWWHITE, SKINCOLOR_SMWFIREGREEN}
}

sfxinfo[freeslot("sfx_smwslw")].caption = "Star Running Out"

addHook("PlayerThink", function(p)
	if not SMW.luigiCheck(p) then return end
	
	if p.powers[pw_invulnerability] then
		local invulnColor = invulnColors[((leveltime / 2) % #invulnColors) + 1]
		p.mo.color = invulnColor[1]
		p.smw.forceOverlayColor = invulnColor[2]
		
		if p.powers[pw_invulnerability] == 1 then
			p.smw.forceOverlayColor = 0
		elseif p.powers[pw_invulnerability] == TICRATE
		and not S_SoundPlaying(p.mo, sfx_smwslw) then
			S_StartSound(p.mo, sfx_smwslw)
		end
	end
end)

-- followmobj stuff
-- a.k.a the overlay

freeslot("MT_SMWOVERLAY")

mobjinfo[MT_SMWOVERLAY] = {
	spawnstate = S_INVISIBLE
}

---@param p player_t
---@param mo mobj_t
addHook("FollowMobj", function(p, mo)
	if not SMW.luigiCheck(p)
	or not (mo and mo.valid) then return end -- gotta make sure :P
	
	mo.sprite = p.mo.sprite
	mo.sprite2 = p.mo.sprite2
	mo.skin = "realoverluigi"
	mo.frame = p.mo.frame
	
	mo.colorized = p.mo.colorized
	if mo.colorized then
		mo.color = p.mo.color
	else
		mo.color = SMW.getOverlayColor(p, p.mo.color)
	end

	if not p.mo.health then -- A_CapeChase makes us kill ourselves if the player's dead, overwrite that
		P_MoveOrigin(mo, p.mo.x, p.mo.y, p.mo.z)
		mo.scale = p.mo.scale
		mo.destscale = p.mo.destscale

		if (p.mo.eflags & MFE_VERTICALFLIP) then -- copy A_CapeChase
			mo.eflags = $|MFE_VERTICALFLIP;
			mo.flags2 = $|MF2_OBJECTFLIP;
			mo.z = p.mo.z + p.mo.height - mo.height;
		else
			mo.eflags = $ & ~MFE_VERTICALFLIP;
			mo.flags2 = $ & ~MF2_OBJECTFLIP;
			mo.z = p.mo.z;
		end
		mo.angle = p.drawangle;
		return true
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
addHook("HUD", function(v, _, x, y, scale, skin, spr2, frame, rot, color)
	if skin ~= "realsmwluigi" then return end
	
	local cmap = v.getColormap("realoverluigi", SMW.getOverlayColor(consoleplayer, color))
	local ovSpr2, ovFlip = v.getSprite2Patch("realoverluigi", spr2, false, frame, rot)
	
	v.drawScaled(x, y, scale, ovSpr2, (ovFlip and V_FLIP or 0), cmap)
end, "playersetup")