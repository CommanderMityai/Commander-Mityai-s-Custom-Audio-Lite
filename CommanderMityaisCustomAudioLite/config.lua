local LSM = LibStub("LibSharedMedia-3.0")

local function GetSoundOptions(eventKey, eventName, tooltip)
    return {
        type = "group",
        name = eventName,
        args = {
            enabled = {
                type = "toggle",
                name = "Включено",
                width = "full",
                get = function() return CustomAudioLite.db.profile.events[eventKey].enabled end,
                set = function(_, value) CustomAudioLite.db.profile.events[eventKey].enabled = value end,
                order = 1,
            },
            spacer1 = {
                type = "description",
                name = " ",
                order = 2,
            },
            source = {
                type = "select",
                name = "Откуда долбит",
                width = "double",
                values = {
                    ["custom"] = "Долбит нормально",   -- Один файл
                    ["shared"] = "Блютуз колонка",     -- SharedMedia
                    ["random"] = "Долбит рандомно",    -- Рандом из папки
                },
                get = function() return CustomAudioLite.db.profile.events[eventKey].source end,
                set = function(_, value) CustomAudioLite.db.profile.events[eventKey].source = value end,
                order = 3,
            },
            spacer2 = {
                type = "description",
                name = " ",
                order = 4,
            },
            -- SharedMedia (Блютуз колонка)
            shared = {
                type = "select",
                name = "Pass me the aux cord fam",
                desc = "Че в библе есть",
                dialogControl = "LSM30_Sound",
                values = function() 
                    local values = LSM:HashTable("sound")
                    values["None"] = "<Не выбрано>"
                    return values
                end,
                get = function() return CustomAudioLite.db.profile.events[eventKey].shared.value end,
                set = function(_, value) CustomAudioLite.db.profile.events[eventKey].shared.value = value end,
                hidden = function() return CustomAudioLite.db.profile.events[eventKey].source ~= "shared" end,
                order = 5,
            },
            -- Долбит нормально (один файл)
            customPath = {
                type = "input",
                name = "Путь к файлу",
                desc = "Путь относительно Interface\\AddOns (без расширения .mp3)",
                width = "double",
                get = function() return CustomAudioLite.db.profile.events[eventKey].custom.path end,
                set = function(_, value) CustomAudioLite.db.profile.events[eventKey].custom.path = value:gsub("%s+", "") end,
                hidden = function() return CustomAudioLite.db.profile.events[eventKey].source ~= "custom" end,
                order = 6,
            },
            -- Долбит рандомно (папка с файлами)
            randomPath = {
                type = "input",
                name = "Путь к папке",
                desc = "Путь к папке, хуле не понятно (например: Sounds\\Random)",
                width = "double",
                get = function() return CustomAudioLite.db.profile.events[eventKey].random.path end,
                set = function(_, value) CustomAudioLite.db.profile.events[eventKey].random.path = value:gsub("%s+", "") end,
                hidden = function() return CustomAudioLite.db.profile.events[eventKey].source ~= "random" end,
                order = 7,
            },
            randomMax = {
                type = "range",
                name = "Количество долбежа",
                desc = "Сколько файлов в папке (например: 1.mp3, 2.mp3, n+1.mp3, ...)",
                min = 1,
                max = 10,
                step = 1,
                bigStep = 1,
                get = function() return CustomAudioLite.db.profile.events[eventKey].random.max end,
                set = function(_, value) CustomAudioLite.db.profile.events[eventKey].random.max = value end,
                hidden = function() return CustomAudioLite.db.profile.events[eventKey].source ~= "random" end,
                order = 8,
            },
            spacer3 = {
                type = "description",
                name = " ",
                order = 9,
            },
            channel = {
                type = "select",
                name = "Канал звука",
                values = {
                    ["Master"] = "Основной",
                    ["SFX"] = "Эффекты",
                },
                get = function() return CustomAudioLite.db.profile.events[eventKey].channel end,
                set = function(_, value) CustomAudioLite.db.profile.events[eventKey].channel = value end,
                order = 10,
            },
            spacer4 = {
                type = "description",
                name = " ",
                order = 11,
            },
            test = {
                type = "execute",
                name = "Че реально работает?",
                desc = "Воспроизвести выбранный звук",
                func = function()
                    CustomAudioLite:PlaySoundEffect(CustomAudioLite.db.profile.events[eventKey], eventKey)
                end,
                order = 12,
            },
            tooltip = tooltip and {
                type = "description",
                name = tooltip,
                fontSize = "small",
                order = 13,
            } or nil,
        },
    }
