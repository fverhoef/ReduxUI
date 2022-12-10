local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

local ELEMENTS = { "EARTH", "FIRE", "WATER", "AIR", "SUMMON", "RECALL" }

function AB:CreateTotemBar()
    if R.isRetail or R.PlayerInfo.class ~= "SHAMAN" or not AB.config.totemBar.enabled then
        return
    end

    local bar = _G.MultiCastActionBarFrame
    bar:SetParent(UIParent)
    bar:Show()
    bar.config = AB.config.totemBar
    bar.defaults = AB.defaults.totemBar
    bar.buttons = {}
    _G.Mixin(bar, AB.TotemBarMixin)

    bar:SetScript("OnShow", nil)
    bar:SetScript("OnHide", nil)
    bar:SetScript("OnUpdate", nil)

    bar.ignoreFramePositionManager = true
    bar:SetAttribute("ignoreFramePositionManager", true)
    UIPARENT_MANAGED_FRAME_POSITIONS[bar:GetName()] = nil

    for i = 1, 4 do
        bar:AddButton(_G["MultiCastSlotButton" .. i], i)
    end
    bar:AddButton(MultiCastSummonSpellButton, 5)
    bar:AddButton(MultiCastRecallSpellButton, 6)
    for i = 1, 3 do
        for j = 1, 4 do
            bar:AddButton(_G["MultiCastActionButton" .. (j + (i - 1) * 4)], j)
        end
    end

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateMover(L["Totem Bar"], bar.defaults.point)
    bar:CreateFader(bar.config.fader, bar.buttons)

    AB:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        _G.MultiCastActionBarFrame:Configure()
    end)
    AB:SecureHook("MultiCastActionBarFrame_Update", AB.TotemBarMixin.Configure)
    AB:SecureHook("MultiCastActionButton_Update", AB.TotemBarButtonMixin.Configure)
    AB:SecureHook("MultiCastSlotButton_Update", AB.TotemBarButtonMixin.Configure)

    _G.ActionBarButtonEventsFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
    _G.ActionBarButtonEventsFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")

    return bar
end

AB.TotemBarMixin = {}

function AB.TotemBarMixin:Configure()
    self:ClearAllPoints()
    self:SetNormalizedPoint(self.config.point)

    self.Backdrop:SetShown(self.config.backdrop)
    self.Border:SetShown(self.config.border)
    self.Shadow:SetShown(self.config.shadow)
    self.Mover:Unlock()

    MultiCastSummonSpellButton:ClearAllPoints()
    MultiCastSummonSpellButton:SetPoint("BOTTOMLEFT", MultiCastActionBarFrame, "BOTTOMLEFT", 0, 0)

    MultiCastSlotButton1:ClearAllPoints()
    MultiCastSlotButton1:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", self.config.columnSpacing, 0)
    MultiCastSlotButton2:SetPoint("LEFT", MultiCastSlotButton1, "RIGHT", self.config.columnSpacing, 0)
    MultiCastSlotButton3:SetPoint("LEFT", MultiCastSlotButton2, "RIGHT", self.config.columnSpacing, 0)
    MultiCastSlotButton4:SetPoint("LEFT", MultiCastSlotButton3, "RIGHT", self.config.columnSpacing, 0)

    MultiCastRecallSpellButton:ClearAllPoints()
    MultiCastRecallSpellButton:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", self.config.columnSpacing, 0)

    for i = 1, 3 do
        for j = 1, 4 do
            local actionButton = _G["MultiCastActionButton" .. (j + (i - 1) * 4)]
            local slotButton = _G["MultiCastSlotButton" .. j]
            actionButton:ClearAllPoints()
            actionButton:SetPoint("CENTER", slotButton, "CENTER")
        end
    end

    for _, button in ipairs(self.buttons) do
        button:SetNormalizedSize(self.config.buttonStyle.size)
        button:Configure()
    end
end

function AB.TotemBarMixin:AddButton(button, element)
    if not button then
        return
    end

    button.element = ELEMENTS[element]
    _G.Mixin(button, AB.TotemBarButtonMixin)
    -- TODO: KeyBound support

    table.insert(self.buttons, button)
end

AB.TotemBarButtonMixin = {}

function AB.TotemBarButtonMixin:Configure()
    self:ApplyStyle()
end

function AB.TotemBarButtonMixin:ApplyStyle()
    if not self.__styled then
        self.__styled = true

        local buttonName = self:GetName()

        self.cooldown = _G[buttonName .. "Cooldown"]
        self.highlight = _G[buttonName .. "Highlight"]
        self.icon = _G[buttonName .. "Icon"]

        if self.icon then
            self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            self.icon:SetInside(self, 2, 2)
        end

        if self.cooldown then
            self.cooldown:SetInside(self, 2, 2)
            self.cooldown:SetSwipeColor(0, 0, 0)
        end

        if self.overlayTex then
            self.overlayTex:SetTexture(R.media.textures.buttons.border)
            self.overlayTex:SetOutside(self, 3, 3)
        end

        if self.highlight then
            self.highlight:SetTexture(R.media.textures.buttons.border)
            self.highlight:SetTexCoord(0, 1, 0, 1)
            self.highlight:SetVertexColor(unpack(AB.config.totemBar.colors[self.element]))
            self.highlight:SetOutside(self, 3, 3)
        end
    end

    if self.icon then
        self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    end
    if self.overlayTex then
        self.overlayTex:SetTexCoord(0, 1, 0, 1)
        self.overlayTex:SetVertexColor(unpack(AB.config.totemBar.colors[self.element]))
    end
end
