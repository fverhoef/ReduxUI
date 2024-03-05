local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateModernArt()
    local bar = AB.bars[1]
    bar.ArtLeft = bar:CreateTexture("$parentArtLeft", "BACKGROUND")
    bar.ArtLeft:SetTexture(R.media.textures.actionBars.modern.actionBar)
    bar.ArtLeft:SetSize(88, 79)
    bar.ArtLeft:SetPoint("RIGHT", bar, "LEFT", 5, 5)

    bar.ArtRight = bar:CreateTexture("$parentArtRight", "BACKGROUND")
    bar.ArtRight:SetTexture(R.media.textures.actionBars.modern.actionBar)
    bar.ArtRight:SetSize(88, 79)
    bar.ArtRight:SetPoint("LEFT", bar, "RIGHT", -5, 5)

    if R.PlayerInfo.faction == "Alliance" then
        bar.ArtLeft:SetTexCoord(0 / 512, 351 / 512, 208 / 2048, 525 / 2048)
        bar.ArtRight:SetTexCoord(0 / 512, 351 / 512, 555 / 2048, 861 / 2048)
    else
        bar.ArtLeft:SetTexCoord(0 / 512, 351 / 512, 882 / 2048, 1197 / 2048)
        bar.ArtRight:SetTexCoord(0 / 512, 351 / 512, 1218 / 2048, 1533 / 2048)
    end
end

function AB:CreateVanillaArtFrame()
    AB.VanillaArtFrame = CreateFrame("Frame", addonName .. "VanillaArtFrame", UIParent, "VanillaArtFrameTemplate")
end

AB.VanillaArtFrameMixin = {}
ReduxVanillaArtFrameMixin = AB.VanillaArtFrameMixin

function AB.VanillaArtFrameMixin:OnLoad()
    self.config = AB.config.actionBar1.vanillaArt
    self:Update()
end

function AB.VanillaArtFrameMixin:OnEvent(event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        if self.needsUpdate then
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
            self:Update()
        end
    end
end

function AB.VanillaArtFrameMixin:OnStatusBarsUpdated()
    self:Update()
end

function AB.VanillaArtFrameMixin:GetNumberOfVisibleTrackingBars()
    if R.isRetail then
        return StatusTrackingBarManager:GetNumberVisibleBars()
    else
        return (AB.experienceBar:IsShown() and 1 or 0) + (AB.statusTrackingBar:IsShown() and 1 or 0)
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
        AB.experienceBar:SetHeight(11)
        AB.experienceBar:ClearAllPoints()
        AB.experienceBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, AB.statusTrackingBar:IsShown() and -19 or -13)
        AB.experienceBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, AB.statusTrackingBar:IsShown() and -19 or -13)

        AB.statusTrackingBar:SetHeight(AB.experienceBar:IsShown() and 9 or 11)
        AB.statusTrackingBar:ClearAllPoints()
        AB.statusTrackingBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, AB.experienceBar:IsShown() and -8 or -13)
        AB.statusTrackingBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, AB.experienceBar:IsShown() and -8 or -13)
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

    AB.bars[1].ArtLeft:Hide()
    AB.bars[1].ArtRight:Hide()

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
