local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local S = Addon.Modules.Skins

-- Credit: Leatrix_Plus

function S:StyleTradeSkillFrame()
    LoadAddOn("Blizzard_TradeSkillUI")

    -- Make the tradeskill frame double-wide
    UIPanelWindows["TradeSkillFrame"] = {area = "override", pushable = 1, xoffset = -16, yoffset = 12, bottomClampOverride = 140 + 12, width = 714, height = 487, whileDead = 1}

    -- Size the tradeskill frame
    TradeSkillFrame:SetWidth(714)
    TradeSkillFrame:SetHeight(487)

    -- Adjust title text
    TradeSkillFrameTitleText:ClearAllPoints()
    TradeSkillFrameTitleText:SetPoint("TOP", TradeSkillFrame, "TOP", 0, -18)

    -- Expand the tradeskill list to full height
    TradeSkillListScrollFrame:ClearAllPoints()
    TradeSkillListScrollFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 25, -75)
    TradeSkillListScrollFrame:SetSize(295, 336)

    -- Create additional list rows
    local oldTradeSkillsDisplayed = TRADE_SKILLS_DISPLAYED

    -- Position existing buttons
    for i = 1 + 1, TRADE_SKILLS_DISPLAYED do
        _G["TradeSkillSkill" .. i]:ClearAllPoints()
        _G["TradeSkillSkill" .. i]:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i-1)], "BOTTOMLEFT", 0, 1)
    end

    -- Create and position new buttons
    _G.TRADE_SKILLS_DISPLAYED = _G.TRADE_SKILLS_DISPLAYED + 14
    for i = oldTradeSkillsDisplayed + 1, TRADE_SKILLS_DISPLAYED do
        local button = CreateFrame("Button", "TradeSkillSkill" .. i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i-1)], "BOTTOMLEFT", 0, 1)
    end

    -- Set highlight bar width when shown
    S:SecureHook(TradeSkillHighlightFrame, "Show", function()
        TradeSkillHighlightFrame:SetWidth(290)
    end)

    -- Move the tradeskill detail frame to the right and stretch it to full height
    TradeSkillDetailScrollFrame:ClearAllPoints()
    TradeSkillDetailScrollFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 352, -74)
    TradeSkillDetailScrollFrame:SetSize(298, 336)
    TradeSkillDetailScrollFrameTop:SetAlpha(0)
    TradeSkillDetailScrollFrameBottom:SetAlpha(0)

    -- Create texture for skills list
    local recipeInset = TradeSkillFrame:CreateTexture(nil, "ARTWORK")
    recipeInset:SetSize(304, 361)
    recipeInset:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 16, -72)
    recipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")

    -- Set detail frame backdrop
    local detailsInset = TradeSkillFrame:CreateTexture(nil, "ARTWORK")
    detailsInset:SetSize(302, 339)
    detailsInset:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 348, -72)
    detailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")

    -- Hide expand tab (left of All button)
    --TradeSkillExpandTabLeft:Hide()

    -- Get tradeskill frame textures
    local regions = {TradeSkillFrame:GetRegions()}

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
    regions[10]:Hide()

    -- Move create button row
    TradeSkillCreateButton:ClearAllPoints()
    TradeSkillCreateButton:SetPoint("RIGHT", TradeSkillCancelButton, "LEFT", -1, 0)

    -- Position and size close button
    TradeSkillCancelButton:SetSize(80, 22)
    TradeSkillCancelButton:SetText(CLOSE)
    TradeSkillCancelButton:ClearAllPoints()
    TradeSkillCancelButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -42, 54)

    -- Position close box
    TradeSkillFrameCloseButton:ClearAllPoints()
    TradeSkillFrameCloseButton:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -30, -8)

    -- Position dropdown menus
    TradeSkillInvSlotDropDown:ClearAllPoints()
    TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
    TradeSkillSubClassDropDown:ClearAllPoints()
    TradeSkillSubClassDropDown:SetPoint("RIGHT", TradeSkillInvSlotDropDown, "LEFT", 0, 0)
end