
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
		state = "normal",
		pmeter = {
			time = 0,
			prejumptime = 0
		},
		flags = 0
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