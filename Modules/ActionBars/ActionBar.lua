local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionBar(id)
    local bar = CreateFrame("Frame", addonName .. "_Bar" .. id, UIParent, "SecureHandlerStateTemplate", id)
    bar.id = id
    bar.config = AB.config["actionBar" .. id]
    bar.defaults = AB.defaults["actionBar" .. id]
    _G.Mixin(bar, AB.ActionBarMixin)

    bar.buttons = {}
    for id = 1, 12 do
        bar.buttons[id] = bar:CreateButton(id)
    end

    bar:SetAttribute("_onstate-page", [[
        if newstate == "possess" or newstate == "11" then
            if HasVehicleActionBar() then
                newstate = GetVehicleBarIndex()
            elseif HasOverrideActionBar() then
                newstate = GetOverrideBarIndex()
            elseif HasTempShapeshiftActionBar() then
                newstate = GetTempShapeshiftBarIndex()
            elseif HasBonusActionBar() then
                newstate = GetBonusBarIndex()
            else
                newstate = 12
            end
        end

        self:SetAttribute("state", newstate)
        control:ChildUpdate("state", newstate)
	]])

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder(nil, 12, 3)
    bar:CreateShadow(nil, 12, 6)
    bar:CreateFader(bar.config.fader, bar.buttons)
    bar:CreateMover(L["Action Bar " .. id], bar.defaults.point)

    return bar
end

AB.ActionBarMixin = {}

function AB.ActionBarMixin:Configure()
    local visibleButtons = self.visibleButtons or self.config.buttons
    local buttonsPerRow = self.config.buttonsPerRow
    local width = self.config.buttonStyle.size
    local height = self.config.buttonStyle.size
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

            button:Configure()
        end
    end

    if self.visibility then
        RegisterStateDriver(self, "visibility", self.visibility)
    else
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

    local page = self.config.page
    if page then
        if self.id == 1 then
            page = string.format("[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] %d; [bar:2] 2;", GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex(), GetTempShapeshiftBarIndex())
            for pageNumber = 3, 6 do
                if AB:IsPageEnabled(pageNumber) then
                    page = page .. " [bar:" .. pageNumber .. "] " .. pageNumber .. ";"
                end
            end

            if R.PlayerInfo.class == "DRUID" then
                page = page .. "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 10; [bonusbar:3] 9; [bonusbar:4] 10;"
            elseif R.PlayerInfo.class == "EVOKER" then
                page = page .. "[bonusbar:1] 7;"
            elseif R.PlayerInfo.class == "PRIEST" then
                page = page .. "[bonusbar:1] 7;"
            elseif R.PlayerInfo.class == "ROGUE" then
                if R.isRetail then
                    page = page .. "[bonusbar:1] 7;"
                else
                    page = page .. "[bonusbar:1] 7; [bonusbar:2] 8;"
                end
            elseif R.PlayerInfo.class == "WARLOCK" and not R.isRetail then
                page = page .. "[form:1] 7;"
            elseif R.PlayerInfo.class == "WARRIOR" then
                page = page .. "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;"
            end

            page = page .. " [bonusbar:5] 11; 1"
        end
        RegisterStateDriver(self, "page", page)
    end
end

function AB.ActionBarMixin:CreateButton(id)
    local button = R.Libs.ActionButton:CreateButton(id, "$parentButton" .. id, self)
    button.header = button.header or self
    _G.Mixin(button, AB.ActionBarButtonMixin)

    button:SetState(0, "action", id)
    for page = 1, 18 do
        button:SetState(page, "action", (page - 1) * 12 + id)
    end

    button:Configure()

    return button
end

AB.ActionBarButtonMixin = {}

