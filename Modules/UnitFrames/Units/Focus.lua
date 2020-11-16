local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnFocus()
    local config = UF.config.db.profile.focus
    local default = Addon.config.defaults.profile.modules.unitFrames.focus
    
    if Addon.IsRetail and config.enabled then
        return UF:SpawnFrame("Focus", "focus", UF.CreateFocus, config, default)
    end
end

function UF:CreateFocus()
    self.cfg = UF.config.db.profile.focus
end

function UF:UpdateFocus()
    local self = UF.frames.focus
    if self then
        UF:UpdateFrame(self)

        if UF:IsBlizzardTheme() then
        else
        end
    end
end
