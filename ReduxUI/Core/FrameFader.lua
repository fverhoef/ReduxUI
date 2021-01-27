local AddonName, AddonTable = ...
local R = _G.ReduxUI

function R:StartFadeIn(frame, config)
    if frame.fader.direction == "in" then
        return
    end

    config = config or frame.faderConfig

    frame.fader:Pause()
    frame.fader.anim:SetFromAlpha(config.fadeOutAlpha or 0)
    frame.fader.anim:SetToAlpha(config.fadeInAlpha or 1)
    frame.fader.anim:SetDuration(config.fadeInDuration or 0.3)
    frame.fader.anim:SetSmoothing(config.fadeInSmooth or "OUT")
    frame.fader.anim:SetStartDelay(config.fadeInDelay or 0)
    frame.fader.finalAlpha = config.fadeInAlpha
    frame.fader.direction = "in"
    frame.fader:Play()
end

function R:StartFadeOut(frame, config)
    if frame.fader.direction == "out" then
        return
    end

    config = config or frame.faderConfig

    frame.fader:Pause()
    frame.fader.anim:SetFromAlpha(config.fadeInAlpha or 1)
    frame.fader.anim:SetToAlpha(config.fadeOutAlpha or 0)
    frame.fader.anim:SetDuration(config.fadeOutDuration or 0.3)
    frame.fader.anim:SetSmoothing(config.fadeOutSmooth or "OUT")
    frame.fader.anim:SetStartDelay(config.fadeOutDelay or 0)
    frame.fader.finalAlpha = config.fadeOutAlpha
    frame.fader.direction = "out"
    frame.fader:Play()
end

local function FrameHandler(frame)
    if MouseIsOver(frame) then
        R:StartFadeIn(frame)
    else
        R:StartFadeOut(frame)
    end
end

local function OffFrameHandler(frame)
    if not frame.__faderParent then
        return
    end
    FrameHandler(frame.__faderParent)
end

function R:CreateFrameFader(frame, faderConfig)
    if not frame or frame.faderConfig then
        return
    end
    frame.faderConfig = faderConfig

    local animFrame = CreateFrame("Frame", nil, frame)
    animFrame.__owner = frame
    frame.fader = animFrame:CreateAnimationGroup()
    frame.fader.__owner = frame
    frame.fader.__animFrame = animFrame
    frame.fader.direction = nil
    frame.fader.setToFinalAlpha = false
    frame.fader.anim = frame.fader:CreateAnimation("Alpha")
    frame.fader:HookScript("OnFinished", function(me)
        if me.finalAlpha ~= nil then
            me.__owner:SetAlpha(me.finalAlpha)
        end
    end)
    frame.fader:HookScript("OnUpdate", function(me)
        me.__owner:SetAlpha(me.__animFrame:GetAlpha())
    end)

    if faderConfig.trigger and faderConfig.trigger == "OnShow" then
        frame:HookScript("OnShow", function(me)
            if me.fader then
                R:StartFadeIn(me)
            end
        end)
        -- I know setting the alpha on a hidden frame does not really make sense but we need to set the fader to "out"
        -- sadly a delay on the OnHide is impossible. we get the benefit of the fadeIn though.
        frame:HookScript("OnHide", function(me)
            if me.fader then
                R:StartFadeOut(me)
            end
        end)
    else
        frame:EnableMouse(true)
        frame:HookScript("OnEnter", FrameHandler)
        frame:HookScript("OnLeave", FrameHandler)
        FrameHandler(frame)
    end
end

function R:CreateButtonFrameFader(frame, buttonList, faderConfig)
    if frame.faderConfig then
        return
    end

    R:CreateFrameFader(frame, faderConfig)

    if faderConfig.trigger and faderConfig.trigger == "OnShow" then
        return
    end
    for _, button in next, buttonList do
        if not button.__faderParent then
            button.__faderParent = frame
            button:HookScript("OnEnter", OffFrameHandler)
            button:HookScript("OnLeave", OffFrameHandler)
        end
    end
end
