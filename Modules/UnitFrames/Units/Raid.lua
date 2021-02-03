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
            local group = UF:SpawnHeader("Raid", i, UF.CreateRaid, config, default)
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
            -- child:ClearAllPoints()
            UF:UpdateRaid(child)
        end

        group:SetAttribute("point", group.cfg.unitAnchorPoint)
        group:SetAttribute("xOffset", group.cfg.xOffset)
        group:SetAttribute("yOffset", group.cfg.yOffset)
        group:SetAttribute("columnSpacing", group.cfg.columnSpacing)
        group:SetAttribute("columnAnchorPoint", group.cfg.columnAnchorPoint)
        group:SetAttribute("maxColumns", group.cfg.maxColumns)
        group:SetAttribute("unitsPerColumn", group.cfg.unitsPerColumn)
        group:SetAttribute("groupBy", group.cfg.groupBy)
        group:SetAttribute("groupingOrder", group.cfg.groupingOrder)
        group:SetAttribute("sortMethod", group.cfg.sortMethod)
        group:SetAttribute("sortDir", group.cfg.sortDir)
        group:SetAttribute("showPlayer", group.cfg.showPlayer)

        if not group.isForced then
            if not group.initialized then
                group:SetAttribute("startingIndex", -4)
                group:Show()
                group.initialized = true
            end
            group:SetAttribute("startingIndex", 1)
        end

        if i == 1 then
            group:SetPoint("TOPLEFT", UF.frames.raidHeader, "TOPLEFT")
        else
            group:SetPoint("TOPLEFT", UF.frames.raidHeader.groups[i - 1], "BOTTOMLEFT")
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

    -- border
    if self.cfg.border.enabled then
        self:CreateBorder(self.cfg.border.size)
        self:CreateShadow()
    end

    -- health
    UF.CreateHealth(self)
    self.Health:SetSize(width, height)
    self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", self.cfg.border.enabled and 2 or 0, 0)
    self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", self.cfg.border.enabled and -2 or 0, 0)
    self.Health.Value:ClearAllPoints()
    self.Health.Value:SetPoint("TOP", self, "TOP", 0, -20)

    -- power
    if self.cfg.power.enabled then
        UF.CreatePower(self)
        self.Power:SetHeight(self.cfg.power.size[2])
        self.Power.Value:Hide()

        self.Health:SetHeight(height - self.cfg.power.size[2])
    end

    -- name
    UF.CreateName(self, 12)
    self.Name:SetPoint("TOP", self, "TOP", 0, -8)

    -- leader
    UF.CreateLeaderIndicator(self)
    self.LeaderIndicator:SetSize(14, 14)
    self.LeaderIndicator:ClearAllPoints()
    self.LeaderIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 5)

    -- assistant
    UF.CreateAssistantIndicator(self)
    self.AssistantIndicator:ClearAllPoints()
    self.AssistantIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 5)

    -- master loot
    UF.CreateMasterLooterIndicator(self)
    self.MasterLooterIndicator:ClearAllPoints()
    self.MasterLooterIndicator:SetPoint("TOPLEFT", self, "TOPLEFT", 10, 5)

    -- raid role
    UF.CreateRaidRoleIndicator(self)
    self.RaidRoleIndicator:SetSize(14, 14)
    self.RaidRoleIndicator:ClearAllPoints()
    self.RaidRoleIndicator:SetPoint("TOPRIGHT", self, "TOPRIGHT", 6, 5)

    -- raid target
    UF.CreateRaidTargetIndicator(self)
    self.RaidTargetIndicator:SetSize(20, 20)
    self.RaidTargetIndicator:ClearAllPoints()
    self.RaidTargetIndicator:SetPoint("TOP", self, "TOP", 0, 10)

    -- ready check
    UF.CreateReadyCheckIndicator(self)
    self.ReadyCheckIndicator:SetSize(24, 24)
    self.ReadyCheckIndicator:ClearAllPoints()
    self.ReadyCheckIndicator:SetPoint("LEFT", self, "RIGHT", -12, 0)

    -- resurrect
    UF.CreateResurrectIndicator(self)

    -- range check
    self.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
        Update = function(self, inRange, checkedRange, connected)
            if self.fader and not self:IsShown() then
                R:StartFadeIn(self, {
                    fadeInAlpha = self.Range[inRange and "insideAlpha" or "outsideAlpha"],
                    fadeInDuration = self.faderConfig.fadeInDuration,
                    fadeInSmooth = self.faderConfig.fadeInSmooth
                })
            else
                self:SetAlpha(self.Range[inRange and "insideAlpha" or "outsideAlpha"])
            end
        end
    }

    -- aura highlight
    UF.CreateAuraHighlight(self)
end

function UF:UpdateRaid(frame)
    if not frame then
        return
    end

end
