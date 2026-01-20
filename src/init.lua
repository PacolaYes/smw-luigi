
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
	return unpack(files[file]) ---@diagnostic disable-line: deprecated
end

local dofile = RealSMWLuigi.dofile

-- i'm not sure how much reusable each of my 'libs' are
-- other than customhud, i didnt make that :P


dofile("constants.lua")
dofile("functions.lua")
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

dofile("Freeslots/colors.lua")
dofile("misc.lua")

dofile("Objects/springs.lua")
dofile("Objects/goal tape.lua")

dofile("Power-ups/base.lua")

dofile("HUD/main.lua")