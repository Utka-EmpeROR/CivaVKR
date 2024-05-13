---@class hex
---@field go any
---@field type string

-- table for hexes
-- hex can be accessed by coordinates(q, r) on grid
-- go : gameobject
-- type : type of the hex
-- maybe something else
---@type table<string, hex>
hex_table = {}

map_size = 5
local scale = 0.5
local horizontal = 256 * scale
local vertical = 194 * scale

cube_direction_vectors = { { 1, 0 }, { 1, -1 }, { 0, -1 }, { -1, 0 }, { -1, 1 }, { 0, 1 } }

function hex_neighbor(hex, dir)
    vec = cube_direction_vectors[dir]
    return { hex[1] + vec[1], hex[2] + vec[2] }
end

function bound(value, lower_bound, upper_bound)
    return (value >= lower_bound and value <= upper_bound)
end

function hex_in_map(hex)
    local q = hex[1]
    local r = hex[2]
    local s = -hex[1] - hex[2]
    return (bound(q, -map_size, map_size)
        and bound(r, -map_size, map_size)
        and bound(s, -map_size, map_size))
end

---calculate reachable hexes for movement
---@param x {q,r} - start hex
---@param r integer, number of moves
---@return table of {q,r}
function hex_reachable(start, movement, side)
    local visited = {} -- таблица для хранения посещенных гексов
    table.insert(visited, start)

    local fringes = {} -- массив массивов гексов
    table.insert(fringes, { start })

    for k = 2, movement + 1 do
        table.insert(fringes, {})
        for _, hex in ipairs(fringes[k - 1]) do
            for dir = 1, 6 do
                local neighbor = hex_neighbor(hex, dir)
                if (get_unit(neighbor[1], neighbor[2]) == nil and
                        (get_building_side(neighbor[1], neighbor[2]) == nil or get_building_side(neighbor[1], neighbor[2]) == side) and
                        not is_in_table(neighbor, visited) and
                        hex_in_map(neighbor)) then
                    table.insert(visited, neighbor)
                    table.insert(fringes[k], neighbor)
                end
            end
        end
    end
    table.remove(visited, 1)
    return visited
end

---calculate reachable hexes for movement
---@param x {q,r} - start hex
---@param r integer, number of moves
---@return table of {q,r}
function hexes_in_range(start, movement)
    local visited = {} -- таблица для хранения посещенных гексов
    table.insert(visited, start)

    local fringes = {} -- массив массивов гексов
    table.insert(fringes, { start })

    for k = 2, movement + 1 do
        table.insert(fringes, {})
        for _, hex in ipairs(fringes[k - 1]) do
            for dir = 1, 6 do
                local neighbor = hex_neighbor(hex, dir)
                if (not is_in_table(neighbor, visited) and
                        hex_in_map(neighbor)) then
                    table.insert(visited, neighbor)
                    table.insert(fringes[k], neighbor)
                end
            end
        end
    end
    table.remove(visited, 1)
    return visited
end

function is_in_table(value, table)
    for _, v in ipairs(table) do
        if v[1] == value[1] and v[2] == value[2] then
            return true
        end
    end
    return false
end

---set full hex data
function set_hex_data(q, r, go, type)
    local key = get_hex_key(q, r)
    hex_table[key] = { go = go, type = type }
end

---@return hex type
function get_hex_type(q, r)
    local key = get_hex_key(q, r)
    return hex_table[key] and hex_table[key].type or nil
end

---@return hex game object
function get_hex_go(q, r)
    local key = get_hex_key(q, r)
    return hex_table[key] and hex_table[key].go or nil
end

function get_hex_key(q, r)
    return string.format("%d_%d", q, r)
end

---@return hex hex
function get_hex(q, r)
    return hex_table[get_hex_key(q, r)]
end

---get real coordinates from grid coordinates
---@param q integer
---@param r integer
---@return vector3 coordinates real coordinates
function get_real_coordinates(q, r)
    return vmath.vector3(640 + q * horizontal + r * (horizontal / 2), 512 - r * vertical, r * 0.01)
end

---get grid  coordinates from real coordinates
---@param x number
---@param y number
---@return integer, integer cubic coordinates q and r
function get_cube_coordinates(x, y)
    local r = (512 - y) / vertical + 0.6
    local q = (x - 640 - r * (horizontal / 2)) / horizontal
    return math.floor(q + 0.5), math.floor(r + 0.5)
end

---get real coordinates from grid coordinates
---@param q integer
---@param r integer
---@return vector3 coordinates real coordinates
function get_real_coordinates_for_units(q, r)
    return vmath.vector3(640 + q * horizontal + r * (horizontal / 2), 512 - r * vertical + 100, 0.5)
end

function get_real_coordinates_for_buildings(q, r)
    return vmath.vector3(640 + q * horizontal + r * (horizontal / 2), 512 - r * vertical + 100, 0.4)
end

function get_distance(q, r, q_new, r_new)
    return (math.abs(q - q_new)
        + math.abs(q + r - q_new - r_new)
        + math.abs(r - r_new)) / 2
end

local hex_types_by_factory = {
    hex_factory_forest = "forest",
    hex_factory_animal = "animal",
    hex_factory_plains = "plains",
    hex_factory_clay = "clay",
    hex_factory_mountain = "mountain",
    hex_factory_farm = "farm",
}

---get hex type by factory
---@param factory string
function get_hex_type_by_factory(factory)
    return hex_types_by_factory[factory:sub(2)]
end
