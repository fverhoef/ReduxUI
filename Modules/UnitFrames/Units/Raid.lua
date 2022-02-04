local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnRaidHeader()
    local config = UF.config.raid
    if not config.enabled then return end

    local default = UF.defaults.raid

    local parent = CreateFrame("Frame", addonName .. "Raid")
    parent:Point(unpack(config.point))
    parent:SetSize(200, 40)
    parent:Show()
    parent.config = config
    parent.defaults = default
    parent.groups = {}

    oUF:RegisterStyle(addonName .. "Raid", UF.CreateRaid)
    oUF:SetActiveStyle(addonName .. "Raid")
    for i = 1, NUM_RAID_GROUPS do
        local group = UF:SpawnHeader("Raid", nil, config, default, false, i)
        parent.groups[i] = group
    end

    R:CreateDragFrame(parent, "Raid", default.point, 200, 40)

    CompactRaidFrameManager_SetSetting("IsShown", "0")
    _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
    _G.CompactRaidFrameManager:UnregisterAllEvents()
    _G.CompactRaidFrameManager:SetParent(R.HiddenFrame)

    parent.Update = UF.UpdateRaidHeader
    parent.ForceShow = UF.ForceShowRaid
    parent.UnforceShow = UF.UnforceShowRaid

    return parent
end

function UF:UpdateRaidHeader()
    if not self or not self.groups then return end

    local config = self.config
    self:ClearAllPoints()
    self:Point(unpack(config.point))

    for i, group in ipairs(self.groups) do
        group:ClearAllPoints()

        for j = 1, group:GetNumChildren() do
            local child = group:GetAttribute("child" .. j)
            if child.Update then child:Update() end
        end

        group:SetAttribute("point", config.unitAnchorPoint)
        if config.unitAnchorPoint == "LEFT" or config.unitAnchorPoint == "RIGHT" then
            group:SetAttribute("xOffset", config.unitSpacing * (config.unitAnchorPoint == "RIGHT" and -1 or 1))
            group:SetAttribute("yOffset", 0)
            group:SetAttribute("columnSpacing", config.unitSpacing)
        else
            group:SetAttribute("xOffset", 0)
            group:SetAttribute("yOffset", config.unitSpacing * (config.unitAnchorPoint == "TOP" and -1 or 1))
            group:SetAttribute("columnSpacing", config.unitSpacing)
        end

        -- group:SetAttribute("columnAnchorPoint", config.columnAnchorPoint)

        group:SetAttribute("maxColumns", config.raidWideSorting and 40 or 1)
        group:SetAttribute("unitsPerColumn", config.raidWideSorting and 40 or 5)

        group:SetAttribute("groupBy", config.groupBy)
        group:SetAttribute("groupingOrder", config.groupingOrder)
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
        UF:UpdateHeaderVisibility(group, (group.isForced and "show") or config.visibility or "show")

        group:SetAttribute("showPlayer", config.showPlayer)
        group:SetAttribute("showSolo", config.showSolo)
        group:SetAttribute("showParty", config.showParty)
        group:SetAttribute("showRaid", config.showRaid)

        if i == 1 then
            local groupAnchorPoint
            if config.groupAnchorPoint == "LEFT" then
                groupAnchorPoint = config.unitAnchorPoint == "BOTTOM" and "BOTTOMLEFT" or "TOPLEFT"
            elseif config.groupAnchorPoint == "RIGHT" then
                groupAnchorPoint = config.unitAnchorPoint == "BOTTOM" and "BOTTOMRIGHT" or "TOPRIGHT"
            elseif config.groupAnchorPoint == "TOP" then
                groupAnchorPoint = config.unitAnchorPoint == "RIGHT" and "TOPRIGHT" or "TOPLEFT"
            elseif config.groupAnchorPoint == "BOTTOM" then
                groupAnchorPoint = config.unitAnchorPoint == "RIGHT" and "BOTTOMRIGHT" or "TOPLEFT"
            end

            group:SetPoint(groupAnchorPoint, self, groupAnchorPoint)
        else
            local groupAnchorPoint, groupRelativeAnchorPoint, xOffset, yOffset
            if config.groupAnchorPoint == "LEFT" then
                groupAnchorPoint = (config.unitAnchorPoint == "BOTTOM" and "BOTTOMLEFT") or (config.unitAnchorPoint == "TOP" and "TOPLEFT") or "LEFT"
                groupRelativeAnchorPoint = (config.unitAnchorPoint == "BOTTOM" and "BOTTOMRIGHT") or (config.unitAnchorPoint == "TOP" and "TOPRIGHT") or "RIGHT"
                xOffset = config.groupSpacing
            elseif config.groupAnchorPoint == "RIGHT" then
                groupAnchorPoint = (config.unitAnchorPoint == "BOTTOM" and "BOTTOMRIGHT") or (config.unitAnchorPoint == "TOP" and "TOPRIGHT") or "RIGHT"
                groupRelativeAnchorPoint = (config.unitAnchorPoint == "BOTTOM" and "BOTTOMLEFT") or (config.unitAnchorPoint == "TOP" and "TOPLEFT") or "LEFT"
                xOffset = -config.groupSpacing
            elseif config.groupAnchorPoint == "TOP" then
                groupAnchorPoint = (config.unitAnchorPoint == "RIGHT" and "TOPRIGHT") or (config.unitAnchorPoint == "LEFT" and "TOPLEFT") or "TOP"
                groupRelativeAnchorPoint = (config.unitAnchorPoint == "RIGHT" and "BOTTOMRIGHT") or (config.unitAnchorPoint == "LEFT" and "BOTTOMLEFT") or "BOTTOM"
                yOffset = -config.groupSpacing
            elseif config.groupAnchorPoint == "BOTTOM" then
                groupAnchorPoint = (config.unitAnchorPoint == "RIGHT" and "BOTTOMRIGHT") or (config.unitAnchorPoint == "LEFT" and "BOTTOMLEFT") or "BOTTOM"
                groupRelativeAnchorPoint = (config.unitAnchorPoint == "RIGHT" and "TOPRIGHT") or (config.unitAnchorPoint == "LEFT" and "TOPLEFT") or "TOP"
                yOffset = config.groupSpacing
            end

            group:SetPoint(groupAnchorPoint, self.groups[i - 1], groupRelativeAnchorPoint, xOffset or 0, yOffset or 0)
        end
    end
end

function UF:CreateRaid()
    self.config = UF.config.raid
    self.defaults = UF.defaults.raid
    self.isGroupUnit = true

    self:InitializeFrame()

    self.Update = UF.UpdateRaid
end

function UF:UpdateRaid()
    if not self then return end

    self:ConfigureFrame()
end

function UF:ForceShowRaid()
    if InCombatLockdown() then return end

    for _, group in ipairs(self.groups) do group:ForceShow() end

    self.forceShow = true
end

function UF:UnforceShowRaid()
    if InCombatLockdown() then return end

    for _, group in ipairs(self.groups) do group:UnforceShow() end

    self.forceShow = false
end
