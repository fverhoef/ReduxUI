local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

local Buttons = {}
local IgnoreButton = {
    "HelpOpenWebTicketButton", "MiniMapVoiceChatFrame", "TimeManagerClockButton", "BattlefieldMinimap", "ButtonCollectFrame", "GameTimeFrame", "QueueStatusMinimapButton",
    "GarrisonLandingPageMinimapButton", "MiniMapMailFrame", "MinimapZoneTextButton", "MinimapToggleButton", "MiniMapTracking", "MinimapZoomIn", "MinimapZoomOut", "RecipeRadarMinimapButtonFrame"
}
local GenericIgnore = {
    "Archy", "GatherMatePin", "GatherNote", "GuildInstance", "HandyNotesPin", "MiniMap", "Spy_MapNoteList_mini", "ZGVMarker", "poiMinimap", "GuildMap3Mini", "LibRockConfig-1.0_MinimapButton",
    "NauticusClassicMiniIcon", "NauticusMiniIcon", "WestPointer", "Cork", "DugisArrowMinimapPoint", "QuestieFrame"
}
local PartialIgnore = {"Node", "Note", "Pin", "POI"}
local UnrulyButtons = {"WIM3MinimapButton", "RecipeRadar_MinimapButton"}
local ButtonFunctions = {"SetParent", "ClearAllPoints", "SetPoint", "SetSize", "SetScale", "SetFrameStrata", "SetFrameLevel"}
local RemoveTextureID = {[136467] = true, [136468] = true, [130924] = true}
local RemoveTextureFile = {["interface\\minimap\\ui-minimap-border"] = true, ["interface\\minimap\\ui-minimap-background"] = true}

local function LockButton(button) for _, func in pairs(ButtonFunctions) do button[func] = function() end end end

local function UnlockButton(button) for _, func in pairs(ButtonFunctions) do button[func] = nil end end

local function SkipButton(button)
    local name = button.GetName and button:GetName()
    if not name or tContains(IgnoreButton, name) then return true end
    for i = 1, #GenericIgnore do if string.sub(name, 1, string.len(GenericIgnore[i])) == GenericIgnore[i] then return true end end
    for i = 1, #PartialIgnore do if string.find(name, PartialIgnore[i]) ~= nil then return true end end

    return false
end

local function RemoveTexture(texture)
    if RemoveTextureFile[texture] then
        return true
    elseif string.find(texture, "interface/characterframe") then
        return true
    elseif string.find(texture, "interface/minimap") then
        return true
    elseif string.find(texture, "interface/minimap/tracking") then
        return true
    elseif string.find(texture, "border") then
        return true
    elseif string.find(texture, "background") then
        return true
    elseif string.find(texture, "alphamask") then
        return true
    elseif string.find(texture, "highlight") then
        return true
    end

    return false
end

local function SkinMinimapButton(button)
    if (not button) or button.isSkinned or SkipButton(button) then return end

    local regions = {button:GetRegions()}
    for i, region in ipairs(regions) do
        if region.IsObjectType and region:IsObjectType("Texture") then
            local textureID = region.GetTextureFileID and region:GetTextureFileID()
            local texture = string.lower(tostring(region:GetTexture()))

            if not region.__texture then
                region.__alpha = region:GetAlpha()
                region.__textureID = textureID
                region.__texture = texture
                region.__setPoint = region.SetPoint
                region.__point = {region:GetPoint()}
                region.__setTexCoord = region.SetTexCoord
                region.__texCoords = {region:GetTexCoord()}
            end

            region:SetMask(nil)
            region:SetAlpha(region.__alpha)
            region:SetTexture(region.__texture)
            region:ClearAllPoints()
            region.SetPoint = region.__setPoint
            region:SetPoint(unpack(region.__point))
            region.SetTexCoord = region.__setTexCoord
            region:SetTexCoord(unpack(region.__texCoords))

            if textureID == 136430 or texture == [[interface\minimap\minimap-trackingBorder]] then
                region:ClearAllPoints()
                region:SetAllPoints()
                region:SetTexture(R.media.textures.minimap.minimapButtonBorder)
            elseif textureID == 136477 or texture == [[interface\minimap\ui-minimap-zoombutton-highlight]] then
                region:ClearAllPoints()
                region:SetAllPoints()
            elseif RemoveTextureID[region.__textureID] or RemoveTexture(region.__texture) then
                region:SetTexture()
                region:SetAlpha(0)
            else
                region:ClearAllPoints()
                region:SetInside(nil, 3, 3)
                region.SetPoint = function() return end

                -- replace icons that don't display properly
                -- TODO: find out why masking icons with alpha gives a white background
                if name == "LibDBIcon10_DBM" then
                    region:SetTexture([[Interface\Icons\INV_Helmet_01]])
                elseif name == "LibDBIcon10_Leatrix_Plus" then
                    region:SetTexture([[Interface\Icons\INV_Staff_20]])
                end

                region:SetTexCoord(0, 1, 0, 1)
                region.SetTexCoord = function() return end
                region:SetMask([[Interface\CharacterFrame\TempPortraitAlphaMask]])
            end
        end
    end

    button.isSkinned = true
