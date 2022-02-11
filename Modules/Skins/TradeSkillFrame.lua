local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

-- Credit: Leatrix_Plus

function S:StyleTradeSkillFrame()
    if R.isRetail or not S.config.tradeSkill.enabled then return end

    if not _G.TradeSkillFrame then
        S:ScheduleTimer("StyleTradeSkillFrame", 0.01)
        return
    end

    UIPanelWindows["TradeSkillFrame"] = {area = "override", pushable = 1, xoffset = -16, yoffset = 12, bottomClampOverride = 140 + 12, width = 714, height = 487, whileDead = 1}

    TradeSkillFrame:SetWidth(714)
    TradeSkillFrame:SetHeight(487)

    TradeSkillFrameTitleText:ClearAllPoints()
    TradeSkillFrameTitleText:SetPoint("TOP", TradeSkillFrame, "TOP", 0, -18)

    TradeSkillListScrollFrame:ClearAllPoints()
    TradeSkillListScrollFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 25, -75)
    TradeSkillListScrollFrame:SetSize(295, 336)

    local oldTradeSkillsDisplayed = TRADE_SKILLS_DISPLAYED

    for i = 1 + 1, TRADE_SKILLS_DISPLAYED do
        _G["TradeSkillSkill" .. i]:ClearAllPoints()
        _G["TradeSkillSkill" .. i]:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    _G.TRADE_SKILLS_DISPLAYED = _G.TRADE_SKILLS_DISPLAYED + 14
    for i = oldTradeSkillsDisplayed + 1, TRADE_SKILLS_DISPLAYED do
        local button = CreateFrame("Button", "TradeSkillSkill" .. i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    S:SecureHook(TradeSkillHighlightFrame, "Show", function() TradeSkillHighlightFrame:SetWidth(290) end)

    TradeSkillDetailScrollFrame:ClearAllPoints()
    TradeSkillDetailScrollFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 352, -74)
    TradeSkillDetailScrollFrame:SetSize(298, 336)
    TradeSkillDetailScrollFrameTop:SetAlpha(0)
    TradeSkillDetailScrollFrameBottom:SetAlpha(0)

    local recipeInset = TradeSkillFrame:CreateTexture(nil, "ARTWORK")
    recipeInset:SetSize(304, 361)
    recipeInset:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 16, -72)
    recipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")

    local detailsInset = TradeSkillFrame:CreateTexture(nil, "ARTWORK")
    detailsInset:SetSize(302, 339)
    detailsInset:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 348, -72)
    detailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")

    TradeSkillExpandTabLeft:Hide()
    TradeSkillHorizontalBarLeft:SetSize(1, 1)
    TradeSkillHorizontalBarLeft:Hide()

    local regions = {TradeSkillFrame:GetRegions()}

    regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
    regions[2]:SetSize(512, 512)

    regions[3]:ClearAllPoints()
    regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
    regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
    regions[3]:SetSize(256, 512)

    regions[4]:Hide()
    regions[5]:Hide()

    TradeSkillCreateButton:ClearAllPoints()
    TradeSkillCreateButton:SetPoint("RIGHT", TradeSkillCancelButton, "LEFT", -1, 0)

    TradeSkillCancelButton:SetSize(80, 22)
    TradeSkillCancelButton:SetText(CLOSE)
    TradeSkillCancelButton:ClearAllPoints()
    TradeSkillCancelButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "BOTTOMRIGHT", -42, 54)

    TradeSkillFrameCloseButton:ClearAllPoints()
    TradeSkillFrameCloseButton:SetPoint("TOPRIGHT", TradeSkillFrame, "TOPRIGHT", -30, -8)

    TradeSkillInvSlotDropDown:ClearAllPoints()
    TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
    TradeSkillSubClassDropDown:ClearAllPoints()
    TradeSkillSubClassDropDown:SetPoint("RIGHT", TradeSkillInvSlotDropDown, "LEFT", 0, 0)
end
