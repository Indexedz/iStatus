local player   = import '@Index/player';
local array    = import '@Index/array';
local status   = import '@status/status';
local behavior = player.behavior()
local player   = player.localPlayer()
local statuses = array.new();
local death    = player.getState("death");

for name, data in pairs(config.status) do
    local state, maxState = status.new(name, data.default, data.maximum);
    statuses:push({
        state = state,
        maxState = maxState,
        data = data,
        name = name
    })
end

player.on("loaded", function()
    while true do
        Wait(config.statusTick)

        local updated = {
            death = death.get()
        }

        statuses:map(function(status)
            local state = status.state;
            local nextVal = state.get() - status.data.tick

            if (nextVal <= 0) then
                nextVal = 0
            end

            updated[status.name] = nextVal
            state:set(nextVal)
        end)

        TriggerServerEvent("@status:update", updated)
    end
end)