end

local function GrabMinimapButton(button)
    if (not button) or button.isSkinned or SkipButton(button) then return end

    SkinMinimapButton(button)
    table.insert(Buttons, button)

    return true
end

local function GrabChildren(frame)
    local children = {frame:GetChildren()}
    for i, object in ipairs(children) do
        local name = object:GetName()
        local width = object:GetWidth()
        if name and width > 15 and width < 60 and (object:IsObjectType("Button") or object:IsObjectType("Frame")) then if GrabMinimapButton(object) then grabbedAnyButtons = true end end
    end

    return grabbedAnyButtons
end

local function GrabMinimapButtons()
    if (InCombatLockdown() or C_PetBattles and C_PetBattles.IsInBattle()) then return end

    for _, button in pairs(UnrulyButtons) do if _G[button] then _G[button]:SetParent(Minimap) end end

    local grabbedAnyButtons = GrabChildren(Minimap)
    grabbedAnyButtons = GrabChildren(MinimapBackdrop) or grabbedAnyButtons
    grabbedAnyButtons = GrabChildren(MinimapCluster) or grabbedAnyButtons

    if grabbedAnyButtons then Minimap.ButtonFrame:Update() end
end

ButtonFrameMixin = {}

function ButtonFrameMixin:Update()
    local spacing = MM.config.buttonFrame.buttonSpacing or 2
    local iconSize = MM.config.buttonFrame.iconSize or 27

    local columnCount, rowCount = 1, 1
    local anchor, relativeColumnAnchor, relativeRowAnchor, dirMult = "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", 1
    local actualWidth, availableWidth = 0, self:GetWidth()
    local previousButton, previousRowFirstButton

    for _, button in pairs(Buttons) do
        if button:IsVisible() then
            actualWidth = columnCount * iconSize + (columnCount - 1) * spacing

            if actualWidth > availableWidth then columnCount, rowCount = 1, rowCount + 1 end

            SkinMinimapButton(button)
            UnlockButton(button)

            button:SetParent(self)
            button:ClearAllPoints()
            if columnCount == 1 and rowCount == 1 then
                button:SetPoint(anchor, self, anchor, spacing, -spacing)
            elseif columnCount == 1 and rowCount > 1 then
                button:SetPoint(anchor, previousRowFirstButton or self, relativeRowAnchor, 0, -spacing)
            else
                button:SetPoint(anchor, previousButton, relativeColumnAnchor, spacing, 0)
            end

            button:SetSize(iconSize, iconSize)
            button:SetScale(1)
            button:SetFrameStrata("MEDIUM")
            button:SetFrameLevel(self:GetFrameLevel() + 1)
            button:SetScript("OnDragStart", nil)
            button:SetScript("OnDragStop", nil)

            LockButton(button)

            previousButton = button
            if columnCount == 1 then previousRowFirstButton = button end

            columnCount = columnCount + 1
        end
    end

    self:SetHeight(2 * spacing + (iconSize * rowCount) + (spacing * (rowCount - 1)))
end

function ButtonFrameMixin:Toggle()
    if self.ToggleButton:GetChecked() then
        self:Show()
        self.ToggleButton:SetNormalTexture([[Interface\BUTTONS\Arrow-Up-Up]])
        self.ToggleButton:SetPushedTexture([[Interface\BUTTONS\Arrow-Up-Down]])
        self.ToggleButton:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -8, -1)
        MM.config.buttonFrame.collapsed = false
    else
        self:Hide()
        self.ToggleButton:SetNormalTexture([[Interface\BUTTONS\Arrow-Down-Up]])
        self.ToggleButton:SetPushedTexture([[Interface\BUTTONS\Arrow-Down-Down]])
        self.ToggleButton:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -8, -8)
        MM.config.buttonFrame.collapsed = true
    end
    self:Update()
end

function MM:CreateButtonFrame()
    Minimap.ButtonFrame = CreateFrame("Frame", "MinimapButtonFrame", UIParent)
    Minimap.ButtonFrame:Hide()
    Minimap.ButtonFrame:SetFrameStrata("MEDIUM")
    Minimap.ButtonFrame:SetFrameLevel(1)
    Minimap.ButtonFrame:EnableMouse(true)
    -- Minimap.ButtonFrame:CreateBorder()

    _G.Mixin(Minimap.ButtonFrame, ButtonFrameMixin)

    MM:CreateButtonFrameToggleButton()

    -- TODO: check if it's possible to use events rather than a timed update
    GrabMinimapButtons()
    MM:ScheduleRepeatingTimer(GrabMinimapButtons, 1)
end
