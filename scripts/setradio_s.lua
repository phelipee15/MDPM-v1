local radioStreams = 0
vehicles = {}

server.functions["onResourceStart"] = function()
    for i, veh in ipairs(getElementsByType("vehicle")) do
        vehicles[veh] = {}
        vehicles[veh].radio = false
        vehicles[veh].radioStation = false
        vehicles[veh].volume = 1.0
    end

server.functions["onPlayerLogin"] = function()	
    for i, veiculo in ipairs(getElementsByType("vehicle")) do
        if vehicles[veiculo] then
            if vehicles[veiculo].radio then
                triggerClientEvent(source, "onServerToggleRadio", root, true, vehicles[veiculo].radioStation, veiculo, vehicles[veiculo].volume)
                server.functions["setSoundDistance"](source, veiculo, vehicles[veiculo].distance)
            end
        end
    end
end
addEventHandler("onPlayerLogin", root, server.functions["onPlayerLogin"])

server.functions["onElementDestroy"] = function()
    if vehicles[source] then
        if vehicles[source].radio then
            triggerClientEvent("onServerToggleRadio", root, false, nil, source)
            vehicles[source].radio = false
            destroyElement(vehicles[source].radioMarker)
            if isTimer(vehicles[source].idleTimer) then killTimer(vehicles[source].idleTimer) end
            if radioStreams ~= 0 then
                radioStreams = radioStreams - 1
            end
        end
    end
end
addEventHandler("onVehicleExplode", root, server.functions["onElementDestroy"])
addEventHandler("onElementDestroy", root, server.functions["onElementDestroy"])

server.functions["radio:ligar"] = function(jogador, veiculo)
    if (client and client ~= jogador) then return end
    if isElement(jogador) and isElement(veiculo) then
        local occupants = getVehicleOccupants(veiculo)
        local seats = getVehicleMaxPassengers(veiculo)
        local posicao = getPedOccupiedVehicleSeat(jogador)
        if (posicao ~= 0 and posicao ~= 1) and (getPedOccupiedVehicle(jogador) == veiculo) then
            config["notify"](jogador, translate[lang]["err_radio_on"], "warning", "server")
            return;
        end
        if not vehicles[veiculo] then
            vehicles[veiculo] = {}
            vehicles[veiculo].radio = false
            vehicles[veiculo].radioStation = false
            vehicles[veiculo].volume = 1.0
        end
        if not vehicles[veiculo].radio then
            local idleTime = 60e3
            local x, y, z = getElementPosition(veiculo)
            vehicles[veiculo].radio = true
            vehicles[veiculo].lastTick = getTickCount()
            vehicles[veiculo].turnedOnBy = getPlayerName(jogador)
            vehicles[veiculo].radioMarker = createMarker(x, y, z, "corona", 0.05, 255, 0, 0, 0)
            vehicles[veiculo].distance = distance
            attachElements(vehicles[veiculo].radioMarker, veiculo)
            vehicles[veiculo].idleTimer = setTimer(server.functions["radioIdleTimer"], idleTime, 0, veiculo)
        end
        triggerClientEvent("onServerToggleRadio", root, true, vehicles[veiculo].radioStation, veiculo, vehicles[veiculo].volume, vehicles[veiculo].infos)
        config["notify"](jogador, translate[lang]["radio_on"], "info", "server")
    end
end
server.functions["radio:desligar"] = function(jogador, veiculo)
    if (client and client ~= jogador) then return end
    if isElement(jogador) and isElement(veiculo) then
        local occupants = getVehicleOccupants(veiculo)
        local seats = getVehicleMaxPassengers(veiculo)
        local posicao = getPedOccupiedVehicleSeat(jogador)
        if (posicao ~= 0 and posicao ~= 1) and (getPedOccupiedVehicle(jogador) == veiculo) then
            config["notify"](jogador, translate[lang]["err_radio_off"], "warning", "server")
            return;
        end
        if not vehicles[veiculo] then
            vehicles[veiculo] = {}
            vehicles[veiculo].radio = false
            vehicles[veiculo].radioStation = defaultRadio
            vehicles[veiculo].volume = 1.0
        end
        if vehicles[veiculo].radio then		
            vehicles[veiculo].radio = false
            destroyElement(vehicles[veiculo].radioMarker)
            if isElement(vehicles[veiculo].idleTimer) then
                killTimer(vehicles[veiculo].idleTimer)
            end
            radioStreams = radioStreams - 1
            triggerClientEvent("onServerToggleRadio", root, false, nil, veiculo, vehicles[veiculo].volume)
            config["notify"](jogador, translate[lang]["radio_off"], "info", "server")
        end
    end
end
addEvent("SS:desligarRadio", true)
addEventHandler("SS:desligarRadio", resourceRoot, server.functions["radio:desligar"])

