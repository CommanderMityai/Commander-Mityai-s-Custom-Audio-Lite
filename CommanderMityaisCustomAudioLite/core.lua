local ADDON_NAME, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local AceAddon = LibStub("AceAddon-3.0")
CustomAudioLite = AceAddon:NewAddon("CustomAudioLite", "AceEvent-3.0")
local db

-- Спеллы бладласта
local BLOODLUST_SPELLS = {
    [2825] = true, [32182] = true, [80353] = true, [264667] = true,
    [90355] = true, [160452] = true, [388976] = true, [390386] = true,
    [381301] = true, [65980] = true, [71975] = true, [463981] = true,
    [192423] = true, [57724] = true, [272678] = true, [357650] = true,
    [466904] = true, [1243972] = true,
}

-- Спеллы прерывания
local INTERRUPT_SPELLS = {
    [2139] = true, [57994] = true, [147362] = true, [116705] = true,
    [6552] = true, [183770] = true, [47528] = true, [47476] = true,
    [221562] = true, [19647] = true, [89766] = true, [1766] = true,
    [15487] = true, [96231] = true, [183752] = true, [106839] = true,
    [78675] = true, [351338] = true,
}

-- Спеллы боевого воскрешения
local COMBAT_REZ_SPELLS = {
    [20484] = true,   -- Rebirth (Druid)
    [61999] = true,   -- Raise Ally (Death Knight)
    [95750] = true,   -- Soulstone Resurrection (Warlock)
    [391054] = true,  -- Intercession (Paladin)
    [345130] = true,  -- Disposable Spectrophasic Reanimator (Engineer)
    [385403] = true,  -- Tinker: Arclight Vital Correctors (Engineer)
    [384893] = true,  -- Convincingly Realistic Jumper Cables (Engineer)
}

-- Кэш для предотвращения дублирования звука
local soundCooldown = {}
local hasBloodlust = false
local hasCustomAuras = {}
local lastRezCharges = {} 

function CustomAudioLite:PlaySoundEffect(dbEntry, eventKey)
    if not dbEntry or not dbEntry.enabled then return end
    if soundCooldown[eventKey] and GetTime() - soundCooldown[eventKey] < 0.3 then return end
    
    local path, channel = "", dbEntry.channel
    local source = dbEntry.source or "custom"

    if source == "shared" then
        if dbEntry.shared.value and dbEntry.shared.value ~= "None" then
            path = LSM:Fetch("sound", dbEntry.shared.value) or ""
        end
    elseif source == "custom" then
        if dbEntry.custom.path and dbEntry.custom.path ~= "" then
            path = dbEntry.custom.path:gsub("%s+", ""):gsub("\\\\", "\\"):gsub("//", "/"):gsub("[/\\]+$", "")
            path = path:gsub("%.mp3$", ""):gsub("%.ogg$", "") .. ".mp3"
        end
    elseif source == "random" then
        if dbEntry.random.path and dbEntry.random.path ~= "" then
            local basePath = dbEntry.random.path:gsub("%s+", ""):gsub("\\\\", "\\"):gsub("//", "/")
            if not basePath:match("[/\\]$") then
                basePath = basePath .. "/"
            end
            local maxFiles = dbEntry.random.max or 1
            if maxFiles > 1 then
                local randomNum = math.random(1, maxFiles)
                path = basePath .. randomNum .. ".mp3"
            else
                path = basePath .. ".mp3"
            end
        end
    end

    if path ~= "" then
        if C_Sound and C_Sound.PlaySoundFile then
            local soundChannel = Enum and Enum.SoundKitChannel and Enum.SoundKitChannel[channel] or Enum.SoundKitChannel.Master
            C_Sound.PlaySoundFile(path, soundChannel)
        else
            PlaySoundFile(path, channel)
        end
        soundCooldown[eventKey] = GetTime()
        --print("✅ Звук проигран: " .. path)
        --else
        --print("❌ Путь к звуку пустой! source=" .. source .. ", path=" .. (dbEntry.random and dbEntry.random.path or dbEntry.custom.path or "nil"))
    end
end

