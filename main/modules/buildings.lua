---@class building
---@field go any
---@field type string
---@field side integer
---@field max_hp integer
---@field current_hp integer
---@field cost cost

---@type table<string, building>
buildings_table = {}

function set_building_data(q, r, properties)
	local key = get_building_key(q, r)
	buildings_table[key] = {
		go = properties.go,
		type = properties.type,
		side = properties.side,
		max_hp = properties.max_hp,
		current_hp = properties.max_hp,
		cost = properties.cost
	}
end

function get_building_go(q, r)
	local key = get_building_key(q, r)
	return buildings_table[key] and buildings_table[key].go or nil
end

function get_building_type(q, r)
	local key = get_building_key(q, r)
	return buildings_table[key] and buildings_table[key].type or nil
end

function get_building_side(q, r)
	local key = get_building_key(q, r)
	return buildings_table[key] and buildings_table[key].side or nil
end

function get_building_max_hp(q, r)
	local key = get_building_key(q, r)
	return buildings_table[key] and buildings_table[key].max_hp or nil
end

function get_building_current_hp(q, r)
	local key = get_building_key(q, r)
	return buildings_table[key] and buildings_table[key].current_hp or nil
end

function get_building_key(q, r)
	return string.format("%d_%d", q, r)
end

---@return building
function get_building(q, r)
	return buildings_table[get_building_key(q, r)]
end

buildings_types = { "collector", "tower", "wall" }

local buildings_properties = {
	collector = {
		type = "collector",
		max_hp = 4,
		cost = {
			gold = 2,
			wheat = 0,
			metal = 0,
			wood = 2,
		},
	},
	tower = {
		type = "tower",
		max_hp = 8,
		cost = {
			gold = 5,
			wheat = 4,
			metal = 4,
			wood = 4,
		},
	},
	wall = {
		type = "wall",
		max_hp = 15,
		cost = {
			gold = 6,
			wheat = 0,
			metal = 1,
			wood = 5,
		},
	}
}

tower_attack_range = 2
tower_damage = 1

function get_building_properties(type)
	return buildings_properties[type]
end
