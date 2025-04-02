
-- let's init the lua!!
-- -pac

rawset(_G, "RealSMWLuigi", {
	funcs = {}
})
RealSMWLuigi.state = dofile("States/handler.lua")

-- handle the smw flags :P
local smwFlags = {
	-- sjump standing for spinjump
	SMWF_SJUMPED = 1,
	SMWF_STARTSJUMP = 1<<1,
	
	-- self-explanatory, not sure if sliding being a flag is the best thing though :P
	SMWF_SLIDING = 1<<2
}

for flagName, flagValue in pairs(smwFlags) do
	rawset(_G, flagName, flagValue)
end

local function copyTable(from, to)
	from = $ or {}
	
	local copy = to or {}
	for key, val in pairs(from) do
		copy[key] = val
	end
	
	return copy
end

--RealSMWLuigi.funcs = dofile("functions.lua")
RealSMWLuigi = copyTable(dofile("functions.lua"), $)
RealSMWLuigi = copyTable(dofile("custom hooks.lua"), $)

RealSMWLuigi.luigiCheck = dofile("player variable.lua")

local files = {}
function RealSMWLuigi.dofile(file)
	if not files[file] then
		files[file] = dofile(file)
	end
	return files[file]
end

--dofile("credits.lua") -- todo: finish this!!

dofile("Freeslots/abilities.lua")

local stateList = {
	"normal",
	"underwater"
}

-- maybe i should come up with a better name
-- for the second "States" folder? idk :P
for _, val in ipairs(stateList) do
	dofile("States/States/"+val)
end

dofile("music related stuff.lua")
dofile("Freeslots/colors.lua")
dofile("color related stuff.lua")