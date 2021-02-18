local addonName, ns = ...
local R = _G.ReduxUI
local S = R:AddModule("Skins", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function S:Initialize()
    if not S.config.enabled then
        return
    end

    S:RegisterEvent("ADDON_LOADED")

    S:StylePaperDollFrame()
    S:StyleHonorFrame()

    S:StyleFriendsFrame()
    S:StyleWhoFrame()
    S:StyleGuildFrame()

    S:StyleQuestLogFrame()

    S:StyleWorldMapFrame()

    _G.CharacterFrame:HookScript("OnShow", S.UpdatePaperDollFrame)

    --R:CreateDragFrame(_G.LootFrame, "Loot Frame", nil, 170, 240)
end

function S:ADDON_LOADED(event, addonName)
    if addonName == "Blizzard_TrainerUI" then
        S:ScheduleTimer("StyleClassTrainerFrame", 0.01)
    elseif addonName == "Blizzard_TradeSkillUI" then
        S:ScheduleTimer("StyleTradeSkillFrame", 0.01)
    end
end
