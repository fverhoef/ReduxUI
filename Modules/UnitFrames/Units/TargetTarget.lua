local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTargetTarget()
    return UF:SpawnFrame("TargetTarget", "targettarget", TargetTargetMixin, UF.config.targettarget, UF.defaults.targettarget)
end

TargetTargetMixin = {}

function TargetTargetMixin:PostConfigure()
    if self.config.style == UF.Styles.Blizzard then
        self:SetSize(93, 45)
        self:ClearAllPoints()
        self:SetPoint("LEFT", UF.frames.target, "RIGHT", 2, 2)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self:CreateTexture("$parentArtwork", "BORDER", nil, 7)
            self.Artwork:SetTexture(R.media.textures.unitFrames.targetOfTargetFrame)
            self.Artwork:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
            self.Artwork:SetAllPoints()
        end
        self.Artwork:Show()

        if self.PortraitHolder then
            self.PortraitHolder:Hide()
        end

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 11, "OUTLINE")
        self.Name:SetJustifyH("CENTER")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetSize(50, 13)
        self.Name:SetPoint("TOPLEFT", self, "TOPLEFT", 42, -1)
        self:Tag(self.Name, "[name:sub(10)]")

        self.Level:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitRound
        self.Portrait:SetSize(35, 35)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
        self:EnableElement("Portrait")
        self:UpdatePortraitTexture()

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 42, -15)
        self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 23)

        self.Health.Value:Hide()
        self.Health.Percent:Hide()

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", self, "TOPLEFT", 42, -23)
        self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 15)

        self.Power.Value:Hide()
        self.Power.Percent:Hide()

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(18, 18)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end
    elseif self.config.style == UF.Styles.Custom then
        if self.Artwork then
            self.Artwork:Hide()
        end
    end
end
