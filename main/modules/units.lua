---@class cost
---@field gold integer
---@field wood integer
---@field wheat integer
---@field metal integer

---@class unit
---@field go any
---@field name string
---@field side integer
---@field attack integer
---@field defence integer
---@field max_hp integer
---@field current_hp integer
---@field max_movement_distance integer
---@field current_movement_distance integer
---@field attack_range integer
---@field can_attack boolean
---@field cost cost

-- table for units
-- unit can be accesses by coordinates(q, r) on grid
-- go : gameobject
-- name : name of a unit
-- side : index of player who controls unit
-- attack, defence
-- max_hp, current_hp,
-- max_movement_distance, current_movement_distance,
-- attack_range
---@type table<string, unit>
units_table = {}

castles_positions = {}

function set_unit_data(q, r, properties)
    local key = get_hex_key(q, r)
    units_table[key] = {
        go = properties.go,
        name = properties.name,
        side = properties.side,
        attack = properties.attack,
        defence = properties.defence,
        max_hp = properties.max_hp,
        current_hp = properties.max_hp,
        max_movement_distance = properties.max_movement_distance,
        current_movement_distance = 0,
        attack_range = properties.attack_range,
        can_attack = false,
        cost = properties.cost
    }
end

function get_unit_go(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].go or nil
end

function get_unit_name(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].name or nil
end

function get_unit_side(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].side or nil
end

function get_unit_attack(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].attack or nil
end

function get_unit_defence(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].defence or nil
end

function get_unit_max_hp(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].max_hp or nil
end

function get_unit_current_hp(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].current_hp or nil
end

function get_unit_max_movement_distance(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].max_movement_distance or nil
end

function get_unit_current_movement_distance(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].current_movement_distance or nil
end

function get_unit_attack_range(q, r)
    local key = get_hex_key(q, r)
    return units_table[key] and units_table[key].attack_range or nil
end

function get_unit_key(q, r)
    return string.format("%d_%d", q, r)
end

---@return unit unit
function get_unit(q, r)
    return units_table[get_unit_key(q, r)]
end

units_names = { "archer", "cavalier", "lancer", "dragon" }

units_cost_table = {}

local units_properties = {
    archer = {
        name = "archer",
        attack = 3,
        defence = 0,
        max_hp = 5,
        max_movement_distance = 2,
        attack_range = 3,
        cost = {
            gold = 0,
            wheat = 2,
            metal = 0,
            wood = 1,
        },
    },
    cavalier = {
        name = "cavalier",
        attack = 5,
        defence = 2,
        max_hp = 7,
        max_movement_distance = 4,
        attack_range = 1,
        cost = {
            gold = 0,
            wheat = 2,
            metal = 2,
            wood = 1,
        },
    },
    lancer = {
        name = "lancer",
        attack = 4,
        defence = 1,
        max_hp = 6,
        max_movement_distance = 2,
        attack_range = 1,
        cost = {
            gold = 3,
            wheat = 1,
            metal = 0,
            wood = 0,
        },
    },
    dragon = {
        name = "dragon",
        attack = 6,
        defence = 2,
        max_hp = 8,
        max_movement_distance = 3,
        attack_range = 2,
        cost = {
            gold = 4,
            wheat = 3,
            metal = 3,
            wood = 0,
        },
    },
    castle = {
        name = "castle",
        max_hp = 20,
        defence = 2,
        max_movement_distance = 0,
        attack_range = 0,
    }
}

---get unit properties by it's name
---@param name string
function get_unit_properties(name)
    return units_properties[name]
end

units_ai_cost = {
    archer = 6,
    lancer = 4,
    castle = 15,
    dragon = 10,
    cavalier = 8,
}
