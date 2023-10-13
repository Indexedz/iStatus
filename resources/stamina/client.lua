local player              = import '@Index/player';
local behavior            = import '@Index/behavior';
local stamina, maxStamina = import 'status'.new('stamina', config.stamina.default, config.stamina.max)

local tick                = config.tick or 100

local currentMovement     = "idle"
local jumping             = false
local ragdoll             = false
local oldStamina          = stamina.get()

local states              = {
    hunger = player.getState("hunger"),
    thirst = player.getState("thirst")
}

local function updateStamina(val)
    if (val < 0) then
        val = 0
    end

    if (val > maxStamina.get()) then
        val = maxStamina.get()
    end

    if (oldStamina == val) then
        return
    end

    oldStamina = val
    stamina:set(val)
    return val
end

local function canRegen()
    return states.hunger.get() > 0 and
        states.thirst.get() > 0
end

behavior.on("Movement", function(movement)
    currentMovement = movement
end)

behavior.on("Jumping", function()
    local stamina = stamina.get() - 1
    jumping = true

    updateStamina(stamina - config.stamina.using.jumping)
    if (stamina <= 0 and not ragdoll) then
        SetPedToRagdoll(player.ped(), 5000, 1, 2)
        ragdoll = true
        CreateThread(function()
            Wait(1000)
            ragdoll = false
        end)
    end
end, function()
    jumping = false
end)

stamina.onChange(function(val)
    RestorePlayerStamina(PlayerId(), 1.0)
    if (val <= 0) then
        SetPlayerSprint(PlayerId(), false)
    else
        SetPlayerSprint(PlayerId(), true)
    end
end)

CreateThread(function()
    local waitsuccess = false
    local playerId = PlayerId()

    local WhileWait = function(timer)
        if (waitsuccess) then
            return true
        end

        while (currentMovement == "idle" or currentMovement == "walking" or currentMovement == "climbing") do
            Wait(timer)
            break;
        end
        waitsuccess = true
    end

    while true do
        if (currentMovement == "sprinting") then
            waitsuccess = false
            updateStamina(stamina.get() - config.stamina.using.sprinting)
        elseif (currentMovement == "running") then
            waitsuccess = false
            updateStamina(stamina.get() - config.stamina.using.running)
        end

        if ((
                currentMovement == "idle" or
                currentMovement == "walking" or
                currentMovement == "climbing"
            ) and not jumping and canRegen()) then
            WhileWait(config.stamina.gain.wait)
            while ((
                    currentMovement == "idle" or
                    currentMovement == "walking" or
                    currentMovement == "climbing"
                ) and not jumping and canRegen()) do
                updateStamina(stamina.get() +
                    (currentMovement == "idle" and config.stamina.gain.idle or config.stamina.gain.walking))
                Wait(tick)
            end
        end

        if (jumping) then
            waitsuccess = false
        end

        Wait(tick)
    end
end)
