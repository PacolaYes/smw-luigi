
-- handles the normal state
-- for when you should do stuff like
-- running & spin-jumping & the rest :P
-- -pac

local SMW = RealSMWLuigi
local state = SMW.dofile("Libs/states.lua") ---@type smw_statelib

local crouch_pthink, crouch_postthink = SMW.dofile("Abilities/crouch.lua") ---@type function, function
local pspeed_pthink, pspeed_postthink = SMW.dofile("Abilities/p-speed.lua") ---@type function, function
local spinjump_pthink, spinjump_thinkframe = SMW.dofile("Abilities/spinjump.lua") ---@type function, function

local function check(p)
	return not (
		p.playerstate == PST_DEAD
		or not p.mo.health
	)
end

---@param p player_t
local function pthink(_, p)
	if not check(p) then return end
	
	if SMW.isUnderwater(p.mo) then
		return state.enums.UNDERWATER
	end
	
	crouch_pthink(p)
	spinjump_pthink(p)
	pspeed_pthink(p)
	
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

---@param p player_t
local function thinkframe(_, p)
	if not check(p) then return end
	
	spinjump_thinkframe(p)
end

---@param p player_t
local function postthink(_, p)
	if not check(p) then return end
	
	crouch_postthink(p)
	pspeed_postthink(p)
end

state.create("normal", {
	PlayerThink = pthink,
	ThinkFrame = thinkframe,
	PostThinkFrame = postthink
})