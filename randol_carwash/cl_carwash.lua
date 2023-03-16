local QBCore = exports['qb-core']:GetCoreObject()
local washingVehicle = false
local washRadial = nil

local function setRadial()
    if not washRadial then
        washRadial = exports['qb-radialmenu']:AddOption({
            id = 'car_wash',
            title = 'Wash Vehicle',
            icon = 'car',
            type = 'client',
            event = 'randol_carwash:client:startWash',
            shouldClose = true
        })
    end
end

CreateThread(function()
    local carwashZones = {}

    for k, v in pairs(Config.CarWashLocs) do
        carwashZones[#carwashZones + 1] = PolyZone:Create(v.PolyZone, {
            name = k,
            minZ = v.minZ,
            maxZ = v.maxZ,
            debugPoly = false
        })
    end

    local washCombo = ComboZone:Create(carwashZones, {
        name = "washCombo",
        debugPoly = false
    })
    
    washCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
            local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
            local driver = GetPedInVehicleSeat(currentVeh, -1)
            if inVehicle and not washRadial then 
                if driver == PlayerPedId() then
                    exports['qb-core']:DrawText('Car Wash $'..Config.Cost, 'left')
                    setRadial()
                end
            end
        else
            if washRadial then
                exports['qb-radialmenu']:RemoveOption(washRadial)
                washRadial = nil
                exports['qb-core']:HideText()
            end
        end
    end)
end)

RegisterNetEvent('randol_carwash:client:startWash', function()
    if washingVehicle then return end
    QBCore.Functions.TriggerCallback("randol_carwash:server:canAfford",function(result)
        if result then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            washingVehicle = true
            QBCore.Functions.Progressbar("wash_car", "Washing vehicle..", Config.WashTime, false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                SetVehicleDirtLevel(vehicle, 0.0)
                WashDecalsFromVehicle(vehicle, 1.0)
                washingVehicle = false
                QBCore.Functions.Notify('Your car is now clean.', 'success')
            end)
        end
    end)
end)

CreateThread(function()
    for location in pairs(Config.CarWashLocs) do
        local loc = Config.CarWashLocs[location].Blip
        local washBlip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(washBlip, 100)
        SetBlipDisplay(washBlip, 4)
        SetBlipScale(washBlip, 0.75)
        SetBlipAsShortRange(washBlip, true)
        SetBlipColour(washBlip, 37)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.CarWashLocs[location].Label)
        EndTextCommandSetBlipName(washBlip)
    end
end)
