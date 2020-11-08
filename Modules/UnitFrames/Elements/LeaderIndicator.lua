local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateLeaderIndicator = function(self)
    self.LeaderIndicator = self:CreateTexture("$parentLeaderIcon", "ARTWORK")
    self.LeaderIndicator:SetSize(16, 16)

    return self.LeaderIndicator
end