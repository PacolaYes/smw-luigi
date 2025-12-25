
-- handles the normal state
-- for when you should do stuff like
-- running & spin-jumping & the rest :P
-- -pac

local SMW = RealSMWLuigi
local state = SMW.dofile("Libs/states.lua") ---@type smw_statelib

local crouch_pthink, crouch_postthink = dofile("Abilities/crouch.lua") ---@type function, function
local pspeed = dofile("Abilities/p-speed.lua") ---@type function
local spinjump_pthink, spinjump_thinkframe = dofile("Abilities/spinjump.lua") ---@type function, function

local function check(p)
	return not (
		p.playerstate == PST_DEAD
		or not p.mo.health
	)
end

local function pthink(self, p)
	if not check(p) then return end
	
	if (p.mo.eflags & MFE_UNDERWATER) then
		return state.enums.UNDERWATER
	end
	
	crouch_pthink(p)
	spinjump_pthink(p)
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
	
	spinjump_thinkframe(p)
end

local function postthink(self, p)
	if not check(p) then return end
	
	crouch_postthink(p)
end

state.create("normal", {
	PlayerThink = pthink,
	ThinkFrame = thinkframe,
	PostThinkFrame = postthink
})