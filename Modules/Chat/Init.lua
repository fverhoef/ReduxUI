local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local C = Addon:AddModule("Chat", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function C:OnInitialize()
    C.config = {}
    C.config.db = {
        profile = Addon.config.db.profile.modules.chat,
        char = Addon.config.db.char.modules.chat,
    }
end
