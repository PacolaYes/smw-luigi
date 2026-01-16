
local SMW = RealSMWLuigi
local hudlib = SMW.dofile("Libs/hud.lua") ---@type smw_hudlib

local mario_chatColors = {
    [V_MAGENTAMAP] = true,
    [V_REDMAP] = true,
    [V_ROSYMAP] = true
}

---@param skincolor skincolornum_t
---@return string
local function getNamePatch(skincolor)
    if skincolors[skincolor]
    and mario_chatColors[skincolors[skincolor].chatcolor]
    and SMW.marioColor[skincolor] ~= false
    or SMW.marioColor[skincolor] then
        return "SMW_MARIONAME"
    end

    return "SMW_LUIGINAME"
end

---@param stplyr player_t
local function getLives(stplyr)
	if stplyr == nil then return end

	local candrawlives = false;
	local livescount = -1

	local cv_cooplives = CV_FindVar("cooplives")

	// Co-op and Competition, normal life counter
	if (G_GametypeUsesLives()) then
		// Handle cooplives here
		if ((netgame or multiplayer) and G_GametypeUsesCoopLives() and cv_cooplives.value == 3) then
			livescount = 0;
			for p in players.iterate() do
				if p.spectator
				or p.lives < 1 then
					continue;
				end

				if (p.lives == INFLIVES) then
					livescount = INFLIVES;
					break;
				elseif (livescount < 99) then
					livescount = $+(p.lives);
				end
			end
		else
			livescount = (((netgame or multiplayer) and G_GametypeUsesCoopLives() and cv_cooplives.value == 0) and INFLIVES or stplyr.lives);
		end
		
		candrawlives = true
	// Infinity symbol (Race)
	elseif (G_PlatformGametype() and not (gametyperules & GTR_LIVES)) then
		livescount = INFLIVES;
		candrawlives = true;
	end

	return livescount, candrawlives
end

---@param v videolib
---@param p player_t
addHook("HUD", function(v, p)
    if not SMW.luigiCheck(p) then return end

    local flags = V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS
    local x_patch = hudlib.cachePatch(v, "SMW_TX")

    v.draw(20, 14, hudlib.cachePatch(v, getNamePatch(p.skincolor)), V_SNAPTOLEFT|flags, v.getColormap(p.skin, p.skincolor))
    v.draw(32, 22, x_patch, V_SNAPTOLEFT|flags)
    hudlib.drawString(v, 56, 22, FU, tostring(getLives(p)), V_SNAPTOLEFT|flags, "right")

    v.draw(88, 22, hudlib.cachePatch(v, "SMW_STAR"), V_SNAPTOLEFT|flags)
    v.draw(96, 22, x_patch, V_SNAPTOLEFT|flags)

    v.draw(212, 14, hudlib.cachePatch(v, "SMW_TIME"), V_SNAPTORIGHT|flags)
    local time = tostring(p.realtime / TICRATE) -- TODO: make this more accurate to SMW's way of handling time
    if #time > 3 then
        hudlib.drawString(v, 224, 22, FU, time, V_SNAPTORIGHT|flags, "center")
    else
        hudlib.drawString(v, 235, 22, FU, time, V_SNAPTORIGHT|flags, "right")
    end

    v.draw(260, 14, hudlib.cachePatch(v, "SMW_COIN"), V_SNAPTORIGHT|flags)
    v.draw(268, 14, x_patch, V_SNAPTORIGHT|flags)
    local rings = tostring(p.rings)
    if #rings > 2 then
        hudlib.drawString(v, 285, 14, FU, rings, V_SNAPTORIGHT|flags)
    else
        hudlib.drawString(v, 299, 14, FU, rings, V_SNAPTORIGHT|flags, "right")
    end
    
    hudlib.drawString(v, 299, 22, FU, tostring(p.score), V_SNAPTORIGHT|flags, "right")
end)

local hud_items = {"rings", "score", "time", "lives"}
local disabled_hud = false
addHook("PlayerThink", function(p)
    if not P_IsLocalPlayer(p) then return end

    local luigiCheck = SMW.luigiCheck(p)
    if luigiCheck
    and not disabled_hud then
        for _, val in ipairs(hud_items) do
            hud.disable(val)
        end
        disabled_hud = true
    elseif not luigiCheck
    and disabled_hud then
        for _, val in ipairs(hud_items) do
            hud.enable(val)
        end
        disabled_hud = false
    end
end)