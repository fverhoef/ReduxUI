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

function R:CreateColorOption(name, desc, order, hidden, hasAlpha, default, get, postSet)
    return {
        type = "color",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
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

function R:CreateFontOption(name, desc, order, hidden, get, set, postSet)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        dialogControl = "LSM30_Font",
        values = R.Libs.SharedMedia:HashTable("font"),
        get = function() for key, font in pairs(R.Libs.SharedMedia:HashTable("font")) do if get() == font then return key end end end,
        set = function(_, key)
            set(R.Libs.SharedMedia:Fetch("font", key))
            if postSet then postSet() end
        end
    }
end

function R:CreateInputOption(name, desc, order, hidden, get, set, postSet)
    return {
        type = "input",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        get = get,
        set = function(_, val)
            set(val)
            if postSet then postSet() end
        end
    }
end

function R:CreateRangeOption(name, desc, order, hidden, min, max, softMax, step, get, set, postSet)
    return {
        type = "range",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
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

function R:CreateSelectOption(name, desc, order, hidden, values, get, set, postSet)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        values = values,
        get = function() for key, value in ipairs(values) do if value == get() then return key end end end,
        set = function(_, key)
            set(values[key])
            if postSet then postSet() end
        end
    }
end

function R:CreateStatusBarOption(name, desc, order, hidden, get, set, postSet)
    return {
        type = "select",
        name = name,
        desc = desc,
        order = order,
        hidden = hidden,
        dialogControl = "LSM30_Statusbar",
        values = R.Libs.SharedMedia:HashTable("statusbar"),
        get = function() for key, texture in pairs(R.Libs.SharedMedia:HashTable("statusbar")) do if get() == texture then return key end end end,
        set = function(_, key)
            set(R.Libs.SharedMedia:Fetch("statusbar", key))
            if postSet then postSet() end
        end
    }
end

function R:CreateToggleOption(name, desc, order, width, hidden, get, set, postSet, confirm)
    return {
        type = "toggle",
        name = name,
        desc = desc,
        order = order,
        width = width,
        hidden = hidden,
        get = function() return get() end,
        set = function(_, value)
            set(value)
            if postSet then postSet() end
        end,
        confirm = confirm
    }
end