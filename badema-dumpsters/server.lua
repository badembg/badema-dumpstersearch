local QBCore = exports['qb-core']:GetCoreObject()

local function GetRandomItems()
    local foundItems = {}
    
    if Config.AdditionalItems then
        local itemsGiven = 0
        local shuffledItems = {}
        
        for i, itemConfig in pairs(Config.Items) do
            table.insert(shuffledItems, itemConfig)
        end
        
        for i = #shuffledItems, 2, -1 do
            local j = math.random(i)
            shuffledItems[i], shuffledItems[j] = shuffledItems[j], shuffledItems[i]
        end
        
        for _, itemConfig in pairs(shuffledItems) do
            if itemsGiven >= Config.MaxItemsPerSearch then
                break
            end
            
            local chance = itemConfig.chance
            if itemsGiven > 0 then
                chance = math.floor(chance * (Config.MultipleItemsChance / 100))
            end
            
            if math.random(100) <= chance then
                local amount = math.random(itemConfig.minItems, itemConfig.maxItems)
                table.insert(foundItems, {
                    item = itemConfig.item,
                    amount = amount
                })
                itemsGiven = itemsGiven + 1
            end
        end
    else
        local availableItems = {}
        for _, itemConfig in pairs(Config.Items) do
            if math.random(100) <= itemConfig.chance then
                table.insert(availableItems, itemConfig)
            end
        end
        
        if #availableItems > 0 then
            local selectedItem = availableItems[math.random(#availableItems)]
            local amount = math.random(selectedItem.minItems, selectedItem.maxItems)
            table.insert(foundItems, {
                item = selectedItem.item,
                amount = amount
            })
        end
    end
    
    return foundItems
end

local function AddItemToPlayer(src, item, amount)
    if Config.Inventory == 'ox_inventory' then
        return exports.ox_inventory:AddItem(src, item, amount)
    else
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.AddItem(item, amount)
        end
    end
    return false
end

local function GetItemLabel(item)
    if Config.Inventory == 'ox_inventory' then
        local itemData = exports.ox_inventory:Items(item)
        return itemData and itemData.label or item
    else
        return QBCore.Shared.Items[item] and QBCore.Shared.Items[item].label or item
    end
end

RegisterNetEvent('dumpster:server:searchDumpster', function()
    local src = source
    local foundItems = GetRandomItems()
    local itemsToShow = {}
    
    for _, itemData in pairs(foundItems) do
        if AddItemToPlayer(src, itemData.item, itemData.amount) then
            table.insert(itemsToShow, {
                item = itemData.item,
                amount = itemData.amount,
                label = GetItemLabel(itemData.item)
            })
        end
    end
    
    TriggerClientEvent('dumpster:client:showFoundItems', src, itemsToShow)
end)