-- ЛУТ
function CustomAudioLite:CHAT_MSG_LOOT(event, text, lootReceiverName, ...)
    local myName = UnitName("player")
    if Ambiguate(lootReceiverName, "none") ~= myName then return end
    local itemLink = text:match("|Hitem:([^|]+)|h")
    if not itemLink then return end
    local itemID = itemLink:match("^(%d+)")
    if not itemID then return end

    local _, _, rarity = GetItemInfo(tonumber(itemID))

    if not rarity then
        local item = Item:CreateFromItemID(tonumber(itemID))
        item:ContinueOnItemLoad(function()
            local _, _, rarity = GetItemInfo(tonumber(itemID))
            if rarity == 3 and db.events.rareLootRare.enabled then
                CustomAudioLite:PlaySoundEffect(db.events.rareLootRare, "rareLootRare")
            elseif rarity >= 4 and db.events.rareLootEpic.enabled then
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

-- Бладласт
local function CheckBloodlust()
    if not db.events.bloodlust.enabled then return end
    local found = false
    for spellId in pairs(BLOODLUST_SPELLS) do
        local aura = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID and C_UnitAuras.GetPlayerAuraBySpellID(spellId)
        if aura then
            found = true
            break
        end
    end
    if found and not hasBloodlust then
        CustomAudioLite:PlaySoundEffect(db.events.bloodlust, "bloodlust")
        hasBloodlust = true
    elseif not found and hasBloodlust then
        hasBloodlust = false
    end
end

-- Кастомные ауры
local function CheckCustomAuras()
    if not db.customAuras.enabled then return end
    local auras = db.customAuras.auras
    for i, auraConfig in ipairs(auras) do
        if auraConfig.enabled and auraConfig.auraId then
            local aura = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID and C_UnitAuras.GetPlayerAuraBySpellID(auraConfig.auraId)
            local auraKey = "aura_" .. i
            if aura and not hasCustomAuras[auraKey] then
                CustomAudioLite:PlaySoundEffect(auraConfig, "customAura_" .. auraConfig.auraId)
                hasCustomAuras[auraKey] = true
            elseif not aura and hasCustomAuras[auraKey] then
                hasCustomAuras[auraKey] = nil
            end
        end
    end
end

-- Проверка комбат-ресов через событие SPELL_UPDATE_CHARGES 
local function CheckCombatRez()
    if not db.events.combatRez.enabled then return end
    
    for spellId in pairs(COMBAT_REZ_SPELLS) do
        local chargeInfo = C_Spell and C_Spell.GetSpellCharges and C_Spell.GetSpellCharges(spellId)
        if chargeInfo and chargeInfo.currentCharges then
            local currentCharges = chargeInfo.currentCharges
            local lastCharges = lastRezCharges[spellId]
            
            -- Если зарядов стало меньше — кто-то использовал рес
            if lastCharges and currentCharges < lastCharges then
                CustomAudioLite:PlaySoundEffect(db.events.combatRez, "combatRez_" .. spellId)
            end
            
            lastRezCharges[spellId] = currentCharges
        end
    end
end

-- Прерывание через каст спелла прерывания
function CustomAudioLite:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellID)
    if unit ~= "player" then return end
    if INTERRUPT_SPELLS[spellID] and db.events.interrupt.enabled then
        CustomAudioLite:PlaySoundEffect(db.events.interrupt, "interrupt")
        return
    end
    if db.customSpells.enabled then
        for _, spellConfig in ipairs(db.customSpells.spells) do
            if spellConfig.enabled and spellConfig.spellId and tonumber(spellConfig.spellId) == spellID then
                CustomAudioLite:PlaySoundEffect(spellConfig, "customSpell_" .. spellID)
                break
            end
        end
    end
end

-- Событие обновления зарядов 
function CustomAudioLite:SPELL_UPDATE_CHARGES()
    CheckCombatRez()
end

-- Смерть игрока
function CustomAudioLite:OnPlayerDead()
    if db.events.death.enabled then
        CustomAudioLite:PlaySoundEffect(db.events.death, "death")
    end
end

-- Вход в данж/рейд
function CustomAudioLite:ZONE_CHANGED_NEW_AREA()
    local _, instanceType = GetInstanceInfo()
    if db.events.raidEnterDungeon.enabled and instanceType == "party" then
        CustomAudioLite:PlaySoundEffect(db.events.raidEnterDungeon, "raidEnterDungeon")
        return
    end
    if db.events.raidEnterRaid.enabled and (instanceType == "raid" or instanceType == "flex") then
        CustomAudioLite:PlaySoundEffect(db.events.raidEnterRaid, "raidEnterRaid")
        return
    end
end

-- Инициализация аддона
function CustomAudioLite:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("CustomAudioLiteDB", CustomAudioLiteDefaults, true)
    db = self.db.profile
    
    -- Миграция: Добавляем поле random в старые спеллы
    if db.customSpells.spells then
        for _, spell in ipairs(db.customSpells.spells) do
            if not spell.random then
                spell.random = {
                    path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max = 3,
                    isRandom = { enabled = true, currentFile = 1 }
                }
            end
        end
    end

    -- Миграция: Добавляем поле random в старые ауры
    if db.customAuras.auras then
        for _, aura in ipairs(db.customAuras.auras) do
            if not aura.random then
                aura.random = {
                    path = "Interface\\AddOns\\CommanderMityaisCustomAudioLite\\sounds\\random",
                    max = 3,
                    isRandom = { enabled = true, currentFile = 1 }
                }
            end
        end
    end

    -- Регистрация событий
    self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:RegisterEvent("PLAYER_DEAD", "OnPlayerDead")
    self:RegisterEvent("CHAT_MSG_LOOT")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("SPELL_UPDATE_CHARGES")

    -- Таймеры
    C_Timer.NewTicker(0.5, CheckBloodlust)
    C_Timer.NewTicker(0.5, CheckCustomAuras)

    -- Регистрация опций
    LibStub("AceConfig-3.0"):RegisterOptionsTable("CustomAudioLite", CustomAudioLiteOptions)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CustomAudioLite", "Commander Mityai's Custom Audio Lite")

    -- Слэш-команда
    SLASH_CUSTOMAUDIOLITE1 = "/сal"
    SlashCmdList["CUSTOMAUDIOLITE"] = function()
        LibStub("AceConfigDialog-3.0"):Open("CustomAudioLite")
    end
end