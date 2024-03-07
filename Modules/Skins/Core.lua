local addonName, ns = ...
local R = _G.ReduxUI
local S = R:AddModule("Skins", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

function S:Initialize()
    S:UpdateBlizzardFonts()
end

function S:Enable()
    if not S.config.enabled then
        return
    end

    S:StyleDurabilityFrame()
    S:StyleWatchFrame()
    S:StyleQuestWatchFrame()
    S:StyleObjectiveTrackerFrame()
    S:StyleTicketStatusFrame()
    S:StyleVehicleSeatIndicator()
    S:StyleWidgets()

    if not R.isRetail then
        S:StyleCharacterFrame()
        S:StyleFriendsFrame()
        S:StyleGuildFrame()
        S:StyleQuestLogFrame()
        S:StyleWhoFrame()
    end

    S:StyleWorldMapFrame()

    S:RegisterEvent("ADDON_LOADED")
    if IsAddOnLoaded("Blizzard_EngravingUI") then
        S:StyleEngravingFrame()
    end
    if IsAddOnLoaded("Blizzard_TradeSkillUI") then
        S:StyleTradeSkillFrame()
    end
end

function S:ADDON_LOADED(event, addon)
    if addon == "Blizzard_EngravingUI" then
        S:StyleEngravingFrame()
    elseif addon == "Blizzard_TradeSkillUI" then
        S:StyleTradeSkillFrame()
    end
end
