local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF
local L = R.L

local MAX_RUNES = MAX_RUNES or 6
local RUNETYPE_BLOOD = 1
local RUNETYPE_FROST = 2
local RUNETYPE_UNHOLY = 3
local RUNETYPE_DEATH = 4
local RUNE_ICONS = {
    [RUNETYPE_BLOOD] = R.media.textures.icons.deathKnightBlood,
    [RUNETYPE_FROST] = R.media.textures.icons.deathKnightFrost,
    [RUNETYPE_UNHOLY] = R.media.textures.icons.deathKnightUnholy,
    [RUNETYPE_DEATH] = R.media.textures.icons.deathKnightDeath
}
local RUNE_COLORS = { [RUNETYPE_BLOOD] = { 1, 0, 0 }, [RUNETYPE_FROST] = { 0, 1, 1 }, [RUNETYPE_UNHOLY] = { 0, 0.5, 0 }, [RUNETYPE_DEATH] = { 0.8, 0.1, 1 } }
local RUNE_NAMES = { [1] = "BLOOD", [2] = "FROST", [3] = "UNHOLY", [4] = "DEATH" }

function UF:CreateRunes()
    if not self.config.runes.enabled then
        return
    end

    self.RunesHolder = CreateFrame("Frame", "$parentRunesHolder", self)
    self.RunesHolder:SetFrameLevel(self.Power:GetFrameLevel())
    self.RunesHolder.config = self.config.runes
    self.RunesHolder.defaults = self.defaults.runes
    self.RunesHolder:CreateMover(L["Runes"], self.defaults.runes.point)

    self.RuneBars = {}
    for i = 1, MAX_RUNES do
        local rune = CreateFrame("StatusBar", "$parentBar" .. i, self.RunesHolder, BackdropTemplateMixin and "BackdropTemplate")
        rune:SetStatusBarTexture(UF.config.statusbars.classPower)
        rune:SetFrameLevel(self.Power:GetFrameLevel())
        rune:SetBackdrop({ bgFile = R.Libs.SharedMedia:Fetch("background", "Solid") })
        rune:SetBackdropColor(0, 0, 0, 0.70)
        rune:SetScript("OnEnter", UF.Rune_OnEnter)
        rune:SetScript("OnLeave", UF.Rune_OnLeave)

        rune:CreateBorder(nil, 8, 2, rune:GetFrameLevel() + 1)
        rune:CreateInlay()

        self.RuneBars[i] = rune
    end

    self.RuneIcons = {}
    for i = 1, MAX_RUNES do
        local rune = CreateFrame("Frame", "$parentIcon" .. i, self.RunesHolder)
        rune.Texture = rune:CreateTexture("$parentTexture", "ARTWORK")
        rune.Texture:SetPoint("TOPLEFT", -2, 1)
        rune.Texture:SetPoint("BOTTOMRIGHT", 3, -4)
        rune.Cooldown = CreateFrame("Cooldown", "$parentCooldown", rune, "CooldownFrameTemplate")
        rune.Cooldown:SetAllPoints()
        rune.Cooldown:SetDrawEdge(true)
        rune.Cooldown:SetUseCircularEdge(true)
        rune.Cooldown:SetSwipeTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
        rune.Cooldown:SetSwipeColor(0, 0, 0, 0.7)
        rune:SetScript("OnEnter", UF.Rune_OnEnter)
        rune:SetScript("OnLeave", UF.Rune_OnLeave)

        rune.Value = 1
        rune.GetMinMaxValues = function()
            return rune.MinValue, rune.MaxValue
        end
        rune.SetMinMaxValues = function(rune, min, max)
            rune.MinValue = min
            rune.MaxValue = max
        end
        rune.GetValue = function(rune)
            return rune.Value
        end
        rune.SetValue = function(rune, value)
            rune.Value = value
        end
        rune.SetStatusBarColor = function(rune, r, g, b)
            rune.Texture:SetVertexColor(r, g, b)
        end

        self.RuneIcons[i] = rune
    end

    self.Runes = {}
    self.Runes.PostUpdate = UF.Runes_PostUpdate
    self.Runes.PostUpdateColor = UF.Runes_PostUpdate

    return self.Runes
end

oUF:RegisterMetaFunction("CreateRunes", UF.CreateRunes)

function UF:ConfigureRunes()
    local config = self.config.runes
    if not config.enabled then
        self:DisableElement("Runes")
        if self.RunesHolder then
            self.RunesHolder.Mover:Lock(true)
        end
        return
    elseif not self.Runes then
        self:CreateRunes()
    end

    self:DisableElement("Runes")
    for i = 1, MAX_RUNES do
        self.Runes[i] = config.style == UF.RuneStyles.Bars and self.RuneBars[i] or self.RuneIcons[i]
        self.RuneBars[i]:SetShown(config.style == UF.RuneStyles.Bars)
        self.RuneIcons[i]:SetShown(config.style == UF.RuneStyles.Icons)
    end
    self:EnableElement("Runes")

    self.RunesHolder:SetSize(MAX_RUNES * config.size[1] + (MAX_RUNES - 1) * config.spacing, config.size[2])

    if config.detached then
        self.RunesHolder:SetParent(UIParent)
        self.RunesHolder.Mover:Unlock()
    else
        self.RunesHolder:SetParent(self)
        self.RunesHolder.Mover:Lock(true)
        config.point[5] = nil
    end
    self.RunesHolder:ClearAllPoints()
    self.RunesHolder:SetNormalizedPoint(config.point)

    for i, rune in ipairs(self.Runes) do
        rune:SetSize(config.size[1], config.size[2])

        if rune:IsObjectType("StatusBar") then
            rune:SetStatusBarTexture(UF.config.statusbars.classPower)
            rune.Border:SetShown(config.border)
            rune.Inlay:SetShown(config.inlay)

            if config.smooth then
                R.Libs.SmoothStatusBar:SmoothBar(rune)
            else
                R.Libs.SmoothStatusBar:ResetBar(rune)
            end
        end

        if i == 1 then
            rune:SetPoint("BOTTOMLEFT", self.RunesHolder, "BOTTOMLEFT")
        else
            rune:SetPoint("LEFT", self.Runes[i - 1], "RIGHT", config.spacing, 0)
        end
    end

    self.Runes:ForceUpdate()
end

oUF:RegisterMetaFunction("ConfigureRunes", UF.ConfigureRunes)

local runemap = { 1, 2, 3, 4, 5, 6 }

function UF:Runes_PostUpdate()
    if self.sortOrder == "asc" then
        table.sort(runemap, ascSort)
    elseif self.sortOrder == "desc" then
        table.sort(runemap, descSort)
    else
        table.sort(runemap)
    end

    for index, runeID in next, runemap do
        rune = self[index]
        if not rune then
            break
        end

        local runeType = GetRuneType(runeID)
        local runeColor = RUNE_COLORS[runeType]

        if rune:IsObjectType("StatusBar") then
            rune:SetStatusBarColor(unpack(runeColor))
        else
            local start, duration, runeReady = GetRuneCooldown(runeID)
            rune.Cooldown:SetCooldown(start, duration)

            rune.Texture:SetTexture(RUNE_ICONS[runeType])
            rune.Texture:SetVertexColor(1, 1, 1, 1)
        end

        rune.tooltip = _G["COMBAT_TEXT_RUNE_" .. RUNE_NAMES[runeType]]
    end
end

function UF:Rune_OnEnter()
    if self.tooltip then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.tooltip)
        GameTooltip:Show()
    end
end

function UF:Rune_OnLeave()
    GameTooltip:Hide()
end
