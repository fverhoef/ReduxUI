local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateVanillaArtFrame()
    AB.VanillaArtFrame = CreateFrame("Frame", addonName .. "VanillaArtFrame", UIParent, "VanillaArtFrameTemplate")
end

AB.VanillaArtFrameMixin = {}
ReduxVanillaArtFrameMixin = AB.VanillaArtFrameMixin

function AB.VanillaArtFrameMixin:OnLoad()
    if R.isRetail then
        StatusTrackingBarManager:SetParent(self)
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "ReputationStatusBarTemplate");
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "HonorStatusBarTemplate");
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "ArtifactStatusBarTemplate");
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "ExpStatusBarTemplate");
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "AzeriteBarTemplate");
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_LEVEL_UP")
    self:RegisterEvent("PLAYER_UPDATE_RESTING")
    self:RegisterEvent("PLAYER_XP_UPDATE")
    self:RegisterEvent("UPDATE_EXHAUSTION")
    if not R.isRetail then
        AB:SecureHook("MainMenuBar_UpdateExperienceBars", function()
            self:Update()
        end)
    end

    self.config = AB.config.actionBar1.vanillaArt

    self:Update()
end

function AB.VanillaArtFrameMixin:OnEvent(event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        if self.needsUpdate then
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
            self:Update()
        end
    else
        self:UpdateRested()
    end
end

function AB.VanillaArtFrameMixin:OnStatusBarsUpdated()
    self:Update()
end

function AB.VanillaArtFrameMixin:GetNumberOfVisibleTrackingBars()
    if R.isRetail then
        return StatusTrackingBarManager:GetNumberVisibleBars()
    else
        return (self.ExperienceBar:IsShown() and 1 or 0) + (self.ReputationBar:IsShown() and 1 or 0)
    end
end

function AB.VanillaArtFrameMixin:UpdateRested()
    if self.ExperienceBar:IsShown() then
        local exhaustionThreshold = GetXPExhaustion()

        if not exhaustionThreshold or exhaustionThreshold <= 0 then
            self.ExperienceBar.RestedTick:Hide()
            self.ExperienceBar.RestedFillBar:Hide()
        else
            local exhaustionTickSet = math.max(((UnitXP("player") + exhaustionThreshold) / UnitXPMax("player")) * self.ExperienceBar:GetWidth(), 0)
            if exhaustionTickSet > self.ExperienceBar:GetWidth() then
                self.ExperienceBar.RestedTick:Hide()
                self.ExperienceBar.RestedFillBar:Hide()
            else
                self.ExperienceBar.RestedTick:Show()
                self.ExperienceBar.RestedTick:SetPoint("CENTER", self.ExperienceBar, "LEFT", exhaustionTickSet, 0)
                self.ExperienceBar.RestedFillBar:Show()
                self.ExperienceBar.RestedFillBar:SetPoint("TOPRIGHT", exhaustionTickSet, 0)
            end
        end
    end
end

function AB.VanillaArtFrameMixin:Update()
    if InCombatLockdown() then
        self.needsUpdate = true
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    if not self.config.enabled then
        self:Hide()
        return
    else
        self:Show()
    end

    if not R.isRetail then
        local watchedFactionName = GetWatchedFactionInfo()
        local showXP = UnitLevel("player") < GetMaxPlayerLevel()
        local showRep = watchedFactionName ~= nil

        local expMin, expMax = MainMenuExpBar:GetMinMaxValues()
        local expValue = MainMenuExpBar:GetValue()
        local expText = string.format("%s %i / %i", XP, expValue, expMax)
        self.ExperienceBar:SetStatusBarTexture(AB.config.statusbars.experience)
        self.ExperienceBar:SetStatusBarColor(unpack({ MainMenuExpBar:GetStatusBarColor() }))
        self.ExperienceBar:SetMinMaxValues(expMin, expMax)
        self.ExperienceBar:SetValue(expValue)
        self.ExperienceBar:SetShown(showXP)
        self.ExperienceBar.OverlayFrame.Text:SetText(expText)
        self.ExperienceBar.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

        self.ExperienceBar:SetHeight(11)
        self.ExperienceBar:SetPoint("BOTTOMLEFT", 0, showRep and -19 or -13)
        self.ExperienceBar:SetPoint("BOTTOMRIGHT", 0, showRep and -19 or -13)

        self:UpdateRested()

        local repMin, repMax = ReputationWatchBar.StatusBar:GetMinMaxValues()
        local repValue = ReputationWatchBar.StatusBar:GetValue()
        local repText = string.format("%s %i / %i", watchedFactionName or "None", repValue, repMax)
        self.ReputationBar:SetStatusBarTexture(AB.config.statusbars.reputation)
        self.ReputationBar:SetStatusBarColor(unpack({ ReputationWatchBar.StatusBar:GetStatusBarColor() }))
        self.ReputationBar:SetMinMaxValues(repMin, repMax)
        self.ReputationBar:SetValue(repValue)
        self.ReputationBar:SetShown(showRep)
        self.ReputationBar.OverlayFrame.Text:SetText(repText)
        self.ReputationBar.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

        self.ReputationBar:SetHeight(showXP and 9 or 11)
        self.ReputationBar:SetPoint("BOTTOMLEFT", 0, showXP and -8 or -13)
        self.ReputationBar:SetPoint("BOTTOMRIGHT", 0, showXP and -8 or -13)
    end

    local isLarge = not self.config.stackBottomBars and AB.config.actionBar4.enabled
    local numBars = self:GetNumberOfVisibleTrackingBars()
    local isDouble = numBars >= 2

    self:SetSize(isLarge and 804 or 550, 64)
    self.Background2:SetShown(isLarge)

    if numBars >= 2 then
        self:SetPoint("BOTTOM", 0, 19)
        self.LeftEndCap:SetPoint("BOTTOMLEFT", -97, -19)
        self.RightEndCap:SetPoint("BOTTOMRIGHT", 97, -19)
    elseif numBars == 1 then
        self:SetPoint("BOTTOM", 0, 14)
        self.LeftEndCap:SetPoint("BOTTOMLEFT", -97, -14)
        self.RightEndCap:SetPoint("BOTTOMRIGHT", 97, -14)
    else
        self:SetPoint("BOTTOM", 0, 0)
        self.LeftEndCap:SetPoint("BOTTOMLEFT", -97, 0)
        self.RightEndCap:SetPoint("BOTTOMRIGHT", 97, 0)
    end

    self.TrackingBarLarge:SetHeight(isDouble and 10 or 14)
    self.TrackingBarLargeUpper:SetHeight(isDouble and 10 or 14)
    self.TrackingBarSmall:SetHeight(isDouble and 10 or 14)
    self.TrackingBarSmallUpper:SetHeight(isDouble and 10 or 14)

    self.TrackingBarLarge:SetShown(numBars > 0 and isLarge)
    self.TrackingBarLargeUpper:SetShown(numBars > 0 and isDouble and isLarge)
    self.TrackingBarSmall:SetShown(numBars > 0 and not isLarge)
    self.TrackingBarSmallUpper:SetShown(numBars > 0 and isDouble and not isLarge)

    if R.isRetail then
        local visibleBars = {}
        for i, bar in ipairs(StatusTrackingBarManager.bars) do
            if bar:ShouldBeVisible() then
                table.insert(visibleBars, bar)
            end
        end
        table.sort(visibleBars, function(left, right)
            return left:GetPriority() < right:GetPriority()
        end);

        local width = self:GetWidth()
        if (#visibleBars > 1) then
            StatusTrackingBarManager:LayoutBar(visibleBars[2], width, false, true)
            StatusTrackingBarManager:LayoutBar(visibleBars[1], width, true, true)
        elseif (#visibleBars == 1) then
            StatusTrackingBarManager:LayoutBar(visibleBars[1], width, true, false)
        end

        StatusTrackingBarManager.SingleBarSmall:Hide()
        StatusTrackingBarManager.SingleBarLarge:Hide()
        StatusTrackingBarManager.SingleBarSmallUpper:Hide()
        StatusTrackingBarManager.SingleBarLargeUpper:Hide()
    end
     
    for i, button in ipairs(AB.bars[1].buttons) do
        button:SetSize(36, 36)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 8, 4)
        else
            button:SetPoint("LEFT", AB.bars[1].buttons[i - 1], "RIGHT", 6, 0)
        end
    end
    AB.bars[1].Backdrop:SetShown(false)
    AB.bars[1].Border:SetShown(false)
    AB.bars[1].Shadow:SetShown(false)
    AB.bars[1].Mover:Lock(true)

    AB.pageUpButton:ClearAllPoints()
    AB.pageUpButton:SetPoint("LEFT", AB.bars[1].buttons[12], "RIGHT", -1, 8.5)
    AB.pageUpButton.style = AB.Styles.Vanilla
    AB.pageUpButton:Update()

    AB.pageDownButton:ClearAllPoints()
    AB.pageDownButton:SetPoint("LEFT", AB.bars[1].buttons[12], "RIGHT", -1, -9.5)
    AB.pageDownButton.style = AB.Styles.Vanilla
    AB.pageDownButton:Update()

    AB.pageNumber:ClearAllPoints()
    AB.pageNumber:SetPoint("LEFT", self, "LEFT", 530, -9)
    AB.pageNumber:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    AB.pageNumber:SetTextColor(1, 0.82, 0)

    for i, button in ipairs(AB.bars[2].buttons) do
        button:SetSize(36, 36)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("BOTTOMLEFT", AB.bars[1].buttons[1], "TOPLEFT", 0, 10)
        else
            button:SetPoint("LEFT", AB.bars[2].buttons[i - 1], "RIGHT", 6, 0)
        end
    end
    AB.bars[2].Backdrop:SetShown(false)
    AB.bars[2].Border:SetShown(false)
    AB.bars[2].Shadow:SetShown(false)
    AB.bars[2].Mover:Lock(true)

    for i, button in ipairs(AB.bars[3].buttons) do
        button:SetSize(36, 36)
        button:ClearAllPoints()

        if self.config.stackBottomBars then
            if i == 1 then
                button:SetPoint("BOTTOMLEFT", AB.bars[2].buttons[1], "TOPLEFT", 0, 5)
            else
                button:SetPoint("LEFT", AB.bars[3].buttons[i - 1], "RIGHT", 6, 0)
            end
        else
            if i == 1 then
                button:SetPoint("BOTTOMLEFT", AB.bars[1].buttons[12], "BOTTOMRIGHT", 45, 0)
            elseif i == 7 then
                button:SetPoint("BOTTOMLEFT", AB.bars[3].buttons[1], "TOPLEFT", 0, 10)
            else
                button:SetPoint("LEFT", AB.bars[3].buttons[i - 1], "RIGHT", 6, 0)
            end
        end
    end
    AB.bars[3].Backdrop:SetShown(false)
    AB.bars[3].Border:SetShown(false)
    AB.bars[3].Shadow:SetShown(false)
    AB.bars[3].Mover:Lock(true)

    for i, button in ipairs(AB.petBar.buttons) do
        button:SetSize(32, 32)
        button:ClearAllPoints()

        if i == 1 then
            button:SetPoint("BOTTOMLEFT", self.config.stackBottomBars and AB.bars[3].buttons[1] or AB.bars[2].buttons[1], "TOPLEFT", 18, 5)
        else
            button:SetPoint("LEFT", AB.petBar.buttons[i - 1], "RIGHT", 6, 0)
        end
    end
    AB.petBar.Backdrop:SetShown(false)
    AB.petBar.Border:SetShown(false)
    AB.petBar.Shadow:SetShown(false)
    AB.petBar.Mover:Lock(true)

    for i, button in ipairs(AB.stanceBar.buttons) do
        button:SetSize(32, 32)
        button:ClearAllPoints()

        if i == 1 then
            button:SetPoint("BOTTOMLEFT", self.config.stackBottomBars and AB.bars[3].buttons[1] or AB.bars[2].buttons[1], "TOPLEFT", 18, 5)
        else
            button:SetPoint("LEFT", AB.stanceBar.buttons[i - 1], "RIGHT", 6, 0)
        end
    end
    AB.stanceBar.Backdrop:SetShown(false)
    AB.stanceBar.Border:SetShown(false)
    AB.stanceBar.Shadow:SetShown(false)
    AB.stanceBar.Mover:Lock(true)

    if AB.totemBar then
        AB.totemBar:ClearAllPoints()
        AB.totemBar:SetPoint("BOTTOMLEFT", self.config.stackBottomBars and AB.bars[3].buttons[1] or AB.bars[2].buttons[1], "TOPLEFT", 18, 5)
        AB.totemBar.Backdrop:SetShown(false)
        AB.totemBar.Border:SetShown(false)
        AB.totemBar.Shadow:SetShown(false)
        AB.totemBar.Mover:Lock(true)
    end
end

AB.VanillaArtFrameExperienceBarMixin = {}
ReduxVanillaArtFrameExperienceBarMixin = AB.VanillaArtFrameExperienceBarMixin

function AB.VanillaArtFrameExperienceBarMixin:OnEnter()
    self.OverlayFrame.Text:Show()
end

function AB.VanillaArtFrameExperienceBarMixin:OnLeave()
    self.OverlayFrame.Text:Hide()
end

AB.VanillaArtFrameReputationBarMixin = {}
ReduxVanillaArtFrameReputationBarMixin = AB.VanillaArtFrameReputationBarMixin

function AB.VanillaArtFrameReputationBarMixin:OnEnter()
    self.OverlayFrame.Text:Show()
end

function AB.VanillaArtFrameReputationBarMixin:OnLeave()
    self.OverlayFrame.Text:Hide()
end
