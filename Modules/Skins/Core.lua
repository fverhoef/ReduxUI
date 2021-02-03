local addonName, ns = ...
local R = _G.ReduxUI
local S = R:AddModule("Skins", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function S:Initialize()
    if not R.config.db.profile.modules.skins.enabled then
        return
    end

    R:CreateDragFrame(_G.LootFrame, "Loot Frame", nil, 170, 240)
end
