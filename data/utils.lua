local function deep_copy(t)
    local copy = {}
    if type(t) == "table" then
        for k, v in pairs(t) do
            copy[k] = deep_copy(v)
        end
    else
        copy = t
    end
    return copy
end

-- Initialize a material object with the necessary data
function mat_mod.init_obj(key)
    if not G.P_CENTERS[key] then return end

    local type = key:match("_(%w+)$")
    return {key = key, ability = deep_copy(G.P_CENTERS[key].config), type = type}
end

function mat_mod.generate_name(t)
    if not t or not t.hat or not t.head or not t.collar then return "ERROR" end
    local hat = t.hat
    local head = t.head
    local collar = t.collar

    -- Split in 3
    local function get_part(str, part)
        local len = #str
        if part == 1 then
            return str:sub(1, math.floor(len / 3))
        elseif part == 2 then
            return str:sub(math.floor(len / 3) + 1, 2 * (math.floor(len / 3)))
        else
            return str:sub(2 * (math.floor(len / 3)) + 1)
        end
    end

    local hat_key = hat.key:match("mat_(.-)_hat") or ""
    local head_key = head.key:match("mat_(.-)_head") or ""
    local collar_key = collar.key:match("mat_(.-)_collar") or ""

    local name = get_part(hat_key, 1) .. get_part(head_key, 2) .. get_part(collar_key, 3)
    name = name:gsub("_", " ")
    name = name:gsub("(%l)(%u)", "%1 %2")
    name = name:gsub("(%a)([%w']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)

    return name
end

-- "Create Joker" button check if at least one of each material is owned
function mat_mod.all_one_min()
    if not G.GAME then return false end
    local ha = G.GAME.used_mat_hat
    local he = G.GAME.used_mat_head
    local c = G.GAME.used_mat_collar
    return (ha and #ha > 0) and (he and #he > 0) and (c and #c > 0)
end

local aliases = {
    ["jkr"] = "c_mat_joker",
    ["ff"] = "c_mat_four_fingers",
    ["cc"] = "c_mat_credit_card",
    ["cd"] = "c_mat_ceremonial_dagger",
    ["lc"] = "c_mat_loyalty_card",
    ["8b"] = "c_mat_8_ball",
}

-- Create a (random or not) tri-Joker
function mat_mod.create_custom_joker(keys)
    local chosen_objs = {
        hat = "c_mat_joker_hat",
        head = "c_mat_joker_head",
        collar = "c_mat_joker_collar"
    }

    if not keys then
        for _, obj in ipairs(mat_mod.objects) do
            local str = "Mat_" .. obj
            local _pool, _pool_key = get_current_pool(str)
            local center = pseudorandom_element(_pool, pseudoseed("random_mat" .. obj))
            local it = 1
            while center == 'UNAVAILABLE' do
                it = it + 1
                center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
            end

            chosen_objs[obj] = center
        end
    else
        local function get_key(type, key)
            local prefix = aliases[key] or key
            if not prefix:match("^c_mat_") then
                prefix = "c_mat_" .. prefix
            end

            local obj = prefix .. "_" .. type

            if G.P_CENTERS[obj] then
                return obj
            end
            if G.P_CENTERS[key] then
                return key
            end

            return chosen_objs[type]
        end

        if type(keys) == "table" and #keys == 3 then
            chosen_objs.hat = get_key("hat", keys[1])
            chosen_objs.head = get_key("head", keys[2])
            chosen_objs.collar = get_key("collar", keys[3])

        elseif type(keys) == "string" then
            chosen_objs.hat = get_key("hat", keys)
            chosen_objs.head = get_key("head", keys)
            chosen_objs.collar = get_key("collar", keys)
        end
    end

    local card = SMODS.create_card{key = "j_mat_custom_joker"}
    card.ability.extra.hat = mat_mod.init_obj(chosen_objs.hat)
    card.ability.extra.head = mat_mod.init_obj(chosen_objs.head)
    card.ability.extra.collar = mat_mod.init_obj(chosen_objs.collar)
    card:add_to_deck()
    G.jokers:emplace(card)
end

-- Find where an object is, similar to SMODS.find_card
function mat_mod.find_object(key, count_debuffed)
    local res = {}
    if not G.jokers or not G.jokers.cards then return {} end
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        if area.cards then
            for _, v in pairs(area.cards) do
                if v and type(v) == 'table' and v.ability.extra and type(v.ability.extra) == "table" and (count_debuffed or not v.debuff) then
                    for _, obj in ipairs(mat_mod.objects) do
                        if v.ability.extra[obj] and (v.ability.extra[obj].key == "c_mat_" .. key .. "_" .. obj or v.ability.extra[obj].key == key) then
                            table.insert(res, v)
                        end
                    end
                end
            end
        end
    end
    return res
end

-- Check if the card param is an object or not (unused for now?)
function mat_mod.is_object(card)
    return (card and card.config and card.config.center.key:sub(1, 4) == "c_mat")
end

-- Get the Joker the object is attached to
function mat_mod.get_parent_obj(obj)
    --print(obj.key)
    if G.jokers then
        for i = 1, #G.jokers.cards do
            local jkr = G.jokers.cards[i]
            if jkr.config.center.key == "j_mat_custom_joker" then
                if jkr.ability.extra.hat and jkr.ability.extra.hat == obj or
                jkr.ability.extra.head and jkr.ability.extra.head == obj or
                jkr.ability.extra.collar and jkr.ability.extra.collar == obj then
                    return jkr, i
                end
            end
        end
    end
    --print("obj not found")
    --print(obj)
end

-- Used for the "Pareidolia" object
function Card:mat_is_true_face(from_boss)
    if self.debuff and not from_boss then return end
    local id = self:get_id()
    local rank = SMODS.Ranks[self.base.value]
    if not id then return end
    if (id > 0 and rank and rank.face) then
        return true
    end
    return false
end

-- Used to properly scale all Vampire objects in a Joker
function Card:mat_get_latest_vampire()
    if self and self.config and self.config.center and self.config.center.key == "j_mat_custom_joker" then
        local res = {hat = false, head = false, collar = false}
        local hat = self.ability.extra.hat
        local head = self.ability.extra.head
        local collar = self.ability.extra.collar

        local jkr_objs = {hat, head, collar}

        for _, v in ipairs(jkr_objs) do
            if v.key == "c_mat_vampire_" .. v.type then
                res[v.type] = true
            end
        end

        if res.collar then return "collar" end
        if res.head then return "head"end
        if res.hat then return "hat" end
    end
end

function mat_mod.get_shortcutless_straight(hand, min_length, wrap)
    min_length = min_length or 5
    if min_length < 2 then min_length = 2 end
    if #hand < min_length then return {} end
    local ranks = {}
    for k,_ in pairs(SMODS.Ranks) do ranks[k] = {} end
    for _,card in ipairs(hand) do
        local id = card:get_id()
        if id > 0 then
            for k,v in pairs(SMODS.Ranks) do
                if v.id == id then table.insert(ranks[k], card); break end
            end
        end
    end
    local function next_ranks(key, start)
        local rank = SMODS.Ranks[key]
        local ret = {}
		if not start and not wrap and rank.straight_edge then return ret end
        for _,v in ipairs(rank.next) do
            ret[#ret+1] = v
        end
        return ret
    end
    local tuples = {}
    local ret = {}
    for _,k in ipairs(SMODS.Rank.obj_buffer) do
        if next(ranks[k]) then
            tuples[#tuples+1] = {k}
        end
    end
    for i = 2, #hand+1 do
        local new_tuples = {}
        for _, tuple in ipairs(tuples) do
            local any_tuple
            if i ~= #hand+1 then
                for _,l in ipairs(next_ranks(tuple[i-1], i == 2)) do
                    if next(ranks[l]) then
                        local new_tuple = {}
                        for _,v in ipairs(tuple) do new_tuple[#new_tuple+1] = v end
                        new_tuple[#new_tuple+1] = l
                        new_tuples[#new_tuples+1] = new_tuple
                        any_tuple = true
                    end
                end
            end
            if i > min_length and not any_tuple then
                local straight = {}
                for _,v in ipairs(tuple) do
                    for _,card in ipairs(ranks[v]) do
                        straight[#straight+1] = card
                    end
                end
                ret[#ret+1] = straight
            end
        end
        tuples = new_tuples
    end
    table.sort(ret, function(a,b) return #a > #b end)
    return ret
end