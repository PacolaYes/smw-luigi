
-- functions!!
-- just the stuff so the RealSMWLuigi variable can get 'em!

local funcs = dofile("Libs/text.lua")

function funcs.abilityCheck(p) -- base ability check :P
	return not (
		P_PlayerInPain(p)
		or p.playerstate == PST_DEAD
		or (p.mo and p.mo.valid) and not p.mo.health
		or p.exiting
	)
end

-- converts a value from SMW to FUs, fully based on (insert link here)
function funcs.convertValue(val, comparison, comparison2, signed)
	if val == nil then return end
	
	if comparison == nil then comparison = 36*FU end
	if comparison2 == nil then comparison2 = 3*FU end
	if signed == nil then signed = true end
	
	val = tonumber($, 16) -- converts to decimal
	if signed
	and val >= 128 then -- if its a signed number and its higher or equals than 128
		val = 256-$ -- subtract it from 256, making it the equivalent, just not negative :P
	end
	
	val = FixedDiv($, 16) -- convert from subpixels to the pixels value in FUs
	return FixedMul(val, FixedDiv(comparison, comparison2)) -- yes, sprint speed is 3 pixels/frame
end

-- gets what color the overlay should use
function funcs.getOverlayColor(p, color)
	local fColor = RealSMWLuigi.overlayColor[color] or ColorOpposite(color)
	if type(p) == "userdata"
	and userdataType(p) == "player_t"
	and (p and p.valid) then
		fColor = p.smw.forceOverlayColor or p.smw.overlayColor or $
	end
	
	return fColor
end

function funcs.isMoving(p)
	local is2D = (p.mo and p.mo.valid) and (p.mo.flags2 & MF2_TWOD) or twodlevel
	
	local forward = not is2D and p.cmd.forwardmove or 0
	return (forward or p.cmd.sidemove) and true or false, forward
end

function funcs.getMoveAngle(p)
	local isMoving, forward = funcs.isMoving(p)
	
	local add = isMoving and R_PointToAngle2(0, 0, forward*FU, -p.cmd.sidemove*FU) or 0
	return (p.cmd.angleturn<<16) + add or 0
end

-- L_ZLaunch made by clairebun
-- it can be found at
-- https://wiki.srb2.org/wiki/User:Clairebun/Sandbox/Common_Lua_Functions#L_ZLaunch
-- -pac
function funcs.ZLaunch(mo,thrust,relative)
	if mo.eflags&MFE_UNDERWATER
		thrust = $*3/5
	end
	P_SetObjectMomZ(mo,thrust,relative)
end

function funcs.InstaThrust(mo, angle, speed)
	if (mo.eflags & MFE_UNDERWATER) then
		speed = $/2
	end
	
	P_InstaThrust(mo, angle, FixedMul(speed, mo.scale))
end

return funcs