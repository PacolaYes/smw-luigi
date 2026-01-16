
-- handles all you can do underwater
-- i think its better to do stuff here, idk!!

local SMW = RealSMWLuigi
local state = SMW.dofile("Libs/states.lua") ---@type smw_statelib

local swim = SMW.dofile("Abilities/swim.lua")

local uwGrav = SMW.convertValue("02", FU/2, 2*FU)
local baseUWGrav = FU/2 / 3

---@param p player_t
local function pthink(_, p)
	if p.playerstate == PST_DEAD
	or not p.mo.health then return end

	if not (p.mo.eflags & MFE_VERTICALFLIP)
	and p.mo.momz > 0
	and (p.mo.z + p.mo.height/2 + p.mo.momz) > p.mo.watertop then
		p.mo.momz = -FU

		p.mo.z = min(p.mo.watertop - p.mo.height/2, p.mo.ceilingz - p.mo.height)
		if (p.cmd.buttons & BT_CUSTOM3)
		and (p.cmd.buttons & BT_JUMP)
		and p.mo.z+p.mo.height >= p.mo.watertop then
			P_DoJump(p, true)
		else
			p.mo.z = $
		end
	elseif (p.mo.eflags & MFE_VERTICALFLIP) -- i love copy and paste
	and p.mo.momz < 0
	and (p.mo.z - p.mo.height/2) > p.mo.waterbottom
	and (p.mo.z - p.mo.height/2 + p.mo.momz) < p.mo.waterbottom then
		p.mo.momz = FU

		p.mo.z = max(p.mo.waterbottom + p.mo.height/2, p.mo.floorz)
		if (p.cmd.buttons & BT_CUSTOM3)
		and (p.cmd.buttons & BT_JUMP)
		and p.mo.z <= p.mo.waterbottom then
			P_DoJump(p, true)
		end
	end
	
	if not SMW.isUnderwater(p.mo) then
		return state.enums.NORMAL
	end
	
	-- force stuff, because i HATE these!!
	p.smw.flags = $ & ~(SMWF_SJUMPED|SMWF_STARTSJUMP)
	p.pflags = $ & ~(PF_JUMPED|PF_STARTJUMP)
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