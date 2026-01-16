
-- crouching!!
-- also includes sliding on slopes

local SMW = RealSMWLuigi

---@param p player_t
local function slidingThink(p)
	--p.pflags = $1|PF_STASIS
	
	if FixedHypot(p.rmomx, p.rmomy) > FU then return end
	
	local slope = p.mo.standingslope
	if not (slope and slope.valid) then return end -- no valid slopes? i'm outta here! i like running better
	
	local zangle = AngleFixed(slope.zangle)
	if zangle > 180*FU then zangle = $-360*FU end
	
	if zangle >= -5*FU
	and zangle <= 5*FU then return end
	
	local xydir = slope.xydirection
	if zangle*P_MobjFlip(p.mo) > 0 then
		xydir = $+ANGLE_180
	end
	
	P_InstaThrust(p.mo, xydir, FU+FU/2)
	p.rmomx = p.mo.momx - p.cmomx
	p.rmomy = p.mo.momy - p.cmomy
end

---@param p player_t
local function pthink(p)
	local grounded = P_IsObjectOnGround(p.mo)
	
	if (p.cmd.buttons & BT_CUSTOM2)
	and not p.smw.crouched
	and SMW.abilityCheck(p)
	and not (p.pflags & PF_STASIS)
	and grounded then
		p.smw.crouched = true
	end
	
	if p.smw.crouched then
		local slope = p.mo.standingslope
		if (slope and slope.valid)
		and not (p.pflags & PF_SPINNING) then
			--p.smw.flags = $1|SMWF_SLIDING -- if you're on a slope and you're not sliding then please do so :D
			p.pflags = $1|PF_SPINNING
		end
		
		--local isSliding = (p.smw.flags & SMWF_SLIDING)
		local isSliding = (p.pflags & PF_SPINNING) or (p.smw.lastpflags & PF_SPINNING) -- you'll be considered sliding if you're crouched and also happen to be spinning
		
		if (
			not (p.cmd.buttons & BT_CUSTOM2) and grounded
			or not SMW.abilityCheck(p)
		)
		and not isSliding
		or isSliding and ((p.pflags & PF_JUMPED) or (p.smw.flags & SMWF_SJUMPED)) then
			p.smw.crouched = false
			p.pflags = $ & ~PF_SPINNING
			return
		end
		
		if isSliding then
			slidingThink(p)
		end
		
		if grounded then
			if not isSliding then
				p.pflags = $1|PF_STASIS
			end
			
			local spd = FixedHypot(p.rmomx, p.rmomy)
			if spd >= 5*FU
			and leveltime%4 == 0 then
				P_SpawnSkidDust(p, FU)
			end
		end
	end
	
	/*if not p.smw.crouched then
		-- remove SMWF_SLIDING every tic if you aren't crouched :P
		-- should still trigger the sliding functionality, so you don't
		-- necessarily have to change p.smw.crouched, if you force the flag to be on
		-- kinda necessary if you dont wanna force the flag every tic though :P
		p.smw.flags = $ & ~SMWF_SLIDING
	end*/
end

---@param p player_t
local function postthink(p)
	if p.smw.crouched then
		local forcedState = (p.pflags & PF_SPINNING) and S_LUIGI_SLIDE or S_LUIGI_CROUCH
		
		if p.mo.state ~= forcedState then
			p.mo.state = forcedState
		end
	elseif not p.smw.crouched
	and (p.mo.state == S_LUIGI_CROUCH or p.mo.state == S_LUIGI_SLIDE) then
		if P_IsObjectOnGround(p.mo) then
			p.mo.state = S_PLAY_STND
		else
			p.mo.state = S_PLAY_JUMP
		end
	end
end

return pthink, postthink