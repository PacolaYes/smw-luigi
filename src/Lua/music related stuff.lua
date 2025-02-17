
-- this one is not obvious
-- jtgj
-- -pac

local SMW = RealSMWLuigi

local luigiMusList = {
	["_INV"] = {"SMWINV", true},
	["_MINV"] = {"SMWINV", true},
	["_BOSS"] = {"SMWBB"},
	["_CLEAR"] = {"SMWCC"},
	["_GOVER"] = {"SMWGO"}
}

addHook("MusicChange", function(_, new, mflags, loop, pos, prefade, fadein)
	if not consoleplayer
	or skins[consoleplayer.skin].name ~= "realsmwluigi" then return end
	
	new = $:upper()
	if luigiMusList[new] then
		if luigiMusList[new][2] then
			loop = luigiMusList[new][2]
		end
		if luigiMusList[new][1] then
			new = luigiMusList[new][1]
		end
	end
	
	return new, mflags, loop, pos, prefade, fadein
end)

sfxinfo[freeslot("sfx_smwslw")].caption = "Star Running Out"

addHook("PlayerThink", function(p)
	if not SMW.luigiCheck(p) then return end
	
	if p.powers[pw_invulnerability] == TICRATE
	and not S_SoundPlaying(p.mo, sfx_smwslw) then
		S_StartSound(p.mo, sfx_smwslw)
	end
	
	p.mo.translation = SMW.handleTrans(p.mo)
end)

addHook("MobjThinker", function(mo)
	if mo.skin == "realsmwluigi"
		if mo.smwoldtranslation == nil then
			mo.smwoldtranslation = mo.translation
		end
		
		mo.translation = SMW.handleTrans(mo)
	elseif mo.smwoldtranslation then
		mo.smwoldtranslation, mo.translation = nil, $1
	end
end, MT_OVERLAY)