end

-- Опции для кастомного спелла
local function GetCustomSpellOptions(spellIndex)
    local spellConfig = CustomAudioLite.db.profile.customSpells.spells[spellIndex]
    if not spellConfig then return nil end
    
    return {
        type = "group",
        name = "Спелл #" .. spellIndex,
        inline = true,
        args = {
            enabled = {
                type = "toggle",
                name = "Включено",
                width = "full",
                get = function() return spellConfig.enabled end,
                set = function(_, value) spellConfig.enabled = value end,
                order = 1,
            },
            spellId = {
                type = "input",
                name = "ID спелла",
                desc = "C вики, или аддон idTip в помощь (например: 2825, 1943, 133)",
                width = "full",
                get = function() return tostring(spellConfig.spellId or "") end,
                set = function(_, value) 
                    local num = tonumber(value)
                    spellConfig.spellId = num or nil
                end,
                order = 2,
            },
            spacer1 = {
                type = "description",
                name = " ",
                order = 3,
            },
            source = {
                type = "select",
                name = "Откуда долбит",
                width = "double",
                values = {
                    ["custom"] = "Долбит нормально",   -- Один файл
                    ["shared"] = "Блютуз колонка",     -- SharedMedia
                    ["random"] = "Долбит рандомно",    -- Рандом из папки
                },
                get = function() return spellConfig.source end,
                set = function(_, value) spellConfig.source = value end,
                order = 4,
            },
            spacer2 = {
                type = "description",
                name = " ",
                order = 5,
            },
            -- Блютуз колонка (SharedMedia)
            shared = {
                type = "select",
                name = "Pass me the aux cord fam",
                desc = "Че в библе есть",
                dialogControl = "LSM30_Sound",
                values = function()
                    local values = LSM:HashTable("sound")
                    values["None"] = "<Не выбрано>"
                    return values
                end,
                get = function() return spellConfig.shared.value end,
                set = function(_, value) spellConfig.shared.value = value end,
                hidden = function() return spellConfig.source ~= "shared" end,
                order = 6,
            },
            -- Долбит нормально (один файл)
            customPath = {
                type = "input",
                name = "Путь к файлу",
                desc = "Путь относительно Interface\\AddOns (без расширения .mp3)",
                width = "double",
                get = function() return spellConfig.custom.path end,
                set = function(_, value) spellConfig.custom.path = value:gsub("%s+", "") end,
                hidden = function() return spellConfig.source ~= "custom" end,
                order = 7,
            },
            -- Долбит рандомно (папка с файлами)
            randomPath = {
                type = "input",
                name = "Путь к папке",
                desc = "Путь к папке, хуле не понятно (например: Sounds\\Random)",
                width = "double",
                get = function() return spellConfig.random.path end,
                set = function(_, value) spellConfig.random.path = value:gsub("%s+", "") end,
                hidden = function() return spellConfig.source ~= "random" end,
                order = 8,
            },
            randomMax = {
                type = "range",
                name = "Количество долбежа",
                desc = "Сколько файлов в папке (например: 1.mp3, 2.mp3, n+1.mp3, ...)",
                min = 1,
                max = 10,
                step = 1,
                bigStep = 1,
                get = function() return spellConfig.random.max end,
                set = function(_, value) spellConfig.random.max = value end,
                hidden = function() return spellConfig.source ~= "random" end,
                order = 9,
            },
            spacer3 = {
                type = "description",
                name = " ",
                order = 10,
            },
            channel = {
                type = "select",
                name = "Канал звука",
                values = {
                    ["Master"] = "Основной",
                    ["SFX"] = "Эффекты",
                },
                get = function() return spellConfig.channel end,
                set = function(_, value) spellConfig.channel = value end,
                order = 11,
            },
            spacer4 = {
                type = "description",
                name = " ",
                order = 12,
            },
            test = {
                type = "execute",
                name = "Че реально работает?",
                desc = "Воспроизвести выбранный звук",
                func = function()
                    CustomAudioLite:PlaySoundEffect(spellConfig, "customSpell_" .. (spellConfig.spellId or spellIndex))
                end,
                order = 13,
            },
            remove = {
                type = "execute",
                name = "|cffff0000Удалить спелл|r",
                desc = "Удалить этот спелл из списка",
                func = function()
                    table.remove(CustomAudioLite.db.profile.customSpells.spells, spellIndex)
                    CustomAudioLite:RebuildSpellOptions()
                end,
                order = 14,
            },
        },
    }
