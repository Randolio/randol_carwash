local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("randol_carwash:server:removeCost", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cost = Config.Cost
    Player.Functions.RemoveMoney('bank', cost)
    QBCore.Functions.Notify(src, 'You paid $'..cost..' to get a car wash.', 'success')
    TriggerClientEvent('randol_carwash:client:startWash', src)
end)

QBCore.Functions.CreateCallback('randol_carwash:server:canAfford', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money.bank
    local cost = Config.Cost
    if bankBalance >= cost then
        cb(true)
    else
        QBCore.Functions.Notify(src, 'You need $'..cost..' in your bank to get a car wash.', 'error')
        cb(false)
    end
end)