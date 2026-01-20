
local SMW = RealSMWLuigi
local hook = SMW.dofile("Libs/hooks.lua") ---@type smw_hooklib
local powerup = SMW.dofile("Libs/power-ups.lua") ---@type smw_poweruplib

---@param pmo mobj_t
addHook("MobjDamage", function(pmo, inf, src, dmg, dmgtype)
    if not (pmo.player and pmo.player.valid)
    or (pmo.player.spectator) or not SMW.luigiCheck(pmo.player) then return end
    
    local hookResult = hook.executeHook("PowerUpDamage", pmo, inf, src, dmg, dmgtype)
    if hookResult then
        return hookResult
    end

    local p = pmo.player
    local prev_powerup = p.smw.powerup
    p.smw.powerup = SMWPU_NONE

    if (dmgtype & DMG_DEATHMASK) then return end

    if prev_powerup == SMWPU_NONE then
        P_DamageMobj(pmo, inf, src, dmg, DMG_INSTAKILL)
    end
    return true
end, MT_PLAYER)