
-- handles da springs
-- so they give us p-speed if they're strong enough

-- seperated from p-speed.lua as i dont want it there >:(
-- no i did not think on how to make the seperation prettier

-- -pac

local SMW = RealSMWLuigi
local _, _, getSpeedFromTime = SMW.dofile("Abilities/p-speed.lua") ---@type any, any, fun(time: tic_t, player: player_t)
local maxTime = FixedRound(FixedDiv(112, 60)*TICRATE)/FU

local starting_index = 1
local function doSpringStuff()
	local ending = #mobjinfo-1
	for i = starting_index, ending do
		if i == ending then return end

		local info = mobjinfo[i]

		if (info.flags & MF_SPRING) then
			---@param spring mobj_t
			---@param pmo mobj_t
			addHook("MobjCollide", function(spring, pmo)
				if not (spring.flags & MF_SPRING)
				or not (pmo.player and pmo.player.valid)
				or not SMW.luigiCheck(pmo.player) then return end -- just making sure :P

				if spring.z > pmo.z+pmo.height
				or pmo.z > spring.z+spring.height
				or spring.info.painchance == -1 then return end
				
				local smw = pmo.smw

				local maxSpeed = getSpeedFromTime(maxTime, pmo.player)
				local meterBar = FixedRound(ease.linear(FixedDiv(spring.info.damage, maxSpeed), 0, maxTime*FU))/FU

				smw.pmeter.time = max(min(meterBar, maxTime), $)
				if (pmo.player.pflags & PF_JUMPED) then
					smw.pmeter.prejumptime = smw.pmeter.time
				end
			end, i)
		end
	end
	starting_index = ending
end

doSpringStuff()
addHook("AddonLoaded", function()
	doSpringStuff()
end)