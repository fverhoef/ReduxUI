local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateThreatIndicator = function(self)
    local unit = self.unit
    if unit == "player" then
        self.ThreatIndicator = self:CreateTexture("$parentThreatGlow", "BACKGROUND")
        self.ThreatIndicator:SetSize(242, 93)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, 13, 0)
        self.ThreatIndicator:SetTexture(R.media.textures.unitFrames.targetFrame_Flash)
        self.ThreatIndicator:SetTexCoord(0.9453125, 0, 0, 0.181640625)
    elseif unit == "pet" then
        self.ThreatIndicator = self:CreateTexture("$parentThreatGlow", "BACKGROUND")
        self.ThreatIndicator:SetSize(129, 64)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, -5, 13)
        self.ThreatIndicator:SetTexture(R.media.textures.unitFrames.partyFrame_Flash)
        self.ThreatIndicator:SetTexCoord(0, 1, 1, 0)
    elseif unit == "target" or unit == "focus" then
        self.ThreatIndicator = self:CreateTexture("$parentThreatGlow", "BACKGROUND")
        self.ThreatIndicator:SetSize(239, 92)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, -23, 0)
        self.ThreatIndicator:SetTexture(R.media.textures.unitFrames.targetFrame_Flash)
        self.ThreatIndicator:SetTexCoord(0, 0.9453125, 0, 0.182)
        self.ThreatIndicator.feedbackUnit = "player"
    elseif unit:match("party") then
        self.ThreatIndicator = self:CreateTexture("$parentThreatGlow", "BACKGROUND")
        self.ThreatIndicator:SetSize(128, 63)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, -3, 4)
        self.ThreatIndicator:SetTexture(R.media.textures.unitFrames.partyFrame_Flash)
    else
        -- TODO: reuse existing frame glow?
        self.ThreatIndicator = self:CreateShadow(nil, nil, true, {1, 0, 0, 1})
        self.ThreatIndicator.feedbackUnit = "player"
    end

    return self.ThreatIndicator
end

oUF:RegisterMetaFunction("CreateThreatIndicator", UF.CreateThreatIndicator)
