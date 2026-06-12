-- TODO: Add missing loc and colors

SMODS.Booster({
	key = "material_normal_1",
	pos = {x = 0, y = 5},
	config = {extra = 3, choose = 1},
	cost = 4,
	weight = 1,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.GOLD)
        ease_background_colour{new_colour = G.C.GOLD, special_colour = darken(G.C.GOLD, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		if (i - 1) % 3 == 0 then
			mat_mod.booster_cycle = {"hat", "head", "collar"}
		end

		local type, idx = pseudorandom_element(mat_mod.booster_cycle, pseudoseed('mat_booster_type'))
		table.remove(mat_mod.booster_cycle, idx)

		return SMODS.create_card({
			set = "Mat_" .. type,
			skip_materialize = true,
			soulable = true,
			key_append = "mat"
		})
	end,
})

SMODS.Booster({
	key = "material_normal_2",
	pos = {x = 0, y = 5},
	config = {extra = 3, choose = 1},
	cost = 4,
	weight = 1,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.GOLD)
        ease_background_colour{new_colour = G.C.GOLD, special_colour = darken(G.C.GOLD, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		if (i - 1) % 3 == 0 then
			mat_mod.booster_cycle = {"hat", "head", "collar"}
		end

		local type, idx = pseudorandom_element(mat_mod.booster_cycle, pseudoseed('mat_booster_type'))
		table.remove(mat_mod.booster_cycle, idx)

		return SMODS.create_card({
			set = "Mat_" .. type,
			skip_materialize = true,
			soulable = true,
			key_append = "mat"
		})
	end,
})

SMODS.Booster({
	key = "material_jumbo_1",
	pos = {x = 0, y = 5},
	config = {extra = 6, choose = 1},
	cost = 6,
	weight = 1,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.GOLD)
        ease_background_colour{new_colour = G.C.GOLD, special_colour = darken(G.C.GOLD, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		if (i - 1) % 3 == 0 then
			mat_mod.booster_cycle = {"hat", "head", "collar"}
		end

		local type, idx = pseudorandom_element(mat_mod.booster_cycle, pseudoseed('mat_booster_type'))
		table.remove(mat_mod.booster_cycle, idx)

		return SMODS.create_card({
			set = "Mat_" .. type,
			skip_materialize = true,
			soulable = true,
			key_append = "mat"
		})
	end,
})

SMODS.Booster({
	key = "material_mega_1",
	pos = {x = 0, y = 5},
	config = {extra = 6, choose = 2},
	cost = 8,
	weight = 0.25,
	kind = "Mat",
	group_key = "k_mat_pack",
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.GOLD)
        ease_background_colour{new_colour = G.C.GOLD, special_colour = darken(G.C.GOLD, 0.2), contrast = 2}
    end,
	create_card = function(self, card, i)
		if (i - 1) % 3 == 0 then
			mat_mod.booster_cycle = {"hat", "head", "collar"}
		end

		local type, idx = pseudorandom_element(mat_mod.booster_cycle, pseudoseed('mat_booster_type'))
		table.remove(mat_mod.booster_cycle, idx)

		return SMODS.create_card({
			set = "Mat_" .. type,
			skip_materialize = true,
			soulable = true,
			key_append = "mat"
		})
	end,
})