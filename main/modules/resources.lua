---@class resources
---@field gold integer
---@field gold_income integer
---@field metal integer
---@field metal_income integer
---@field wood integer
---@field wood_income integer
---@field wheat integer
---@field wheat_income integer

---table for resources by hash get all resources
---@type table<string, resources>
resources_table = {}

local resources_by_type = {
    forest = "wood",
    animal = "gold",
    plains = "gold",
    clay = "gold",
    mountain = "metal",
    farm = "wheat",
}

function get_resource_by_type(type)
    return resources_by_type[type]
end

---@param player_id integer
---@param cost cost
---@return boolean
function can_buy_by_cost(player_id, cost)
    if (resources_table[player_id].gold >= cost.gold and
            resources_table[player_id].wood >= cost.wood and
            resources_table[player_id].wheat >= cost.wheat and
            resources_table[player_id].metal >= cost.metal)
    then
        return true
    end
    return false
end

---@param player_id integer
---@param cost cost
function remove_resources(player_id, cost)
    resources_table[player_id].gold = resources_table[player_id].gold - cost.gold
    resources_table[player_id].wood = resources_table[player_id].wood - cost.wood
    resources_table[player_id].wheat = resources_table[player_id].wheat - cost.wheat
    resources_table[player_id].metal = resources_table[player_id].metal - cost.metal
end

exchange_table = {
    buy_metal = { metal = 1, gold = -3 },
    buy_wood = { wood = 1, gold = -3 },
    buy_wheat = { wheat = 1, gold = -3 },
    sell_metal = { metal = -1, gold = 2 },
    sell_wood = { wood = -1, gold = 2 },
    sell_wheat = { wheat = -1, gold = 2 },
}

exchange_table_resources_names = {
    "metal", "wood", "wheat"
}

resources_names = {
    "gold", "metal", "wood", "wheat"
}
