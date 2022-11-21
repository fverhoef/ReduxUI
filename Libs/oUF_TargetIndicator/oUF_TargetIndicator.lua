local _, ns = ...
local oUF = ns.oUF or oUF

if not oUF then
    return
end

local Update = function(self, event)
    --[[ Callback: TargetIndicator:PreUpdate()
	Called before the element has been updated.

	* self   - the TargetIndicator element
	--]]
    if self.TargetIndicator.PreUpdate then
        self.TargetIndicator:PostUpdate()
    end

    local visible
    if self.unit and UnitIsUnit(self.unit, "target") then
        self.TargetIndicator:Show()
        visible = true
    else
        self.TargetIndicator:Hide()
        visible = false
    end

    --[[ Callback: TargetIndicator:PostUpdate()
	Called after the element has been updated.

	* self   - the TargetIndicator element
	* visible   - whether the element is visible
	--]]
    if self.TargetIndicator.PostUpdate then
        self.TargetIndicator:PostUpdate(visible)
    end
end

local Path = function(self, ...)
    return (self.TargetIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
    return Path(element.__owner, "ForceUpdate")
end

local Enable = function(self, unit)
    if self.TargetIndicator then
        self.TargetIndicator.__owner = self
        self.TargetIndicator.ForceUpdate = ForceUpdate

        self:RegisterEvent("PLAYER_TARGET_CHANGED", Path, true)

        return true
    end
end

local Disable = function(self)
    if self.TargetIndicator then
        self:UnregisterEvent("PLAYER_TARGET_CHANGED", Path)
        self.TargetIndicator:Hide()

        return false
    end
end

oUF:AddElement("TargetIndicator", Path, Enable, Disable)
