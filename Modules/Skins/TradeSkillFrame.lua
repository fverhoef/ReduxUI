local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

-- credit: LeatrixPlus

function S:StyleTradeSkillFrame()
    if R.isRetail or not S.config.tradeSkill.enabled then
        return
    end
    UIPanelWindows["TradeSkillFrame"] = { area = "override", pushable = 1, xoffset = -16, yoffset = 12, bottomClampOverride = 140 + 12, width = 682, height = 447, whileDead = 1 }

    TradeSkillFrame:SetSize(682, 447)

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

    _G.TRADE_SKILLS_DISPLAYED = _G.TRADE_SKILLS_DISPLAYED + 13
    for i = oldTradeSkillsDisplayed + 1, TRADE_SKILLS_DISPLAYED do
        local button = CreateFrame("Button", "TradeSkillSkill" .. i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
    end

    S:SecureHook(TradeSkillHighlightFrame, "Show", function()
        TradeSkillHighlightFrame:SetWidth(290)
    end)

    TradeSkillDetailScrollFrame:ClearAllPoints()
    TradeSkillDetailScrollFrame:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 352, -74)
    TradeSkillDetailScrollFrame:SetSize(298, 336)

    TradeSkillDetailScrollFrameTop:SetAlpha(0)
    TradeSkillDetailScrollFrameBottom:SetAlpha(0)

    TradeSkillExpandTabLeft:Hide()

    local regions = { TradeSkillFrame:GetRegions() }

    regions[3]:SetTexture(S.config.tradeSkill.style == S.Styles.Modern and R.media.textures.frames.modern.dualPaneFrame_Left or R.media.textures.frames.vanilla.dualPaneFrame_Left)
    regions[3]:SetTexCoord(0, 1, 0, 1)
    regions[3]:SetSize(512, 512)
    regions[4]:SetTexture(S.config.tradeSkill.style == S.Styles.Modern and R.media.textures.frames.modern.dualPaneFrame_Right or R.media.textures.frames.vanilla.dualPaneFrame_Right)
    regions[4]:SetTexCoord(0, 1, 0, 1)
    regions[4]:SetSize(256, 512)
    regions[4]:ClearAllPoints()
    regions[4]:SetPoint("TOPLEFT", 512, 0)
    regions[5]:Hide()
    regions[6]:Hide()
    regions[8]:Hide()
    regions[9]:Hide()

    TradeSkillRankFrame:ClearAllPoints()    
    TradeSkillRankFrame:SetPoint("TOPLEFT", 75, -48)

    TradeSkillRankFrameSkillRank:ClearAllPoints()
    TradeSkillRankFrameSkillRank:SetPoint("TOP", TradeSkillRankFrame, "TOP", 0, -1)

    TradeSkillCreateButton:ClearAllPoints()
    TradeSkillCreateButton:SetPoint("RIGHT", TradeSkillCancelButton, "LEFT", -1, 0)

    TradeSkillCancelButton:SetSize(80, 22)
    TradeSkillCancelButton:SetText(CLOSE)
    TradeSkillCancelButton:ClearAllPoints()
    TradeSkillCancelButton:SetPoint("BOTTOMRIGHT", -7, 14)

    TradeSkillFrameCloseButton:ClearAllPoints()
    TradeSkillFrameCloseButton:SetPoint("TOPRIGHT", 2, -8)

    TradeSkillInvSlotDropDown:ClearAllPoints()
    TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", 510, -40)
    TradeSkillSubClassDropDown:ClearAllPoints()
    TradeSkillSubClassDropDown:SetPoint("RIGHT", TradeSkillInvSlotDropDown, "LEFT", 0, 0)

    TradeSkillFrameEditBox:ClearAllPoints()
    TradeSkillFrameEditBox:SetPoint("BOTTOMLEFT", 25, 15)
    TradeSkillFrameEditBox:SetSize(200, 18)
    TradeSkillFrameEditBox:SetFrameLevel(3)
    _G["TradeSkillFrameEditBoxLeft"]:SetHeight(18)
    _G["TradeSkillFrameEditBoxRight"]:SetHeight(18)
    _G["TradeSkillFrameEditBoxMiddle"]:SetHeight(18)

    TradeSkillFrameAvailableFilterCheckButton:ClearAllPoints()
    TradeSkillFrameAvailableFilterCheckButton:SetPoint("LEFT", TradeSkillFrameEditBox, "RIGHT", 5, 0)

    TradeSkillFrameAvailableFilterCheckButtonText:SetWidth(110)
    TradeSkillFrameAvailableFilterCheckButtonText:SetWordWrap(false)
    TradeSkillFrameAvailableFilterCheckButtonText:SetJustifyH("LEFT")
end
