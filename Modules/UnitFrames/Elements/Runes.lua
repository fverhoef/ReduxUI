local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local MAX_RUNES = MAX_RUNES or 6

function UF:CreateRunes()
    if not self.config.runes.enabled then return end

    self.RunesHolder = CreateFrame("Frame", "$parentRunesHolder", self)
    self.RunesHolder:SetFrameLevel(self.Power:GetFrameLevel())
    self.RunesHolder:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
    self.RunesHolder:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 5)

    self.Runes = {}
    for i = 1, MAX_RUNES do
        local rune = CreateFrame("StatusBar", nil, self.RunesHolder, BackdropTemplateMixin and "BackdropTemplate")
        rune:SetStatusBarTexture(UF.config.statusbars.classPower)
        rune:SetFrameLevel(self.Power:GetFrameLevel())
        rune:SetBackdrop({bgFile = R.Libs.SharedMedia:Fetch("background", "Solid")})
        rune:SetBackdropColor(0, 0, 0, 0.70)

        rune:CreateBackdrop({edgeFile = R.media.textures.edgeFiles.borderThickTooltip, edgeSize = 12})
        rune.Backdrop:SetOutside(rune, 3, 3)
        rune.Backdrop:SetFrameLevel(rune:GetFrameLevel() + 2)

        rune:CreateInlay({edgeFile = R.media.textures.edgeFiles.inlay, edgeSize = 12})
        rune.Inlay:SetOutside(rune, 6, 6)
        rune.Inlay:SetFrameLevel(rune:GetFrameLevel() + 1)

        self.Runes[i] = rune
    end

    return self.Runes
end

oUF:RegisterMetaFunction("CreateRunes", UF.CreateRunes)

function UF:ConfigureRunes()
    local config = self.config.runes
    if not config.enabled then
        self:DisableElement("Runes")
        return
    elseif not self.Runes then
        self:CreateRunes()
    end

    self:EnableElement("Runes")

    self.RunesHolder:SetSize(unpack(config.size))

    local holderWidth = self.RunesHolder:GetWidth()
    local runeWidth = (holderWidth - (math.max(0, MAX_RUNES - 1)) * config.spacing) / MAX_RUNES

    for i, rune in ipairs(self.Runes) do
        rune:SetSize(runeWidth, config.size[2])
        rune:SetStatusBarTexture(UF.config.statusbars.classPower)
        if i == 1 then
            rune:SetPoint("BOTTOMLEFT", self.RunesHolder, "BOTTOMLEFT")
        else
            rune:SetPoint("LEFT", self.Runes[i - 1], "RIGHT", config.spacing, 0)
        end

        if config.smooth then
            R.Libs.SmoothStatusBar:SmoothBar(rune)
        else
            R.Libs.SmoothStatusBar:ResetBar(rune)
        end
    end
end

oUF:RegisterMetaFunction("ConfigureRunes", UF.ConfigureRunes)
