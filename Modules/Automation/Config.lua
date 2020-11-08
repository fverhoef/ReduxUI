local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local AM = Addon.Modules.Automation

Addon.config.defaults.profile.modules.automation = {
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

Addon.config.options.args.automation = {
    type = "group",
    name = "Automation",
    order = 3,
    args = {
        header = {type = "header", name = Addon.title .. " > Automation", order = 0},
        enabled = {
            type = "toggle",
            name = "Enabled",
            order = 1,
            confirm = function()
                if AM.config.db.profile.enabled then
                    return "Disabling this module requires a UI reload. Proceed?"
                else
                    return false
                end
            end,
            get = function()
                return AM.config.db.profile.enabled
            end,
            set = function(_, val)
                AM.config.db.profile.enabled = val
                if not val then
                    ReloadUI()
                else
                    Addon.Modules.Automation:OnInitialize()
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
                return AM.config.db.profile.fastLoot
            end,
            set = function(_, val)
                AM.config.db.profile.fastLoot = val
            end
        },
        standDismount = {
            type = "toggle",
            name = "Auto Stand/Dismount",
            order = 11,
            width = "full",
            get = function()
                return AM.config.db.profile.standDismount
            end,
            set = function(_, val)
                AM.config.db.profile.standDismount = val
            end
        },
        vendorGrays = {
            type = "toggle",
            name = "Vendor Trash",
            order = 12,
            width = "full",
            get = function()
                return AM.config.db.profile.vendorGrays
            end,
            set = function(_, val)
                AM.config.db.profile.vendorGrays = val
            end
        },
        repair = {
            type = "toggle",
            name = "Auto Repair",
            order = 13,
            width = "full",
            get = function()
                return AM.config.db.profile.repair
            end,
            set = function(_, val)
                AM.config.db.profile.repair = val
            end
        },
        acceptSummon = {
            type = "toggle",
            name = "Accept Summons",
            order = 14,
            width = "full",
            get = function()
                return AM.config.db.profile.acceptSummon
            end,
            set = function(_, val)
                AM.config.db.profile.acceptSummon = val
            end
        },
        acceptResurrection = {
            type = "toggle",
            name = "Accept Resurrection",
            order = 15,
            width = "full",
            get = function()
                return AM.config.db.profile.acceptResurrection
            end,
            set = function(_, val)
                AM.config.db.profile.acceptResurrection = val
            end
        },
        disableLootBindConfirmation = {
            type = "toggle",
            name = "Disable Bind on Pickup Confirmation",
            order = 16,
            width = "full",
            get = function()
                return AM.config.db.profile.disableLootBindConfirmation
            end,
            set = function(_, val)
                AM.config.db.profile.disableLootBindConfirmation = val
            end
        },
        disableLootRollConfirmation = {
            type = "toggle",
            name = "Disable Loot Roll Confirmation",
            order = 17,
            width = "full",
            get = function()
                return AM.config.db.profile.disableLootRollConfirmation
            end,
            set = function(_, val)
                AM.config.db.profile.disableLootRollConfirmation = val
            end
        },
        disableVendorRefundWarning = {
            type = "toggle",
            name = "Disable Vendor Refund Warning",
            order = 18,
            width = "full",
            get = function()
                return AM.config.db.profile.disableVendorRefundWarning
            end,
            set = function(_, val)
                AM.config.db.profile.disableVendorRefundWarning = val
            end
        },
        disableMailRefundWarning = {
            type = "toggle",
            name = "Disable Mail Refund Warning",
            order = 19,
            width = "full",
            get = function()
                return AM.config.db.profile.disableMailRefundWarning
            end,
            set = function(_, val)
                AM.config.db.profile.disableMailRefundWarning = val
            end
        }
    }
}
