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
        parent.ApplyTheme = UF.Party_ApplyTheme

        return parent
    end
end

function UF:UpdatePartyHeader()
    local group = self.group
    if not group then
        return
    end

    local config = self.config
    self:ClearAllPoints()
    self:Point(unpack(config.point))

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

    self:CreateRange()
    self:CreateAuraHighlight()

    self.Update = UF.UpdateParty
end

function UF:UpdateParty()
    if not self then
        return
    end

    UF:UpdateFrame(self)
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

function UF:Party_ApplyTheme()
    local theme = UF.config.theme
    local config = UF.config.party
    if theme == UF.themes.Blizzard or theme == UF.themes.Blizzard_LargeHealth then
        config.size = {110, 40}
        config.border.enabled = false
        config.shadow.enabled = false

        config.artwork.enabled = true
        config.artwork.background = config.artwork.background or {}
        config.artwork.background.texture = R.media.textures.unitFrames.partyFrame
        config.artwork.background.coords = {0, 1, 0, 1}
        config.artwork.background.point = {"TOPLEFT", "TOPLEFT", -8, 0}
        config.artwork.background.size = {128, 64}
        config.artwork.background.color = {1, 1, 1, 1}

        config.artwork.highlight = config.artwork.highlight or {}
        config.artwork.highlight.texture = R.media.textures.unitFrames.partyFrame_Flash
        config.artwork.highlight.coords = {0, 1, 0, 1}
        config.artwork.highlight.point = {"TOPLEFT", "TOPLEFT", -11, 4}
        config.artwork.highlight.size = {128, 64}

        config.health.enabled = true
        config.health.padding = {40, 0, -10, 14}
        config.health.value.enabled = false

        config.power.enabled = true
        config.power.padding = {0, 0, 0, 15}
        config.power.detached = false
        config.power.inset = false
        config.power.size = {150, 7}
        config.power.value.enabled = false
        config.power.border.enabled = false
        config.power.shadow.enabled = false
        config.power.gloss.enabled = false

        config.portrait.enabled = true
        config.portrait.round = true
        config.portrait.detached = true
        config.portrait.point = {"LEFT", "LEFT", 0, -2}
        config.portrait.size = {37, 37}
        config.portrait.border.enabled = false
        config.portrait.shadow.enabled = false
        config.portrait.gloss.enabled = false

        config.name.enabled = true
        config.name.size = {120, 10}
        config.name.point = {"TOPLEFT", 40, 0}
        config.name.justifyH = "LEFT"

        config.level.enabled = false

        config.pvpIndicator.enabled = true
        config.pvpIndicator.size = {25, 25}
        config.pvpIndicator.point = {"CENTER", "LEFT", -4, -4}

        config.leaderIndicator.enabled = true
        config.leaderIndicator.size = {14, 14}
        config.leaderIndicator.point = {"CENTER", "TOPLEFT", 0, -6}

        config.assistantIndicator.enabled = true
        config.assistantIndicator.size = {14, 14}
        config.assistantIndicator.point = {"CENTER", "TOPLEFT", 0, -6}

        config.masterLooterIndicator.enabled = true
        config.masterLooterIndicator.size = {12, 12}
        config.masterLooterIndicator.point = {"CENTER", "TOPLEFT", 30, -6}

        config.raidRoleIndicator.enabled = true
        config.raidRoleIndicator.size = {14, 14}
        config.raidRoleIndicator.point = {"CENTER", "BOTTOMLEFT", 32, 6}

        config.groupRoleIndicator.enabled = true
        config.groupRoleIndicator.size = {14, 14}
        config.groupRoleIndicator.point = {"CENTER", "BOTTOMLEFT", 32, 6}

        config.raidTargetIndicator.enabled = true
        config.raidTargetIndicator.size = {24, 24}
        config.raidTargetIndicator.point = {"CENTER", "TOPLEFT", 15, 0}

        config.offlineIcon.enabled = true
        config.offlineIcon.size = {48, 48}
        config.offlineIcon.point = {"LEFT", "LEFT", -6, -6}

        config.readyCheckIndicator.enabled = true
        config.readyCheckIndicator.size = {48, 48}
        config.readyCheckIndicator.point = {"LEFT", "LEFT", 0, 0}

        config.castbar.enabled = true
        config.castbar.detached = false
        config.castbar.size = {100, 16}
        config.castbar.attachedPoint = {"LEFT", "RIGHT", 2, 2}
    end
end

