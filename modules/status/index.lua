local player   = import '@Index/player'
local behavior = import '@Index/behavior'
local module   = {}

function module.new(name, default, max)
  local val = player.useState(default, name);
  local max = player.useState(max, ("max:%s"):format(name));

  return val, max
end

return module
