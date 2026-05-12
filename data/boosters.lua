-- TODO: Add missing loc and colors

SMODS.Booster({
	key = "hat",
	--pos = {x = 0, y = 0},
	config = {extra = 3, choose = 1},
	cost = 4,
	kind = "Mat_hat",
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
	kind = "Mat_head",
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
	kind = "Mat_collar",
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
	kind = "Mat_obj",
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Mat_obj",
			skip_materialize = true,
		})
	end,
})