local AddonName, AddonTable = ...
local R = _G.ReduxUI
local AM = R.Modules.Automation

R.config.defaults.profile.modules.automation = {
    enabled = true,
    fastLoot = true,
    standDismount = true,
    vendorGrays = true,
    repair = true,
    acceptSummon = false,
    acceptResurrection = true,
    disableLootRollConfirmation = true,
    disableLootBindConfirmation = false,
    disableVendorRefundWarning = true,
    disableMailRefundWarning = true
}

R.config.options.args.automation = {
    type = "group",
    name = "Automation",
    order = 3,
    args = {
        header = {type = "header", name = R.title .. " > Automation", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if R.config.db.profile.modules.automation.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return R.config.db.profile.modules.automation.enabled
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.enabled = val
                if not val then
                    ReloadUI()
                else
                    R.Modules.Automation:Initialize()
                end
            end
        },
        lineBreak = {type = "header", name = "", order = 2},
        fastLoot = {
            type = "toggle",
            name = "Faster Auto-Loot",
            order = 10,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.fastLoot
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.fastLoot = val
            end
        },
        standDismount = {
            type = "toggle",
            name = "Auto Stand/Dismount",
            order = 11,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.standDismount
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.standDismount = val
            end
        },
        vendorGrays = {
            type = "toggle",
            name = "Vendor Trash",
            order = 12,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.vendorGrays
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.vendorGrays = val
            end
        },
        repair = {
            type = "toggle",
            name = "Auto Repair",
            order = 13,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.repair
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.repair = val
            end
        },
        acceptSummon = {
            type = "toggle",
            name = "Accept Summons",
            order = 14,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.acceptSummon
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.acceptSummon = val
            end
        },
        acceptResurrection = {
            type = "toggle",
            name = "Accept Resurrection",
            order = 15,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.acceptResurrection
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.acceptResurrection = val
            end
        },
        disableLootBindConfirmation = {
            type = "toggle",
            name = "Disable Bind on Pickup Confirmation",
            order = 16,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.disableLootBindConfirmation
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.disableLootBindConfirmation = val
            end
        },
        disableLootRollConfirmation = {
            type = "toggle",
            name = "Disable Loot Roll Confirmation",
            order = 17,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.disableLootRollConfirmation
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.disableLootRollConfirmation = val
            end
        },
        disableVendorRefundWarning = {
            type = "toggle",
            name = "Disable Vendor Refund Warning",
            order = 18,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.disableVendorRefundWarning
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.disableVendorRefundWarning = val
            end
        },
        disableMailRefundWarning = {
            type = "toggle",
            name = "Disable Mail Refund Warning",
            order = 19,
            width = "full",
            get = function()
                return R.config.db.profile.modules.automation.disableMailRefundWarning
            end,
            set = function(_, val)
                R.config.db.profile.modules.automation.disableMailRefundWarning = val
            end
        }
    }
}
