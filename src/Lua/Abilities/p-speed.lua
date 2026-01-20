
-- P-Speed!!
-- from hit Mario game
-- mario world

---@diagnostic disable: missing-fields

local SMW = RealSMWLuigi
local hooks = SMW.dofile("Libs/hooks.lua") ---@type smw_hooklib

CV_RegisterVar({
	name = "luigi_maxspeed",
	defaultvalue = "Fast",
	flags = CV_NETVAR,
	PossibleValue = {
		["Fast"] = 0,
		["Slow"] = 1,
		["Turtle"] = 2
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
	[0] = {
		[1] = SMW.convertValue("14", 36*FU), -- walking spd
		[2] = SMW.convertValue("24", 36*FU), -- running spd
		[3] = 36*FU -- p-speed / sprinting spd
	},
	[1] = {
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

---@param mo mobj_t
local function is2D(mo)
	return (mo.flags2 & MF2_TWOD) or twodlevel
end

---@param p player_t
local function shouldGoUp(p)
	if (P_IsObjectOnGround(p.mo) or p.mo.smw.pmeter.prejumptime >= maxTime)
	and SMW.abilityCheck(p)
	and P_GetPlayerControlDirection(p) == 1 then
		return true
	end
	return false
end

---@param time tic_t
---@param p player_t?
local function getSpeedFromTime(time, p)
	local sprintSpd = speedvals[CV_FindVar("luigi_maxspeed").value] or speedvals[1]
	
	return time >= maxTime and sprintSpd[3] or time > 0 and sprintSpd[2] or sprintSpd[1]
end

---@param p player_t
local function pthink(p)
	local plyrSpd = FixedDiv(R_PointToDist2(0, 0, p.rmomx, p.rmomy), p.mo.scale)
	local runSpd = getSpeedFromTime(1, p)
	
	local hookResults = hooks.executeHook("PSpeedHandle", p)
	if not hookResults then
		if (p.cmd.buttons & BT_SPIN)
		and not p.smw.crouched then
			if shouldGoUp(p) -- increase the time if it should be increased
			and plyrSpd >= runSpd-5*FU then -- and if you're at around your max running spd
				p.mo.smw.pmeter.time = min($+2, maxTime) -- if so then increase the p-meter time by 2 every frame
			else
				p.mo.smw.pmeter.time = max(1, $-1) -- otherwise, decrease it by 1 every frame, with a minimum of 1 (0 is used by the speed func to get the walking spd, pretty janky i know :P)
			end
		elseif p.mo.smw.pmeter.time ~= 0 then -- if you're not holding spin and the meter isn't 0 then
			p.mo.smw.pmeter.time = max(0, $-1) -- decrease it with the smallest value allowed being 0
		end
	
		local time = (p.cmd.buttons & BT_SPIN) and p.mo.smw.pmeter.time or 0 -- if you're pressing spin then get the speed according to the p-meter time, otherwise use time 0, which is the time for the walking speed
		p.normalspeed = getSpeedFromTime(time, p) -- set the player's normalspeed to a speed using the time from the variable that was just created
		p.runspeed = runSpd+3*FU
	end
	
	-- kind of a misleading name since it's more of a time it was on the grounded buut i dont want it to be massive and idk how else to make it smaller!!
	if P_IsObjectOnGround(p.mo) then -- if you're grounded then
		p.mo.smw.pmeter.prejumptime = p.mo.smw.pmeter.time -- set the pre mid-air time variable to whatever the p-meter time is rn
	elseif not (p.pflags & PF_JUMPED) then
		p.mo.smw.pmeter.prejumptime = 0 -- only do it if you've jumped :P
	end
end

---@param p player_t
local function postthink(p)
	local plyrSpd = FixedDiv(R_PointToDist2(0, 0, p.rmomx, p.rmomy), p.mo.scale)

	if p.panim == PA_JUMP -- above the thing that sets runspeed so it can get other when other mods edit it :P
	and plyrSpd >= min(p.runspeed, getSpeedFromTime(maxTime, p)) then
		p.mo.state = S_LUIGI_FLY
	end
end

-- debugging stuff down here
if devparm then
	local hud = SMW.dofile("Libs/hud.lua") ---@type smw_hudlib

	---@param v videolib
	---@param p player_t
	addHook("HUD", function(v, p)
		if not SMW.luigiCheck(p) then return end
		
		hud.drawString(
			v, 320, 0, FU,
			"meter %: "+FixedRound(FixedDiv(max(p.mo.smw.pmeter.time-1, 0), maxTime-1)*100)/FU+"%\nmeter in tics: "+p.mo.smw.pmeter.time,
			V_SNAPTORIGHT|V_SNAPTOTOP, "right"
		)
	end)
end

return pthink, postthink, getSpeedFromTime