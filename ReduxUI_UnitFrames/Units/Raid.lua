local AddonName, AddonTable = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnRaid()
    local config = R.config.db.profile.modules.unitFrames.raid
    local default = R.config.defaults.profile.modules.unitFrames.raid

    if config.enabled then
        oUF:RegisterStyle(AddonName .. "Raid", UF.CreateRaid)
        oUF:SetActiveStyle(AddonName .. "Raid")
        for i = 1, NUM_RAID_GROUPS do
            -- config needs to provide 8 point tables, one for each raid group
            local raidGroup = oUF:SpawnHeader(AddonName .. "RaidHeader" .. i, nil, nil, "showPlayer", config.showPlayer, "showSolo", config.showSolo, "showParty", config.showParty,
                                              "showRaid", config.showRaid, "point", config.point, "xOffset", config.xOffset, "yOffset", config.yOffset, "groupFilter", tostring(i),
                                              "unitsPerColumn", 5, "oUF-initialConfigFunction", ([[
                    self:SetWidth(%d)
                    self:SetHeight(%d)
                    self:GetParent():SetScale(%f)
                ]]):format(config.size[1], config.size[2], config.scale))
            raidGroup:SetPoint(unpack(config.points[i]))
            raidGroup:Show()
            raidGroup.cfg = config
            UF.frames["raidGroup" .. i] = raidGroup

            if config.fader and config.fader.enabled then
                R:CreateFrameFader(raidGroup, config.fader)
            end

            R:CreateDragFrame(raidGroup, "Raid Group " .. i, default.points[i], 200, 40)
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

    -- aura highlight
    UF.CreateAuraHighlight(self)
end

function UF:UpdateRaid()
end
