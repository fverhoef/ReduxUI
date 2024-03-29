local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local L = R.L

oUF.Tags.Events["curhp_status"] = (R.isRetail and "UNIT_HEALTH" or "UNIT_HEALTH_FREQUENT") .. " PLAYER_UPDATE_RESTING UNIT_CONNECTION"
oUF.Tags.Methods["curhp_status"] = function(unit)
    if UnitIsDead(unit) then
        return L["Dead"]
    elseif UnitIsGhost(unit) then
        return L["Ghost"]
    elseif not UnitIsConnected(unit) then
        return L["Offline"]
    else
        return UnitHealth(unit)
    end
end

oUF.Tags.Events["curhp_status:shortvalue"] = (R.isRetail and "UNIT_HEALTH" or "UNIT_HEALTH_FREQUENT") .. " PLAYER_UPDATE_RESTING UNIT_CONNECTION"
oUF.Tags.Methods["curhp_status:shortvalue"] = function(unit, decimalPlaces)
    if UnitIsDead(unit) then
        return L["Dead"]
    elseif UnitIsGhost(unit) then
        return L["Ghost"]
    elseif not UnitIsConnected(unit) then
        return L["Offline"]
    else
        return R:ShortValue(UnitHealth(unit), decimalPlaces)
    end
end

oUF.Tags.Events["curhp:shortvalue"] = (R.isRetail and "UNIT_HEALTH" or "UNIT_HEALTH_FREQUENT")
oUF.Tags.Methods["curhp:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["curhp"](unit), decimalPlaces)
end

oUF.Tags.Events["maxhp:shortvalue"] = "UNIT_MAXHEALTH"
oUF.Tags.Methods["maxhp:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["maxhp"](unit), decimalPlaces)
end

oUF.Tags.Events["missinghp"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp"] = function(unit)
    local current = UnitHealthMax(unit) - UnitHealth(unit)
    if current > 0 then
        return current
    else
        return ""
    end
end
oUF.Tags.Events["missinghp:shortvalue"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["missinghp"](unit), decimalPlaces)
end
oUF.Tags.Events["missinghp_status"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp_status"] = function(unit)
    if UnitIsDead(unit) then
        return L["Dead"]
    elseif UnitIsGhost(unit) then
        return L["Ghost"]
    elseif not UnitIsConnected(unit) then
        return L["Offline"]
    else
        return _TAGS["missinghp"](unit)
    end
end
oUF.Tags.Events["missinghp_status:shortvalue"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp_status:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["missinghp_status"](unit), decimalPlaces)
end

oUF.Tags.Events["missinghp_neg"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp_neg"] = function(unit)
    local current = UnitHealth(unit) - UnitHealthMax(unit)
    if current < 0 then
        return current
    else
        return ""
    end
end
oUF.Tags.Events["missinghp_neg:shortvalue"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp_neg:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["missinghp_neg"](unit), decimalPlaces)
end
oUF.Tags.Events["missinghp_neg_status"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp_neg_status"] = function(unit)
    if UnitIsDead(unit) then
        return L["Dead"]
    elseif UnitIsGhost(unit) then
        return L["Ghost"]
    elseif not UnitIsConnected(unit) then
        return L["Offline"]
    else
        return _TAGS["missinghp_neg"](unit)
    end
end
oUF.Tags.Events["missinghp_neg_status:shortvalue"] = (R.isRetail and "UNIT_HEALTH UNIT_MAXHEALTH" or "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH")
oUF.Tags.Methods["missinghp_neg_status:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["missinghp_neg_status"](unit), decimalPlaces)
end

oUF.Tags.Events["curmana:shortvalue"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
oUF.Tags.Methods["curmana:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["curmana"](unit), decimalPlaces)
end

oUF.Tags.Events["maxmana:shortvalue"] = "UNIT_MAXPOWER"
oUF.Tags.Methods["maxmana:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["maxmana"](unit), decimalPlaces)
end

oUF.Tags.Events["perpp"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
oUF.Tags.Events["curpp"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
oUF.Tags.Events["curpp:shortvalue"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
oUF.Tags.Methods["curpp:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["curpp"](unit), decimalPlaces)
end

oUF.Tags.Events["maxpp:shortvalue"] = "UNIT_MAXPOWER"
oUF.Tags.Methods["maxpp:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["maxpp"](unit), decimalPlaces)
end

oUF.Tags.Events["missingpp"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
oUF.Tags.Events["missingpp:shortvalue"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
oUF.Tags.Methods["missingpp:shortvalue"] = function(unit, decimalPlaces)
    return R:ShortValue(_TAGS["missingpp"](unit), decimalPlaces)
end

oUF.Tags.Events["permana"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
oUF.Tags.Methods["permana"] = function(unit, decimalPlaces)
    local m = _TAGS["maxmana"](unit)
    if m == 0 then
        return 0
    else
        return math.floor(_TAGS["curmana"](unit) / m * 100 + .5)
    end
end

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
    elseif (-DiffColor <= (R.isRetail and UnitQuestTrivialLevelRange("player") or GetQuestGreenRange())) then
        r, g, b = 0.251, 0.753, 0.251
    else
        r, g, b = 0.6, 0.6, 0.6
    end

    return R:Hex(r, g, b)
end

oUF.Tags.Events["threat:percent"] = "UNIT_THREAT_LIST_UPDATE UNIT_THREAT_SITUATION_UPDATE GROUP_ROSTER_UPDATE"
oUF.Tags.Methods["threat:percent"] = function(unit)
    local _, _, percent = UnitDetailedThreatSituation("player", unit)
    if percent and percent > 0 and (IsInGroup() or UnitExists("pet")) then
        return string.format("%.0f%%", percent)
    end
end

oUF.Tags.Events["threat:current"] = "UNIT_THREAT_LIST_UPDATE UNIT_THREAT_SITUATION_UPDATE GROUP_ROSTER_UPDATE"
oUF.Tags.Methods["threat:current"] = function(unit)
    local _, _, percent, _, threatvalue = UnitDetailedThreatSituation("player", unit)
    if percent and percent > 0 and (IsInGroup() or UnitExists("pet")) then
        return R:ShortValue(threatvalue)
    end
end

oUF.Tags.Events["name:sub"] = "UNIT_NAME_UPDATE"
oUF.Tags.Methods["name:sub"] = function(unit, realUnit, length, noDots)
    local name = _TAGS["name"](unit, realUnit)
    if length and string.len(name) > tonumber(length) then
        return string.sub(name, 1, length) .. (noDots and "" or "...") -- please note, this code doesn't support UTF-8 chars
    else
        return name
    end
end

oUF.Tags.Events["afk"] = "UNIT_NAME_UPDATE PLAYER_FLAGS_CHANGED"
oUF.Tags.Methods["afk"] = function(unit)
    return UnitIsAFK(unit) and (R:Hex(R.modules.tooltips.config.colors.afk) .. " <" .. L["AFK"] .. ">|r") or UnitIsDND(unit) and
               (R:Hex(R.modules.tooltips.config.colors.dnd) .. " <" .. L["DND"] .. ">|r") or ""
end
