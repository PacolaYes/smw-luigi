
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

local state = {
	states = {},
	enums = {}
}

local function emptyFunc() end

local function baseState()
	return {
		enter = emptyFunc,
		exit = emptyFunc,
		playerthink = emptyFunc,
		thinkframe = emptyFunc,
		postthinkframe = emptyFunc
	}
end

state.enums.BASE = 0
state.states[0] = baseState()

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
			error("Hey! This state has already been found!")
			return
		end
	end
	
	local newfuncList = baseState()
	for k, val in pairs(funcList) do
		if tonumber(k) ~= nil then
			newfuncList[k] = val
		else
			newfuncList[tostring(k):lower()] = val
		end
	end
	
	state.enums[name] = stateNum
	state.states[stateNum] = newfuncList
end

local function playerCheck(p)
	if not (p and p.valid)
	or userdataType(p) ~= "player_t" then
		error("Please provide a player!")
		return false
	end
	return true
end

function state.getState(p, gstate)
	if not playerCheck(p) then return end
	
	if gstate == nil then
		gstate = p.smw.state
	end
	return state.states[gstate] or state.states[0]
end

function state.exists(stateNum)
	return stateNum ~= nil and state.states[stateNum] ~= nil
end

function state.changeState(p, cstate)
	if not playerCheck(p) then return end
	
	if state.exists(cstate) then
		local hookResult = SMW.executeHook("ChangeState", p, p.smw.state, cstate)
		if hookResult ~= false
		and (cstate ~= 0 or hookResult == true) then
			state.getState(p, cstate):enter(p)
			state.getState(p):exit(p)
			p.smw.state = cstate
		end
	end
end

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