lib.callback.register('randol_carwash:server:canAfford', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money.bank
    local cost = Config.Cost
    if bankBalance >= cost then
        Player.Functions.RemoveMoney('bank', cost)
        QBCore.Functions.Notify(src, ('You paid $%s to get a car wash.'):format(cost), 'success')
        return true
    end
    QBCore.Functions.Notify(src, ('You need $%s in your bank to get a car wash.'):format(cost), 'error')
    return false
end)
