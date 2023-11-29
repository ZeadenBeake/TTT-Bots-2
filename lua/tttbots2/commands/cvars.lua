local FCVAR = FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED + FCVAR_LUA_SERVER

local function bot_cvar(name, def, desc)
    return CreateConVar("ttt_bot_" .. name, def, FCVAR, desc)
end

-- Misc cvars
bot_cvar("language", "en",
    "Changes the language that the bots speak in text chat, and may modify some GUI strings. Example is 'en' or 'es'")
bot_cvar("chat_cmds", "1",
    "If you want to allow chat commands to be used for administration. This cvar exists for mod compatibility.")
bot_cvar("names_prefixes", "1", "Bot names are forced prefixed by '[BOT]'")
bot_cvar("pfps", "1", "Bots can have AI-related profile pictures in the scoreboard")
bot_cvar("pfps_humanlike", "0", "Bots can have AI-related profile pictures in the scoreboard")
bot_cvar("emulate_ping", "0",
    "Bots will emulate a humanlike ping (does not affect gameplay and is cosmetic.) This is to be used in servers of players that consent to playing with bots. It's a flavor feature for friends.")
bot_cvar("playermodel", "", "The path to the playermodel the bots should use. Leave blank to disable this feature.")

bot_cvar("quota", "0",
    "The number of bots to ensure are in the level at all times. Set to 0 to disable this feature. This cvar is affected by ..._mode")
bot_cvar("quota_mode", "fill",
    "The mode of the quota system. Options = 'fill', 'exact'. Fill will basically set the player count to X (filling in for players as they leave), and exact will always have X bots in the match.")
bot_cvar("quota_cull_difficulty", "1",
    "Whether or not the quota system should cull bots that are too beyond or below the ttt_bot_difficulty setting.")

-- "Cheat" cvars
bot_cvar("cheat_know_shooter", "1",
    "If set to 1, bots will automatically know who in a firefight shot first, and will use that to determine who to shoot. While technically a cheat, the bots feel much dumber when this is off.")
bot_cvar("cheat_redhanded_time", "3",
    "This is the number of seconds that a player is silently marked KOS by bots after killing a non-evil class. Set to 0 to disable. This is technically a cheat, but makes the bots more engaging.")
bot_cvar("cheat_traitor_reactionspd", "1",
    "If set to 1, traitor bots will have a superior reaction speed. This is technically a cheat, but makes the bots more engaging.")

-- Chatter cvars
bot_cvar("chatter_lvl", "3",
    "The level of chatter that bots will have. 0 = none (not even KOS), 1 = critical only (like KOS), 2 = >= callouts/important only, 3 = everything.")
bot_cvar("chatter_cps", "30",
    "Determines the typing speed of bots, in characters per second. Higher values = faster typing = more chatting.")
bot_cvar("chatter_minrepeat", "15",
    "The minimum time between a bot can repeat the same chatter event in voice/text chat.")
bot_cvar("chatter_koschance", "1",
    "A multiplier value that affects a bots chance to call KOS. Higher values = more KOS calls. Only does anything if ttt_bot_chatter_lvl is 1 or higher. Set to 0 to disable KOS calls.")

-- Gameplay-effecting cvars
bot_cvar("plans_mindelay", "12",
    "The delay when a round starts before traitor bots may follow coordinated plans.")
bot_cvar("plans_maxdelay", "35",
    "The maximum duration when a round starts before traitor bots may follow coordinated plans.")
bot_cvar("attack_delay", "15",
    "The minimum number of seconds until a traitor bot will consider shooting someone around them.")
bot_cvar("flicking", "1",
    "Can the bots flick around when they get shot from the rear? Effectively makes bots harder and seem smarter.")
bot_cvar("difficulty", "3",
    "A difficulty integer between 1-5; higher = harder. This affects trait selection and aim speed, reaction speed, and KOS callout chances.")
bot_cvar("kos_limit", "2",
    "The upper bound of KOS calls an individual, bot or player, can make per round. Before the bots ignore them, at least. Used to deter trolls.")
bot_cvar("reaction_speed", "0.5",
    "The base time, in seconds, a bot will take before attacking a newly assigned target. Higher means easier gameplay. THIS INVERSELY SCALES WITH DIFFICULTY AUTOMATICALLY.")
bot_cvar("plant_c4", "1",
    "Whether or not ANY bots are permitted to plant c4. It will not disable the ability to *have* c4, just prevent the use of it.")
bot_cvar("defuse_c4", "1",
    "Whether or not ANY bots are permitted to defuse c4. Does not affect if bots will buy defuse kits or not as detective (they just won't use it).")
bot_cvar("personalities", "1",
    "Whether or not each bot should spawn in as its own unique individual (basically have their own gameplay-effecting traits)")

-- Noise cvars
bot_cvar("noise_investigate_chance", "50", "The % chance (therefore 0-100) that a bot will investigate a noise he hears.")
bot_cvar("noise_investigate_mtb", "15",
    "The minimum time between, in seconds, that a bot will investigate a noise he hears.")
