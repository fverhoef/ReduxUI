local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

local Buttons = {}
local IgnoreButton = {
    "MinimapButtonFrameToggleButton", "HelpOpenWebTicketButton", "MiniMapVoiceChatFrame", "TimeManagerClockButton", "BattlefieldMinimap", "ButtonCollectFrame", "GameTimeFrame",
    "QueueStatusMinimapButton", "GarrisonLandingPageMinimapButton", "MiniMapMailFrame", "MinimapZoneTextButton", "MinimapToggleButton", "MiniMapTracking", "MinimapZoomIn", "MinimapZoomOut",
    "RecipeRadarMinimapButtonFrame"
}
local GenericIgnore = {
    "Archy", "GatherMatePin", "GatherNote", "GuildInstance", "HandyNotesPin", "MiniMap", "Spy_MapNoteList_mini", "ZGVMarker", "poiMinimap", "GuildMap3Mini", "LibRockConfig-1.0_MinimapButton",
    "NauticusClassicMiniIcon", "NauticusMiniIcon", "WestPointer", "Cork", "DugisArrowMinimapPoint", "QuestieFrame"
}
local PartialIgnore = { "Node", "Note", "Pin", "POI" }
local UnrulyButtons = { "WIM3MinimapButton", "RecipeRadar_MinimapButton" }
local ButtonFunctions = { "SetParent", "ClearAllPoints", "SetPoint", "SetSize", "SetScale", "SetFrameStrata", "SetFrameLevel" }

local function LockButton(button)
    for _, func in pairs(ButtonFunctions) do
        button[func] = function()
        end
    end
end

local function UnlockButton(button)
    for _, func in pairs(ButtonFunctions) do
        button[func] = nil
    end
end

local function SkipButton(button)
    local name = button.GetName and button:GetName()
    if not name or tContains(IgnoreButton, name) then
        return true
    end
    for i = 1, #GenericIgnore do
        if string.sub(name, 1, string.len(GenericIgnore[i])) == GenericIgnore[i] then
            return true
        end
    end
    for i = 1, #PartialIgnore do
        if string.find(name, PartialIgnore[i]) ~= nil then
            return true
        end
    end

    return false
end

local function GrabMinimapButton(button)
    if (not button) or button.IsSkinned or SkipButton(button) then
        return
    end

    table.insert(Buttons, button)

    return true
end

local function GrabChildren(frame)
    local children = { frame:GetChildren() }
    for i, object in ipairs(children) do
        local name = object:GetName()
        local width = object:GetWidth()
        if name and width > 15 and width < 60 and (object:IsObjectType("Button") or object:IsObjectType("Frame")) then
            if GrabMinimapButton(object) then
                grabbedAnyButtons = true
            end
        end
    end

    return grabbedAnyButtons
end

local function GrabMinimapButtons()
    if (InCombatLockdown() or C_PetBattles and C_PetBattles.IsInBattle()) then
        return
    end

    for _, button in pairs(UnrulyButtons) do
        if _G[button] then
            _G[button]:SetParent(Minimap)
        end
    end

    local grabbedAnyButtons = GrabChildren(Minimap)
    grabbedAnyButtons = GrabChildren(MinimapBackdrop) or grabbedAnyButtons
    grabbedAnyButtons = GrabChildren(MinimapCluster) or grabbedAnyButtons

    if grabbedAnyButtons then
        MinimapButtonFrame:Update()
    end
end

ButtonFrameMixin = {}

function ButtonFrameMixin:OnLoad()
    self:CreateBackdrop({ bgFile = R.media.textures.blank })
    self:CreateBorder()
    self.Buttons = Buttons
    GrabMinimapButtons()
    MM:ScheduleRepeatingTimer(GrabMinimapButtons, 1)
end

function ButtonFrameMixin:Update()
    local spacing = MM.config.buttonFrame.buttonSpacing or 2
    local iconSize = MM.config.buttonFrame.iconSize or 27

    local columnCount, rowCount = 1, 1
    local anchor, relativeColumnAnchor, relativeRowAnchor, dirMult = "TOPRIGHT", "TOPLEFT", "BOTTOMRIGHT", -1
    local actualWidth, availableWidth = 0, self:GetWidth()
    local previousButton, previousRowFirstButton

    for _, button in pairs(Buttons) do
        if button:IsVisible() then
            actualWidth = columnCount * iconSize + (columnCount - 1) * spacing

            if actualWidth > availableWidth then
                columnCount, rowCount = 1, rowCount + 1
            end

            UnlockButton(button)

            button:SetParent(self)
            button:ClearAllPoints()
            if columnCount == 1 and rowCount == 1 then
                button:SetPoint(anchor, self, anchor, dirMult * spacing, -spacing)
            elseif columnCount == 1 and rowCount > 1 then
                button:SetPoint(anchor, previousRowFirstButton or self, relativeRowAnchor, 0, -spacing)
            else
                button:SetPoint(anchor, previousButton, relativeColumnAnchor, dirMult * spacing, 0)
            end

            button:SetSize(iconSize, iconSize)
            button:SetScale(1)
            button:SetFrameStrata("MEDIUM")
            button:SetFrameLevel(self:GetFrameLevel() + 1)
            button:SetScript("OnDragStart", nil)
            button:SetScript("OnDragStop", nil)

            LockButton(button)

            previousButton = button
            if columnCount == 1 then
                previousRowFirstButton = button
            end

            columnCount = columnCount + 1
        end
    end

    self.Backdrop:SetShown(MM.config.buttonFrame.showBorder)
    self.Border:SetShown(MM.config.buttonFrame.showBorder)
    self:SetHeight(2 * spacing + (iconSize * rowCount) + (spacing * (rowCount - 1)))

    if MM.Config then
        self:CreateFader(MM.config.buttonFrame.fader, self.Buttons)
    end
end

function ButtonFrameMixin:Toggle()
    if self.Faded then
        self:FadeIn()
        MM.config.buttonFrame.collapsed = false
    elseif not self:IsShown() then
        self:Show()
        MM.config.buttonFrame.collapsed = false
    else
        self:Hide()
        MM.config.buttonFrame.collapsed = true
    end
    self:Update()
end

ButtonFrameToggleButtonMixin = {}

function ButtonFrameToggleButtonMixin:OnEnter()
    self:UpdateTooltip()
end

function ButtonFrameToggleButtonMixin:OnLeave()
    GameTooltip:Hide()
end

function ButtonFrameToggleButtonMixin:OnClick()
    self:UpdateTooltip()
    MinimapButtonFrame:Toggle()
end

function ButtonFrameToggleButtonMixin:UpdateTooltip()
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(L["Minimap"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    GameTooltip:AddLine(L["Toggle Minimap Buttons"], 1, 1, 1)
    GameTooltip:Show()
end
