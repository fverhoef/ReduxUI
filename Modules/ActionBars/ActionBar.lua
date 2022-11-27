local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionBar(id)
    local bar = CreateFrame("Frame", addonName .. "_Bar" .. id, UIParent, "SecureHandlerStateTemplate")
    SecureHandlerSetFrameRef(bar, "MainMenuBarArtFrame", _G.MainMenuBarArtFrame)
    bar.config = AB.config["actionBar" .. id]
    bar.defaults = AB.defaults["actionBar" .. id]
    bar.id = id
    _G.Mixin(bar, ActionBarMixin)

    bar.buttons = {}
    for id = 1, 12 do
        local button = R.Libs.ActionButton:CreateButton(i, "$parent_Button" .. id, bar, nil)
        button:SetState(0, "action", id)
        button:SetAttribute("buttonlock", true)

        for k = 1, 14 do
            button:SetState(k, "action", (k - 1) * 12 + id)
        end
        button:UpdateConfig({ keyBoundTarget = bar.config.keyBoundTarget .. id })
        R.Modules.ButtonStyles:StyleActionButton(button)

        bar.buttons[id] = button
    end

    bar:SetAttribute("_onstate-page", [[
        self:SetAttribute("state", newstate)
        control:ChildUpdate("state", newstate)
        self:GetFrameRef('MainMenuBarArtFrame'):SetAttribute('actionpage', newstate)
    ]])

    local page = bar.config.page
    if id == 1 then
        page = string.format("[overridebar] %d; [vehicleui] %d; [possessbar] %d;", GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex())
        page = page .. " [shapeshift] 13; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;"

        if R.PlayerInfo.class == "DRUID" then
            page = page .. "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:3] 9; [bonusbar:4] 10;"
        elseif R.PlayerInfo.class == "ROGUE" then
            page = page .. "[bonusbar:1] 7;"
        end

        page = page .. " [form] 1; 1"
    end

    RegisterStateDriver(bar, "page", page)

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateFader(bar.config.fader, bar.buttons)
    bar:CreateMover(L["Action Bar " .. id], bar.defaults.point)

    return bar
end

ActionBarMixin = {}

function ActionBarMixin:Configure()
    local visibleButtons = self.visibleButtons or self.config.buttons
    local buttonsPerRow = self.config.buttonsPerRow
    local width = self.config.buttonSize
    local height = self.config.buttonSize
    local columnDirection = self.config.columnDirection
    local columnSpacing = self.config.columnSpacing
    local rowDirection = self.config.rowDirection
    local rowSpacing = self.config.rowSpacing

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
        columnMultiplier = -1
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

    local totalWidth, totalHeight = 0, 0
    local row, column = 0, 0, 0
    for i, button in ipairs(self.buttons) do
        local parent = self

        if i > visibleButtons then
            button:Hide()
        else
            button:Show()

            local point
            if i == 1 then
                point = { columnAnchor, self, columnAnchor, 0, 0 }
                row, column = 1, 1
                totalWidth, totalHeight = width, height
            elseif column == buttonsPerRow then
                parent = self.buttons[(row - 1) * buttonsPerRow + 1]
                point = { rowAnchor, parent, relativeRowAnchor, 0, rowMultiplier * rowSpacing }
                row, column = row + 1, 1
                totalHeight = totalHeight + rowSpacing + height
            else
                parent = self.buttons[i - 1]
                point = { columnAnchor, parent, relativeColumnAnchor, columnMultiplier * columnSpacing, 0 }
                column = column + 1
                if i <= buttonsPerRow then
                    totalWidth = totalWidth + columnSpacing + width
                end
            end

            button:SetSize(width, height)
            button:ClearAllPoints()
            button:SetNormalizedPoint(point)

            button:SetAttribute("buttonlock", true)
            if button.Configure then
                button:Configure()
            end
            if button.UpdateConfig then
                button:UpdateConfig({
                    clickOnDown = self.config.clickOnDown,
                    showGrid = self.config.showGrid,
                    hideElements = { hotkey = self.config.hideHotkey, macro = self.config.hideMacro },
                    flyoutDirection = self.config.flyoutDirection or "UP",
                    keyBoundTarget = self.config.keyBoundTarget .. i
                })
            end
        end
    end

    if not self.visibility then
        self:SetShown(self.config.enabled)
    end
    self:SetSize(totalWidth, totalHeight)

    self:ClearAllPoints()
    self:SetNormalizedPoint(self.config.point)

    self.Backdrop:SetShown(self.config.backdrop)
    self.Border:SetShown(self.config.border)
    self.Shadow:SetShown(self.config.shadow)
    self.Mover:Unlock()
    self:CreateFader(self.config.fader, self.buttons)
