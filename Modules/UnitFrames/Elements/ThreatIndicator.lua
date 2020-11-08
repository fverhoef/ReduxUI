local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateThreatIndicator = function(self)
    local unit = self.unit

    self.ThreatIndicator = self:CreateTexture("$parentThreatGlow", "BACKGROUND")

    if unit == "player" then
        self.ThreatIndicator:SetSize(242, 93)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, 13, 0)
        self.ThreatIndicator:SetTexture(Addon.media.textures.TargetFrame_Flash)
        self.ThreatIndicator:SetTexCoord(0.9453125, 0, 0, 0.181640625)
    elseif unit == "pet" then
        self.ThreatIndicator:SetSize(129, 64)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, -5, 13)
        self.ThreatIndicator:SetTexture(Addon.media.textures.PartyFrame_Flash)
        self.ThreatIndicator:SetTexCoord(0, 1, 1, 0)
    elseif unit == "target" or unit == "focus" then
        self.ThreatIndicator:SetSize(239, 92)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, -23, 0)
        self.ThreatIndicator:SetTexture(Addon.media.textures.TargetFrame_Flash)
        self.ThreatIndicator:SetTexCoord(0, 0.9453125, 0, 0.182)
        self.ThreatIndicator.feedbackUnit = "player"
    elseif unit:match("party") then
        self.ThreatIndicator:SetSize(128, 63)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Texture, -3, 4)
        self.ThreatIndicator:SetTexture(Addon.media.textures.PartyFrame_Flash)
    elseif unit:match("nameplate") then
        self.ThreatIndicator:SetSize(self:GetWidth() + 20, self:GetHeight() + 20)
        self.ThreatIndicator:SetPoint("TOPLEFT", self.Health, -10, 10)
        self.ThreatIndicator:SetTexture(Addon.media.textures.Nameplate_Flash)
        self.ThreatIndicator.feedbackUnit = "player"
    end

    return self.ThreatIndicator
end