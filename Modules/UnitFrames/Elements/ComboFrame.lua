local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local CS = R.Modules.CharacterStats
local oUF = ns.oUF or oUF

UF.CreateComboFrame = function(self)
    if (CS.class ~= "ROGUE" and CS.class ~= "DRUID") then
        return
    end

    -- create frame
    self.ComboFrame = CreateFrame("Frame", nil, self)
    self.ComboFrame:SetFrameStrata("LOW")
    self.ComboFrame:SetPoint("TOPLEFT", self.Health, "TOPLEFT", -65, 28)
    self.ComboFrame:SetSize(256, 32)

    self.ComboFrame.Background = self.ComboFrame:CreateTexture("BACKGROUND")
    self.ComboFrame.Background:SetAllPoints()
    self.ComboFrame.Background:SetTexture(R.media.textures.unitFrames.comboFrameBackground)

    self.ComboFrame.ComboPoints = {}
    for i = 1, 5 do
        local scale = i == 5 and 1.5 or 1.2
        local size = 12 * scale
        local comboPoint = CreateFrame("Frame", nil, self)
        comboPoint.Background = comboPoint:CreateTexture("BACKGROUND")
        comboPoint.Background:SetTexture(R.media.textures.unitFrames.comboPoint)
        comboPoint.Background:SetTexCoord(0, 0.375, 0, 1)
        comboPoint.Background:SetSize(12, 16)
        comboPoint.Background:SetPoint("TOPLEFT")
        comboPoint.Background:SetScale(scale)

        comboPoint.Highlight = comboPoint:CreateTexture("ARTWORK")
        comboPoint.Highlight:SetTexture(R.media.textures.unitFrames.comboPoint)
        comboPoint.Highlight:SetTexCoord(0.375, 0.5625, 0, 1)
        comboPoint.Highlight:SetSize(8, 16)
        comboPoint.Highlight:SetPoint("TOPLEFT", 2, 0)
        comboPoint.Highlight:SetScale(scale)

        comboPoint.Shine = comboPoint:CreateTexture("OVERLAY")
        comboPoint.Shine:SetTexture(R.media.textures.unitFrames.comboPoint)
        comboPoint.Shine:SetTexCoord(0.5625, 1, 0, 1)
        comboPoint.Shine:SetBlendMode("ADD")
        comboPoint.Shine:SetSize(14, 16)
        comboPoint.Shine:SetPoint("TOPLEFT", 0, 4)
        comboPoint.Shine:SetScale(scale)

        comboPoint:SetPoint("LEFT", self.ComboFrame, "LEFT", 71 + (i - 1) * 24, 2)
        comboPoint:SetSize(size, size)
        comboPoint:SetFrameLevel(self.ComboFrame:GetFrameLevel() + 1)
        comboPoint:Hide()

        self.ComboFrame.ComboPoints[i] = comboPoint
    end

    self.ComboFrame:Hide()

    self.ComboFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    self.ComboFrame:RegisterEvent("UNIT_POWER_UPDATE")
    self.ComboFrame:SetScript("OnEvent", function(frame, event, ...)
        local comboPoints = GetComboPoints("player", "target")
        if comboPoints > 0 then
            if not self.ComboFrame:IsShown() then
                self.ComboFrame:Show()
                UIFrameFadeIn(self.ComboFrame, COMBOFRAME_FADE_IN);
            end
        else
            self.ComboFrame.ComboPoints[1].Highlight:SetAlpha(0)
            self.ComboFrame.ComboPoints[1].Shine:SetAlpha(0)
            self.ComboFrame:Hide()
        end

        for i = 1, 5 do
            local comboPoint = self.ComboFrame.ComboPoints[i]
            if i <= comboPoints then
                if i > COMBO_FRAME_LAST_NUM_POINTS then
                    local fadeInfo = {}
                    fadeInfo.mode = "IN"
                    fadeInfo.timeToFade = COMBOFRAME_HIGHLIGHT_FADE_IN
                    fadeInfo.finishedFunc = function(frame)
                        local fadeInfo = {}
                        fadeInfo.mode = "IN"
                        fadeInfo.timeToFade = COMBOFRAME_SHINE_FADE_IN
                        fadeInfo.finishedFunc = function(frame)
                            UIFrameFadeOut(frame, COMBOFRAME_SHINE_FADE_OUT)
                        end
                        fadeInfo.finishedArg1 = frame
                        UIFrameFade(frame, fadeInfo)
                    end
                    fadeInfo.finishedArg1 = comboPointShine
                    UIFrameFade(comboPoint.Highlight, fadeInfo)
                end
                comboPoint:Show()
            else
                comboPoint.Highlight:SetAlpha(0)
                comboPoint.Shine:SetAlpha(0)
                comboPoint:Hide()
            end
        end
    end)

    return self.ComboFrame
end

oUF:RegisterMetaFunction("CreateComboFrame", UF.CreateComboFrame)