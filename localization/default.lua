
local loc = {
    misc = {
        dictionary = {
            b_mat_create_joker_1 = "Create",
            b_mat_create_joker_2 = "Joker",

            b_mat_select_hat = "Select Hat",
            b_mat_select_head = "Select Head",
            b_mat_select_collar = "Select Collar",
            b_mat_create = "Create",

            k_mat_create_joker = "Create your Joker!",

            k_mat_special = "Special",

            k_mat_hat = "Hat",
            b_mat_hat_cards = "Hats",
            k_mat_head = "Head",
            b_mat_head_cards = "Heads",
            k_mat_collar = "Collar",
            b_mat_collar_cards = "Collars",
            b_mat_material_cards = "Materials",

            k_mat_active = "Active",
            k_mat_inactive = "Inactive"
        }
    },
    descriptions = {
        Joker = {
            j_mat_custom_joker = {
                name = "#1# Joker",
                text = {{"{elements:1}{}"},{},{}}
            }
        },
        Back = {
            b_mat_debug = {
                name = "Debug",
                text = {
                    "Test menu overlay"
                },
            },
            b_mat_increase_rate = {
                name = "Increased Rate",
                text = {
                    "No Joker, more materials"
                },
            },
        },
        Other = {
            undiscovered_mat_hat = {
                name = 'Not Discovered',
                text = {
                    'Find this hat in an unseeded',
                    'run to find out what it does'
                }
        },
        undiscovered_mat_head = {
                name = 'Not Discovered',
                text = {
                    'Find this head in an unseeded',
                    'run to find out what it does'
                }
        },
        undiscovered_mat_collar = {
                name = 'Not Discovered',
                text = {
                    'Find this collar in an unseeded',
                    'run to find out what it does'
                }
            }
        }
    }
}

