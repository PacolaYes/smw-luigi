
-- handles the normal state
-- for when you should do stuff like
-- running & spin-jumping & the rest :P
-- -pac

local SMW = RealSMWLuigi
local state = SMW.state
local heist = SMW.require("Compatibility/fangs heist.lua")

local pspeed = dofile("Abilities/p-speed.lua")
local spinjump = dofile("Abilities/spinjump.lua")

local function pthink(self, p)
	if p.playerstate == PST_DEAD
	or not p.mo.health then return end
	
	if (p.mo.eflags & MFE_UNDERWATER)
	and not heist.inMode() then
		return state.enums.UNDERWATER
	end
	
	spinjump[1](p)
	pspeed(p)
end

local function thinkframe(self, p)
	if p.playerstate == PST_DEAD
	or not p.mo.health then return end
	
	spinjump[2](p)
end

state.create("normal", {
	PlayerThink = pthink,
	ThinkFrame = thinkframe
})