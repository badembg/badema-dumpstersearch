Config = {}

Config.Target = 'qb-target' -- qb-target / ox-target
Config.Inventory = 'qb-inventory' -- qb-inventory / ox_inventory
Config.ProgressBar = 8000 -- miliseconds
Config.Cooldown = 60000 -- how much miliseconds to search the same dumpster again

Config.AdditionalItems = true -- receive more items in one search
Config.MultipleItemsChance = 35 -- how much chance to receive more items
Config.MaxItemsPerSearch = math.random(2, 3) -- or only | Config.MaxItemsPerSearch = 3

Config.DumpsterProps = {
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_dumpster_3a',
    'prop_dumpster_4a',
    'prop_dumpster_4b',
    'prop_cs_dumpster_01a',
    'prop_cs_dumpster_02a',
    'prop_bin_01a',
    'prop_bin_02a',
    'prop_bin_03a',
    'prop_bin_04a',
    'prop_bin_05a',
    'prop_bin_07a',
    'prop_bin_07b',
    'prop_bin_07c',
    'prop_bin_07d',
    'prop_bin_08a',
    'prop_bin_08open',
    'prop_bin_10a',
    'prop_bin_10b',
    'prop_bin_11a',
    'prop_bin_11b',
    'prop_bin_12a',
    'prop_bin_14a',
    'prop_bin_14b',
    'prop_cs_bin_01a',
    'prop_cs_bin_01_skinned',
    'prop_cs_bin_02a',
    'prop_cs_bin_03a'
}

Config.Items = {
    {
        item = 'sandwich',
        minItems = 1,
        maxItems = 3,
        chance = 30
    },
    {
        item = 'water_bottle',
        minItems = 1,
        maxItems = 2,
        chance = 25
    },
    {
        item = 'lockpick',
        minItems = 1,
        maxItems = 1,
        chance = 10
    },
    {
        item = 'plastic',
        minItems = 1,
        maxItems = 5,
        chance = 40
    },
    {
        item = 'metalscrap',
        minItems = 1,
        maxItems = 3,
        chance = 35
    }
}

Config.Locale = {
    search_dumpster = 'Search Dumpster',
    searching = 'Searching dumpster...',
    found_items = 'You found %s x%d',
    found_nothing = 'You found nothing useful',
    already_searched = 'This dumpster was recently searched',
    cancelled = 'Search cancelled'
}