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

function R:CreateFader(config, children, mouseParent)
    if not self then
        return
    end

    local fader = self.Fader
    if not fader then
        mouseParent = mouseParent or self
        fader = _G.Mixin({
            target = self,
            config = config,
            mouseParent = mouseParent,
            children = {}
        }, FaderMixin)
        self.Fader = fader

        mouseParent:EnableMouse(true)
        mouseParent:HookScript("OnShow", function()
            fader:OnShow()
        end)
        mouseParent:HookScript("OnEnter", function()
            fader:OnEnterOrLeave()
        end)
        mouseParent:HookScript("OnLeave", function()
            fader:OnEnterOrLeave()
        end)
    end

    fader.config = config
    if fader.config == R.config.faders.mouseOver then
        fader:OnEnterOrLeave()
    elseif self.faded then
        fader:OnShow()
    end

    if not children then
        return
    end

    for _, child in next, children do
        if not self.Fader.children[child] then
            child:EnableMouse(true)
            child:HookScript("OnEnter", function(self)
                fader:OnEnterOrLeave()
            end)
            child:HookScript("OnLeave", function(self)
                fader:OnEnterOrLeave()
            end)
            fader.children[child] = true
        end
    end
end

FaderMixin = {}

function FaderMixin:OnShow()
    if self.config == R.config.faders.onShow then
        self.target:FadeIn(0.3, 0)
    end
end

function FaderMixin:OnEnterOrLeave()
    if self.config == R.config.faders.mouseOver then
        if MouseIsOver(self.mouseParent) then
            self.target:FadeIn()
        else
            self.target:FadeOut()
        end
    end
end
