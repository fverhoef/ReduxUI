local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMainMenuBar()
    local config = AB.config.mainMenuBar
    local default = AB.defaults.mainMenuBar

    local framesToHide = {_G.MainMenuBar}
    local framesToDisable = {_G.MainMenuBar, _G.MicroButtonAndBagsBar, _G.MainMenuBarArtFrame}
    AB:HideBlizzardBar(framesToHide, framesToDisable)

    -- create new parent frame for buttons
    local frame = CreateFrame("Frame", addonName .. "MainMenuBar", UIParent, "SecureHandlerStateTemplate")
    frame.config = config
    frame:SetSize(552, 51)
    frame:SetPoint("BOTTOM", _G.UIParent, "BOTTOM", 0, 0)

    local buttonList = {}
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        local button = _G["ActionButton" .. i]
        if not button then
            break
        end
        table.insert(buttonList, button)
    end

    for i, button in next, buttonList do
        local parent = frame
        local point = {"BOTTOMLEFT", frame, "BOTTOMLEFT", 8, 4}

        if i > 1 then
            parent = buttonList[i - 1]
            point = {"BOTTOMLEFT", parent, "BOTTOMRIGHT", 6, 0}
        end

        AB:SetupButton(button, frame, 36, 36, point)
    end

    if _G.ActionBarUpButton then
        _G.ActionBarUpButton:SetParent(frame)
        _G.ActionBarUpButton:ClearAllPoints()
        _G.ActionBarUpButton:SetPoint("LEFT", "ActionButton12", "RIGHT", 0, 9)
    end

    if _G.ActionBarDownButton then
        _G.ActionBarDownButton:SetParent(frame)
        _G.ActionBarDownButton:ClearAllPoints()
        _G.ActionBarDownButton:SetPoint("LEFT", "ActionButton12", "RIGHT", 0, -10)
    end

    frame.PageNumber = frame:CreateFontString(nil, "OVERLAY")
    frame.PageNumber:SetFont(_G.STANDARD_TEXT_FONT, 11, "OUTLINE")
    frame.PageNumber:SetJustifyH("CENTER")
    frame.PageNumber:SetText(GetActionBarPage())
    frame.PageNumber:SetSize(20, 20)
    frame.PageNumber:SetPoint("LEFT", "ActionButton12", "RIGHT", 25, 0)

    -- fix the button grid for actionbar1
    local function UpdateGridVisibility()
        if InCombatLockdown() then
            return
        end
        local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
        for _, button in next, buttonList do
            button:SetAttribute("showgrid", showgrid)
            ActionButton_ShowGrid(button)
        end
    end
    AB:SecureHook("MultiActionBar_UpdateGridVisibility", UpdateGridVisibility)

    -- _onstate-page state driver
    for i, button in next, buttonList do
        frame:SetFrameRef("ActionButton" .. i, button)
    end

    frame:Execute(([[
        buttons = table.new()
        for i=1, %d do
            table.insert(buttons, self:GetFrameRef("%s"..i))
        end
    ]]):format(_G.NUM_ACTIONBAR_BUTTONS, "ActionButton"))

    frame:SetAttribute("_onstate-page", [[
        --print("_onstate-page","index",newstate)
        self:SetAttribute("actionpage", newstate)
        for i, button in next, buttons do
            button:SetAttribute("actionpage", newstate)
        end
    ]])

    local actionPage =
        "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
    RegisterStateDriver(frame, "page", actionPage)

    if config.frameVisibility then
        frame.frameVisibility = config.frameVisibility
        RegisterStateDriver(frame, "visibility", config.frameVisibility)
    end

    frame:CreateFader(config.fader, buttonList)
    R:CreateDragFrame(frame, "Main Action Bar", default.point)

    return frame
end

function AB:UpdateMainMenuBar()
    local config = AB.config.mainMenuBar
    local frame = AB.bars.MainMenuBar

    frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, _G.MainMenuExpBar:IsShown() and _G.ReputationWatchBar:IsShown() and 22 or 10)
    frame.PageNumber:SetText(GetActionBarPage())

    if AB.config.multiBarBottomRight.enabled then
        frame:SetWidth(806)
    else
        frame:SetWidth(552)
    end
end

function AB:CreateMainMenuBarArtwork()
    local frame = AB.bars.MainMenuBar

    local artwork = CreateFrame("Frame", "$parentArtwork", frame)
    artwork:SetAllPoints()
    artwork:SetFrameLevel(frame:GetFrameLevel() - 1)

    artwork.Texture = artwork:CreateTexture("ARTWORK", 0)
    artwork.Texture:SetTexture(R.media.textures.actionBars.mainMenuBar)
    artwork.Texture:SetAllPoints()

    artwork.TopEndCap = artwork:CreateTexture("ARTWORK", 1)

    artwork.LeftEndCap = artwork:CreateTexture("ARTWORK", 2)
    artwork.LeftEndCap:SetPoint("BOTTOMRIGHT", artwork, "BOTTOMLEFT", 32, 0)

    artwork.RightEndCap = artwork:CreateTexture("ARTWORK", 2)
    artwork.RightEndCap:SetPoint("BOTTOMLEFT", artwork, "BOTTOMRIGHT", -32, 0)

    frame.Artwork = artwork
    return artwork
