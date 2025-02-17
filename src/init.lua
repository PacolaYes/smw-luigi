
-- let's init the lua!!

rawset(_G, "RealSMWLuigi", {
	funcs = {}
})
RealSMWLuigi.state = dofile("player states.lua")

local funcs = dofile("functions.lua")

for k, func in pairs(funcs) do
	RealSMWLuigi[k] = func
end

RealSMWLuigi.luigiCheck = dofile("player variable.lua")

local files = {}
function RealSMWLuigi.require(file)
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

for _, val in ipairs(stateList) do
	dofile("States/"+val)
end

dofile("music related stuff.lua")
dofile("colors.lua")