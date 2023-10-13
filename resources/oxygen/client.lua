local player            = import '@Index/player';
local behavior          = import '@Index/behavior';
local oxygen, maxOxygen = import 'status'.new('oxygen', config.oxygen.default, config.oxygen.max)
local tick              = config.tick

local isUnderWater      = false;
local currentMovement   = "idle";

local function updateOxygen(val)
    if (val < 0) then
        val = 0
    end

    if (val > maxOxygen.get()) then
        val = maxOxygen.get()
    end

    oxygen:set(val)
    return val
end

oxygen.onChange(function(val)
    if val <= 0 then
        SetPlayerUnderwaterTimeRemaining(PlayerId(), 0)
    else
        SetPlayerUnderwaterTimeRemaining(PlayerId(), 100.0)
    end
end)

behavior.on("Movement", function(movement)
    currentMovement = movement
end)

behavior.on("UnderWater", function()
    isUnderWater = true;
end, function()
    isUnderWater = false;
end)

CreateThread(function()
    while true do
        if (isUnderWater) then
            while isUnderWater do
                local rate = config.oxygen.using[currentMovement:lower()] or 1

                updateOxygen(oxygen.get() - rate)
                Wait(tick)
            end
        else
            while not isUnderWater do
                local rate = config.oxygen.gain[currentMovement:lower()] or 1

                updateOxygen(oxygen.get() + rate)
                Wait(tick)
            end
        end

        Wait(tick);
    end
end)