end

function AB:UpdateMainMenuBarArtwork()
    local config = AB.config.mainMenuBar
    local artwork = AB.bars.MainMenuBar.Artwork

    if config.artwork.enabled then
        artwork.Texture:Show()
        artwork.TopEndCap:Show()
        artwork.LeftEndCap:Show()
        artwork.RightEndCap:Show()

        local isExpBarShown = _G.MainMenuExpBar:IsShown()
        local isRepBarShown = _G.ReputationWatchBar:IsShown()

        local offset = 0
        if isExpBarShown and isRepBarShown then
            offset = 22
        else
            offset = 10
        end

        artwork.LeftEndCap:SetPoint("BOTTOMRIGHT", artwork, "BOTTOMLEFT", 32, -offset - 1)
        artwork.RightEndCap:SetPoint("BOTTOMLEFT", artwork, "BOTTOMRIGHT", -32, -offset - 1)

        local endCapWidth = 128
        local endCapHeight = 76
        if config.artwork.theme == AB.themes.Default then
            artwork.Texture:SetTexture(R.media.textures.actionBars.mainMenuBar)
            if AB.config.multiBarBottomRight.enabled then
                artwork.Texture:SetTexCoord(113 / 1024, (113 + 806) / 1024, 115 / 255, 165 / 255)
            else
                artwork.Texture:SetTexCoord(113 / 1024, (113 + 552) / 1024, 64 / 255, 114 / 255)
            end

            artwork.TopEndCap:Hide()

            artwork.LeftEndCap:SetTexture(R.media.textures.actionBars.mainMenuBar)
            artwork.LeftEndCap:SetTexCoord(115 / 1024, (115 + endCapWidth) / 1024, 168 / 255, (168 + endCapHeight) / 255)
            artwork.LeftEndCap:SetSize(endCapWidth, 76)

            artwork.RightEndCap:SetTexture(R.media.textures.actionBars.mainMenuBar)
            artwork.RightEndCap:SetTexCoord((115 + endCapWidth) / 1024, 115 / 1024, 168 / 255, (168 + endCapHeight) / 255)
            artwork.RightEndCap:SetSize(endCapWidth, 76)
        else
            local texture = R.media.textures.actionBars["mainMenuBar_" .. config.artwork.theme]
            if config.artwork.theme == AB.themes.Faction then
                if UnitFactionGroup("player") == "Horde" then
                    texture = R.media.textures.actionBars.mainMenuBar_Horde
                else
                    texture = R.media.textures.actionBars.mainMenuBar_Alliance
                end
            end
            artwork.Texture:SetTexture(texture)
            artwork.Texture:SetTexCoord(0, 1, 90 / 512, 184 / 512)
            artwork.Texture:SetDrawLayer("ARTWORK", 0)

            artwork.TopEndCap:Show()
            artwork.TopEndCap:SetTexture(texture, true)
            artwork.TopEndCap:SetTexCoord(0 / 512, 512 / 512, 2 / 512, 29 / 512)
            artwork.TopEndCap:SetHorizTile(true)
            artwork.TopEndCap:SetHeight(16)
            artwork.TopEndCap:SetWidth(artwork:GetWidth())
            artwork.TopEndCap:SetPoint("TOPLEFT", artwork.LeftEndCap, "TOPRIGHT", -30,
                                       (isExpBarShown and isRepBarShown and -25) or -38)
            artwork.TopEndCap:SetPoint("TOPRIGHT", artwork.RightEndCap, "TOPLEFT", 30,
                                       (isExpBarShown and isRepBarShown and -25) or -38)
            artwork.TopEndCap:SetDrawLayer("ARTWORK", 1)

            artwork.LeftEndCap:SetTexture(texture)
            artwork.LeftEndCap:SetTexCoord(0 / 512, 176 / 512, 365 / 512, 510 / 512)
            artwork.LeftEndCap:SetSize(endCapWidth, 105)
            artwork.LeftEndCap:SetDrawLayer("ARTWORK", 2)

            artwork.RightEndCap:SetTexture(texture)
            artwork.RightEndCap:SetTexCoord(176 / 512, 0 / 512, 365 / 512, 510 / 512)
            artwork.RightEndCap:SetSize(endCapWidth, 105)
            artwork.RightEndCap:SetDrawLayer("ARTWORK", 2)
        end
    else
        artwork.Texture:Hide()
        artwork.TopEndCap:Hide()
        artwork.LeftEndCap:Hide()
        artwork.RightEndCap:Hide()
    end
end
