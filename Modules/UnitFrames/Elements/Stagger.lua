local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateStagger()
    if not self.config.stagger.enabled then return end
    
    self.Stagger = CreateFrame('StatusBar', nil, self)
    self.Stagger:SetStatusBarTexture(UF.config.statusbars.classPower)
    self.Stagger:SetFrameLevel(self.Power:GetFrameLevel())
    self.Stagger:SetBackdrop({bgFile = R.Libs.SharedMedia:Fetch("background", "Solid")})
    self.Stagger:SetBackdropColor(0, 0, 0, 0.70)
    self.Stagger:SetSize(120, 20)
    self.Stagger:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
    self.Stagger:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 5)
    self.Stagger:CreateBackdrop({edgeFile = R.media.textures.edgeFiles.borderThickTooltip, edgeSize = 12})
    self.Stagger.Backdrop:SetOutside(self.Stagger, 3, 3)
    self.Stagger.Backdrop:SetFrameLevel(self.Stagger:GetFrameLevel() + 1)

    return self.Stagger
end

oUF:RegisterMetaFunction("CreateStagger", UF.CreateStagger)

function UF:ConfigureStagger()
    local config = self.config.stagger
    if not config.enabled then
        self:DisableElement("Stagger")
        return
    elseif not self.Stagger then
        self:CreateStagger()
    end

    self:EnableElement("Stagger")

    self.Stagger:SetSize(unpack(config.size))
    self.Stagger:SetStatusBarTexture(UF.config.statusbars.classPower)

    if config.smooth then
        R.Libs.SmoothStatusBar:SmoothBar(self.Stagger)
    else
        R.Libs.SmoothStatusBar:ResetBar(self.Stagger)
    end
end

oUF:RegisterMetaFunction("ConfigureStagger", UF.ConfigureStagger)
