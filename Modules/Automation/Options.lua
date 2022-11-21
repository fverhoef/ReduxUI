local addonName, ns = ...
local R = _G.ReduxUI
local L = R.L
local AM = R.Modules.Automation

R:RegisterModuleOptions(AM, {
    type = "group",
    name = "Automation",
    args = {
        header = { type = "header", name = R.title .. " > Automation", order = 0 },
        enabled = R:CreateModuleEnabledOption(1, nil, "Automation"),
        lineBreak = { type = "header", name = "", order = 2 },
        fastLoot = {
            type = "toggle",
            name = L["Faster Auto-Loot"],
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
            name = L["Auto Stand/Dismount"],
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
            name = L["Vendor Trash"],
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
            name = L["Auto Repair"],
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
            name = L["Accept Summons"],
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
            name = L["Accept Resurrection"],
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
            name = L["Disable Bind on Pickup Confirmation"],
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
            name = L["Disable Loot Roll Confirmation"],
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
            name = L["Disable Vendor Refund Warning"],
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
            name = L["Disable Mail Refund Warning"],
            order = 19,
            width = "full",
            get = function()
                return AM.config.disableMailRefundWarning
            end,
            set = function(_, val)
                AM.config.disableMailRefundWarning = val
            end
        },
        lineBreak2 = { type = "description", name = "", order = 20 },
        autoInvite = {
            type = "toggle",
            name = L["Auto Invite"],
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
            name = L["Auto Invite Password"],
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
        lineBreak2 = { type = "header", name = "Announcer", order = 30 },
        announceInterrupt = {
            type = "toggle",
            name = L["Announce Interrupts"],
            desc = L["Whether to announce when you successfully interrupt an enemy's spell."],
            order = 31,
            get = function()
                return AM.config.announceInterrupt
            end,
            set = function(_, val)
                AM.config.announceInterrupt = val
            end
        },
        announceInterruptChannel = R:CreateSelectOption(L["Announce Interrupt Channel"], L["The channel to announce interrupts on"], 32, function()
            return not AM.config.announceInterrupt
        end, R.ANNOUNCE_CHANNELS, function()
            return AM.config.announceInterruptChannel
        end, function(value)
            AM.config.announceInterruptChannel = value
        end),
        lineBreak3 = { type = "header", name = L["Tweaks"], order = 40 },
        cameraDistanceMaxZoomFactor = R:CreateRangeOption(L["Max Camera Distance"], L["Maximum Camera Distance Zoom Factor"], 41, nil, 1, 4, 4, 0.1, function()
            return AM.config.cameraDistanceMaxZoomFactor
        end, function(value)
            AM.config.cameraDistanceMaxZoomFactor = value
        end, AM.Update)
    }
})
