local addonName, ns = ...
local R = _G.ReduxUI

function R:FadeIn(timeToFade, startAlpha, endAlpha, finishedFunc, finishedArg1, finishedArg2, finishedArg3, finishedArg4)
    self.faded = false

    if InCombatLockdown() then
        self:SetAlpha(endAlpha or 1)
        return
    end

    UIFrameFade(self, {
        mode = "IN",
        timeToFade = timeToFade or 0.3,
        startAlpha = startAlpha or self:GetAlpha(),
        endAlpha = endAlpha or 1,
        finishedFunc = finishedFunc,
        finishedArg1 = finishedArg1,
        finishedArg2 = finishedArg2,
        finishedArg3 = finishedArg3,
        finishedArg4 = finishedArg4
    })
end

function R:FadeOut(timeToFade, startAlpha, endAlpha, finishedFunc, finishedArg1, finishedArg2, finishedArg3, finishedArg4)
    self.faded = true

    if InCombatLockdown() then
        self:SetAlpha(endAlpha or 0)
        return
    end

    UIFrameFade(self, {
        mode = "OUT",
        timeToFade = timeToFade or 0.3,
        startAlpha = startAlpha or self:GetAlpha(),
        endAlpha = endAlpha or 0,
        finishedFunc = finishedFunc,
        finishedArg1 = finishedArg1,
        finishedArg2 = finishedArg2,
        finishedArg3 = finishedArg3,
        finishedArg4 = finishedArg4
    })
end

function R:CreateFader(faderConfig, children)
    if not self then
        return
    end

    if not self.faderConfig then
        self.children = {}
        self.faded = false

        self:EnableMouse(true)
        self:HookScript("OnShow", R.Fader_OnShow)
        self:HookScript("OnEnter", R.Fader_OnEnterOrLeave)
        self:HookScript("OnLeave", R.Fader_OnEnterOrLeave)
    end

    self.faderConfig = faderConfig
    if self.faderConfig == R.config.faders.mouseOver then
        R.Fader_OnEnterOrLeave(self)
    elseif self.faded then
        R.Fader_OnShow(self)
    end

    if not children then
        return
    end

    for _, child in next, children do
        if not child.faderParent then
            child.faderParent = self
            child:EnableMouse(true)
            child:HookScript("OnEnter", R.Fader_OnEnterOrLeave)
            child:HookScript("OnLeave", R.Fader_OnEnterOrLeave)
            table.insert(self.children, child)
        end
    end
end

function R:Fader_OnShow()
    local frame = self.faderParent or self
    if frame.faderConfig == R.config.faders.onShow then
        frame:FadeIn(0.3, 0)
    end
end

function R:Fader_OnEnterOrLeave()
    local frame = self.faderParent or self
    if frame.faderConfig == R.config.faders.mouseOver then
        if MouseIsOver(frame) or (SpellFlyout and SpellFlyout:IsShown() and MouseIsOver(SpellFlyout) and SpellFlyout:GetParent().faderParent == frame) then
            frame:FadeIn()
        else
            frame:FadeOut()
            if SpellFlyout and SpellFlyout:IsShown() and not MouseIsOver(SpellFlyout) and SpellFlyout:GetParent().faderParent == frame then
                SpellFlyout:Hide()
                ActionButton_UpdateFlyout(self:GetParent())
            end
        end
    end
end
