-- ============================================================
-- Commander Mityai's Custom Audio Lite — Core
-- ============================================================

local ADDON_NAME, ns = ...
local LSM      = LibStub("LibSharedMedia-3.0")
local AceAddon  = LibStub("AceAddon-3.0")

CustomAudioLite = AceAddon:NewAddon("CustomAudioLite", "AceEvent-3.0")

local db


-- ============================================================
-- Справочники спеллов
-- ============================================================

-- Бладласт
local BLOODLUST_SPELLS = {
    [2825]    = true, [32182]   = true, [80353]   = true, [264667]  = true,
    [90355]   = true, [160452]  = true, [388976]  = true, [390386]  = true,
    [381301]  = true, [65980]   = true, [71975]   = true, [463981]  = true,
    [192423]  = true, [57724]   = true, [272678]  = true, [357650]  = true,
    [466904]  = true, [1243972] = true, [80354]   = true, [57723]   = true,
    [264689]  = true,
}

-- Прерывание
local INTERRUPT_SPELLS = {
    [2139]   = true, [57994]  = true, [147362] = true, [116705] = true,
    [6552]   = true, [183770] = true, [47528]  = true, [47476]  = true,
    [221562] = true, [19647]  = true, [89766]  = true, [1766]   = true,
    [15487]  = true, [96231]  = true, [183752] = true, [106839] = true,
    [78675]  = true, [351338] = true,
}

-- Боевое воскрешение
local COMBAT_REZ_SPELLS = {
    [20484]   = true,   -- Rebirth (Druid)
    [61999]   = true,   -- Raise Ally (Death Knight)
    [95750]   = true,   -- Soulstone Resurrection (Warlock)
    [391054]  = true,   -- Intercession (Paladin)
    [345130]  = true,   -- Disposable Spectrophasic Reanimator (Engineer)
    [385403]  = true,   -- Tinker: Arclight Vital Correctors (Engineer)
    [384893]  = true,   -- Convincingly Realistic Jumper Cables (Engineer)
    [248486]  = true,   -- ENGI cr midnight
    [1259644] = true,   -- ENGI cr midnight
}


-- ============================================================
-- Кэш и состояние
-- ============================================================

local soundCooldown        = {}
local hasBloodlust         = false
local bloodlustLostTime    = nil
local BLOODLUST_GRACE      = 5
local BLOODLUST_MAX_ELAPSED = 5

local hasCustomAuras       = {}
local customAuraLostTime   = {}
local CUSTOM_AURA_GRACE    = 5
local CUSTOM_AURA_MAX_ELAPSED = 5

local lastRezCharges       = {}

-- Для системы замены звуков
local activeMutes          = {}   -- { [fileDataID] = true }


-- ============================================================
-- Воспроизведение звукового эффекта
-- ============================================================

function CustomAudioLite:PlaySoundEffect(dbEntry, eventKey)
    if not dbEntry or not dbEntry.enabled then return end
    if soundCooldown[eventKey]
       and GetTime() - soundCooldown[eventKey] < 0.3 then
        return
    end

    local path    = ""
    local channel = dbEntry.channel or "Master"
    local source  = dbEntry.source or "custom"

    -- SharedMedia
    if source == "shared" then
        if dbEntry.shared
           and dbEntry.shared.value
           and dbEntry.shared.value ~= "None" then
            path = LSM:Fetch("sound", dbEntry.shared.value) or ""
        end

    -- Конкретный файл
    elseif source == "custom" then
        if dbEntry.custom
           and dbEntry.custom.path
           and dbEntry.custom.path ~= "" then
            path = dbEntry.custom.path:gsub("%s+", "")
            -- Нормализуем расширение: убираем .ogg/.mp3 если есть, ставим .mp3
            path = path:gsub("%.ogg$", ""):gsub("%.mp3$", "") .. ".mp3"
        end

    -- Рандомный файл из папки
    elseif source == "random" then
        if dbEntry.random
           and dbEntry.random.path
           and dbEntry.random.path ~= "" then
            local basePath = dbEntry.random.path:gsub("%s+", "")
            if not basePath:match("[/\\]$") then
                basePath = basePath .. "\\"
            end
            local maxFiles  = dbEntry.random.max or 1
            local randomNum = math.random(1, maxFiles)
            path = basePath .. randomNum .. ".mp3"
        end
    end

    -- Воспроизводим
    if path ~= "" then
        if C_Sound and C_Sound.PlaySoundFile then
            local soundChannel = Enum
                and Enum.SoundKitChannel
                and Enum.SoundKitChannel[channel]
                or  Enum.SoundKitChannel.Master
            C_Sound.PlaySoundFile(path, soundChannel)
        else
            PlaySoundFile(path, channel)
        end
        soundCooldown[eventKey] = GetTime()
          --print("✅ Звук проигран: " .. path)  -- Отладка
          -- else
          --  print("❌ Путь к звуку пустой! source=" .. source .. ", path=" .. (dbEntry.random and dbEntry.random.path or dbEntry.custom.path or "nil"))
    end
