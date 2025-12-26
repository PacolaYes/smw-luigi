
-- this one is not obvious
-- jtgj
-- -pac

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
end)