-- ============================================================
-- Commander Mityai's Custom Audio Lite — Config / Options
-- ============================================================

local LSM = LibStub("LibSharedMedia-3.0")


-- ============================================================
-- Хелпер: настройки для встроенного события
-- ============================================================

local function GetSoundOptions(eventKey, eventName, tooltip)
    return {
        type = "group",
        name = eventName,
        args = {

            enabled = {
                type  = "toggle",
                name  = "Включено",
                width = "full",
                order = 1,
                get = function()
                    return CustomAudioLite.db.profile.events[eventKey].enabled
                end,
                set = function(_, value)
                    CustomAudioLite.db.profile.events[eventKey].enabled = value
                end,
            },

            spacer1 = { type = "description", name = " ", order = 2 },

            source = {
                type   = "select",
                name   = "Откуда долбит",
                width  = "double",
                order  = 3,
                values = {
                    ["custom"] = "Долбит нормально",
                    ["shared"] = "Блютуз колонка",
                    ["random"] = "Долбит рандомно",
                },
                get = function()
                    return CustomAudioLite.db.profile.events[eventKey].source
                end,
                set = function(_, value)
                    CustomAudioLite.db.profile.events[eventKey].source = value
                end,
            },

            spacer2 = { type = "description", name = " ", order = 4 },

            shared = {
                type          = "select",
                name          = "Pass me the aux cord fam",
                desc          = "Че в библе есть",
                dialogControl = "LSM30_Sound",
                order         = 5,
                values = function()
                    local v = LSM:HashTable("sound")
                    v["None"] = " <Не выбрано> "
                    return v
                end,
                get = function()
                    return CustomAudioLite.db.profile.events[eventKey].shared.value
                end,
                set = function(_, value)
                    CustomAudioLite.db.profile.events[eventKey].shared.value = value
                end,
                hidden = function()
                    return CustomAudioLite.db.profile.events[eventKey].source ~= "shared"
                end,
            },

            customPath = {
                type  = "input",
                name  = "Путь к файлу",
                desc  = "Путь относительно Interface\\AddOns (без расширения .mp3)",
                width = "double",
                order = 6,
                get = function()
                    return CustomAudioLite.db.profile.events[eventKey].custom.path
                end,
                set = function(_, value)
                    CustomAudioLite.db.profile.events[eventKey].custom.path =
                        value:gsub("%s+", "")
                end,
                hidden = function()
                    return CustomAudioLite.db.profile.events[eventKey].source ~= "custom"
                end,
            },

            randomPath = {
                type  = "input",
                name  = "Путь к папке",
                desc  = "Путь к папке, хуле не понятно (например: Sounds\\Random)",
                width = "double",
                order = 7,
                get = function()
                    return CustomAudioLite.db.profile.events[eventKey].random.path
                end,
                set = function(_, value)
                    CustomAudioLite.db.profile.events[eventKey].random.path =
                        value:gsub("%s+", "")
                end,
                hidden = function()
                    return CustomAudioLite.db.profile.events[eventKey].source ~= "random"
                end,
            },

            randomMax = {
                type    = "range",
                name    = "Количество долбежа",
                desc    = "Сколько файлов в папке (1.mp3, 2.mp3, ...)",
                min     = 1,
                max     = 10,
                step    = 1,
                bigStep = 1,
                order   = 8,
                get = function()
                    return CustomAudioLite.db.profile.events[eventKey].random.max
                end,
                set = function(_, value)
                    CustomAudioLite.db.profile.events[eventKey].random.max = value
                end,
                hidden = function()
                    return CustomAudioLite.db.profile.events[eventKey].source ~= "random"
                end,
            },

            spacer3 = { type = "description", name = " ", order = 9 },

            channel = {
                type  = "select",
                name  = "Канал звука",
                order = 10,
                values = {
                    ["Master"] = "Основной",
                    ["SFX"]    = "Эффекты",
                },
                get = function()
                    return CustomAudioLite.db.profile.events[eventKey].channel
                end,
                set = function(_, value)
                    CustomAudioLite.db.profile.events[eventKey].channel = value
                end,
            },

            spacer4 = { type = "description", name = " ", order = 11 },

            test = {
                type  = "execute",
                name  = "Че реально работает?",
                desc  = "Воспроизвести выбранный звук",
                order = 12,
                func = function()
                    CustomAudioLite:PlaySoundEffect(
                        CustomAudioLite.db.profile.events[eventKey], eventKey)
                end,
            },

            tooltip = tooltip and {
                type     = "description",
                name     = tooltip,
                fontSize = "small",
                order    = 13,
            } or nil,
        },
    }
