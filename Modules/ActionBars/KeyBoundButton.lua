local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

AB.KeyBoundButtonMixin = {}

function AB.KeyBoundButtonMixin:GetBindingAction()
    return self.keyBoundTarget
end

function AB.KeyBoundButtonMixin:GetHotkey()
    local key = GetBindingKey(self.keyBoundTarget)
    if key then
        return R.Libs.KeyBound:ToShortKey(key) or key
    end
end

function AB.KeyBoundButtonMixin:GetBindings()
    local keys = ""
    for i = 1, select("#", GetBindingKey(self.keyBoundTarget)) do
        local hotKey = select(i, GetBindingKey(self.keyBoundTarget))
        if keys ~= "" then
            keys = keys .. ", "
        end
        keys = keys .. GetBindingText(hotKey)
    end
    return keys
end

function AB.KeyBoundButtonMixin:SetKey(key)
    SetBinding(key, self.keyBoundTarget)
end

function AB.KeyBoundButtonMixin:ClearBindings()
    while GetBindingKey(self.keyBoundTarget) do
        SetBinding(GetBindingKey(self.keyBoundTarget), nil)
    end
end