bot_cvar("noise_enable", "1", "Enables bots to hear noises and investigate them.")

-- Naming cvars
bot_cvar("names_allowcommunity", "1",
    "Enables community-suggested names, replacing many auto-generated names. WARNING: Potentially offensive, not family-friendly.")
bot_cvar("names_communityonly", "0",
    "Disables auto-generated names, only using community-suggested names. NOTE: ttt_bot_names_allowcommunity must be enabled.")
bot_cvar("names_canleetify", "1",
    "Enables leetifying of ALL names. (e.g. 'John' -> 'j0hn'). See ttt_bot_names_leetify_chance.")
bot_cvar("names_canusenumbers", "1",
    "Enables adding numbers to autogenerated names. (e.g. 'John' -> 'John69')")
bot_cvar("names_canusespaces", "1",
    "Enables using spaces in autogenerated names. (e.g. 'John Doe' -> 'JohnDoe')")
bot_cvar("names_allowgeneric", "1",
    "Enables generic usernames, generated by ChatGPT. They're less appropriate than random names but more appropriate than community-suggested names.")

-- Debug cvars
bot_cvar("debug_pathfinding", "0",
    "[May console spam. Development use only] Enables debug for pathfinding. Requires built-in developer convar to be 1 for drawings.")
bot_cvar("debug_look", "0",
    "[May console spam. Development use only] Enables debug for looking at things. Requires built-in developer convar to be 1 for drawings.")
bot_cvar("debug_misc", "0",
    "[May console spam. Development use only] Enables misc debug. Requires built-in developer convar to be 1 for drawings.")
bot_cvar("debug_stuckpositions", "0",
    "[May console spam. Development use only] Enables debug for stuck positions. Requires built-in developer convar to be 1 for drawings.")
bot_cvar("debug_obstacles", "0",
    "[May console spam. Development use only] Enables debug for recognized obstacles. Requires built-in developer convar to be 1 for drawings.")
bot_cvar("debug_doors", "0",
    "[May console spam. Development use only] Enables debug for doors. Requires built-in developer convar to be 1 for drawings.")
bot_cvar("debug_attack", "0",
    "[May console spam. Development use only] Enables debug for attacking. Requires built-in developer convar to be 1 for drawings.")
bot_cvar("debug_evil", "0",
    "[May console spam. Development use only] Enables debug for the Evil Coordinator.")
bot_cvar("debug_inventory", "0",
    "[May console spam. Development use only] Enables debug for inventory management.")
bot_cvar("debug_strafe", "0",
    "[May console spam. Development use only] Enables debug drawing for strafing. Requires 'developer 1' first.")
bot_cvar('debug_navpopularity', '0',
    '[May console spam. Development use only] Enables debug drawing for nav popularity. Requires "developer 1" first.')

-- Personality cvars
bot_cvar("boredom", "1",
    "Enables boredom. Bots will leave the server if they get too bored. If RDM is enabled, then some bots will be more likely RDM when (very) bored")
bot_cvar("boredom_rate", "100",
    "How quickly bots get bored. *THIS IS A PERCENTAGE*. Higher values = faster boredom. Only does anything if ttt_bot_boredom is enabled.")
bot_cvar("pressure", "1",
    "Enables pressure. Bots will have worse aim if they are under pressure. Certain traits may make some bots better under pressure, increasing difficulty.")
bot_cvar("pressure_rate", "100",
    "How quickly bots accrue pressure. *THIS IS A PERCENTAGE*. Higher values = faster pressure gain. Only does anything if ttt_bot_pressure is enabled.")
bot_cvar("rage", "1",
    "Enables rage. Like boredom, bots will leave, and even be more likely to RDM if RDM is enabled. This will also build onto pressure, if enabled, and may make bots more aggressive in chat.")
bot_cvar("rage_rate", "100",
    "How quickly bots get angry. *THIS IS A PERCENTAGE*. Higher values = faster anger. Only does anything if ttt_bot_rage is enabled.")
bot_cvar("allow_leaving", "1",
    "Enables bots to leave the server if they get too bored or angry. Bots that leave voluntarily will automatically have a replacement join within 30 seconds.")

-- Pathfinding cvars
bot_cvar("pathfinding_cpf", "50",
    "Don't change this unless you know what you are doing. How many pathfinding calculations to do per frame. Higher values = more CPU usage, but faster pathfinding.")
bot_cvar("pathfinding_cpf_scaling", "0",
    "Don't change this unless you know what you are doing. Should we dynamically multiply the pathfinding calculations per frame by the number of bots? (e.g. 50 cpf * 2 bots = 100 cpf)")
bot_cvar("rdm", "0",
    "Enables RDM (random deathmatch). This isn't advised for most situations, but can offer some extra variety should you want it.")

-- Behavior cvars
bot_cvar("radar_chance", "100",
    "Chance that a traitor bot will simulate having radar as a traitor (internally they must be an 'evil' role).")
bot_cvar("coordinator", "1",
    "Enables the Evil Coordinator module. Evil bots will not coordinate with other traitors with this set to 0. WARNING: This will make traitor bots far less effective & responsive.")
