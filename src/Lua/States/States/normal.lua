
-- handles the normal state
-- for when you should do stuff like
-- running & spin-jumping & the rest :P
-- -pac

local SMW = RealSMWLuigi
local state = SMW.state
local heist = SMW.dofile("Compatibility/fangs heist.lua")

local crouch = dofile("Abilities/crouch.lua")
local pspeed = dofile("Abilities/p-speed.lua")
local spinjump = dofile("Abilities/spinjump.lua")

local function check(p)
	return not (
		p.playerstate == PST_DEAD
		or not p.mo.health
	)
end

local function pthink(self, p)
	if not check(p) then return end
	
	if (p.mo.eflags & MFE_UNDERWATER)
	and not heist.inMode() then
		return state.enums.UNDERWATER
	end
	
	crouch[1](p)
	spinjump[1](p)
	pspeed(p)
	
	if (p.cmd.buttons & BT_CUSTOM3)
	and (p.panim == PA_IDLE or p.panim == PA_EDGE) then
		local panim = p.panim
		p.mo.state = S_LUIGI_LOOKUP
		p.panim = panim
	elseif p.mo.state == S_LUIGI_LOOKUP
	and not (p.cmd.buttons & BT_CUSTOM3) then
		p.mo.state = p.panim == PA_EDGE and S_PLAY_EDGE or S_PLAY_STND
	end
end

local function thinkframe(self, p)
	if not check(p) then return end
	
	spinjump[2](p)
end

local function postthink(self, p)
	if not check(p) then return end
	
	crouch[2](p)
end

state.create("normal", {
	PlayerThink = pthink,
	ThinkFrame = thinkframe,
	PostThinkFrame = postthink
})