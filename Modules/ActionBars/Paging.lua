local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreatePageUpButton(parent)
    local button = CreateFrame("Button", addonName .. "_ActionBarPageUp", parent, "SecureActionButtonTemplate")
    SecureHandlerSetFrameRef(button, "ActionBar1", AB.bars[1])
    button:EnableMouse(true)
    button:RegisterForClicks("AnyDown")
    button:SetFrameLevel(10)
    button:SetAttribute("type", "actionbar")
    button:SetAttribute("action", AB:GetNextPage())

    _G.Mixin(button, AB.PageUpButtonMixin)

	parent:WrapScript(button, "OnClick", [[
        local bar = self:GetFrameRef("ActionBar1")
        local currentPage = bar:GetAttribute("state")
        local nextPage = 1
        for i = currentPage + 1, 6 do
            if bar:GetAttribute("allowPage" .. i) == 1 then
                nextPage = i
                break
            end
        end
    
        if not nextPage then
            nextPage = 1
        end

        self:SetAttribute("action", nextPage)
	]])

    button:Update()

    return button
end

AB.PageUpButtonMixin = {}

function AB.PageUpButtonMixin:Update()
    if self.style == AB.Styles.Modern then
        self:SetSize(16, 11)
        self:SetHitRectInsets(0, 0, 0, 0)
        self:SetNormalTexture(R.media.textures.actionBars.modern.actionBar)
        self:GetNormalTexture():SetTexCoord(454 / 512, 486 / 512, 713 / 2048, 735 / 2048)
        self:SetPushedTexture(R.media.textures.actionBars.modern.actionBar)
        self:GetPushedTexture():SetTexCoord(454 / 512, 486 / 512, 683 / 2048, 705 / 2048)
        self:SetHighlightTexture(R.media.textures.actionBars.modern.actionBar)
        self:GetHighlightTexture():SetTexCoord(454 / 512, 486 / 512, 713 / 2048, 735 / 2048)
    else
        self:SetSize(32, 32)
        self:SetHitRectInsets(6, 6, 7, 7)
        self:SetNormalTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollUpButton-Up]])
        self:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
        self:SetPushedTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollUpButton-Down]])
        self:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
        self:SetHighlightTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollUpButton-Highlight]])
        self:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
    end
end

function AB:CreatePageDownButton(parent)
    local button = CreateFrame("Button", addonName .. "_ActionBarPageDown", parent, "SecureActionButtonTemplate")
    SecureHandlerSetFrameRef(button, "ActionBar1", AB.bars[1])
    button:EnableMouse(true)
    button:RegisterForClicks("AnyDown")
    button:SetFrameLevel(10)
    button:SetAttribute("type", "actionbar")
    button:SetAttribute("action", AB:GetPreviousPage())

    _G.Mixin(button, AB.PageDownButtonMixin)

	parent:WrapScript(button, "OnClick", [[
        local bar = self:GetFrameRef("ActionBar1")
        local currentPage = bar:GetAttribute("state")
        local prevPage
        for i = currentPage - 1, 1, -1 do
            if bar:GetAttribute("allowPage" .. i) == 1 then
                prevPage = i
                break
            end
        end
    
        if not prevPage then
            for i = 6, 1, -1 do
                if bar:GetAttribute("allowPage" .. i) == 1 then
                    prevPage = i
                    break
                end
            end
        end

        self:SetAttribute("action", prevPage)
	]])

    button:Update()

    return button
end

AB.PageDownButtonMixin = {}

function AB.PageDownButtonMixin:Update()
    if self.style == AB.Styles.Modern then
        self:SetSize(16, 11)
        self:SetHitRectInsets(0, 0, 0, 0)
        self:SetNormalTexture(R.media.textures.actionBars.modern.actionBar)
        self:GetNormalTexture():SetTexCoord(462 / 512, 494 / 512, 578 / 2048, 600 / 2048)
        self:SetPushedTexture(R.media.textures.actionBars.modern.actionBar)
        self:GetPushedTexture():SetTexCoord(462 / 512, 494 / 512, 548 / 2048, 570 / 2048)
        self:SetHighlightTexture(R.media.textures.actionBars.modern.actionBar)
        self:GetHighlightTexture():SetTexCoord(462 / 512, 494 / 512, 578 / 2048, 600 / 2048)
    else
        self:SetSize(32, 32)
        self:SetHitRectInsets(6, 6, 7, 7)
        self:SetNormalTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollDownButton-Up]])
        self:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
        self:SetPushedTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollDownButton-Down]])
        self:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
        self:SetHighlightTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollDownButton-Highlight]])
        self:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
    end
end

function AB:CreatePageNumber()
    local pageNumber = AB.bars[1]:CreateFontString("$parentPageNumber", "OVERLAY", nil, 7)
    pageNumber:SetSize(20, 20)
    pageNumber:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    pageNumber:SetJustifyH("CENTER")
    pageNumber:SetText(GetActionBarPage())
    return pageNumber
end

function AB:UpdatePageNumber()
    AB.pageNumber:SetText(GetActionBarPage())
end

function AB:UpdateAllowedPages()
    for i = 1, 6 do
        AB.bars[1]:SetAttribute("allowPage" .. i, AB:IsPageEnabled(i) and 1 or 0)
    end
end

function AB:IsPageEnabled(page)
    if page == 3 then
        return not AB.bars[4].config.enabled
    elseif page == 4 then
        return not AB.bars[5].config.enabled
    elseif page == 5 then
        return not AB.bars[3].config.enabled
    elseif page == 6 then
        return not AB.bars[2].config.enabled
    end

    return page > 0 and page < 7
end

function AB:GetNextPage()
    local nextPage
    for i = GetActionBarPage() + 1, NUM_ACTIONBAR_PAGES do
        if AB:IsPageEnabled(i) then
            nextPage = i
            break
        end
    end

    if not nextPage then
        nextPage = 1
    end

    return nextPage
end

function AB:GetPreviousPage()
    local prevPage
    for i = GetActionBarPage() - 1, 1, -1 do
        if AB:IsPageEnabled(i) then
            prevPage = i
            break
        end
    end

    if not prevPage then
        for i = NUM_ACTIONBAR_PAGES, 1, -1 do
            if AB:IsPageEnabled(i) then
                prevPage = i
                break
            end
        end
    end

    return prevPage
end
