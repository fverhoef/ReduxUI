local addonName, ns = ...
local R = _G.ReduxUI
local S = R:AddModule("Skins", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

function S:Initialize()
    S:UpdateBlizzardFonts()
end

function S:Enable()
    if not S.config.enabled then return end
    
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
        S:StyleWhoFrame()

        S:RegisterEvent("ADDON_LOADED")
    end
    
    S:StyleWorldMapFrame()
end

function S:ADDON_LOADED(event, addonName)
    if addonName == "Blizzard_TrainerUI" then
        S:StyleClassTrainerFrame()
    elseif addonName == "Blizzard_TradeSkillUI" then
        S:StyleTradeSkillFrame()
    end
end
