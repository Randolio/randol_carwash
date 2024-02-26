local washingVehicle = false

local function washCar()
    local success = lib.callback.await("randol_carwash:server:canAfford", false)
    if not success then return end
    washingVehicle = true
    QBCore.Functions.Progressbar("wash_car", "Washing vehicle..", Config.WashTime, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        SetVehicleDirtLevel(cache.vehicle, 0.0)
        WashDecalsFromVehicle(cache.vehicle, 1.0)
        washingVehicle = false
        QBCore.Functions.Notify('Your car is now clean.', 'success')
    end)
end

local function onEnter(self)
    if IsPedInAnyVehicle(cache.ped, false) then
        lib.showTextUI('[E] - Wash Car', { icon = 'fa-solid fa-car', position = 'left-center', })
    end
end
 
local function onExit(self)
    lib.hideTextUI()
end

local function inside(self)
    if IsControlJustReleased(0, 38) and not washingVehicle and cache.seat == -1 then
        washCar()
    end
end

for i = 1, #Config.CarWashLocs do
    local zone = lib.zones.poly({
        points = Config.CarWashLocs[i].points,
        thickness = 9.0,
        debug = false,
        onEnter = onEnter,
        inside = inside,
        onExit = onExit,
    })
    local washBlip = AddBlipForCoord(Config.CarWashLocs[i].Blip.x, Config.CarWashLocs[i].Blip.y, Config.CarWashLocs[i].Blip.z)
    SetBlipSprite(washBlip, 100)
    SetBlipDisplay(washBlip, 4)
    SetBlipScale(washBlip, 0.75)
    SetBlipAsShortRange(washBlip, true)
    SetBlipColour(washBlip, 37)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.CarWashLocs[i].Label)
    EndTextCommandSetBlipName(washBlip)
end
