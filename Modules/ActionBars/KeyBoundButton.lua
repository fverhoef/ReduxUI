local R = _G.ReduxUI

KeyBoundButtonMixin = {}

function KeyBoundButtonMixin:GetBindingAction()
    return self.KeyBoundTarget
end

function KeyBoundButtonMixin:GetHotkey()
    local key = GetBindingKey(self.KeyBoundTarget)
    if key then
        return R.Libs.KeyBound:ToShortKey(key) or key
    end
end

function KeyBoundButtonMixin:GetBindings()
    local keys = ""
    for i = 1, select("#", GetBindingKey(self.KeyBoundTarget)) do
        local hotKey = select(i, GetBindingKey(self.KeyBoundTarget))
        if keys ~= "" then
            keys = keys .. ", "
        end
        keys = keys .. GetBindingText(hotKey)
    end
    return keys
end

function KeyBoundButtonMixin:SetKey(key)
    SetBinding(key, self.KeyBoundTarget)
end

function KeyBoundButtonMixin:ClearBindings()
    while GetBindingKey(self.KeyBoundTarget) do
        SetBinding(GetBindingKey(self.KeyBoundTarget), nil)
    end
end
