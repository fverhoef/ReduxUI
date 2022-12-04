local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnArenaHeader()
    if UF.config.arena.enabled then
        if EditModeManagerFrame then
            EditModeManagerFrame.AccountSettings.RefreshArenaFrames = nop
        end
    end
    return UF:SpawnUnitFrameGroup("Arena", "arena", 5, UF.ArenaMixin, UF.config.arena, UF.defaults.arena)
end

UF.ArenaMixin = {}

function UF.ArenaMixin:PostConfigure()
    if self.config.style == UF.Styles.Vanilla then
        self:SetSize(120, 49)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.partyFrame_LargeHealth or R.media.textures.unitFrames.vanilla.partyFrame)
        self.Artwork:SetTexCoord(240 / 256, 0, 0, 98 / 128)
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "BACKGROUND", nil, 1)
        end
        self.Flash:SetDrawLayer("BACKGROUND")
        self.Flash:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.partyFrame_LargeHealth_Flash or R.media.textures.unitFrames.vanilla.partyFrame_Flash)
        self.Flash:SetTexCoord(1, 0, 0, 1)
        self.Flash:ClearAllPoints()
        self.Flash:SetPoint("CENTER", self, "CENTER", 0, 4)
        self.Flash:SetSize(128, 64)
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 11, "OUTLINE")
        self.Name:SetJustifyH("RIGHT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetSize(74, 13)
        self.Name:SetPoint("TOPRIGHT", self, "TOPRIGHT", -42, 3)
        self:Tag(self.Name, "[name:sub(15)]")

        self.Level:Hide()

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(35, 35)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPRIGHT", self, "TOPRIGHT", -7, -7)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", -46, -11)
        if self.config.largeHealth then
            self.Health:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 4, 21)
        else
            self.Health:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 4, 31)
        end

        if self.config.largeHealth then
            self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
            self.Health.Value:SetJustifyH("LEFT")
            self.Health.Value:ClearAllPoints()
            self.Health.Value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

            self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
            self.Health.Percent:SetJustifyH("RIGHT")
            self.Health.Percent:ClearAllPoints()
            self.Health.Percent:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
        else
            self.Health.Value:Hide()
            self.Health.Percent:Hide()
        end

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        if self.config.largeHealth then
            self.Power:SetPoint("TOPRIGHT", self, "TOPRIGHT", -44, -28)
            self.Power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 4, 12)
        else
            self.Power:SetPoint("TOPRIGHT", self, "TOPRIGHT", -46, -19)
            self.Power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 4, 23)
        end

        self.Power.Border:Hide()
        self.Power.Separator:Hide()
        self.Power.Value:Hide()
        self.Power.Percent:Hide()

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(18, 18)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end

        self.Castbar:ClearAllPoints()
        self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
        self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
    elseif self.config.style == UF.Styles.Modern then
        self:SetSize(138, 53)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
        self.Artwork:SetTexCoord(0.9794921875, 0.75, 0, 0.173828125)
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "OVERLAY", nil, 1)
        end
        self.Flash:SetDrawLayer("OVERLAY")
        self.Flash:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
        self.Flash:SetTexCoord(0.9794921875, 0.75, 0.173828125, 0.34765625)
        self.Flash:ClearAllPoints()
        self.Flash:SetAllPoints()
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 11, "OUTLINE")
        self.Name:SetJustifyH("RIGHT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetPoint("TOPRIGHT", -50, -3)
        self.Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 6, -12)
        self:Tag(self.Name, "[name:sub(15)]")

        self.Level:Hide()

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(40, 40)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPRIGHT", -9, -6)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPRIGHT", -50, -16)
        self.Health:SetPoint("BOTTOMLEFT", 9, 24)

        self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
        self.Health.Value:SetJustifyH("LEFT")
        self.Health.Value:ClearAllPoints()
        self.Health.Value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

        self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
        self.Health.Percent:SetJustifyH("RIGHT")
        self.Health.Percent:ClearAllPoints()
        self.Health.Percent:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPRIGHT", -48, -30)
        self.Power:SetPoint("BOTTOMLEFT", 9, 14)

        self.Power.Border:Hide()
        self.Power.Separator:Hide()
        self.Power.Value:Hide()
        self.Power.Percent:Hide()

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(18, 18)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end

        self.Castbar:ClearAllPoints()
        self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
        self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
    else
        if self.Artwork then
            self.Artwork:Hide()
        end
        if self.Flash then
            self.Flash:Hide()
        end
    end
end
