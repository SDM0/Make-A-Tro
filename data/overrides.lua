-- Adding object descriptions (1)
local gcu = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local ui = gcu(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if card and card.config and card.config.center and card.config.center.key == "j_mat_custom_joker" then
        local mat = {
            hat = {},
            head = {},
            collar = {},
        }
        for _, obj in ipairs(mat_mod.objects) do
            local vars = {}

            if G.P_CENTERS[card.ability.extra[obj].key] then
                vars = (G.P_CENTERS[card.ability.extra[obj].key]:loc_vars({}, card.ability.extra[obj]) or {})
                main_end = vars.main_end or main_end
                vars = (vars and vars.vars) or {}
            else
                vars = Card.generate_UIBox_ability_table({ability = card.ability.extra[obj].ability, config = G.P_CENTERS[card.ability.extra[obj].key].config, bypass_lock = true}, true)
            end
            localize{type = 'descriptions', set = 'Mat_obj', key = card.ability.extra[obj].key, nodes = mat[obj], vars = vars or specific_vars or {}, AUT = { info = { "I HATE GENERATE_CARD_UI" }}}
            ui["mat_" .. obj] = mat[obj]
        end
    end
    return ui
end

-- Adding object descriptions (2)
local chp = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret_val = chp(card)
    local AUT = card.ability_UIBox_table
    if AUT.mat_hat then
        local desc_ui = ret_val.nodes[1].nodes[1].nodes[1].nodes
        desc_ui[2] = desc_from_rows(AUT.mat_hat)
        table.insert(desc_ui, #desc_ui + (card.config.center.discovered and 0 or 1), desc_from_rows(AUT.mat_head))
        table.insert(desc_ui, #desc_ui + (card.config.center.discovered and 0 or 1), desc_from_rows(AUT.mat_collar))
    end
    return ret_val
end