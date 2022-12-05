local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateCastbar()
    if not self.config.castbar.enabled then
        return
    end

    self.Castbar = CreateFrame("StatusBar", "$parentCastbar", self, "AnimatedModernCastbarTemplate")
    self.Castbar.config = self.config.castbar
    self.Castbar.holdTime = 1.0
    self.Castbar.Spark:SetPoint("CENTER", self.Castbar.Texture, "RIGHT")
    self.Castbar.HideBase = self.Castbar.Hide
    self.Castbar.Hide = UF.Castbar_Hide

    return self.Castbar
end

oUF:RegisterMetaFunction("CreateCastbar", UF.CreateCastbar)

function UF:ConfigureCastbar()
    local config = self.config.castbar
    if not config.enabled then
        self:DisableElement("Castbar")
        return
    elseif not self.Castbar then
        self:CreateCastbar()
    end

    self:EnableElement("Castbar")

    if not config.detached then
        config.point[5] = nil
    end
    self.Castbar:SetSize(config.detached and config.size[1] or self:GetWidth(), config.size[2])
    self.Castbar:ClearAllPoints()
    self.Castbar:SetNormalizedPoint(config.point)

    self.Castbar.Texture:SetTexture(UF.config.statusbars.castbar)
    self.Castbar.Texture:SetVertexColor(unpack(UF.config.colors.castbar))

    self.Castbar.Spark:SetAlpha(config.showSpark and 1 or 0)

    self.Castbar.Text:SetFont(config.font or UF.config.font, config.fontSize or 10, config.fontOutline)
    self.Castbar.Text:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    self.Castbar.Time:SetFont(config.font or UF.config.font, config.fontSize or 10, config.fontOutline)
    self.Castbar.Time:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)

    self.Castbar.Icon:SetShown(config.showIcon)
    self.Castbar.SafeZone:SetShown(config.showSafeZone)

    self.Castbar.Shield:SetAlpha(config.showShield and 1 or 0)
    self.Castbar.Shield:SetNormalizedSize(config.shieldSize)
    self.Castbar.Shield:SetPoint("RIGHT", self.Castbar, "LEFT", -2, 0)
end

oUF:RegisterMetaFunction("ConfigureCastbar", UF.ConfigureCastbar)

function UF:Castbar_Hide()
    if self.FlashLoopingAnim then
        self.FlashLoopingAnim:Stop()
    end

    if self.FlashAnim then
        self.Flash:SetAlpha(0.0)
        self.Flash:Show()
        self.FlashAnim:Play()
    end

    if self.FadeOutAnim and self:GetAlpha() > 0 and self:IsVisible() then
        if self.reverseChanneling and self.CurrSpellStage < self.NumStages then
            self.HoldFadeOutAnim:Play()
        else
            self.FadeOutAnim:Play()
        end
    end
end

CastbarMixin = {}

function CastbarMixin:OnLoad()
    self:StopAnimations()
end

function CastbarMixin:OnShow()
    if self.Holder then
        self.Holder:Show()
    end
end

function CastbarMixin:OnHide()
    if self.Holder then
        self.Holder:Hide()
    end
end

function CastbarMixin:StopAnimations()
    self.FadeOutAnim:Stop()
    self.HoldFadeOutAnim:Stop()
end

function CastbarMixin:PostCastStart(unit)
    self:StopAnimations()
    self:SetAlpha(1.0)
    self.Spark:Show()
end

function CastbarMixin:PostCastFail(unit, spellID)
    self.Texture:SetTexture(UF.config.statusbars.castbarInterrupted)
    self.Texture:SetVertexColor(unpack(UF.config.colors.castbarInterrupted))
end

function CastbarMixin:PostCastInterruptible(unit, spellID)
    if self.notInterruptible then
        self.Texture:SetTexture(UF.config.statusbars.castbarUninterruptable)
        self.Texture:SetVertexColor(unpack(UF.config.colors.castbarUninterruptable))

        self.Icon:SetShown(self.config.showIcon and not self.notInterruptible)
    end
