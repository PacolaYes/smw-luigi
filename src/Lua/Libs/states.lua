
-- hi!!
-- this handles state stuff!!
-- mostly used for handling when
-- you're in flight or yoshi
-- stuff like that!!
-- -pac

-- i thin kthis is like, called a finite state machine buut
-- i dont use no fancy terms, this is the "shit that handles states"
-- a.k.a the STHS (sonic the hedgehog saturn :P)
-- -pac

local SMW = RealSMWLuigi
local hooks = SMW.dofile("Libs/hooks.lua") ---@type smw_hooklib

---@class smw_statelib
local state = {
	states = {}, ---@type table<integer, smw_state_t>
	enums = {} ---@type table<string, integer>
}

local function emptyFunc() end

state.enums.BASE = 0
---@class smw_state_t
state.states[0] = {
	enter = emptyFunc, ---@type fun(self: smw_state_t, player: player_t)? Executes once you enter the state. <br>`player.smw.state` will be the previous state.
	exit = emptyFunc, ---@type fun(self: smw_state_t, player: player_t)? Executes once you exit the state. <br>`player.smw.state` will be the new state.
	playerthink = emptyFunc, ---@type fun(self: smw_state_t, player: player_t)? Executes every tic a player thinks.
	thinkframe = emptyFunc, ---@type fun(self: smw_state_t, player: player_t)? Executes every tic, triggers before(?) `playerthink`.
	postthinkframe = emptyFunc ---@type fun(self: smw_state_t, player: player_t)? Executes every tic, after everything else.
}

local state_mt = { ---@type metatable
	__index = state.states[0]
}
registerMetatable(state_mt)

--- Creates a state.
---@param name string
---@param funcList table<string | number, function>
---@param overwrite boolean?
function state.create(name, funcList, overwrite)
	if name == nil
	or funcList == nil
	or type(funcList) ~= "table" then return end
	
	name = tostring($):upper()
	
	local stateNum = 0 -- start at BASE
	for _ in pairs(state.states) do -- will this resync?
		stateNum = $+1 -- and go up based on the state numbers (so you'll be at 1 without any other states added :P)
	end
	
	if state.enums[name] ~= nil then
		if overwrite then
			stateNum = state.enums[name]
		else
			error("Hey! This state has already been found!", 2)
			return
		end
	end

	local new_funcList = setmetatable({}, state_mt)
	for key, val in pairs(funcList) do
		if type(key) == "string" then
			new_funcList[key:lower()] = val
		else
			new_funcList[key] = val
		end
	end
	
	state.enums[name] = stateNum
	state.states[stateNum] = new_funcList
end

--- Gets the state specified, or the player's current state.
---@param p player_t?
---@param gstate integer?
---@return smw_state_t
function state.getState(p, gstate)
	if not (p and p.valid) and gstate == nil then
		return state.states[0]
	end

	if (p and p.valid)
	and gstate == nil then
		gstate = p.smw.state
	end

	return state.states[gstate] or state.states[0]
end

--- Returns if the specified state number exists.
---@param stateNum integer
---@return boolean
function state.exists(stateNum)
	return stateNum ~= nil and state.states[stateNum] ~= nil
end

--- changes the player's state to the specified one.
---@param p player_t
---@param cstate integer
function state.changeState(p, cstate)
	if not (p and p.valid) then return end
	
	if state.exists(cstate) then
		local hookResult = hooks.executeHook("ChangeState", p, p.smw.state, cstate)
		if hookResult ~= false
		and (cstate ~= 0 or hookResult == true) then
			state.getState(p, cstate):enter(p)
			p.smw.state = cstate
			state.getState(p):exit(p)
		end
	end
end

---@param p player_t
addHook("PlayerThink", function(p)
	if not SMW.luigiCheck(p) then return end
	
	p.powers[pw_underwater] = 0
	p.powers[pw_spacetime] = 0 -- dont drown pleaase :D
	
	local nextState = state.getState(p):playerthink(p)
	state.changeState(p, nextState) -- already handles if the state may or may not exist!
	
	p.smw.lastpflags = p.pflags -- self-explanatory name, only here because of sliding :P
end)

addHook("ThinkFrame", function()
	for p in players.iterate do
		if not SMW.luigiCheck(p) then continue end
		
		local nextState = state.getState(p):thinkframe(p)
		state.changeState(p, nextState)
	end
end)

addHook("PostThinkFrame", function()
	for p in players.iterate do
		if not SMW.luigiCheck(p) then continue end
		
		local nextState = state.getState(p):postthinkframe(p)
		state.changeState(p, nextState)
	end
end)

return state