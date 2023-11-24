lib.callback.register('randol_carwash:server:canAfford', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money.bank
    local cost = Config.Cost
    if bankBalance >= cost then
        Player.Functions.RemoveMoney('bank', cost)
        QBCore.Functions.Notify(src, 'You paid $'..cost..' to get a car wash.', 'success')
        return true
    else
        QBCore.Functions.Notify(src, 'You need $'..cost..' in your bank to get a car wash.', 'error')
        return false
    end
end)
