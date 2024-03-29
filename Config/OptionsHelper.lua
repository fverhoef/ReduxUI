local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L

R.ANCHOR_POINTS = {"TOPLEFT", "TOP", "TOPRIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT", "LEFT", "RIGHT", "CENTER"}
R.ANCHORS = {"UIParent", addonName .. "Player", addonName .. "Target", addonName .. "Pet", addonName .. "Focus"}
R.JUSTIFY_H = {"LEFT", "CENTER", "RIGHT"}
R.JUSTIFY_V = {"TOP", "CENTER", "BOTTOM"}
R.FONT_OUTLINES = {"NONE", "OUTLINE", "THICKOUTLINE"}
R.FONT_MIN_SIZE = 4
R.FONT_MAX_SIZE = 30

function R:CreateColorOption(name, desc, order, hidden, hasAlpha, default, get, postSet, disabled)
    return {
        type = "color",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        disabled = disabled,
        hasAlpha = hasAlpha,
        get = function()
            local color = get()
            if default then
                return color[1], color[2], color[3], hasAlpha and color[4] or 1, default[1], default[2], default[3], default[4] or 1
            else
                return color[1], color[2], color[3], hasAlpha and color[4] or 1
            end
        end,
        set = function(_, r, g, b, a)
            local color = get()
            color[1] = r
            color[2] = g
            color[3] = b
            if hasAlpha then color[4] = a end
            if postSet then postSet() end
        end
    }
end

function R:CreateFontOption(name, desc, order, hidden, get, set, postSet, confirm, disabled)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        disabled = disabled,
        dialogControl = "LSM30_Font",
        values = R.Libs.SharedMedia:HashTable("font"),
        get = function() for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if get() == font then return key end end end,
        set = function(_, key)
            set(R.Libs.SharedMedia:Fetch("font", key))
            if postSet then postSet() end
        end,
        confirm = confirm
    }
end

function R:CreateInputOption(name, desc, order, hidden, get, set, postSet, disabled)
    return {
        type = "input",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        disabled = disabled,
        get = get,
        set = function(_, val)
            set(val)
            if postSet then postSet() end
        end
    }
end

function R:CreateRangeOption(name, desc, order, hidden, min, max, softMax, step, get, set, postSet, disabled)
    return {
        type = "range",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        disabled = disabled,
        min = min,
        max = max,
        softMax = softMax,
        step = step,
        get = get,
        set = function(_, val)
            set(val)
            if postSet then postSet() end
        end
    }
end

function R:CreateSelectOption(name, desc, order, hidden, values, get, set, postSet, disabled)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        disabled = disabled,
        values = values,
        get = function() for key, value in pairs(values) do if value == get() then return key end end end,
        set = function(_, key)
            set(values[key])
            if postSet then postSet() end
        end
    }
end

function R:CreateStatusBarOption(name, desc, order, hidden, get, set, postSet, disabled)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        disabled = disabled,
        dialogControl = "LSM30_Statusbar",
        values = R.Libs.SharedMedia:HashTable("statusbar"),
        get = function() for key, texture in pairs(R.Libs.SharedMedia:HashTable("statusbar")) do if get() == texture then return key end end end,
        set = function(_, key)
            set(R.Libs.SharedMedia:Fetch("statusbar", key))
            if postSet then postSet() end
        end
    }
end

function R:CreateToggleOption(name, desc, order, width, hidden, get, set, postSet, confirm, disabled)
    return {
        type = "toggle",
        name = name,
        desc = desc,
        order = order,
        width = width,
        hidden = hidden,
        disabled = disabled,
        get = function() return get() end,
        set = function(_, value)
            set(value)
            if postSet then postSet() end
        end,
        confirm = confirm
    }
end

function R:CreateModuleEnabledOption(order, width, module)
    return R:CreateToggleOption(L["Enabled"], nil, order, width, nil, function() return R.config.db.profile.modules[module].enabled end, function(value) R.config.db.profile.modules[module].enabled = value end,
                                function()
        if R.config.db.profile.modules[module].enabled then
            if R.Modules[module] and R.Modules[module].Enable then R.Modules[module]:Enable() end
        else
            ReloadUI()
        end
    end, function() return R.config.db.profile.modules[module].enabled and L["Disabling this module requires a UI reload. Proceed?"] end)
end
