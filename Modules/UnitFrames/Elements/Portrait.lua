local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreatePortrait = function(self)
    self.Portrait = self.Health:CreateTexture("$parentPortrait", "BACKGROUND")
    self.Portrait.PostUpdate = function()
        self.Portrait:SetDesaturated(not UnitIsConnected(self.unit))
    end

    return self.Portrait
end