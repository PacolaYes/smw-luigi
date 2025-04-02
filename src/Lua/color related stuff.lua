
-- simple stuff related to colors
-- also includes the overlay
-- since it's related to the overalls' color :P

local SMW = RealSMWLuigi

local invulnColors = {
	{SKINCOLOR_SMWRED},
	{SKINCOLOR_SMWGREEN},
	{SKINCOLOR_SMWWHITE, SKINCOLOR_SMWFIRERED},
	{SKINCOLOR_SMWWHITE, SKINCOLOR_SMWFIREGREEN}
}

addHook("PlayerThink", function(p)
	if not SMW.luigiCheck(p) then return end
	
	if p.powers[pw_invulnerability] then
		local invulnColor = invulnColors[((leveltime / 2) % #invulnColors) + 1]
		p.mo.color = invulnColor[1]
		p.smw.forceOverlayColor = invulnColor[2]
		
		if p.powers[pw_invulnerability] == 1 then
			p.smw.forceOverlayColor = 0
		end
	end
end)

-- followmobj stuff
-- a.k.a the overlay

freeslot("MT_SMWOVERLAY")

mobjinfo[MT_SMWOVERLAY] = {
	spawnstate = S_INVISIBLE
}

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
end, MT_SMWOVERLAY)

addHook("HUD", function(v, _, x, y, scale, skin, spr2, frame, rot, color)
	if skin ~= "realsmwluigi" then return end
	
	local cmap = v.getColormap("realoverluigi", SMW.getOverlayColor(p, color))
	local ovSpr2, ovFlip = v.getSprite2Patch("realoverluigi", spr2, false, frame, rot)
	
	v.drawScaled(x, y, scale, ovSpr2, (ovFlip and V_FLIP or 0), cmap)
end, "playersetup")