local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnRaidHeader()
    local config = R.config.db.profile.modules.unitFrames.raid
    local default = R.config.defaults.profile.modules.unitFrames.raid

    if config.enabled then
        local parent = CreateFrame("Frame", addonName .. "Raid")
        parent:SetPoint(unpack(config.point))
        parent:SetSize(200, 40)
        parent:Show()
        parent.groups = {}

        oUF:RegisterStyle(addonName .. "Raid", UF.CreateRaid)
        oUF:SetActiveStyle(addonName .. "Raid")
        for i = 1, NUM_RAID_GROUPS do
            local group = UF:SpawnHeader("Raid", UF.CreateRaid, config, default, false, i)
            group.cfg = config

            parent.groups[i] = group
        end

        R:CreateDragFrame(parent, "Raid Frames", default.point, 200, 40)

        CompactRaidFrameManager_SetSetting("IsShown", "0")
        _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
        _G.CompactRaidFrameManager:UnregisterAllEvents()
        _G.CompactRaidFrameManager:SetParent(R.HiddenFrame)

        return parent
    end
end

function UF:UpdateRaidHeader()
    if not UF.frames.raidHeader then
        return
    end

    for i, group in ipairs(UF.frames.raidHeader.groups) do
        group:ClearAllPoints()

        for j = 1, group:GetNumChildren() do
            local child = group:GetAttribute("child" .. j)
            child:ClearAllPoints()
            UF:UpdateRaid(child)
        end

        group:SetAttribute("point", group.cfg.unitAnchorPoint)
        if group.cfg.unitAnchorPoint == "LEFT" or group.cfg.unitAnchorPoint == "RIGHT" then
            group:SetAttribute("xOffset", group.cfg.unitSpacing * (group.cfg.unitAnchorPoint == "RIGHT" and -1 or 1))
            group:SetAttribute("yOffset", 0)
            group:SetAttribute("columnSpacing", group.cfg.unitSpacing)
        else
            group:SetAttribute("xOffset", 0)
            group:SetAttribute("yOffset", group.cfg.unitSpacing * (group.cfg.unitAnchorPoint == "TOP" and -1 or 1))
            group:SetAttribute("columnSpacing", group.cfg.unitSpacing)
        end

        -- group:SetAttribute("columnAnchorPoint", group.cfg.columnAnchorPoint)

        group:SetAttribute("maxColumns", group.cfg.raidWideSorting and 40 or 1)
        group:SetAttribute("unitsPerColumn", group.cfg.raidWideSorting and 40 or 5)

        group:SetAttribute("groupBy", group.cfg.groupBy)
        group:SetAttribute("groupingOrder", group.cfg.groupingOrder)
        group:SetAttribute("sortMethod", group.cfg.sortMethod)
        group:SetAttribute("sortDir", group.cfg.sortDir)

        if not group.isForced then
            if not group.initialized then
                group:SetAttribute("startingIndex", -4)
                group:Show()
                group.initialized = true
            end
            group:SetAttribute("startingIndex", 1)
            group:SetAttribute("visibility", group.cfg.visibility)
        else
            group:SetAttribute("visibility", nil)
        end

        group:SetAttribute("showPlayer", group.cfg.showPlayer)
        group:SetAttribute("showSolo", group.cfg.showSolo)
        group:SetAttribute("showParty", group.cfg.showParty)
        group:SetAttribute("showRaid", group.cfg.showRaid)

        if i == 1 then
            local groupAnchorPoint
            if group.cfg.groupAnchorPoint == "LEFT" then
                groupAnchorPoint = group.cfg.unitAnchorPoint == "BOTTOM" and "BOTTOMLEFT" or "TOPLEFT"
            elseif group.cfg.groupAnchorPoint == "RIGHT" then
                groupAnchorPoint = group.cfg.unitAnchorPoint == "BOTTOM" and "BOTTOMRIGHT" or "TOPRIGHT"
            elseif group.cfg.groupAnchorPoint == "TOP" then
                groupAnchorPoint = group.cfg.unitAnchorPoint == "RIGHT" and "TOPRIGHT" or "TOPLEFT"
            elseif group.cfg.groupAnchorPoint == "BOTTOM" then
                groupAnchorPoint = group.cfg.unitAnchorPoint == "RIGHT" and "BOTTOMRIGHT" or "TOPLEFT"
            end

            group:SetPoint(groupAnchorPoint, UF.frames.raidHeader, groupAnchorPoint)
        else
            local groupAnchorPoint, groupRelativeAnchorPoint, xOffset, yOffset
            if group.cfg.groupAnchorPoint == "LEFT" then
                groupAnchorPoint = (group.cfg.unitAnchorPoint == "BOTTOM" and "BOTTOMLEFT") or
                                       (group.cfg.unitAnchorPoint == "TOP" and "TOPLEFT") or "LEFT"
                groupRelativeAnchorPoint = (group.cfg.unitAnchorPoint == "BOTTOM" and "BOTTOMRIGHT") or
                                               (group.cfg.unitAnchorPoint == "TOP" and "TOPRIGHT") or "RIGHT"
                xOffset = group.cfg.groupSpacing
            elseif group.cfg.groupAnchorPoint == "RIGHT" then
                groupAnchorPoint = (group.cfg.unitAnchorPoint == "BOTTOM" and "BOTTOMRIGHT") or
                                       (group.cfg.unitAnchorPoint == "TOP" and "TOPRIGHT") or "RIGHT"
                groupRelativeAnchorPoint = (group.cfg.unitAnchorPoint == "BOTTOM" and "BOTTOMLEFT") or
                                               (group.cfg.unitAnchorPoint == "TOP" and "TOPLEFT") or "LEFT"
                xOffset = -group.cfg.groupSpacing
            elseif group.cfg.groupAnchorPoint == "TOP" then
                groupAnchorPoint = (group.cfg.unitAnchorPoint == "RIGHT" and "TOPLEFT") or
                                       (group.cfg.unitAnchorPoint == "LEFT" and "TOPRIGHT") or "TOP"
                groupRelativeAnchorPoint = (group.cfg.unitAnchorPoint == "RIGHT" and "BOTTOMLEFT") or
                                               (group.cfg.unitAnchorPoint == "LEFT" and "BOTTOMRIGHT") or "BOTTOM"
                yOffset = -group.cfg.groupSpacing
            elseif group.cfg.groupAnchorPoint == "BOTTOM" then
                groupAnchorPoint = (group.cfg.unitAnchorPoint == "RIGHT" and "BOTTOMLEFT") or
                                       (group.cfg.unitAnchorPoint == "LEFT" and "BOTTOMRIGHT") or "BOTTOM"
                groupRelativeAnchorPoint = (group.cfg.unitAnchorPoint == "RIGHT" and "TOPLEFT") or
                                               (group.cfg.unitAnchorPoint == "LEFT" and "TOPRIGHT") or "TOP"
                yOffset = group.cfg.groupSpacing
            end

            group:SetPoint(groupAnchorPoint, UF.frames.raidHeader.groups[i - 1], groupRelativeAnchorPoint, xOffset or 0,
                           yOffset or 0)
        end
    end
