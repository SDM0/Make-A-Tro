mat_mod = SMODS.current_mod
mat_mod.objects = {"hat", "head", "collar"}

-- TODOS: 
-- Add purchased objects to some "Run Info" tab
-- Make better collection system for materials
-- Add counter to "Create Joker" button (ex: 1Ha / 2He / 1CO)

assert(SMODS.load_file("data/utils.lua"))()
assert(SMODS.load_file("data/overrides.lua"))()
assert(SMODS.load_file("data/ui.lua"))()
assert(SMODS.load_file("data/objects.lua"))()
assert(SMODS.load_file("data/boosters.lua"))()
assert(SMODS.load_file("data/joker.lua"))()

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