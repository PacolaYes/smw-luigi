
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

return fang