end

CastbarFadeOutAnimationMixin = {}

function CastbarFadeOutAnimationMixin:OnFinished()
    self:GetParent():HideBase()
end

ModernCastbarMixin = {}

function ModernCastbarMixin:PostCastStart(unit)
    CastbarMixin.PostCastStart(self, unit)

    local name, _, _, _, _, crafting = UnitCastingInfo(unit)
    if not name and not self.channeling and not self.empowering then
        crafting = select(6, UnitChannelInfo(unit))
    end
    self.crafting = crafting

    local texture, color = UF.config.statusbars.castbar, UF.config.colors.castbar
    if self.crafting then
        texture, color = UF.config.statusbars.castbarCrafting, UF.config.colors.castbarCrafting
    elseif self.notInterruptible then
        texture, color = UF.config.statusbars.castbarUninterruptable, UF.config.colors.castbarUninterruptable
    elseif self.channeling then
        texture, color = UF.config.statusbars.castbarChanneling, UF.config.colors.castbarChanneling
    elseif self.empowering then
        texture, color = UF.config.statusbars.castbarEmpowering, UF.config.colors.castbarEmpowering
    end

    self.Texture:SetTexture(texture)
    self.Texture:SetVertexColor(unpack(color))

    self.Spark:SetTexture(R.media.textures.unitFrames.modern.castingBar)
    self.Spark:SetTexCoord(78 / 1024, 88 / 1024, 408 / 512, 468 / 512)

    self.Icon:SetShown(self.config.showIcon and not self.notInterruptible)

    local isStandard = not self.crafting and not self.notInterruptible and not self.channeling and not self.empowering
    self.StandardGlow:SetShown(self.config.showGlow and isStandard)
    self.CraftGlow:SetShown(self.config.showGlow and self.crafting)
    self.ChannelShadow:SetShown(self.config.showGlow and self.channeling)

    if self.config.showGlow and isStandard then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarGlow)
    elseif self.config.showGlow and self.crafting then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarCraftingGlow)
    elseif self.config.showGlow and self.channeling then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarChannelingGlow)
    else
        self.Flash:SetTexture(nil)
    end
    self.Flash:Hide()
end

function ModernCastbarMixin:PostCastFail(unit, spellID)
    CastbarMixin.PostCastFail(self, unit, spellID)

    self.Spark:SetTexture(R.media.textures.unitFrames.modern.castingBarFx)
    self.Spark:SetTexCoord(933 / 1024, 943 / 1024, 176 / 512, 236 / 512)
end

AnimatedModernCastbarMixin = {}

function AnimatedModernCastbarMixin:StopAnimations()
    CastbarMixin.StopAnimations(self)

    self.FlashLoopingAnim:Stop()
    self.FlashAnim:Stop()
    self.ChannelFinish:Stop()
    self.CraftingFinish:Stop()
    self.StandardFinish:Stop()
    self.InterruptShakeAnim:Stop()
    self.InterruptGlowAnim:Stop()
    self.InterruptSparkAnim:Stop()
end

function AnimatedModernCastbarMixin:PostCastStop(unit)
    if self.channeling and self.ChannelFinish then
        self.ChannelFinish:Play()
    elseif self.crafting and self.CraftingFinish then
        self.CraftingFinish:Play()
    elseif not self.empowering and not self.notInterruptible and self.StandardFinish then
        self.StandardFinish:Play()
    end
end

function AnimatedModernCastbarMixin:PostCastFail(unit, spellID)
    ModernCastbarMixin.PostCastFail(self, unit)

    if self.InterruptShakeAnim then
        self.InterruptShakeAnim:Play()
    end
    if self.InterruptGlowAnim then
        self.InterruptGlowAnim:Play()
    end
    if self.InterruptSparkAnim then
        self.InterruptSparkAnim:Play()
    end
end

CastbarInterruptAnimationMixin = {}

function CastbarInterruptAnimationMixin:OnFinished()
    self:GetParent().Spark:Hide()
end
