mat_mod = SMODS.current_mod
mat_mod.objects = {"hat", "head", "collar"}

assert(SMODS.load_file("data/utils.lua"))()
assert(SMODS.load_file("data/overrides.lua"))()
assert(SMODS.load_file("data/objects.lua"))()
assert(SMODS.load_file("data/joker.lua"))()

G.FUNCS.mat_can_create_joker = function(e)
	if mat_mod.all_one_min() and #G.jokers.cards < G.jokers.config.card_limit then
		e.config.colour = G.C.GOLD
		e.config.button = 'mat_create_joker'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

function create_UIBox_your_collection_objects(e)
	local deck_tables = {}
	local obj = e.config.id:match("_(%w+)")

	G.your_collection = {}
	for j = 1, 3 do
		G.your_collection[j] = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
			5 * G.CARD_W,
			0.95 * G.CARD_H,
			{ card_limit = 5, type = 'title', highlight_limit = 0, collection = true })
		table.insert(deck_tables,
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.07, no_fill = true },
				nodes = {
					{ n = G.UIT.O, config = { object = G.your_collection[j] } }
				}
			}
		)
	end

	local obj_options = {}
	for i = 1, math.ceil(#G.GAME["used_mat_" .. obj] / (5 * #G.your_collection)) do
		table.insert(obj_options,
			localize('k_page') ..
			' ' .. tostring(i) .. '/' .. tostring(math.ceil(#G.GAME["used_mat_" .. obj] / (5 * #G.your_collection))))
	end

	for i = 1, 5 do
		for j = 1, #G.your_collection do
			if G.GAME["used_mat_" .. obj][i + (j - 1) * 5] then
				local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
					G.CARD_W, G.CARD_H, nil, G.P_CENTERS[G.GAME["used_mat_" .. obj][i + (j - 1) * 5]])
				card["mat_from_" .. obj .. "_selection"] = true
				G.your_collection[j]:emplace(card)
			end
		end
	end

	local t = create_UIBox_generic_options({
		back_func = 'mat_create_joker',
		contents = {
			{ n = G.UIT.R, config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes = deck_tables },
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					create_option_cycle({ options = obj_options, w = 4.5, cycle_shoulders = true, opt_callback =
					'exit_overlay_menu', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = { snap_to = true, nav = 'wide' } })
				}
			}
		}
	})
	return t
end

G.FUNCS.your_collection_objects = function(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
		definition = create_UIBox_your_collection_objects(e),
	}
end

G.FUNCS.mat_add_joker = function(e)
	if not G.OVERLAY_MENU then return end

	local copy = copy_card(e.config.card)
	copy:add_to_deck()
	G.jokers:emplace(copy)
	copy:start_materialize()

	for _, obj in ipairs(mat_mod.objects) do
		G.GAME["saved_" .. obj .. "_selection"] = nil
		for i = #G.GAME["used_mat_" .. obj], 1, -1 do
			if G.GAME["used_mat_" .. obj][i] == copy.ability.extra[obj].key then
				table.remove(G.GAME["used_mat_" .. obj], i)
				break
			end
		end
	end

	G.CONTROLLER.locks.frame_set = true
	G.CONTROLLER.locks.frame = true
	G.CONTROLLER:mod_cursor_context_layer(-1000)
	G.OVERLAY_MENU:remove()
	G.OVERLAY_MENU = nil
	G.VIEWING_DECK = nil
	G.SETTINGS.paused = false
end

function create_UIBox_mat_joker_creation(e)
	local deck_tables = {}

	G.your_collection = CardArea(
		G.ROOM.T.x + 0.8 * G.ROOM.T.w, G.ROOM.T.h,
		G.CARD_W,
		G.CARD_H,
		{ card_limit = 1, type = 'title', highlight_limit = 0, collection = true }
	)

	table.insert(deck_tables,
		{n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
			{n=G.UIT.O, config={object = G.your_collection}}
		}}
	)

	local card = Card(G.your_collection.T.x + G.your_collection.T.w / 2, G.your_collection.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS['j_mat_custom_joker'])

	card.ability.extra.hat = G.GAME.saved_hat_selection and mat_mod.init_obj(G.GAME.saved_hat_selection) or mat_mod.init_obj(G.GAME.used_mat_hat[1])
	card.ability.extra.head = G.GAME.saved_head_selection and mat_mod.init_obj(G.GAME.saved_head_selection) or mat_mod.init_obj(G.GAME.used_mat_head[1])
	card.ability.extra.collar = G.GAME.saved_collar_selection and mat_mod.init_obj(G.GAME.saved_collar_selection) or mat_mod.init_obj(G.GAME.used_mat_collar[1])

	G.your_collection:emplace(card)

	return {
		n = G.UIT.ROOT,
		config = { align = "cm", minw = G.ROOM.T.w * 5, minh = G.ROOM.T.h * 5, padding = 0.1, r = 0.1, colour = { G.C.GREY[1], G.C.GREY[2], G.C.GREY[3], 0.7 } },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, emboss = 0.1 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", minh = 1, r = 0.2, padding = 0.2, minw = 1, colour = G.C.L_BLACK },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.1 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('k_mat_create_joker'), colour = G.C.UI.TEXT_LIGHT, scale = 0.9 } }
								}
							},
							{
								n = G.UIT.R,
								config = { align = "cl", padding = 0.2, minw = 7 },
								nodes = {
									{ n = G.UIT.C, config = { align = "cm", padding = 0.25, r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes = deck_tables },
									{
										n = G.UIT.C,
										config = { align = "cm", padding = 0.1 },
										nodes = {}
									},
									{
										n = G.UIT.C,
										config = { align = "cm", padding = 0.1 },
										nodes = {
											{
												n = G.UIT.R,
												config = { id = 'mat_hat', align = "cm", r = 0.1, minw = 3, minh = 0.7, hover = true, colour = G.C.RED, shadow = true, button = "your_collection_objects", focus_args = { type = 'none' } },
												nodes = {
													{ n = G.UIT.T, config = {align = "cm", size = 1, text = localize('b_mat_select_hat'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT } }
												}
											},
											{
												n = G.UIT.R,
												config = { id = 'mat_head', align = "cm", r = 0.1, minw = 3, minh = 0.7, hover = true, colour = G.C.RED, shadow = true, button = "your_collection_objects", focus_args = { type = 'none' } },
												nodes = {
													{ n = G.UIT.T, config = {align = "cm", size = 1, text = localize('b_mat_select_head'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT } }
												}
											},
											{
												n = G.UIT.R,
												config = { id = 'mat_collar', align = "cm", r = 0.1, minw = 3, minh = 0.7, hover = true, colour = G.C.RED, shadow = true, button = "your_collection_objects", focus_args = { type = 'none' } },
												nodes = {
													{ n = G.UIT.T, config = {align = "cm", size = 1, text = localize('b_mat_select_collar'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT } }
												}
											},
										}
									},
								},
							},
							{
								n = G.UIT.R,
								config = { id = 'overlay_menu_mat_create_button', align = "cm", minw = 2.5, button_delay = 0, padding = 0.1, r = 0.1, hover = true, colour = G.C.GREEN, card = card, button = "mat_add_joker", shadow = true, focus_args = { nav = 'wide', button = 'c', snap_to = true } },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm", padding = 0, no_fill = true },
										nodes = {
											{ n = G.UIT.T, config = { id = nil, text = localize('b_mat_create'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, func = 'set_button_pip', focus_args = { button = 'c' } } }
										}
									}
								}
							},
							{
								n = G.UIT.R,
								config = { id = 'overlay_menu_back_button', align = "cm", minw = 2.5, button_delay = 0, padding = 0.1, r = 0.1, hover = true, colour = G.C.ORANGE, button = "exit_overlay_menu", shadow = true, focus_args = { nav = 'wide', button = 'b', snap_to = true } },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm", padding = 0, no_fill = true },
										nodes = {
											{ n = G.UIT.T, config = { id = nil, text = localize('b_back'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, func = 'set_button_pip', focus_args = { button = 'b' } } }
										}
									}
								}
							}
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{ n = G.UIT.O, config = { id = 'overlay_menu_infotip', object = Moveable() } },
				}
			},
		}
	}
end

function G.FUNCS.mat_create_joker(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu {
		definition = create_UIBox_mat_joker_creation(e),
	}
end

local cc = Card.click
function Card:click()
	for _, obj in ipairs(mat_mod.objects) do
		if self["mat_from_" .. obj .. "_selection"] then
			G.GAME["saved_" .. obj .. "_selection"] = self.config.center.key
			G.FUNCS.mat_create_joker()
		end
	end
    cc(self)
end

SMODS.Back{
    key = "debug",
    pos = {x = 0, y = 0},
    config = {consumables = {'c_mat_joker_hat', 'c_mat_cloud_9_hat', 'c_mat_joker_head', 'c_mat_loyalty_card_collar'}, jokers = {'j_mat_custom_joker'}, consumable_slot = 100},
}

SMODS.Back{
    key = "increase_rate",
    pos = {x = 0, y = 0},
	apply = function(self, back)
        G.GAME.joker_rate = 0
		G.GAME.mat_hat_rate = 10
		G.GAME.mat_head_rate = 10
		G.GAME.mat_collar_rate = 10
    end,
}