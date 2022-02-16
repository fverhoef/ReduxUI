local addonName, ns = ...
local R = _G.ReduxUI
local AB = R:AddModule("ActionBars", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local L = R.L

function AB:Initialize()
    if not AB.config.enabled then return end

    AB:DisableBlizzard()
    if AB.config.mainMenuBarArt.enabled then AB:CreateMainMenuBarArtFrame() end
    AB:CreateMicroButtonAndBagsBar()

    AB.bars = {}
    for i = 1, 10 do AB.bars[i] = AB:CreateActionBar(i, AB.config["actionBar" .. i]) end

    AB.petBar = AB:CreatePetBar()
    AB.stanceBar = AB:CreateStanceBar()
    AB.vehicleExitBar = AB:CreateVehicleExitBar()

    AB:LoadFlyoutBars()
    AB:Update()
end

function AB:Update()
    if AB.config.mainMenuBarArt.enabled and not AB.MainMenuBarArtFrame then AB:CreateMainMenuBarArtFrame() end
    if AB.MainMenuBarArtFrame then AB.MainMenuBarArtFrame:Update() end
    AB:ConfigureActionBars()
    AB:UpdateFlyoutBars()
end

function AB:DisableBlizzard()
    R:ForceHide(MainMenuBarArtFrame, true)
    MainMenuBar:EnableMouse(false)
    R:ForceHide(MultiBarBottomLeft)
    R:ForceHide(MultiBarBottomRight)
    R:ForceHide(MultiBarLeft)
    R:ForceHide(MultiBarRight)
    R:ForceHide(PetActionBarFrame)
    R:ForceHide(PossessBarFrame)
    R:ForceHide(StanceBarFrame)
    R:ForceHide(MainMenuBarVehicleLeaveButton)
end

function AB:CreateActionBar(id)
    local bar = CreateFrame("Frame", addonName .. "_Bar" .. id, UIParent, "SecureHandlerStateTemplate")
    SecureHandlerSetFrameRef(bar, "MainMenuBarArtFrame", _G.MainMenuBarArtFrame)
    bar.config = AB.config["actionBar" .. id]
    bar.id = id

    bar.buttons = {}
    for i = 1, 12 do
        local button = R.Libs.ActionButton:CreateButton(i, "$parent_Button" .. i, bar, nil)
        button:SetState(0, "action", i)

        for k = 1, 14 do button:SetState(k, "action", (k - 1) * 12 + i) end

        button:UpdateConfig({keyBoundTarget = bar.config.keyBoundTarget .. i})
        R.Modules.ButtonStyles:StyleActionButton(button)

        bar.buttons[i] = button
    end

    bar:SetAttribute("_onstate-page", [[
        self:SetAttribute("state", newstate)
        control:ChildUpdate("state", newstate)
        self:GetFrameRef('MainMenuBarArtFrame'):SetAttribute('actionpage', newstate)
    ]])

    local page = bar.config.page
    if id == 1 then
        if R.isRetail then
            page = string.format("[overridebar] %d; [vehicleui] %d; [possessbar] %d;", GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex())
        else
            page = "[bonusbar:5] 11;"
        end

        page = page .. " [shapeshift] 13; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;"

        if R.PlayerInfo.class == "DRUID" then
            page = page .. "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:3] 9; [bonusbar:4] 10;"
        elseif R.PlayerInfo.class == "ROGUE" then
            page = page .. "[bonusbar:1] 7;"
        end

        page = page .. " [form] 1; 1"
    end

    RegisterStateDriver(bar, "page", page)

    R:CreateBackdrop(bar, {bgFile = R.media.textures.blank})
    R:CreateBorder(bar)
    R:CreateShadow(bar)
    R:CreateFader(bar, bar.config.fader, bar.buttons)
    R:CreateDragFrame(bar, bar:GetName(), AB.defaults["actionBar" .. id])

    return bar
end

function AB:ConfigureActionBars()
    for _, bar in ipairs(AB.bars) do AB:ConfigureActionBar(bar) end

    AB:ConfigureActionBar(AB.petBar)
    AB:ConfigureActionBar(AB.stanceBar)
    AB:ConfigureActionBar(AB.vehicleExitBar)

    if AB.config.mainMenuBarArt.enabled then
        local mainMenuBar = AB.bars[1]
        for j, button in ipairs(mainMenuBar.buttons) do
            button:SetSize(36, 36)
            button:ClearAllPoints()
            if j == 1 then
                button:SetPoint("BOTTOMLEFT", AB.MainMenuBarArtFrame, "BOTTOMLEFT", 8, 4)
            else
                button:SetPoint("LEFT", mainMenuBar.buttons[j - 1], "RIGHT", 6, 0)
            end
        end
        mainMenuBar.Backdrop:SetShown(false)
        mainMenuBar.Border:SetShown(false)
        mainMenuBar.Shadow:SetShown(false)
        R:LockDragFrame(mainMenuBar, true)

        local multiBarBottomLeft = AB.bars[2]
        for j, button in ipairs(multiBarBottomLeft.buttons) do
            button:SetSize(36, 36)
            button:ClearAllPoints()
            if j == 1 then
                button:SetPoint("BOTTOMLEFT", mainMenuBar.buttons[1], "TOPLEFT", 0, 10)
            else
                button:SetPoint("LEFT", multiBarBottomLeft.buttons[j - 1], "RIGHT", 6, 0)
            end
        end
        multiBarBottomLeft.Backdrop:SetShown(false)
        multiBarBottomLeft.Border:SetShown(false)
        multiBarBottomLeft.Shadow:SetShown(false)
        R:LockDragFrame(multiBarBottomLeft, true)

        local multiBarBottomRight = AB.bars[3]
        for j, button in ipairs(multiBarBottomRight.buttons) do
            button:SetSize(36, 36)
            button:ClearAllPoints()

            if AB.config.mainMenuBarArt.stackBottomBars then
                if j == 1 then
                    button:SetPoint("BOTTOMLEFT", multiBarBottomLeft.buttons[1], "TOPLEFT", 0, 5)
                else
                    button:SetPoint("LEFT", multiBarBottomRight.buttons[j - 1], "RIGHT", 6, 0)
                end
            else
                if j == 1 then
                    button:SetPoint("BOTTOMLEFT", mainMenuBar.buttons[12], "BOTTOMRIGHT", 45, 0)
                elseif j == 7 then
                    button:SetPoint("BOTTOMLEFT", multiBarBottomRight.buttons[1], "TOPLEFT", 0, 10)
                else
                    button:SetPoint("LEFT", multiBarBottomRight.buttons[j - 1], "RIGHT", 6, 0)
                end
            end
        end
        multiBarBottomRight.Backdrop:SetShown(false)
        multiBarBottomRight.Border:SetShown(false)
        multiBarBottomRight.Shadow:SetShown(false)
        R:LockDragFrame(multiBarBottomRight, true)

        local petBar = AB.petBar
        for j, button in ipairs(petBar.buttons) do
            button:SetSize(32, 32)
            button:ClearAllPoints()

            if j == 1 then
                button:SetPoint("BOTTOMLEFT", AB.config.mainMenuBarArt.stackBottomBars and multiBarBottomRight.buttons[1] or multiBarBottomLeft.buttons[1], "TOPLEFT", 18, 5)
            else
                button:SetPoint("LEFT", petBar.buttons[j - 1], "RIGHT", 6, 0)
            end
        end
        petBar.Backdrop:SetShown(false)
        petBar.Border:SetShown(false)
        petBar.Shadow:SetShown(false)
        R:LockDragFrame(petBar, true)

        local stanceBar = AB.stanceBar
        for j, button in ipairs(stanceBar.buttons) do
            button:SetSize(32, 32)
            button:ClearAllPoints()

            if j == 1 then
                button:SetPoint("BOTTOMLEFT", AB.config.mainMenuBarArt.stackBottomBars and multiBarBottomRight.buttons[1] or multiBarBottomLeft.buttons[1], "TOPLEFT", 18, 5)
            else
                button:SetPoint("LEFT", stanceBar.buttons[j - 1], "RIGHT", 6, 0)
            end
        end
        stanceBar.Backdrop:SetShown(false)
        stanceBar.Border:SetShown(false)
        stanceBar.Shadow:SetShown(false)
        R:LockDragFrame(stanceBar, true)

        AB.vehicleExitBar:ClearAllPoints()
        AB.vehicleExitBar:SetPoint("BOTTOMLEFT", AB.config.mainMenuBarArt.stackBottomBars and multiBarBottomRight.buttons[1] or multiBarBottomLeft.buttons[1], "TOPLEFT", 18, 5)
    end
end

function AB:ConfigureActionBar(bar)
    local buttons = bar.config.buttons
    local buttonsPerRow = bar.config.buttonsPerRow
    local width = bar.config.buttonSize
    local height = bar.config.buttonSize
    local columnDirection = bar.config.columnDirection
    local columnSpacing = bar.config.columnSpacing
    local rowDirection = bar.config.rowDirection
    local rowSpacing = bar.config.rowSpacing

    local columnMultiplier, columnAnchor, relativeColumnAnchor, rowMultiplier, rowAnchor, relativeRowAnchor
    if columnDirection == "Right" then
        columnMultiplier = 1
        columnAnchor = "TOPLEFT"
        relativeColumnAnchor = "TOPRIGHT"

        if rowDirection == "Down" then
            rowMultiplier = -1
            rowAnchor = "TOPLEFT"
            relativeRowAnchor = "BOTTOMLEFT"
        else
            rowMultiplier = 1
            rowAnchor = "BOTTOMLEFT"
            relativeRowAnchor = "TOPLEFT"
        end
    elseif columnDirection == "Left" then
        columnMultiplier = 1
        columnAnchor = "TOPRIGHT"
        relativeColumnAnchor = "TOPLEFT"

        if rowDirection == "Down" then
            rowMultiplier = -1
            rowAnchor = "TOPRIGHT"
            relativeRowAnchor = "BOTTOMRIGHT"
        else
            rowMultiplier = 1
            rowAnchor = "BOTTOMRIGHT"
            relativeRowAnchor = "TOPRIGHT"
        end
    end

    local rowCount, columnCount = 0, 0
    for i, button in ipairs(bar.buttons) do
        local parent = bar

        local point
        if i == 1 then
            point = {columnAnchor, bar, columnAnchor, 0, 0}
        elseif (i - 1) % buttonsPerRow == 0 then
            parent = bar.buttons[rowCount * buttonsPerRow + 1]
            point = {rowAnchor, parent, relativeRowAnchor, 0, rowMultiplier * rowSpacing}
            rowCount = rowCount + 1
        else
            parent = bar.buttons[i - 1]
            point = {columnAnchor, parent, relativeColumnAnchor, columnMultiplier * columnSpacing, 0}
        end

        button:SetSize(width, height)
        button:ClearAllPoints()
        R:SetPoint(button, point)

        if i > buttons then
            button:Hide()
        else
            button:Show()
        end

        if button.UpdateConfig then
            button:UpdateConfig({
                clickOnDown = bar.config.clickOnDown,
                showGrid = bar.config.showGrid,
                hideElements = {hotkey = bar.config.hideHotkey, macro = bar.config.hideMacro},
                flyoutDirection = bar.config.flyoutDirection or "UP",
                keyBoundTarget = bar.config.keyBoundTarget .. i
            })
        end

        columnCount = columnCount + 1
        if columnCount > buttonsPerRow then columnCount = buttonsPerRow end
    end

    if not bar.visibility then bar:SetShown(bar.config.enabled) end
    bar:SetSize(columnCount * width + (columnCount - 1) * columnSpacing, (rowCount + 1) * height + rowCount * rowSpacing)

    bar:ClearAllPoints()
    R:SetPoint(bar, bar.config.point)

    bar.Backdrop:SetShown(bar.config.backdrop)
    bar.Border:SetShown(bar.config.border)
    bar.Shadow:SetShown(bar.config.shadow)

    R:UnlockDragFrame(bar)

    if bar.Update then bar:Update() end
end
