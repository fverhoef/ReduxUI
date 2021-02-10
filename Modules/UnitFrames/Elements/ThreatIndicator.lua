local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateThreatIndicator = function(self)
    local unit = self.unit
    self.ThreatIndicator = CreateFrame("Frame", "$parentThreat", self)

    if unit == "player" then
        self.ThreatIndicator.Texture = self.ThreatIndicator:CreateTexture("$parentTexture", "BACKGROUND")
        self.ThreatIndicator.Texture:SetSize(242, 93)
        self.ThreatIndicator.Texture:SetPoint("TOPLEFT", self.Texture, 13, 0)
        self.ThreatIndicator.Texture:SetTexture(R.media.textures.unitFrames.targetFrame_Flash)
        self.ThreatIndicator.Texture:SetTexCoord(0.9453125, 0, 0, 0.181640625)
    elseif unit == "pet" then
        self.ThreatIndicator.Texture = self.ThreatIndicator:CreateTexture("$parentTexture", "BACKGROUND")
        self.ThreatIndicator.Texture:SetSize(129, 64)
        self.ThreatIndicator.Texture:SetPoint("TOPLEFT", self.Texture, -5, 13)
        self.ThreatIndicator.Texture:SetTexture(R.media.textures.unitFrames.partyFrame_Flash)
        self.ThreatIndicator.Texture:SetTexCoord(0, 1, 1, 0)
    elseif unit == "target" or unit == "focus" then
        self.ThreatIndicator.Texture = self.ThreatIndicator:CreateTexture("$parentTexture", "BACKGROUND")
        self.ThreatIndicator.Texture:SetSize(239, 92)
        self.ThreatIndicator.Texture:SetPoint("TOPLEFT", self.Texture, -23, 0)
        self.ThreatIndicator.Texture:SetTexture(R.media.textures.unitFrames.targetFrame_Flash)
        self.ThreatIndicator.Texture:SetTexCoord(0, 0.9453125, 0, 0.182)
        self.ThreatIndicator.feedbackUnit = "player"
    elseif unit:match("party") then
        self.ThreatIndicator.Texture = self.ThreatIndicator:CreateTexture("$parentTexture", "BACKGROUND")
        self.ThreatIndicator.Texture:SetSize(128, 63)
        self.ThreatIndicator.Texture:SetPoint("TOPLEFT", self.Texture, -3, 4)
        self.ThreatIndicator.Texture:SetTexture(R.media.textures.unitFrames.partyFrame_Flash)
    else
        self.ThreatIndicator.feedbackUnit = "player"
    end

    self.ThreatIndicator:SetScript("OnShow", function()
        if self.ThreatIndicator.Texture then
            self.ThreatIndicator.Texture:SetShown(UF:IsBlizzardTheme())
        end
        self.ThreatIndicator.originalShadowColor = self:GetShadowColor()
    end)
    self.ThreatIndicator:SetScript("OnHide", function()
        if self.ThreatIndicator.Texture then
            self.ThreatIndicator.Texture:Hide()
        end
        self:SetShadowColor({r, g, b, a})
    end)
    self.ThreatIndicator.SetVertexColor = function(frame, r, g, b, a)
        if self.ThreatIndicator.Texture then
            self.ThreatIndicator.Texture:SetVertexColor(r, g, b, a)
        end
        self:SetShadowColor({r, g, b, a})
    end

    return self.ThreatIndicator
end

oUF:RegisterMetaFunction("CreateThreatIndicator", UF.CreateThreatIndicator)
