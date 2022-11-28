local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreatePageUpButton()
    local button = CreateFrame("Button", addonName .. "_ActionBarPageUp", UIParent, "SecureActionButtonTemplate")
    button:EnableMouse(true)
    button:RegisterForClicks("AnyDown")
    button:SetFrameLevel(10)
    button:SetAttribute("type", "actionbar")
    button:SetAttribute("action", AB:GetNextPage())
    button:SetSize(32, 32)
    button:SetHitRectInsets(6, 6, 7, 7)
    button:SetNormalTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollUpButton-Up]])
    button:SetPushedTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollUpButton-Down]])
    button:SetDisabledTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Disabled]])
    button:SetHighlightTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollUpButton-Highlight]])
    button:SetScript("PostClick", function()
        button:SetAttribute("action", AB:GetNextPage())
    end)
    return button
end

function AB:CreatePageDownButton()
    local button = CreateFrame("Button", addonName .. "_ActionBarPageDown", UIParent, "SecureActionButtonTemplate")
    button:EnableMouse(true)
    button:RegisterForClicks("AnyDown")
    button:SetFrameLevel(10)
    button:SetAttribute("type", "actionbar")
    button:SetAttribute("action", AB:GetPreviousPage())
    button:SetSize(32, 32)
    button:SetHitRectInsets(6, 6, 7, 7)
    button:SetNormalTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollDownButton-Up]])
    button:SetPushedTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollDownButton-Down]])
    button:SetDisabledTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Disabled]])
    button:SetHighlightTexture([[Interface\MainMenuBar\UI-MainMenu-ScrollDownButton-Highlight]])
    button:SetScript("PostClick", function()
        button:SetAttribute("action", AB:GetPreviousPage())
    end)
    return button
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
