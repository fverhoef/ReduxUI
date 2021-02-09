local parent, ns = ...
ns.oUF = {}
ns.oUF.Private = {}

ns.oUF.isClassic = select(4, GetBuildInfo()) < 20000
ns.oUF.isRetail = not ns.oUF.isClassic

if ns.oUF.isClassic then
    if not _G.ALT_MANA_BAR_PAIR_DISPLAY_INFO then
        _G.ALT_MANA_BAR_PAIR_DISPLAY_INFO = {}
    end

    if not Enum.PowerType then
        Enum.PowerType = {}
    end

    if not Enum.PvPUnitClassification then
        Enum.PvPUnitClassification = {}
    end

    if not Enum.SummonStatus then
        Enum.SummonStatus = {}
    end

    if not _G.UnitCastingInfo then
        local LibClassicCasterino = LibStub("LibClassicCasterino", true)
        _G.UnitCastingInfo = function(unit)
            if LibClassicCasterino then
                return LibClassicCasterino:UnitCastingInfo(unit)
            else
                return CastingInfo(unit)
            end
        end
    end

    if not _G.UnitChannelInfo then
        local LibClassicCasterino = LibStub("LibClassicCasterino", true)
        _G.UnitChannelInfo = function(unit)
            if LibClassicCasterino then
                return LibClassicCasterino:UnitChannelInfo(unit)
            else
                return ChannelInfo(unit)
            end
        end
    end

    if not _G.UnitGetIncomingHeals then
        local HealComm = LibStub("LibHealComm-4.0", true)
        _G.UnitGetIncomingHeals = function(unit, healer)
            if HealComm then
                return HealComm:GetHealAmount(UnitGUID(unit), HealComm.ALL_HEALS, nil, healer and UnitGUID(healer) or nil)
            end
        end
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

    if not _G.UnitEffectiveLevel then
        _G.UnitEffectiveLevel = function(u)
            return UnitLevel(u) - UnitLevel("player")
        end
    end

    if not _G.UnitHasVehicleUI then
        _G.UnitHasVehicleUI = function()
            return false
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

    if not _G.UnitIsMercenary then
        _G.UnitIsMercenary = function()
            return false
        end
    end

    if not _G.GetThreatStatusColor then
        _G.GetThreatStatusColor = function(status)
            if status == 0 then
                return 0.69, 0.69, 0.69
            elseif status == 1 then
                return 1, 1, 0.47
            elseif status == 2 then
                return 1, 0.6, 0
            else
                return 1, 0, 0
            end
        end
    end
end
