local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnHeader(name, count, mixin, config, defaultConfig, index)
    if not config.enabled then
        return
    end

    local parent = CreateFrame("Frame", addonName .. name, UIParent)
    parent:SetNormalizedPoint(unpack(config.point))
    parent:SetSize(200, 40)
    parent:Show()
    parent.config = config
    parent.defaults = defaultConfig
    parent.groups = {}

    UF:SetStyle(name, frame, mixin, config, defaultConfig, isGroupUnit)
    for i = 1, count do
        local group = oUF:SpawnHeader(addonName .. name .. "Header" .. (count > 1 and i or ""), nil, config.visibility, "showPlayer", config.showPlayer, "showSolo", config.showSolo, "showParty",
                                      config.showParty, "showRaid", config.showRaid, "point", config.unitAnchorPoint, "groupFilter", index or (count > 1 and tostring(i)) or nil,
                                      "oUF-initialConfigFunction", ([[
                self:SetWidth(%d)
                self:SetHeight(%d)
                self:GetParent():SetScale(%f)
            ]]):format(config.size[1], config.size[2], config.scale))

        group:SetFrameStrata("LOW")
        group:CreateFader(config.fader)
        group.config = config
        _G.Mixin(group, UnitFrameHeaderMixin)

        parent.groups[i] = group
    end

    _G.Mixin(parent, UnitFrameHeaderParentMixin)
    parent:Update()

    parent:CreateMover(name, defaultConfig.point)

    return parent
end

UnitFrameHeaderParentMixin = {}

function UnitFrameHeaderParentMixin:Update()
    local config = self.config
    self:ClearAllPoints()
    self:SetNormalizedPoint(unpack(config.point))

    local numGroups = #self.groups
    local groupWidth = (config.unitAnchorPoint == "LEFT" or config.unitAnchorPoint == "RIGHT") and (config.size[1] * 5 + config.unitSpacing * 4) or (config.size[1])
    local groupHeight = (config.unitAnchorPoint == "TOP" or config.unitAnchorPoint == "BOTTOM") and (config.size[2] * 5 + config.unitSpacing * 4) or (config.size[2])
    local width = (config.groupAnchorPoint == "LEFT" or config.groupAnchorPoint == "RIGHT") and (numGroups * groupWidth + (numGroups - 1) * config.groupSpacing) or groupWidth
    local height = (config.groupAnchorPoint == "TOP" or config.groupAnchorPoint == "BOTTOM") and (numGroups * groupHeight + (numGroups - 1) * config.groupSpacing) or groupHeight
    self:SetSize(width, height)
    if self.Mover then
        self.Mover:SetSize(width, height)
    end

    for i, group in ipairs(self.groups) do
        for j = 1, group:GetNumChildren() do
            local child = group:GetAttribute("child" .. j)
            if child.Update then
                child:Update()
            end
        end

        group:SetAttribute("point", config.unitAnchorPoint)
        if config.unitAnchorPoint == "LEFT" or config.unitAnchorPoint == "RIGHT" then
            group:SetAttribute("xOffset", config.unitSpacing * (config.unitAnchorPoint == "RIGHT" and -1 or 1))
            group:SetAttribute("yOffset", 0)
        else
            group:SetAttribute("xOffset", 0)
            group:SetAttribute("yOffset", config.unitSpacing * (config.unitAnchorPoint == "TOP" and -1 or 1))
        end

        group:SetAttribute("columnSpacing", config.unitSpacing)
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

        if numGroups == 1 then
            group:UpdateVisibility((group.isForced and "show") or (config.showRaid and "party,raid") or "party")
        else
            group:UpdateVisibility((group.isForced and "show") or config.visibility or "show")
        end

        group:SetAttribute("showPlayer", config.showPlayer)
        group:SetAttribute("showSolo", config.showSolo)
        group:SetAttribute("showParty", config.showParty)
        group:SetAttribute("showRaid", config.showRaid)

        group:ClearAllPoints()
        if i == 1 then
            local groupAnchorPoint
            if config.groupAnchorPoint == "LEFT" then
                groupAnchorPoint = config.unitAnchorPoint == "BOTTOM" and "BOTTOMLEFT" or "TOPLEFT"
            elseif config.groupAnchorPoint == "RIGHT" then
                groupAnchorPoint = config.unitAnchorPoint == "BOTTOM" and "BOTTOMRIGHT" or "TOPRIGHT"
            elseif config.groupAnchorPoint == "TOP" then
                groupAnchorPoint = config.unitAnchorPoint == "RIGHT" and "TOPRIGHT" or "TOPLEFT"
            elseif config.groupAnchorPoint == "BOTTOM" then
                groupAnchorPoint = config.unitAnchorPoint == "RIGHT" and "BOTTOMRIGHT" or "BOTTOMLEFT"
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

function UnitFrameHeaderParentMixin:ForceShow()
    if self.isForced then
        return
    end

    self.isForced = true

    for _, group in ipairs(self.groups) do
        group.isForced = true
        group:SetAttribute("startingIndex", -4)

        for i = 1, group:GetNumChildren() do
            group:GetAttribute("child" .. i):ForceShow(child)
        end
    end

    self:Update()
end

function UnitFrameHeaderParentMixin:UnforceShow()
    if not self.isForced then
        return
    end

    self.isForced = nil

    for _, group in ipairs(self.groups) do
        group.isForced = nil
        group:SetAttribute("startingIndex", 1)

        for i = 1, group:GetNumChildren() do
            group:GetAttribute("child" .. i):UnforceShow()
        end
    end

    self:Update()
end

UnitFrameHeaderMixin = {}

local CONDITIONS = {
    raid40 = "[@raid26,exists] show;",
    raid25 = "[@raid11,exists] show;",
    raid10 = "[@raid6,exists] show;",
    raid = "[group:raid] show;",
    party = "[group:party,nogroup:raid] show;",
    solo = "[@player,exists,nogroup:party] show;",
    show = "show;"
}

local function GetCondition(...)
    local cond = ""

    local short, condition
    for i = 1, select("#", ...) do
        short = select(i, ...)

        condition = CONDITIONS[short]
        if condition then
            cond = cond .. condition
        end
    end

    return cond .. "hide"
end

function UnitFrameHeaderMixin:UpdateVisibility(visibility)
    local type, list = string.split(" ", visibility, 2)
    if list and type == "custom" then
        RegisterAttributeDriver(self, "state-visibility", list)
        self.visibility = list
    else
        local condition = GetCondition(string.split(",", visibility))
        RegisterAttributeDriver(self, "state-visibility", condition)
        self.visibility = condition
    end
end
