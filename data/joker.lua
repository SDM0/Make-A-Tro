SMODS.Rarity{
    key = "special",
    badge_colour = G.C.MONEY,
    pools = {},
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

--- Custom Joker ---

SMODS.Atlas{
    key = "mat_joker",
    path = "mat_joker.png",
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "custom_joker",
    name = "Custom Joker",
    rarity = "mat_special",
    blueprint_compat = false,
    pos = {x = 0, y = 0},
    cost = 6,
    config = {extra = {hat = mat_mod.init_obj("c_mat_joker_hat"), head = mat_mod.init_obj("c_mat_joker_head"), collar = mat_mod.init_obj("c_mat_joker_collar")}},
    loc_vars = function(self, info_queue, card)
        local hat = card.ability.extra.hat
        local head = card.ability.extra.head
        local collar = card.ability.extra.collar

        local name = mat_mod.generate_name({hat = hat, head = head, collar = collar})

        -- Dumb horrible info_queue fetching
        -- TODO: Do it
        --G.P_CENTERS[hat.key]:loc_vars(info_queue, hat)
        --G.P_CENTERS[head.key]:loc_vars(info_queue, head)
        --G.P_CENTERS[collar.key]:loc_vars(info_queue, collar)

        --print(info_queue)

        --print(h)
        --local _main_end = nil
        --if h and h.main_end then
        --    _main_end = h.main_end
        --    --print("main_end set")
        --end

        -- TODO: Figure out main_end/main_start fetching ugh

        return {vars = {name}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.hat = mat_mod.init_obj("c_mat_joker_hat")
        card.ability.extra.head = mat_mod.init_obj("c_mat_joker_head")
        card.ability.extra.collar = mat_mod.init_obj("c_mat_joker_collar")
    end,
    add_to_deck = function(self, card, from_debuff)
        for _, obj in ipairs(mat_mod.objects) do
            local added_obj = SMODS.Centers[card.ability.extra[obj].key]
            if added_obj and added_obj.mat_add_to_deck_obj and type(added_obj.mat_add_to_deck_obj) == 'function' then
                added_obj:mat_add_to_deck_obj(card.ability.extra[obj], from_debuff)
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for _, obj in ipairs(mat_mod.objects) do
            local removed_obj = SMODS.Centers[card.ability.extra[obj].key]
            if removed_obj and removed_obj.mat_remove_from_deck_obj and type(removed_obj.mat_remove_from_deck_obj) == 'function' then
                removed_obj:mat_remove_from_deck_obj(card.ability.extra[obj], from_debuff)
            end
        end
    end,
    calculate = function(self, card, context)
        local hat_ret, hat_trig = {}, {}
        local hat = G.P_CENTERS[card.ability.extra.hat.key]
        if hat and hat.mat_calculate_obj and type(hat.mat_calculate_obj) == 'function' then
            hat_ret, hat_trig = G.P_CENTERS[card.ability.extra.hat.key]:mat_calculate_obj(card.ability.extra.hat, context)
        end

        local head_ret, head_trig = {}, {}
        local head = G.P_CENTERS[card.ability.extra.head.key]
        if head and head.mat_calculate_obj and type(head.mat_calculate_obj) == 'function' then
            head_ret, head_trig = G.P_CENTERS[card.ability.extra.head.key]:mat_calculate_obj(card.ability.extra.head, context)
        end

        local collar_ret, collar_trig = {}, {}
        local collar = G.P_CENTERS[card.ability.extra.collar.key]
        if collar and collar.mat_calculate_obj and type(collar.mat_calculate_obj) == 'function' then
            collar_ret, collar_trig = G.P_CENTERS[card.ability.extra.collar.key]:mat_calculate_obj(card.ability.extra.collar, context)
        end

        return SMODS.merge_effects({hat_ret}, {head_ret}, {collar_ret}), hat_trig or head_trig or collar_trig
    end,
    calc_dollar_bonus = function(self, card)
        local total = 0
        for _, obj in ipairs(mat_mod.objects) do
            local money_obj = SMODS.Centers[card.ability.extra[obj].key]
            if money_obj and money_obj.mat_calc_dollar_bonus_obj and type(money_obj.mat_calc_dollar_bonus_obj) == 'function' then
                total = total + money_obj:mat_calc_dollar_bonus_obj(card.ability.extra[obj])
            end
        end

        local hat = card.ability.extra.hat
        local head = card.ability.extra.head
        local collar = card.ability.extra.collar

        local name = mat_mod.generate_name({hat = hat, head = head, collar = collar})
        if total ~= 0 then return total, {text = name .. " Joker"} end
	end,
    in_pool = function() return false end,
    discovered = true,
    no_collection = true,
    atlas = "mat_joker"
}

SMODS.DrawStep{
    key = 'mat_object',
    order = 21,
    func = function(self)
        if self.config.center_key == "j_mat_custom_joker" then
            for _, obj in ipairs(mat_mod.objects) do
                mat_mod[self.ability.extra[obj].key].role.draw_major = self
                mat_mod[self.ability.extra[obj].key]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                if self.edition then
                    mat_mod[self.ability.extra[obj].key]:draw_shader(G.P_CENTERS[self.edition.key].shader, nil, self.ARGS.send_to_shader, nil, self.children.center)
                end
            end
        end
    end,
    conditions = {vortex = false, facing = 'front'}
}