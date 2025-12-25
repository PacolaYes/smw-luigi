
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