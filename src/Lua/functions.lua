
-- functions!!
-- just the stuff so the RealSMWLuigi variable can get 'em!

local funcs = dofile("Libs/text.lua")

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

-- handles translations, function name makes luigi trans canonically (can you tell this is a joke its /j guys its uspposed to be funny)
function funcs.handleTrans(mo)
	if not (mo and mo.valid)
	or mo.skin ~= "realsmwluigi" then return end
	
	return mo.color == SKINCOLOR_SMWRED and "RealSMWLuigiRed" or nil
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