local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateExtraActionBar()
    if not R.isRetail then
        return
    end

    local bar = CreateFrame("Frame", addonName .. "ExtraActionBar", UIParent)
    bar.config = AB.config.extraActionBar
    _G.Mixin(bar, AB.ExtraActionBarMixin)

    --_G.UIPARENT_MANAGED_FRAME_POSITIONS.ExtraAbilityContainer = nil
    ExtraAbilityContainer.SetSize = R.EmptyFunction

    ExtraActionBarFrame:SetParent(bar)
    ExtraActionBarFrame:ClearAllPoints()
    ExtraActionBarFrame:SetAllPoints()
    ExtraActionBarFrame.ignoreInLayout = true

    bar:SetScript("OnEvent", bar.OnEvent)
    AB:SecureHook(ExtraActionBarFrame, "SetParent", AB.ExtraActionBarFrame_SetParent)
    AB:SecureHook(ExtraAbilityContainer, "AddFrame", AB.ExtraAbilityContainer_AddFrame)

    local width, height = ExtraActionBarFrame.button:GetSize()
    bar:SetSize(width + 4, height + 4)

    bar:CreateMover("ExtraActionBar", AB.defaults.extraActionBar.point)
    bar:CreateFader(bar.config.fader)
    bar:SetNormalizedPoint(bar.config.point)

    bar:Update()

    return bar
end

function AB:ExtraActionBarFrame_SetParent(parent)
    if parent == AB.extraActionBar or not AB.extraActionBar then
        return
    end
    AB.extraActionBar:Update()
end

function AB:ExtraAbilityContainer_AddFrame(frame)
    if not AB.extraActionBar then
        return
    end
    AB.extraActionBar:Update()
end

AB.ExtraActionBarMixin = {}

function AB.ExtraActionBarMixin:Configure()
    self:Update()
end

function AB.ExtraActionBarMixin:Update()
    if InCombatLockdown() then
        self.needsUpdate = true
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    local width, height = ExtraActionBarFrame.button:GetSize()
    self:SetSize(width + 4, height + 4)

    self.needsUpdate = false
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    ExtraActionBarFrame:SetParent(self)
end

function AB.ExtraActionBarMixin:OnEvent(event)
    if event == "PLAYER_REGEN_ENABLED" and self.needsUpdate then
        self:Update()
    end
end
