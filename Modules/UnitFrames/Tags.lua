local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

oUF.Tags.Events["difficultycolor"] = "UNIT_LEVEL PLAYER_LEVEL_UP"
oUF.Tags.Methods["difficultycolor"] = function(unit)
    local r, g, b
    local DiffColor = UnitLevel(unit) - UnitLevel("player")
    if (DiffColor >= 5) then
        r, g, b = 0.77, 0.12, 0.23
    elseif (DiffColor >= 3) then
        r, g, b = 1.0, 0.49, 0.04
    elseif (DiffColor >= -2) then
        r, g, b = 1.0, 0.96, 0.41
    elseif (-DiffColor <= GetQuestGreenRange()) then
        r, g, b = 0.251, 0.753, 0.251
    else
        r, g, b = 0.6, 0.6, 0.6
    end

    return Addon:Hex(r, g, b)
end

oUF.Tags.Events["curhp_status"] = "UNIT_HEALTH_FREQUENT PLAYER_UPDATE_RESTING UNIT_CONNECTION"
oUF.Tags.Methods["curhp_status"] = function(unit)
    if UnitIsDead(unit) then
        return "Dead"
    elseif UnitIsGhost(unit) then
        return "Ghost"
    elseif not UnitIsConnected(unit) then
        return "Offline"
    else
        return UnitHealth(unit)
    end
end
