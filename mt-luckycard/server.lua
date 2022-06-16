local QBCore = exports['qb-core']:GetCoreObject()

local function GerarPlaca()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GerarPlaca()
    else
        return plate:upper()
    end
end

local function DarVeiculo(pData)
    local cid = pData.citizenid
    local plate = GerarPlaca()
    local vehicle = Config.Rewards['Vehicle']
    
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        pData.license,
        cid,
        vehicle,
        GetHashKey(vehicle),
        '{}',
        plate,
        0
    })
end

RegisterNetEvent('mt-luckycard:server:ComprarCartao', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = Config.CardPrice
    local item = 'cartao_sorte'

    Player.Functions.RemoveMoney('bank', price)
    Player.Functions.AddItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
end)

RegisterNetEvent('mt-luckycard:server:DarRecompesa', function(pData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = 'cartao_sorte'
    local quantidade = 1
    local prob = math.random(1, 100)
    local preco = Config.Rewards['Money']

    if prob <= 5 then
        DarVeiculo(pData)
        TriggerEvent('mt-luckycard:server:DarVeiculo', pData)
        Player.Functions.RemoveItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove")
        TriggerClientEvent('QBCore:Notify', src, 'You earn a new vehicle!...', 'error', '5000')
    elseif prob > 5 and prob <= 25 then
        Player.Functions.AddMoney('bank', preco, 'moeda')
        Player.Functions.RemoveItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove")
        TriggerClientEvent('QBCore:Notify', src, 'You earn some money...', 'error', '5000')
    elseif prob > 25 and prob <= 75 then
        TriggerClientEvent('QBCore:Notify', src, 'You earn nothing...', 'error', '5000')
        Player.Functions.RemoveItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove")
    elseif prob > 75 and prob <= 100 then
        Player.Functions.AddItem(Config.Rewards['Item'], 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.Rewards['Item']], "add")
        Player.Functions.RemoveItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove")
        TriggerClientEvent('QBCore:Notify', src, 'You earn something...', 'error', '5000')
    end
end)
