config = config or {}
config.tick = 100
config.statusTick = 1000
config.status = {
    ["hunger"] = {
        default = 100,
        maximum = 100,
        tick    = 0.01
    },
    ["thirst"] = {
        default = 100,
        maximum = 100,
        tick    = 0.005
    }
}

config.stamina = {
    default = 50,
    max     = 100,
    using   = {
        sprinting = 2,
        running = 1,
        jumping = 25
    },
    gain    = {
        wait = 1000,
        idle = 2,
        walking = 1
    }
}

config.oxygen = {
    default = 100,
    max = 100,
    using = {
        idle = 0.5,
        sprinting = 0.8,
        running = 0.7,
        walking = 0.6
    },
    gain = {
        idle = 2,
        walking = 1.5,
        running = 1,
        sprinting = 1
    }
}
