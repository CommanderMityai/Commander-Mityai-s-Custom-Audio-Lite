CustomAudioLiteDefaults = {
    profile = {
        events = {
            interrupt = {
                enabled = true,
                source = "random",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\interrupt", max = 6, isRandom = { enabled = true, currentFile = 1 } }
            },
            death = {
                enabled = true,
                source = "random",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\death", max = 2, isRandom = { enabled = true, currentFile = 1 } }
            },
            bloodlust = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\bl\\bl.mp3", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            combatRez = {
                enabled = true,
                source = "random",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\BR", max = 4, isRandom = { enabled = true, currentFile = 1 } }
            },
            rareLootRare = {
                enabled = true,
                source = "random",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\loot\\rare", max = 2, isRandom = { enabled = true, currentFile = 1 } }
            },
            rareLootEpic = {
                enabled = true,
                source = "random",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\loot\\epic", max = 2, isRandom = { enabled = true, currentFile = 1 } }
            },
            raidEnterDungeon = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\enter\\mesto.mp3", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            raidEnterRaid = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\enter\\rabotaem.mp3", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
        },
        customSpells = {
            enabled = true,
            spells = {
                {
                    spellId = 1269949, 
                    enabled = true,
                    source = "custom",
                    channel = "Master",
                    random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomSpells\\Fish.mp3", max = 5, isRandom = { enabled = true, currentFile = 1 } },
                    shared = { value = "None" },
                    custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomSpells\\Fish.mp3", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                },
            },
        },
        customAuras = {
            enabled = true,
            auras = {
                {
                    auraId = 115834, 
                    enabled = true,
                    source = "custom",
                    channel = "Master",
                    random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomAuras\\", max = 5, isRandom = { enabled = true, currentFile = 1 } },
                    shared = { value = "None" },
                    custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomAuras\\Amogus.mp3", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                },
                {
                    auraId = 142073, 
                    enabled = true,
                    source = "custom",
                    channel = "Master",
                    random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\", max = 5, isRandom = { enabled = true, currentFile = 1 } },
                    shared = { value = "None" },
                    custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomAuras\\go.mp3", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                },
                },
        },
    },
}