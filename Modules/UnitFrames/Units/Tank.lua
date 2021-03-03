local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTankHeader()
    local config = UF.config.tank
    local default = UF.config.tank

    if config.enabled then
        local parent = CreateFrame("Frame", addonName .. "Tank")
        parent:Point(unpack(config.point))
        parent:SetSize(200, 40)
        parent:Show()
        parent.config = config
        parent.defaults = default

        local group = UF:SpawnHeader("Tank", UF.CreateTank, config, default, true, "MAINTANK")
        parent.group = group

        R:CreateDragFrame(parent, "Tank", default.point, 200, 40)

        parent.Update = UF.UpdateTankHeader
        parent.ForceShow = UF.ForceShowTank
        parent.UnforceShow = UF.UnforceShowTank

        return parent
    end
end

function UF:UpdateTankHeader()
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

function UF:CreateTank()
    self.config = UF.config.tank
    self.defaults = UF.defaults.tank
    self.isGroupUnit = true

    UF:SetupFrame(self)

    self.Update = UF.UpdateTank
end

function UF:UpdateTank()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end

function UF:ForceShowTank()
    UF:ForceShowHeader(self.group)
    UF:UpdateTankHeader()
    self.forceShow = true
end

function UF:UnforceShowTank()
    UF:UnforceShowHeader(self.group)
    UF:UpdateTankHeader()
    self.forceShow = false
end