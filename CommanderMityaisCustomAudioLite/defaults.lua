-- ============================================================
-- Commander Mityai's Custom Audio Lite — Defaults
-- ============================================================

CustomAudioLiteDefaults = {
    profile = {

        -- ========================================================
        -- Встроенные события
        -- ========================================================
        events = {
            interrupt = {
                enabled  = true,
                source   = "random",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\interrupt",
                    max      = 6,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },

            death = {
                enabled  = true,
                source   = "random",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\death",
                    max      = 2,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },

            bloodlust = {
                enabled  = true,
                source   = "custom",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\bl\\bl.mp3",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max      = 3,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },

            combatRez = {
                enabled  = true,
                source   = "random",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\BR",
                    max      = 4,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },

            rareLootRare = {
                enabled  = true,
                source   = "random",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\loot\\rare",
                    max      = 2,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },

            rareLootEpic = {
                enabled  = true,
                source   = "random",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\test",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\loot\\epic",
                    max      = 2,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },

            raidEnterDungeon = {
                enabled  = true,
                source   = "custom",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\enter\\mesto.mp3",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max      = 3,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },

            raidEnterRaid = {
                enabled  = true,
                source   = "custom",
                channel  = "Master",
                shared   = { value = "None" },
                custom   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\enter\\rabotaem.mp3",
                    max      = 1,
                    isRandom = { enabled = true, currentFile = 1 },
                },
                random   = {
                    path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max      = 3,
                    isRandom = { enabled = true, currentFile = 1 },
                },
            },
        },

        -- ========================================================
        -- Кастомные спеллы
        -- ========================================================
        customSpells = {
            enabled = true,
            spells  = {
                {
                    spellId  = 1269949,
                    enabled  = true,
                    source   = "custom",
                    channel  = "Master",
                    shared   = { value = "None" },
                    custom   = {
                        path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomSpells\\Fish.mp3",
                        max      = 1,
                        isRandom = { enabled = true, currentFile = 1 },
                    },
                    random   = {
                        path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomSpells\\Fish.mp3",
                        max      = 5,
                        isRandom = { enabled = true, currentFile = 1 },
                    },
                },
            },
        },

        -- ========================================================
        -- Кастомные ауры
        -- ========================================================
        customAuras = {
            enabled = true,
            auras   = {
                {
                    auraId   = 115834,
                    enabled  = true,
                    source   = "custom",
                    channel  = "Master",
                    shared   = { value = "None" },
                    custom   = {
                        path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomAuras\\Amogus.mp3",
                        max      = 1,
                        isRandom = { enabled = true, currentFile = 1 },
                    },
                    random   = {
                        path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomAuras",
                        max      = 5,
                        isRandom = { enabled = true, currentFile = 1 },
                    },
                },
                {
                    auraId   = 142073,
                    enabled  = true,
                    source   = "custom",
                    channel  = "Master",
                    shared   = { value = "None" },
                    custom   = {
                        path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomAuras\\go.mp3",
                        max      = 1,
                        isRandom = { enabled = true, currentFile = 1 },
                    },
                    random   = {
                        path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds",
                        max      = 5,
                        isRandom = { enabled = true, currentFile = 1 },
                    },
                },
            },
        },

        -- Замена / мьют игровых звуков  
        soundReplacements = {
            enabled      = true,
            replacements = {
                {
                    enabled     = false,
                    name        = "MapPing",
                    soundKitId  = 3175,      
                    fileDataIds = "567416",       
                    source      = "shared", 
                    channel     = "Master",
                    shared      = { value = "KAZ_SilverGroup" },
                    custom      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\CustomAuras\\go.mp3" },
                    random      = { path = "", max = 1 },
                },
                {
                    enabled     = true,
                    name        = "whisper",
                    soundKitId  = 3081,      
                    fileDataIds = "567421",       
                    source      = "random", 
                    channel     = "Master",
                    shared      = { value = "KAZ_SilverGroup" },
                    custom      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\Sounds\\CustomSounds\\Chat" },
                    random      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\Sounds\\CustomSounds\\Chat", max = 3, isRandom = { enabled = true, currentFile = 1 }, },
                },
                {
                    enabled     = true,
                    name        = "ReadyCheck1",
                    soundKitId  = 8960,      
                    fileDataIds = "567478",       
                    source      = "random", 
                    channel     = "Master",
                    shared      = { value = "KAZ_SilverGroup" },
                    custom      = { path = "" },
                    random      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\Sounds\\CustomSounds\\RC", max = 2, isRandom = { enabled = true, currentFile = 1 }, },
                },
                {
                    enabled     = true,
                    name        = "ReadyCheck2",
                    soundKitId  = 139828,      
                    fileDataIds = "567478",       
                    source      = "random", 
                    channel     = "Master",
                    shared      = { value = "KAZ_SilverGroup" },
                    custom      = { path = "" },
                    random      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\Sounds\\CustomSounds\\RC", max = 2, isRandom = { enabled = true, currentFile = 1 }, },
                },
                {
                    enabled     = true,
                    name        = "Auction",
                    soundKitId  = 5274,      
                    fileDataIds = "567482",       
                    source      = "custom", 
                    channel     = "Master",
                    shared      = { value = "KAZ_SilverGroup" },
                    custom      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\Sounds\\CustomSounds\\Auction.mp3" },
                    random      = { path = "", max = 2, isRandom = { enabled = true, currentFile = 1 }, },
                },
                {
                    enabled     = true,
                    name        = "Friend",
                    soundKitId  = 18019,      
                    fileDataIds = "567402",       
                    source      = "custom", 
                    channel     = "Master",
                    shared      = { value = "KAZ_SilverGroup" },
                    custom      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\Sounds\\CustomSounds\\Friend.mp3" },
                    random      = { path = "", max = 2, isRandom = { enabled = true, currentFile = 1 }, },
                },
                {
                    enabled     = true,
                    name        = "RaidWarning",
                    soundKitId  = 8959,      
                    fileDataIds = "567397",       
                    source      = "custom", 
                    channel     = "Master",
                    shared      = { value = "KAZ_SilverGroup" },
                    custom      = { path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\Sounds\\CustomSounds\\RW.mp3" },
                    random      = { path = "", max = 2, isRandom = { enabled = true, currentFile = 1 }, },
                },
                
                

                -- Пример записи (по умолчанию пусто, юзер добавляет сам):
                --[[
                {
                    enabled     = true,
                    name        = "Ready Check",
                    soundKitId  = nil,      -- SoundKit ID  (перехват PlaySound)
                    fileDataIds = "",       -- FileData ID через запятую (MuteSoundFile)
                    source      = "custom", -- "none" / "custom" / "shared" / "random"
                    channel     = "Master",
                    shared      = { value = "None" },
                    custom      = { path = "" },
                    random      = { path = "", max = 1 },
                },
                ]]
            },
        },
        -- ========================================================
        -- Отладка
        -- ========================================================
        debug = {
            enabled = false,
        },
    },
}