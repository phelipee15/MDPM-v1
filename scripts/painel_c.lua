painel = {
    functions = {},
    state = false,
    url = createElement("SS:MDPM"),
    distance = createElement("SS:MDPM"),
}

pos = {
    x = 416,
    y = 322,
}

painel.functions["change"] = function()
    if not isEventHandlerAdded("onClientRender", root, painel.functions["dx"]) then
        painel.functions["vector"]()
        addEventHandler("onClientRender", root, painel.functions["dx"])
        showCursor(true)
        painel.state = true
        addEventHandler("onClientCursorMove", root, painel.functions["onClientCursorMove"])
    else
        painel.state = false
        showCursor(false)
        removeEventHandler("onClientRender", root, painel.functions["dx"])
        vectors = {}
        guiSetInputMode("allow_binds")
        setElementData(painel.url, "state", false)
        setElementData(painel.distance, "state", false)
        removeEventHandler("onClientCursorMove", root, painel.functions["onClientCursorMove"])
    end
end

painel.functions["vector"] = function()
    mainPanel("panel_main", {w = 534, h = 108, color = "#1E1E1E"})
    movePanel("panel_move", {w = 534, h = 16, color = hex})
    criarRetangulo("url", {w = 222, h = 25, color = hex, border = 5, op = 0, stroke = 1.5, strokeColor = hex, strokeAlpha = 1})
    criarRetangulo("distance", {w = 84, h = 25, color = hex, border = 5, op = 0, stroke = 1.5, strokeColor = hex, strokeAlpha = 1})
    criarRetangulo("volume_bar", {w = 69, h = 8, color = hex, border = 5, op = 0, stroke = 1.5, strokeColor = hex, strokeAlpha = 1})
    criarRetangulo("volume_circle", {w = 10, h = 10, color = "#FFFFFF", border = 5, op = 1})
    criarRetangulo("mdpm_check", {w = 15, h = 15, color = hex, border = 5, op = 0, stroke = 1.5, strokeColor = hex, strokeAlpha = 1})
    criarRetangulo("button1", {w = 84, h = 25, color = hex, border = 5, op = 1})
    criarRetangulo("button2", {w = 84, h = 25, color = hex, border = 5, op = 0, stroke = 1.5, strokeColor = hex, strokeAlpha = 1})
    criarRetangulo("line", {w = 222, h = 2, color = hex, border = 1, op = 1})
    criarRetangulo("volume_progress", {w = 69, h = 8, color = hex, border = 5, op = 1})
end

