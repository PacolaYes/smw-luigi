
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
	if (p.cmd.buttons & BT_JUMP)
	and not (p.lastbuttons & BT_JUMP) then
		SMW.ZLaunch(p.mo, swimThrust, true)
		
		local uMax = (p.cmd.buttons & BT_CUSTOM3) and swimMaxU or (p.cmd.buttons & BT_CUSTOM2) and swimMaxD or swimMaxN
		if p.mo.momz*P_MobjFlip(p.mo) > uMax*2 then
			P_SetObjectMomZ(p.mo, uMax*2)
		end
	end
end

return pthink