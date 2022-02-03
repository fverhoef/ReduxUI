local _, ns = ...
ns.oUF = {}
ns.oUF.Private = {}

local build = select(4, GetBuildInfo())
ns.oUF.isClassic = build < 20000
ns.oUF.isTbc = build < 30000
ns.oUF.isRetail = build > 30000

if ns.oUF.isClassic or ns.oUF.isTbc then
    if not Enum.PowerType then
        Enum.PowerType = {
            HealthCost = -2,
            None = -1,
            Mana = 0,
            Rage = 1,
            Focus = 2,
            Energy = 3,
            ComboPoints = 4
        }
    end

    if not _G.ALT_MANA_BAR_PAIR_DISPLAY_INFO then
        _G.ALT_MANA_BAR_PAIR_DISPLAY_INFO = {
            DRUID = {
                [Enum.PowerType.Mana] = false,
                [Enum.PowerType.Energy] = true,
                [Enum.PowerType.Rage] = true
            }
        };
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

    if not _G.TotemFrame then
        _G.TotemFrame = CreateFrame("Frame", "TotemFrame")
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

    if not _G.GetSpecialization then
        _G.GetSpecialization = function()
            return nil
        end
    end
end
