Config = {}

Config.TreasureHunter = {
    model = `s_m_m_trucker_01`,
    coords = vector4(-3281.8, 958.55, 8.35, 79.08),
} -- Treasure Hunter Ped Whom You Sign Up With

Config.TreasureHunterBlip = true
Config.TreasureHunterBlipSettings = {
    name = "Treasure Hunter",
    sprite = 310,
    scale = 0.70,
    color = 2,

}

Config.TournamentTimer = 30 -- Minutes Between Each Tournament (Only Starts After Previous Tournament Is Over Or A Restart)
Config.TreasureHuntingChestItem = "treasurehunterchest" -- Normal Treasure Hunting Chest Item (No functionality To Receive Yet)
Config.TournamentChestItem = "tournamentchest" -- Tournament Chest Reward Item (Earned Through Tournaments)
Config.TournamentBlipSettings = { -- Tournament Chest Blip Settings (Radius Around Blip Included)
    name = "Tournament Treasure Hunting Zone",
    radius = 280.0,
    sprite = 587,
    scale = 0.75,
    color = 0,

}
Config.TournamentLength = 45 -- Minutes That Each Tournament Will Last Before Config.TournamentTimer Starts Again

Config.TreasureHuntingChestLootTable = { -- Normal LootTable for Treasure Chests When Config.TreasureHuntingChestItem Is Used
    amountOfItems = math.random(2, 3), -- Amount Of UNIQUE Items Received Per Chest
    rareChance = 8, -- % Chance To Receive From rareProperties Pool. rareChance Is Refreshed For EACH amountOfItems
    rareProperties = {
        [1] = {
            name = 'WEAPON_APPISTOL', -- Item Spawncode
            amount = 1, -- Amount Received Of Said Item
        },
        [2] = {
            name = 'captainskull',
            amount = 1,
        },
    },
    normalProperties = {
        [1] = {
            name = 'yellow-diamond',
            amount = 1,
        },
        [2] = {
            name = 'antique_sapphire',
            amount = 1,
        },
        [3] = {
            name = 'antique_ruby',
            amount = 1,
        },
        [4] = {
            name = 'antique_diamond',
            amount = 1,
        },
        [5] = {
            name = 'antique_emerald',
            amount = 1,
        },
    }
}

Config.TournamentChestLootTable = { -- Tournament Chest LootTable For Tournament Chests when Config.TournamentChestItem Is Used
    amountOfItems = math.random(4, 5),
    rareChance = 6,
    rareProperties = {
        [1] = {
            name = 'weapon_smg',
            amount = 1,
        },
        [2] = {
            name = 'captainskull',
            amount = math.random(1, 2),
        },
    },
    normalProperties = {
        [1] = {
            name = 'yellow-diamond',
            amount = math.random(2, 3),
        },
        [2] = {
            name = 'antique_sapphire',
            amount = math.random(2, 3),
        },
        [3] = {
            name = 'antique_ruby',
            amount = math.random(2, 3),
        },
        [4] = {
            name = 'antique_diamond',
            amount = math.random(2, 3),
        },
        [5] = {
            name = 'antique_emerald',
            amount = math.random(2, 3),
        },
    }
    
}

Config.TreasureLocations = { -- Locations For All Chest Spawns (Both Treasure Chests and Tournament Chests)
    [1] = {
        blip = vector3(-2838.28, -551.37, -75.25), -- Location Where Blip Is Marked
        spots = { -- Possible Locations WITHIN blip Radius Found In Config.TournamentBlipSettings (Locations Are Elevated For Easier Sight. Has To Be Edited)
            vector4(-2827.17, -498.84, -64.75, 259.66),
            vector4(-2834.28, -531.37, -73.25, 352.53),
            vector4(-2830.98, -562.47, -73.2, 5.51),
        },
        model = "xm_prop_x17_chest_closed" -- Model Of Item That Is Spawned. Default: "xm_prop_x17_chest_closed"
    },
    [2] = {
        blip = vector3(-3569.39, 822.15, -26.26),
        spots = {
            vector4(-3553.06, 838.0, -27.00, 45.28),
            vector4(-3589.77, 832.37, -30.90, 101.48),
            vector4(-3598.79, 800.69, -30.00, 193.18),
            vector4(-3593.12, 778.42, -33.00, 273.59),
            vector4(-3588.55, 792.7, -29.68, 23.57),
            vector4(-3522.23, 807.18, -33.23, 41.77),
            vector4(-3529.95, 838.85, -30.13, 86.89)
        },
        model = "xm_prop_x17_chest_closed"
    },
    [3] = {
        blip = vector3(-2068.18, -888.93, -7.24),
        spots = {
            vector4(-2040.75, -900.14, -27.83, 240.66),
            vector4(-2090.57, -863.0, -34.9, 194.44),
            vector4(-2052.06, -846.37, -22.88, 98.85),
            vector4(-2043.13, -908.05, -29.61, 272.47),
            vector4(-2109.88, -849.96, -31.11, 296.1),
        },
        model = "xm_prop_x17_chest_closed"
    },
    
}



