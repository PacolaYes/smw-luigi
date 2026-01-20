
local SMW = RealSMWLuigi
-- states: 2
-- now the enemy is another

local pups = {} ---@class smw_poweruplib
local powerups = {} ---@type table<integer, smw_powerup_t>

local function emptyFunc() end

powerups[SMWPU_NONE] = { ---@class smw_powerup_t
    mobjtype = nil, ---@type mobjtype_t? The `MT_` for the power-up state's stored item.

    think = emptyFunc, ---@type fun(player: player_t)?
}

local pup_mt = {__index = powerups[SMWPU_NONE]}

local function checkExists(value)
    local success, retval = pcall(function()
        return (_G[value] ~= nil)
    end)

    return success and retval or false
end

---@param name string
---@param definition smw_powerup_t
function pups.addPowerUp(name, definition)
    if not name
    or not definition then return end

    name = tostring($):upper()

    local pupNum = 0
	for _ in pairs(powerups) do
		pupNum = $+1
	end

    if checkExists("SMWPU_" + name) then
        error("\x85[SMW Luigi]\x80 Hey! This power-up has already been found!", 2)
        return
    end

    rawset(_G, "SMWPU_"+name, pupNum)

    powerups[pupNum] = setmetatable(definition, pup_mt)
end

return pups