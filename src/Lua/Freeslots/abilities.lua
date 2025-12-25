
-- freeslots
-- the abilities!!
-- or something like that!!
-- -pac

---@diagnostic disable: missing-fields

function A_SetFrame(mo, var1, var2)
	if mo.state == mo.setframeoldstate then return end
	
	local uframe = var1
	if (mo.frame & FF_FRAMEMASK) then
		uframe = var2
	end
	mo.frame = uframe|($ & ~FF_FRAMEMASK)
	mo.setframeoldstate = mo.state
end

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
freeslot(
	"S_LUIGI_SWIMIDLE",
	"S_LUIGI_SWIM"
)

sfxinfo[freeslot("sfx_smwswm")].caption = "Swim"

if SUBVERSION < 16 then
	states[S_LUIGI_SWIMIDLE] = {
		sprite = SPR_PLAY,
		frame = SPR2_SWIM,
		action = A_SetFrame,
		tics = -1,
		var1 = A
	}

	states[S_LUIGI_SWIM] = {
		sprite = SPR_PLAY,
		frame = SPR2_SWIM|FF_SPR2ENDSTATE,
		action = A_SetFrame,
		tics = 5,
		var1 = S_LUIGI_SWIMIDLE,
		var2 = B,
		nextstate = S_LUIGI_SWIM
	}
else
	states[S_LUIGI_SWIMIDLE] = {
		sprite = SPR_PLAY,
		sprite2 = SPR2_SWIM,
		frame = A,
		tics = -1
	}

	states[S_LUIGI_SWIM] = {
		sprite = SPR_PLAY,
		sprite2 = SPR2_SWIM,
		frame = B|FF_SPR2ENDSTATE,
		tics = 5,
		var1 = S_LUIGI_SWIMIDLE,
		nextstate = S_LUIGI_SWIM
	}
end

-- crouuuch
-- also slide :D
freeslot(
	"S_LUIGI_CROUCH",
	"S_LUIGI_SLIDE"
)

states[S_LUIGI_CROUCH] = {
	sprite = SPR_PLAY,
	frame = SPR2_LAND
}

states[S_LUIGI_SLIDE] = {
	sprite = SPR_PLAY,
	frame = SPR2_FLT_
}

-- looking up
-- not really an ability but ehh :P
freeslot("S_LUIGI_LOOKUP")

states[S_LUIGI_LOOKUP] = {
	sprite = SPR_PLAY,
	frame = SPR2_MLEE
}