end


-- ============================================================
-- Хелпер: кастомный спелл
-- ============================================================

local function GetCustomSpellOptions(spellIndex)
    local spellConfig = CustomAudioLite.db.profile.customSpells.spells[spellIndex]
    if not spellConfig then return nil end

    return {
        type   = "group",
        name   = "Спелл #" .. spellIndex,
        inline = true,
        args   = {

            enabled = {
                type = "toggle", name = "Включено", width = "full", order = 1,
                get = function() return spellConfig.enabled end,
                set = function(_, v) spellConfig.enabled = v end,
            },

            spellId = {
                type  = "input",
                name  = "ID спелла",
                desc  = "С вики, или аддон idTip (например: 2825, 1943, 133)",
                width = "full",
                order = 2,
                get = function() return tostring(spellConfig.spellId or "") end,
                set = function(_, v) spellConfig.spellId = tonumber(v) or nil end,
            },

            spacer1 = { type = "description", name = " ", order = 3 },

            source = {
                type  = "select", name = "Откуда долбит", width = "double", order = 4,
                values = {
                    ["custom"] = "Долбит нормально",
                    ["shared"] = "Блютуз колонка",
                    ["random"] = "Долбит рандомно",
                },
                get = function() return spellConfig.source end,
                set = function(_, v) spellConfig.source = v end,
            },

            spacer2 = { type = "description", name = " ", order = 5 },

            shared = {
                type = "select", name = "Pass me the aux cord fam", desc = "Че в библе есть",
                dialogControl = "LSM30_Sound", order = 6,
                values = function()
                    local v = LSM:HashTable("sound"); v["None"] = " <Не выбрано> "; return v
                end,
                get    = function() return spellConfig.shared.value end,
                set    = function(_, v) spellConfig.shared.value = v end,
                hidden = function() return spellConfig.source ~= "shared" end,
            },

            customPath = {
                type = "input", name = "Путь к файлу",
                desc = "Путь относительно Interface\\AddOns (без расширения .mp3)",
                width = "double", order = 7,
                get    = function() return spellConfig.custom.path end,
                set    = function(_, v) spellConfig.custom.path = v:gsub("%s+", "") end,
                hidden = function() return spellConfig.source ~= "custom" end,
            },

            randomPath = {
                type = "input", name = "Путь к папке",
                desc = "Путь к папке (например: Sounds\\Random)",
                width = "double", order = 8,
                get    = function() return spellConfig.random.path end,
                set    = function(_, v) spellConfig.random.path = v:gsub("%s+", "") end,
                hidden = function() return spellConfig.source ~= "random" end,
            },

            randomMax = {
                type = "range", name = "Количество долбежа",
                desc = "Сколько файлов в папке (1.mp3, 2.mp3, ...)",
                min = 1, max = 10, step = 1, bigStep = 1, order = 9,
                get    = function() return spellConfig.random.max end,
                set    = function(_, v) spellConfig.random.max = v end,
                hidden = function() return spellConfig.source ~= "random" end,
            },

            spacer3 = { type = "description", name = " ", order = 10 },

            channel = {
                type = "select", name = "Канал звука", order = 11,
                values = { ["Master"] = "Основной", ["SFX"] = "Эффекты" },
                get = function() return spellConfig.channel end,
                set = function(_, v) spellConfig.channel = v end,
            },

            spacer4 = { type = "description", name = " ", order = 12 },

            test = {
                type = "execute", name = "Че реально работает?",
                desc = "Воспроизвести выбранный звук", order = 13,
                func = function()
                    CustomAudioLite:PlaySoundEffect(
                        spellConfig, "customSpell_" .. (spellConfig.spellId or spellIndex))
                end,
            },

            remove = {
                type = "execute", name = "|cffff0000Удалить спелл|r",
                desc = "Удалить этот спелл из списка", order = 14,
                func = function()
                    table.remove(
                        CustomAudioLite.db.profile.customSpells.spells, spellIndex)
                    CustomAudioLite:RebuildSpellOptions()
                end,
            },
        },
    }
