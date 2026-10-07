client = {
    functions = {},
    mdpm = config["main"]["mdpm"],
    start = false,
}

screenW, screenH = guiGetScreenSize()
x, y = (screenW/1366), (screenH/768)

client.functions["reMap"] = function(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

local responsiveMultipler = client.functions["reMap"](screenW, 800, 1920, 0.50, 1)

client.functions["resp"] = function(num)
	return num * responsiveMultipler
end

fonts = {
    ["12"] = dxCreateFont("files/fontes/Inter-Bold.ttf", client.functions["resp"](11)) or "default-bold",
    ["10"] = dxCreateFont("files/fontes/Inter-Bold.ttf", client.functions["resp"](10)) or "default-bold",
}

client.functions["main"] = function()
    
if start then return end
start = true;
r, g, b, a = unpack(config["color"]())  
hex = RGBToHex(r, g, b)
lang = config["main"]["language"]
bindKey(config["main"]["bind"], "down", painel.functions["change"])
addCommandHandler(config["main"]["cmd"], painel.functions["change"])

shaders = {}
strobo = {}
retrocesso =  {}
door = {}

moveNormal = function(shader, value)
    dxSetShaderValue(shader, "sMorphSize", 0, value, 0)
end

iniRevote = function(shader, value)
    retrocesso[shader] = setTimer(function()
        dxSetShaderValue(shader, "sMorphSize", 0, value/4, 0)
    end, 16, 1)
end

calcFFTData = function()
    if client.mdpm then
        for i, veiculo in ipairs(getElementsByType("vehicle", root, true)) do
            if isElement(veiculo) and isElement(setradio[veiculo]) then
                local fftData = getSoundFFTData(setradio[veiculo], 2048, 20)
                if fftData then
                    if isElement(strobo[veiculo]) then
                        local averageFFT = 0
                        for i = 1, #fftData do
                            if (fftData[i] < 0) then fftData[i] = 0; elseif (fftData[i] > 2) then fftData[i] = 0; end
                            averageFFT = averageFFT + fftData[i]/2
                        end
                        averageFFT = averageFFT / #fftData
                        dxSetShaderValue(strobo[veiculo], "alpha", math.max(math.min(averageFFT * 5, 2), 0))
                    end
                    if (fftData[1] < 0) then fftData[1] = 0; elseif (fftData[1] > 2) then fftData[1] = 0; end
                    fftData[1] = tonumber(string.format("%.3f", fftData[1])) or 0
                    local intensity = math.min(math.max(fftData[1] * getSoundVolume(setradio[veiculo]), 0), 5)
                    if shaders[veiculo] then
                        for freq, shader in pairs(shaders[veiculo]) do
                            local value = math.min(intensity * config["frequencies"][freq] * 0.75, 0.04)
                            local fase = math.random(1, 8)
                            if not isTimer(retrocesso[shader]) then
                                moveNormal(shader, value)
                                iniRevote(shader, value)
                            end
                            value = value/6
                            if fase == 1 then
                                dxSetShaderValue(shader, "sRotation", 0, 0, value)
                            elseif fase == 2 then
                                dxSetShaderValue(shader, "sRotation", value, 0, value)
                            elseif fase == 3 then
                                dxSetShaderValue(shader, "sRotation", value, 0, 0)
                            elseif fase == 4 then
                                dxSetShaderValue(shader, "sRotation", value, 0, -value)
                            elseif fase == 5 then
                                dxSetShaderValue(shader, "sRotation", 0, 0, -value)
                            elseif fase == 6 then
                                dxSetShaderValue(shader, "sRotation", -value, 0, -value)
                            elseif fase == 7 then
                                dxSetShaderValue(shader, "sRotation", -value, 0, 0)
                            elseif fase == 8 then
                                dxSetShaderValue(shader, "sRotation", -value, 0, value)
                            end
                        end
                    end
                    if not isTimer(door[veiculo]) then
                        door[veiculo] = setTimer(function()
                            for i, dummy in ipairs(config["dummys"]) do
                                if isElement(veiculo) then
                                    if getVehicleDoorOpenRatio(veiculo, dummy) then
                                        local valor = math.min(tonumber(string.format("%.3f", intensity*config["lata"])), 0.1)
                                        setVehicleDoorOpenRatio(veiculo, dummy, getVehicleDoorOpenRatio(veiculo, dummy) + valor, 0)
                                        setTimer(function()
                                            if isElement(veiculo) then
                                                setVehicleDoorOpenRatio(veiculo, dummy, getVehicleDoorOpenRatio(veiculo, dummy) - valor, 0)
                                                door[veiculo] = false
                                            end
                                        end, 50, 1)
                                    end
                                end
                            end
                        end, 20, 1)
                    end
                end
            end
        end
    end
end
setTimer(calcFFTData, 1, 0)

client.functions["createShaders"] = function(veiculo)
    if isElement(veiculo) then
        if not shaders[veiculo] then
            shaders[veiculo] = {}
            shaders[veiculo]["low"] = dxCreateShader("files/shaders/shader.fx")
            shaders[veiculo]["mid"] = dxCreateShader("files/shaders/shader.fx")
            shaders[veiculo]["high"] = dxCreateShader("files/shaders/shader.fx")
        end
        if not strobo[veiculo] then
            strobo[veiculo] = dxCreateShader("files/shaders/strobo.fx")
        end
    end
end

client.functions["applyShaders"] = function(veiculo)
    if isElementStreamedIn(veiculo) then
        client.functions["createShaders"](veiculo)
        for i, object in ipairs(getAttachedElements(veiculo)) do
            if getElementType(object) == "object" then
                local freq = frequencies[getElementModel(object)]
                if freq then
                    engineApplyShaderToWorldTexture(shaders[veiculo][freq], config["options"]["texture"], object)
                else
                    engineApplyShaderToWorldTexture(shaders[veiculo]["mid"], config["options"]["texture"], object)
                end
                engineApplyShaderToWorldTexture(strobo[veiculo], config["options"]["strobo"], object)
            end
        end
    end
end
addEvent("SS:applyShaders", true)
addEventHandler("SS:applyShaders", resourceRoot, client.functions["applyShaders"])

for i, veiculo in ipairs(getElementsByType("vehicle", root, true)) do
    client.functions["applyShaders"](veiculo)
end

client.functions["onClientElementStreamIn"] = function()
    if isElement(source) and getElementType(source) == "vehicle" then
        client.functions["createShaders"](source)
        for i, object in ipairs(getAttachedElements(source)) do
            if getElementType(object) == "object" then
                local freq = frequencies[getElementModel(object)]
                if freq then
                    engineApplyShaderToWorldTexture(shaders[source][freq], config["options"]["texture"], object)
                else
                    engineApplyShaderToWorldTexture(shaders[source]["mid"], config["options"]["texture"], object)
                end
                engineApplyShaderToWorldTexture(strobo[source], config["options"]["strobo"], object)
            end
        end
    end
end
addEventHandler("onClientElementStreamIn", root, client.functions["onClientElementStreamIn"])

client.functions["onClientElementStreamOut"] = function()
    if isElement(source) and getElementType(source) == "vehicle" then
        if shaders[source] then
            for i, object in ipairs(getAttachedElements(source)) do
                if getElementType(object) == "object" then
                    local freq = frequencies[getElementModel(object)]
                    if freq then
                        engineRemoveShaderFromWorldTexture(shaders[source][freq], config["options"]["texture"], object)
                    else
                        engineRemoveShaderFromWorldTexture(shaders[source]["mid"], config["options"]["texture"], object)
                    end
                end
            end
        end
    end
end
addEventHandler("onClientElementStreamOut", root, client.functions["onClientElementStreamOut"])

end
addEventHandler("onClientResourceStart", resourceRoot, client.functions["main"])