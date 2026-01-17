
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

-- font-related stuff
-- is this better than customhudlib? idk :P
local fonts = {}

---@class smw_hudlib_font
fonts["SMW-TinyFont"] = {
	prefix = "SMWFNT", ---@type string The GFX prefix for your font; <br>If a GFX of your font uses `"SUPERCOOLFONT_22"`, this'd be `"SUPERCOOLFONT_"`.
	num_padding = 0, ---@type integer? The padding your GFX's numbers use; <br>If a GFX is `"SUPERCOOLFONT_03"`, this'd be `2`; <br>Defaults to 0.
	offset = { ---@type vector2_t? The offset of each letter, this'll be the extra spacing in-between letters; <br>Defaults to 0 in both axis.
		x = 0,
		y = 0
	},
	space_width = 8*FU ---@type fixed_t? The width that a space character will have, defaults to 8.
}

--- Defines a font with the specified parameters.
---@param name string
---@param definition smw_hudlib_font
---@return smw_hudlib_font? fontDefinition
function hud.addFont(name, definition)
	if fonts[name] then
		error("\x85[SMW Luigi]\x80 Font "+name+" already exists!", 2)
		return
	end

	for key, value in pairs(fonts["SMW-TinyFont"]) do
		if key ~= "prefix"
		and definition[key] == nil then
			definition[key] = value
		end
	end

	fonts[name] = definition
	return definition
end

--- Gets the specified font by name.
---@param name string
---@return smw_hudlib_font? fontDefinition
function hud.getFont(name)
	return fonts[name]
end

--- Gets the length of the string using the specified font and scale
---@param v videolib
---@param scale fixed_t
---@param string string
---@param font string?
---@return fixed_t? length, fixed_t? height
function hud.getTextSize(v, scale, string, font)
	font = doDefault($, "SMW-TinyFont")

	local font_def = hud.getFont(font)

	if not font_def then return end
	
	cachedStuff.length[font] = $ or {}

	if not cachedStuff.length[font][string] then
		local length, height = 0, 0
		local lineHeight = 0

		for line in string:gmatch("[^\n]+") do
			lineHeight = 0

			for i = 1, #line do
				local letter = line:byte(i, i)
				local patchName = string.format("%s%0"+font_def.num_padding+"d", font_def.prefix, letter)

				if not v.patchExists(patchName) then
					length = $ + font_def.space_width
					continue
				end

				local patch = hud.cachePatch(v, patchName)
				length = $ + patch.width*FU + font_def.offset.x

				lineHeight = max($, patch.height*FU)
			end

			height = $ + lineHeight + font_def.offset.y
		end

		cachedStuff.length[font][string] = {
			width = length,
			height = height
		}
	end

	local size = cachedStuff.length[font][string]
	return FixedMul(size.width, scale), FixedMul(size.height, scale)
end

---@alias smw_stringAlignment
---| '"left"' # The string will be drawn at its left corner
---| '"right"' # The string will be drawn at its right corner
---| '"center"' # The string will be drawn at its center
---| '"fixed-left"' # Same as `"left"`, except the coordinates must be specified in fixed_t
---| '"fixed-right"' # Same as `"right"`, except the coordinates must be specified in fixed_t
---| '"fixed-center"' # Same as `"center"`, except the coordinates must be specified in fixed_t

--- Draws text on screen at the specified coordinates with the specified font.
---@param v videolib
---@param x integer | fixed_t Must be a `fixed_t` if `align` has a `fixed` prefix
---@param y integer | fixed_t Must be a `fixed_t` if `align` has a `fixed` prefix
---@param scale fixed_t
---@param string string | number
---@param flags integer?
---@param align smw_stringAlignment?
---@param font (string | smw_hudlib_font)? Defaults to "SMW-TinyFont"
---@param colormap colormap?
function hud.drawString(v, x, y, scale, string, flags, align, font, colormap)
	if string == nil then return end

	string = tostring($)
	align = doDefault($, "left")
	font = doDefault($, "SMW-TinyFont")
	local font_def = hud.getFont(font)

	if not font_def then return end

	if align:sub(1, 6) ~= "fixed-" then
		x = $ * FU
		y = $ * FU
	else
		align = align:sub(7)
	end
	--[[@cast x fixed_t]] --[[@cast y fixed_t]]

	local text_x = x
	for line in string:gmatch("[^\n]+") do
		text_x = x
		if align == "right" then
			text_x = $ - hud.getTextSize(v, scale, line, font)
		elseif align == "center" then
			text_x = $ - hud.getTextSize(v, scale, line, font)/2
		end

		local lineHeight = 0
		for i = 1, #line do
			local letter = line:byte(i, i)
			local patchName = string.format("%s%0"+font_def.num_padding+"d", font_def.prefix, letter)

			if not v.patchExists(patchName) then
				text_x = $ + font_def.space_width
				continue
			end

			local patch = hud.cachePatch(v, patchName)

			v.drawScaled(text_x, y, scale, patch, flags, colormap)

			text_x = $ + patch.width*scale + font_def.offset.x
			lineHeight = max($, patch.height * scale)
		end

		y = $ + lineHeight + font_def.offset.y
	end
end

return hud