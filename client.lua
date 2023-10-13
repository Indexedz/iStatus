local player = import '@Index/player';

local function onPlayerLoaded()
    local status, state = player.get("status")

    local death = player.getState("death");
    death:set(death.get());

    for name, value in pairs(config.status) do
        local state = player.getState(name);
        state:set(status[name])
    end
end

player.on("loaded", onPlayerLoaded)
