local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPartyHeader()
    local config = UF.config.party
    local default = UF.config.party

    if config.enabled then
        local parent = CreateFrame("Frame", addonName .. "Party")
        parent:SetPoint(unpack(config.point))
        parent:SetSize(200, 40)
        parent:Show()

        local group = UF:SpawnHeader("Party", UF.CreateParty, config, default, true)
        group.cfg = config
        parent.group = group

        R:CreateDragFrame(parent, "Party", default.point, 200, 40)

        return parent
    end
end

function UF:UpdatePartyHeader()
    local group = UF.frames.partyHeader.group
    if not group then
        return
    end

    for i = 1, group:GetNumChildren() do
        local child = group:GetAttribute("child" .. i)
        child:ClearAllPoints()
        UF:UpdateParty(child)
    end

    group:SetAttribute("point", group.cfg.unitAnchorPoint)
    group:SetAttribute("columnAnchorPoint", group.cfg.unitAnchorPoint)
    if group.cfg.unitAnchorPoint == "LEFT" or group.cfg.unitAnchorPoint == "RIGHT" then
        group:SetAttribute("xOffset", group.cfg.unitSpacing * (group.cfg.unitAnchorPoint == "RIGHT" and -1 or 1))
        group:SetAttribute("yOffset", 0)
        group:SetAttribute("columnSpacing", group.cfg.unitSpacing)
    else
        group:SetAttribute("xOffset", 0)
        group:SetAttribute("yOffset", group.cfg.unitSpacing * (group.cfg.unitAnchorPoint == "TOP" and -1 or 1))
        group:SetAttribute("columnSpacing", group.cfg.unitSpacing)
    end

    group:SetAttribute("maxColumns", 1)
    group:SetAttribute("unitsPerColumn", 5)
    group:SetAttribute("sortMethod", group.cfg.sortMethod)
    group:SetAttribute("sortDir", group.cfg.sortDir)

    if not group.isForced then
        if not group.initialized then
            group:SetAttribute("startingIndex", -4)
            group:Show()
            group.initialized = true
        end
        group:SetAttribute("startingIndex", 1)
    end
    UF:UpdateHeaderVisibility(group, (group.isForced and "show") or (group.cfg.showRaid and "party,raid") or "party")

    group:ClearAllPoints()
    if group.cfg.unitAnchorPoint == "LEFT" then
        group:SetPoint("TOPLEFT", UF.frames.partyHeader, "TOPLEFT")
    elseif group.cfg.unitAnchorPoint == "RIGHT" then
        group:SetPoint("TOPRIGHT", UF.frames.partyHeader, "TOPRIGHT")
    elseif group.cfg.unitAnchorPoint == "BOTTOM" then
        group:SetPoint("BOTTOMLEFT", UF.frames.partyHeader, "BOTTOMLEFT")
    elseif group.cfg.unitAnchorPoint == "TOP" then
        group:SetPoint("TOPLEFT", UF.frames.partyHeader, "TOPLEFT")
    end

    group:SetAttribute("showPlayer", group.cfg.showPlayer)
    group:SetAttribute("showSolo", group.cfg.showSolo)
    group:SetAttribute("showParty", group.cfg.showParty)
    group:SetAttribute("showRaid", group.cfg.showRaid)
end

function UF:CreateParty()
    self.cfg = UF.config.party

    self:SetSize(unpack(self.cfg.size))
    self:SetFrameStrata("LOW")

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    self:CreateHealth()
    self:CreatePower()
    self:CreateName()
    self:CreatePortrait()
    self:CreateCombatFeedback()
    self:CreatePvPIndicator()
    self:CreateLeaderIndicator()
    self:CreateAssistantIndicator()
    self:CreateMasterLooterIndicator()
    self:CreateRaidTargetIndicator()
    self:CreateOfflineIcon()
    self:CreateReadyCheckIndicator()
    self:CreateRaidRoleIndicator()
    self:CreateResurrectIndicator()

    if not R.isClassic then
        self:CreatePhaseIndicator()
        self:CreateGroupRoleIndicator()
    end

    self:CreateAuras()
    if self.cfg.auras.enabled then
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

    self:CreateCastbar()
    if self.cfg.castbar.enabled then
        if self.cfg.castbar.showIcon and not self.cfg.castbar.showIconOutside then
            local _, height = unpack(self.cfg.castbar.size)
            local leftPadding = height - self.cfg.castbar.borderSize / 2 - 1
            self.Castbar:SetPoint("LEFT", self, "RIGHT", 16 + leftPadding + 2, -5)
        else
            self.Castbar:SetPoint("LEFT", self, "RIGHT", 16, -5)
        end
    end

    self:CreateRange()
    self:CreateAuraHighlight()

    self.Update = function(self)
        UF:UpdateParty(self)
    end
end

function UF:UpdateParty(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
        self.Border:Hide()
        self.Shadow:Hide()

        self:EnableElement("Power")
        self:EnableElement("Portrait")
        self:EnableElement("LeaderIndicator")
        self:EnableElement("AssistantIndicator")
        self:EnableElement("MasterLooterIndicator")

        self.Texture:SetTexture(R.media.textures.unitFrames.partyFrame)
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint("TOPLEFT", self, 0, -2)

        self.Health:SetSize(70, 7)
        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPLEFT", self.Texture, 47, -12)
        self.Health.Value:Hide()

        self.Power:SetHeight(self.Health:GetHeight())
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
        self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
        self.Power.Value:Hide()

        self.Name:SetWidth(110)
        self.Name:SetJustifyH("LEFT")
        self.Name:ClearAllPoints()
        self.Name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 5)

        self.Portrait:SetSize(37, 37)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)
		self.Portrait:SetTexCoord(0, 1, 0, 1)

        self.OfflineIcon:SetSize(48, 48)

        self.PvPIndicator:SetSize(25, 25)
        self.PvPIndicator:ClearAllPoints()
        self.PvPIndicator:SetPoint("LEFT", self.Texture, "LEFT", -9, 5)

        self.LeaderIndicator:SetSize(14, 14)
        self.LeaderIndicator:ClearAllPoints()
        self.LeaderIndicator:SetPoint("CENTER", self.Portrait, "TOPLEFT", 1, -1)

        self.AssistantIndicator:SetSize(14, 14)
        self.AssistantIndicator:ClearAllPoints()
        self.AssistantIndicator:SetPoint("CENTER", self.Portrait, "TOPLEFT", 1, -1)

        self.MasterLooterIndicator:SetSize(12, 12)
        self.MasterLooterIndicator:ClearAllPoints()
        self.MasterLooterIndicator:SetPoint("CENTER", self.Portrait, "TOPRIGHT", -4, 0)

        self.RaidTargetIndicator:ClearAllPoints()
        self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, 2)

        self.RaidRoleIndicator:ClearAllPoints()
        self.RaidRoleIndicator:SetPoint("BOTTOMLEFT", self.Portrait, -5, -5)

        if not R.isClassic then
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("BOTTOMLEFT", self.Portrait, -5, -5)
        end
    end
end

function UF:ForceShowParty()
    UF:ForceShowHeader(UF.frames.partyHeader.group)
    UF:UpdatePartyHeader()
    UF.forceShowParty = true
end

function UF:UnforceShowParty()
    UF:UnforceShowHeader(UF.frames.partyHeader.group)
    UF:UpdatePartyHeader()
    UF.forceShowParty = false
end