end


-- ============================================================
-- Хелпер: кастомная аура
-- ============================================================

local function GetCustomAuraOptions(auraIndex)
    local auraConfig = CustomAudioLite.db.profile.customAuras.auras[auraIndex]
    if not auraConfig then return nil end

    return {
        type   = "group",
        name   = "Аура #" .. auraIndex,
        inline = true,
        args   = {

            enabled = {
                type = "toggle", name = "Включено", width = "full", order = 1,
                get = function() return auraConfig.enabled end,
                set = function(_, v) auraConfig.enabled = v end,
            },

            auraId = {
                type = "input", name = "ID ауры",
                desc = "С вики, или аддон idTip (например: 2825, 1943, 133)",
                width = "full", order = 2,
                get = function() return tostring(auraConfig.auraId or "") end,
                set = function(_, v) auraConfig.auraId = tonumber(v) or nil end,
            },

            spacer1 = { type = "description", name = " ", order = 3 },

            source = {
                type = "select", name = "Откуда долбит", width = "double", order = 4,
                values = {
                    ["custom"] = "Долбит нормально",
                    ["shared"] = "Блютуз колонка",
                    ["random"] = "Долбит рандомно",
                },
                get = function() return auraConfig.source end,
                set = function(_, v) auraConfig.source = v end,
            },

            spacer2 = { type = "description", name = " ", order = 5 },

            shared = {
                type = "select", name = "Pass me the aux cord fam", desc = "Че в библе есть",
                dialogControl = "LSM30_Sound", order = 6,
                values = function()
                    local v = LSM:HashTable("sound"); v["None"] = " <Не выбрано> "; return v
                end,
                get    = function() return auraConfig.shared.value end,
                set    = function(_, v) auraConfig.shared.value = v end,
                hidden = function() return auraConfig.source ~= "shared" end,
            },

            customPath = {
                type = "input", name = "Путь к файлу",
                desc = "Путь относительно Interface\\AddOns (без расширения .mp3)",
                width = "double", order = 7,
                get    = function() return auraConfig.custom.path end,
                set    = function(_, v) auraConfig.custom.path = v:gsub("%s+", "") end,
                hidden = function() return auraConfig.source ~= "custom" end,
            },

            randomPath = {
                type = "input", name = "Путь к папке",
                desc = "Путь к папке (например: Sounds\\Random)",
                width = "double", order = 8,
                get    = function() return auraConfig.random.path end,
                set    = function(_, v) auraConfig.random.path = v:gsub("%s+", "") end,
                hidden = function() return auraConfig.source ~= "random" end,
            },

            randomMax = {
                type = "range", name = "Количество долбежа",
                desc = "Сколько файлов в папке (1.mp3, 2.mp3, ...)",
                min = 1, max = 10, step = 1, bigStep = 1, order = 9,
                get    = function() return auraConfig.random.max end,
                set    = function(_, v) auraConfig.random.max = v end,
                hidden = function() return auraConfig.source ~= "random" end,
            },

            spacer3 = { type = "description", name = " ", order = 10 },

            channel = {
                type = "select", name = "Канал звука", order = 11,
                values = { ["Master"] = "Основной", ["SFX"] = "Эффекты" },
                get = function() return auraConfig.channel end,
                set = function(_, v) auraConfig.channel = v end,
            },

            spacer4 = { type = "description", name = " ", order = 12 },

            test = {
                type = "execute", name = "Че реально работает?",
                desc = "Воспроизвести выбранный звук", order = 13,
                func = function()
                    CustomAudioLite:PlaySoundEffect(
                        auraConfig, "customAura_" .. (auraConfig.auraId or auraIndex))
                end,
            },

            remove = {
                type = "execute", name = "|cffff0000Удалить ауру|r", order = 14,
                func = function()
                    table.remove(
                        CustomAudioLite.db.profile.customAuras.auras, auraIndex)
                    CustomAudioLite:RebuildAuraOptions()
                end,
            },
        },
    }
end


-- ============================================================
-- Хелпер: запись замены звука  (НОВОЕ)
-- ============================================================