end


-- ============================================================
-- СИСТЕМА ЗАМЕНЫ / МЬЮТА ЗВУКОВ
-- ============================================================

--- Парсим строку FileData ID 
local function ParseFileDataIds(str)
    local ids = {}
    if not str or str == "" then return ids end
    for token in str:gmatch("[^,%s]+") do
        local num = tonumber(token)
        if num then
            ids[#ids + 1] = num
        end
    end
    return ids
end

--- Применить / обновить мьюты FileData ID
function CustomAudioLite:ApplySoundMutes()
    for id in pairs(activeMutes) do
        UnmuteSoundFile(id)
    end
    wipe(activeMutes)

    if not db.soundReplacements or not db.soundReplacements.enabled then
        return
    end

    -- 3. Ставим новые мьюты
    for _, rep in ipairs(db.soundReplacements.replacements) do
        if rep.enabled and rep.fileDataIds and rep.fileDataIds ~= "" then
            local ids = ParseFileDataIds(rep.fileDataIds)
            for _, id in ipairs(ids) do
                MuteSoundFile(id)
                activeMutes[id] = true
            end
        end
    end
end

--- Вызывается из конфига при изменении настроек замены
function CustomAudioLite:RefreshSoundMutes()
    self:ApplySoundMutes()
end

--- Установка хука на PlaySound (SoundKit перехват) — через hooksecurefunc,
--- чтобы не тейнтить возвращаемые значения Blizzard UI.
--- Оригинальный звук глушится через MuteSoundFile(fileDataID),
--- поэтому PlaySound отрабатывает «тишину», а  хук добавляет замену.
function CustomAudioLite:InstallPlaySoundHook()
    if self._playSoundHooked then return end

    hooksecurefunc("PlaySound", function(soundKitID, ...)
        -- Проверяем только если система включена и db готов
        if not db
           or not db.soundReplacements
           or not db.soundReplacements.enabled then
            return
        end

        if type(soundKitID) ~= "number" then return end

        for _, rep in ipairs(db.soundReplacements.replacements) do
            if rep.enabled
               and rep.soundKitId
               and tonumber(rep.soundKitId) == soundKitID then
                if rep.source and rep.source ~= "none" then
                    CustomAudioLite:PlaySoundEffect(
                        rep, "soundReplace_" .. soundKitID)
                end
                return
            end
        end
    end)

    self._playSoundHooked = true
end


-- Обработчики игровых событий

-- ЛУТ
function CustomAudioLite:CHAT_MSG_LOOT(event, text, lootReceiverName, ...)
    local myName = UnitName("player")
    if Ambiguate(lootReceiverName, "none") ~= myName then return end

    local itemLink = text:match("|Hitem:([^|]+)|h")
    if not itemLink then return end

    local itemID = itemLink:match("^(%d+)")
    if not itemID then return end

    local _, _, rarity = GetItemInfo(tonumber(itemID))

    -- Предмет ещё не закэширован — дожидаемся
    if not rarity then
        local item = Item:CreateFromItemID(tonumber(itemID))
        item:ContinueOnItemLoad(function()
            local _, _, r = GetItemInfo(tonumber(itemID))
            if r == 3 and db.events.rareLootRare.enabled then
                CustomAudioLite:PlaySoundEffect(db.events.rareLootRare, "rareLootRare")
            elseif r and r >= 4 and db.events.rareLootEpic.enabled then
                CustomAudioLite:PlaySoundEffect(db.events.rareLootEpic, "rareLootEpic")
            end
        end)
        return
    end

    if rarity == 3 and db.events.rareLootRare.enabled then
        CustomAudioLite:PlaySoundEffect(db.events.rareLootRare, "rareLootRare")
    elseif rarity >= 4 and db.events.rareLootEpic.enabled then
        CustomAudioLite:PlaySoundEffect(db.events.rareLootEpic, "rareLootEpic")
    end
end


-- Бладласт (тикер каждые 0.5 с)
local function CheckBloodlust()
    if not db.events.bloodlust.enabled then return end

    local found    = false
    local isNewAura = false

    for spellId in pairs(BLOODLUST_SPELLS) do
        local aura = C_UnitAuras
            and C_UnitAuras.GetPlayerAuraBySpellID
            and C_UnitAuras.GetPlayerAuraBySpellID(spellId)
        if aura then
            found = true
            if aura.duration and aura.duration > 0
               and aura.expirationTime then
                local elapsed = aura.duration - (aura.expirationTime - GetTime())
                if elapsed < BLOODLUST_MAX_ELAPSED then
                    isNewAura = true
                end
            end
            break
        end
    end

    if found then
        bloodlustLostTime = nil
        if not hasBloodlust and isNewAura then
            CustomAudioLite:PlaySoundEffect(db.events.bloodlust, "bloodlust")
            hasBloodlust = true
        elseif not hasBloodlust then
            hasBloodlust = true
        end
    elseif hasBloodlust then
        if not bloodlustLostTime then
            bloodlustLostTime = GetTime()
        elseif GetTime() - bloodlustLostTime > BLOODLUST_GRACE then
            hasBloodlust     = false
            bloodlustLostTime = nil
        end
    end
end


-- Кастомные ауры (тикер каждые 0.5 с)
local function CheckCustomAuras()
    if not db.customAuras.enabled then return end

    local auras = db.customAuras.auras
    for i, auraConfig in ipairs(auras) do
        if auraConfig.enabled and auraConfig.auraId then
            local aura = C_UnitAuras
                and C_UnitAuras.GetPlayerAuraBySpellID
                and C_UnitAuras.GetPlayerAuraBySpellID(auraConfig.auraId)
            local auraKey = "aura_" .. i

            if aura then
                customAuraLostTime[auraKey] = nil
                if not hasCustomAuras[auraKey] then
                    local isNewAura = false
                    if aura.duration and aura.duration > 0
                       and aura.expirationTime then
                        local elapsed = aura.duration
                            - (aura.expirationTime - GetTime())
                        if elapsed < CUSTOM_AURA_MAX_ELAPSED then
                            isNewAura = true
                        end
                    else
                        isNewAura = true
                    end
                    if isNewAura then
                        CustomAudioLite:PlaySoundEffect(
                            auraConfig,
                            "customAura_" .. auraConfig.auraId)
                    end
                    hasCustomAuras[auraKey] = true
                end

            elseif hasCustomAuras[auraKey] then
                if not customAuraLostTime[auraKey] then
                    customAuraLostTime[auraKey] = GetTime()
                elseif GetTime() - customAuraLostTime[auraKey]
                       > CUSTOM_AURA_GRACE then
                    hasCustomAuras[auraKey]     = nil
                    customAuraLostTime[auraKey] = nil
                end
            end
        end
    end
end


-- Проверка комбат-ресов
local function CheckCombatRez()
    if not db.events.combatRez.enabled then return end

    for spellId in pairs(COMBAT_REZ_SPELLS) do
        local chargeInfo = C_Spell
            and C_Spell.GetSpellCharges
            and C_Spell.GetSpellCharges(spellId)
        if chargeInfo and chargeInfo.currentCharges then
            local currentCharges = chargeInfo.currentCharges
            local lastCharges    = lastRezCharges[spellId]
            if lastCharges and currentCharges < lastCharges then
                CustomAudioLite:PlaySoundEffect(
                    db.events.combatRez, "combatRez_" .. spellId)
            end
            lastRezCharges[spellId] = currentCharges
        end
    end
end


-- Прерывание / кастомные спеллы
function CustomAudioLite:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellID)
    if unit ~= "player" then return end

    -- Прерывание
    if INTERRUPT_SPELLS[spellID] and db.events.interrupt.enabled then
        CustomAudioLite:PlaySoundEffect(db.events.interrupt, "interrupt")
        return
    end

    -- Кастомные спеллы
    if db.customSpells.enabled then
        for _, spellConfig in ipairs(db.customSpells.spells) do
            if spellConfig.enabled
               and spellConfig.spellId
               and tonumber(spellConfig.spellId) == spellID then
                CustomAudioLite:PlaySoundEffect(
                    spellConfig, "customSpell_" .. spellID)
                break
            end
        end
    end