painel.functions["dx"] = function()
    drawItem("panel_move", (pos.x+0), (pos.y+0), tocolor(255, 255, 255, 255), false)
    drawItem("panel_main", (pos.x+0), (pos.y+16), tocolor(255, 255, 255, 255), false)
    dxDrawText(translate[lang]["title"], x*(pos.x + 0)*2, y*(pos.y + 2), x*(534), y*(0), tocolor(255, 255, 255, 255), 1, fonts["10"], "center", "top")
    dxDrawImage(x*(pos.x + 14), y*(pos.y + 43), x*(55), y*(55), "files/img/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
    drawItem("url", (pos.x+104), (pos.y+34), tocolor(255, 255, 255, 255), false)
    dxDrawEditBox(translate[lang]["url"], x*(pos.x+104+2), y*(pos.y+34), x*(222-26), y*(25), false, 500, painel.url, tocolor(255, 255, 255, 255), "string", "12", false)
    dxDrawImage(x*(pos.x + 303), y*(pos.y + 36), x*(21), y*(21), "files/img/clear.png", 0, 0, 0, isMouseInPosition(x*(pos.x + 303), y*(pos.y + 36), x*(21), y*(21)) and tocolor(r, g, b, 255) or tocolor(255, 255, 255, 255))
    drawItem(isMouseInPosition(x*(pos.x+104), y*(pos.y+69), x*84, y*25) and "button1" or "button2", (pos.x+104), (pos.y+69), tocolor(255, 255, 255, 255), false)
    dxDrawText(translate[lang]["play"], x*(pos.x + 104)*2, y*(pos.y + 74), x*(84), y*(0), tocolor(255, 255, 255, 255), 1, fonts["12"], "center", "top")
    drawItem(isMouseInPosition(x*(pos.x+242), y*(pos.y+69), x*84, y*25) and "button1" or "button2", (pos.x+242), (pos.y+69), tocolor(255, 255, 255, 255), false)
    dxDrawText(translate[lang]["stop"], x*(pos.x + 242)*2, y*(pos.y + 74), x*(84), y*(0), tocolor(255, 255, 255, 255), 1, fonts["12"], "center", "top")
    drawItem("distance", (pos.x+381), (pos.y+34), tocolor(255, 255, 255, 255), false)
    dxDrawEditBox(translate[lang]["distance"], x*(pos.x+381+2), y*(pos.y+34), x*(84-5), y*(25), false, 3, painel.distance, tocolor(255, 255, 255, 255), "number", "12", false)
    local level = 1
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if isElement(vehicle) and isElement(setradio[vehicle]) then
        level = (getSoundVolume(setradio[vehicle]) > 0.7) and 1 or (getSoundVolume(setradio[vehicle]) > 0.1) and 2 or 3
    end
    dxDrawImage(x*(pos.x + 375), y*(pos.y + 67), x*(16), y*(16), "files/img/volume"..level..".png", 0, 0, 0, tocolor(255, 255, 255, 255))
    drawItem("volume_bar", (pos.x+396), (pos.y+71), tocolor(255, 255, 255, 255), false)
    drawItem("volume_progress", (pos.x+396), (pos.y+71), tocolor(255, 255, 255, 255), false)
    if isElement(vehicle) and isElement(setradio[vehicle]) then
        local progress = getSoundVolume(setradio[vehicle]) or 0
        setSVGOffset("volume_progress", progress*100)
        drawItem("volume_circle", (pos.x+396+(progress*69-5)), (pos.y+70), tocolor(255, 255, 255, 255), false)
        if isMouseInPosition(x*(pos.x+396-2), y*(pos.y+70-2), x*(69+4), y*(10+2)) and getKeyState("mouse1") then
            local cx = getCursorPosition()*1366
            local value = math.max(math.min((cx-(pos.x+396))/69, 1), 0)
            triggerServerEvent("onPlayerRadioVolumeChange", resourceRoot, value)
        end
    end
    drawItem("mdpm_check", (pos.x+381), (pos.y+91), tocolor(255, 255, 255, 255), false)
    dxDrawImage(x*(pos.x + 384), y*(pos.y + 94), x*(9), y*(9), "files/img/confirm.png", 0, 0, 0, tocolor(255, 255, 255, client.mdpm and 255 or 0))
    dxDrawText("MDPM", x*(pos.x + 403), y*(pos.y + 91), x*(0), y*(0), tocolor(255, 255, 255, 255), 1, fonts["12"], "left", "top")
    drawItem("line", (pos.x+104), (pos.y+104), tocolor(255, 255, 255, 255), false)
end

painel.functions["onClientClick"] = function(button, state)
    if isEventHandlerAdded("onClientRender", root, painel.functions["dx"]) and button == "left" then
        if isMouseInPosition(x*(pos.x+0), y*(pos.y+0), x*(534), y*(16)) and state == "down" then
            local cx, cy = getCursorPosition()
            cx, cy = (cx*1366 - pos.x), (cy*768 - pos.y)
            painel.move = {x = cx, y = cy}
        elseif state == "up" and painel.move then
            painel.move = false
        end
        if state == "down" then
            if isMouseInPosition(x*(pos.x+381), y*(pos.y+91), x*15, y*15) then
                client.mdpm = not client.mdpm
            elseif isMouseInPosition(x*(pos.x+104), y*(pos.y+69), x*84, y*25) then
                local vehicle = getPedOccupiedVehicle(localPlayer)
                if isElement(vehicle) then
                    local url = getElementData(painel.url, "text")
                    if #url >= 1 then
                        local distance = getElementData(painel.distance, "text")
                        triggerServerEvent("SS:changeRadio", resourceRoot, localPlayer, false, url, _, distance)
                    else
                        config["notify"](localPlayer, translate[lang]["err_url_panel"], "error", "client")
                    end
                else
                    config["notify"](localPlayer, translate[lang]["err_vehicle"], "error", "client")
                end
            elseif isMouseInPosition(x*(pos.x + 303), y*(pos.y + 36), x*(21), y*(21)) then
                setElementData(painel.url, "text", "")
            elseif isMouseInPosition(x*(pos.x+242), y*(pos.y+69), x*84, y*25) then
                local vehicle = getPedOccupiedVehicle(localPlayer)
                if isElement(vehicle) then
                    triggerServerEvent("SS:desligarRadio", resourceRoot, localPlayer, vehicle)
                else
                    config["notify"](localPlayer, translate[lang]["err_vehicle"], "error", "client")
                end
            end
        end
    end
end
addEventHandler("onClientClick", root, painel.functions["onClientClick"])

painel.functions["onClientCursorMove"] = function(_, _, px, py)
    if painel.move then
        pos.x, pos.y = (px/screenW*1366 - painel.move.x), (py/screenH*768 - painel.move.y)
    end
end