end

-- Опции для кастомной ауры
local function GetCustomAuraOptions(auraIndex)
    local auraConfig = CustomAudioLite.db.profile.customAuras.auras[auraIndex]
    if not auraConfig then return nil end
    
    return {
        type = "group",
        name = "Аура #" .. auraIndex,
        inline = true,
        args = {
            enabled = {
                type = "toggle",
                name = "Включено",
                width = "full",
                get = function() return auraConfig.enabled end,
                set = function(_, value) auraConfig.enabled = value end,
                order = 1,
            },
            auraId = {
                type = "input",
                name = "ID ауры",
                desc = "С вики, или аддон idTip в помощь (например: 2825, 1943, 133)",
                width = "full",
                get = function() return tostring(auraConfig.auraId or "") end,
                set = function(_, value) 
                    local num = tonumber(value)
                    auraConfig.auraId = num or nil
                end,
                order = 2,
            },
            spacer1 = {
                type = "description",
                name = " ",
                order = 3,
            },
            source = {
                type = "select",
                name = "Откуда долбит",
                width = "double",
                values = {
                    ["custom"] = "Долбит нормально",   -- Один файл
                    ["shared"] = "Блютуз колонка",     -- SharedMedia
                    ["random"] = "Долбит рандомно",    -- Рандом из папки
                },
                get = function() return auraConfig.source end,
                set = function(_, value) auraConfig.source = value end,
                order = 4,
            },
            spacer2 = {
                type = "description",
                name = " ",
                order = 5,
            },
            -- Блютуз колонка (SharedMedia)
            shared = {
                type = "select",
                name = "Pass me the aux cord fam",
                desc = "Че в библе есть",
                dialogControl = "LSM30_Sound",
                values = function()
                    local values = LSM:HashTable("sound")
                    values["None"] = "<Не выбрано>"
                    return values
                end,
                get = function() return auraConfig.shared.value end,
                set = function(_, value) auraConfig.shared.value = value end,
                hidden = function() return auraConfig.source ~= "shared" end,
                order = 6,
            },
            -- Долбит нормально (один файл)
            customPath = {
                type = "input",
                name = "Путь к файлу",
                desc = "Путь относительно Interface\\AddOns (без расширения .mp3)",
                width = "double",
                get = function() return auraConfig.custom.path end,
                set = function(_, value) auraConfig.custom.path = value:gsub("%s+", "") end,
                hidden = function() return auraConfig.source ~= "custom" end,
                order = 7,
            },
            -- Долбит рандомно (папка с файлами)
            randomPath = {
                type = "input",
                name = "Путь к папке",
                desc = "Путь к папке, хуле не понятно (например: Sounds\\Random)",
                width = "double",
                get = function() return auraConfig.random.path end,
                set = function(_, value) auraConfig.random.path = value:gsub("%s+", "") end,
                hidden = function() return auraConfig.source ~= "random" end,
                order = 8,
            },
            randomMax = {
                type = "range",
                name = "Количество долбежа",
                desc = "Сколько файлов в папке (например: 1.mp3, 2.mp3, n+1.mp3, ...)",
                min = 1,
                max = 10,
                step = 1,
                bigStep = 1,
                get = function() return auraConfig.random.max end,
                set = function(_, value) auraConfig.random.max = value end,
                hidden = function() return auraConfig.source ~= "random" end,
                order = 9,
            },
            spacer3 = {
                type = "description",
                name = " ",
                order = 10,
            },
            channel = {
                type = "select",
                name = "Канал звука",
                values = {
                    ["Master"] = "Основной",
                    ["SFX"] = "Эффекты",
                },
                get = function() return auraConfig.channel end,
                set = function(_, value) auraConfig.channel = value end,
                order = 11,
            },
            spacer4 = {
                type = "description",
                name = " ",
                order = 12,
            },
            test = {
                type = "execute",
                name = "Че реально работает?",
                desc = "Воспроизвести выбранный звук",
                func = function()
                    CustomAudioLite:PlaySoundEffect(auraConfig, "customAura_" .. (auraConfig.auraId or auraIndex))
                end,
                order = 13,
            },
            remove = {
                type = "execute",
                name = "|cffff0000Удалить ауру|r",
                desc = "Удалить эту ауру из списка",
                func = function()
                    table.remove(CustomAudioLite.db.profile.customAuras.auras, auraIndex)
                    CustomAudioLite:RebuildAuraOptions()
                end,
                order = 14,
            },
        },
    }
