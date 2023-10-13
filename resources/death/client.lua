local player          = import '@Index/player';
local status          = import '@status/status';
local behavior        = player.behavior()
local player          = player.localPlayer()
local isDead          = player.getState("isDead");
local death, maxDeath = status.new('death', 0, 100)
local states          = {
    hunger = player.getState("hunger"),
    thirst = player.getState("thirst")
}

local function isZero()
    return states.hunger.get() <= 0 and states.thirst.get() <= 0
end

local function updateDeath(val)
    if (val < 0) then
        val = 0
    end

    if (val > maxDeath.get()) then
        val = maxDeath.get()
    end

    death:set(val)
end

local function onUpdate()
    if (not isZero()) then
        return
    end

    while isZero() do
        updateDeath(death.get() + 1)
        Wait(config.statusTick)
    end
end

death.onChange(function(val)
    if (val < 100) then
        return
    end

    if isDead.get() then
        return
    end

    SetEntityHealth(PlayerPedId(), 0)
end)

local isLoop = false;
death.onChange(function(savedDeath)
    Wait(config.statusTick * 1.5)
    if isLoop then
        return
    end
    isLoop = true;
    while (savedDeath == death.get()) do
        Wait(config.statusTick)
        death:set(death.get() - 0.5)
    end
    isLoop = false;
end)

isDead.onChange(function(isDead)
    if (not isDead) then
        states.hunger:set(10)
        states.thirst:set(10)
        Wait(1000)
        death:set(0)
    end
end)

states.hunger.onChange(onUpdate)
states.thirst.onChange(onUpdate)
onUpdate()
