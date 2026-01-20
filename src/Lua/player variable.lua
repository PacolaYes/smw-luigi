
-- handles the basic stuff
-- for the "smw" player var
-- mostly just making sure it exists :P

---@class player_t
---@field smw _smwplayer_t?
---@field smwshutuplist table<integer, mobj_t?>?

---@class mobj_t
---@field smw _smwmobj_t?

---@param p player_t
local function luigiCheck(p)
	return (p.mo and p.mo.valid)
		and p.mo.skin == "realsmwluigi"
end

---@return _smwplayer_t
---@return _smwmobj_t
local function SMWTable()
	---@class _smwplayer_t
	---@field state integer
	---@field lastpflags playerflags_t
	---@field crouched boolean
	local smw = {
		powerup = SMWPU_NONE, ---@type integer
		flags = 0, ---@type integer
		lastpflags = 0, ---@type playerflags_t -- self-explanatory name, only here because of sliding :P
		sjangle = 0, ---@type angle_t -- the spinjump's drawangle, set to the player object's angle, so its (always) network safe, as fire flower uses it to spawn fire balls :P

		overlay_mo = nil, ---@type mobj_t -- The player's overlay
		overlayColor = 0, ---@type skincolornum_t -- the player's selected overlay color, 0 means automatic
		forceOverlayColor = 0, ---@type skincolornum_t -- the forced overlay color, only really used for differenciating fire mario/luigi :P

		deadtimer = 0 ---@type tic_t -- how long the player's dead, as player.deadtimer needs to be capped in singleplayer
	}

	---@class _smwmobj_t
	local mo_smw = {
		state = 1, ---@type integer
		pmeter = {
			time = 0, ---@type tic_t
			prejumptime = 0 ---@type tic_t
		}
	}

	return smw, mo_smw
end

---@param p player_t
addHook("PlayerSpawn", function(p)
	if not luigiCheck(p) then return end
	
	local p_table, mo_table = SMWTable()
	if not p.smw then
		p.smw = p_table
	end
	p.mo.smw = mo_table
end)

---@param p player_t
addHook("PlayerThink", function(p)
	if not luigiCheck(p) then
		if p.realmo.smw then
			p.realmo.smw = nil
		end
		return
	end
	
	if p.smw == nil then
		p.smw = SMWTable()
	end
	if p.mo.smw == nil then
		local _, mo_table = SMWTable()
		p.mo.smw = mo_table
	end

	if not (p.smw.overlay_mo and p.smw.overlay_mo.valid) then
		p.smw.overlay_mo = P_SpawnMobjFromMobj(p.mo, 0, 0, 0, MT_SMWOVERLAY)
		p.smw.overlay_mo.tracer = p.mo
	end
end)

---@param p player_t
---@return boolean
function RealSMWLuigi.luigiCheck(p)
	return (luigiCheck(p) and p.smw and p.mo.smw) and true or false
end