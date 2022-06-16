local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L
local AM = R.Modules.Automation

R:RegisterModuleOptions(AM, {
    type = "group",
    name = "Automation",
    args = {
        header = {type = "header", name = R.title .. " > Automation", order = 0},
        enabled = R:CreateModuleEnabledOption(1, nil, "Automation"),
        lineBreak = {type = "header", name = "", order = 2},
        fastLoot = {
            type = "toggle",
            name = "Faster Auto-Loot",
            hidden = R.isRetail,
            order = 10,
            width = "full",
            get = function()
                return AM.config.fastLoot
            end,
            set = function(_, val)
                AM.config.fastLoot = val
            end
        },
        standDismount = {
            type = "toggle",
            name = "Auto Stand/Dismount",
            order = 11,
            width = "full",
            get = function()
                return AM.config.standDismount
            end,
            set = function(_, val)
                AM.config.standDismount = val
            end
        },
        vendorGrays = {
            type = "toggle",
            name = "Vendor Trash",
            order = 12,
            width = "full",
            get = function()
                return AM.config.vendorGrays
            end,
            set = function(_, val)
                AM.config.vendorGrays = val
            end
        },
        repair = {
            type = "toggle",
            name = "Auto Repair",
            order = 13,
            width = "full",
            get = function()
                return AM.config.repair
            end,
            set = function(_, val)
                AM.config.repair = val
            end
        },
        acceptSummon = {
            type = "toggle",
            name = "Accept Summons",
            order = 14,
            width = "full",
            get = function()
                return AM.config.acceptSummon
            end,
            set = function(_, val)
                AM.config.acceptSummon = val
            end
        },
        acceptResurrection = {
            type = "toggle",
            name = "Accept Resurrection",
            order = 15,
            width = "full",
            get = function()
                return AM.config.acceptResurrection
            end,
            set = function(_, val)
                AM.config.acceptResurrection = val
            end
        },
        disableLootBindConfirmation = {
            type = "toggle",
            name = "Disable Bind on Pickup Confirmation",
            order = 16,
            width = "full",
            get = function()
                return AM.config.disableLootBindConfirmation
            end,
            set = function(_, val)
                AM.config.disableLootBindConfirmation = val
            end
        },
        disableLootRollConfirmation = {
            type = "toggle",
            name = "Disable Loot Roll Confirmation",
            order = 17,
            width = "full",
            get = function()
                return AM.config.disableLootRollConfirmation
            end,
            set = function(_, val)
                AM.config.disableLootRollConfirmation = val
            end
        },
        disableVendorRefundWarning = {
            type = "toggle",
            name = "Disable Vendor Refund Warning",
            order = 18,
            width = "full",
            get = function()
                return AM.config.disableVendorRefundWarning
            end,
            set = function(_, val)
                AM.config.disableVendorRefundWarning = val
            end
        },
        disableMailRefundWarning = {
            type = "toggle",
            name = "Disable Mail Refund Warning",
            order = 19,
            width = "full",
            get = function()
                return AM.config.disableMailRefundWarning
            end,
            set = function(_, val)
                AM.config.disableMailRefundWarning = val
            end
        },
        lineBreak2 = {type = "description", name = "", order = 20},
        autoInvite = {
            type = "toggle",
            name = "Auto Invite",
            order = 21,
            get = function()
                return AM.config.autoInvite
            end,
            set = function(_, val)
                AM.config.autoInvite = val
            end
        },
        autoInvitePassword = {
            type = "input",
            name = "Auto Invite Password",
            order = 22,
            disabled = function()
                return not AM.config.autoInvite
            end,
            get = function()
                return AM.config.autoInvitePassword
            end,
            set = function(_, val)
                AM.config.autoInvitePassword = val
            end
        },
        lineBreak2 = {type = "header", name = "Tweaks", order = 30},
        cameraDistanceMaxZoomFactor = R:CreateRangeOption(L["Max Camera Distance"], L["Maximum Camera Distance Zoom Factor"], 31, nil, 1, 4, 4, 0.1,
                                                          function() return AM.config.cameraDistanceMaxZoomFactor end, function(value) AM.config.cameraDistanceMaxZoomFactor = value end, AM.Update)
    }
})
