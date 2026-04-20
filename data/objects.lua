for _, obj in ipairs(mat_mod.objects) do
    local upp_obj = obj:gsub("^%l", string.upper)
    local colors = {
        ["Hat"] = {HEX('fe5f55'), HEX('fe5f55')},
        ["Head"] = {HEX('ff9a00'), HEX('ff9a00')},
        ["Collar"] = {HEX('009dff'), HEX('009dff')}
    }
    local pos_x, pos_y = 0, 0

    SMODS.ConsumableType {
        key = 'Mat_' .. obj,
        no_collection = obj ~= "collar" and true,
        collection_rows = {6, 6, 6},
        create_UIBox_your_collection = function(self)
            local type_buf = {}
            local all_obj = {}
            for i = 0, #G.P_CENTER_POOLS['Mat_hat'] do
                all_obj[#all_obj+1] = G.P_CENTER_POOLS['Mat_hat'][i]
                all_obj[#all_obj+1] = G.P_CENTER_POOLS['Mat_head'][i]
                all_obj[#all_obj+1] = G.P_CENTER_POOLS['Mat_collar'][i]
            end
            for _, v in ipairs(SMODS.ConsumableType.visible_buffer) do
                if not v.no_collection and (not G.ACTIVE_MOD_UI or modsCollectionTally(all_obj[v]).of > 0) then type_buf[#type_buf + 1] = v end
            end
            return SMODS.card_collection_UIBox(all_obj, self.collection_rows, { back_func = #type_buf>3 and 'your_collection_consumables' or nil})
        end,
        primary_colour = colors[upp_obj][1],
        secondary_colour = colors[upp_obj][2],
        shop_rate = 5,
        rarities = {
            { key = "Common" },
            { key = "Uncommon" },
            { key = "Rare" },
        },
        default = "c_mat_joker_" .. obj,
    }

    SMODS.Atlas{
        key = "mat_" .. obj .. "s",
        path = "mat_" .. obj .. "s.png",
        px = 71,
        py = 95
    }

    SMODS.Atlas{
        key = "mat_joker_" .. obj .. "s",
        path = "mat_joker_" .. obj .. "s.png",
        px = 71,
        py = 95
    }

    SMODS["Mat" .. upp_obj] = SMODS.Consumable:extend({
        set = "Mat_" .. obj,
        can_use = function(self, card, area, copier)
            return true
        end,
        use = function(self, card)
            G.GAME["used_mat_" .. obj] = G.GAME["used_mat_" .. obj] or {} -- G.GAME.used_mat_hat
            G.GAME["used_mat_" .. obj][#G.GAME["used_mat_" .. obj]+1] = card.config.center.key

        end,
        cost = 4,
        rarity = 1,
        in_pool = function(self)
            if not G.jokers then return false end
            if next(G.jokers.cards) then
                for _, joker in ipairs(G.jokers.cards) do
                    if joker.config.center.key == "j_mat_custom_joker" then
                        if self.key == joker.ability.extra[obj].key then return false end
                    end
                end
                if G.GAME["used_mat_" .. obj] and #G.GAME["used_mat_" .. obj] > 0 then
                    for _, used_obj in ipairs(G.GAME["used_mat_" .. obj]) do
                        if self.key == used_obj then return false end
                    end
                end
            end
            return true
        end,
        inject = function(self)
            SMODS.Consumable.inject(self)
            mat_mod[self.key] = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["mat_joker_" .. obj .. "s"], {x = pos_x,y = pos_y})
            pos_x = pos_x + 1
            if pos_x == 10 then
                pos_x = 0
                pos_y = pos_y + 1
            end

        end,
        delete = function(self)
            SMODS.Consumable.delete(self)
            mat_mod[self.key] = nil
        end,
        set_card_type_badge = function(self, card, badges)
            badges[#badges+1] = create_badge(localize('k_mat_' .. obj), G.C.SECONDARY_SET["Mat_" .. obj], nil, 1.2)
            if card.config.center.discovered then
                badges[#badges+1] = create_badge(SMODS.Rarity:get_rarity_badge(card.config.center.rarity), G.C.RARITY[card.config.center.rarity], nil, 1.0)
            end
        end,
        atlas = "mat_" .. obj .. "s"
    })

    SMODS.UndiscoveredSprite{key = 'Mat_' .. obj, atlas = "mat_" .. obj .. "s", pos = {x = 1, y = 0}}

    SMODS["Mat" .. upp_obj]{
        key = 'joker_' .. obj,
        name = 'Joker ' .. upp_obj,
        soul_pos = {x = 0, y = 1},
        rarity = 1,
        config = {extra = {mult = 2}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end,
    }

    SMODS["Mat" .. upp_obj]{
        key = 'greedy_' .. obj,
        name = 'Greedy '  .. upp_obj,
        soul_pos = {x = 1, y = 1},
        rarity = 1,
        config = {extra = {s_mult = 2, suit = 'Diamonds'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                context.other_card:is_suit(card.ability.extra.suit) then
                return {
                    mult = card.ability.extra.s_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'lusty_' .. obj,
        name = 'Lusty ' .. upp_obj,
        soul_pos = {x = 2, y = 1},
        rarity = 1,
        config = {extra = {s_mult = 2, suit = 'Hearts'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                context.other_card:is_suit(card.ability.extra.suit) then
                return {
                    mult = card.ability.extra.s_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'wrathful_' .. obj,
        name = 'Wrathful ' .. upp_obj,
        soul_pos = {x = 3, y = 1},
        rarity = 1,
        config = {extra = {s_mult = 2, suit = 'Spades'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                context.other_card:is_suit(card.ability.extra.suit) then
                return {
                    mult = card.ability.extra.s_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'gluttonous_' .. obj,
        name = 'Gluttonous ' .. upp_obj,
        soul_pos = {x = 4, y = 1},
        rarity = 1,
        config = {extra = {s_mult = 2, suit = 'Clubs'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                context.other_card:is_suit(card.ability.extra.suit) then
                return {
                    mult = card.ability.extra.s_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'jolly_' .. obj,
        name = 'Jolly ' .. upp_obj,
        soul_pos = {x = 5, y = 1},
        rarity = 1,
        config = {extra = {t_mult= 4, type = 'Pair'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'zany_' .. obj,
        name = 'Zany ' .. upp_obj,
        soul_pos = {x = 6, y = 1},
        rarity = 1,
        config = {extra = {t_mult= 6, type = 'Three of a Kind'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'mad_' .. obj,
        name = 'Mad ' .. upp_obj,
        soul_pos = {x = 7, y = 1},
        rarity = 1,
        config = {extra = {t_mult= 5, type = 'Two Pair'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'crazy_' .. obj,
        name = 'Crazy ' .. upp_obj,
        soul_pos = {x = 8, y = 1},
        rarity = 1,
        config = {extra = {t_mult= 6, type = 'Straight'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'droll_' .. obj,
        name = 'Droll ' .. upp_obj,
        soul_pos = {x = 9, y = 1},
        rarity = 1,
        config = {extra = {t_mult= 5, type = 'Flush'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'sly_' .. obj,
        name = 'Sly ' .. upp_obj,
        soul_pos = {x = 0, y = 2},
        rarity = 1,
        config = {extra = {t_chips = 25, type = 'Pair'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'wily_' .. obj,
        name = 'Wily ' .. upp_obj,
        soul_pos = {x = 1, y = 2},
        rarity = 1,
        config = {extra = {t_chips = 50, type = 'Three of a Kind'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'clever_' .. obj,
        name = 'Clever ' .. upp_obj,
        soul_pos = {x = 2, y = 2},
        rarity = 1,
        config = {extra = {t_chips = 40, type = 'Two Pair'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'devious_' .. obj,
        name = 'Devious ' .. upp_obj,
        soul_pos = {x = 3, y = 2},
        rarity = 1,
        config = {extra = {t_chips = 50, type = 'Straight'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'crafty_' .. obj,
        name = 'Crafty ' .. upp_obj,
        soul_pos = {x = 4, y = 2},
        rarity = 1,
        config = {extra = {t_chips = 40, type = 'Flush'}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'half_' .. obj,
        name = 'Half ' .. upp_obj,
        soul_pos = {x = 5, y = 2},
        rarity = 1,
        config = {extra = {mult = 7, size = 3}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.mult, card.ability.extra.size}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and #context.full_hand <= card.ability.extra.size then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'stencil_' .. obj,
        name = 'Stencil ' .. upp_obj,
        soul_pos = {x = 6, y = 2},
        rarity = 2,
        config = {extra = {xmult = 0.5}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.xmult, G.jokers and math.max(1, 1 + ((G.jokers.config.card_limit - #G.jokers.cards) * card.ability.extra.xmult)) or 1}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    xmult = 1 + ((G.jokers.config.card_limit - #G.jokers.cards) * card.ability.extra.xmult)
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'four_fingers_' .. obj,
        name = 'Four Fingers ' .. upp_obj,
        soul_pos = {x = 7, y = 2},
        rarity = 2,
        config = {extra = {mult = 6}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS["j_four_fingers"]
            return {vars = {card.ability.extra.mult, localize("Straight", 'poker_hands'), localize("Flush", 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and (next(context.poker_hands["Straight"]) or next(context.poker_hands["Flush"])) then
                if #context.scoring_hand == 4 then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
    }

    local sff = SMODS.four_fingers
    function SMODS.four_fingers(hand_type)
        return (next(mat_mod.find_object("four_fingers")) and 4) or sff(hand_type)
    end

    SMODS["Mat" .. upp_obj]{
        key = 'mime_' .. obj,
        name = 'Mime ' .. upp_obj,
        soul_pos = {x = 8, y = 2},
        rarity = 3,
        config = {extra = {repetitions = 1}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.repetitions}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.repetition and context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'credit_card_' .. obj,
        name = 'Credit Card ' .. upp_obj,
        soul_pos = {x = 9, y = 2},
        rarity = 1,
        config = {extra = {threshold = 7}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.threshold}}
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.threshold
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.threshold
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = 'ceremonial_dagger_' .. obj,
        name = 'Ceremonial Dagger ' .. upp_obj,
        soul_pos = {x = 0, y = 3},
        rarity = 2,
        config = {extra = {mult = 0}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.setting_blind and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                if my_pos and G.jokers.cards[my_pos + 1] and not SMODS.is_eternal(G.jokers.cards[my_pos + 1], card) then
                    if not G.jokers.cards[my_pos + 1].getting_sliced then
                        local sliced_card = G.jokers.cards[my_pos + 1]
                        sliced_card.getting_sliced = true
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.joker_buffer = 0
                                jkr:juice_up(0.8, 0.8)
                                sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                                play_sound('slice1', 0.96 + math.random() * 0.08)
                                return true
                            end
                        }))
                    end
                    return {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                        colour = G.C.RED,
                        no_juice = true
                    }
                end
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = "banner_" .. obj,
        name = 'Banner ' .. upp_obj,
        soul_pos = {x = 1, y = 3},
        rarity = 1,
        config = {extra = {chips = 15}},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.chips}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    chips = G.GAME.current_round.discards_left * card.ability.extra.chips
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = "mystic_summit_" .. obj,
        name = 'Mystic Summit ' .. upp_obj,
        soul_pos = {x = 2, y = 3},
        rarity = 1,
        config = {extra = {mult = 8, d_remaining = 0 }},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.mult, card.ability.extra.d_remaining}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and G.GAME.current_round.discards_left == card.ability.extra.d_remaining then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = "marble_" .. obj,
        name = 'Marble ' .. upp_obj,
        soul_pos = {x = 3, y = 3},
        rarity = 2,
        config = {extra = {spawn = false}},
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    not card.ability.extra.spawn and localize('k_mat_inactive') or "",
                    card.ability.extra.spawn and localize('k_mat_active') or ""
                }
            }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.setting_blind and card.ability.extra.spawn then
                local stone_card = create_playing_card({center = G.P_CENTERS.m_stone}, G.discard, true, false, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        stone_card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(stone_card)
                        return true
                    end
                }))
                return {
                    message = localize('k_plus_stone'),
                    colour = G.C.SECONDARY_SET.Enhanced,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                return true
                            end
                        }))
                        draw_card(G.play, G.deck, 90, 'up')
                        SMODS.calculate_context({playing_card_added = true, cards = {stone_card}})
                    end
                }
            end
            if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
                card.ability.extra.spawn = not card.ability.extra.spawn
                if card.ability.extra.spawn then
                    return {
                        message = localize('k_mat_active')
                    }
                end
                return nil, true
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = "loyalty_card_" .. obj,
        name = 'Loyalty Card ' .. upp_obj,
        soul_pos = {x = 4, y = 3},
        rarity = 2,
        config = {extra = {xmult = 2, every = 5, loyalty_remaining = 5}},
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.xmult,
                    card.ability.extra.every + 1,
                    localize { type = 'variable', key = (card.ability.extra.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {card.ability.extra.loyalty_remaining}}
                }
            }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local jkr = mat_mod.get_parent_obj(card)
                card.ability.extra.loyalty_remaining = (card.ability.extra.every - 1 - (G.GAME.hands_played - jkr.ability.hands_played_at_create)) %
                    (card.ability.extra.every + 1)
                if not context.blueprint then
                    if card.ability.extra.loyalty_remaining == 0 then
                        jkr.ability.mat_juice_until =  true
                        local eval = function(card) return card.ability.mat_juice_until and not G.RESET_JIGGLES end
                        juice_card_until(jkr, eval, true)
                    end
                end
                if card.ability.extra.loyalty_remaining == card.ability.extra.every then
                    jkr.ability.mat_juice_until = nil
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = "8_ball_" .. obj,
        name = '8 Ball ' .. upp_obj,
        soul_pos = {x = 5, y = 3},
        rarity = 1,
        config = {extra = {odds = 8}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_8_ball")
            return { vars = {num, den} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                if (context.other_card:get_id() == 8) and SMODS.pseudorandom_probability(card, "mat_8_ball", G.GAME.probabilities.normal, card.ability.extra.odds) then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    return {
                        extra = {
                            message = localize('k_plus_tarot'),
                            message_card = card,
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {set = 'Tarot', key_append = 'mat_8_ball'}
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end)
                                }))
                            end
                        },
                    }
                end
            end
        end
    }

    SMODS["Mat" .. upp_obj]{
        key = "misprint_" .. obj,
        name = 'Misprint ' .. upp_obj,
        soul_pos = {x = 6, y = 3},
        rarity = 1,
        config = {extra = {max = 23, min = 0}},
        loc_vars = function(self, info_queue, card)
            local r_mults = {}
            for i = card.ability.extra.min, card.ability.extra.max do
                r_mults[#r_mults + 1] = tostring(i)
            end
            local loc_mult = ' ' .. (localize('k_mult')) .. ' '
            main_start = {
                {n = G.UIT.T, config = {text = '  +', colour = G.C.MULT, scale = 0.32}},
                {n = G.UIT.O, config = {object = DynaText({ string = r_mults, colours = {G.C.RED}, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0})}},
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = {
                                { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.RED },
                                loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult,
                                loc_mult, loc_mult, loc_mult, loc_mult },
                            colours = {G.C.UI.TEXT_DARK },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.2011,
                            scale = 0.32,
                            min_cycle_time = 0
                        })
                    }
                },
            }
            return { main_start = main_start }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    mult = pseudorandom('mat_misprint', card.ability.extra.min, card.ability.extra.max)
                }
            end
        end
    }

    -- Dusk
    SMODS["Mat" .. upp_obj]{
        key = "dusk_" .. obj,
        name = "Dusk " .. upp_obj,
        soul_pos = {x = 7, y = 3},
        rarity = 3,
        config = {extra = {repetitions = 1}},
        mat_calculate_obj = function(self, card, context)
            if context.repetition and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    }

    -- Raised Fist
    SMODS["Mat" .. upp_obj]{
        key = "raised_fist_" .. obj,
        name = "Raised Fist " .. upp_obj,
        soul_pos = {x = 8, y = 3},
        rarity = 1,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.hand and not context.end_of_round then
                local temp_Mult, temp_ID = 15, 15
                local raised_card = nil
                for i = 1, #G.hand.cards do
                    if temp_ID >= G.hand.cards[i].base.id and not SMODS.has_no_rank(G.hand.cards[i]) then
                        temp_Mult = G.hand.cards[i].base.nominal
                        temp_ID = G.hand.cards[i].base.id
                        raised_card = G.hand.cards[i]
                    end
                end
                if raised_card == context.other_card then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        }
                    else
                        return {
                            mult = temp_Mult
                        }
                    end
                end
            end
        end
    }

    -- Chaos the Clown
    SMODS["Mat" .. upp_obj]{
        key = "chaos_" .. obj,
        name = "Chaos " .. upp_obj,
        soul_pos = {x = 9, y = 3},
        rarity = 2,
        config = {extra = {rerolls = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.rerolls}}
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            SMODS.change_free_rerolls(card.ability.extra.rerolls)
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            SMODS.change_free_rerolls(-card.ability.extra.rerolls)
        end
    }

    -- Fibonacci
    SMODS["Mat" .. upp_obj]{
        key = "fibonacci_" .. obj,
        name = "Fibonacci " .. upp_obj,
        soul_pos = {x = 0, y = 4},
        rarity = 2,
        config = {extra = {mult = 4}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() == 2 or
                    context.other_card:get_id() == 3 or
                    context.other_card:get_id() == 5 or
                    context.other_card:get_id() == 8 or
                    context.other_card:get_id() == 14 then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
    }

    -- Steel Joker
    SMODS["Mat" .. upp_obj]{
        key = "steel_" .. obj,
        name = "Steel " .. upp_obj,
        soul_pos = {x = 1, y = 4},
        rarity = 2,
        config = {extra = {xmult = 0.1}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_steel

            local steel_tally = 0
            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_steel') then steel_tally = steel_tally + 1 end
                end
            end
            return { vars = {card.ability.extra.xmult, 1 + card.ability.extra.xmult * steel_tally}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local steel_tally = 0
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_steel') then steel_tally = steel_tally + 1 end
                end
                return {
                    Xmult = 1 + card.ability.extra.xmult * steel_tally,
                }
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_steel'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_steel') then
                    return true
                end
            end
            return false
        end
    }

    -- Scary Face
    SMODS["Mat" .. upp_obj]{
        key = "scary_face_" .. obj,
        name = "Scary Face " .. upp_obj,
        soul_pos = {x = 2, y = 4},
        rarity = 1,
        config = {extra = {chips = 15}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_face() then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end,
    }

    -- Abstract Joker
    SMODS["Mat" .. upp_obj]{
        key = "abstract_" .. obj,
        name = "Abstract " .. upp_obj,
        soul_pos = {x = 3, y = 4},
        rarity = 1,
        config = {extra = {mult = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult, card.ability.extra.mult * (G.jokers and #G.jokers.cards or 0)}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local joker_count = 0
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.set == 'Joker' then joker_count = joker_count + 1 end
                end
                return {
                    mult = card.ability.extra.mult * joker_count
                }
            end
        end,
    }

    -- Delayed Gratification
    SMODS["Mat" .. upp_obj]{
        key = "delayed_grat_" .. obj,
        name = "Delayed Gratification " .. upp_obj,
        soul_pos = {x = 4, y = 4},
        rarity = 1,
        config = {extra = {dollars = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars}}
        end,
        mat_calc_dollar_bonus_obj = function(self, card)
            return G.GAME.current_round.discards_used == 0 and G.GAME.current_round.discards_left > 0 and
                G.GAME.current_round.discards_left * card.ability.extra.dollars or nil
        end
    }

    -- Hack
    SMODS["Mat" .. upp_obj]{
        key = "hack_" .. obj,
        name = "Hack " .. upp_obj,
        soul_pos = {x = 5, y = 4},
        rarity = 3,
        config = {extra = {repetitions = 1}},
        mat_calculate_obj = function(self, card, context)
            if context.repetition and context.cardarea == G.play then
                if context.other_card:get_id() == 2 or
                    context.other_card:get_id() == 3 or
                    context.other_card:get_id() == 4 or
                    context.other_card:get_id() == 5 then
                    return {
                        repetitions = card.ability.extra.repetitions
                    }
                end
            end
        end
    }

    -- Pareidolia
    SMODS["Mat" .. upp_obj]{
        key = "pareidolia_" .. obj,
        name = "Pareidolia " .. upp_obj,
        soul_pos = {x = 6, y = 4},
        rarity = 2,
        config = {extra = {mult = 5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and not context.other_card:mat_is_true_face() then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    local cif = Card.is_face
    function Card:is_face(from_boss)
        return cif(self, from_boss) or (self:get_id() and next(mat_mod.find_object("pareidolia")))
    end

    -- Gros Michel
    SMODS["Mat" .. upp_obj]{
        key = "gros_michel_" .. obj,
        name = "Gros Michel " .. upp_obj,
        soul_pos = {x = 7, y = 4},
        rarity = 1,
        config = {extra = {odds = 11, mult = 8}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_gros_michel")
            return { vars = {card.ability.extra.mult, num, den} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                if not jkr.mat_being_removed and SMODS.pseudorandom_probability(card, "mat_gros_michel", G.GAME.probabilities.normal, card.ability.extra.odds) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            jkr.T.r = -0.2
                            jkr:juice_up(0.3, 0.4)
                            jkr.mat_being_removed = true
                            jkr.states.drag.is = true
                            jkr.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    jkr:remove()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    G.GAME.pool_flags.mat_gros_michel_extinct = true
                    return {
                        message = localize('k_extinct_ex')
                    }
                else
                    return {
                        message = localize('k_safe_ex')
                    }
                end
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end,
        in_pool = function(self, args)
            return not G.GAME.pool_flags.mat_gros_michel_extinct
        end
    }

    -- Even Steven
    SMODS["Mat" .. upp_obj]{
        key = "even_steven_" .. obj,
        name = "Even Steven " .. upp_obj,
        soul_pos = {x = 8, y = 4},
        rarity = 1,
        config = {extra = {mult = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() <= 10 and
                    context.other_card:get_id() >= 0 and
                    context.other_card:get_id() % 2 == 0 then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
    }

    -- Odd Todd
    SMODS["Mat" .. upp_obj]{
        key = "odd_todd_" .. obj,
        name = "Odd Todd " .. upp_obj,
        soul_pos = {x = 9, y = 4},
        rarity = 1,
        config = {extra = {chips = 15}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if (context.other_card:get_id() <= 10 and
                        context.other_card:get_id() >= 0 and
                        context.other_card:get_id() % 2 == 1) or
                    (context.other_card:get_id() == 14) then
                    return {
                        chips = card.ability.extra.chips
                    }
                end
            end
        end
    }

    -- Scholar
    SMODS["Mat" .. upp_obj]{
        key = "scholar_" .. obj,
        name = "Scholar " .. upp_obj,
        soul_pos = {x = 0, y = 5},
        rarity = 1,
        config = {extra = {mult = 2, chips = 10}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult, card.ability.extra.chips}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
                return {
                    mult = card.ability.extra.mult,
                    chips = card.ability.extra.chips
                }
            end
        end
    }

    -- Business Card
    SMODS["Mat" .. upp_obj]{
        key = "business_" .. obj,
        name = "Business " .. upp_obj,
        soul_pos = {x = 1, y = 5},
        rarity = 1,
        config = {extra = {odds = 2, dollars = 1}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_business")
		    return { vars = { num, den, card.ability.extra.dollars} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_face() and
                SMODS.pseudorandom_probability(card, "mat_business", G.GAME.probabilities.normal, card.ability.extra.odds) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    }

    -- Supernova
    SMODS["Mat" .. upp_obj]{
        key = "supernova_" .. obj,
        name = "Supernova " .. upp_obj,
        soul_pos = {x = 2, y = 5},
        rarity = 1,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local _mult = math.floor(G.GAME.hands[context.scoring_name].played / 2)
                if _mult ~= 0 then
                    return {
                        mult = _mult
                    }
                end
            end
        end
    }

    -- Ride the Bus
    SMODS["Mat" .. upp_obj]{
        key = "ride_the_bus_" .. obj,
        name = "Ride The Bus " .. upp_obj,
        soul_pos = {x = 3, y = 5},
        rarity = 1,
        config = {extra = {mult_gain = 1, mult = 0}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult_gain, card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint then
                local faces = false
                for _, playing_card in ipairs(context.scoring_hand) do
                    if playing_card:is_face() then
                        faces = true
                        break
                    end
                end
                if faces then
                    local last_mult = card.ability.extra.mult
                    card.ability.extra.mult = 0
                    if last_mult > 0 then
                        return {
                            message = localize('k_reset')
                        }
                    end
                else
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                end
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    -- Space Joker
    SMODS["Mat" .. upp_obj]{
        key = "space_" .. obj,
        name = "Space " .. upp_obj,
        soul_pos = {x = 4, y = 5},
        rarity = 2,
        config = {extra = {odds = 7}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_space")
		    return { vars = { num, den} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and SMODS.pseudorandom_probability(card, "mat_space", G.GAME.probabilities.normal, card.ability.extra.odds) then
                return {
                    level_up = true,
                    message = localize('k_level_up_ex')
                }
            end
        end
    }

    -- Egg
    SMODS["Mat" .. upp_obj]{
        key = "egg_" .. obj,
        name = "Egg " .. upp_obj,
        soul_pos = {x = 4, y = 5},
        rarity = 1,
        config = {extra = {price = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.price}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.price
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
        end
    }

    -- Burglar
    SMODS["Mat" .. upp_obj]{
        key = "burglar_" .. obj,
        name = "Burglar " .. upp_obj,
        soul_pos = {x = 5, y = 5},
        rarity = 2,
        config = {extra = {hands = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.hands}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.setting_blind then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                ease_discard(-G.GAME.current_round.discards_left, nil, true)
                                ease_hands_played(card.ability.extra.hands)
                                SMODS.calculate_effect(
                                    { message = localize { type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}} },
                                    context.blueprint_card or card)
                                return true
                            end
                        }))
                    end
                }
            end
        end
    }

    -- Blackboard
    SMODS["Mat" .. upp_obj]{
        key = "blackboard_" .. obj,
        name = "Blackboard " .. upp_obj,
        soul_pos = {x = 6, y = 5},
        rarity = 2,
        config = {extra = {xmult = 1.75}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult, localize('Spades', 'suits_plural'), localize('Clubs', 'suits_plural')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local all_black_suits = true
                for _, playing_card in ipairs(G.hand.cards) do
                    if not playing_card:is_suit('Clubs', nil, true) and not playing_card:is_suit('Spades', nil, true) then
                        all_black_suits = false
                        break
                    end
                end
                if all_black_suits then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    }

    -- Runner
    SMODS["Mat" .. upp_obj]{
        key = "runner_" .. obj,
        name = "Runner " .. upp_obj,
        soul_pos = {x = 7, y = 5},
        rarity = 1,
        config = {extra = {chips = 0, chip_mod = 8}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint and next(context.poker_hands['Straight']) then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                }
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    }

    -- Ice Cream
    SMODS["Mat" .. upp_obj]{
        key = "ice_cream_" .. obj,
        name = "Ice Cream " .. upp_obj,
        soul_pos = {x = 8, y = 5},
        rarity = 1,
        config = {extra = {chips = 50, chip_mod = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.after and context.main_eval and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                if not jkr.mat_being_removed and card.ability.extra.chips - card.ability.extra.chip_mod <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            jkr.T.r = -0.2
                            jkr:juice_up(0.3, 0.4)
                            jkr.mat_being_removed = true
                            jkr.states.drag.is = true
                            jkr.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    jkr:remove()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_melted_ex'),
                        colour = G.C.CHIPS
                    }
                else
                    card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                    return {
                        message = localize { type = 'variable', key = 'a_chips_minus', vars = {card.ability.extra.chip_mod}},
                        colour = G.C.CHIPS
                    }
                end
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    }

    -- DNA
    SMODS["Mat" .. upp_obj]{
        key = "dna_" .. obj,
        name = "DNA " .. upp_obj,
        soul_pos = {x = 9, y = 5},
        rarity = 3,
        config = {extra = {copy = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.copy}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.first_hand_drawn and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
                juice_card_until(jkr, eval, true)
            end
            if context.before and context.main_eval and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local copy_card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
                copy_card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, copy_card)
                G.hand:emplace(copy_card)
                copy_card.states.visible = nil

                G.E_MANAGER:add_event(Event({
                    func = function()
                        copy_card:start_materialize()
                        return true
                    end
                }))
                return {
                    message = localize('k_copied_ex'),
                    colour = G.C.CHIPS,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.calculate_context({ playing_card_added = true, cards = {copy_card}})
                                return true
                            end
                        }))
                    end
                }
            end
        end
    }

    -- Splash
    SMODS["Mat" .. upp_obj]{
        key = "splash_" .. obj,
        name = "Splash " .. upp_obj,
        soul_pos = {x = 0, y = 6},
        rarity = 1,
        config = {extra = {chips = 20}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS["j_splash"]
            return { vars = {card.ability.extra.chips}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.modify_scoring_hand and not context.blueprint then
                return {
                    add_to_hand = true
                }
            end
            if context.joker_main then
                local _,_,_,_scoring_hand,_ = G.FUNCS.get_poker_hand_info(G.play.cards)
                if #context.scoring_hand > #_scoring_hand then
                    return {
                        chips = card.ability.extra.chips
                    }
                end
            end
        end
    }

    -- Blue Joker
    SMODS["Mat" .. upp_obj]{
        key = "blue_" .. obj,
        name = "Blue " .. upp_obj,
        soul_pos = {x = 1, y = 6},
        rarity = 1,
        config = {extra = {chips = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips, card.ability.extra.chips * ((G.deck and G.deck.cards) and #G.deck.cards or 52)}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips * #G.deck.cards
                }
            end
        end
    }

    -- Sixth Sense
    SMODS["Mat" .. upp_obj]{
        key = "sixth_sense_" .. obj,
        name = "Sixth Sense " .. upp_obj,
        soul_pos = {x = 2, y = 6},
        rarity = 2,
        mat_calculate_obj = function(self, card, context)
            if context.destroy_card and not context.blueprint then
                if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and context.full_hand[1]:get_id() == 6 and G.GAME.current_round.hands_played == 0 then
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                SMODS.add_card {
                                    set = 'Spectral',
                                    key_append = 'mat_sixth_sense'
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                        return {
                            message = localize('k_plus_spectral'),
                            colour = G.C.SECONDARY_SET.Spectral,
                            remove = true
                        }
                    end
                    return {
                        remove = true
                    }
                end
            end
        end
    }

    -- Constellation
    SMODS["Mat" .. upp_obj]{
        key = "constellation_" .. obj,
        name = "Constellation " .. upp_obj,
        soul_pos = {x = 3, y = 6},
        rarity = 2,
        config = {extra = {Xmult = 1, Xmult_mod = 0.05}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Planet' then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}
                }
            end
            if context.joker_main then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    }

    -- Hiker
    SMODS["Mat" .. upp_obj]{
        key = "hiker_" .. obj,
        name = "Hiker " .. upp_obj,
        soul_pos = {x = 4, y = 6},
        rarity = 2,
        config = {extra = {chips = 3}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) +
                    card.ability.extra.chips
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
        end
    }

    -- Faceless Joker
    SMODS["Mat" .. upp_obj]{
        key = "faceless_" .. obj,
        name = "Faceless " .. upp_obj,
        soul_pos = {x = 5, y = 6},
        rarity = 1,
        config = {extra = {dollars = 3, faces = 3}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars, card.ability.extra.faces}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.discard and context.other_card == context.full_hand[#context.full_hand] then
                local face_cards = 0
                for _, discarded_card in ipairs(context.full_hand) do
                    if discarded_card:is_face() then face_cards = face_cards + 1 end
                end
                if face_cards >= card.ability.extra.faces then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                    return {
                        dollars = card.ability.extra.dollars,
                        func = function() -- This is for timing purposes, it runs after the dollar manipulation
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.dollar_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    }

    -- Green Joker
    SMODS["Mat" .. upp_obj]{
        key = "green_" .. obj,
        name = "Green " .. upp_obj,
        soul_pos = {x = 6, y = 6},
        rarity = 2,
        config = {extra = {hand_add = 1, discard_sub = 1, mult = 0}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.hand_add, card.ability.extra.discard_sub, card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.discard and not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
                local prev_mult = card.ability.extra.mult
                card.ability.extra.mult = math.max(0, card.ability.extra.mult - card.ability.extra.discard_sub)
                if card.ability.extra.mult ~= prev_mult then
                    return {
                        message = localize { type = 'variable', key = 'a_mult_minus', vars = {card.ability.extra.discard_sub}},
                        colour = G.C.RED
                    }
                end
            end
            if context.before and context.main_eval and not context.blueprint then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.hand_add
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.hand_add}}
                }
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    -- Superposition
    SMODS["Mat" .. upp_obj]{
        key = "superposition_" .. obj,
        name = "Superposition " .. upp_obj,
        soul_pos = {x = 7, y = 6},
        rarity = 2,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands["Straight"]) and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local ace_check = false
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 14 then
                        ace_check = true
                        break
                    end
                end
                if ace_check then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'mat_superposition'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('k_plus_tarot'),
                        colour = G.C.SECONDARY_SET.Tarot,
                    }
                end
            end
        end
    }

    -- To Do List
    SMODS["Mat" .. upp_obj]{
        key = "todo_list_" .. obj,
        name = "To Do List " .. upp_obj,
        soul_pos = {x = 8, y = 6},
        rarity = 1,
        config = {extra = {dollars = 2, poker_hand = 'High Card'}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars, localize(card.ability.extra.poker_hand, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and context.scoring_name == card.ability.extra.poker_hand then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                local _poker_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible and k ~= card.ability.extra.poker_hand then
                        _poker_hands[#_poker_hands + 1] = k
                    end
                end
                card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, pseudoseed('mat_to_do'))
                return {
                    message = localize('k_reset')
                }
            end
        end,
        set_ability = function(self, card, initial, delay_sprites)
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible and k ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = k
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands,
                pseudoseed((card.area and card.area.config.type == 'title') and 'mat_false_to_do' or 'mat_to_do'))
        end
    }

    -- Cavendish
    SMODS["Mat" .. upp_obj]{
        key = "cavendish_" .. obj,
        name = "Cavendish " .. upp_obj,
        soul_pos = {x = 9, y = 6},
        rarity = 1,
        config = {extra = {odds = 2000, Xmult = 1.75}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_cavendish")
            return { vars = {card.ability.extra.Xmult, num, den}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                if not jkr.mat_being_removed and SMODS.pseudorandom_probability(card, "mat_gros_michel", G.GAME.probabilities.normal, card.ability.extra.odds) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            jkr.T.r = -0.2
                            jkr:juice_up(0.3, 0.4)
                            jkr.mat_being_removed = true
                            jkr.states.drag.is = true
                            jkr.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    jkr:remove()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_extinct_ex')
                    }
                else
                    return {
                        message = localize('k_safe_ex')
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
        in_pool = function(self, args)
            return G.GAME.pool_flags.mat_gros_michel_extinct
        end
    }

    -- Card Sharp
    SMODS["Mat" .. upp_obj]{
        key = "card_sharp_" .. obj,
        name = "Card Sharp " .. upp_obj,
        soul_pos = {x = 0, y = 7},
        rarity = 2,
        config = {extra = {Xmult = 1.75}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- Red Card
    SMODS["Mat" .. upp_obj]{
        key = "red_card_" .. obj,
        name = "Red Card " .. upp_obj,
        soul_pos = {x = 1, y = 7},
        rarity = 1,
        config = {extra = {mult_gain = 2, mult = 0}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult_gain, card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.skipping_booster and not context.blueprint then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_gain}},
                    colour = G.C.RED,
                }
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end,
    }

    -- Madness
    SMODS["Mat" .. upp_obj]{
        key = "madness_" .. obj,
        name = "Madness " .. upp_obj,
        soul_pos = {x = 1, y = 7},
        rarity = 2,
        config = {extra = {xmult_gain = 0.25, xmult = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.setting_blind and not context.blueprint and not context.blind.boss then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                local destructable_jokers = {}
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= jkr and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then
                        destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
                    end
                end
                local joker_to_destroy = pseudorandom_element(destructable_jokers, pseudoseed('mat_madness'))

                if joker_to_destroy then
                    joker_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            jkr:juice_up(0.8, 0.8)
                            joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                            return true
                        end
                    }))
                end
                return { message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}} }
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- Square Joker
    SMODS["Mat" .. upp_obj]{
        key = "square_" .. obj,
        name = "Square " .. upp_obj,
        soul_pos = {x = 2, y = 7},
        rarity = 1,
        pixel_size = {h = 71 },
        config = {extra = {chips = 0, chip_mod = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint and #context.full_hand == 4 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end,
    }

    -- Seance
    SMODS["Mat" .. upp_obj]{
        key = "seance_" .. obj,
        name = "Séance " .. upp_obj,
        soul_pos = {x = 3, y = 7},
        rarity = 2,
        config = {extra = {poker_hand = 'Straight Flush'}},
        loc_vars = function(self, info_queue, card)
            return { vars = {localize(card.ability.extra.poker_hand, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.poker_hand]) and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'mat_seance'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end,
    }

    -- Riff-raff
    SMODS["Mat" .. upp_obj]{
        key = "riff_raff_" .. obj,
        name = "Riff-Raff " .. upp_obj,
        soul_pos = {x = 4, y = 7},
        rarity = 1,
        config = {extra = {creates = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.creates}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                local jokers_to_create = math.min(2, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
                G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _ = 1, jokers_to_create do
                            SMODS.add_card {
                                set = 'Joker',
                                rarity = 'Common',
                                key_append = 'mat_riff_raff'
                            }
                            G.GAME.joker_buffer = 0
                        end
                        return true
                    end
                }))
                return {
                    message = localize('k_plus_joker'),
                    colour = G.C.BLUE,
                }
            end
        end,
    }

    -- Vampire
    SMODS["Mat" .. upp_obj]{
        key = "vampire_" .. obj,
        name = "Vampire " .. upp_obj,
        soul_pos = {x = 5, y = 7},
        rarity = 2,
        config = {extra = {Xmult_gain = 0.1, Xmult = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint then
                local enhanced = {}
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                local last_vamp = jkr:mat_get_latest_vampire()
                for _, scored_card in ipairs(context.scoring_hand) do
                    if next(SMODS.get_enhancements(scored_card)) and not scored_card.debuff and not scored_card.vampired then
                        enhanced[#enhanced + 1] = scored_card
                        scored_card.vampired = true
                        scored_card:set_ability('c_base', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                scored_card.vampired = nil
                                return true
                            end
                        }))
                    end
                end

                if #enhanced > 0 and not jkr.mat_enh_drained then
                    jkr.mat_enh_drained = #enhanced
                end

                if jkr.mat_enh_drained and jkr.mat_enh_drained > 0 then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain * jkr.mat_enh_drained
                    if card.type == last_vamp then jkr.mat_enh_drained = nil end
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                        colour = G.C.MULT
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- Shortcut
    SMODS["Mat" .. upp_obj]{
        key = "shortcut_" .. obj,
        name = "Shortcut " .. upp_obj,
        soul_pos = {x = 6, y = 7},
        rarity = 2,
        config = {extra = {mult = 0, mult_mod = 2}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS["j_shortcut"]
            return { vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval then
                local scless_straight = mat_mod.get_shortcutless_straight(G.play.cards, SMODS.four_fingers('straight'), SMODS.wrap_around_straight())
                if #scless_straight ~= 1 and next(context.poker_hands["Straight"]) then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    return {
                        message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_mod}}
                    }
                end
            end
            if context.joker_main and card.ability.extra.mult ~= 0 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end,
    }

    local sc = SMODS.shortcut
    function SMODS.shortcut()
        if next(mat_mod.find_object('shortcut')) then
            return true
        end
        return sc()
    end

    -- Hologram
    SMODS["Mat" .. upp_obj]{
        key = "hologram_" .. obj,
        name = "Hologram " .. upp_obj,
        rarity = 2,
        soul_pos = {
            x = 7, y = 7,
            draw = function(card, scale_mod, rotate_mod)
                card.hover_tilt = card.hover_tilt * 1.5
                card.children.floating_sprite:draw_shader('hologram', nil, card.ARGS.send_to_shader, nil,
                    card.children.center, 2 * scale_mod, 2 * rotate_mod)
                card.hover_tilt = card.hover_tilt / 1.5
            end
        },
        config = {extra = {Xmult_gain = 0.1, Xmult = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.playing_card_added and not context.blueprint then
                card.ability.extra.Xmult = card.ability.extra.Xmult + #context.cards * card.ability.extra.Xmult_gain
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}},
                }
            end
            if context.joker_main then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- Vagabond
    SMODS["Mat" .. upp_obj]{
        key = "vagabond_" .. obj,
        name = "Vagaond " .. upp_obj,
        soul_pos = {x = 8, y = 7},
        rarity = 3,
        config = {extra = {dollars = 4}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                if G.GAME.dollars <= card.ability.extra.dollars then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'mat_vagabond'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('k_plus_tarot'),
                    }
                end
            end
        end,
    }

    -- Baron
    SMODS["Mat" .. upp_obj]{
        key = "baron_" .. obj,
        name = "Baron " .. upp_obj,
        soul_pos = {x = 9, y = 7},
        rarity = 3,
        config = {extra = {xmult = 1.25}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 13 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        x_mult = card.ability.extra.xmult
                    }
                end
            end
        end,
    }

    -- Cloud 9
    SMODS["Mat" .. upp_obj]{
        key = "cloud_9_" .. obj,
        name = "Cloud 9 " .. upp_obj,
        soul_pos = {x = 0, y = 8},
        rarity = 2,
        config = {extra = {dollars = 1}},
        loc_vars = function(self, info_queue, card)
            local nine_tally = 0
            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    if playing_card:get_id() == 9 then nine_tally = nine_tally + 1 end
                end
            end
            return { vars = {card.ability.extra.dollars, (nine_tally == 0 and 0) or math.floor((card.ability.extra.dollars * nine_tally) / 2)}}
        end,
        mat_calc_dollar_bonus_obj = function(self, card)
            local nine_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 9 then nine_tally = nine_tally + 1 end
            end
            return nine_tally > 0 and math.floor((card.ability.extra.dollars * nine_tally) / 2) or nil
        end
    }

    -- Rocket
    SMODS["Mat" .. upp_obj]{
        key = "rocket_" .. obj,
        name = "Rocket " .. upp_obj,
        soul_pos = {x = 1, y = 8},
        rarity = 2,
        config = {extra = {dollars = 1, increase = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars, card.ability.extra.increase}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over == false and context.main_eval and G.GAME.blind.boss then
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.increase
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MONEY
                }
            end
        end,
        mat_calc_dollar_bonus_obj = function(self, card)
            return card.ability.extra.dollars
        end
    }

    -- Obelisk
    SMODS["Mat" .. upp_obj]{
        key = "obelisk_" .. obj,
        name = "Obelisk " .. upp_obj,
        soul_pos = {x = 2, y = 8},
        rarity = 3,
        config = {extra = {Xmult_gain = 0.1, Xmult = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint then
                local reset = true
                local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
                for k, v in pairs(G.GAME.hands) do
                    if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                        reset = false
                        break
                    end
                end
                if reset then
                    if card.ability.extra.Xmult > 1 then
                        card.ability.extra.Xmult = 1
                        return {
                            message = localize('k_reset')
                        }
                    end
                else
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- Midas Mask
    SMODS["Mat" .. upp_obj]{
        key = "midas_mask_" .. obj,
        name = "Midas " .. upp_obj,
        soul_pos = {x = 3, y = 8},
        rarity = 2,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS["j_midas_mask"]
            info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint then
                local faces = 0
                for _, scored_card in ipairs(context.scoring_hand) do
                    if scored_card:is_face() then
                        faces = faces + 1
                        scored_card:set_ability('m_gold', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                end
                if faces > 0 then
                    return {
                        message = localize('k_gold'),
                        colour = G.C.MONEY
                    }
                end
            end
        end
        -- $ increase in lovely.toml
    }

    -- Luchador
    SMODS["Mat" .. upp_obj]{
        key = "luchador_" .. obj,
        name = "Luchador " .. upp_obj,
        soul_pos = {x = 3, y = 8},
        rarity = 2,
        config = { extra = { dollars = 5 } },
        loc_vars = function(self, info_queue, card)
            local main_end = nil
            info_queue[#info_queue+1] = G.P_CENTERS["j_luchador"]
            if card.area and (card.area == G.jokers) then
                local disableable = G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind.boss))
                main_end = {
                    {
                        n = G.UIT.C,
                        config = {align = "bm", minh = 0.4 },
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = {ref_table = card, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06 },
                                nodes = {
                                    { n = G.UIT.T, config = {text = ' ' .. localize(disableable and 'k_active' or 'ph_no_boss_active') .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9}},
                                }
                            }
                        }
                    }
                }
            end
            return { vars = { card.ability.extra.dollars }, main_end = main_end }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.selling_self then
                if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.boss then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                    return {
                        message = localize('ph_boss_disabled'),
                        dollars = card.ability.extra.dollars,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.blind:disable()
                                    G.GAME.dollar_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    }

    -- Photograph
    SMODS["Mat" .. upp_obj]{
        key = "photograph_" .. obj,
        name = "Photograph " .. upp_obj,
        soul_pos = {x = 4, y = 8},
        rarity = 1,
        -- TODO: appropriate size for photograph consumable size and others with diff pixel_size
        pixel_size = {h = 95 / 1.2 },
        config = {extra = {xmult = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_face() then
                local is_first_face = false
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_face() then
                        is_first_face = context.scoring_hand[i] == context.other_card
                        break
                    end
                end
                if is_first_face then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end
    }

    -- Gift Card
    SMODS["Mat" .. upp_obj]{
        key = "gift_" .. obj,
        name = "Gift " .. upp_obj,
        soul_pos = {x = 5, y = 8},
        rarity = 2,
        config = {extra = {sell_value = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.sell_value}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                for _, area in ipairs({ G.jokers, G.consumeables }) do
                    for _, other_card in ipairs(area.cards) do
                        if other_card.set_cost then
                            other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                                card.ability.extra.sell_value
                            other_card:set_cost()
                        end
                    end
                end
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
        end
    }

    -- Turtle Bean
    SMODS["Mat" .. upp_obj]{
        key = "turtle_bean_" .. obj,
        name = "Turtle " .. upp_obj,
        soul_pos = {x = 6, y = 8},
        rarity = 2,
        config = {extra = {h_size = 3, h_mod = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.h_size, card.ability.extra.h_mod}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                if not jkr.mat_being_removed and card.ability.extra.h_size - card.ability.extra.h_mod <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            jkr.T.r = -0.2
                            jkr:juice_up(0.3, 0.4)
                            jkr.mat_being_removed = true
                            jkr.states.drag.is = true
                            jkr.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    jkr:remove()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.extra.h_size = card.ability.extra.h_size - card.ability.extra.h_mod
                    G.hand:change_size(-card.ability.extra.h_mod)
                    return {
                        message = localize { type = 'variable', key = 'a_handsize_minus', vars = {card.ability.extra.h_mod}},
                        colour = G.C.FILTER
                    }
                end
            end
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.hand:change_size(card.ability.extra.h_size)
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.hand:change_size(-card.ability.extra.h_size)
        end
    }

    -- Erosion
    SMODS["Mat" .. upp_obj]{
        key = "erosion_" .. obj,
        name = "Erosion " .. upp_obj,
        soul_pos = {x = 7, y = 8},
        rarity = 2,
        config = {extra = {mult = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult, math.max(0, card.ability.extra.mult * (G.playing_cards and (G.GAME.starting_deck_size - #G.playing_cards) or 0)), G.GAME.starting_deck_size}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    mult = math.max(0, card.ability.extra.mult * (G.GAME.starting_deck_size - #G.playing_cards))
                }
            end
        end
    }

    -- Reserved Parking
    SMODS["Mat" .. upp_obj]{
        key = "reserved_parking_" .. obj,
        name = "Reserved " .. upp_obj,
        soul_pos = {x = 8, y = 8},
        rarity = 1,
        config = {extra = {odds = 4, dollars = 1}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_reserved_parking")
            return { vars = {card.ability.extra.dollars, num, den}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.hand and not context.end_of_round then
                if context.other_card:is_face() and
                    SMODS.pseudorandom_probability(card, "mat_reserved_parking", G.GAME.probabilities.normal, card.ability.extra.odds) then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        }
                    else
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                        return {
                            dollars = card.ability.extra.dollars,
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.GAME.dollar_buffer = 0
                                        return true
                                    end
                                }))
                            end
                        }
                    end
                end
            end
        end
    }

    -- Mail-In Rebate
    SMODS["Mat" .. upp_obj]{
        key = "mail_" .. obj,
        name = "Mail " .. upp_obj,
        soul_pos = {x = 9, y = 8},
        rarity = 1,
        config = {extra = {dollars = 5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars, localize((G.GAME.current_round.mat_mail_card or {}).rank or 'Ace', 'ranks')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.discard and not context.other_card.debuff and
                context.other_card:get_id() == G.GAME.current_round.mat_mail_card.id then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    }

    local function reset_mat_mail_rank()
        G.GAME.current_round.mat_mail_card = {rank = 'Ace' }
        local valid_mail_cards = {}
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_rank(playing_card) then
                valid_mail_cards[#valid_mail_cards + 1] = playing_card
            end
        end
        local mail_card = pseudorandom_element(valid_mail_cards, pseudoseed('mat_mail' .. G.GAME.round_resets.ante))
        if mail_card then
            G.GAME.current_round.mat_mail_card.rank = mail_card.base.value
            G.GAME.current_round.mat_mail_card.id = mail_card.base.id
        end
    end


    -- To the Moon
    SMODS["Mat" .. upp_obj]{
        key = "to_the_moon_" .. obj,
        name = "To The Moon " .. upp_obj,
        soul_pos = {x = 0, y = 9},
        rarity = 2,
        config = {extra = {interest = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.interest}}
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.GAME.interest_amount = G.GAME.interest_amount + card.ability.extra.interest
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.GAME.interest_amount = G.GAME.interest_amount - card.ability.extra.interest
        end
    }

    -- Hallucination
    SMODS["Mat" .. upp_obj]{
        key = "hallucination_" .. obj,
        name = "Hallucination " .. upp_obj,
        soul_pos = {x = 1, y = 9},
        rarity = 1,
        config = {extra = {odds = 4}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_hallucination")
            return { vars = {num, den}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.open_booster and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                if SMODS.pseudorandom_probability(card, "mat_hallucination", G.GAME.probabilities.normal, card.ability.extra.odds) then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'mat_hallucination'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('k_plus_tarot'),
                        colour = G.C.PURPLE,
                    }
                end
            end
        end
    }

    -- Fortune Teller
    SMODS["Mat" .. upp_obj]{
        key = "fortune_teller_" .. obj,
        name = "Fortune Teller " .. upp_obj,
        soul_pos = {x = 2, y = 9},
        rarity = 1,
        config = {extra = {mult = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult, card.ability.extra.mult * (G.GAME.consumeable_usage_total and math.floor(G.GAME.consumeable_usage_total.tarot / 2) or 0)}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Tarot" then
                local old_usage = math.floor((G.GAME.consumeable_usage_total.tarot - 1) / 2)
                local new_usage = math.floor(G.GAME.consumeable_usage_total.tarot / 2)
                if new_usage > old_usage then
                    return {
                        message = localize { type = 'variable', key = 'a_mult', vars = {new_usage}},
                    }
                end
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult * (G.GAME.consumeable_usage_total and math.floor(G.GAME.consumeable_usage_total.tarot / 2) or 0)
                }
            end
        end,
    }

    -- Juggler
    SMODS["Mat" .. upp_obj]{
        key = "juggler_" .. obj,
        name = "Juggler " .. upp_obj,
        soul_pos = {x = 3, y = 9},
        rarity = 2,
        config = {extra = {h_size = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.h_size}}
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.hand:change_size(card.ability.extra.h_size)
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.hand:change_size(-card.ability.extra.h_size)
        end
    }

    -- Drunkard
    SMODS["Mat" .. upp_obj]{
        key = "drunkard_" .. obj,
        name = "Drunkard " .. upp_obj,
        soul_pos = {x = 4, y = 9},
        rarity = 2,
        config = {extra = {d_size = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.d_size}}
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
            ease_discard(card.ability.extra.d_size)
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
            ease_discard(-card.ability.extra.d_size)
        end
    }

    -- Stone Joker
    SMODS["Mat" .. upp_obj]{
        key = "stone_" .. obj,
        name = "Stone " .. upp_obj,
        soul_pos = {x = 5, y = 9},
        rarity = 2,
        config = {extra = {chips = 18}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_stone

            local stone_tally = 0
            if G.playing_card then
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_stone') then stone_tally = stone_tally + 1 end
                end
            end
            return { vars = {card.ability.extra.chips, card.ability.extra.chips * stone_tally}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local stone_tally = 0
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_stone') then stone_tally = stone_tally + 1 end
                end
                return {
                    chips = card.ability.extra.chips * stone_tally
                }
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_stone') then
                    return true
                end
            end
            return false
        end
    }

    -- Golden Joker
    SMODS["Mat" .. upp_obj]{
        key = "golden_" .. obj,
        name = "Golden " .. upp_obj,
        soul_pos = {x = 6, y = 9},
        rarity = 1,
        config = {extra = {dollars = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars}}
        end,
        mat_calc_dollar_bonus_obj = function(self, card)
            return card.ability.extra.dollars
        end
    }

    -- Lucky Cat
    SMODS["Mat" .. upp_obj]{
        key = "lucky_cat_" .. obj,
        name = "Lucky Cat " .. upp_obj,
        soul_pos = {x = 7, y = 9},
        rarity = 2,
        config = {extra = {Xmult_gain = 0.1, Xmult = 1}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky

            return { vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card.lucky_trigger and not context.blueprint then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
                }
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_lucky'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_lucky') then
                    return true
                end
            end
            return false
        end
    }

    -- Baseball Card
    SMODS["Mat" .. upp_obj]{
        key = "baseball_" .. obj,
        name = "Baseball " .. upp_obj,
        soul_pos = {x = 8, y = 9},
        rarity = 3,
        config = {extra = {xmult = 1.25}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.other_joker and (context.other_joker.config.center.rarity == 2 or context.other_joker.config.center.rarity == "Uncommon") then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- Bull
    SMODS["Mat" .. upp_obj]{
        key = "bull_" .. obj,
        name = "Bull " .. upp_obj,
        soul_pos = {x = 9, y = 9},
        rarity = 2,
        config = {extra = {chips = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips, card.ability.extra.chips * math.max(0, (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0))}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return { -- TODO: Check Talisman compat
                    chips = card.ability.extra.chips * math.max(0, (G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
                }
            end
        end,
    }

    -- Diet Cola
    SMODS["Mat" .. upp_obj]{
        key = "diet_cola_" .. obj,
        name = "Diet Cola " .. upp_obj,
        soul_pos = {x = 0, y = 10},
        rarity = 2,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = {key = 'tag_double', set = 'Tag' }
            return { vars = {localize { type = 'name_text', set = 'Tag', key = 'tag_double'}} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.selling_self then
                return {
                    func = function()
                        -- This is for retrigger purposes, Jokers need to return something to retrigger
                        -- You can also do this outside the return and `return nil, true` instead
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                add_tag(Tag('tag_double'))
                                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                                return true
                            end)
                        }))
                    end
                }
            end
        end,
    }

    -- Trading Card
    SMODS["Mat" .. upp_obj]{
        key = "trading_" .. obj,
        name = "Trading " .. upp_obj,
        soul_pos = {x = 1, y = 10},
        rarity = 2,
        config = {extra = {dollars = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.first_hand_drawn then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
                juice_card_until(jkr, eval, true)
            end
            if context.discard and not context.blueprint and
                G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
                return {
                    dollars = card.ability.extra.dollars,
                    remove = true
                }
            end
        end
    }

    -- Flash Card
    SMODS["Mat" .. upp_obj]{
        key = "flash_" .. obj,
        name = "" .. upp_obj,
        soul_pos = {x = 2, y = 10},
        rarity = 2,
        config = {extra = {mult_gain = 1, mult = 0}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult_gain, card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.reroll_shop and not context.blueprint then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    colour = G.C.MULT,
                }
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    -- Popcorn
    SMODS["Mat" .. upp_obj]{
        key = "popcorn_" .. obj,
        name = "Popcorn " .. upp_obj,
        soul_pos = {x = 3, y = 10},
        rarity = 1,
        config = {extra = {mult_loss = 2, mult = 10}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult, card.ability.extra.mult_loss}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                if not jkr.mat_being_removed and card.ability.extra.mult - card.ability.extra.mult_loss <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            jkr.T.r = -0.2
                            jkr:juice_up(0.3, 0.4)
                            jkr.mat_being_removed = true
                            jkr.states.drag.is = true
                            jkr.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    jkr:remove()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.RED
                    }
                else
                    card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_loss
                    return {
                        message = localize { type = 'variable', key = 'a_mult_minus', vars = {card.ability.extra.mult_loss}},
                        colour = G.C.MULT
                    }
                end
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    -- Spare Trousers
    SMODS["Mat" .. upp_obj]{
        key = "trousers_" .. obj,
        name = "Trousers " .. upp_obj,
        soul_pos = {x = 4, y = 10},
        rarity = 2,
        config = {extra = {mult_gain = 1, mult = 0}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult_gain, localize('Two Pair', 'poker_hands'), card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint and (next(context.poker_hands['Two Pair']) or next(context.poker_hands['Full House'])) then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED
                }
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    -- Ancient Joker
    SMODS["Mat" .. upp_obj]{
        key = "ancient_" .. obj,
        name = "Ancient " .. upp_obj,
        soul_pos = {x = 5, y = 10},
        rarity = 3,
        config = {extra = {xmult = 1.25}},
        loc_vars = function(self, info_queue, card)
            local suit = (G.GAME.current_round.mat_ancient_card or {}).suit or 'Spades'
            return { vars = {card.ability.extra.xmult, localize(suit, 'suits_singular'), colours = {G.C.SUITS[suit]}} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_suit(G.GAME.current_round.mat_ancient_card.suit) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }

    local function reset_mat_ancient_card()
        G.GAME.current_round.mat_ancient_card = G.GAME.current_round.mat_ancient_card or { suit = 'Spades' }
        local ancient_suits = {}
        for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
            if v ~= G.GAME.current_round.mat_ancient_card.suit then ancient_suits[#ancient_suits + 1] = v end
        end
        local ancient_card = pseudorandom_element(ancient_suits, pseudoseed('mat_ancient' .. G.GAME.round_resets.ante))
        G.GAME.current_round.mat_ancient_card.suit = ancient_card
    end

    -- Ramen
    SMODS["Mat" .. upp_obj]{
        key = "ramen_" .. obj,
        name = "Ramen " .. upp_obj,
        soul_pos = {x = 6, y = 10},
        rarity = 2,
        config = {extra = {Xmult_loss = 0.005, Xmult = 1.5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_loss}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.discard and not context.blueprint then
                if not jkr.mat_being_removed and card.ability.extra.Xmult - card.ability.extra.Xmult_loss <= 1 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            jkr.T.r = -0.2
                            jkr:juice_up(0.3, 0.4)
                            jkr.mat_being_removed = true
                            jkr.states.drag.is = true
                            jkr.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    jkr:remove()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.Xmult_loss
                    return {
                        message = localize { type = 'variable', key = 'a_xmult_minus', vars = {card.ability.extra.Xmult_loss}},
                        colour = G.C.RED
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end
    }

    -- Walkie Talkie
    SMODS["Mat" .. upp_obj]{
        key = "walkie_talkie_" .. obj,
        name = "Walkie Talkie" .. upp_obj,
        soul_pos = {x = 7, y = 10},
        rarity = 1,
        config = {extra = {chips = 5, mult = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips, card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                (context.other_card:get_id() == 10 or context.other_card:get_id() == 4) then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    -- Seltzer
    SMODS["Mat" .. upp_obj]{
        key = "selzer_" .. obj,
        name = "Selzer " .. upp_obj,
        soul_pos = {x = 8, y = 10},
        rarity = 2,
        config = {extra = {hands_left = 5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.hands_left}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.repetition and context.cardarea == G.play then
                return {
                    repetitions = 1
                }
            end
            if context.after and not context.blueprint then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                if not jkr.mat_being_removed and card.ability.extra.hands_left - 1 <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            jkr.T.r = -0.2
                            jkr:juice_up(0.3, 0.4)
                            jkr.mat_being_removed = true
                            jkr.states.drag.is = true
                            jkr.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    jkr:remove()
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                    return {
                        message = localize('k_drank_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.extra.hands_left = card.ability.extra.hands_left - 1
                    return {
                        message = card.ability.extra.hands_left .. '',
                        colour = G.C.FILTER
                    }
                end
            end
        end
    }

    -- Castle
    SMODS["Mat" .. upp_obj]{
        key = "castle_" .. obj,
        name = "Castle " .. upp_obj,
        soul_pos = {x = 9, y = 10},
        rarity = 2,
        config = {extra = {chips = 0, chip_mod = 2}},
        loc_vars = function(self, info_queue, card)
            local suit = (G.GAME.current_round.mat_castle_card or {}).suit or 'Spades'
            return { vars = {card.ability.extra.chip_mod, localize(suit, 'suits_singular'), card.ability.extra.chips, colours = {G.C.SUITS[suit]}} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.discard and not context.blueprint and not context.other_card.debuff and
                context.other_card:is_suit(G.GAME.current_round.mat_castle_card.suit) then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    }

    local function reset_mat_castle_card()
        G.GAME.current_round.mat_castle_card = {suit = 'Spades' }
        local valid_castle_cards = {}
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_suit(playing_card) then
                valid_castle_cards[#valid_castle_cards + 1] = playing_card
            end
        end
        local castle_card = pseudorandom_element(valid_castle_cards,
            pseudoseed('mat_castle' .. G.GAME.round_resets.ante))
        if castle_card then
            G.GAME.current_round.mat_castle_card.suit = castle_card.base.suit
        end
    end

    -- Smiley Face
    SMODS["Mat" .. upp_obj]{
        key = "smiley_" .. obj,
        name = "Smiley " .. upp_obj,
        soul_pos = {x = 0, y = 11},
        rarity = 1,
        config = {extra = {mult = 2}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_face() then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }

    -- Campfire
    SMODS["Mat" .. upp_obj]{
        key = "campfire_" .. obj,
        name = "Campfire " .. upp_obj,
        soul_pos = {x = 1, y = 11},
        rarity = 3,
        config = {extra = {xmult_gain = 0.1, xmult = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.selling_card and not context.blueprint then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize('k_upgrade_ex')
                }
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                if G.GAME.blind.boss and card.ability.extra.xmult > 1 then
                    card.ability.extra.xmult = 1
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    }

    ------- WIP ----------------------------------------------------------------

    -- Golden Ticket
    SMODS["Mat" .. upp_obj]{
        key = "ticket_" .. obj,
        name = "Ticket " .. upp_obj,
        soul_pos = {x = 2, y = 11},
        rarity = 1,
        config = {extra = {dollars = 2}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
            return { vars = {card.ability.extra.dollars}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                SMODS.has_enhancement(context.other_card, 'm_gold') then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end,
        in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_gold'`
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_gold') then
                    return true
                end
            end
            return false
        end,
    }

    -- Mr. Bones
    SMODS["Mat" .. upp_obj]{
        key = "mr_bones_" .. obj,
        name = "Mr. Bones " .. upp_obj,
        soul_pos = {x = 3, y = 11},
        rarity = 3,
        mat_calculate_obj = function(self, card, context)
            if context.end_of_round and context.game_over and context.main_eval then
                if G.GAME.chips / G.GAME.blind.chips >= 0.25 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand_text_area.blind_chips:juice_up()
                            G.hand_text_area.game_chips:juice_up()
                            play_sound('tarot1')
                            card:start_dissolve()
                            return true
                        end
                    }))
                    return {
                        message = localize('k_saved_ex'),
                        saved = 'ph_mr_bones',
                        colour = G.C.RED
                    }
                end
            end
        end,
    }

    -- Acrobat
    SMODS["Mat" .. upp_obj]{
        key = "acrobat_" .. obj,
        name = "Acrobat " .. upp_obj,
        soul_pos = {x = 4, y = 11},
        rarity = 2,
        config = {extra = {xmult = 1.75}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and G.GAME.current_round.hands_left == 0 then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- Sock and Buskin
    SMODS["Mat" .. upp_obj]{
        key = "sock_and_buskin_" .. obj,
        name = "Sock and Buskin " .. upp_obj,
        soul_pos = {x = 5, y = 11},
        rarity = 3,
        config = {extra = {repetitions = 1}},
        mat_calculate_obj = function(self, card, context)
            if context.repetition and context.cardarea == G.play and context.other_card:is_face() then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end,
    }

    -- Swashbuckler
    SMODS["Mat" .. upp_obj]{
        key = "swashbuckler_" .. obj,
        name = "Swashbuckler " .. upp_obj,
        soul_pos = {x = 6, y = 11},
        rarity = 1,
        config = {extra = {mult = 1}},
        loc_vars = function(self, info_queue, card)
            local sell_cost = 0
            local jkr, my_pos = mat_mod.get_parent_obj(card)
            for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
                if joker ~= jkr then
                    sell_cost = sell_cost + joker.sell_cost
                end
            end
            return { vars = { (not G.jokers and 0) or card.ability.extra.mult * math.floor(sell_cost / 2) } }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local sell_cost = 0
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                for _, joker in ipairs(G.jokers.cards) do
                    if joker ~= jkr then
                        sell_cost = sell_cost + joker.sell_cost
                    end
                end
                return {
                    mult = card.ability.extra.mult * math.floor(sell_cost / 2)
                }
            end
        end,
    }

    -- Troubadour
    SMODS["Mat" .. upp_obj]{
        key = "troubadour_" .. obj,
        name = "Troubadour " .. upp_obj,
        soul_pos = {x = 7, y = 11},
        rarity = 2,
        config = {extra = {h_size = 1, h_plays = -1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.h_size, -card.ability.extra.h_plays}}
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
            G.hand:change_size(card.ability.extra.h_size)
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
            G.hand:change_size(-card.ability.extra.h_size)
        end,
    }

    -- Certificate
    SMODS["Mat" .. upp_obj]{
        key = "certificate_" .. obj,
        name = "Certificate " .. upp_obj,
        soul_pos = {x = 8, y = 11},
        rarity = 3,
        mat_calculate_obj = function(self, card, context)
            if context.first_hand_drawn then
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                local _card = create_playing_card({
                    front = pseudorandom_element(G.P_CARDS, pseudoseed('mat_certificate')),
                    center = G.P_CENTERS.c_base
                }, G.discard, true, nil, { G.C.SECONDARY_SET.Enhanced }, true)
                _card:set_seal(SMODS.poll_seal({ guaranteed = true, type_key = 'mat_certificate_seal' }))
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.hand:emplace(_card)
                                _card:start_materialize()
                                G.GAME.blind:debuff_card(_card)
                                G.hand:sort()
                                if context.blueprint_card then
                                    context.blueprint_card:juice_up()
                                else
                                    jkr:juice_up()
                                end
                                return true
                            end
                        }))
                        SMODS.calculate_context({ playing_card_added = true, cards = {_card}})
                    end
                }
            end
        end,
    }

    -- Smeared Joker
    SMODS["Mat" .. upp_obj]{
        key = "smeared_" .. obj,
        name = "Smeared " .. upp_obj,
        soul_pos = {x = 9, y = 11},
        rarity = 2,
        config = {extra = {Xmult = 1.75}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS["j_smeared"]
            return { vars = { card.ability.extra.Xmult } }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and (next(context.poker_hands['Flush'])) then
                local suits = {}
                local suit_count = 0
                for _, v in ipairs(context.scoring_hand) do
                    if not (SMODS.has_no_suit(v) or v.debuff) and not suits[v.base_suit] then
                        suit_count = suit_count + 1
                        suits[v.base.suit] = true
                    end
                end
                if suit_count > 1 then
                    return {
                        xmult = card.ability.extra.Xmult
                    }
                end
            end
        end,
    }

    function mat_mod.smeared_obj_check(card, suit)
        if ((card.base.suit == 'Hearts' or card.base.suit == 'Diamonds') and (suit == 'Hearts' or suit == 'Diamonds')) then
            return true
        elseif (card.base.suit == 'Spades' or card.base.suit == 'Clubs') and (suit == 'Spades' or suit == 'Clubs') then
            return true
        end
        return false
    end

    local card_is_suit_ref = Card.is_suit
    function Card:is_suit(suit, bypass_debuff, flush_calc)
        local ret = card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
        if not ret and not SMODS.has_no_suit(self) and next(mat_mod.find_object("smeared")) then
            return mat_mod.smeared_obj_check(self, suit)
        end
        return ret
    end

    -- Throwback
    SMODS["Mat" .. upp_obj]{
        key = "throwback_" .. obj,
        name = "Throwback " .. upp_obj,
        soul_pos = {x = 0, y = 12},
        rarity = 2,
        config = {extra = {xmult = 0.1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult, 1 + G.GAME.skips * card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.skip_blind and not context.blueprint then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = {1 + G.GAME.skips * card.ability.extra.xmult}}
                }
            end
            if context.joker_main then
                return {
                    xmult = 1 + G.GAME.skips * card.ability.extra.xmult
                }
            end
        end,
    }

    -- Hanging Chad
    SMODS["Mat" .. upp_obj]{
        key = "hanging_chad_" .. obj,
        name = "Hanging Chad " .. upp_obj,
        soul_pos = {x = 1, y = 12},
        rarity = 1,
        config = {extra = {repetitions = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.repetitions}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end,
    }

    -- Rough Gem
    SMODS["Mat" .. upp_obj]{
        key = "rough_gem_" .. obj,
        name = "Rough Gem " .. upp_obj,
        soul_pos = {x = 2, y = 12},
        rarity = 2,
        config = {extra = {dollars = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_suit("Diamonds") then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end,
    }

    -- Bloodstone
    SMODS["Mat" .. upp_obj]{
        key = "bloodstone_" .. obj,
        name = "Bloodstone " .. upp_obj,
        soul_pos = {x = 3, y = 12},
        rarity = 2,
        config = {extra = {odds = 4, Xmult = 1.5}},
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, "mat_bloodstone")
            return { vars = {num, den, card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") and
                SMODS.pseudorandom_probability(card, "mat_bloodstone", G.GAME.probabilities.normal, card.ability.extra.odds) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- Arrowhead
    SMODS["Mat" .. upp_obj]{
        key = "arrowhead_" .. obj,
        name = "Arrowhead " .. upp_obj,
        soul_pos = {x = 4, y = 12},
        rarity = 2,
        config = {extra = {chips = 25}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_suit("Spades") then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end,
    }

    -- Onyx Agate
    SMODS["Mat" .. upp_obj]{
        key = "onyx_agate_" .. obj,
        name = "Onyx Agate " .. upp_obj,
        soul_pos = {x = 5, y = 12},
        rarity = 2,
        config = {extra = {mult = 4}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_suit("Clubs") then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end,
    }

    -- Glass Joker
    SMODS["Mat" .. upp_obj]{
        key = "glass_" .. obj,
        name = "Glass " .. upp_obj,
        soul_pos = {x = 6, y = 12},
        rarity = 2,
        config = {extra = {Xmult_gain = 0.35, Xmult = 1}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
            return { vars = {card.ability.extra.Xmult_gain, card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.remove_playing_cards and not context.blueprint then
                local glass_cards = 0
                for _, removed_card in ipairs(context.removed) do
                    if removed_card.shattered then glass_cards = glass_cards + 1 end
                end
                if glass_cards > 0 then
                    return {
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.E_MANAGER:add_event(Event({
                                        func = function()
                                            card.ability.extra.Xmult = card.ability.extra.Xmult +
                                                card.ability.extra.Xmult_gain * glass_cards
                                            return true
                                        end
                                    }))
                                    SMODS.calculate_effect(
                                        {
                                            message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult +
                                            card.ability.extra.Xmult_gain * glass_cards}}
                                        }, card)
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
            if context.using_consumeable and not context.blueprint and context.consumeable.config.center.key == 'c_hanged_man' then
                -- Glass Joker updates on Hanged Man and no other destroy consumable
                local glass_cards = 0
                for _, removed_card in ipairs(G.hand.highlighted) do
                    if SMODS.has_enhancement(removed_card, 'm_glass') then glass_cards = glass_cards + 1 end
                end
                if glass_cards > 0 then
                    card.ability.extra.Xmult = card.ability.extra.Xmult +
                        card.ability.extra.Xmult_gain * glass_cards
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
        in_pool = function(self, args)
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_glass') then
                    return true
                end
            end
            return false
        end,
    }

    -- Showman
    SMODS["Mat" .. upp_obj]{
        key = "showman_" .. obj,
        name = "Showman " .. upp_obj,
        soul_pos = {x = 7, y = 12},
        rarity = 2,
        config = {extra = {xmult = 1.5}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS["j_ring_master"]
            return { vars = {card.ability.extra.xmult} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local unique = {}
                for k, v in ipairs(G.jokers.cards) do
                    if not unique[v.config.center.key] and v.config.center.key ~= "j_mat_custom_joker" then
                        unique[v.config.center.key] = true
                    end
                end
                if #unique < #G.jokers.cards then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end,
    }

    local sm = SMODS.showman
    function SMODS.showman(card_key)
        if SMODS.create_card_allow_duplicates or next(mat_mod.find_object('showman')) then
            return true
        end
        return sm(card_key)
    end

    -- Flower Pot
    SMODS["Mat" .. upp_obj]{
        key = "flower_pot_" .. obj,
        name = "Flower Pot " .. upp_obj,
        soul_pos = {x = 8, y = 12},
        rarity = 2,
        config = {extra = {Xmult = 1.75}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local suits = {
                    ['Hearts'] = 0,
                    ['Diamonds'] = 0,
                    ['Spades'] = 0,
                    ['Clubs'] = 0
                }
                for i = 1, #context.scoring_hand do
                    if not SMODS.has_any_suit(context.scoring_hand[i]) then
                        if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then
                            suits["Hearts"] = suits["Hearts"] + 1
                        elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0 then
                            suits["Diamonds"] = suits["Diamonds"] + 1
                        elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0 then
                            suits["Spades"] = suits["Spades"] + 1
                        elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0 then
                            suits["Clubs"] = suits["Clubs"] + 1
                        end
                    end
                end
                for i = 1, #context.scoring_hand do
                    if SMODS.has_any_suit(context.scoring_hand[i]) then
                        if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then
                            suits["Hearts"] = suits["Hearts"] + 1
                        elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0 then
                            suits["Diamonds"] = suits["Diamonds"] + 1
                        elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0 then
                            suits["Spades"] = suits["Spades"] + 1
                        elseif context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0 then
                            suits["Clubs"] = suits["Clubs"] + 1
                        end
                    end
                end
                if suits["Hearts"] > 0 and
                    suits["Diamonds"] > 0 and
                    suits["Spades"] > 0 and
                    suits["Clubs"] > 0 then
                    return {
                        xmult = card.ability.extra.Xmult
                    }
                end
            end
        end,
    }

    -- Blueprint
    SMODS["Mat" .. upp_obj]{
        key = "blueprint_" .. obj,
        name = "Blueprint " .. upp_obj,
        soul_pos = {x = 9, y = 12},
        rarity = 3,
        loc_vars = function(self, info_queue, card)
            local other_joker
            local jkr, my_pos = mat_mod.get_parent_obj(card)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == jkr then other_joker = G.jokers.cards[i + 1] end
            end
            main_end = (jkr and jkr.area and jkr.area == G.jokers) and {
                {
                    n = G.UIT.C,
                    config = {align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = {text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8}},
                            }
                        }
                    }
                }
            } or nil
            return { main_end = main_end }
        end,
        mat_calculate_obj = function(self, card, context)
            local other_joker = nil
            local jkr, my_pos = mat_mod.get_parent_obj(card)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == jkr then other_joker = G.jokers.cards[i + 1] end
            end
            return SMODS.blueprint_effect(card, other_joker, context)
        end,
    }

    -- Wee Joker
    SMODS["Mat" .. upp_obj]{
        key = "wee_" .. obj,
        name = "Wee " .. upp_obj,
        soul_pos = {x = 0, y = 13},
        rarity = 3,
        display_size = {w = 71 * 0.7, h = 95 * 0.7 },
        config = {extra = {chips = 0, chip_mod = 4}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 and not context.blueprint then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    message_card = card
                }
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end,
    }

    -- Merry Andy
    SMODS["Mat" .. upp_obj]{
        key = "merry_andy_" .. obj,
        name = "Merry Andy " .. upp_obj,
        soul_pos = {x = 1, y = 13},
        rarity = 2,
        config = {extra = {d_size = 2, h_size = -1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.d_size, card.ability.extra.h_size}}
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
            ease_discard(card.ability.extra.d_size)
            G.hand:change_size(card.ability.extra.h_size)
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
            ease_discard(-card.ability.extra.d_size)
            G.hand:change_size(-card.ability.extra.h_size)
        end,
    }

    -- Oops! All 6s
    SMODS["Mat" .. upp_obj]{
        key = "oops_" .. obj,
        name = "" .. upp_obj,
        soul_pos = {x = 2, y = 13},
        rarity = 2,
        mat_calculate_obj = function(self, card, context)
            if context.mod_probability then
                return {
                    numerator = context.numerator * 1.5
                }
            end
        end,
            
    }

    -- The Idol
    SMODS["Mat" .. upp_obj]{
        key = "idol_" .. obj,
        name = "Idol " .. upp_obj,
        soul_pos = {x = 3, y = 13},
        rarity = 2,
        config = {extra = {xmult = 1.5}},
        loc_vars = function(self, info_queue, card)
            local idol_card = G.GAME.current_round.mat_idol_card or { rank = 'Ace', suit = 'Spades' }
            return { vars = {card.ability.extra.xmult, localize(idol_card.rank, 'ranks'), localize(idol_card.suit, 'suits_plural'), colours = {G.C.SUITS[idol_card.suit]}} }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                context.other_card:get_id() == G.GAME.current_round.mat_idol_card.id and
                context.other_card:is_suit(G.GAME.current_round.mat_idol_card.suit) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    local function reset_mat_idol_card()
        G.GAME.current_round.mat_idol_card = {rank = 'Ace', suit = 'Spades' }
        local valid_idol_cards = {}
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                valid_idol_cards[#valid_idol_cards + 1] = playing_card
            end
        end
        local idol_card = pseudorandom_element(valid_idol_cards, pseudoseed('mat_idol' .. G.GAME.round_resets.ante))
        if idol_card then
            G.GAME.current_round.mat_idol_card.rank = idol_card.base.value
            G.GAME.current_round.mat_idol_card.suit = idol_card.base.suit
            G.GAME.current_round.mat_idol_card.id = idol_card.base.id
        end
    end

    -- Seeing Double
    SMODS["Mat" .. upp_obj]{
        key = "seeing_double_" .. obj,
        name = "Seeing Double " .. upp_obj,
        soul_pos = {x = 4, y = 13},
        rarity = 2,
        config = {extra = {xmult = 1.5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and SMODS.seeing_double_check(context.scoring_hand, 'Clubs') then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- Matador
    SMODS["Mat" .. upp_obj]{
        key = "matador_" .. obj,
        name = "Matador " .. upp_obj,
        soul_pos = {x = 5, y = 13},
        rarity = 2,
        config = {extra = {dollars = 4}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.dollars}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.debuffed_hand or context.joker_main then
                if G.GAME.blind.triggered then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                    return {
                        dollars = card.ability.extra.dollars,
                        func = function() -- This is for timing purposes, it runs after the dollar manipulation
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.dollar_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end,
    }

    -- Hit the Road
    SMODS["Mat" .. upp_obj]{
        key = "hit_the_road_" .. obj,
        name = "Hit The Road " .. upp_obj,
        soul_pos = {x = 6, y = 13},
        rarity = 3,
        config = {extra = {xmult_gain = 0.25, xmult = 1}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.discard and not context.blueprint and
                not context.other_card.debuff and
                context.other_card:get_id() == 11 then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
                    colour = G.C.RED
                }
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                card.ability.extra.xmult = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- The Duo
    SMODS["Mat" .. upp_obj]{
        key = "duo_" .. obj,
        name = "Duo " .. upp_obj,
        soul_pos = {x = 7, y = 13},
        rarity = 3,
        config = {extra = {Xmult = 1.5, type = 'Pair'}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- The Trio
    SMODS["Mat" .. upp_obj]{
        key = "trio_" .. obj,
        name = "Trio " .. upp_obj,
        soul_pos = {x = 8, y = 13},
        rarity = 3,
        config = {extra = {Xmult = 1.75, type = 'Three of a Kind'}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- The Family
    SMODS["Mat" .. upp_obj]{
        key = "family_" .. obj,
        name = "Family " .. upp_obj,
        soul_pos = {x = 9, y = 13},
        rarity = 3,
        config = {extra = {Xmult = 2, type = 'Four of a Kind'}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- The Order
    SMODS["Mat" .. upp_obj]{
        key = "order_" .. obj,
        name = "Order " .. upp_obj,
        soul_pos = {x = 0, y = 14},
        rarity = 3,
        config = {extra = {Xmult = 3, type = 'Straight'}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- The Tribe
    SMODS["Mat" .. upp_obj]{
        key = "tribe_" .. obj,
        name = "Tribe " .. upp_obj,
        soul_pos = {x = 1, y = 14},
        rarity = 3,
        config = {extra = {Xmult = 1.5, type = 'Flush'}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands')}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }

    -- Stuntman
    SMODS["Mat" .. upp_obj]{
        key = "stuntman_" .. obj,
        name = "Stuntman " .. upp_obj,
        soul_pos = {x = 2, y = 14},
        rarity = 3,
        config = {extra = {h_size = 1, chip_mod = 125}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.chip_mod, card.ability.extra.h_size}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    chips = card.ability.extra.chip_mod
                }
            end
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.hand:change_size(-card.ability.extra.h_size)
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.hand:change_size(card.ability.extra.h_size)
        end,
    }

    -- Invisible Joker
    SMODS["Mat" .. upp_obj]{
        key = "invisible_" .. obj,
        name = "Invisible " .. upp_obj,
        soul_pos = {x = 3, y = 14},
        rarity = 3,
        draw = function(self, card, layer)
            if card.config.center.discovered or card.bypass_discovery_center then
                card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
            end
        end,
        config = {extra = {invis_rounds = 0, total_rounds = 2}},
        loc_vars = function(self, info_queue, card)
            local main_end
            if G.jokers and G.jokers.cards then
                for _, joker in ipairs(G.jokers.cards) do
                    if joker.edition and joker.edition.negative then
                        main_end = {}
                        localize { type = 'other', key = 'remove_negative', nodes = main_end, vars = {} }
                        break
                    end
                end
            end
            return { vars = {card.ability.extra.total_rounds, card.ability.extra.invis_rounds }, main_end = main_end }
        end,
        mat_calculate_obj = function(self, card, context)
            if context.selling_self and (card.ability.extra.invis_rounds >= card.ability.extra.total_rounds) and not context.blueprint then
                local jokers = {}
                local jkr, my_pos = mat_mod.get_parent_obj(card)
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= jkr then
                        jokers[#jokers + 1] = G.jokers.cards[i]
                    end
                end
                if #jokers > 0 then
                    if #G.jokers.cards <= G.jokers.config.card_limit then
                        local chosen_joker = pseudorandom_element(jokers, pseudoseed('mat_invisible'))
                        local copied_joker = copy_card(chosen_joker, nil, nil, nil,
                            chosen_joker.edition and chosen_joker.edition.negative)
                        copied_joker:add_to_deck()
                        G.jokers:emplace(copied_joker)
                        return { message = localize('k_duplicated_ex') }
                    else
                        return { message = localize('k_no_room_ex') }
                    end
                else
                    return { message = localize('k_no_other_jokers') }
                end
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                card.ability.extra.invis_rounds = card.ability.extra.invis_rounds + 1
                if card.ability.extra.invis_rounds == card.ability.extra.total_rounds then
                    local eval = function(card) return not card.REMOVED end
                    juice_card_until(card, eval, true)
                end
                return {
                    message = (card.ability.extra.invis_rounds < card.ability.extra.total_rounds) and
                        (card.ability.extra.invis_rounds .. '/' .. card.ability.extra.total_rounds) or
                        localize('k_active_ex'),
                    colour = G.C.FILTER
                }
            end
        end,
    }

    -- Brainstorm
    SMODS["Mat" .. upp_obj]{
        key = "brainstorm_" .. obj,
        name = "Brainstorm " .. upp_obj,
        soul_pos = {x = 4, y = 14},
        rarity = 3,
        loc_vars = function(self, info_queue, card)
            main_end = (card.area and card.area == G.jokers) and {
                {
                    n = G.UIT.C,
                    config = {align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = {text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8}},
                            }
                        }
                    }
                }
            } or nil
            return { main_end = main_end }
        end,
        mat_calculate_obj = function(self, card, context)
            local ret = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
            if ret then
                ret.colour = G.C.RED
            end
            return ret
        end,
    }

    -- Satellite
    SMODS["Mat" .. upp_obj]{
        key = "satellite_" .. obj,
        name = "Satellite" .. upp_obj,
        soul_pos = {x = 5, y = 14},
        rarity = 2,
        config = {extra = {dollars = 1}},
        loc_vars = function(self, info_queue, card)
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Planet' then planets_used = planets_used + 1 end end
            return { vars = {card.ability.extra.dollars, math.floor(planets_used / 2) * card.ability.extra.dollars}}
        end,
        mat_calc_dollar_bonus_obj = function(self, card)
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Planet' then planets_used = planets_used + 1 end
            end
            return planets_used > 0 and math.floor(planets_used / 2) * card.ability.extra.dollars or nil
        end,
    }

    -- Shoot the Moon
    SMODS["Mat" .. upp_obj]{
        key = "shoot_the_moon_" .. obj,
        name = "Shoot The Moon " .. upp_obj,
        soul_pos = {x = 6, y = 14},
        rarity = 1,
        config = {extra = {mult = 7}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 12 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end,
    }

    -- Driver's License
    SMODS["Mat" .. upp_obj]{
        key = "drivers_license_" .. obj,
        name = "Driver's " .. upp_obj,
        soul_pos = {x = 6, y = 14},
        rarity = 3,
        config = {extra = {xmult = 1.75, driver_amount = 16}},
        loc_vars = function(self, info_queue, card)
            local driver_tally = 0
            for _, playing_card in pairs(G.playing_cards or {}) do
                if next(SMODS.get_enhancements(playing_card)) then driver_tally = driver_tally + 1 end
            end
            return { vars = {card.ability.extra.xmult, card.ability.extra.driver_amount, driver_tally}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                local driver_tally = 0
                for _, playing_card in pairs(G.playing_cards) do
                    if next(SMODS.get_enhancements(playing_card)) then driver_tally = driver_tally + 1 end
                end
                if driver_tally >= card.ability.extra.driver_amount then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end,
    }

    -- Cartomancer
    SMODS["Mat" .. upp_obj]{
        key = "cartomancer_" .. obj,
        name = "Cartomancer " .. upp_obj,
        soul_pos = {x = 7, y = 14},
        rarity = 2,
        mat_calculate_obj = function(self, card, context)
            if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            key_append = 'mat_cartomancer'
                                        }
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end
                                }))
                                SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                                    context.blueprint_card or card)
                                return true
                            end)
                        }))
                    end
                }
            end
        end,
    }

    -- Astronomer
    SMODS["Mat" .. upp_obj]{
        key = "astronomer_" .. obj,
        name = "Astronomer " .. upp_obj,
        soul_pos = {x = 7, y = 14},
        rarity = 2,
        config = {extra = {dollars = 2}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS["j_astronomer"]
            return { vars = {card.ability.extra.dollars} }
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for k, v in pairs(G.I.CARD) do
                        if v.set_cost then v:set_cost() end
                    end
                    return true
                end
            }))
        end,
        mat_remove_from_deck_obj = function(self, card, from_debuff)
            G.E_MANAGER:add_event(Event({
                func = function()
                    for k, v in pairs(G.I.CARD) do
                        if v.set_cost then v:set_cost() end
                    end
                    return true
                end
            }))
        end,
        mat_calculate_obj = function(self, card, context)
            if context.starting_shop then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_booster_to_shop("p_celestial_normal_" .. (math.random(1, 4)))
                        return true
                    end
                }))
            end
        end,
    }

    local card_set_cost_ref = Card.set_cost
    function Card:set_cost()
        card_set_cost_ref(self)
        if next(mat_mod.find_object("astronomer")) then
            if (self.ability.set == 'Planet' or (self.ability.set == 'Booster' and self.config.center.kind == 'Celestial')) then self.cost = 0 end
            self.sell_cost = math.max(1, math.floor(self.cost / 2)) + (self.ability.extra_value or 0)
            self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
        end
    end

    -- Burnt Joker
    SMODS["Mat" .. upp_obj]{
        key = "burnt_" .. obj,
        name = "Burnt " .. upp_obj,
        soul_pos = {x = 7, y = 14},
        rarity = 3,
        mat_calculate_obj = function(self, card, context)
            if context.pre_discard and G.GAME.current_round.discards_used <= 0 and not context.hook then
                local text, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                return {
                    level_up = true,
                    level_up_hand = text
                }
            end
        end,
    }

    -- Bootstraps
    SMODS["Mat" .. upp_obj]{
        key = "bootstraps_" .. obj,
        name = "Boostraps " .. upp_obj,
        soul_pos = {x = 8, y = 14},
        rarity = 2,
        config = {extra = {mult = 1, dollars = 5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.mult, card.ability.extra.dollars, card.ability.extra.mult * math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / card.ability.extra.dollars)}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult * math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / card.ability.extra.dollars)
                }
            end
        end,
    }

    -- Canio
    SMODS["Mat" .. upp_obj]{
        key = "canio_" .. obj,
        name = "Canio " .. upp_obj,
        soul_pos = {x = 9, y = 14},
        rarity = 4,
        config = {extra = {xmult = 1, xmult_gain = 0.5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult_gain, card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.remove_playing_cards and not context.blueprint then
                local face_cards = 0
                for _, removed_card in ipairs(context.removed) do
                    if removed_card:is_face() then face_cards = face_cards + 1 end
                end
                if face_cards > 0 then
                    card.ability.extra.xmult = card.ability.extra.xmult + face_cards * card.ability.extra.xmult_gain
                    return { message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}} }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- Triboulet
    SMODS["Mat" .. upp_obj]{
        key = "triboulet_" .. obj,
        name = "Triboulet " .. upp_obj,
        soul_pos = {x = 0, y = 15},
        rarity = 4,
        config = {extra = {xmult = 1.5}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                (context.other_card:get_id() == 12 or context.other_card:get_id() == 13) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- Yorick
    SMODS["Mat" .. upp_obj]{
        key = "yorick_" .. obj,
        name = "Yorick " .. upp_obj,
        soul_pos = {x = 1, y = 15},
        rarity = 4,
        config = {extra = {xmult = 1, xmult_gain = 0.5, discards = 23, discards_remaining = 23}},
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.extra.xmult_gain, card.ability.extra.discards, card.ability.extra.discards_remaining, card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.discard and not context.blueprint then
                if card.ability.extra.discards_remaining <= 1 then
                    card.ability.extra.discards_remaining = card.ability.extra.discards
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
                        colour = G.C.RED
                    }
                else
                    return {
                        -- This is for retrigger purposes, Jokers need to return something to retrigger
                        -- You can also do this outside the return and `return nil, true` instead
                        func = function()
                            card.ability.extra.discards_remaining = card.ability.extra.discards_remaining - 1
                        end
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }

    -- Chicot
    SMODS["Mat" .. upp_obj]{
        key = "chicot_" .. obj,
        name = "Chicot " .. upp_obj,
        soul_pos = {x = 2, y = 15},
        rarity = 4,
        config = {extra = {xmult = 1.75}},
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS["j_chicot"]
            return { vars = {card.ability.extra.xmult}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.setting_blind and not context.blueprint and context.blind.boss then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.GAME.blind:disable()
                                        play_sound('timpani')
                                        delay(0.4)
                                        return true
                                    end
                                }))
                                SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                                return true
                            end
                        }))
                    end
                }
            end
            if context.joker_main and context.blind.boss then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
        mat_add_to_deck_obj = function(self, card, from_debuff)
            if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                G.GAME.blind:disable()
                play_sound('timpani')
                SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
            end
        end
    }

    -- Perkeo
    SMODS["Mat" .. upp_obj]{
        key = "perkeo_" .. obj,
        name = "Perkeo " .. upp_obj,
        soul_pos = {x = 3, y = 15},
        rarity = 4,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        end,
        mat_calculate_obj = function(self, card, context)
            if context.ending_shop and G.consumeables.cards[1] then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local copied_card = copy_card(
                            pseudorandom_element(G.consumeables.cards, pseudoseed('mat_perkeo')))
                        copied_card:set_edition("e_negative", true)
                        copied_card:add_to_deck()
                        G.consumeables:emplace(copied_card)
                        return true
                    end
                }))
                return { message = localize('k_duplicated_ex') }
            end
        end,
    }
end