local function GetSoundReplacementOptions(repIndex)
    local rep = CustomAudioLite.db.profile.soundReplacements.replacements[repIndex]
    if not rep then return nil end

    return {
        type   = "group",
        name   = (rep.name and rep.name ~= "") and rep.name or ("Замена #" .. repIndex),
        inline = true,
        args   = {

            enabled = {
                type = "toggle", name = "Включено", width = "full", order = 1,
                get = function() return rep.enabled end,
                set = function(_, v)
                    rep.enabled = v
                    CustomAudioLite:RefreshSoundMutes()
                end,
            },

            name = {
                type = "input", name = "Название (необязательно)",
                desc = "Для удобства, чтоб не путаться",
                width = "double", order = 2,
                get = function() return rep.name or "" end,
                set = function(_, v)
                    rep.name = v
                    CustomAudioLite:RebuildReplacementOptions()
                end,
            },

            spacer0 = { type = "description", name = " ", order = 3 },

            descIds = {
                type     = "description",
                fontSize = "small",
                order    = 4,
                name     = "|cffffcc00SoundKit ID|r — перехватывает вызов PlaySound "
                        .. "(интерфейсные звуки: ready-check, ачивки и т.д.).\n"
                        .. "|cffffcc00FileData ID|r — глушит конкретный аудио-файл "
                        .. "через MuteSoundFile (работает на ВСЕ звуки клиента).\n"
                        .. "Для полной замены укажите оба: FileData заглушит оригинал, "
                        .. "SoundKit определит момент воспроизведения замены.",
            },

            soundKitId = {
                type  = "input",
                name  = "SoundKit ID",
                desc  = "ID из SOUNDKIT / Wowhead (например 3175 = MapPing). "
                     .. "Используется для перехвата PlaySound и воспроизведения замены.",
                width = "normal",
                order = 5,
                get = function() return tostring(rep.soundKitId or "") end,
                set = function(_, v)
                    rep.soundKitId = tonumber(v) or nil
                end,
            },

            fileDataIds = {
                type  = "input",
                name  = "FileData ID (через запятую)",
                desc  = "ID звуковых файлов для заглушения через MuteSoundFile. "
                     .. "Можно указать несколько через запятую (например: 567478, 567479).",
                width = "double",
                order = 6,
                get = function() return rep.fileDataIds or "" end,
                set = function(_, v)
                    rep.fileDataIds = v:gsub("%s+", "")
                    CustomAudioLite:RefreshSoundMutes()
                end,
            },

            spacer1 = { type = "description", name = " ", order = 7 },

            source = {
                type  = "select",
                name  = "Откуда долбит",
                desc  = "\"Онли мут клоун\" — ничего не играет. "
                     .. "Всё то же что и в других функциях.",
                width = "double",
                order = 8,
                values = {
                    ["none"]   = "Онли мут клоун",
                    ["custom"] = "Долбит нормально",
                    ["shared"] = "Блютуз колонка",
                    ["random"] = "Долбит рандомно",
                },
                get = function() return rep.source or "none" end,
                set = function(_, v) rep.source = v end,
            },

            spacer2 = { type = "description", name = " ", order = 9 },

            -- SharedMedia
            shared = {
                type = "select", name = "Pass me the aux cord fam",
                desc = "Из библы",
                dialogControl = "LSM30_Sound", order = 10,
                values = function()
                    local v = LSM:HashTable("sound")
                    v["None"] = " <Не выбрано> "
                    return v
                end,
                get = function() return rep.shared and rep.shared.value or "None" end,
                set = function(_, v)
                    if not rep.shared then rep.shared = {} end
                    rep.shared.value = v
                end,
                hidden = function() return rep.source ~= "shared" end,
            },

            -- Custom path
            customPath = {
                type = "input", name = "Путь к файлу",
                desc = "Полный путь (без расширения .mp3)",
                width = "double", order = 11,
                get = function() return rep.custom and rep.custom.path or "" end,
                set = function(_, v)
                    if not rep.custom then rep.custom = {} end
                    rep.custom.path = v:gsub("%s+", "")
                end,
                hidden = function() return rep.source ~= "custom" end,
            },

            -- Random path
            randomPath = {
                type = "input", name = "Путь к папке",
                desc = "Папка с файлами 1.mp3, 2.mp3, ...",
                width = "double", order = 12,
                get = function() return rep.random and rep.random.path or "" end,
                set = function(_, v)
                    if not rep.random then rep.random = {} end
                    rep.random.path = v:gsub("%s+", "")
                end,
                hidden = function() return rep.source ~= "random" end,
            },

            randomMax = {
                type = "range", name = "Файлов в папке",
                desc = "Сколько файлов (1.mp3 ... N.mp3)",
                min = 1, max = 30, step = 1, bigStep = 1, order = 13,
                get = function() return rep.random and rep.random.max or 1 end,
                set = function(_, v)
                    if not rep.random then rep.random = {} end
                    rep.random.max = v
                end,
                hidden = function() return rep.source ~= "random" end,
            },

            spacer3 = { type = "description", name = " ", order = 14 },

            channel = {
                type = "select", name = "Канал звука", order = 15,
                values = { ["Master"] = "Основной", ["SFX"] = "Эффекты" },
                get = function() return rep.channel or "Master" end,
                set = function(_, v) rep.channel = v end,
                hidden = function() return rep.source == "none" end,
            },

            spacer4 = { type = "description", name = " ", order = 16 },

            test = {
                type = "execute", name = "Че реально работает?",
                desc = "Воспроизвести звук", order = 17,
                hidden = function() return rep.source == "none" end,
                func = function()
                    CustomAudioLite:PlaySoundEffect(
                        rep, "replaceTest_" .. (rep.soundKitId or repIndex))
                end,
            },

            remove = {
                type = "execute",
                name = "|cffff0000Удалить запись|r",
                order = 18,
                confirm     = true,
                confirmText = "Удалить эту замену звука?",
                func = function()
                    -- Снимаем мьюты перед удалением
                    if rep.fileDataIds and rep.fileDataIds ~= "" then
                        for token in rep.fileDataIds:gmatch("[^,%s]+") do
                            local id = tonumber(token)
                            if id then UnmuteSoundFile(id) end
                        end
                    end
                    table.remove(
                        CustomAudioLite.db.profile.soundReplacements.replacements,
                        repIndex)
                    CustomAudioLite:RefreshSoundMutes()
                    CustomAudioLite:RebuildReplacementOptions()
                end,
            },
        },
    }
