
-- this one is not obvious
-- jtgj
-- -pac

local SMW = RealSMWLuigi

RealSMWLuigi.replacementMusic = {
	["_INV"] = {"SMWINV", true},
	["_MINV"] = {"SMWINV", true},
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
		for key, value in ipairs(SMW.replacementMusic[old_music[1]]) do
			old_music[key] = value
		end
	end
	
	return unpack(old_music)
end)

sfxinfo[freeslot("sfx_smwslw")].caption = "Star Running Out"

addHook("PlayerThink", function(p)
	if not SMW.luigiCheck(p) then return end
	
	if p.powers[pw_invulnerability] == TICRATE
	and not S_SoundPlaying(p.mo, sfx_smwslw) then
		S_StartSound(p.mo, sfx_smwslw)
	end
end)

addHook("MobjThinker", function(mo)
	if mo.skin == "realsmwluigi" then
		if mo.smwoldtranslation == nil then
			mo.smwoldtranslation = mo.translation
		end
		
		mo.translation = SMW.handleTrans(mo)
	elseif mo.smwoldtranslation then
		mo.smwoldtranslation, mo.translation = nil, $1
	end
end, MT_OVERLAY)