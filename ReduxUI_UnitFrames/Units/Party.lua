local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnParty()
    local config = R.config.db.profile.modules.unitFrames.party
    local default = R.config.db.profile.modules.unitFrames.party

    if config.enabled then
        oUF:RegisterStyle(AddonName .. "Party", UF.CreateParty)
        oUF:SetActiveStyle(AddonName .. "Party")
        local partyHeader = oUF:SpawnHeader(AddonName .. "PartyHeader", nil, (config.showInRaid and "party,raid") or "party", "showPlayer", config.showPlayer, "showSolo",
                                            config.showSolo, "showParty", true, "showRaid", config.showInRaid, "point", "BOTTOM", "xOffset", config.xOffset, "yOffset",
                                            config.yOffset, "sortMethod", "NAME", "oUF-initialConfigFunction", ([[
                self:SetWidth(%d)
                self:SetHeight(%d)
                self:GetParent():SetScale(%f)
            ]]):format(config.size[1], config.size[2], config.scale or 1))
        partyHeader:SetPoint(unpack(config.point))
        partyHeader:SetFrameStrata("LOW")
        partyHeader:Show()
        partyHeader.cfg = config

        if config.fader and config.fader.enabled then
            R:CreateFrameFader(partyHeader, config.fader)
        end

        R:CreateDragFrame(partyHeader, "Party", default.point, 200, 40)

        return partyHeader
    end
end

function UF:CreateParty()
    self.cfg = R.config.db.profile.modules.unitFrames.party

    self:SetSize(unpack(self.cfg.size))
    self:SetFrameStrata("LOW")

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    -- texture
    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetTexture(R.media.textures.PartyFrame)
    self.Texture:SetSize(128, 64)
    self.Texture:SetPoint("TOPLEFT", self, 0, -2)

    if self.Texture then
        self.Texture:SetVertexColor(unpack(self.cfg.textureColor))
    end

    -- health
    UF.CreateHealth(self)
    self.Health:SetSize(70, 7)
    self.Health:SetPoint("TOPLEFT", self.Texture, 47, -12)
    self.Health.Value:Hide()

    -- power
    UF.CreatePower(self)
    self.Power:SetHeight(self.Health:GetHeight())
    self.Power.Value:Hide()

    -- name
    UF.CreateName(self, 11)
    self.Name:SetWidth(110)
    self.Name:SetJustifyH("LEFT")
    self.Name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 5)

    -- portrait
    UF.CreatePortrait(self)
    self.Portrait:SetSize(37, 37)
    self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)
    UF.CreateCombatFeedback(self)

    -- pvp
    UF.CreatePvPIndicator(self)
    self.PvPIndicator:SetSize(25, 25)
    self.PvPIndicator:SetPoint("LEFT", self.Texture, "LEFT", -9, 5)

    -- leader
    UF.CreateLeaderIndicator(self)
    self.LeaderIndicator:SetSize(14, 14)
    self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOPLEFT", 1, -1)

    -- assistant
    UF.CreateAssistantIndicator(self)
    self.AssistantIndicator:SetSize(14, 14)
    self.AssistantIndicator:SetPoint("CENTER", self.Portrait, "TOPLEFT", 1, -1)

    -- master loot
    UF.CreateMasterLooterIndicator(self)
    self.MasterLooterIndicator:SetSize(12, 12)
    self.MasterLooterIndicator:SetPoint("CENTER", self.Portrait, "TOPRIGHT", -4, 0)

    -- raid target
    UF.CreateRaidTargetIndicator(self)
    self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, 2)

    -- phase
    if not R.IsClassic then
        UF.CreatePhaseIndicator(self)
    end

    -- offline
    UF.CreateOfflineIcon(self)
    self.OfflineIcon:SetSize(48, 48)

    -- ready check
    UF.CreateReadyCheckIndicator(self)

    -- role
    if not R.IsClassic then
        UF.CreateGroupRoleIndicator(self)
        self.GroupRoleIndicator:SetPoint("BOTTOMLEFT", self.Portrait, -5, -5)
    end

    -- resurrect
    UF.CreateResurrectIndicator(self)

    -- auras
    if self.cfg.auras.enabled then
        UF.CreateAuras(self)
        if self.Auras then
            self.Auras:ClearAllPoints()
            self.Auras:SetPoint("TOPLEFT", self, "TOPRIGHT", 30, 15)
        else
            self.Buffs:ClearAllPoints()
            self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 46, -2)
            self.Buffs.initialAnchor = "TOPLEFT"

            self.Debuffs:ClearAllPoints()
            self.Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 16, 7)
            self.Debuffs.initialAnchor = "TOPLEFT"
        end
    end

    -- castbar
    if self.cfg.castbar.enabled then
        UF.CreateCastbar(self)
        if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
            local _, height = unpack(self.cfg.castbar.size)
            local leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
            self.Castbar:SetPoint("LEFT", self, "RIGHT", 16 + leftPadding + 2, -5)
        else
            self.Castbar:SetPoint("LEFT", self, "RIGHT", 16, -5)
        end
    end

    -- range check
    self.SpellRange = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
        Update = function(self, inRange)
            if self.fader and not self:IsShown() then
                R:StartFadeIn(self, {
                    fadeInAlpha = self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"],
                    fadeInDuration = self.faderConfig.fadeInDuration,
                    fadeInSmooth = self.faderConfig.fadeInSmooth
                })
            else
                self:SetAlpha(self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"])
            end
        end
    }
end

function UF:UpdateParty()
    local header = UF.frames.partyHeader
    local self = nil
    if self then
        UF:UpdateFrame(self)

        if UF:IsBlizzardTheme() then
        else
        end
    end
end
