local _, ns = ...
ns.oUF = {}
ns.oUF.Private = {}

ns.oUF.isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
ns.oUF.isTbc = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
ns.oUF.isWrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
ns.oUF.isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

if not ns.oUF.isRetail then
    if not Enum.PowerType then
        Enum.PowerType = { HealthCost = -2, None = -1, Mana = 0, Rage = 1, Focus = 2, Energy = 3, ComboPoints = 4, Runes = 5, RunicPower = 6, RuneBlood = 20, RuneFrost = 21, RuneUnholy = 22 }
    end

    if not _G.ALT_POWER_BAR_PAIR_DISPLAY_INFO then
        _G.ALT_POWER_BAR_PAIR_DISPLAY_INFO = { DRUID = { [Enum.PowerType.Mana] = false, [Enum.PowerType.Energy] = true, [Enum.PowerType.Rage] = true } };
    end

    if not Enum.PvPUnitClassification then
        Enum.PvPUnitClassification = {}
    end

    if not Enum.SummonStatus then
        Enum.SummonStatus = {}
    end

    if not _G.UnitGetTotalAbsorbs then
        _G.UnitGetTotalAbsorbs = function(u)
            return 0
        end
    end

    if not _G.UnitGetTotalHealAbsorbs then
        _G.UnitGetTotalHealAbsorbs = function(u)
            return 0
        end
    end

    if not _G.UnitIsWildBattlePet then
        _G.UnitIsWildBattlePet = function()
            return false
        end
    end

    if not _G.UnitIsBattlePetCompanion then
        _G.UnitIsBattlePetCompanion = function()
            return false
        end
    end

    if not C_PvP.GetHonorRewardInfo then
        C_PvP.GetHonorRewardInfo = function()
            return {}
        end
    end

    if not _G.UnitHonorLevel then
        _G.UnitHonorLevel = function()
            return 0
        end
    end

    if not _G.TotemFrame then
        _G.TotemFrame = CreateFrame("Frame", "TotemFrame")
        _G.TotemFrame:Hide()
    end

    if not _G.GetSpecialization then
        _G.GetSpecialization = function()
            return nil
        end
    end

    if not _G.PowerBarColor.RUNES then
        _G.PowerBarColor.RUNES = { r = 0.50, g = 0.50, b = 0.50 }
    end

    if not _G.HasLFGRestrictions then
        _G.HasLFGRestrictions = function()
            return false
        end
    end

    if not _G.GetUnitChargedPowerPoints then
        _G.GetUnitChargedPowerPoints = function()
            return {}
        end
    end

    if not _G.UnitHasVehicleUI then
        _G.UnitHasVehicleUI = function()
            return false
        end
    end

    if not _G.PartyFrame then
        _G.PartyFrame = CreateFrame("Frame", "PartyFrame")
        _G.PartyFrame:Hide()
    end

    -- sourced from FrameXML/PartyMemberFrame.lua
    local MAX_PARTY_MEMBERS = _G.MAX_PARTY_MEMBERS or 4

    if not _G.PartyFrame.PartyMemberFramePool then
        local partyMemberFrames = {}
        for i = 1, (MAX_PARTY_MEMBERS or 4) do
            tinsert(partyMemberFrames, _G['PartyMemberFrame' .. i])
        end
        _G.PartyFrame.PartyMemberFramePool = {}
        _G.PartyFrame.PartyMemberFramePool.EnumerateActive = function()
            return pairs(partyMemberFrames)
        end
    end

    -- sourced from FrameXML\ArenaUI.lua
    local MAX_ARENA_ENEMIES = _G.MAX_ARENA_ENEMIES or 5

    if not _G.CompactArenaFrame then
        _G.CompactArenaFrame = CreateFrame("Frame", "CompactArenaFrame")
        _G.CompactArenaFrame:Hide()
    end

    if not _G.CompactArenaFrame.memberUnitFrames then
        local memberUnitFrames = {}
        for i = 1, MAX_ARENA_ENEMIES do
            tinsert(memberUnitFrames, _G['ArenaEnemyFrame' .. i])
        end
        _G.CompactArenaFrame.memberUnitFrames = memberUnitFrames
    end

    if not _G.GameTooltip.SetUnitAuraByInstanceID then
        _G.GameTooltip.SetUnitAuraByInstanceID = function(self, unit, auraInstanceId, filter)
            local data = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceId)
            local i = 1
            local spellId = select(10, UnitAura(unit, i, filter))
            while spellId do
                if (spellId == data.spellId) then
                    _G.GameTooltip:SetUnitAura(unit, i, filter)
                    return
                end

                i = i + 1
                spellId = select(10, UnitAura(unit, i, filter))
            end
        end
    end

    if not _G.GameTooltip.SetUnitBuffByAuraInstanceID then
        _G.GameTooltip.SetUnitBuffByAuraInstanceID = function(self, unit, auraInstanceId)
            _G.GameTooltip:SetUnitAuraByInstanceID(unit, auraInstanceId, "HELPFUL")
        end
    end

    if not _G.GameTooltip.SetUnitDebuffByAuraInstanceID then
        _G.GameTooltip.SetUnitDebuffByAuraInstanceID = function(self, unit, auraInstanceId)
            _G.GameTooltip:SetUnitAuraByInstanceID(unit, auraInstanceId, "HARMFUL")
        end
    end
end
