
-- hello, i am under the water
-- pleas help me

local SMW = RealSMWLuigi

local srb2jump = FixedMul(39*(FU/4), FU+FU/10)
local smwjump = 5*FU

local swimThrust = SMW.convertValue("E0", srb2jump, smwjump)

local swimMaxU = SMW.convertValue("D0", srb2jump, smwjump)
local swimMaxN = SMW.convertValue("E8", srb2jump, smwjump)
local swimMaxD = SMW.convertValue("F8", srb2jump, smwjump)

local function pthink(p)
	if p.mo.state ~= S_LUIGI_SWIMIDLE
	and p.mo.state ~= S_LUIGI_SWIM
	and not P_IsObjectOnGround(p.mo) then
		p.mo.state = S_LUIGI_SWIMIDLE
		p.mo.frame = A | ($ & ~FF_FRAMEMASK)
	elseif (p.mo.state == S_LUIGI_SWIMIDLE or p.mo.state == S_LUIGI_SWIM)
	and P_IsObjectOnGround(p.mo) then
		p.mo.state = S_PLAY_STND
	end
	
	if (p.cmd.buttons & BT_JUMP)
	and not (p.lastbuttons & BT_JUMP)
	and SMW.abilityCheck(p) then
		SMW.ZLaunch(p.mo, swimThrust, true)
		
		local uMax = (p.cmd.buttons & BT_CUSTOM3) and swimMaxU or (p.cmd.buttons & BT_CUSTOM2) and swimMaxD or swimMaxN
		if p.mo.momz*P_MobjFlip(p.mo) > uMax*2 then
			P_SetObjectMomZ(p.mo, uMax*2)
		end
		
		local ostate = p.mo.state
		p.mo.state = S_LUIGI_SWIM
		
		if ostate ~= S_LUIGI_SWIM then
			p.mo.frame = B | ($ & ~FF_FRAMEMASK) -- anim resets in og smw too, doesn't it??
		end
		S_StartSound(p.mo, sfx_smwswm)
	end
	p.pflags = $1|PF_JUMPSTASIS
end

return pthink