end


-- ============================================================
-- Главная таблица опций
-- ============================================================

CustomAudioLiteOptions = {
    type        = "group",
    name        = "Commander Mityai's Custom Audio Lite",
    childGroups = "tab",
    args        = {

        -- Встроенные события ----------------------------------

        interrupt        = GetSoundOptions("interrupt",        "Прерывание каста",
            "Срабатывает по нажатию кнопки прерывания, "
            .. "даже если каст не был сбит."),

        death            = GetSoundOptions("death",            "Смерть",
            "Лошок"),

        bloodlust        = GetSoundOptions("bloodlust",        "БладЛаст",
            "Срабатывает при бладласте любого игрока в пати "
            .. "в пределах видимости."),

        combatRez        = GetSoundOptions("combatRez",        "Боевое воскрешение",
            "Срабатывает когда ЛЮБОЙ игрок в группе/рейде "
            .. "использует комбат-рес (Друид, ДК, ЧМ, Паладин, Инженер). "
            .. "Бета функция."),

        loot = {
            type = "group",
            name = "Лут",
            args = {
                rareLootRare = GetSoundOptions("rareLootRare",
                    "Редкие предметы", "Рарочка выпала"),
                rareLootEpic = GetSoundOptions("rareLootEpic",
                    "Эпические предметы и выше", "Ого не мои статы"),
            },
        },

        raidEnterDungeon = GetSoundOptions("raidEnterDungeon", "Вход в данж",
            "Пора."),

        raidEnterRaid    = GetSoundOptions("raidEnterRaid",    "Вход в рейд",
            "У лохов нет курвы"),

            


        -- Кастомные спеллы ------------------------------------

        customSpells = {
            type = "group",
            name = "Кастомные спеллы",
            desc = "Звуки при касте своих спеллов",
            args = {
                enabled = {
                    type = "toggle", name = "Включено", width = "full", order = 1,
                    get = function()
                        return CustomAudioLite.db.profile.customSpells.enabled
                    end,
                    set = function(_, v)
                        CustomAudioLite.db.profile.customSpells.enabled = v
                    end,
                },
                spacer1 = { type = "description", name = " ", order = 2 },
                addSpell = {
                    type = "execute",
                    name = "|cff00ff00+ Добавить спелл|r",
                    desc = "Добавить новый спелл в список",
                    order = 3,
                    func = function()
                        local newSpell = {
                            spellId  = nil,
                            enabled  = true,
                            source   = "custom",
                            channel  = "Master",
                            shared   = { value = "None" },
                            custom   = {
                                path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds",
                                customType = "file", max = 1,
                                isRandom = { enabled = true, currentFile = 1 },
                            },
                            random   = {
                                path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                                max      = 3,
                                isRandom = { enabled = true, currentFile = 1 },
                            },
                        }
                        table.insert(
                            CustomAudioLite.db.profile.customSpells.spells, newSpell)
                        CustomAudioLite:RebuildSpellOptions()
                    end,
                },
                spacer2 = { type = "description", name = " ", order = 4 },
                spellsContainer = {
                    type = "group", name = "Список спеллов",
                    inline = true, order = 5, args = {},
                },
            },
        },


        -- Кастомные ауры --------------------------------------

        customAuras = {
            type = "group",
            name = "Кастомные ауры и бафы",
            desc = "Звуки при получении ауры, экскрементальная функция",
            args = {
                enabled = {
                    type = "toggle", name = "Включено", width = "full", order = 1,
                    get = function()
                        return CustomAudioLite.db.profile.customAuras.enabled
                    end,
                    set = function(_, v)
                        CustomAudioLite.db.profile.customAuras.enabled = v
                    end,
                },
                spacer1 = { type = "description", name = " ", order = 2 },
                addAura = {
                    type = "execute",
                    name = "|cff00ff00+ Добавить ауру|r",
                    desc = "Добавить новую ауру в список",
                    order = 3,
                    func = function()
                        local newAura = {
                            auraId   = nil,
                            enabled  = true,
                            source   = "custom",
                            channel  = "Master",
                            shared   = { value = "None" },
                            custom   = {
                                path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds",
                                customType = "file", max = 1,
                                isRandom = { enabled = true, currentFile = 1 },
                            },
                            random   = {
                                path     = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                                max      = 3,
                                isRandom = { enabled = true, currentFile = 1 },
                            },
                        }
                        table.insert(
                            CustomAudioLite.db.profile.customAuras.auras, newAura)
                        CustomAudioLite:RebuildAuraOptions()
                    end,
                },
                spacer2 = { type = "description", name = " ", order = 4 },
                aurasContainer = {
                    type = "group", name = "Список аур",
                    inline = true, order = 5, args = {},
                },
            },
        },


        -- =====================================================
        -- ЗАМЕНА / МЬЮТ ИГРОВЫХ ЗВУКОВ  (НОВОЕ)
        -- =====================================================

        soundReplacements = {
            type = "group",
            name = "Замена звуков",
            desc = "Заглушить и/или заменить любой игровой звук кастомным",
            order = 90,
            args = {

                headerDesc = {
                    type     = "description",
                    fontSize = "medium",
                    order    = 1,
                    name     = "Замена любых игровых звуков|r\n"
                            .. "Позволяет заглушить любой звук клиента (MuteSoundFile) "
                            .. "и/или перехватить вызов PlaySound для подмены "
                            .. "кастомным звуком.\n",
                },

                enabled = {
                    type  = "toggle",
                    name  = "Включить",
                    desc  = "Глобальный выключатель. При выключении все мьюты "
                         .. "снимаются, перехват PlaySound не срабатывает.",
                    width = "full",
                    order = 2,
                    get = function()
                        return CustomAudioLite.db.profile.soundReplacements.enabled
                    end,
                    set = function(_, v)
                        CustomAudioLite.db.profile.soundReplacements.enabled = v
                        CustomAudioLite:RefreshSoundMutes()
                    end,
                },

                spacer1 = { type = "description", name = " ", order = 3 },

                addReplacement = {
                    type  = "execute",
                    name  = "|cff00ff00+ Добавить замену|r",
                    desc  = "Создать новую запись для замены / мьюта звука",
                    order = 4,
                    func  = function()
                        local newEntry = {
                            enabled     = true,
                            name        = "",
                            soundKitId  = nil,
                            fileDataIds = "",
                            source      = "none",
                            channel     = "Master",
                            shared      = { value = "None" },
                            custom      = { path = "" },
                            random      = { path = "", max = 1 },
                        }
                        table.insert(
                            CustomAudioLite.db.profile
                                .soundReplacements.replacements,
                            newEntry)
                        CustomAudioLite:RebuildReplacementOptions()
                    end,
                },

                spacer2 = { type = "description", name = " ", order = 5 },

                replacementsContainer = {
                    type   = "group",
                    name   = "Список замен",
                    inline = true,
                    order  = 6,
                    args   = {},
                },
            },
        },


        -- О аддоне  -------------------------

        zzz_about = {
            type = "group",
            name = "О аддоне",
            args = {
                info = {
                    type     = "description",
                    fontSize = "medium",
                    order    = 1,
                    name     = "Commander Mityai's Custom Audio Lite v0.778\n\n"
                        .. "Создано специально для игрового сообщества \"Казимир\", "
                        .. "навайбкожено слезами и потом\n"
                        .. "При возникновении идей для добавления нового функционала - пишите в личку\n\n"
                        .. "Поддерживаемые события:\n"
                        .. "  \226\128\162 Прерывание каста (UNIT_SPELLCAST_SUCCEEDED)\n"
                        .. "  \226\128\162 Смерть персонажа (OnPlayerDead)\n"
                        .. "  \226\128\162 Бладласт (UNIT_AURA polling)\n"
                        .. "  \226\128\162 Боевое воскрешение (SPELL_CHARGES_CHANGED)\n"
                        .. "  \226\128\162 Лут (rarity по гиперлинке)\n"
                        .. "  \226\128\162 Вход в данж / рейд (ZONE_CHANGED_NEW_AREA)\n"
                        .. "  \226\128\162 Кастомные спеллы (UNIT_SPELLCAST_SUCCEEDED)\n"
                        .. "  \226\128\162 Кастомные ауры (C_UnitAuras polling)\n"
                        .. "  \226\128\162 Замена / мьют игровых звуков|r "
                        .. "(MuteSoundFile + PlaySound hook)\n\n"
                        .. "Поддержка .mp3 и ВОЗМОЖНО .ogg\n"
                        .. "Добавить свой звук — закинуть в папку, прописать путь.\n"
                        .. "Есть функционал отладки через чат - для включения раскомментить строчку где-то на 130 в core",
                },
            },
        },
    },
}


