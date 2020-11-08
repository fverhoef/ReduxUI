local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local AB = Addon:AddModule("ActionBars", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function AB:OnInitialize()
    AB.config = {}
    AB.config.db = {
        profile = Addon.config.db.profile.modules.actionBars
    }
end
