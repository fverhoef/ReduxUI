local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

local spellTicks = {}

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
    castbar.Ticks = {}
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
    if unit == "player" then
        self:UpdateTicks()
    end
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

function CastbarMixin:GetOrCreateTick(i)
    local tick = self.Ticks[i]
    if not tick then
        tick = self:CreateTexture("$parentTick" .. i, "OVERLAY", nil, 4)
        tick:SetTexture(R.media.textures.unitFrames.modern.castingBarTick)
        tick:SetWidth(4)
        self.Ticks[i] = tick
    end

    return tick
end

function CastbarMixin:UpdateTicks()
    for i, tick in ipairs(self.Ticks) do
        tick:Hide()
    end

    if self.channeling then
        local ticks = spellTicks[self.spellID] or 1
        local width = (self:GetWidth()) / ticks
        local height = self:GetHeight()

        for i = 1, ticks - 1 do
            local tick = self:GetOrCreateTick(i)
            tick:ClearAllPoints()
            tick:SetPoint("CENTER", self, "LEFT", i * width, 0)
            tick:SetHeight(height)
            tick:Show()
        end
    end
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

local function AddSpellTicks(ids, ticks)
    if type(ids) == "table" then
        for _, id in ipairs(ids) do
            spellTicks[id] = ticks
        end
    else
        spellTicks[ids] = ticks
    end
end

if R.isRetail then
else
    -- Death Knight
    AddSpellTicks(42650, 8)

    -- Druid
    AddSpellTicks({ 740, 8918, 9862, 9863, 26983, 48446, 48447 }, 4) -- Tranquility
    AddSpellTicks({ 16914, 17401, 17402, 27012, 48467 }, 10) -- Hurricane

    -- Hunter
    AddSpellTicks({ 1510, 14294, 14295, 27022, 58431, 58434 }, 6) -- Volley

    -- Mage
    AddSpellTicks({ 10, 6141, 8427, 10185, 10186, 10187, 27085, 42939, 42940 }, 8) -- Blizzard
    AddSpellTicks(5143, 3) -- Arcane Missiles (Rank 1)
    AddSpellTicks(5144, 4) -- Arcane Missiles (Rank 2)
    AddSpellTicks({ 5145, 5145, 8416, 8417, 10211, 10212, 25345, 27075, 38699, 38704, 42843, 42846 }, 5) -- Arcane Missiles (Rank 3-13)
    AddSpellTicks(12051, 4) -- Evocation

    -- Priest
    AddSpellTicks({ 15407, 17311, 17312, 17313, 17314, 18807, 25387, 48155, 48156 }, 3)
    AddSpellTicks(64843, 4) -- Divine Hymn
    AddSpellTicks(64901, 4) -- Hymn of Hope -- TODO: Accurate without glyph - with glyph it is 5 ticks
    AddSpellTicks({ 48045, 53023 }, 3) -- Mind Sear
    AddSpellTicks({ 47540, 47750, 47757, 47666, 47758, 53005, 52983, 52986, 52998, 53001, 53006, 52984, 52987, 52999, 53002, 53007, 52985, 52988, 53000, 53003 }, 2) -- Penance

    -- Warlock
    AddSpellTicks({ 1120, 8288, 8289, 11675, 27217, 47855 }, 5) -- Drain Soul
    AddSpellTicks({ 755, 3698, 3699, 3700, 11693, 11694, 11695, 27259, 47856 }, 10) -- Health Funnel
    AddSpellTicks({ 689, 699, 709, 7651, 11699, 11700, 27219, 27220, 47857 }, 5) -- Drain Life
    AddSpellTicks({ 5740, 6219, 11677, 11678, 27212, 47819, 47820 }, 4) -- Rain of Fire
    AddSpellTicks({ 1949, 11683, 11684, 27213, 47823 }, 15) -- Hellfire
    AddSpellTicks(5138, 5) -- Drain Mana

    -- First Aid
    AddSpellTicks({ 746, 1159 }, 6) -- Linen Bandage, Heavy Linen Bandage
    AddSpellTicks({ 3267, 3268 }, 7) -- Wool Bandage, Heavy Wool Bandage
    AddSpellTicks({ 45544, 45543, 27031, 27030, 23567, 23696, 24414, 18610, 18608, 10839, 10838, 7927, 7926 }, 8) -- All Other Bandages
end
