local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnHeader(name, func, config, defaultConfig, registerStyle, index, visibility)
    if registerStyle then
        oUF:RegisterStyle(addonName .. name, func)
        oUF:SetActiveStyle(addonName .. name)
    end

    local header = oUF:SpawnHeader(addonName .. name .. "Header" .. (index or ""), nil, config.visibility, "showPlayer", config.showPlayer, "showSolo", config.showSolo, "showParty", config.showParty,
                                   "showRaid", config.showRaid, "point", config.unitAnchorPoint, "groupFilter", index and tostring(index), "oUF-initialConfigFunction", ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
            self:GetParent():SetScale(%f)
        ]]):format(config.size[1], config.size[2], config.scale))

    header:SetFrameStrata("LOW")
    header:CreateFader(config.fader)
    _G.Mixin(header, UnitFrameHeaderMixin)

    return header
end

UnitFrameHeaderMixin = {}

function UnitFrameHeaderMixin:ForceShow()
    if not self or self.isForced then return end

    self.isForced = true
    self.forceShow = true
    self:SetAttribute("startingIndex", -4)

    for i = 1, self:GetNumChildren() do
        local child = self:GetAttribute("child" .. i)
        self:ForceShow(child)
    end

    if self.Update then self:Update() end
end

function UnitFrameHeaderMixin:UnforceShow()
    if not self or not self.isForced then return end

    self.isForced = nil
    self.forceShow = nil
    self:SetAttribute("startingIndex", 1)

    for i = 1, self:GetNumChildren() do
        local child = self:GetAttribute("child" .. i)
        child:UnforceShow()
    end

    if self.Update then self:Update() end
end