end


-- Обновление зарядов
function CustomAudioLite:SPELL_UPDATE_CHARGES()
    CheckCombatRez()
end


-- Смерть
function CustomAudioLite:OnPlayerDead()
    if db.events.death.enabled then
        CustomAudioLite:PlaySoundEffect(db.events.death, "death")
    end
end


-- Вход в данж/рейд
function CustomAudioLite:ZONE_CHANGED_NEW_AREA()
    local _, instanceType = GetInstanceInfo()

    if db.events.raidEnterDungeon.enabled and instanceType == "party" then
        CustomAudioLite:PlaySoundEffect(
            db.events.raidEnterDungeon, "raidEnterDungeon")
        return
    end

    if db.events.raidEnterRaid.enabled
       and (instanceType == "raid" or instanceType == "flex") then
        CustomAudioLite:PlaySoundEffect(
            db.events.raidEnterRaid, "raidEnterRaid")
        return
    end
end


-- Инициализация

function CustomAudioLite:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New(
        "CustomAudioLiteDB", CustomAudioLiteDefaults, true)
    db = self.db.profile

    -- Миграция поля random
    if db.customSpells.spells then
        for _, spell in ipairs(db.customSpells.spells) do
            if not spell.random then
                spell.random = {
                    path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max  = 3,
                    isRandom = { enabled = true, currentFile = 1 },
                }
            end
        end
    end

    if db.customAuras.auras then
        for _, aura in ipairs(db.customAuras.auras) do
            if not aura.random then
                aura.random = {
                    path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max  = 3,
                    isRandom = { enabled = true, currentFile = 1 },
                }
            end
        end
    end

    -- Миграция soundReplacements 
    if not db.soundReplacements then
        db.soundReplacements = { enabled = false, replacements = {} }
    end

    -- --------------------------------------------------------
    -- Замена звуков: мьют FileData + хук PlaySound
    -- --------------------------------------------------------
    self:ApplySoundMutes()
    self:InstallPlaySoundHook()

    -- --------------------------------------------------------
    -- Регистрация игровых событий
    -- --------------------------------------------------------
    self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:RegisterEvent("PLAYER_DEAD", "OnPlayerDead")
    self:RegisterEvent("CHAT_MSG_LOOT")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("SPELL_UPDATE_CHARGES")

    -- Тикеры
    C_Timer.NewTicker(0.5, CheckBloodlust)
    C_Timer.NewTicker(0.5, CheckCustomAuras)
end
