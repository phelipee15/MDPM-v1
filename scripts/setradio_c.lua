setradio = {}

client.functions["onServerToggleRadio"] = function(toggle, url, veh, volume)
    if not isElement(veh) then
        if setradio[veh] then 
            if isElement(setradio[veh]) then stopSound(setradio[veh]) end
        end
        return;
    end
    if toggle then
        local x, y, z = getElementPosition(veh)
        if setradio[veh] then
            if isElement(setradio[veh]) then stopSound(setradio[veh]) end
            local musica = playSound3D(url, x, y, z)
            setSoundVolume(musica, 1)
            setSoundMinDistance(musica, 10)
            attachElements(musica, veh)
            setradio[veh] = musica
        else
            local musica = playSound3D(url, x, y, z)
            setSoundVolume(musica, 1)
            setSoundMinDistance(musica, 10)
            attachElements(musica, veh)
            setradio[veh] = musica
        end
    else
        if setradio[veh] then
            if isElement(setradio[veh]) then
                stopSound(setradio[veh])
            end
        end
    end
end
addEvent("onServerToggleRadio", true)
addEventHandler("onServerToggleRadio", localPlayer, client.functions["onServerToggleRadio"])

client.functions["onServerRadioURLChange"] = function(url, vehicle, volume)
    if setradio[vehicle] then
        if isElement(setradio[vehicle]) then
            stopSound(setradio[vehicle])
        end
        local x, y, z = getElementPosition(vehicle)
        local musica = playSound3D(url, x, y, z)
        setSoundVolume(musica, 1)
        setSoundMinDistance(musica, 10)
        attachElements(musica, vehicle)
        setradio[vehicle] = musica
    end
end
addEvent("onServerRadioURLChange", true)
addEventHandler("onServerRadioURLChange", localPlayer, client.functions["onServerRadioURLChange"])

client.functions["onServerVolumeChangeAccept"] = function(vehicle, volume)
    if isElement(vehicle) then
        if isElement(setradio[vehicle]) then
            setSoundVolume(setradio[vehicle], volume)
        end
    end
end
addEvent("onServerVolumeChangeAccept", true)
addEventHandler("onServerVolumeChangeAccept", localPlayer, client.functions["onServerVolumeChangeAccept"])

client.functions["setSoundDistance"] = function(veiculo, distance)
    if isElement(veiculo) and setradio[veiculo] then
        if isElement(setradio[veiculo]) then
            setSoundMaxDistance(setradio[veiculo], tonumber(distance))
        end
    end
end
addEvent("SS:setSoundDistance", true)
addEventHandler("SS:setSoundDistance", resourceRoot, client.functions["setSoundDistance"])