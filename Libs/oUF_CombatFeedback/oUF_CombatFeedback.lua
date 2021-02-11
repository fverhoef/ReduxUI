local _, ns = ...
local oUF = ns.oUF or oUF

if not oUF then
    return
end

local damage_format = "-%d"
local heal_format = "+%d"
local maxAlpha = 1
local updateFrame
local feedback = {}
local originalHeight = {}
local color
local colors = {
    STANDARD = {1, 1, 1}, -- color for everything not in the list below
    -- damage colors
    IMMUNE = {1, 1, 1},
    DAMAGE = {1, 0, 0},
    CRUSHING = {1, 0, 0},
    CRITICAL = {1, 0, 0},
    GLANCING = {1, 0, 0},
    ABSORB = {1, 1, 1},
    BLOCK = {1, 1, 1},
    RESIST = {1, 1, 1},
    MISS = {1, 1, 1},
    -- heal colors
    HEAL = {0, 1, 0},
    CRITHEAL = {0, 1, 0},
    -- energize colors
    ENERGIZE = {0.41, 0.8, 0.94},
    CRITENERGIZE = {0.41, 0.8, 0.94}
}

local Update = function(self, event, unit, eventType, flags, amount, dtype)
    if unit ~= self.unit or unit == "vehicle" or event ~= "UNIT_COMBAT" then
        return
    end

    local element = self.CombatFeedbackText
    local overrideColors = element.colors
    local font, fontHeight, fontFlags = element:GetFont()
    if not font then
        font = STANDARD_TEXT_FONT
    end
    if (not fontHeight) or (fontHeight <= 0) then
        fontHeight = 12
    end
    if not fontFlags then
        fontFlags = nil
    end
    local text, arg
    color = overrideColors and overrideColors.STANDARD or colors.STANDARD
    if eventType == "IMMUNE" and not element.ignoreImmune then
        color = overrideColors and overrideColors.IMMUNE or colors.IMMUNE
        text = CombatFeedbackText[eventType]
    elseif eventType == "WOUND" and not element.ignoreDamage then
        if amount ~= 0 then
            if flags == "CRITICAL" then
                color = overrideColors and overrideColors.CRITICAL or colors.CRITICAL
            elseif flags == "CRUSHING" then
                color = overrideColors and overrideColors.CRUSING or colors.CRUSHING
            elseif flags == "GLANCING" then
                color = overrideColors and overrideColors.GLANCING or colors.GLANCING
            else
                color = overrideColors and overrideColors.DAMAGE or colors.DAMAGE
            end
            text = damage_format
            arg = amount
        elseif flags == "ABSORB" then
            color = overrideColors and overrideColors.ABSORB or colors.ABSORB
            text = CombatFeedbackText["ABSORB"]
        elseif flags == "BLOCK" then
            color = overrideColors and overrideColors.BLOCK or colors.BLOCK
            text = CombatFeedbackText["BLOCK"]
        elseif flags == "RESIST" then
            color = overrideColors and overrideColors.RESIST or colors.RESIST
            text = CombatFeedbackText["RESIST"]
        else
            color = overrideColors and overrideColors.MISS or colors.MISS
            text = CombatFeedbackText["MISS"]
        end
    elseif eventType == "BLOCK" and not element.ignoreDamage then
        color = overrideColors and overrideColors.BLOCK or colors.BLOCK
        text = CombatFeedbackText[eventType]
    elseif eventType == "HEAL" and not element.ignoreHeal then
        text = heal_format
        arg = amount
        if flags == "CRITICAL" then
            color = overrideColors and overrideColors.CRITHEAL or colors.CRITHEAL
        else
            color = overrideColors and overrideColors.HEAL or colors.HEAL
        end
    elseif event == "ENERGIZE" and not element.ignoreEnergize then
        text = amount
        if flags == "CRITICAL" then
            color = overrideColors and overrideColors.ENERGIZE or colors.ENERGIZE
        else
            color = overrideColors and overrideColors.CRITENERGIZE or colors.CRITENERGIZE
        end
    elseif not element.ignoreOther then
        text = CombatFeedbackText[eventType]
    end

    if text then
        element:SetFont(font, fontHeight, fontFlags)
        element:SetFormattedText(text, arg)
        element:SetTextColor(unpack(color))
        element:SetAlpha(0)
        element:Show()
        feedback[self] = GetTime()
        updateFrame:Show() -- start our onupdate
    end
end

local Path = function(self, ...)
    return (self.CombatFeedbackText.Override or Update)(self, ...)
end

local Enable = function(self, unit)
    local element = self.CombatFeedbackText

    if element then
        element.__owner = self

        local _, fontHeight = self.CombatFeedbackText:GetFont()
        self.CombatFeedbackText.origHeight = fontHeight
        self.CombatFeedbackText.maxAlpha = self.CombatFeedbackText.maxAlpha or maxAlpha

        if not updateFrame then
            updateFrame = CreateFrame("Frame")
            updateFrame:Hide()
            updateFrame:SetScript("OnUpdate", function()
                if next(feedback) == nil then
                    updateFrame:Hide()
                    return
                end
                for object, startTime in pairs(feedback) do
                    local maxalpha = object.CombatFeedbackText.maxAlpha
                    local elapsedTime = GetTime() - startTime
                    if (elapsedTime < COMBATFEEDBACK_FADEINTIME) then
                        local alpha = maxalpha * (elapsedTime / COMBATFEEDBACK_FADEINTIME)
                        object.CombatFeedbackText:SetAlpha(alpha)
                    elseif (elapsedTime < (COMBATFEEDBACK_FADEINTIME + COMBATFEEDBACK_HOLDTIME)) then
                        object.CombatFeedbackText:SetAlpha(maxalpha)
                    elseif (elapsedTime < (COMBATFEEDBACK_FADEINTIME + COMBATFEEDBACK_HOLDTIME + COMBATFEEDBACK_FADEOUTTIME)) then
                        local alpha = maxalpha - maxalpha *
                                          ((elapsedTime - COMBATFEEDBACK_HOLDTIME - COMBATFEEDBACK_FADEINTIME) /
                                              COMBATFEEDBACK_FADEOUTTIME)
                        object.CombatFeedbackText:SetAlpha(alpha)
                    else
                        object.CombatFeedbackText:Hide()
                        feedback[object] = nil
                    end
                end
            end)
        end

        self:RegisterEvent("UNIT_COMBAT", Path)

        return true
    end
end

local Disable = function(self)
    local element = self.CombatFeedbackText

    if element then
        self:UnregisterEvent("UNIT_COMBAT", Path)

        return false
    end
end

oUF:AddElement("CombatFeedbackText", nil, Enable, Disable)
