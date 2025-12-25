
-- let's init the lua!!
-- -pac

rawset(_G, "RealSMWLuigi", {})

local files = {}

---@param file string
---@return ...
function RealSMWLuigi.dofile(file)
	if not files[file] then
		files[file] = {dofile(file)}
	end
	return unpack(files[file])
end

local dofile = RealSMWLuigi.dofile

dofile("constants.lua")

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
dofile("player variable.lua")

--dofile("credits.lua") -- todo: finish this!!

dofile("Freeslots/abilities.lua")

local stateList = {
	"normal",
	"underwater"
}

-- maybe i should come up with a better name
-- for the second "States" folder? idk :P
for _, val in ipairs(stateList) do
	dofile("States/"+val)
end

dofile("music related stuff.lua")
dofile("Freeslots/colors.lua")
dofile("color related stuff.lua")