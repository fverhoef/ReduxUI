local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local BS = Addon:AddModule("Buttons", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function BS:OnInitialize()
    BS.config = {}
    BS.config.db = {
        profile = Addon.config.db.profile.modules.buttons
    }
end
