local array = import '@Index/array';
local player = import '@Index/player';
local default = {
    death = 0
};

for name, data in pairs(config.status) do
    default[name] = data.default
end

RegisterNetEvent("@status:update", function(payload)
    local _, xCharacter = player.find(source)
    if not xCharacter then
        return
    end

    local data = xCharacter.get("status") or {};

    for name, val in pairs (default) do
        if (not data[name]) then
            data[name] = val
        end
    end

    for name, val in pairs(payload) do
        data[name] = val
    end

    xCharacter:set('status', data)
end)
