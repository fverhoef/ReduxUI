local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateLeaderIndicator = function(self)
    self.LeaderIndicator = self:CreateTexture("$parentLeaderIcon", "OVERLAY")
    self.LeaderIndicator:SetParent(self.Overlay)
    self.LeaderIndicator:SetSize(16, 16)

    return self.LeaderIndicator
end

oUF:RegisterMetaFunction("CreateLeaderIndicator", UF.CreateLeaderIndicator)

UF.UpdateLeaderIndicator = function(self)
    if not self.LeaderIndicator then
        return
    end

    local config = self.config.leaderIndicator
    if config.enabled then
        self:EnableElement("LeaderIndicator")

        self.LeaderIndicator:SetSize(unpack(config.size))
        self.LeaderIndicator:ClearAllPoints()
        self.LeaderIndicator:SetPoint(unpack(config.point))
    else
        self:DisableElement("LeaderIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateLeaderIndicator", UF.UpdateLeaderIndicator)
