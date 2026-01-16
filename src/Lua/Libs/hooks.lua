
-- heyheyhey!!!
-- this lua handles SMW Luigi's custom hooks!!
-- should just work like addHook, not much else :P
-- -pac

-- theres also an executeHook function thing
-- its not like its hard to recreate what it does
-- so its just here becaus why not

---@class smw_hooklib
local hook = {}

local hookList = {
	["SpinJumpSpecial"] = true, -- triggered before a spin-jump happens, returning true disables it
	["PSpeedHandle"] = true, -- triggered when p-speed's being handled, returning true disables p-speed going up/down
	["ChangeState"] = true -- triggered when luigi's state changes (ex. going from land to underwater), gives you a player, the state you're coming from and the state you're going to. returning false will disallow the state change, true will allow it, nil makes the mod handle it
}
local addedHooks = {}

-- if someone keeps adding hooks in a playerthink
-- thats their fault for doing bad code!!!!
-- not sure if i can even disable adding thos only outside of hooks (excluding lik AddonLoaded)

--- Binds a function to a hook (i.e., the function will be run when a particular event happens). See Lua/Hooks for more information on using this function.
---@param hook string
---@param fn function
---@param extra any?
function hook.addHook(hook, fn, extra)
	if not hookList[hook] then
		error(hook+" is not a valid hook!")
		return
	end
	
	addedHooks[hook] = $ or {}
	
	local hookTable = {
		func = fn,
		extra = extra
	}
	
	-- add it at the end of the table
	-- so that what we use for the
	-- return values based on the
	-- hook that was last added
	table.insert(addedHooks[hook], hookTable)
end

--- Executes all the functions binded to the specified hook, using all parameters supplied.
---@param hook string
---@param ... any
---@return any
function hook.executeHook(hook, ...)
	if hook == nil
	or not hookList[hook]
	or not addedHooks[hook] then return end
	
	local retval
	for _, foundHook in ipairs(addedHooks[hook]) do
		local funcVal = foundHook.func(...)
		if funcVal ~= nil then -- if its nil then you shouldn't replace anything, after-all you're letting the hook system handle stuff :P
			retval = funcVal
		end
	end
	return retval
end

return hook