
-- handles the basic stuff
-- for the "smw" player var
-- mostly just making sure it exists :P

local function luigiCheck(p)
	return not (
		not (p.mo and p.mo.valid)
		or p.mo.skin ~= "realsmwluigi"
	)
end

local function SMWTable()
	return {
		state = 1,
		pmeter = {
			time = 0,
			prejumptime = 0
		},
		flags = 0,
		lastpflags = 0, -- self-explanatory name, only here because of sliding :P
		sjangle = 0, -- the spinjump's drawangle, set to the player object's angle, so its network safe, as fire flower uses it to spawn fire balls :P
		overlayColor = 0, -- the player's selected overlay color, 0 means automatic
		forceOverlayColor = 0 -- the forced overlay color, only really used for differenciating fire mario/luigi :P
	}
end

addHook("PlayerSpawn", function(p)
	if not luigiCheck(p) then return end
	
	p.smw = SMWTable()
end)

addHook("PlayerThink", function(p)
	if not luigiCheck(p) then return end
	
	if p.smw == nil then
		p.smw = SMWTable()
	end
end)

return function(p)
	return (luigiCheck(p) and p.smw) and true or false
end