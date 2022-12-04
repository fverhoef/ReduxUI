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
        bar.buttons[id] = AB:CreateActionBarButton(id, bar, bar.config.buttonType)
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
            page = string.format("[overridebar] %d; [vehicleui] %d; [possessbar] %d;", GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex())
            page = page .. " [shapeshift] 13; [bar:2] 2;"
            for pageNumber = 3, 6 do
                if AB:IsPageEnabled(pageNumber) then
                    page = page .. " [bar:" .. pageNumber .. "] " .. pageNumber .. ";"
                end
            end

            if R.PlayerInfo.class == "DRUID" then
                page = page .. "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:3] 9; [bonusbar:4] 10;"
            elseif R.PlayerInfo.class == "ROGUE" then
                page = page .. "[bonusbar:1] 7;"
            end

            page = page .. " [form] 1; 1"
        end
        RegisterStateDriver(self, "page", page)
    end
end

function AB:CreateActionBarButton(id, parent, buttonType)
    local button = R.Libs.ActionButton:CreateButton(id, "$parentButton" .. id, parent)
    button.buttonType = buttonType
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
    self:UpdateConfig({ clickOnDown = config.clickOnDown, flyoutDirection = config.flyoutDirection, keyBoundTarget = self.buttonType .. self.id, showGrid = config.showGrid })

    self:SetAttribute("buttonlock", config.locked)
    self:SetAttribute("checkselfcast", config.checkSelfCast)
    self:SetAttribute("checkfocuscast", config.checkFocusCast)
    self:SetAttribute("checkmouseovercast", config.checkMouseoverCast)

    R.Modules.ButtonStyles:StyleActionButton(self)
end
