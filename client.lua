local starterPackLocation = vector3(123.45, 67.89, 50.0) -- Define the location where the starter pack is available

-- Function to create the starter pack entity
local function CreateStarterPackPed()
    local pedModel = "a_m_y_business_03" -- Example PED model
    local pedHeading = 180.0 -- Example PED heading

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(0)
    end

    local ped = CreatePed(4, pedModel, starterPackLocation, pedHeading, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    return ped
end

RegisterNetEvent('r-z_starterpack:ShowStarterPack')
AddEventHandler('r-z_starterpack:ShowStarterPack', function()
    -- Perform actions to show the starter pack to the player
end)


--[[ if you don't use QTARGET

-- Function to display the starter pack text above the PED
local function DrawStarterPackText(ped)
    local pedCoords = GetEntityCoords(ped)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(pedCoords - playerCoords)

    if distance < 10.0 then
        local screenCoords = GetScreenCoordFromWorldCoord(pedCoords.x, pedCoords.y, pedCoords.z + 1.0)

        if screenCoords.visible then
            ESX.Game.Utils.DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, "Press [ALT] to pick up the starter kit", 0.4)
        end
    end
end

]]

exports['qtarget']:AddBoxZone("starterpack", vector3(123.45, 67.89, 50.0), 0.8, 6.6, {
    name="StarterPack",
    heading=270,
    debugPoly=false,
    minZ=8.36,
    maxZ=12.36,
    }, {
        options = {
            {
                event = "r-z_starterpack:Collect",
                icon = "fas fa-bars",
                label = "Take starter pack",
            },
        },
        distance = 3.5
})

-- Event triggered when the player enters the specified location
Citizen.CreateThread(function()
    local ped = nil

    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Check if the player is at the starter pack location
        if Vdist2(playerCoords, starterPackLocation) < 10.0 then
            -- Create the starter pack PED if it doesn't exist
            if not DoesEntityExist(ped) then
                ped = CreateStarterPackPed()
            end

            -- Display the starter pack text above the PED
            DrawStarterPackText(ped)

            -- Check if the player presses the ALT key to collect the starter pack
            if IsControlJustReleased(0, 19) then
                -- Trigger the event to collect the starter pack
                TriggerServerEvent('r-z_starterpack:Collect')
                Citizen.Wait(1000) -- Wait for the server event to be processed
                DeletePed(ped) -- Delete the starter pack PED
                ped = nil
            end
        else
            -- Delete the starter pack PED if the player is not at the location
            if DoesEntityExist(ped) then
                DeletePed(ped)
                ped = nil
            end
        end
    end
end)
