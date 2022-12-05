local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateCastbar()
    if not self.config.castbar.enabled then
        return
    end

    self.Castbar = CreateFrame("StatusBar", "$parentCastbar", self, "AnimatedCastbarTemplate")
    self.Castbar.config = self.config.castbar
    self.Castbar.holdTime = 1.0
    self.Castbar.PostCastStart = UF.Castbar_PostCastStart
    self.Castbar.PostCastStop = UF.Castbar_PostCastStop
    self.Castbar.PostCastFail = UF.Castbar_PostCastFail
    self.Castbar.PostCastInterruptible = UF.Castbar_PostCastInterruptible
    self.Castbar.Spark:SetPoint("CENTER", self.Castbar.Texture, "RIGHT")
    self.Castbar.HideBase = self.Castbar.Hide
    self.Castbar.Hide = UF.Castbar_Hide

    return self.Castbar
end

function UF:Castbar_OnShow()
    self.Holder:Show()
end

function UF:Castbar_OnHide()
    self.Holder:Hide()
end

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

    self.Castbar:SetStatusBarTexture(UF.config.statusbars.castbar)
    self.Castbar:SetStatusBarColor(unpack(UF.config.colors.castbar))

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

function UF:Castbar_PostCastStart(unit)
    local isChanneling, isEmpowering = false, false
    local name, _, _, _, _, isCrafting, _, uninterruptable = UnitCastingInfo(unit)
    if not name then
        _, _, _, _, _, isCrafting, uninterruptable, _, _, numStages = UnitChannelInfo(unit)
        isEmpowering = numStages and numStages > 0
        isChanneling = not isEmpowering
    end

    local texture, color = UF.config.statusbars.castbar, UF.config.colors.castbar
    if isCrafting then
        texture, color = UF.config.statusbars.castbarCrafting, UF.config.colors.castbarCrafting
    elseif uninterruptable then
        texture, color = UF.config.statusbars.castbarUninterruptable, UF.config.colors.castbarUninterruptable
    elseif isChanneling then
        texture, color = UF.config.statusbars.castbarChanneling, UF.config.colors.castbarChanneling
    elseif isEmpowering then
        texture, color = UF.config.statusbars.castbarEmpowering, UF.config.colors.castbarEmpowering
    end

    self.isChanneling = isChanneling
    self.isCrafting = isCrafting
    self.isEmpowering = isEmpowering

    self.Texture:SetTexture(texture)
    self.Texture:SetVertexColor(unpack(UF.config.colors.castbar))

    self.Spark:SetTexture(R.media.textures.unitFrames.modern.castingBar)
    self.Spark:SetTexCoord(78 / 1024, 88 / 1024, 408 / 512, 468 / 512)

    self.Icon:SetShown(self.config.showIcon and not uninterruptable)

    local isStandard = not isCrafting and not uninterruptable and not isChanneling and not isEmpowering
    self.StandardGlow:SetShown(self.config.showGlow and isStandard)
    self.CraftGlow:SetShown(self.config.showGlow and isCrafting)
    self.ChannelShadow:SetShown(self.config.showGlow and isChanneling)

    if self.config.showGlow and isStandard then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarGlow)
    elseif self.config.showGlow and isCrafting then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarCraftingGlow)
    elseif self.config.showGlow and isChanneling then
        self.Flash:SetTexture(R.media.textures.statusBars.castbarChannelingGlow)
    else
        self.Flash:SetTexture(nil)
    end
    self.Flash:Hide()
    
    self.FadeOutAnim:Stop()
    self.HoldFadeOutAnim:Stop()
    self.FlashLoopingAnim:Stop()
    self.FlashAnim:Stop()
    self.ChannelFinish:Stop()
    self.CraftingFinish:Stop()
    self.StandardFinish:Stop()
    self.InterruptShakeAnim:Stop()
    self.InterruptGlowAnim:Stop()
    self.InterruptSparkAnim:Stop()

    self:SetAlpha(1.0)
    self.Spark:Show()
end

function UF:Castbar_PostCastStop(unit)
    if self.config.playAnimations then
        if self.isChanneling and self.ChannelFinish then
            self.ChannelFinish:Play()
        elseif self.isCrafting and self.CraftingFinish then
            self.CraftingFinish:Play()
        elseif not self.isEmpowering and not self.notInterruptible and self.StandardFinish then
            self.StandardFinish:Play()
        end
    end
end

function UF:Castbar_PostCastFail(unit, spellID)
    self.Texture:SetTexture(UF.config.statusbars.castbarInterrupted)
    self.Texture:SetVertexColor(unpack(UF.config.colors.castbarInterrupted))

    self.Spark:SetTexture(R.media.textures.unitFrames.modern.castingBarFx)
    self.Spark:SetTexCoord(933 / 1024, 943 / 1024, 176 / 512, 236 / 512)

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

function UF:Castbar_PostCastInterruptible(unit)
    if self.notInterruptible then
        self.Texture:SetTexture(UF.config.statusbars.castbarUninterruptable)
        self.Texture:SetVertexColor(unpack(UF.config.colors.castbarUninterruptable))

        self.Icon:SetShown(self.config.showIcon and not self.notInterruptible)
    end
end

function CastbarAnimation_OnInterruptSparkAnimFinish(self)
    local bar = self:GetParent()
    bar.Spark:Hide()
end

function CastbarAnimation_OnFadeOutFinish(self)
    self:GetParent():HideBase()
end
