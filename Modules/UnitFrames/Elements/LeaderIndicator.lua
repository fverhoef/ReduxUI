local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateLeaderIndicator()
    if not self.config.leaderIndicator.enabled then return end

    self.LeaderIndicator = self:CreateTexture("$parentLeaderIcon", "OVERLAY")
    self.LeaderIndicator:SetParent(self.Overlay)
    self.LeaderIndicator:SetSize(16, 16)

    return self.LeaderIndicator
end

oUF:RegisterMetaFunction("CreateLeaderIndicator", UF.CreateLeaderIndicator)

function UF:ConfigureLeaderIndicator()
    local config = self.config.leaderIndicator
    if not config.enabled then
        self:DisableElement("LeaderIndicator")
        return
    elseif not self.LeaderIndicator then
        self:CreateLeaderIndicator()
    end

    self:EnableElement("LeaderIndicator")

    self.LeaderIndicator:SetSize(unpack(config.size))
    self.LeaderIndicator:ClearAllPoints()
    self.LeaderIndicator:Point(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigureLeaderIndicator", UF.ConfigureLeaderIndicator)
