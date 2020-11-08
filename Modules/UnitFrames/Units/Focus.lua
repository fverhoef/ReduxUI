local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnFocus()
    local config = UF.config.db.profile.focus
    local default = Addon.config.defaults.profile.modules.unitFrames.focus
    
    if UF.IsRetail and config.enabled then
        return UF:SpawnFrame("Focus", "focus", UF.CreateFocusStyle, config, default)
    end
end

function UF:CreateFocusStyle()
    self.cfg = UF.config.db.profile.focus
end
