-- TODO: Add missing loc and colors

SMODS.Booster({
	key = "hat",
	--pos = {x = 0, y = 0},
	config = {extra = 3, choose = 1},
	cost = 4,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.RED)
        ease_background_colour{new_colour = G.C.RED, special_colour = darken(G.C.BLACK, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Mat_hat",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "head",
	--pos = {x = 0, y = 0},
	config = {extra = 3, choose = 1},
	cost = 4,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
        ease_background_colour{new_colour = G.C.FILTER, special_colour = darken(G.C.BLACK, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Mat_head",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "collar",
	--pos = {x = 0, y = 0},
	config = {extra = 3, choose = 1},
	cost = 4,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.BLUE)
        ease_background_colour{new_colour = G.C.BLUE, special_colour = darken(G.C.BLACK, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Mat_collar",
			skip_materialize = true,
		})
	end,
})

SMODS.Booster({
	key = "material",
	--pos = {x = 0, y = 0},
	config = {extra = 5, choose = 2},
	cost = 6,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.GOLD)
        ease_background_colour{new_colour = G.C.GOLD, special_colour = darken(G.C.GOLD, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Mat_obj",
			skip_materialize = true,
		})
	end,
})