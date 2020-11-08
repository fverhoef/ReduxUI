local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local SI = Addon.Modules.SpellInfo

function SI:HookSetSpell(tip)
    tip:HookScript("OnTooltipSetSpell", function(tooltip)
        local spellName, spellId = tooltip:GetSpell()
        if spellId then
            if SI.config.db.profile.modifySpellDamage and not IsShiftKeyDown() then
                SI.Database:ModifyTooltip(tooltip, spellId)
            end

            if SI.config.db.profile.showNextRank then
                local isMaxKnownRank = SI.Database:IsMaxKnownRank(spellId)
                local isMaxRank = SI.Database:IsMaxRank(spellId)
                if isMaxKnownRank and not isMaxRank then
                    local nextRank = SI.Database:GetNextRank(spellId)
                    if nextRank then
                        tooltip:AddLine("|cffa0bed2Next rank available at level " .. nextRank.level .. ".|r")
                    end
                end
            end

            tooltip:Show()
        end
    end)
end

function SI:OnEnable()
    SI.Database:Initialize()

    SI:HookSetSpell(GameTooltip)
    SI:HookSetSpell(ItemRefTooltip)

    SI:RegisterEvent("PLAYER_DAMAGE_DONE_MODS", SI.OnEvent)
    SI:RegisterEvent("PLAYER_ENTERING_WORLD", SI.OnEvent)
    SI:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", SI.OnEvent)
    SI:RegisterEvent("PLAYER_LEVEL_UP", SI.OnEvent)
    SI:RegisterEvent("PLAYER_UPDATE_RESTING", SI.OnEvent)
    SI:RegisterEvent("PLAYER_XP_UPDATE", SI.OnEvent)
    SI:RegisterEvent("SKILL_LINES_CHANGED", SI.OnEvent)
    SI:RegisterEvent("UNIT_ATTACK", SI.OnEvent)
    SI:RegisterEvent("UNIT_ATTACK_POWER", SI.OnEvent)
    SI:RegisterEvent("UNIT_ATTACK_SPEED", SI.OnEvent)
    SI:RegisterEvent("UNIT_DAMAGE", SI.OnEvent)
    SI:RegisterEvent("UNIT_LEVEL", SI.OnEvent)
    SI:RegisterEvent("UNIT_MODEL_CHANGED", SI.OnEvent)
    SI:RegisterEvent("UNIT_RANGED_ATTACK_POWER", SI.OnEvent)
    SI:RegisterEvent("UNIT_RANGEDDAMAGE", SI.OnEvent)
    SI:RegisterEvent("UNIT_RESISTANCES", SI.OnEvent)
    SI:RegisterEvent("UNIT_STATS", SI.OnEvent)
end

SI.OnEvent = function(event, ...)
    if string.find(event, "UNIT_") then
        local unitTarget = select(1, ...)
        if unitTarget == "player" then
            SI.Database:UpdateCharacterStats()
        end
    else
        SI.Database:UpdateCharacterStats()
    end
end
