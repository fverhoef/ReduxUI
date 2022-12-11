--[[
# Element: Master Looter Indicator

Toggles the visibility of an indicator based on the unit's master looter status.

## Widget

ComboPointBar - Any UI widget.

## Notes

A default texture will be applied if the widget is a Texture and doesn't have a texture or a color set.

## Examples

    -- Position and size
    local ComboPointBar = self:CreateTexture(nil, 'OVERLAY')
    MasterLooterIndicator:SetSize(16, 16)
    MasterLooterIndicator:SetPoint('TOPRIGHT', self)

    -- Register it with oUF
    self.MasterLooterIndicator = MasterLooterIndicator
--]] local _, ns = ...
local oUF = ns.oUF

if oUF.isRetail then
    return
end

local COMBOFRAME_FADE_IN = 0.3
local COMBOFRAME_FADE_OUT = 0.5
local COMBOFRAME_HIGHLIGHT_FADE_IN = 0.4
local COMBOFRAME_SHINE_FADE_IN = 0.3
local COMBOFRAME_SHINE_FADE_OUT = 0.4
local COMBO_POINT_SIZE = 12
local COMBO_POINT_SPACING = 5

local function ShineFadeOut(comboPoint)
    UIFrameFadeOut(comboPoint.Shine, COMBOFRAME_SHINE_FADE_OUT)
end

local function ShineFadeIn(comboPoint)
    UIFrameFade(comboPoint.Shine, { mode = "IN", timeToFade = COMBOFRAME_SHINE_FADE_IN, finishedFunc = ShineFadeOut, finishedArg1 = comboPoint })
end

local function FillFadeIn(comboPoint)
    UIFrameFade(comboPoint.Fill, { mode = "IN", timeToFade = COMBOFRAME_HIGHLIGHT_FADE_IN, finishedFunc = ShineFadeIn, finishedArg1 = comboPoint })
end

local function Create(element, index)
    local comboPoint = CreateFrame("Frame", "$parentComboPoint" .. index, element)
    comboPoint:SetSize(element.size, element.size)

    comboPoint.Background = comboPoint:CreateTexture("BACKGROUND")
    comboPoint.Background:SetSize(12, 16)
    comboPoint.Background:SetPoint("TOPLEFT")
    comboPoint.Background:SetTexture([[Interface\ComboFrame\ComboPoint]])
    comboPoint.Background:SetTexCoord(0, 0.375, 0, 1)

    comboPoint.Fill = comboPoint:CreateTexture("ARTWORK")
    comboPoint.Fill:SetSize(8, 16)
    comboPoint.Fill:SetPoint("TOPLEFT", 2, 0)
    comboPoint.Fill:SetTexture([[Interface\ComboFrame\ComboPoint]])
    comboPoint.Fill:SetTexCoord(0.375, 0.5625, 0, 1)

    comboPoint.Shine = comboPoint:CreateTexture("OVERLAY")
    comboPoint.Shine:SetSize(14, 16)
    comboPoint.Shine:SetPoint("TOPLEFT", 0, 4)
    comboPoint.Shine:SetTexture([[Interface\ComboFrame\ComboPoint]])
    comboPoint.Shine:SetTexCoord(0.5625, 1, 0, 1)
    comboPoint.Shine:SetBlendMode("ADD")

    element.ComboPoints[index] = comboPoint

    --[[ Callback: ComboPointBar:PostCreateComboPoint()
	Called after a new combo point element has been created.

	* self          - the ComboPointBar element
	* comboPoint    - the new ComboPoint element
	--]]
    if element.PostCreateComboPoint then
        element:PostCreateComboPoint(comboPoint)
    end

    return comboPoint
end

local function UpdateMax(element)
    element.MaxComboPoints = UnitPowerMax(element.unit, Enum.PowerType.ComboPoints);

    for i = 1, element.MaxComboPoints do
        if not element.ComboPoints[i] then
            element:CreateComboPoint(i)
        end
    end

    for i, comboPoint in ipairs(element.ComboPoints) do
        comboPoint:Hide()
    end
end

local function Update(self, event, unit)
    if unit and unit ~= "player" then
        return
    end

    local element = self

    if event == "UNIT_MAXPOWER" or event == "PLAYER_ENTERING_WORLD" then
        UpdateMax(element)
    elseif event == "UNIT_ENTERED_VEHICLE" then
        element.unit = "vehicle"
        UpdateMax(element)
    elseif event == "UNIT_EXITED_VEHICLE" then
        element.unit = "player"
        UpdateMax(element)
    end

    if not element.MaxComboPoints then
        element:Hide()
        return
    end

    local comboPoints = GetComboPoints(element.unit, "target")
    if comboPoints > 0 then
        if not element:IsShown() then
            element:Show()
            UIFrameFadeIn(element, COMBOFRAME_FADE_IN)
        end

        for i, comboPoint in ipairs(element.ComboPoints) do
            if i <= comboPoints then
                if i > element.lastNumPoints then
                    FillFadeIn(comboPoint)
                end
            else
                comboPoint.Fill:SetAlpha(0)
                comboPoint.Shine:SetAlpha(0)
            end

            comboPoint:Show()
            comboPoint:ClearAllPoints()
            comboPoint:SetPoint("LEFT", i == 1 and self or element.ComboPoints[i - 1], i == 1 and "LEFT" or "RIGHT", i > 1 and element.spacing or 0, 0)
        end

        element:SetSize(element.MaxComboPoints * element.size + (element.MaxComboPoints - 1) * element.spacing, element.size)
    else
        for i, comboPoint in ipairs(element.ComboPoints) do
            comboPoint.Fill:SetAlpha(0)
            comboPoint.Shine:SetAlpha(0)
        end
        element:Hide()
    end
    element.lastNumPoints = comboPoints

    --[[ Callback: ComboPointBar:PostUpdate()
	Called after the element has been updated.

	* self    - the ComboPointBar element
	--]]
    if (element.PostUpdate) then
        return element:PostUpdate()
    end
end

local function Path(self, ...)
    --[[ Override: ComboPointBar.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
    return (self.Override or Update)(self, ...)
end

local function ForceUpdate(element)
    return Path(element.__owner, "ForceUpdate")
end

local function Enable(self, unit)
    local element = self.ComboPointBar
    if (element) then
        element.__owner = self
        element.ForceUpdate = ForceUpdate
        element.ComboPoints = {}
        element.CreateComboPoint = element.CreateComboPoint or Create
        element.unit = "player"
        element.size = element.size or COMBO_POINT_SIZE
        element.spacing = element.spacing or COMBO_POINT_SPACING

        element:RegisterEvent("PLAYER_TARGET_CHANGED")
        element:RegisterEvent("UNIT_POWER_FREQUENT")
        element:RegisterEvent("UNIT_MAXPOWER")
        element:RegisterEvent("PLAYER_ENTERING_WORLD")
        element:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
        element:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")

        element:SetScript("OnEvent", Path)

        return true
    end
end

local function Disable(self)
    local element = self.ComboPointBar
    if (element) then
        element:Hide()

        element:UnregisterAllEvents()
    end
end

oUF:AddElement("ComboPointBar", Path, Enable, Disable)
