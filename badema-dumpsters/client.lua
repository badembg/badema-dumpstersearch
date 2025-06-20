local QBCore = exports['qb-core']:GetCoreObject()
local searchedDumpsters = {}
local isSearching = false

local function ShowNotification(text, type)
    if Config.Inventory == 'ox_inventory' then
        lib.notify({
            title = 'Dumpster',
            description = text,
            type = type or 'inform'
        })
    else
        QBCore.Functions.Notify(text, type or 'primary')
    end
end

local function ProgressBar(duration, label, callback)
    if Config.Inventory == 'ox_inventory' then
        if lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'amb@prop_human_bum_bin@idle_b',
                clip = 'idle_d'
            }
        }) then
            callback(true)
        else
            callback(false)
        end
    else
        QBCore.Functions.Progressbar('search_dumpster', label, duration, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'amb@prop_human_bum_bin@idle_b',
            anim = 'idle_d',
            flags = 49,
        }, {}, {}, function()
            callback(true)
        end, function()
            callback(false)
        end)
    end
end

local function GetDumpsterId(entity)
    local coords = GetEntityCoords(entity)
    return string.format("%.2f_%.2f_%.2f", coords.x, coords.y, coords.z)
end

local function CanSearchDumpster(entity)
    local dumpsterId = GetDumpsterId(entity)
    local currentTime = GetGameTimer()
    
    if searchedDumpsters[dumpsterId] and (currentTime - searchedDumpsters[dumpsterId]) < Config.Cooldown then
        return false
    end
    
    return true
end

local function SearchDumpster(entity)
    if isSearching then return end
    
    if not CanSearchDumpster(entity) then
        ShowNotification(Config.Locale.already_searched, 'error')
        return
    end
    
    isSearching = true
    local dumpsterId = GetDumpsterId(entity)
    
    TriggerServerEvent('dumpster:server:startSearch')
    
    RequestAnimDict('amb@prop_human_bum_bin@idle_b')
    while not HasAnimDictLoaded('amb@prop_human_bum_bin@idle_b') do
        Wait(100)
    end
    
    ProgressBar(Config.ProgressBar, Config.Locale.searching, function(success)
        ClearPedTasks(PlayerPedId())
        isSearching = false
        
        if success then
            searchedDumpsters[dumpsterId] = GetGameTimer()
            TriggerServerEvent('dumpster:server:searchDumpster')
        else
            ShowNotification(Config.Locale.cancelled, 'error')
        end
    end)
end

local function SetupTargeting()
    if Config.Target == 'ox_target' then
        exports.ox_target:addModel(Config.DumpsterProps, {
            {
                name = 'search_dumpster',
                icon = 'fas fa-search',
                label = Config.Locale.search_dumpster,
                onSelect = function(data)
                    SearchDumpster(data.entity)
                end,
                distance = 2.0
            }
        })
    else
        exports['qb-target']:AddTargetModel(Config.DumpsterProps, {
            options = {
                {
                    type = 'client',
                    event = 'dumpster:client:searchDumpster',
                    icon = 'fas fa-search',
                    label = Config.Locale.search_dumpster,
                }
            },
            distance = 2.0
        })
    end
end

RegisterNetEvent('dumpster:client:searchDumpster', function(data)
    SearchDumpster(data.entity)
end)

RegisterNetEvent('dumpster:client:showFoundItems', function(items)
    if #items == 0 then
        ShowNotification(Config.Locale.found_nothing, 'error')
        return
    end
    
    for _, itemData in pairs(items) do
        local message = string.format(Config.Locale.found_items, itemData.label, itemData.amount)
        ShowNotification(message, 'success')
        
        if Config.Inventory == 'ox_inventory' then
            exports.ox_inventory:displayMetadata({
                {label = 'Found', value = itemData.label .. ' x' .. itemData.amount}
            })
        else
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemData.item], 'add', itemData.amount)
        end
    end
end)

CreateThread(function()
    SetupTargeting()
end)