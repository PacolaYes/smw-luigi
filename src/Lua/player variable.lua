
-- handles the basic stuff
-- for the "smw" player var
-- mostly just making sure it exists :P

---@class player_t
---@field smw _smwplayer_t?

---@param p player_t
local function luigiCheck(p)
	return not (
		not (p.mo and p.mo.valid)
		or p.mo.skin ~= "realsmwluigi"
	)
end

---@return _smwplayer_t
local function SMWTable()
	---@class _smwplayer_t
	---@field state integer
	---@field lastpflags playerflags_t
	local smw = {
		state = 1, ---@type integer
		pmeter = {
			time = 0, ---@type tic_t
			prejumptime = 0 ---@type tic_t
		},
		flags = 0, ---@type integer
		lastpflags = 0, ---@type playerflags_t -- self-explanatory name, only here because of sliding :P
		sjangle = 0, ---@type angle_t -- the spinjump's drawangle, set to the player object's angle, so its network safe, as fire flower uses it to spawn fire balls :P
		overlayColor = 0, ---@type skincolornum_t -- the player's selected overlay color, 0 means automatic
		forceOverlayColor = 0 ---@type skincolornum_t -- the forced overlay color, only really used for differenciating fire mario/luigi :P
	}

	return smw
end

---@param p player_t
addHook("PlayerSpawn", function(p)
	if not luigiCheck(p) then return end
	
	p.smw = SMWTable()
end)

---@param p player_t
addHook("PlayerThink", function(p)
	if not luigiCheck(p) then return end
	
	if p.smw == nil then
		p.smw = SMWTable()
	end
end)

---@param p player_t
---@return boolean
function RealSMWLuigi.luigiCheck(p)
	return (luigiCheck(p) and p.smw) and true or false
end