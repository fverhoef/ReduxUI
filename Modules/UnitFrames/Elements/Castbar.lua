local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateCastbar()
    if not self.config.castbar.enabled then
        return
    end

    if self.config.castbar.style == UF.CastbarStyles.Custom then
        self.Castbar = self:GetOrCreateCustomCastbar()
    elseif self.config.castbar.style == UF.CastbarStyles.Modern then
        self.Castbar = self:GetOrCreateModernCastbar()
    elseif self.config.castbar.style == UF.CastbarStyles.ModernAnimated then
        self.Castbar = self:GetOrCreateAnimatedModernCastbar()
    end

    return self.Castbar
end

oUF:RegisterMetaFunction("CreateCastbar", UF.CreateCastbar)

local function CreateCastbar(self, template)
    local castbar = CreateFrame("StatusBar", "$parentCastbar", self, template)
    castbar.config = self.config.castbar
    castbar.Spark:SetPoint("CENTER", castbar.Texture, "RIGHT")
    castbar:Hide()
    castbar.HideBase = castbar.Hide
    castbar.Hide = UF.Castbar_Hide
    return castbar
end

function UF:GetOrCreateCustomCastbar()
    if not self.CustomCastbar then
        self.CustomCastbar = CreateCastbar(self, "CastbarTemplate")
        self.CustomCastbar.Holder = CreateFrame("Frame", "$parentHolder", self.CustomCastbar)
        self.CustomCastbar.Holder:CreateBackdrop({ bgFile = R.media.textures.blank })
        self.CustomCastbar.Holder:CreateBorder()
        self.CustomCastbar.Holder:CreateShadow()
        self.CustomCastbar.Holder:SetPoint("TOPLEFT", self.CustomCastbar, "TOPLEFT")
        self.CustomCastbar.Holder:SetPoint("BOTTOMRIGHT", self.CustomCastbar, "BOTTOMRIGHT")
    end

    return self.CustomCastbar
end

oUF:RegisterMetaFunction("GetOrCreateCustomCastbar", UF.GetOrCreateCustomCastbar)

function UF:GetOrCreateModernCastbar()
    if not self.ModernCastbar then
        self.ModernCastbar = CreateCastbar(self, "ModernCastbarTemplate")
    end

    return self.ModernCastbar
end

oUF:RegisterMetaFunction("GetOrCreateModernCastbar", UF.GetOrCreateModernCastbar)

function UF:GetOrCreateAnimatedModernCastbar()
    if not self.AnimatedModernCastbar then
        self.AnimatedModernCastbar = CreateCastbar(self, "AnimatedModernCastbarTemplate")
    end

    return self.AnimatedModernCastbar
end

oUF:RegisterMetaFunction("GetOrCreateAnimatedModernCastbar", UF.GetOrCreateAnimatedModernCastbar)

function UF:ConfigureCastbar()
    local config = self.config.castbar
    if not config.enabled then
        self:DisableElement("Castbar")
        return
    elseif not self.Castbar then
        self:CreateCastbar()
    end

    if config.style == UF.CastbarStyles.Custom and self.Castbar ~= self.CustomCastbar then
        self:DisableElement("Castbar")
        self.Castbar = self:GetOrCreateCustomCastbar()
    elseif config.style == UF.CastbarStyles.Modern and self.Castbar ~= self.ModernCastbar then
        self:DisableElement("Castbar")
        self.Castbar = self:GetOrCreateModernCastbar()
    elseif config.style == UF.CastbarStyles.ModernAnimated and self.Castbar ~= self.AnimatedModernCastbar then
        self:DisableElement("Castbar")
        self.Castbar = self:GetOrCreateAnimatedModernCastbar()
    end

    self:EnableElement("Castbar")

    if config.detached then
        self.Castbar:SetParent(UIParent)
    else
        self.Castbar:SetParent(self)
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
    self.Castbar.Shield:ClearAllPoints()
    self.Castbar.Shield:SetPoint("RIGHT", self.Castbar, "LEFT", -2, -4)
end

oUF:RegisterMetaFunction("ConfigureCastbar", UF.ConfigureCastbar)

function UF:Castbar_Hide()
    if not self:IsVisible() then
        return
    elseif not self.__owner:IsElementEnabled("Castbar") then
        self:HideBase()
        return
    elseif self:IsCasting() then
        self:SetAlpha(1)
        self:Show()
        return
    end

    if self.FlashLoopingAnim then
        self.FlashLoopingAnim:Stop()
    end

    if self.FlashAnim then
        self.Flash:SetAlpha(0.0)
        self.Flash:Show()
        self.FlashAnim:Play()
    end

    if self.FadeOutAnim and self:GetAlpha() > 0 then
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

function CastbarMixin:PostCastStop(unit)
end

function CastbarMixin:PostCastUpdate(unit)
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

function CastbarMixin:IsCasting()
    return self.casting or self.channeling or self.empowering
end

CastbarFadeOutAnimationMixin = {}

function CastbarFadeOutAnimationMixin:OnFinished()
    local bar = self:GetParent()
    if not bar:IsCasting() then
        bar:HideBase()
    else
        bar:Show()
        bar:SetAlpha(1)
    end
end

function CastbarFadeOutAnimationMixin:OnStop()
    local bar = self:GetParent()
    if bar:IsCasting() then
        bar:Show()
        bar:SetAlpha(1)
    end
end

ModernCastbarMixin = {}

function ModernCastbarMixin:StopAnimations()
    CastbarMixin.StopAnimations(self)

    self.Flakes01:Hide()
    self.Flakes02:Hide()
    self.Flakes03:Hide()
end

function ModernCastbarMixin:PostCastStart(unit)
    CastbarMixin.PostCastStart(self, unit)

    self.crafting = select(6, UnitCastingInfo(unit))
    self.applyingTalents = R:IsTalentActivationSpell(self.spellID)

    local texture, color = UF.config.statusbars.castbar, UF.config.colors.castbar
    if self.crafting or self.applyingTalents then
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
    elseif self.config.showGlow and (self.crafting or self.applyingTalents) then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarCraftingGlow)
    elseif self.config.showGlow and self.channeling then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarChannelingGlow)
    else
        self.Flash:SetTexture(nil)
    end
    self.Flash:Hide()
end

function ModernCastbarMixin:PostCastStop(unit)
    CastbarMixin.PostCastStop(self, unit)
end

function ModernCastbarMixin:PostCastFail(unit, spellID)
    CastbarMixin.PostCastFail(self, unit, spellID)

    self.Spark:SetTexture(R.media.textures.unitFrames.modern.castingBarFx)
    self.Spark:SetTexCoord(933 / 1024, 943 / 1024, 176 / 512, 236 / 512)
end

AnimatedModernCastbarMixin = {}

function AnimatedModernCastbarMixin:StopAnimations()
    ModernCastbarMixin.StopAnimations(self)

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
    ModernCastbarMixin.PostCastStop(self, unit)

    if self.channeling and self.ChannelFinish then
        self.ChannelFinish:Play()
    elseif (self.crafting or self.applyingTalents) and self.CraftingFinish then
        self.CraftingFinish:Play()
    elseif not self.empowering and not self.notInterruptible and self.StandardFinish then
        self.Flakes01:Show()
        self.Flakes02:Show()
        self.Flakes03:Show()
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