server.functions["radioIdleTimer"] = function(veh)
    local settingDist = config["options"]["distance"].limit[2]
    if isElement(veh) then		
        if vehicles[veh] then
            if vehicles[veh].radio then
                local playerInRange = false
                local vx, vy, vz = getElementPosition(veh)
                for i, jogador in ipairs(getElementsByType("player")) do
                    local px, py, pz = getElementPosition(jogador)
                    local distance = getDistanceBetweenPoints3D(vx, vy, vz, px, py, pz)
                    if distance ~= false and distance < settingDist then
                        playerInRange = true
                    end
                end
                if not playerInRange then
                    triggerClientEvent("onServerToggleRadio", root, false, nil, veh)
                    vehicles[veh].radio = false
                    destroyElement(vehicles[veh].radioMarker)
                    killTimer(vehicles[veh].idleTimer)
                    if radioStreams ~= 0 then
                        radioStreams = radioStreams - 1
                    end
                end
            end
        end
    end
end

server.functions["cmdChangeRadioURL"] = function(jogador, commandName, url, veiculo, distance)
    if not url then
        return config["notify"](jogador, translate[lang]["err_url_console"], "info", "server")
    end
    url = string.gsub(url, "setradio ", "")
    local veh = getPedOccupiedVehicle(jogador)
    if isElement(veiculo) then veh = veiculo end
    if isElement(veh) then
        local ocupantes = getVehicleOccupants(veh)
        local lugares = getVehicleMaxPassengers(veh)
        if not vehicles[veh] then
            local x, y, z = getElementPosition(veh)
            vehicles[veh] = {}
            vehicles[veh].radio = true
            vehicles[veh].lastTick = getTickCount()
            vehicles[veh].radioStation = defaultRadio
            vehicles[veh].volume = 1.0
            vehicles[veh].radioMarker = createMarker(x, y, z, "corona", 0.1, 255, 0, 0, 0)
            attachElements(vehicles[veh].radioMarker, veh)
            if tonumber(idleTime) then
                vehicles[veh].idleTimer = setTimer(server.functions["radioIdleTimer"], idleTime, 0, veh)
            end
        end
        local posicao = getPedOccupiedVehicleSeat(jogador)
        if (posicao ~= 0 and posicao ~= 1) and (getPedOccupiedVehicle(jogador) == veh) then
            config["notify"](jogador, translate[lang]["err_station"], "warning", "server")
            return;
        end
        vehicles[veh].radioStation = url
        vehicles[veh].changedBy = getPlayerName(jogador)
        triggerClientEvent("SS:applyShaders", resourceRoot, veh)
        distance = distance or config["options"]["distance"].default
        server.functions["radio:ligar"](jogador, veh, distance)
        server.functions["setSoundDistance"](jogador, veh, distance)
    end
end
addEvent("SS:changeRadio", true)
addEventHandler("SS:changeRadio", resourceRoot, server.functions["cmdChangeRadioURL"])
addCommandHandler("setradio", server.functions["cmdChangeRadioURL"])

server.functions["onPlayerRadioVolumeChange"] = function(volume)
    local veh = getPedOccupiedVehicle(client)
    if isElement(veh) then
        local posicao = getPedOccupiedVehicleSeat(client)
        if posicao == 0 or posicao == 1 then
            if tonumber(volume) then
                if vehicles[veh] then
                    vehicles[veh].volume = volume
                    if vehicles[veh].volume <= 0 then
                        vehicles[veh].volume = 0
                    end
                end
            end
            if vehicles[veh] then
                triggerClientEvent("onServerVolumeChangeAccept", root, veh, vehicles[veh].volume)
            end
        end
    end
end
addEvent("onPlayerRadioVolumeChange", true)
addEventHandler("onPlayerRadioVolumeChange", root, server.functions["onPlayerRadioVolumeChange"])

server.functions["setSoundDistance"] = function(jogador, veiculo, distance)
    if (client and client ~= jogador) then return end
    distance = tonumber(distance)
    if distance and type(distance) == "number" then
        if distance >= config["options"]["distance"].limit[1] and distance <= config["options"]["distance"].limit[2] then
            triggerClientEvent(root, "SS:setSoundDistance", resourceRoot, veiculo, distance)
        else
            triggerClientEvent(root, "SS:setSoundDistance", resourceRoot, veiculo, config["options"]["distance"].default)
            config["notify"](jogador, translate[lang]["err_distance"].." "..config["options"]["distance"].limit[1].."-".. config["options"]["distance"].limit[2], "warning", "server")
        end
    else
        triggerClientEvent(root, "SS:setSoundDistance", root, veiculo, config["options"]["distance"].default)
    end
end
addEvent("SS:setSoundDistance", true)
addEventHandler("SS:setSoundDistance", resourceRoot, server.functions["setSoundDistance"])

end