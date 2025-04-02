
-- gives luig
-- compatibiltiy for fang hesit
-- hooray!
-- -pac

local fang = {}

function fang.shouldNerf(p)
	return FangsHeist and not FangsHeist.canUseAbility(p) or false
end

function fang.inMode()
	return FangsHeist and FangsHeist.isMode() or false
end

RealSMWLuigi.addHook("PSpeedHandle", function(p)
	if fang.inMode()
	and fang.shouldNerf(p)
	and not P_IsObjectOnGround(p.mo)
	and (p.cmd.buttons & BT_SPIN) then
		return true
	end
end)

return fang