end

function AB:CreateActionBarButton(id, parent, keyBoundTarget)
    local button = CreateFrame("CheckButton", "$parent_Button", parent, "ActionBarButtonTemplate")
    button:SetID(id)
    button.config = parent.config
    _G.Mixin(button, ActionBarButtonMixin)
    button:SetScript("OnUpdate", ActionBarButtonMixin.OnUpdate)
    button.IsFlashing = button.IsFlashing or ActionButton_IsFlashing

    if keyBoundTarget then
        _G.Mixin(button, KeyBoundButtonMixin)

        button.keyBoundTarget = keyBoundTarget
        AB:SecureHookScript(button, "OnEnter", function(self)
            R.Libs.KeyBound:Set(self)
        end)
    end

    button:Configure()
    R.Modules.ButtonStyles:StyleActionButton(button)

    return button
end

ActionBarButtonMixin = {}

function ActionBarButtonMixin:Configure()
    local id = self:GetID()

    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")
end

function ActionBarButtonMixin:OnUpdate(elapsed)
    if self.stateDirty then
        self:UpdateState()
        self.stateDirty = nil
    end

    if self.flashDirty then
        self:UpdateFlash()
        self.flashDirty = nil
    end

    if self:IsFlashing() then
        local flashtime = self.flashtime
        flashtime = flashtime - elapsed

        if flashtime <= 0 then
            local overtime = -flashtime
            if overtime >= ATTACK_BUTTON_FLASH_TIME then
                overtime = 0
            end
            flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

            local flashTexture = self.Flash
            if flashTexture:IsShown() then
                flashTexture:Hide()
            else
                flashTexture:Show()
            end
        end

        self.flashtime = flashtime
    end

    if self.rangeTimer then
        self.rangeTimer = self.rangeTimer - elapsed

        if rangeTimer <= 0 then
            local valid = IsActionInRange(self.action)
            local checksRange = (valid ~= nil)
            self.checksRange = (valid ~= nil)
            self.inRange = self.checksRange and valid
            self:UpdateUsable()
            self.rangeTimer = TOOLTIP_UPDATE_TIME
        end
    end
end

function ActionBarButtonMixin:UpdateUsable()
    if self.checksRange and not self.inRange then
        self.icon.SetVertexColor(0.8, 0.1, 0.1)
    else
        local isUsable, notEnoughMana = IsUsableAction(self.action);
        if isUsable then
            self.icon:SetVertexColor(1.0, 1.0, 1.0)
        elseif notEnoughMana then
            self.icon:SetVertexColor(0.5, 0.5, 1.0)
        else
            self.icon:SetVertexColor(0.4, 0.4, 0.4)
        end
    end

    if R.isRetail then
        local isLevelLinkLocked = C_LevelLink.IsActionLocked(self.action)
        if not self.icon:IsDesaturated() then
            self.icon:SetDesaturated(isLevelLinkLocked);
        end

        if self.LevelLinkLockIcon then
            self.LevelLinkLockIcon:SetShown(isLevelLinkLocked);
        end
    end

    if self.HotKey:GetText() == RANGE_INDICATOR then
        if self.checksRange then
            self.HotKey:Show()
            if self.inRange then
                self.HotKey:SetVertexColor(LIGHTGRAY_FONT_COLOR:GetRGB())
            else
                self.HotKey:SetVertexColor(RED_FONT_COLOR:GetRGB())
            end
        else
            self.HotKey:Hide()
        end
    else
        if self.checksRange and not self.inRange then
            self.HotKey:SetVertexColor(RED_FONT_COLOR:GetRGB())
        else
            self.HotKey:SetVertexColor(LIGHTGRAY_FONT_COLOR:GetRGB())
        end
    end
end
