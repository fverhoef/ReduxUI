local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePortrait = function(self)
    self.Portrait = self.Health:CreateTexture("$parentPortrait", "BACKGROUND")
    self.Portrait.PostUpdate = function()
        self.Portrait:SetDesaturated(not UnitIsConnected(self.unit))
    end

    return self.Portrait
end

oUF:RegisterMetaFunction("CreatePortrait", UF.CreatePortrait)