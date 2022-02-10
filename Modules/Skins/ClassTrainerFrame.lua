local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

-- Credit: Leatrix_Plus

function S:StyleClassTrainerFrame()
    if R.isRetail or not S.config.classTrainer.enabled then return end

    if not _G.ClassTrainerFrame then
        S:ScheduleTimer("StyleClassTrainerFrame", 0.01)
        return
    end

    local width, height = 714, 487

    -- Make the frame double-wide
    UIPanelWindows["ClassTrainerFrame"] = {
        area = "override",
        pushable = 1,
        xoffset = -16,
        yoffset = 12,
        bottomClampOverride = 140 + 12,
        width = width,
        height = height,
        whileDead = 1
    }

    -- Size the frame
    ClassTrainerFrame:SetSize(width, height)

    -- Lower title text slightly
    ClassTrainerNameText:ClearAllPoints()
    ClassTrainerNameText:SetPoint("TOP", ClassTrainerFrame, "TOP", 0, -18)

    -- Expand the skill list to full height
    ClassTrainerListScrollFrame:ClearAllPoints()
    ClassTrainerListScrollFrame:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 25, -75)
    ClassTrainerListScrollFrame:SetSize(295, 336)

    -- Create additional list rows
    local oldSkillsDisplayed = CLASS_TRAINER_SKILLS_DISPLAYED

    -- Position existing buttons
    for i = 1 + 1, CLASS_TRAINER_SKILLS_DISPLAYED do
        _G["ClassTrainerSkill" .. i]:ClearAllPoints()
        _G["ClassTrainerSkill" .. i]:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    -- Create and position new buttons
    _G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + 12
    for i = oldSkillsDisplayed + 1, CLASS_TRAINER_SKILLS_DISPLAYED do
        local button = CreateFrame("Button", "ClassTrainerSkill" .. i, ClassTrainerFrame, "ClassTrainerSkillButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    S:SecureHook("ClassTrainer_SetToTradeSkillTrainer", function()
        _G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + 12
        ClassTrainerListScrollFrame:SetHeight(336)
        ClassTrainerDetailScrollFrame:SetHeight(336)
    end)

    S:SecureHook("ClassTrainer_SetToClassTrainer", function()
        _G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + 11
        ClassTrainerListScrollFrame:SetHeight(336)
        ClassTrainerDetailScrollFrame:SetHeight(336)
    end)

    -- Set highlight bar width when shown
    S:SecureHook(ClassTrainerSkillHighlightFrame, "Show", function()
        ClassTrainerSkillHighlightFrame:SetWidth(290)
    end)

    -- Move the detail frame to the right and stretch it to full height
    ClassTrainerDetailScrollFrame:ClearAllPoints()
    ClassTrainerDetailScrollFrame:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 352, -74)
    ClassTrainerDetailScrollFrame:SetSize(296, 336)
    -- _G["ClassTrainerSkillIcon"]:SetHeight(500) -- Debug

    -- Hide detail scroll frame textures
    ClassTrainerDetailScrollFrameTop:SetAlpha(0)
    ClassTrainerDetailScrollFrameBottom:SetAlpha(0)

    -- Hide expand tab (left of All button)
    ClassTrainerExpandTabLeft:Hide()

    -- Get frame textures
    local regions = {ClassTrainerFrame:GetRegions()}

    -- Set top left texture
    regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
    regions[2]:SetSize(512, 512)

    -- Set top right texture
    regions[3]:ClearAllPoints()
    regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
    regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
    regions[3]:SetSize(256, 512)

    -- Hide bottom left and bottom right textures
    regions[4]:Hide()
    regions[5]:Hide()

    -- Hide skills list dividing bar
    regions[9]:Hide()
    ClassTrainerHorizontalBarLeft:Hide()

    -- Set skills list backdrop
    local recipeInset = ClassTrainerFrame:CreateTexture(nil, "ARTWORK")
    recipeInset:SetSize(304, 361)
    recipeInset:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 16, -72)
    recipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")

    -- Set detail frame backdrop
    local detailsInset = ClassTrainerFrame:CreateTexture(nil, "ARTWORK")
    detailsInset:SetSize(302, 339)
    detailsInset:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 348, -72)
    detailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")

    -- Move bottom button row
    ClassTrainerTrainButton:ClearAllPoints()
    ClassTrainerTrainButton:SetPoint("RIGHT", ClassTrainerCancelButton, "LEFT", -1, 0)

    -- Position and size close button
    ClassTrainerCancelButton:SetSize(80, 22)
    ClassTrainerCancelButton:SetText(CLOSE)
    ClassTrainerCancelButton:ClearAllPoints()
    ClassTrainerCancelButton:SetPoint("BOTTOMRIGHT", ClassTrainerFrame, "BOTTOMRIGHT", -42, 54)

    -- Position close box
    ClassTrainerFrameCloseButton:ClearAllPoints()
    ClassTrainerFrameCloseButton:SetPoint("TOPRIGHT", ClassTrainerFrame, "TOPRIGHT", -30, -8)

    -- Position dropdown menus
    ClassTrainerFrameFilterDropDown:ClearAllPoints()
    ClassTrainerFrameFilterDropDown:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 501, -40)

    -- Position money frame
    ClassTrainerMoneyFrame:ClearAllPoints()
    ClassTrainerMoneyFrame:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 143, -49)
    ClassTrainerGreetingText:Hide()
end
