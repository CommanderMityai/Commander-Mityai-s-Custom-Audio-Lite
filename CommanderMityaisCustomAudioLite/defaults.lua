CustomAudioLiteDefaults = {
    profile = {
        events = {
            interrupt = {
                enabled = true,
                source = "custom",  -- Может быть: "custom", "shared", "random"
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            death = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            bloodlust = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            rareLootRare = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            rareLootEpic = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            raidEnterDungeon = {
                enabled = false,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
            raidEnterRaid = {
                enabled = true,
                source = "custom",
                channel = "Master",
                shared = { value = "None" },
                custom = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test", max = 1, isRandom = { enabled = true, currentFile = 1 } },
                random = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", max = 3, isRandom = { enabled = true, currentFile = 1 } }
            },
        },
        customSpells = {
            enabled = true,
            spells = {},
        },
        customAuras = {
            enabled = true,
            auras = {},
        },
    },
}