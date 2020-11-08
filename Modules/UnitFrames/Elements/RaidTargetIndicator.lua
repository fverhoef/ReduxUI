local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateRaidTargetIndicator = function(self)
    self.RaidTargetIndicator = self:CreateTexture("$parentRaidTargetIcon", "OVERLAY")
    if self.Portrait then
        self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, -1)
    else
        self.RaidTargetIndicator:SetPoint("RIGHT", self.Health, "LEFT", -5, 0)
    end
    local size = (self.Portrait and self.Portrait:GetSize() / 3) or 24
    self.RaidTargetIndicator:SetSize(size, size)

    return self.RaidTargetIndicator
end