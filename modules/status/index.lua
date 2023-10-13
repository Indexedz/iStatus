local player   = import '@Index/player'
local behavior = player.behavior()
local player   = player.localPlayer()
local module   = {}

function module.new(name, default, max)
  local val = player.useState(default, name);
  local max = player.useState(max, ("max:%s"):format(name));

  return val, max
end

return module
