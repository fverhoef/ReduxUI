local addonName, ns = ...
local R = _G.ReduxUI
local S = R:AddModule("Skins", "AceEvent-3.0", "AceHook-3.0")

function S:Initialize()
    if not S.config.enabled then return end

    if not R.isRetail then
        S:StyleCharacterFrame()
        S:StyleFriendsFrame()
        S:StyleGuildFrame()
        S:StyleWhoFrame()
        S:StyleQuestLogFrame()
        S:StyleWorldMapFrame()

        S:RegisterEvent("ADDON_LOADED")
    end
end

function S:ADDON_LOADED(event, addonName)
    if addonName == "Blizzard_TrainerUI" then
        S:StyleClassTrainerFrame()
    elseif addonName == "Blizzard_TradeSkillUI" then
        S:StyleTradeSkillFrame()
    end
end