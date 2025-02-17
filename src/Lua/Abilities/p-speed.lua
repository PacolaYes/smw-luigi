
-- P-Speed!!
-- from hit Mario game
-- mario world

local SMW = RealSMWLuigi
local heist = SMW.require("Compatibility/fangs heist.lua")

CV_RegisterVar({
	name = "luigi_maxspeed",
	defaultvalue = "Fast",
	flags = CV_NETVAR,
	PossibleValue = {
		["Slow"] = 0,
		["Fast"] = 1,
		["Turtle"] = 2,
	}
})

freeslot("S_LUIGI_FLY")

states[S_LUIGI_FLY] = {
	sprite = SPR_PLAY,
	frame = SPR2_TWIN,
	tics = -1
}

-- i lov stealing values from Super Mario World released for the Super Nintendo Entertainment System
local speedvals = {
	[1] = {
		[1] = SMW.convertValue("14", 36*FU), -- walking spd
		[2] = SMW.convertValue("24", 36*FU), -- running spd
		[3] = 36*FU -- p-speed / sprinting spd
	},
	[0] = {
		[1] = SMW.convertValue("14", 24*FU),
		[2] = SMW.convertValue("24", 24*FU),
		[3] = 24*FU
	},
	[2] = {
		[1] = SMW.convertValue("14", 18*FU),
		[2] = SMW.convertValue("24", 18*FU),
		[3] = 18*FU
	}
}

local maxTime = FixedRound(FixedDiv(112, 60)*TICRATE)/FU

local function is2D(mo)
	return (mo.flags2 & MF2_TWOD) or twodlevel
end

local function shouldGoUp(p)
	if (P_IsObjectOnGround(p.mo) or p.smw.pmeter.prejumptime >= maxTime)
	and not P_PlayerInPain(p)
	and p.playerstate ~= PST_DEAD
	and P_GetPlayerControlDirection(p) == 1 then
		return true
	end
	return false
end

local function getSpeedFromTime(time, p)
	local sprintSpd = speedvals[CV_FindVar("luigi_maxspeed").value] or speedvals[1]
	
	if (p and p.valid)
	and heist.shouldNerf(p) then
		sprintSpd = speedvals[0]
	end
	
	return time >= maxTime and sprintSpd[3] or time > 0 and sprintSpd[2] or sprintSpd[1]
end

local function pthink(p)
	local plyrSpd = FixedDiv(FixedHypot(p.rmomx, p.rmomy), p.mo.scale)
	local runSpd = getSpeedFromTime(1, p)
	
	if (p.cmd.buttons & BT_SPIN)
		if shouldGoUp(p) -- increase the time if it should be increased
		and plyrSpd >= runSpd-5*FU then -- and if you're at around your max running spd
			p.smw.pmeter.time = min($+2, maxTime) -- if so then increase the p-meter time by 2 every frame
		else
			p.smw.pmeter.time = max(1, $-1) -- otherwise, decrease it by 1 every frame, with a minimum of 1 (0 is used by the speed func to get the walking spd, pretty janky i know :P)
		end
	elseif p.smw.pmeter.time ~= 0 then -- if you're not holding spin and the meter isn't 0 then
		p.smw.pmeter.time = max(0, $-1) -- decrease it with the smallest value allowed being 0
	end
	
	local time = (p.cmd.buttons & BT_SPIN) and p.smw.pmeter.time or 0 -- if you're pressing spin then get the speed according to the p-meter time, otherwise use time 0, which is the time for the walking speed
	p.normalspeed = getSpeedFromTime(time, p) -- set the player's normalspeed to a speed using the time from the variable that was just created
	p.runspeed = runSpd+5*FU
	
	if p.panim == PA_JUMP
	and plyrSpd >= p.runspeed then
		p.mo.state = S_LUIGI_FLY
	end
	
	-- kind of a misleading name since it's more of a time it was on the grounded buut i dont want it to be massive and idk how else to make it smaller!!
	if P_IsObjectOnGround(p.mo) then -- if you're grounded then
		p.smw.pmeter.prejumptime = p.smw.pmeter.time -- set the pre mid-air time variable to whatever the p-meter time is rn
	end
end

-- debugging stuff down here
addHook("HUD", function(v, p)
	if not p.smw
	or p.smw.pmeter.time == nil then return end
	
	v.drawString(320, 0, "meter %: "+FixedRound(FixedDiv(max(p.smw.pmeter.time-1, 0), maxTime-1)*100)/FU+"%", V_SNAPTORIGHT|V_SNAPTOBOTTOM, "right")
	v.drawString(320, 8, "meter in tics: "+p.smw.pmeter.time, V_SNAPTORIGHT|V_SNAPTOBOTTOM, "right")
end)

return pthink