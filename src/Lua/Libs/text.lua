
-- my text drawing thingie
-- is it necessary? not really
-- i just like doing stuff on my own!!
-- -pac

-- idk if this counts as a lib either :P

local cachedStuff = {
	length = {},
	patches = {},
	centerstuff = {}
}

local function getPatch(v, name)
	if not v
	or not v.patchExists(name) then return end
	
	if not (cachedStuff.patches[name] and cachedStuff.patches[name].valid) then
		cachedStuff.patches[name] = v.cachePatch(name)
	end
	return cachedStuff.patches[name]
end

local function drawText(v, x, y, size, str, flags, align, fnt, colormap)
	if not v -- we kind of need v !!
	or str == nil -- kind of need a string to draw text, wouldn't you agree?
	or size == 0 then return end -- size is 0, it wouldn't show anyways, so don't bother drawing it!
	
	x = $ ~= nil and $ or 0
	y = $ ~= nil and $ or 0
	size = $ ~= nil and $ or FU
	str = tostring($)
	flags = $ ~= nil and $ or 0
	fnt = $ ~= nil and $ or "SMWFNT"
	align = $ ~= nil and $ or "left"
	
	/*if not cachedStuff.length[str] then
		cachedStuff.length[str] = str:len() -- as far as i know, string.len could be slow? idk im tryin to optimize this, might be overdoing it with caching though :P
	end
	local length = cachedStuff.length[str]*/
	local length = str:len()
	
	local mul = align == "right" and -1 or 1
	if align == "center" then
		if not cachedStuff.centerstuff[str] then
			cachedStuff.centerstuff[str] = 0
			for i = 1, length do
				local curLetter = str:byte(i, i)
				if not v.patchExists(fnt+curLetter) then
					cachedStuff.centerstuff[str] = $+4*FU
					continue
				end
				
				cachedStuff.centerstuff[str] = $+getPatch(v, fnt+curLetter).width*(FU/2)
			end
		end
		x = $-FixedMul(cachedStuff.centerstuff[str], size)
	end
	
	for i = 1, length do
		local curLetter = align == "right" and length-(i-1) or i
		curLetter = str:byte($, $)
		
		if not v.patchExists(fnt+curLetter) then
			x = $+8*size*mul
			continue
		end
		
		local patch = getPatch(v, fnt+curLetter)
		
		v.drawScaled(x, y, size, patch, flags, colormap)
		x = $+patch.width*size*mul
	end
end

return {
	getPatch = getPatch,
	drawText = drawText
}