-- ============================================================
-- Ребилд-функции
-- ============================================================

function CustomAudioLite:RebuildSpellOptions()
    local container =
        CustomAudioLiteOptions.args.customSpells.args.spellsContainer.args
    wipe(container)
    local spells = self.db.profile.customSpells.spells
    for i = 1, #spells do
        container["spell_" .. i] = GetCustomSpellOptions(i)
    end
    LibStub("AceConfigRegistry-3.0"):NotifyChange("CustomAudioLite")
end

function CustomAudioLite:RebuildAuraOptions()
    local container =
        CustomAudioLiteOptions.args.customAuras.args.aurasContainer.args
    wipe(container)
    local auras = self.db.profile.customAuras.auras
    for i = 1, #auras do
        container["aura_" .. i] = GetCustomAuraOptions(i)
    end
    LibStub("AceConfigRegistry-3.0"):NotifyChange("CustomAudioLite")
end

function CustomAudioLite:RebuildReplacementOptions()
    local container =
        CustomAudioLiteOptions.args.soundReplacements.args
            .replacementsContainer.args
    wipe(container)
    local reps = self.db.profile.soundReplacements.replacements
    for i = 1, #reps do
        container["rep_" .. i] = GetSoundReplacementOptions(i)
    end
    LibStub("AceConfigRegistry-3.0"):NotifyChange("CustomAudioLite")
end


-- ============================================================
-- Регистрация при логине
-- ============================================================

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    CustomAudioLite:RebuildSpellOptions()
    CustomAudioLite:RebuildAuraOptions()
    CustomAudioLite:RebuildReplacementOptions()

    LibStub("AceConfig-3.0"):RegisterOptionsTable(
        "CustomAudioLite", CustomAudioLiteOptions)

    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
        "CustomAudioLite", "Commander Mityai's Custom Audio Lite")

    SLASH_CUSTOMAUDIOLITE1 = "/cal"
    SlashCmdList["CUSTOMAUDIOLITE"] = function()
        LibStub("AceConfigDialog-3.0"):Open("CustomAudioLite")
    end

    frame:UnregisterEvent("PLAYER_LOGIN")
end)