function AB.ActionBarButtonMixin:Configure()
    local config = self.header.config
    self:UpdateConfig({
        clickOnDown = config.buttonStyle.clickOnDown,
        flyoutDirection = config.buttonStyle.flyoutDirection,
        keyBoundTarget = config.buttonStyle.type .. self.id,
        showGrid = config.showGrid,
        colors = { range = { 0.8, 0.1, 0.1 }, mana = { 0.5, 0.5, 1.0 } },
        hideElements = { macro = config.buttonStyle.hideMacroText, hotkey = config.buttonStyle.hideKeybindText },
        text = {
            hotkey = { font = { font = config.buttonStyle.keybindFont, size = config.buttonStyle.keybindFontSize, flags = config.buttonStyle.keybindFontOutline } },
            count = { font = { font = config.buttonStyle.countFont, size = config.buttonStyle.countFontSize, flags = config.buttonStyle.countFontOutline } },
            macro = { font = { font = config.buttonStyle.macroFont, size = config.buttonStyle.macroFontSize, flags = config.buttonStyle.macroFontOutline } }
        }
    })

    self.HotKey:SetShadowOffset(config.buttonStyle.keybindFontShadow and 1 or 0, config.buttonStyle.keybindFontShadow and -1 or 0)
    self.Count:SetShadowOffset(config.buttonStyle.countFontShadow and 1 or 0, config.buttonStyle.countFontShadow and -1 or 0)
    self.Name:SetShadowOffset(config.buttonStyle.macroFontShadow and 1 or 0, config.buttonStyle.macroFontShadow and -1 or 0)

    self:SetAttribute("buttonlock", config.locked)
    self:SetAttribute("checkselfcast", config.buttonStyle.checkSelfCast)
    self:SetAttribute("checkfocuscast", config.buttonStyle.checkFocusCast)
    self:SetAttribute("checkmouseovercast", config.buttonStyle.checkMouseoverCast)

    self:ApplyStyle()
end

function AB.ActionBarButtonMixin:ApplyStyle()
    if not self.__styled then
        self.__styled = true

        self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        self.icon:SetInside(self, 2, 2)

        self.raisedContainer = CreateFrame("Frame", nil, self)
        self.raisedContainer:SetAllPoints()
        self.raisedContainer:SetFrameLevel(self:GetFrameLevel() + 1)

        self.cooldown:SetInside(self, 2, 2)
        self.cooldown:SetSwipeColor(0, 0, 0)

        self.Count:SetParent(self.raisedContainer)
        self.HotKey:SetParent(self.raisedContainer)
        self.Name:SetParent(self.raisedContainer)

        self.Border:ClearAllPoints()
        self.Border:SetAllPoints()
        self.Border:SetTexture(R.media.textures.buttons.equippedOverlay)
        AB:SecureHook(self.Border, "Show", self.Border_OnShow)
        AB:SecureHook(self.Border, "Hide", self.Border_OnHide)

        self:CreateBackdrop({ bgFile = R.media.textures.buttons.backdrop, edgeSize = 2, insets = { left = 2, right = 2, top = 2, bottom = 2 } })
    end

    self:SetNormalTexture(R.media.textures.buttons.border)
    local normalTexture = self:GetNormalTexture()
    normalTexture:SetOutside(self, 4, 4)
    normalTexture:SetTexCoord(0, 1, 0, 1)
    normalTexture:SetVertexColor(0.7, 0.7, 0.7)

    self:SetPushedTexture(R.media.textures.buttons.border)
    local pushedTexture = self:GetPushedTexture()
    pushedTexture:SetOutside(self, 4, 4)
    pushedTexture:SetTexCoord(0, 1, 0, 1)
    pushedTexture:SetVertexColor(1, 0.78, 0, 1)

    self:GetCheckedTexture():SetOutside(self, 2, 2)
    self:GetHighlightTexture():SetInside(self, 0, 0)

    if self.IsEquipped and self:IsEquipped() then
        self:GetNormalTexture():SetVertexColor(0, 0.8, 0)
    else
        self:GetNormalTexture():SetVertexColor(0.7, 0.7, 0.7)
    end
end

function AB.ActionBarButtonMixin:Border_OnShow()
    self:GetParent():ApplyStyle()
end

function AB.ActionBarButtonMixin:Border_OnHide()
    self:GetParent():ApplyStyle()
end
