local QBCore = exports['qb-core']:GetCoreObject()
local display = false
local aracmenu = false

function aracmenuacamk()
    aracmenu = not aracmenu

    if aracmenu then
        QBCore.Functions.TriggerCallback('yoo:permkontrolu', function(hasPermission)
            if hasPermission then
                QBCore.Functions.Notify('Araç model gösterme aktif oldu', 'success') 
                CreateThread(function()
                    while aracmenu do
                        Wait(5)

                        local ped = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(ped, false)

                        if vehicle ~= 0 then
                            if IsControlJustPressed(0, 38) then -- E tuşu
                                local vehClass = GetVehicleClass(vehicle)

                                if vehClass == 18 then -- polis araçlarının kategori kontrolü
                                    local closestVehicle = GetClosestVehicle(GetEntityCoords(ped), 30.0, 0, 70)

                                    if closestVehicle and closestVehicle ~= 0 then
                                        local model = GetEntityModel(closestVehicle)
                                        local modelName = GetDisplayNameFromVehicleModel(model)
                                        local plate = GetVehicleNumberPlateText(closestVehicle)

                                        SendNUIMessage({
                                            type = 'ui',
                                            display = true,
                                            model = modelName,
                                            plate = plate
                                        })

                                        display = true
                                    end
                                end
                            end
                        else
                            --  Araçtan indiyse NUI kapat
                            SendNUIMessage({
                                type = 'ui',
                                display = false
                            })
                            display = false
                            aracmenu = false -- Döngüyü durdurma
                        end

                        -- ESC veya Backspace ile kapatma
                        if display then
                            if IsControlJustPressed(0, 322) or IsControlJustPressed(0, 177) then 
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
    else
        QBCore.Functions.Notify('Araç model gösterme kapatıldı', 'error')
        SendNUIMessage({
            type = 'ui',
            display = false
        })
        display = false
    end
end

RegisterCommand("+aracmenu", function()
    aracmenuacamk()
end, false)