end

CustomAudioLiteOptions = {
    type = "group",
    name = "Commander Mityai's Custom Audio Lite",
    childGroups = "tab",
    args = {
        interrupt = GetSoundOptions("interrupt", "Прерывание каста", "Срабатывает по нажатию кнопки прерывания, даже если каст не был сбит (Если у цели он несбиваемый, а вы нажали кнопку). Чек на было ли успешное сбитие нереализуем с нынешним API (Либо я не нашел, хз)"),
        death = GetSoundOptions("death", "Смерть", "Лошок"),
        bloodlust = GetSoundOptions("bloodlust", "БладЛаст", "Срабатывает при прожатии бладласта любым игроком в пати в пределах видимости"),
        -- НОВОЕ: Два поля для лута в ОДНОЙ вкладке
        loot = {
            type = "group",
            name = "Лут",
            args = {
                rareLootRare = GetSoundOptions("rareLootRare", "Редкие предметы (rarity 3)", "Срабатывает при получении редкого предмета (синий, rarity 3)"),
                rareLootEpic = GetSoundOptions("rareLootEpic", "Эпические предметы и выше (rarity >= 4)", "Срабатывает при получении эпического (фиолетовый) или легендарного (оранжевый) предмета"),
            },
        },
        raidEnterDungeon = GetSoundOptions("raidEnterDungeon", "Вход в данж", "При заходе в подземелье проигрывается звук"),
        raidEnterRaid = GetSoundOptions("raidEnterRaid", "Вход в рейд", "При заходе в рейд проигрывается звук"),
        -- НОВОЕ: Кастомные спеллы (сохранены!)
        customSpells = {
            type = "group",
            name = "Кастомные спеллы",
            desc = "Звуки при касте своих спеллов",
            args = {
                enabled = {
                    type = "toggle",
                    name = "Включено",
                    width = "full",
                    get = function() return CustomAudioLite.db.profile.customSpells.enabled end,
                    set = function(_, value) CustomAudioLite.db.profile.customSpells.enabled = value end,
                    order = 1,
                },
                spacer1 = {
                    type = "description",
                    name = " ",
                    order = 2,
                },
                addSpell = {
                    type = "execute",
                    name = "|cff00ff00+ Добавить спелл|r",
                    desc = "Добавить новый спелл в список",
                    func = function()
                        local newSpell = {
                            spellId = nil,
                            enabled = true,
                            source = "custom",
                            channel = "Master",
                            random = { 
                              path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", 
                                max = 3, 
                                isRandom = { enabled = true, currentFile = 1 } 
                              },
                            shared = {
                                value = "None",
                            },
                            custom = {
                                path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\",
                                customType = "file",
                                max = 1,
                                isRandom = {
                                    enabled = true,
                                    currentFile = 1,
                                },
                            },
                        }
                        table.insert(CustomAudioLite.db.profile.customSpells.spells, newSpell)
                        CustomAudioLite:RebuildSpellOptions()
                    end,
                    order = 3,
                },
                spacer2 = {
                    type = "description",
                    name = " ",
                    order = 4,
                },
                spellsContainer = {
                    type = "group",
                    name = "Список спеллов",
                    inline = true,
                    order = 5,
                    args = {}, -- Заполняется динамически в RebuildSpellOptions
                },
            },
        },
        -- НОВОЕ: Кастомные ауры и бафы
        customAuras = {
            type = "group",
            name = "Кастомные ауры и бафы",
            desc = "Звуки при получении ауры экскрементально",
            args = {
                enabled = {
                    type = "toggle",
                    name = "Включено",
                    width = "full",
                    get = function() return CustomAudioLite.db.profile.customAuras.enabled end,
                    set = function(_, value) CustomAudioLite.db.profile.customAuras.enabled = value end,
                    order = 1,
                },
                spacer1 = {
                    type = "description",
                    name = " ",
                    order = 2,
                },
                addAura = {
                    type = "execute",
                    name = "|cff00ff00+ Добавить ауру|r",
                    desc = "Добавить новую ауру в список",
                    func = function()
                        local newAura = {
                            auraId = nil,
                            enabled = true,
                            source = "custom",
                            channel = "Master",
                            random = { 
                              path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random", 
                                max = 3, 
                                isRandom = { enabled = true, currentFile = 1 } 
                            },
                            shared = {
                                value = "None",
                            },
                            custom = {
                                path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\",
                                customType = "file",
                                max = 1,
                                isRandom = {
                                    enabled = true,
                                    currentFile = 1,
                                },
                            },
                        }
                        table.insert(CustomAudioLite.db.profile.customAuras.auras, newAura)
                        CustomAudioLite:RebuildAuraOptions()
                    end,
                    order = 3,
                },
                spacer2 = {
                    type = "description",
                    name = " ",
                    order = 4,
                },
                aurasContainer = {
                    type = "group",
                    name = "Список аур",
                    inline = true,
                    order = 5,
                    args = {}, -- Заполняется динамически в RebuildAuraOptions
                },
            },
        },
        zzz_about = {
            type = "group",
            name = "О аддоне",
            args = {
                info = {
                    type = "description",
                    name = "Commander Mityai's Custom Audio Lite v1.228\n\nСоздано специально для игрового сообщества \"Казимир\", навайбкожено слезами и потом\nПри возникновении идей, для добавления нового функционала - пишите в личку\n\nПоддерживаемые события:\n• Прерывание каста противника (Триггер \"UNIT_SPELLCAST_SUCCEEDED\")\n• Смерть персонажа (Триггер \"OnPlayerDead\")\n• Получение бладласта (Триггер \"UNIT_AURA\")\n• Получение лута (Чек на rarity по гиперлинке)\n• Вход в подземелья (5 игроков) (Триггер \"ZONE_CHANGED_NEW_AREA\")\n• Вход в рейды (10+ игроков) (Триггер \"ZONE_CHANGED_NEW_AREA\")\n• Кастомные спеллы (Триггер \"UNIT_SPELLCAST_SUCCEEDED\")\n• Кастомные ауры и бафы (Периодическая проверка по C_UNIT_AURASGET)\n\nПоддержка .mp3 (Возможно даже .ogg, мне было впадлу тестить)\nДобавить свой звук - закинуть в папку, правильно прописать путь. Есть функционал отладки через чат - для включение раскомментить строчку где-то на 87-90 в core",
                    fontSize = "medium",
                    order = 1,
                },
            },
        },
    },
}

