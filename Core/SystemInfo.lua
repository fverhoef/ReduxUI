local AddonName, AddonTable = ...
local Addon = AddonTable[1]
Addon.SystemInfo = {
    updateInterval = 30,
    ipTypeHome = "IPv4",
    ipTypeWorld = "IPv4",
    cpuProfiling = 0,
    totalMemory = 0,
    totalCPU = 0,
    bandwidth = 0,
    homePing = 0,
    worldPing = 0,
    framerate = 0,
    memoryTable = {},
    cpuTable = {}
}

local function RebuildAddonList()
    local addOnCount = GetNumAddOns()
    if (addOnCount == #Addon.SystemInfo.memoryTable) then
        return
    end

    -- Number of loaded addons changed, create new memoryTable for all addons
    wipe(Addon.SystemInfo.memoryTable)
    wipe(Addon.SystemInfo.cpuTable)
    for i = 1, addOnCount do
        Addon.SystemInfo.memoryTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
        Addon.SystemInfo.cpuTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
    end
end

local sortByMemoryOrCPU = function(a, b)
    if a and b then
        return (a[3] == b[3] and a[2] < b[2]) or a[3] > b[3]
    end
end

local function UpdateMemory()
    -- Update the memory usages of the addons
    UpdateAddOnMemoryUsage()

    -- Load memory usage in table
    local totalMemory = 0
    for i = 1, #Addon.SystemInfo.memoryTable do
        Addon.SystemInfo.memoryTable[i][3] = GetAddOnMemoryUsage(Addon.SystemInfo.memoryTable[i][1])
        totalMemory = totalMemory + Addon.SystemInfo.memoryTable[i][3]
    end

    -- Sort the table to put the largest addon on top
    sort(Addon.SystemInfo.memoryTable, sortByMemoryOrCPU)

    return totalMemory
end

local function UpdateCPU()
    -- Update the CPU usages of the addons
    UpdateAddOnCPUUsage()

    -- Load cpu usage in table
    local totalCPU = 0
    for i = 1, #Addon.SystemInfo.cpuTable do
        local addonCPU = GetAddOnCPUUsage(Addon.SystemInfo.cpuTable[i][1])
        Addon.SystemInfo.cpuTable[i][3] = addonCPU
        totalCPU = totalCPU + addonCPU
    end

    -- Sort the table to put the largest addon on top
    sort(Addon.SystemInfo.cpuTable, sortByMemoryOrCPU)

    return totalCPU
end

local function LiteUpdate()
    local _, _, homePing, worldPing = GetNetStats()
    Addon.SystemInfo.homePing = homePing
    Addon.SystemInfo.worldPing = worldPing
end

local function FullUpdate()
    LiteUpdate()
    RebuildAddonList()

    local cpuProfiling = GetCVar("scriptProfile") == "1"
    local totalCPU = 0
    if cpuProfiling then
        totalCPU = UpdateCPU()
    end
    local totalMemory = UpdateMemory()
    local bandwidth = GetAvailableBandwidth()
    local framerate = floor(GetFramerate())
    local useIPv6 = GetCVarBool("useIPv6")
    if useIPv6 then
        local ipTypeHome, ipTypeWorld = GetNetIpTypes()
        Addon.SystemInfo.ipTypeHome = ipTypeHome
        Addon.SystemInfo.ipTypeWorld = ipTypeWorld
    else
        Addon.SystemInfo.ipTypeHome = "IPv4"
        Addon.SystemInfo.ipTypeWorld = "IPv4"
    end

    Addon.SystemInfo.cpuProfiling = cpuProfiling
    Addon.SystemInfo.totalMemory = totalMemory
    Addon.SystemInfo.totalCPU = totalCPU
    Addon.SystemInfo.bandwidth = bandwidth
    Addon.SystemInfo.framerate = framerate
end

function Addon.SystemInfo:Update(fullUpdate)
    if fullUpdate then
        FullUpdate()
    else
        LiteUpdate()
    end
end

function Addon.SystemInfo:ToggleCPUProfiling()
    Addon.SystemInfo.cpuProfiling = not Addon.SystemInfo.cpuProfiling
    SetCVar("scriptProfile", Addon.SystemInfo.cpuProfiling)
end

function Addon.SystemInfo:CurrentCPUUsage(addon)
    for i = 1, #Addon.SystemInfo.cpuTable do
        local ele = Addon.SystemInfo.cpuTable[i]
        if ele and IsAddOnLoaded(ele[1]) then
            if ele[2] == addon then
                return ele[3]
            end
        end
    end
end

function Addon.SystemInfo:CurrentMemoryUsage(addon)
    for i = 1, #Addon.SystemInfo.memoryTable do
        local ele = Addon.SystemInfo.memoryTable[i]
        if ele and IsAddOnLoaded(ele[1]) then
            if ele[2] == addon then
                return ele[3]
            end
        end
    end
end

function Addon.SystemInfo:GetLatency()
    return Addon.SystemInfo.homePing > Addon.SystemInfo.worldPing and Addon.SystemInfo.homePing or Addon.SystemInfo.worldPing
end

function Addon.SystemInfo:FormatMemory(memory)
    local mult = 10 ^ 1
    if memory > 999 then
        local mem = ((memory / 1024) * mult) / mult
        return format("%.2f mb", mem)
    else
        local mem = (memory * mult) / mult
        return format("%d kb", mem)
    end
end
