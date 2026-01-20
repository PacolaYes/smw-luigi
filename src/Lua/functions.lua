
-- general functions!!
-- just the stuff so the RealSMWLuigi variable can get 'em!

--- Checks if the player can use a basic ability.
---@param p player_t
---@return boolean
function RealSMWLuigi.abilityCheck(p)
	return not (
		P_PlayerInPain(p)
		or p.playerstate == PST_DEAD
		or (p.mo and p.mo.valid) and not p.mo.health
		or p.exiting
	)
end

--- Converts a value from SMW to FUs, fully based on (insert link here)
---@param val string The value in hexadecimal.
---@param comparison fixed_t?
---@param comparison2 fixed_t?
---@param signed boolean? If the value is signed.
---@return fixed_t
function RealSMWLuigi.convertValue(val, comparison, comparison2, signed)	
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

-- Gets what color the overlay should use.
---@param p player_t
---@param color skincolornum_t | integer
---@return skincolornum_t overlayColor
function RealSMWLuigi.getOverlayColor(p, color)
	local fColor = RealSMWLuigi.overlayColor[color] or ColorOpposite(color)
	if (p and p.valid)
	and p.smw then
		fColor = p.smw.forceOverlayColor or p.smw.overlayColor or $
	end
	
	return fColor ---@type skincolornum_t
end

--- Returns if the player's trying to move, taking 2D into account.
---@param p player_t
---@return boolean moving if the player's trying to move.
---@return integer forwardmove the player's `cmd.forwardmove`, taking 2D into account.
function RealSMWLuigi.isMoving(p)
	local is2D = (p.mo and p.mo.valid) and (p.mo.flags2 & MF2_TWOD) or twodlevel
	
	local forward = not is2D and p.cmd.forwardmove or 0
	return ((forward or p.cmd.sidemove) and true or false), forward
end

--- Gets the angle that the player's directional inputs are going in.
---@param p player_t
---@return angle_t
function RealSMWLuigi.getMoveAngle(p)
	local isMoving, forward = RealSMWLuigi.isMoving(p)
	
	local add = isMoving and R_PointToAngle2(0, 0, forward*FU, -p.cmd.sidemove*FU) or 0
	return ((p.cmd.angleturn<<16) + add) or 0
end

--- Returns if the specified object is underwater, and only if more than half of its top is submerged.
---@param mo mobj_t
---@return boolean
function RealSMWLuigi.isUnderwater(mo)
	if (mo.eflags & MFE_UNDERWATER) then
		return (
			(mo.z + mo.height/2) < mo.watertop and not (mo.eflags & MFE_VERTICALFLIP)
		or  (mo.z - mo.height/2) > mo.waterbottom and (mo.eflags & MFE_VERTICALFLIP)
		)
	end
	return false
end

-- L_ZLaunch made by clairebun
-- it can be found at
-- https://wiki.srb2.org/wiki/User:Clairebun/Sandbox/Common_Lua_Functions#L_ZLaunch
-- -pac

--- Sets the mobj's `momz` to the value given, taking underwater physics into account.
---@param mo mobj_t
---@param thrust fixed_t
---@param relative boolean?
function RealSMWLuigi.ZLaunch(mo,thrust,relative)
	if RealSMWLuigi.isUnderwater(mo) then
		thrust = $*3/5
	end
	P_SetObjectMomZ(mo,thrust,relative)
end

--- Adds the value given to the mobj's horizontal speed, nerfing it underwater and taking scale into account.
---@param mo mobj_t
---@param angle angle_t
---@param speed fixed_t
function RealSMWLuigi.Thrust(mo, angle, speed)
	if RealSMWLuigi.isUnderwater(mo) then
		speed = $/2
	end

	P_Thrust(mo, angle, FixedMul(speed, mo.scale))
end

--- Sets the mobj's horizontal speed to the value given, nerfing it underwater and taking scale into account.
---@param mo mobj_t
---@param angle angle_t
---@param speed fixed_t
function RealSMWLuigi.InstaThrust(mo, angle, speed)
	if RealSMWLuigi.isUnderwater(mo) then
		speed = $/2
	end
	
	P_InstaThrust(mo, angle, FixedMul(speed, mo.scale))
end