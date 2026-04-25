local QBCore = exports['qb-core']:GetCoreObject()
local display = false
local aracmenu = false

function GetVehicleClassFromConfig(modelName)
    if not Config.VehicleClass then return nil end
    local lowerModel = string.lower(modelName)
    for className, vehicles in pairs(Config.VehicleClass) do
        for _, veh in ipairs(vehicles) do
            if string.lower(veh.model) == lowerModel then
                return className
            end
        end
    end
    return nil
end

local wasOpen = false
local isHiddenByUser = false

function AracMenuBaslat()
    if aracmenu then return end
    aracmenu = true

    QBCore.Functions.TriggerCallback('yoo:permkontrolu', function(hasPermission)
        if hasPermission then
            QBCore.Functions.Notify('Araç model gösterme aktif oldu', 'success')
            CreateThread(function()
                while aracmenu do
                    Wait(5)

                    local ped = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(ped, false)

                    if vehicle ~= 0 then
                        local isDriverOrFrontPassenger = (GetPedInVehicleSeat(vehicle, -1) == ped or GetPedInVehicleSeat(vehicle, 0) == ped)

                        if isDriverOrFrontPassenger then
                            local vehClass = GetVehicleClass(vehicle)

                            if vehClass == 18 then -- pd vehicles class (18=emergency)
                                if not display and wasOpen and not isHiddenByUser then
                                    SendNUIMessage({
                                        type = 'ui',
                                        display = true
                                    })
                                    display = true
                                end

                                if IsControlJustPressed(0, Config.ScanKey) then
                                    local closestVehicle = GetClosestVehicle(GetEntityCoords(ped), Config.ScanDistance, 0, 70)

                                    if closestVehicle and closestVehicle ~= 0 then
                                        local model = GetEntityModel(closestVehicle)
                                        local modelName = GetDisplayNameFromVehicleModel(model)
                                        local plate = GetVehicleNumberPlateText(closestVehicle)
                                        local vehclassConfig = GetVehicleClassFromConfig(modelName)

                                        SendNUIMessage({
                                            type = 'ui',
                                            display = true,
                                            model = modelName,
                                            plate = plate,
                                            vehclass = vehclassConfig or '?'
                                        })

                                        display = true
                                        wasOpen = true
                                        isHiddenByUser = false
                                    end
                                end

                                -- Hide or show the NUI with the backspace key
                                if wasOpen then
                                    if IsControlJustPressed(0, 177) then
                                        if display then
                                            isHiddenByUser = true
                                            SendNUIMessage({
                                                type = 'ui',
                                                display = false
                                            })
                                            display = false
                                        else
                                            isHiddenByUser = false
                                            SendNUIMessage({
                                                type = 'ui',
                                                display = true
                                            })
                                            display = true
                                        end
                                    end
                                end
                            else
                                if display then
                                    SendNUIMessage({
                                        type = 'ui',
                                        display = false
                                    })
                                    display = false
                                end
                            end
                        else
                            if display then
                                SendNUIMessage({
                                    type = 'ui',
                                    display = false
                                })
                                display = false
                            end
                        end
                    else
                        --  Hide the NUI if the player is not in any vehicle
                        if display then
                            SendNUIMessage({
                                type = 'ui',
                                display = false
                            })
                            display = false
                        end
                    end
                end
            end)
        else
            QBCore.Functions.Notify('Bu sistemi kullanmak için yetkiniz yok.', 'error')
            aracmenu = false
        end
    end)
end

function AracMenuDurdur()
    if not aracmenu then return end
    aracmenu = false
    QBCore.Functions.Notify('Araç model gösterme kapatıldı', 'error')
    SendNUIMessage({
        type = 'ui',
        display = false
    })
    display = false
    wasOpen = false
    isHiddenByUser = false
end

RegisterCommand("+platemenu", function()
    if not aracmenu then
        AracMenuBaslat()
    else
        AracMenuDurdur()
    end
end, false)

RegisterCommand("platesettings", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData or not PlayerData.job then return end

    local hasJob = false
    if Config.Jobs then
        for _, job in ipairs(Config.Jobs) do
            if PlayerData.job.name == job then
                hasJob = true
                break
            end
        end
    end

    if hasJob then
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'plakaedit'
        })
    else
        QBCore.Functions.Notify('Bu komutu kullanmak için yetkiniz yok.', 'error')
    end
end, false)

RegisterNUICallback("closeSettings", function(data, cb)
    SetNuiFocus(false, false)
    if cb then cb("ok") end
end)

-- EVENT IF YOU WANT TO TOGGLE WITH A SERVER EVENT INSTEAD OF COMMAND
-- RegisterNetEvent('yoo:toggle')
-- AddEventHandler('yoo:toggle', function()
--     if not aracmenu then
--         AracMenuBaslat()
--     else
--         AracMenuDurdur()
--     end
-- end)