local jokers = {
    ["8_ball"] = {
        "{C:green}#1# in #2#{} chance for each",
        "played {C:attention}8{} to create a",
        "{C:tarot}Tarot{} card when scored",
        "{C:inactive}(Must have room)",
    },
    abstract = {
        "{C:mult}+#1#{} Mult for",
        "each {C:attention}Joker{} card",
        "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)",
    },
    acrobat = {
        "{X:red,C:white} X#1# {} Mult on {C:attention}final",
        "{C:attention}hand{} of round",
    },
    ancient = {
        "Each played card with",
        "{V:1}#2#{} suit gives",
        "{X:mult,C:white} X#1# {} Mult when scored,",
        "{s:0.8}suit changes at end of round",
    },
    arrowhead = {
        "Played cards with",
        "{C:spades}Spade{} suit give",
        "{C:chips}+#1#{} Chips when scored",
    },
    astronomer = {
        "{C:attention}Astronomer{} effect",
        "Creates a {C:planet}Celestial Pack{}",
        "when entering shop"
    },
    banner = {
        "{C:chips}+#1#{} Chips for",
        "each remaining",
        "{C:attention}discard",
    },
    baron = {
        "Each {C:attention}King{}",
        "held in hand",
        "gives {X:mult,C:white} X#1# {} Mult",
    },
    baseball = {
        "{C:green}Uncommon{} Jokers",
        "each give {X:mult,C:white} X#1# {} Mult",
    },
    blackboard = {
        "{X:red,C:white} X#1# {} Mult if all",
        "cards held in hand",
        "are {C:spades}#2#{} or {C:clubs}#3#{}",
    },
    bloodstone = {
        "{C:green}#1# in #2#{} chance for",
        "played cards with",
        "{C:hearts}Heart{} suit to give",
        "{X:mult,C:white} X#3# {} Mult when scored",
    },
    blue = {
        "{C:chips}+#1#{} Chips for each",
        "remaining card in {C:attention}deck",
        "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
    },
    blueprint = {
        "Copies ability of",
        "{C:attention}Joker{} to the right",
    },
    bootstraps = {
        "{C:mult}+#1#{} Mult for every",
        "{C:money}$#2#{} you have",
        "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
    },
    brainstorm = {
        "Copies the ability",
        "of leftmost {C:attention}Joker",
    },
    bull = {
        "{C:chips}+#1#{} Chips for",
        "each {C:money}$1{} you have",
        "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
    },
    burglar = {
        "When {C:attention}Blind{} is selected,",
        "gain {C:blue}+#1#{} Hands and",
        "{C:attention}lose all discards",
    },
    burnt = {
        "Upgrade the level of",
        "the first {C:attention}discarded",
        "poker hand each round",
    },
    business = {
        "Played {C:attention}face{} cards have",
        "a {C:green}#1# in #2#{} chance to",
        "give {C:money}$2{} when scored",
    },
    canio = {
        "This Joker gains {X:mult,C:white} X#1# {} Mult",
        "when a {C:attention}face{} card",
        "is destroyed",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    campfire = {
        "This Joker gains {X:mult,C:white}X#1#{} Mult",
        "for each card {C:attention}sold{}, resets",
        "when {C:attention}Boss Blind{} is defeated",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    card_sharp = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "{C:attention}poker hand{} has already",
        "been played this round",
    },
    cartomancer = {
        "Create a {C:tarot}Tarot{} card",
        "when {C:attention}Blind{} is selected",
        "{C:inactive}(Must have room)",
    },
    castle = {
        "This Joker gains {C:chips}+#1#{} Chips",
        "per discarded {V:1}#2#{} card,",
        "suit changes every round",
        "{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
    },
    cavendish = {
        "{X:mult,C:white} X#1# {} Mult",
        "{C:green}#2# in #3#{} chance this",
        "card is destroyed",
        "at end of round",
    },
    ceremonial_dagger = {
        "When {C:attention}Blind{} is selected,",
        "destroy Joker to the right",
        "and permanently add {C:attention}double",
        "its sell value to this {C:red}Mult",
        "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
    },
    certificate = {
        "When round begins,",
        "add a random {C:attention}playing",
        "{C:attention}card{} with a random",
        "{C:attention}seal{} to your hand",
    },
    chaos = {
        "{C:attention}#1#{} free {C:green}Reroll",
        "per shop",
    },
    chicot = {
        "{C:attention}Chicot{} effect",
        "{X:red,C:white}X#1#{} during",
        "{C:attention}Boss Blind{}"
    },
    clever = {
        "{C:chips}+#1#{} Chips if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    cloud_9 = {
        "Earn {C:money}$#1#{} per 2",
        "{C:attention}9s{} in your {C:attention}full deck",
        "at end of round",
        "{C:inactive}(Currently {C:money}$#2#{}{C:inactive})",
    },
    constellation = {
        "This Joker gains",
        "{X:mult,C:white} X#1# {} Mult every time",
        "a {C:planet}Planet{} card is used",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    crafty = {
        "{C:chips}+#1#{} Chips if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    crazy = {
        "{C:red}+#1#{} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    credit_card = {
        "Go up to",
        "{C:red}-$#1#{} in debt",
    },
    delayed_grat = {
        "Earn {C:money}$#1#{} per {C:attention}discard{} if",
        "no discards are used",
        "by end of the round",
    },
    devious = {
        "{C:chips}+#1#{} Chips if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    diet_cola = {
        "Sell this card to",
        "create a free",
        "{C:attention}#1#",
    },
    dna = {
        "If {C:attention}first hand{} of round",
        "has only {C:attention}1{} card, add a",
        "permanent copy to deck",
        "and draw it to {C:attention}hand",
    },
    drivers_license = {
        "{X:mult,C:white} X#1# {} Mult if you have",
        "at least {C:attention}16{} Enhanced",
        "cards in your full deck",
        "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
    },
    droll = {
        "{C:red}+#1#{} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    drunkard = {
        "{C:red}+#1#{} discard",
        "each round",
    },
    duo = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    dusk = {
        "Retrigger all played",
        "cards in {C:attention}final",
        "{C:attention}hand{} of round",
    },
    egg = {
        "Gains {C:money}$#1#{} of",
        "{C:attention}sell value{} at",
        "end of round",
    },
    erosion = {
        "{C:red}+#1#{} Mult for each",
        "card below {C:attention}#3#{}",
        "in your full deck",
        "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)",
    },
    even_steven = {
        "Played cards with",
        "{C:attention}even{} rank give",
        "{C:mult}+#1#{} Mult when scored",
        "{C:inactive}(10, 8, 6, 4, 2)",
    },
    faceless = {
        "Earn {C:money}$#1#{} if {C:attention}#2#{} or",
        "more {C:attention}face cards{}",
        "are discarded",
        "at the same time",
    },
    family = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    fibonacci = {
        "Each played {C:attention}Ace{},",
        "{C:attention}2{}, {C:attention}3{}, {C:attention}5{}, or {C:attention}8{} gives",
        "{C:mult}+#1#{} Mult when scored",
    },
    flash = {
        "This Joker gains {C:mult}+#1#{} Mult",
        "per {C:attention}reroll{} in the shop",
        "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
    },
    flower_pot = {
        "{X:mult,C:white} X#1# {} Mult if poker",
        "hand contains a",
        "{C:diamonds}Diamond{} card, {C:clubs}Club{} card,",
        "{C:hearts}Heart{} card, and {C:spades}Spade{} card",
    },
    fortune_teller = {
        "{C:red}+#1#{} Mult per {C:attention}2{} {C:purple}Tarot{}",
        "cards used this run",
        "{C:inactive}(Currently {C:red}+#2#{C:inactive})",
    },
    four_fingers = {
        "{C:attention}Four Fingers{} effect",
        "{C:mult}+#1#{} Mult if played",
        "hand is a {C:attention}4{} cards",
        "{C:attention}Straight{} or {C:attention}Flush{}"
    },
    gift = {
        "Add {C:money}$#1#{} of {C:attention}sell value",
        "to every {C:attention}Joker{} and",
        "{C:attention}Consumable{} card at",
        "end of round",
    },
    glass = {
        "This Joker gains {X:mult,C:white} X#1# {} Mult",
        "for every {C:attention}Glass Card",
        "that is destroyed",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    gluttonous = {
        "Played cards with",
        "{C:clubs}#2#{} suit give",
        "{C:mult}+#1#{} Mult when scored",
    },
    golden = {
        "Earn {C:money}$#1#{} at",
        "end of round",
    },
    greedy = {
        "Played cards with",
        "{C:diamonds}#2#{} suit give",
        "{C:mult}+#1#{} Mult when scored",
    },
    green = {
        "{C:mult}+#1#{} Mult per hand played",
        "{C:mult}-#2#{} Mult per discard",
        "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
    },
    gros_michel = {
        "{C:mult}+#1#{} Mult",
        "{C:green}#2# in #3#{} chance this",
        "card is destroyed",
        "at end of round",
    },
    hack = {
        "Retrigger",
        "each played",
        "{C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5{}",
    },
    half = {
        "{C:red}+#1#{} Mult if played",
        "hand contains",
        "{C:attention}#2#{} or fewer cards",
    },
    hallucination = {
        "{C:green}#1# in #2#{} chance to create",
        "a {C:tarot}Tarot{} card when any",
        "{C:attention}Booster Pack{} is opened",
        "{C:inactive}(Must have room)",
    },
    hanging_chad = {
        "Retrigger {C:attention}first{} played",
        "card used in scoring",
        "{C:attention}#1#{} additional times",
    },
    hiker = {
        "Every played {C:attention}card{}",
        "permanently gains",
        "{C:chips}+#1#{} Chips when scored",
    },
    hit_the_road = {
        "This Joker gains {X:mult,C:white} X#1# {} Mult",
        "for every {C:attention}Jack{}",
        "discarded this round",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    hologram = {
        "This Joker gains {X:mult,C:white} X#1# {} Mult",
        "every time a {C:attention}playing card{}",
        "is added to your deck",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    ice_cream = {
        "{C:chips}+#1#{} Chips",
        "{C:chips}-#2#{} Chips for",
        "every hand played",
    },
    idol = {
        "Each played {C:attention}#2#",
        "of {V:1}#3#{} gives",
        "{X:mult,C:white} X#1# {} Mult when scored",
        "{s:0.8}Card changes every round",
    },
    invisible = {
        "After {C:attention}#1#{} rounds,",
        "sell this card to",
        "{C:attention}Duplicate{} a random Joker",
        "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)",
    },
    joker = {
        "{C:red,s:1.1}+#1#{} Mult",
    },
    jolly = {
        "{C:red}+#1#{} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    juggler = {
        "{C:attention}+#1#{} hand size",
    },
    loyalty_card = {
        "{X:red,C:white} X#1# {} Mult every",
        "{C:attention}#2#{} hands played",
        "{C:inactive}#3#",
    },
    luchador = {
        "{C:attention}Luchador{} effect",
        "Earn {C:money}$#1#{} when",
        "disabling {C:attention}Boss Blind{}"
    },
    lucky_cat = {
        "This Joker gains {X:mult,C:white} X#1# {} Mult",
        "every time a {C:attention}Lucky{} card",
        "{C:green}successfully{} triggers",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    lusty = {
        "Played cards with",
        "{C:hearts}#2#{} suit give",
        "{C:mult}+#1#{} Mult when scored",
    },
    mad = {
        "{C:red}+#1#{} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    madness = {
        "When {C:attention}Small Blind{} or {C:attention}Big Blind{}",
        "is selected, gain {X:mult,C:white} X#1# {} Mult",
        "and {C:attention}destroy{} a random Joker",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    mail = {
        "Earn {C:money}$#1#{} for each",
        "discarded {C:attention}#2#{}, rank",
        "changes every round",
    },
    marble = {
        "Adds one {C:attention}Stone{} card",
        "to deck when",
        "{C:attention}Blind{} is selected",
    },
    matador = {
        "Earn {C:money}$#1#{} if played",
        "hand triggers the",
        "{C:attention}Boss Blind{} ability",
    },
    merry_andy = {
        "{C:red}+#1#{} discards",
        "each round,",
        "{C:red}#2#{} hand size",
    },
    midas_mask = {
        "{C:attention}Midas Mask{} effect",
        "{C:attention}Gold face{} cards earns",
        "{C:money}$2{} when held in hand"
    },
    mime = {
        "Retrigger all",
        "card {C:attention}held in",
        "{C:attention}hand{} abilities",
    },
    misprint = {
        "",
    },
    mr_bones = {
        "Prevents Death",
        "if chips scored",
        "are at least {C:attention}25%",
        "of required chips",
        "{S:1.1,C:red,E:2}self destructs{}",
    },
    mystic_summit = {
        "{C:mult}+#1#{} Mult when",
        "{C:attention}#2#{} discards",
        "remaining",
    },
    obelisk = {
        "This Joker gains {X:mult,C:white} X#1# {} Mult",
        "per {C:attention}consecutive{} hand played",
        "without playing your",
        "most played {C:attention}poker hand",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    odd_todd = {
        "Played cards with",
        "{C:attention}odd{} rank give",
        "{C:chips}+#1#{} Chips when scored",
        "{C:inactive}(A, 9, 7, 5, 3)",
    },
    onyx_agate = {
        "Played cards with",
        "{C:clubs}Club{} suit give",
        "{C:mult}+#1#{} Mult when scored",
    },
    oops = {
        "{X:green,C:white}X1.5{} to all {C:attention}listed",
        "{C:green,E:1,S:1.1}probabilities",
        "{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}1.5 in 3{C:inactive})",
    },
    order = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    pareidolia = {
        "{C:attention}Pareidolia{} effect",
        "Played cards with {C:attention}non-face{} ranks",
        "give {C:mult}+5{} mult when scored"
    },
    perkeo = {
        "Creates a {C:dark_edition}Negative{} copy of",
        "{C:attention}1{} random {C:attention}consumable{}",
        "card in your possession",
        "at the end of the {C:attention}shop",
    },
    photograph = {
        "First played {C:attention}face",
        "card gives {X:mult,C:white} X#1# {} Mult",
        "when scored",
    },
    popcorn = {
        "{C:mult}+#1#{} Mult",
        "{C:mult}-#2#{} Mult per",
        "round played",
    },
    raised_fist = {
        "Adds the rank of",
        "{C:attention}lowest{} ranked card",
        "held in hand to Mult",
    },
    ramen = {
        "{X:mult,C:white} X#1# {} Mult,",
        "loses {X:mult,C:white} X#2# {} Mult",
        "per {C:attention}card{} discarded",
    },
    red_card = {
        "This Joker gains",
        "{C:red}+#1#{} Mult when any",
        "{C:attention}Booster Pack{} is skipped",
        "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)",
    },
    reserved_parking = {
        "Each {C:attention}face{} card",
        "held in hand has",
        "a {C:green}#2# in #3#{} chance",
        "to give {C:money}$#1#{}",
    },
    ride_the_bus = {
        "This Joker gains {C:mult}+#1#{} Mult",
        "per {C:attention}consecutive{} hand",
        "played without a",
        "scoring {C:attention}face{} card",
        "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
    },
    riff_raff = {
        "When {C:attention}Blind{} is selected,",
        "create {C:attention}#1# {C:blue}Common{C:attention} Jokers",
        "{C:inactive}(Must have room)",
    },
    showman = {
        "{C:attention}Showman{} effect",
        "{X:red,C:white}X#1#{} if you own {C:attention}duped{}",
        "non-custom Jokers",
    },
    rocket = {
        "Earn {C:money}$#1#{} at end of round",
        "Payout increases by {C:money}$#2#{}",
        "when {C:attention}Boss Blind{} is defeated",
    },
    rough_gem = {
        "Played cards with",
        "{C:diamonds}Diamond{} suit earn",
        "{C:money}$#1#{} when scored",
    },
    runner = {
        "Gains {C:chips}+#2#{} Chips",
        "if played hand",
        "contains a {C:attention}Straight{}",
        "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
    },
    satellite = {
        "Earn {C:money}$#1#{} at end of",
        "round per 2 unique {C:planet}Planet",
        "card used this run",
        "{C:inactive}(Currently {C:money}$#2#{C:inactive})",
    },
    scary_face = {
        "Played {C:attention}face{} cards",
        "give {C:chips}+#1#{} Chips",
        "when scored",
    },
    scholar = {
        "Played {C:attention}Aces{}",
        "give {C:chips}+#2#{} Chips",
        "and {C:mult}+#1#{} Mult",
        "when scored",
    },
    seance = {
        "If {C:attention}poker hand{} is a",
        "{C:attention}#1#{}, create a",
        "random {C:spectral}Spectral{} card",
        "{C:inactive}(Must have room)",
    },
    seeing_double = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "hand has a scoring",
        "{C:clubs}Club{} card and a scoring",
        "card of any other {C:attention}suit",
    },
    selzer = {
        "Retrigger all",
        "cards played for",
        "the next {C:attention}#1#{} hands",
    },
    shoot_the_moon = {
        "Each {C:attention}Queen{}",
        "held in hand",
        "gives {C:mult}+#1#{} Mult",
    },
    shortcut = {
        "{C:attention}Shortcut{} effect",
        "Gains {C:mult}+#1#{} Mult when scoring",
        "a gapped {C:attention}Straight{}",
        "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
    },
    sixth_sense = {
        "If {C:attention}first hand{} of round is",
        "a single {C:attention}6{}, destroy it and",
        "create a {C:spectral}Spectral{} card",
        "{C:inactive}(Must have room)",
    },
    sly = {
        "{C:chips}+#1#{} Chips if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    smeared = {
        "{C:attention}Smeared{} effect",
        "Scored {C:attention}Wild{} cards",
        "give {X:red,C:white}X#1#{} Mult"
    },
    smiley = {
        "Played {C:attention}face{} cards",
        "give {C:mult}+#1#{} Mult",
        "when scored",
    },
    sock_and_buskin = {
        "Retrigger all",
        "played {C:attention}face{} cards",
    },
    space = {
        "{C:green}#1# in #2#{} chance to",
        "upgrade level of",
        "played {C:attention}poker hand{}",
    },
    splash = {
        "{C:attention}Splash{} effect",
        "{C:chips}+#1#{} Chips when playing",
        "{C:attention}extra{} scored cards"
    },
    square = {
        "This Joker gains {C:chips}+#2#{} Chips",
        "if played hand has",
        "exactly {C:attention}4{} cards",
        "{C:inactive}(Currently {C:chips}#1#{C:inactive} Chips)",
    },
    steel = {
        "Gives {X:mult,C:white} X#1# {} Mult",
        "for each {C:attention}Steel Card",
        "in your {C:attention}full deck",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    stencil = {
        "{X:red,C:white} X1 {} Mult for each",
        "empty {C:attention}Joker{} slot",
        "{s:0.8}Joker Stencil included",
        "{C:inactive}(Currently {X:red,C:white} X#1# {C:inactive})",
    },
    stone = {
        "Gives {C:chips}+#1#{} Chips for",
        "each {C:attention}Stone Card",
        "in your {C:attention}full deck",
        "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
    },
    stuntman = {
        "{C:chips}+#1#{} Chips,",
        "{C:attention}-#2#{} hand size",
    },
    supernova = {
        "Adds the number of times",
        "{C:attention}poker hand{} has been",
        "played this run to Mult",
    },
    superposition = {
        "Create a {C:tarot}Tarot{} card if",
        "poker hand contains an",
        "{C:attention}Ace{} and a {C:attention}Straight{}",
        "{C:inactive}(Must have room)",
    },
    swashbuckler = {
        "Adds half the sell value",
        "of all other owned",
        "{C:attention}Jokers{} to Mult",
        "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
    },
    throwback = {
        "{X:mult,C:white} X#1# {} Mult for each",
        "{C:attention}Blind{} skipped this run",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    ticket = {
        "Played {C:attention}Gold{} cards",
        "earn {C:money}$#1#{} when scored",
    },
    to_the_moon = {
        "Earn an extra {C:money}$#1#{} of",
        "{C:attention}interest{} for every {C:money}$5{} you",
        "have at end of round",
    },
    todo_list = {
        "Earn {C:money}$#1#{} if {C:attention}poker hand{}",
        "is a {C:attention}#2#{},",
        "poker hand changes",
        "at end of round",
    },
    trading = {
        "If {C:attention}first discard{} of round",
        "has only {C:attention}1{} card, destroy",
        "it and earn {C:money}$#1#",
    },
    tribe = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    triboulet = {
        "Played {C:attention}Kings{} and",
        "{C:attention}Queens{} each give",
        "{X:mult,C:white} X#1# {} Mult when scored",
    },
    trio = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    troubadour = {
        "{C:attention}+#1#{} hand size,",
        "{C:blue}-#2#{} hand each round",
    },
    trousers = {
        "This Joker gains {C:mult}+#1#{} Mult",
        "if played hand contains",
        "a {C:attention}#2#",
        "{C:inactive}(Currently {C:red}+#3#{C:inactive} Mult)",
    },
    turtle_bean = {
        "{C:attention}+#1#{} hand size,",
        "reduces by",
        "{C:red}#2#{} every round",
    },
    vagabond = {
        "Create a {C:purple}Tarot{} card",
        "if hand is played",
        "with {C:money}$#1#{} or less",
    },
    vampire = {
        "This Joker gains {X:mult,C:white} X#1# {} Mult",
        "per scoring {C:attention}Enhanced card{} played,",
        "removes card {C:attention}Enhancement",
        "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
    walkie_talkie = {
        "Each played {C:attention}10{} or {C:attention}4",
        "gives {C:chips}+#1#{} Chips and",
        "{C:mult}+#2#{} Mult when scored",
    },
    wee = {
        "This Joker gains",
        "{C:chips}+#2#{} Chips when each",
        "played {C:attention}2{} is scored",
        "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
    },
    wily = {
        "{C:chips}+#1#{} Chips if played",
        "hand contains",
        "a {C:attention}#2#",
    },
    wrathful = {
        "Played cards with",
        "{C:spades}#2#{} suit give",
        "{C:mult}+#1#{} Mult when scored",
    },
    yorick = {
        "This Joker gains",
        "{X:mult,C:white} X#1# {} Mult every {C:attention}#2#{C:inactive} [#3#]{}",
        "cards discarded",
        "{C:inactive}(Currently {X:mult,C:white} X#4# {C:inactive} Mult)",
    },
    zany = {
        "{C:red}+#1#{} Mult if played",
        "hand contains",
        "a {C:attention}#2#",
    }
}

local hats = {}
local heads = {}
local collars = {}
local objects = {"hat", "head", "collar"}

local type_tables = {
    hat = hats,
    head = heads,
    collar = collars
}

for _, type in ipairs(objects) do
    for joker_key, loc in pairs(jokers) do
        local joker = G.P_CENTERS["c_mat_" .. joker_key .. "_" .. type]
        type_tables[type]["c_mat_" .. joker_key .. "_" .. type] = {
            name = (joker and joker.name) or "ERROR",
            text = loc
        }
    end
end

loc.descriptions.Mat_hat = hats
loc.descriptions.Mat_head = heads
loc.descriptions.Mat_collar = collars

return loc