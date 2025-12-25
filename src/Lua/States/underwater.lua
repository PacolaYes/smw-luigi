
-- handles all you can do underwater
-- i think its better to do stuff here, idk!!

local SMW = RealSMWLuigi
local state = SMW.dofile("Libs/states.lua") ---@type smw_statelib

local swim = dofile("Abilities/swim.lua")

local uwGrav = SMW.convertValue("02", FU/2, 2*FU)
local baseUWGrav = FU/2 / 3

local function pthink(self, p)
	if p.playerstate == PST_DEAD
	or not p.mo.health then return end
	
	if not (p.mo.eflags & MFE_UNDERWATER)then
		return state.enums.NORMAL
	end
	
	-- force stuff, because i HATE these!!
	p.smw.flags = $ & ~(SMWF_SJUMPED|SMWF_STARTSJUMP)
	if p.smw.crouched then
		p.pflags = $ & ~PF_SPINNING -- dont continue sliding pls
	end
	p.smw.crouched = false
	
	swim(p)
	
	/*if p.mo.momz then
		local grav = abs(P_GetMobjGravity(p.mo))
		local mul = FixedDiv(grav, baseUWGrav)
		local uGrav = FixedMul(uwGrav, mul)
		
		P_SetObjectMomZ(p.mo, grav-uGrav, true)
	end*/
end
state.create("underwater", {
	PlayerThink = pthink
})