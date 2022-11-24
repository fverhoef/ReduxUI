local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnRaidHeader()
    if UF.config.raid.enabled then
        _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

		if _G.CompactRaidFrameContainer then
			_G.CompactRaidFrameContainer:UnregisterAllEvents()
		end

        --_G.CompactRaidFrameManager:UnregisterAllEvents()
        CompactRaidFrameManager_SetSetting("IsShown", "0")
        _G.CompactRaidFrameManager:SetParent(R.HiddenFrame)
    end

    return UF:SpawnHeader("Raid", NUM_RAID_GROUPS, RaidMixin, UF.config.raid, UF.defaults.raid)
end

RaidMixin = {}