end

function UF:CreateRaid()
    self.cfg = R.config.db.profile.modules.unitFrames.raid

    local width, height = unpack(self.cfg.size)
    self:SetSize(width, height)
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(20)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)

    -- health
    self:CreateHealth()
    self.Health:SetSize(width, height)
    self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", self.cfg.border.enabled and 2 or 0, 0)
    self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", self.cfg.border.enabled and -2 or 0, 0)
    self.Health.Value:ClearAllPoints()
    self.Health.Value:SetPoint("TOP", self, "TOP", 0, -20)

    -- power
    self:CreatePower()
    if self.cfg.power.enabled then
        self.Power:SetHeight(self.cfg.power.size[2])
        self.Power.Value:Hide()

        self.Health:SetHeight(height - self.cfg.power.size[2])
    end

    -- name
    self:CreateName(12)
    self.Name:SetPoint("TOP", self, "TOP", 0, -8)

    -- leader
    self:CreateLeaderIndicator()
    self.LeaderIndicator:SetSize(14, 14)
    self.LeaderIndicator:ClearAllPoints()
    self.LeaderIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 5)

    -- assistant
    self:CreateAssistantIndicator()
    self.AssistantIndicator:ClearAllPoints()
    self.AssistantIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 5)

    -- master loot
    self:CreateMasterLooterIndicator()
    self.MasterLooterIndicator:ClearAllPoints()
    self.MasterLooterIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", 10, 5)

    -- raid role
    self:CreateRaidRoleIndicator()
    self.RaidRoleIndicator:SetSize(14, 14)
    self.RaidRoleIndicator:ClearAllPoints()
    self.RaidRoleIndicator:SetPoint("TOPRIGHT", self, "TOPRIGHT", 6, 5)

    -- raid target
    self:CreateRaidTargetIndicator(self)
    self.RaidTargetIndicator:SetSize(20, 20)
    self.RaidTargetIndicator:ClearAllPoints()
    self.RaidTargetIndicator:SetPoint("TOP", self, "TOP", 0, 10)

    -- ready check
    self:CreateReadyCheckIndicator()
    self.ReadyCheckIndicator:SetSize(24, 24)
    self.ReadyCheckIndicator:ClearAllPoints()
    self.ReadyCheckIndicator:SetPoint("LEFT", self, "RIGHT", -12, 0)

    -- resurrect
    self:CreateResurrectIndicator()

    -- range check
    self:CreateRange()

    -- aura highlight
    self:CreateAuraHighlight()
end

function UF:UpdateRaid(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    local width, height = unpack(self.cfg.size)
    self:SetSize(width, height)
end

function UF:ForceShowRaid()
    if InCombatLockdown() or not UF.frames.raidHeader then
        return
    end

    for _, group in ipairs(UF.frames.raidHeader.groups) do
        UF:ForceShowHeader(group)
    end

    UF.forceShowRaid = true
end

function UF:UnforceShowRaid()
    if InCombatLockdown() or not UF.frames.raidHeader then
        return
    end

    for _, group in ipairs(UF.frames.raidHeader.groups) do
        UF:UnforceShowHeader(group)
    end

    UF.forceShowRaid = false
end
