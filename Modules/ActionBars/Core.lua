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
    MainMenuBar:SetParent(R.HiddenFrame)
    MultiBarBottomLeft:SetParent(R.HiddenFrame)
    MultiBarBottomRight:SetParent(R.HiddenFrame)
    MultiBarLeft:SetParent(R.HiddenFrame)
    MultiBarRight:SetParent(R.HiddenFrame)
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

    if AB.config.mainMenuBarArt.enabled then
        local mainMenuBar = AB.bars[1]
        for j = 1, 12 do
            local button = mainMenuBar.buttons[j]
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
        for j = 1, 12 do
            local button = multiBarBottomLeft.buttons[j]
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
        for j = 1, 12 do
            local button = multiBarBottomRight.buttons[j]
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
        for j = 1, 11 do
            local button = petBar.buttons[j]
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

        columnCount = columnCount + 1
        if columnCount > buttonsPerRow then columnCount = buttonsPerRow end
    end

    bar:SetShown(bar.config.enabled)
    bar:SetSize(columnCount * width + (columnCount - 1) * columnSpacing, (rowCount + 1) * height + rowCount * rowSpacing)

    bar:ClearAllPoints()
    R:SetPoint(bar, bar.config.point)

    bar.Backdrop:SetShown(bar.config.backdrop)
    bar.Border:SetShown(bar.config.border)
    bar.Shadow:SetShown(bar.config.shadow)

    R:UnlockDragFrame(bar)
end

function AB:CreateMainMenuBarArtFrame() AB.MainMenuBarArtFrame = CreateFrame("Frame", addonName .. "MainMenuBarArtFrame", UIParent, "MainMenuBarArtFrameTemplate") end

function AB:CreateMicroButtonAndBagsBar() AB.MicroButtonAndBagsBar = CreateFrame("Frame", addonName .. "MicroButtonAndBagsBar", UIParent, "MicroButtonAndBagsBarTemplate") end

function AB:CreatePetBar()
    local bar = CreateFrame("Frame", addonName .. "_PetBar", UIParent, "SecureHandlerStateTemplate")
    bar:SetFrameStrata("LOW")
    bar.config = AB.config.petBar
    bar.buttons = {}

    for i = 1, 10 do
        local button = CreateFrame("CheckButton", "$parent_Button" .. i, bar, "PetActionButtonTemplate")
        button:SetID(i)
        button:SetScript("OnEvent", nil)
        button:SetScript("OnUpdate", nil)
        button:UnregisterAllEvents()
        R.Modules.ButtonStyles:StyleActionButton(button)
        button.keyBoundTarget = bar.config.keyBoundTarget .. i
        AB:UpdatePetButton(button)

        bar.buttons[i] = button
    end

    local dismissButton = R.Libs.ActionButton:CreateButton(11, "$parent_Button11", bar, nil)
    dismissButton:SetState(0, "custom", {func = function() PetDismiss() end, texture = [[Interface\Icons\Spell_Shadow_SacrificialShield]], tooltip = _G.PET_DISMISS})
    bar.buttons[11] = dismissButton
    R.Modules.ButtonStyles:StyleActionButton(dismissButton)

    RegisterStateDriver(bar, "visibility", "[overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide")

    bar:SetScript("OnEvent", function(self, event, arg1)
        if event == "PET_BAR_UPDATE" or event == "PET_SPECIALIZATION_CHANGED" or event == "PET_UI_UPDATE" or (event == "UNIT_PET" and arg1 == "player") or
            ((event == "UNIT_FLAGS" or event == "UNIT_AURA") and arg1 == "pet") or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or
            event == "PET_BAR_UPDATE_COOLDOWN" then for i = 1, 10 do AB:UpdatePetButton(self.buttons[i]) end end
    end)

    bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
    bar:RegisterEvent("PET_BAR_UPDATE")
    if R.isRetail then bar:RegisterEvent("PET_SPECIALIZATION_CHANGED") end
    bar:RegisterEvent("PLAYER_CONTROL_GAINED")
    bar:RegisterEvent("PLAYER_CONTROL_LOST")
    bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
    bar:RegisterEvent("UNIT_AURA")
    bar:RegisterEvent("UNIT_FLAGS")
    bar:RegisterEvent("UNIT_PET")

    R:CreateBackdrop(bar, {bgFile = R.media.textures.blank})
    R:CreateBorder(bar)
    R:CreateShadow(bar)
    R:CreateFader(bar, bar.config.fader, bar.buttons)
    R:CreateDragFrame(bar, bar:GetName(), AB.defaults.petBar)

    return bar
end

function AB:UpdatePetButton(button)
    local id = button:GetID()
    local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(id)

    button.tooltipName = isToken and _G[name] or name
    button.isToken = isToken
    button.icon:SetTexture(isToken and _G[texture] or texture)
    button.icon:SetShown(texture ~= nil)

    if spellID then button.tooltipSubtext = GetSpellSubtext(spellID) end

    if PetHasActionBar() and isActive then
        if IsPetAttackAction(id) then
            PetActionButton_StartFlash(button)
            button:GetCheckedTexture():SetAlpha(0.5)
        else
            PetActionButton_StopFlash(button)
            button:GetCheckedTexture():SetAlpha(1.0)
        end

        button:SetChecked(true)
    else
        PetActionButton_StopFlash(button)
        button:GetCheckedTexture():SetAlpha(1.0)
        button:SetChecked(false)
    end

    _G[button:GetName() .. "AutoCastable"]:SetShown(autoCastAllowed)
    if autoCastEnabled then
        AutoCastShine_AutoCastStart(button.AutoCastShine)
    else
        AutoCastShine_AutoCastStop(button.AutoCastShine)
    end

    button.HotKey:SetText(R.Libs.KeyBound:ToShortKey(GetBindingKey(button.keyBoundTarget)))
    button.HotKey:Show()
end

function AB:CreateStanceBar()
    local bar = CreateFrame("Frame", addonName .. "_StanceBar", UIParent, "SecureHandlerStateTemplate")
    bar:SetFrameStrata("LOW")
    bar.config = AB.config.stanceBar
    bar.buttons = {}

    R:CreateBackdrop(bar, {bgFile = R.media.textures.blank})
    R:CreateBorder(bar)
    R:CreateShadow(bar)
    R:CreateFader(bar, bar.config.fader, bar.buttons)
    R:CreateDragFrame(bar, bar:GetName(), AB.defaults.stanceBar)

    return bar
end
