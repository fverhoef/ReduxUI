local AddonName, AddonTable = ...
local Addon = AddonTable[1]

local SS = Addon:AddModule("ScreenSaver", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

function SS:OnInitialize()
    SS.config = {}
    SS.config.db = {
        profile = Addon.config.db.profile.modules.screenSaver
    }
end
