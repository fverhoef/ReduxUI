local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateAuraWatch()
    if not self.config.auraWatch.enabled then return end

    self.AuraWatch = CreateFrame("Frame", "$parentAuraWatch", self)
    self.AuraWatch:SetParent(self.Overlay)
    self.AuraWatch.presentAlpha = 1
    self.AuraWatch.missingAlpha = 0
    self.AuraWatch.strictMatching = true
    self.AuraWatch.PostCreateIcon = UF.AuraWatch_PostCreateIcon
    self.AuraWatch.PostUpdateIcon = UF.AuraWatch_PostUpdateIcon
    R:SetInside(self.AuraWatch, self.Health)

    return self.AuraWatch
end

oUF:RegisterMetaFunction("CreateAuraWatch", UF.CreateAuraWatch)

function UF:ConfigureAuraWatch()
    local config = self.config.auraWatch
    if not config.enabled then
        self:DisableElement("AuraWatch")
        return
    elseif not self.AuraWatch then
        self:CreateAuraHighlight()
    end

    self:EnableElement("AuraWatch")
end

oUF:RegisterMetaFunction("ConfigureAuraWatch", UF.ConfigureAuraWatch)

function UF:AuraWatch_PostCreateIcon(button) end

function UF:AuraWatch_PostUpdateIcon(_, button)
    local settings = self.watched[button.spellID]
    if not settings then return end

    local onlyText = settings.style == "timerOnly"
    local colorIcon = settings.style == "coloredIcon"
    local textureIcon = settings.style == "texturedIcon"

    if (colorIcon or textureIcon) and not button.icon:IsShown() then
        button.icon:Show()
        button.cd:SetDrawSwipe(true)
    elseif onlyText and button.icon:IsShown() then
        button.icon:Hide()
        button.cd:SetDrawSwipe(false)
    end

    if colorIcon then
        button.icon:SetTexture(R.media.textures.blank)
        button.icon:SetVertexColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
    elseif textureIcon then
        button.icon:SetVertexColor(1, 1, 1)
    end

    button.count:FontTemplate(nil, self.countFontSize or 12, "OUTLINE")
end
