local addonName, ns = ...
local R = _G.ReduxUI
R.SystemInfo = {
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
    if (addOnCount == #R.SystemInfo.memoryTable) then
        return
    end

    -- Number of loaded addons changed, create new memoryTable for all addons
    wipe(R.SystemInfo.memoryTable)
    wipe(R.SystemInfo.cpuTable)
    for i = 1, addOnCount do
        R.SystemInfo.memoryTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
        R.SystemInfo.cpuTable[i] = {i, select(2, GetAddOnInfo(i)), 0}
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
    for i = 1, #R.SystemInfo.memoryTable do
        R.SystemInfo.memoryTable[i][3] = GetAddOnMemoryUsage(R.SystemInfo.memoryTable[i][1])
        totalMemory = totalMemory + R.SystemInfo.memoryTable[i][3]
    end

    -- Sort the table to put the largest addon on top
    sort(R.SystemInfo.memoryTable, sortByMemoryOrCPU)

    return totalMemory
end

local function UpdateCPU()
    -- Update the CPU usages of the addons
    UpdateAddOnCPUUsage()

    -- Load cpu usage in table
    local totalCPU = 0
    for i = 1, #R.SystemInfo.cpuTable do
        local addonCPU = GetAddOnCPUUsage(R.SystemInfo.cpuTable[i][1])
        R.SystemInfo.cpuTable[i][3] = addonCPU
        totalCPU = totalCPU + addonCPU
    end

    -- Sort the table to put the largest addon on top
    sort(R.SystemInfo.cpuTable, sortByMemoryOrCPU)

    return totalCPU
end

function R.SystemInfo:Update(fullUpdate)
    local _, _, homePing, worldPing = GetNetStats()
    R.SystemInfo.homePing = homePing
    R.SystemInfo.worldPing = worldPing

    if not fullUpdate then
        return
    end

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
        R.SystemInfo.ipTypeHome = ipTypeHome
        R.SystemInfo.ipTypeWorld = ipTypeWorld
    else
        R.SystemInfo.ipTypeHome = "IPv4"
        R.SystemInfo.ipTypeWorld = "IPv4"
    end

    R.SystemInfo.cpuProfiling = cpuProfiling
    R.SystemInfo.totalMemory = totalMemory
    R.SystemInfo.totalCPU = totalCPU
    R.SystemInfo.bandwidth = bandwidth
    R.SystemInfo.framerate = framerate
end

function R.SystemInfo:ToggleCPUProfiling()
    R.SystemInfo.cpuProfiling = not R.SystemInfo.cpuProfiling
    SetCVar("scriptProfile", R.SystemInfo.cpuProfiling)
end

function R.SystemInfo:CurrentCPUUsage(addon)
    for i = 1, #R.SystemInfo.cpuTable do
        local ele = R.SystemInfo.cpuTable[i]
        if ele and IsAddOnLoaded(ele[1]) then
            if ele[2] == addon then
                return ele[3]
            end
        end
    end
end

function R.SystemInfo:CurrentMemoryUsage(addon)
    for i = 1, #R.SystemInfo.memoryTable do
        local ele = R.SystemInfo.memoryTable[i]
        if ele and IsAddOnLoaded(ele[1]) then
            if ele[2] == addon then
                return ele[3]
            end
        end
    end
end

function R.SystemInfo:GetLatency()
    return R.SystemInfo.homePing > R.SystemInfo.worldPing and R.SystemInfo.homePing or R.SystemInfo.worldPing
end

function R.SystemInfo:FormatMemory(memory)
    local mult = 10 ^ 1
    if memory > 999 then
        local mem = ((memory / 1024) * mult) / mult
        return format("%.2f mb", mem)
    else
        local mem = (memory * mult) / mult
        return format("%d kb", mem)
    end
end
