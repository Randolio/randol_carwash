local washingVehicle = false

local function washCar()
    if washingVehicle then return end
    washingVehicle = true
    local result = lib.callback.await("randol_carwash:server:canAfford", false)
    if result then
        local vehicle = GetVehiclePedIsIn(cache.ped)
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
    else
        washingVehicle = false
    end
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
    if IsControlJustReleased(0, 38) then
        local inVehicle = IsPedInAnyVehicle(cache.ped, false)
        local currentVeh = GetVehiclePedIsIn(cache.ped, false)
        local driver = GetPedInVehicleSeat(currentVeh, -1)
        if inVehicle and not washingVehicle then 
            if driver == cache.ped then
                washCar()
            end
        end
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
