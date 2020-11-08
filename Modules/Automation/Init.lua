local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local AM = Addon:AddModule("Automation", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function AM:OnInitialize()
    AM.config = {}
    AM.config.db = {
        profile = Addon.config.db.profile.modules.automation
    }
end
