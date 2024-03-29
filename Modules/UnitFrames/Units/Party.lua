local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPartyHeader()
    if UF.config.party.enabled then
        _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

        if _G.CompactPartyFrame then
            _G.CompactPartyFrame:UnregisterAllEvents()
        end

        if EditModeManagerFrame and EditModeManagerFrame.AccountSettings then
            EditModeManagerFrame.AccountSettings.RefreshPartyFrames = nop
            EditModeManagerFrame.AccountSettings.ResetPartyFrames = nop
        end
    end
    return UF:SpawnHeader("Party", 1, UF.PartyMixin, UF.config.party, UF.defaults.party)
end

UF.PartyMixin = {}

function UF.PartyMixin:PostConfigure()
    if self.config.style == UF.Styles.Vanilla then
        self:SetSize(120, 49)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        self.Artwork:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.partyFrame_LargeHealth or R.media.textures.unitFrames.vanilla.partyFrame)
        self.Artwork:SetTexCoord(0, 240 / 256, 0, 98 / 128)
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "BACKGROUND", nil, 1)
        end
        self.Flash:SetDrawLayer("BACKGROUND")
        self.Flash:SetTexture(self.config.largeHealth and R.media.textures.unitFrames.vanilla.partyFrame_LargeHealth_Flash or R.media.textures.unitFrames.vanilla.partyFrame_Flash)
        self.Flash:SetTexCoord(0, 1, 0, 1)
        self.Flash:ClearAllPoints()
        self.Flash:SetPoint("CENTER", self, "CENTER", 0, -4)
        self.Flash:SetSize(128, 64)
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 11, "OUTLINE")
        self.Name:SetJustifyH("LEFT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetSize(74, 13)
        self.Name:SetPoint("TOPLEFT", self, "TOPLEFT", 42, 3)
        self:Tag(self.Name, "[name:sub(15)]")

        self.Level:Hide()

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(35, 35)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPLEFT", self, "TOPLEFT", 7, -7)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 46, -11)
        if self.config.largeHealth then
            self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 21)
        else
            self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 31)
        end

        if self.config.largeHealth then
            self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
            self.Health.Value:SetJustifyH("RIGHT")
            self.Health.Value:ClearAllPoints()
            self.Health.Value:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)

            self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
            self.Health.Percent:SetJustifyH("LEFT")
            self.Health.Percent:ClearAllPoints()
            self.Health.Percent:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
        else
            self.Health.Value:Hide()
            self.Health.Percent:Hide()
        end

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        if self.config.largeHealth then
            self.Power:SetPoint("TOPLEFT", self, "TOPLEFT", 44, -28)
            self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 12)
        else
            self.Power:SetPoint("TOPLEFT", self, "TOPLEFT", 46, -19)
            self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 23)
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

        if not self.config.castbar.overrideStylePosition then
            self.Castbar:ClearAllPoints()
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
            self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
        end
    elseif self.config.style == UF.Styles.Redux or self.config.style == UF.Styles.Modern then
        self:SetSize(138, 53)

        self.Border:Hide()
        self.Inlay:Hide()
        self.Shadow:Hide()

        if not self.Artwork then
            self.Artwork = self.Overlay:CreateTexture("$parentArtwork", "BORDER", nil, 7)
        end
        if self.config.style == UF.Styles.Redux then
            self.Artwork:SetTexture(R.media.textures.unitFrames.redux.unitFrameSmall)
            self.Artwork:SetTexCoord(0, 0.91796875, 0, 0.34765625)
        else
            self.Artwork:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
            self.Artwork:SetTexCoord(0.75, 0.9794921875, 0, 0.173828125)
        end
        self.Artwork:ClearAllPoints()
        self.Artwork:SetAllPoints()
        self.Artwork:Show()

        if not self.Flash then
            self.Flash = self.Overlay:CreateTexture("$parentFlash", "OVERLAY", nil, 1)
        end
        self.Flash:SetDrawLayer("OVERLAY")
        if self.config.style == UF.Styles.Redux then
            self.Flash:SetTexture(R.media.textures.unitFrames.redux.unitFrameSmall)
            self.Flash:SetTexCoord(0, 0.91796875, 0.34765625, 0.6953125)
        else
            self.Flash:SetTexture(R.media.textures.unitFrames.modern.unitFrame)
            self.Flash:SetTexCoord(0.75, 0.9794921875, 0.173828125, 0.34765625)
        end
        self.Flash:ClearAllPoints()
        self.Flash:SetAllPoints()
        self.Flash:Hide()

        self.Name:Show()
        self.Name:SetFont(self.config.name.font, 11, "OUTLINE")
        self.Name:SetJustifyH("LEFT")
        self.Name:SetShadowOffset(0, 0)

        self.Name:ClearAllPoints()
        self.Name:SetPoint("TOPLEFT", 50, -3)
        self.Name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -6, -12)
        self:Tag(self.Name, "[name:sub(15)]")

        self.Level:Hide()

        self.PortraitHolder.Separator:Hide()

        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.PortraitRound
        self.PortraitHolder:SetSize(40, 40)
        self.PortraitHolder:ClearAllPoints()
        self.PortraitHolder:SetPoint("TOPLEFT", 7, -6)
        self:EnableElement("Portrait")

        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPLEFT", 50, -16)
        self.Health:SetPoint("BOTTOMRIGHT", -9, 24)

        self.Health.Value:SetFont(self.config.health.value.font, 11, "OUTLINE")
        self.Health.Value:SetJustifyH("RIGHT")
        self.Health.Value:ClearAllPoints()
        self.Health.Value:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)

        self.Health.Percent:SetFont(self.config.health.percent.font, 11, "OUTLINE")
        self.Health.Percent:SetJustifyH("LEFT")
        self.Health.Percent:ClearAllPoints()
        self.Health.Percent:SetPoint("LEFT", self.Health, "LEFT", 2, 0)

        self:EnableElement("Power")
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", 48, -30)
        self.Power:SetPoint("BOTTOMRIGHT", -9, 14)

        self.Power.Border:Hide()
        self.Power.Separator:Hide()
        self.Power.Value:Hide()
        self.Power.Percent:Hide()

        if self.RaidTargetIndicator then
            self.RaidTargetIndicator:SetSize(18, 18)
            self.RaidTargetIndicator:ClearAllPoints()
            self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP")
        end

        if not self.config.castbar.overrideStylePosition then
            self.Castbar:ClearAllPoints()
            self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, -5)
            self.Castbar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -5, -16)
        end
    else
        if self.Artwork then
            self.Artwork:Hide()
        end
        if self.Flash then
            self.Flash:Hide()
        end
    end
end
