
-- my hud thingie
-- is it necessary? maybe? idk
-- i just like doing stuff on my own!!
-- -pac

-- idk if this counts as a lib either :P

local cachedStuff = {
	length = {},
	patches = {}
}

---@class smw_hudlib
local hud = {}

---@param v videolib
---@param name string
---@return patch_t
function hud.cachePatch(v, name)
	if not (cachedStuff.patches[name] and cachedStuff.patches[name].valid) then
		cachedStuff.patches[name] = v.cachePatch(name)
	end
	return cachedStuff.patches[name]
end

--- defaults to the `default` value if `val` is `nil`.
---@param val any
---@param default any
---@return any
local function doDefault(val, default)
	if val == nil then
		return default
	end

	return val
end

local fontPattern = "%s%03d"

--- Gets the length of the string using the specified font and scale
---@param v videolib
---@param scale fixed_t
---@param string string
---@param font string
function hud.getTextLength(v, scale, string, font)
	cachedStuff.length[font] = $ or {}

	if not cachedStuff.length[font][string] then
		local length = 0
		local prevLetter_length = 0
		for i = 1, #string do
			local letter = string:byte(i, i)
			local patchName = fontPattern:format(font, letter)

			if not v.patchExists(patchName) then
				length = $ + prevLetter_length
				continue
			end

			local patch = hud.cachePatch(v, patchName)
			length = $ + patch.width
			prevLetter_length = patch.width
		end

		cachedStuff.length[font][string] = length
	end
	return cachedStuff.length[font][string] * scale
end

---@alias smw_stringAlignment
---| '"left"' # The string will be drawn at its left corner
---| '"right"' # The string will be drawn at its right corner
---| '"center"' # The string will be drawn at its center
---| '"fixed-left"' # The string will be drawn at its left corner, the coordinates must be specified in fixed_t
---| '"fixed-right"' # The string will be drawn at its right corner, the coordinates must be specified in fixed_t
---| '"fixed-center"' # The string will be drawn at its center, the coordinates must be specified in fixed_t

--- Draws text on screen at the specified coordinates with the specified font.
---@param v videolib
---@param x integer | fixed_t Must be a `fixed_t` if `align` has a `fixed` prefix
---@param y integer | fixed_t Must be a `fixed_t` if `align` has a `fixed` prefix
---@param scale fixed_t
---@param string string
---@param flags integer?
---@param align smw_stringAlignment?
---@param font string? Defaults to "SMWFNT"
---@param colormap colormap?
function hud.drawString(v, x, y, scale, string, flags, align, font, colormap)
	align = doDefault($, "left")
	font = doDefault($, "SMWFNT")

	print(align:sub(1, 6))
	if align:sub(1, 6) ~= "fixed-" then
		x = $ * FU ---@cast x fixed_t
		y = $ * FU ---@cast y fixed_t
		align = align:sub(6)
	end

	local text_x = x
	for line in string:gmatch("[^\n]+") do
		text_x = x
		if align == "right" then
			text_x = $ - hud.getTextLength(v, scale, string, font)
		elseif align == "center" then
			text_x = $ - hud.getTextLength(v, scale, string, font)/2
		end

		local prevLetter_length = 0
		for i = 1, #line do
			local letter = line:byte(i, i)
			local patchName = fontPattern:format(font, letter)

			if not v.patchExists(patchName) then
				text_x = $ + prevLetter_length
				continue
			end

			local patch = hud.cachePatch(v, patchName)

			v.drawScaled(text_x, y, scale, patch, flags, colormap)
			text_x = $ + patch.width*scale
			prevLetter_length = patch.width * scale
		end
	end
end

return hud