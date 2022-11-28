local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionBar(id)
    local bar = CreateFrame("Frame", addonName .. "_Bar" .. id, UIParent, "SecureHandlerAttributeTemplate")
    bar.config = AB.config["actionBar" .. id]
    bar.defaults = AB.defaults["actionBar" .. id]
    bar.id = id
    _G.Mixin(bar, AB.ActionBarMixin)

    bar.buttons = {}
    for id = 1, 12 do
        bar.buttons[id] = AB:CreateActionBarButton(id, bar, bar.config.buttonType)
    end

    bar:SetAttribute("_onattributechanged", [[
        if name == "actionpage" then
            control:ChildUpdate("actionpage", value)
        end
    ]])

    bar:RegisterEvent("PLAYER_ENTERING_WORLD")
    bar:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    bar:RegisterEvent("UPDATE_BINDINGS")
    bar:RegisterEvent("GAME_PAD_ACTIVE_CHANGED")
    bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    bar:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    bar:RegisterEvent("PET_BAR_UPDATE")
    bar:RegisterUnitEvent("UNIT_FLAGS", "pet")
    bar:RegisterUnitEvent("UNIT_AURA", "pet")
    bar:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
    bar:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
    bar:RegisterEvent("SPELL_UPDATE_CHARGES")
    bar:RegisterEvent("UPDATE_INVENTORY_ALERTS")
    bar:RegisterEvent("PLAYER_TARGET_CHANGED")
    bar:RegisterEvent("TRADE_SKILL_SHOW")
    bar:RegisterEvent("TRADE_SKILL_CLOSE")
    if R.isRetail then
        bar:RegisterEvent("ARCHAEOLOGY_CLOSED")
    end
    bar:RegisterEvent("PLAYER_ENTER_COMBAT")
    bar:RegisterEvent("PLAYER_LEAVE_COMBAT")
    if R.isRetail then
        bar:RegisterEvent("START_AUTOREPEAT_SPELL")
        bar:RegisterEvent("STOP_AUTOREPEAT_SPELL")
    end
    bar:RegisterEvent("UNIT_ENTERED_VEHICLE")
    bar:RegisterEvent("UNIT_EXITED_VEHICLE")
    bar:RegisterEvent("COMPANION_UPDATE")
    bar:RegisterEvent("UNIT_INVENTORY_CHANGED")
    bar:RegisterEvent("LEARNED_SPELL_IN_TAB")
    bar:RegisterEvent("PET_STABLE_UPDATE")
    bar:RegisterEvent("PET_STABLE_SHOW")
    bar:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
    bar:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
    if R.isRetail then
        bar:RegisterEvent("UPDATE_SUMMONPETS_ACTION")
    end
    bar:RegisterEvent("LOSS_OF_CONTROL_ADDED")
    bar:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
    bar:RegisterEvent("SPELL_UPDATE_ICON")

    bar:SetScript("OnEvent", bar.OnEvent)

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
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

            button:SetAttribute("buttonlock", true)
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
        RegisterAttributeDriver(self, "actionpage", page)
    end
end

function AB.ActionBarMixin:OnEvent(event, ...)
    if event == "UNIT_INVENTORY_CHANGED" then
        local unit = ...
        if unit == "player" and self.tooltipOwner and GameTooltip:GetOwner() == self.tooltipOwner then
            self.tooltipOwner:SetTooltip()
        end
    else
        for _, button in pairs(self.buttons) do
            if HasAction(button.action) then
                button:OnEvent(event, ...)
            end
        end
    end
end
