--[[
	Copyright (c) 2021 Bastien Clément, Frederik Verhoef

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]] -- Port of oUF Smooth Update by Xuerian
-- http://www.wowinterface.com/downloads/info11503-oUFSmoothUpdate.html
--[[
Functions:

- SmoothBar(bar)
    Enables smooth animation for the bar.
	The bar:SetValue() method will be overloaded to handle animation.

  Parameters:
    bar - StatusBar frame - The StatusBar to be animated

- ResetBar(bar)
    Restores the bar to its original state. Disabling animation.

  Parameters:
    bar - StatusBar frame - The StatusBar to be restored
]] 
local MAJOR = "LibSmoothStatusBar-1.0"
local MINOR = 2

local lib, upgrade = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then
    return
end

lib.frame = lib.frame or CreateFrame("Frame")
lib.activeObjects = lib.activeObjects or {}
lib.handledObjects = lib.handledObjects or {}

-------------------------------------------------------------------------------

local TARGET_FPS = 60
local AMOUNT = 0.33

local function Clamp(v, min, max)
    min = min or 0
    max = max or 1

    if v > max then
        return max
    elseif v < min then
        return min
    end

    return v
end

local function IsCloseEnough(new, target, range)
    if range > 0 then
        return math.abs((new - target) / range) <= 0.001
    end

    return true
end

local function AnimationTick(_, elapsed)
    for object, target in next, lib.activeObjects do
        local new = Lerp(object._value, target, Clamp(AMOUNT * elapsed * TARGET_FPS))
        if IsCloseEnough(new, target, object._max - object._min) then
            new = target
            lib.activeObjects[object] = nil
        end

        object:SetValue_(new)
        object._value = new
    end
end

local function SmoothSetValue(self, value)
    self._value = self:GetValue()
    lib.activeObjects[self] = Clamp(value, self._min, self._max)
end

local function SmoothSetMinMaxValues(self, min, max)
    self:SetMinMaxValues_(min, max)

    if self._max and self._max ~= max then
        local ratio = 1
        if max ~= 0 and self._max and self._max ~= 0 then
            ratio = max / (self._max or max)
        end

        local target = lib.activeObjects[self]
        if target then
            lib.activeObjects[self] = target * ratio
        end

        local cur = self._value
        if cur then
            self:SetValue_(cur * ratio)
            self._value = cur * ratio
        end
    end

    self._min = min
    self._max = max
end

function lib:SmoothBar(bar)
    if not bar or lib.handledObjects[bar] then
        return
    end

    bar._min, bar._max = bar:GetMinMaxValues()
    bar._value = bar:GetValue()

    bar.SetValue_ = bar.SetValue
    bar.SetMinMaxValues_ = bar.SetMinMaxValues
    bar.SetValue = SmoothSetValue
    bar.SetMinMaxValues = SmoothSetMinMaxValues

    lib.handledObjects[bar] = true

    if not lib.frame:GetScript("OnUpdate") then
        lib.frame:SetScript("OnUpdate", AnimationTick)
    end
end

function lib:ResetBar(bar)
    if not bar or not lib.handledObjects[bar] then
        return
    end

    if lib.activeObjects[bar] then
        bar:SetValue_(lib.activeObjects[bar])
        lib.activeObjects[bar] = nil
    end

    if bar.SetValue_ then
        bar.SetValue = bar.SetValue_
        bar.SetValue_ = nil
    end

    if bar.SetMinMaxValues_ then
        bar.SetMinMaxValues = bar.SetMinMaxValues_
        bar.SetMinMaxValues_ = nil
    end

    lib.handledObjects[bar] = nil

    if not next(lib.handledObjects) then
        frame:SetScript("OnUpdate", nil)
    end
end

function lib:SetSmoothingAmount(amount)
    AMOUNT = Clamp(amount, 0.3, 0.6)
end
