local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPartyHeader()
    local config = UF.config.party
    local default = UF.config.party

    if config.enabled then
        local parent = CreateFrame("Frame", addonName .. "Party")
        parent:Point(unpack(config.point))
        parent:SetSize(200, 40)
        parent:Show()
        parent.config = config
        parent.defaults = default

        local group = UF:SpawnHeader("Party", UF.CreateParty, config, default, true)
        parent.group = group

        R:CreateDragFrame(parent, "Party", default.point, 200, 40)

        parent.Update = UF.UpdatePartyHeader
        parent.ForceShow = UF.ForceShowParty
        parent.UnforceShow = UF.UnforceShowParty

        return parent
    end
end

function UF:UpdatePartyHeader()
    local group = self.group
    if not group then
        return
    end

    local config = self.config

    for i = 1, group:GetNumChildren() do
        local child = group:GetAttribute("child" .. i)
        child:ClearAllPoints()
        if child.Update then
            child:Update()
        end
    end

    group:SetAttribute("point", config.unitAnchorPoint)
    group:SetAttribute("columnAnchorPoint", config.unitAnchorPoint)
    if config.unitAnchorPoint == "LEFT" or config.unitAnchorPoint == "RIGHT" then
        group:SetAttribute("xOffset", config.unitSpacing * (config.unitAnchorPoint == "RIGHT" and -1 or 1))
        group:SetAttribute("yOffset", 0)
        group:SetAttribute("columnSpacing", config.unitSpacing)
    else
        group:SetAttribute("xOffset", 0)
        group:SetAttribute("yOffset", config.unitSpacing * (config.unitAnchorPoint == "TOP" and -1 or 1))
        group:SetAttribute("columnSpacing", config.unitSpacing)
    end

    group:SetAttribute("maxColumns", 1)
    group:SetAttribute("unitsPerColumn", 5)
    group:SetAttribute("sortMethod", config.sortMethod)
    group:SetAttribute("sortDir", config.sortDir)

    if not group.isForced then
        if not group.initialized then
            group:SetAttribute("startingIndex", -4)
            group:Show()
            group.initialized = true
        end
        group:SetAttribute("startingIndex", 1)
    end
    UF:UpdateHeaderVisibility(group, (group.isForced and "show") or (config.showRaid and "party,raid") or "party")

    group:ClearAllPoints()
    if config.unitAnchorPoint == "LEFT" then
        group:SetPoint("TOPLEFT", self, "TOPLEFT")
    elseif config.unitAnchorPoint == "RIGHT" then
        group:SetPoint("TOPRIGHT", self, "TOPRIGHT")
    elseif config.unitAnchorPoint == "BOTTOM" then
        group:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
    elseif config.unitAnchorPoint == "TOP" then
        group:SetPoint("TOPLEFT", self, "TOPLEFT")
    end

    group:SetAttribute("showPlayer", config.showPlayer)
    group:SetAttribute("showSolo", config.showSolo)
    group:SetAttribute("showParty", config.showParty)
    group:SetAttribute("showRaid", config.showRaid)
end

function UF:CreateParty()
    self.config = UF.config.party
    self.defaults = UF.defaults.party
    self.isGroupUnit = true

    UF:SetupFrame(self)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    self:CreateRange()
    self:CreateAuraHighlight()

    if self.config.auras.enabled then
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

    self.Update = UF.UpdateParty
end

function UF:UpdateParty()
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

        self:SetSize(105, 30)

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
        self.Power.Border:Hide()
        self.Power.Shadow:Hide()

        self.Name:ClearAllPoints()
        self.Name:SetWidth(110)
        self.Name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 5)
        self.Name:SetJustifyH("LEFT")
        self.Name:Show()

        self.Level:Hide()

        self.Portrait:SetSize(37, 37)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)
        self.Portrait:SetTexCoord(0, 1, 0, 1)

        self.OfflineIcon:SetSize(48, 48)
        self.OfflineIcon:ClearAllPoints()
        self.OfflineIcon:SetPoint("CENTER", self.Portrait, 0, 0)

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

        self.RaidRoleIndicator:ClearAllPoints()
        self.RaidRoleIndicator:SetPoint("BOTTOMLEFT", self.Portrait, -5, -5)

        self.RaidTargetIndicator:ClearAllPoints()
        self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, 2)

        self.ReadyCheckIndicator:ClearAllPoints()
        self.ReadyCheckIndicator:SetPoint("TOPRIGHT", self.Portrait, -7, -7)
        self.ReadyCheckIndicator:SetPoint("BOTTOMLEFT", self.Portrait, 7, 7)

        if not R.isClassic then
            self.GroupRoleIndicator:ClearAllPoints()
            self.GroupRoleIndicator:SetPoint("BOTTOMLEFT", self.Portrait, -5, -5)
        end

        self.CastbarParent:ClearAllPoints()
        self.CastbarParent:SetSize(89, 15)
        self.CastbarParent:SetPoint("TOPLEFT", self, "TOPRIGHT", 15, -13)
        
        self.Highlight:ClearAllPoints()
        self.Highlight:SetSize(128, 63)
        self.Highlight:SetPoint("TOPLEFT", self.Texture, -3, 4)
        self.Highlight:SetTexture(R.media.textures.unitFrames.partyFrame_Flash)
    else
        self.Highlight:SetTexture(nil)
    end
end

function UF:ForceShowParty()
    UF:ForceShowHeader(self.group)
    UF:UpdatePartyHeader()
    self.forceShow = true
end

function UF:UnforceShowParty()
    UF:UnforceShowHeader(self.group)
    UF:UpdatePartyHeader()
    self.forceShow = false
end