-- Функция для построения опций спеллов
function CustomAudioLite:RebuildSpellOptions()
    local spellsContainer = CustomAudioLiteOptions.args.customSpells.args.spellsContainer.args
    table.wipe(spellsContainer)
    
    local spells = CustomAudioLite.db.profile.customSpells.spells
    for i = 1, #spells do
        spellsContainer["spell_" .. i] = GetCustomSpellOptions(i)
    end
    
    LibStub("AceConfigRegistry-3.0"):NotifyChange("CustomAudioLite")
end

-- Функция для построения опций аур
function CustomAudioLite:RebuildAuraOptions()
    local aurasContainer = CustomAudioLiteOptions.args.customAuras.args.aurasContainer.args
    table.wipe(aurasContainer)
    
    local auras = CustomAudioLite.db.profile.customAuras.auras
    for i = 1, #auras do
        aurasContainer["aura_" .. i] = GetCustomAuraOptions(i)
    end
    
    LibStub("AceConfigRegistry-3.0"):NotifyChange("CustomAudioLite")
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    if CustomAudioLite.db.profile.customSpells.spells then
        for _, spell in ipairs(CustomAudioLite.db.profile.customSpells.spells) do
            if not spell.random then
                spell.random = {
                    path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max = 3,
                    isRandom = { enabled = true, currentFile = 1 }
                }
            end
        end
    end
    
    if CustomAudioLite.db.profile.customAuras.auras then
        for _, aura in ipairs(CustomAudioLite.db.profile.customAuras.auras) do
            if not aura.random then
                aura.random = {
                    path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max = 3,
                    isRandom = { enabled = true, currentFile = 1 }
                }
            end
        end
    end

    CustomAudioLite:RebuildSpellOptions() 
    CustomAudioLite:RebuildAuraOptions() 
    LibStub("AceConfig-3.0"):RegisterOptionsTable("CustomAudioLite", CustomAudioLiteOptions)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CustomAudioLite", "Commander Mityai's Custom Audio Lite")

    SLASH_CUSTOMAUDIOLITE1 = "/kal"
    SlashCmdList["CUSTOMAUDIOLITE"] = function()
        LibStub("AceConfigDialog-3.0"):Open("CustomAudioLite")
    end

    frame:UnregisterEvent("PLAYER_LOGIN")
end)