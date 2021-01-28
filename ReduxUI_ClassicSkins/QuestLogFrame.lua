local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

-- Credit: Leatrix_Plus

function S:StyleQuestLogFrame()
    local width, height = 714, 487

    -- Make the quest log frame double-wide
    UIPanelWindows["QuestLogFrame"] = {area = "override", pushable = 0, xoffset = -16, yoffset = 12, bottomClampOverride = 140 + 12, width = width, height = height, whileDead = 1}

    -- Size the quest log frame
    QuestLogFrame:SetWidth(width)
    QuestLogFrame:SetHeight(height)

    -- Adjust quest log title text
    QuestLogTitleText:ClearAllPoints()
    QuestLogTitleText:SetPoint("TOP", QuestLogFrame, "TOP", 0, -18)

    -- Move the detail frame to the right and stretch it to full height
    QuestLogDetailScrollFrame:ClearAllPoints()
    QuestLogDetailScrollFrame:SetPoint("TOPLEFT", QuestLogListScrollFrame, "TOPRIGHT", 31, 1)
    QuestLogDetailScrollFrame:SetHeight(336)

    -- Expand the quest list to full height
    QuestLogListScrollFrame:SetHeight(336)

    -- Create additional quest rows
    local oldQuestsDisplayed = QUESTS_DISPLAYED
    _G.QUESTS_DISPLAYED = _G.QUESTS_DISPLAYED + 16
    for i = oldQuestsDisplayed + 1, QUESTS_DISPLAYED do
        local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["QuestLogTitle" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    -- Get quest frame textures
    local regions = {QuestLogFrame:GetRegions()}

    -- Set top left texture
    regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
    regions[3]:SetSize(512, 512)

    -- Set top right texture
    regions[4]:ClearAllPoints()
    regions[4]:SetPoint("TOPLEFT", regions[3], "TOPRIGHT", 0, 0)
    regions[4]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
    regions[4]:SetSize(256, 512)

    -- Hide bottom left and bottom right textures
    regions[5]:Hide()
    regions[6]:Hide()

    -- Position and resize abandon button
    QuestLogFrameAbandonButton:SetSize(110, 21)
    QuestLogFrameAbandonButton:SetText(ABANDON_QUEST_ABBREV)
    QuestLogFrameAbandonButton:ClearAllPoints()
    QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 17, 54)

    -- Position and resize share button
    QuestFramePushQuestButton:SetSize(100, 21)
    QuestFramePushQuestButton:SetText(SHARE_QUEST_ABBREV)
    QuestFramePushQuestButton:ClearAllPoints()
    QuestFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", -3, 0)

    -- Add map button
    local logMapButton = CreateFrame("Button", nil, QuestLogFrame, "UIPanelButtonTemplate")
    logMapButton:SetText(SHOW_MAP)
    logMapButton:ClearAllPoints()
    logMapButton:SetPoint("LEFT", QuestFramePushQuestButton, "RIGHT", -3, 0)
    logMapButton:SetSize(100, 21)
    logMapButton:SetScript("OnClick", ToggleWorldMap)

    -- Position and size close button
    QuestFrameExitButton:SetSize(80, 22)
    QuestFrameExitButton:SetText(CLOSE)
    QuestFrameExitButton:ClearAllPoints()
    QuestFrameExitButton:SetPoint("BOTTOMRIGHT", QuestLogFrame, "BOTTOMRIGHT", -42, 54)

    -- Empty quest frame
    QuestLogNoQuestsText:ClearAllPoints()
    QuestLogNoQuestsText:SetPoint("TOP", QuestLogListScrollFrame, 0, -50)
    hooksecurefunc(EmptyQuestLogFrame, "Show", function()
        EmptyQuestLogFrame:ClearAllPoints()
        EmptyQuestLogFrame:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 20, -76)
        EmptyQuestLogFrame:SetHeight(487)
    end)

    -- Show quest levels
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

                -- adjust check mark position
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
