
-- freeslots
-- the abilities!!
-- or something like that!!
-- -pac

-- p-speed
freeslot("S_LUIGI_FLY")

states[S_LUIGI_FLY] = {
	sprite = SPR_PLAY,
	frame = SPR2_TWIN,
	tics = -1
}

-- spinjump
sfxinfo[freeslot("sfx_smwspj")].caption = "Spinjump"
sfxinfo[freeslot("sfx_smwssp")].caption = "Super Boot-stomp"
sfxinfo[freeslot("sfx_smwbsp")].caption = "Boot-stomp"

-- swim
freeslot("S_LUIGI_SWIMIDLE")

states[S_LUIGI_SWIMIDLE] = {
	sprite = SPR_PLAY,
	sprite2 = SPR2_TWIN,
	frame = A,
	tics = -1
}