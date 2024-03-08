local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:StyleQuestLogFrame()
    if not R.isClassic or not S.config.questLog.enabled then
        return
    end
    UIPanelWindows["QuestLogFrame"] = { area = "override", pushable = 1, xoffset = -16, yoffset = 12, bottomClampOverride = 140 + 12, width = 682, height = 447, whileDead = 1 }

    QuestLogFrame:SetSize(682, 447)

    QuestLogTitleText:ClearAllPoints()
    QuestLogTitleText:SetPoint("TOP", QuestLogFrame, "TOP", 0, -18)

    QuestLogListScrollFrame:ClearAllPoints()
    QuestLogListScrollFrame:SetPoint("TOPLEFT", QuestLogFrame, "TOPLEFT", 25, -75)
    QuestLogListScrollFrame:SetSize(295, 336)

    QuestLogDetailScrollFrame:ClearAllPoints()
    QuestLogDetailScrollFrame:SetPoint("TOPLEFT", QuestLogFrame, "TOPLEFT", 352, -74)
    QuestLogDetailScrollFrame:SetSize(298, 336)

    local oldQuestsDisplayed = QUESTS_DISPLAYED
    _G.QUESTS_DISPLAYED = _G.QUESTS_DISPLAYED + 13
    for i = oldQuestsDisplayed + 1, QUESTS_DISPLAYED do
        local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["QuestLogTitle" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    local regions = { QuestLogFrame:GetRegions() }

    regions[3]:SetTexture(S.config.questLog.style == S.Styles.Modern and R.media.textures.frames.modern.dualPaneFrameWithBook_Left or R.media.textures.frames.vanilla.dualPaneFrameWithBook_Left)
    regions[3]:SetTexCoord(0, 1, 0, 1)
    regions[3]:SetSize(512, 512)
    regions[4]:SetTexture(S.config.questLog.style == S.Styles.Modern and R.media.textures.frames.modern.dualPaneFrameWithBook_Right or R.media.textures.frames.vanilla.dualPaneFrameWithBook_Right)
    regions[4]:SetTexCoord(0, 1, 0, 1)
    regions[4]:SetSize(256, 512)
    regions[4]:ClearAllPoints()
    regions[4]:SetPoint("TOPLEFT", 512, 0)
    regions[5]:Hide()
    regions[6]:Hide()

    QuestLogFrameCloseButton:ClearAllPoints()
    QuestLogFrameCloseButton:SetPoint("TOPRIGHT", 2, -8)

    QuestLogFrameAbandonButton:SetSize(110, 21)
    QuestLogFrameAbandonButton:SetText(ABANDON_QUEST_ABBREV)
    QuestLogFrameAbandonButton:ClearAllPoints()
    QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 17, 14)

    QuestFramePushQuestButton:SetSize(100, 21)
    QuestFramePushQuestButton:SetText(SHARE_QUEST_ABBREV)
    QuestFramePushQuestButton:ClearAllPoints()
    QuestFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", -3, 0)

    CreateFrame("Button", "QuestLogFrameTrackButton", QuestLogFrame, "UIPanelButtonTemplate")
    QuestLogFrameTrackButton:SetText(TRACK_QUEST_ABBREV)
    QuestLogFrameTrackButton:SetPoint("LEFT", QuestFramePushQuestButton, "RIGHT", -3, 0)
    QuestLogFrameTrackButton:SetSize(100, 21)
    QuestLogFrameTrackButton:SetScript("OnClick", function(self)
        local questIndex = GetQuestLogSelection()
        
        if IsQuestWatched(questIndex) then
            RemoveQuestWatch(questIndex)
        else
            if (GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS) then
                UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0)
                return
            end
            AddQuestWatch(questIndex)
        end

        QuestWatch_Update()
        QuestLog_Update()
    end)

    QuestFrameExitButton:SetSize(80, 22)
    QuestFrameExitButton:SetText(CLOSE)
    QuestFrameExitButton:ClearAllPoints()
    QuestFrameExitButton:SetPoint("BOTTOMRIGHT", QuestLogFrame, "BOTTOMRIGHT", -7, 14)

    QuestLogTrack:Hide()
end
