local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

-- Credit: Leatrix_Plus

function S:StyleQuestLogFrame()
    if R.isRetail or not S.config.questLog.enabled then return end

    local width, height = 714, 487

    UIPanelWindows["QuestLogFrame"] = {
        area = "override",
        pushable = 0,
        xoffset = -16,
        yoffset = 12,
        bottomClampOverride = 140 + 12,
        width = width,
        height = height,
        whileDead = 1
    }

    QuestLogFrame:SetWidth(width)
    QuestLogFrame:SetHeight(height)

    QuestLogTitleText:ClearAllPoints()
    QuestLogTitleText:SetPoint("TOP", QuestLogFrame, "TOP", 0, -18)

    QuestLogDetailScrollFrame:ClearAllPoints()
    QuestLogDetailScrollFrame:SetPoint("TOPLEFT", QuestLogListScrollFrame, "TOPRIGHT", 31, 1)
    QuestLogDetailScrollFrame:SetHeight(336)

    QuestLogListScrollFrame:SetHeight(336)

    local oldQuestsDisplayed = QUESTS_DISPLAYED
    _G.QUESTS_DISPLAYED = _G.QUESTS_DISPLAYED + 16
    for i = oldQuestsDisplayed + 1, QUESTS_DISPLAYED do
        local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["QuestLogTitle" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    local regions = {QuestLogFrame:GetRegions()}

    regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
    regions[3]:SetSize(512, 512)

    regions[4]:ClearAllPoints()
    regions[4]:SetPoint("TOPLEFT", regions[3], "TOPRIGHT", 0, 0)
    regions[4]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
    regions[4]:SetSize(256, 512)

    regions[5]:Hide()
    regions[6]:Hide()

    QuestLogFrameAbandonButton:SetSize(110, 21)
    QuestLogFrameAbandonButton:SetText(ABANDON_QUEST_ABBREV)
    QuestLogFrameAbandonButton:ClearAllPoints()
    QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 17, 54)

    QuestFramePushQuestButton:SetSize(100, 21)
    QuestFramePushQuestButton:SetText(SHARE_QUEST_ABBREV)
    QuestFramePushQuestButton:ClearAllPoints()
    QuestFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", -3, 0)

    local logMapButton = CreateFrame("Button", nil, QuestLogFrame, "UIPanelButtonTemplate")
    logMapButton:SetText(SHOW_MAP)
    logMapButton:ClearAllPoints()
    logMapButton:SetPoint("LEFT", QuestFramePushQuestButton, "RIGHT", -3, 0)
    logMapButton:SetSize(100, 21)
    logMapButton:SetScript("OnClick", ToggleWorldMap)

    QuestFrameExitButton:SetSize(80, 22)
    QuestFrameExitButton:SetText(CLOSE)
    QuestFrameExitButton:ClearAllPoints()
    QuestFrameExitButton:SetPoint("BOTTOMRIGHT", QuestLogFrame, "BOTTOMRIGHT", -42, 54)

    QuestLogNoQuestsText:ClearAllPoints()
    QuestLogNoQuestsText:SetPoint("TOP", QuestLogListScrollFrame, 0, -50)
    hooksecurefunc(EmptyQuestLogFrame, "Show", function()
        EmptyQuestLogFrame:ClearAllPoints()
        EmptyQuestLogFrame:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 20, -76)
        EmptyQuestLogFrame:SetHeight(487)
    end)

    S:SecureHook("QuestLog_Update", function()
        local numEntries, numQuests = GetNumQuestLogEntries()
        if numEntries == 0 then
            return
        end
        for i = 1, QUESTS_DISPLAYED do
            local questIndex = i + FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
            if questIndex <= numEntries then
                local questLogTitle = _G["QuestLogTitle" .. i]
                local questCheck = _G["QuestLogTitle" .. i .. "Check"]
                local title, level, suggestedGroup, isHeader = GetQuestLogTitle(questIndex)
                if title and level and not isHeader then
                    local questTextFormatted = string.format("  [%d] %s", level, title)
                    questLogTitle:SetText(questTextFormatted)
                    QuestLogDummyText:SetText(questTextFormatted)
                end

                local checkText = _G["QuestLogTitle" .. i .. "NormalText"]
                if checkText then
                    local checkPos = checkText:GetStringWidth()
                    if checkPos then
                        if checkPos <= 210 then
                            questCheck:SetPoint("LEFT", questLogTitle, "LEFT", checkPos + 24, 0)
                        else
                            questCheck:SetPoint("LEFT", questLogTitle, "LEFT", 210, 0)
                        end
                    end
                end
            end
        end
    end)
end
