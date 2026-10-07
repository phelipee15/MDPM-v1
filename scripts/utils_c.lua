isEventHandlerAdded = function(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

isMouseInPosition = function( x, y, width, height )
	if (not isCursorShowing()) then
		return false
	end
	local sx, sy = guiGetScreenSize()
	local cx, cy = getCursorPosition()
	local cx, cy = ( cx * sx ), ( cy * sy )
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

hexToRGB = function(hex)
    hex = hex:gsub("#","")
    local r = tonumber(hex:sub(1,2), 16)
    local g = tonumber(hex:sub(3,4), 16)
    local b = tonumber(hex:sub(5,6), 16)
    return r, g, b;
end

RGBToHex = function(r, g, b)
    local hex = string.format("#%02X%02X%02X", r, g, b)
    return hex;
end

vectors = {}
cache = {volume_progress = {false, -1, getTickCount()}}

function createVector(width, height, rawData)
    if width > 1 and height > 1 then
        local svgElm = svgCreate(width, height, rawData)
        local svgXML = svgGetDocumentXML(svgElm)
        local rect = xmlFindChild(svgXML, 'rect', 0)
        return {
            svg = svgElm,
            xml = svgXML,
            rect = rect
        }
    end
end

function drawItem(id, px, py, color, postGUI, rx)
    if (not vectors[id]) then return end
    if (not (px or py)) then return end
    local svg = vectors[id]
    postGUI = postGUI or false
    color = color or 0xFFFFFFFF
    local width, height = svg.width, svg.height
    dxDrawImage(x*px, y*py, x*width, y*height, svg.svgDetails.svg, rx, 0, 0, color, postGUI)
end

function setSVGOffset(id, value)
    if (not vectors [id]) then return end
    local svg = vectors[id]
    if (cache[id][2] ~= value) then
        if (not cache[id][1]) then
            cache[id][3] = getTickCount()
            cache[id][1] = true
        end
        local progress = (getTickCount() - cache[id][3]) / 5000
        cache[id][2] = interpolateBetween (cache[id][2], 0, 0, value, 0, 0, progress, 'OutQuad')
        if (progress > 1) then
            cache[id][3] = nil
            cache[id][1] = false
        end
        local rect = svg.svgDetails.rect
        local newValue = svg.width * cache [id][2]/100
        xmlNodeSetAttribute(rect, 'width', newValue)
        svgSetDocumentXML(svg.svgDetails.svg, svg.svgDetails.xml)
    elseif (cache[id][1]) then
        cache[id][1] = false
    end
end

function criarRetangulo(id, dados)
    if not id or not dados then return end
    if vectors[id] then vectors[id] = nil end
    if not vectors[id] then
        local width, width_2, height, height_2 = dados.w or 1, dados.w or 1, dados.h or 1, dados.h or 1
        local color = dados.color or '#FFFFFF'
        local color2 = dados.color2 or color
        local color3 = dados.color3 or color2
        local border = dados.border or 5
        local opacity = dados.op or 1
        local alpha = dados.alpha or 1
        local alpha2 = dados.alpha2 or 1
        local alpha3 = dados.alpha3 or alpha2
        local stroke = dados.stroke or 0
        local strokeColor = dados.strokeColor or "#FFFFFF"
        local strokeAlpha = dados.strokeAlpha or 1
        local gradID = dados.gradID or false
        local x1, y1, x2, y2
        if gradID and dados.grad then x1, y1, x2, y2 = unpack(dados.grad) end
        local gradient = string.format([[
            <linearGradient id='%s' x1='%s%%' y1='%s%%' x2='%s%%' y2='%s%%'>
                <stop offset='0%%' style='stop-color:%s; stop-opacity:%s' />
                <stop offset='50%%' style='stop-color:%s; stop-opacity:%s' />
                <stop offset='100%%' style='stop-color:%s; stop-opacity:%s' />
            </linearGradient>
        ]], gradID or "false", x1 or 0, y1 or 0, x2 or 100, y2 or 0, color, alpha, color2, alpha2, color3, alpha3)
        if gradID then gradID = "url(#"..gradID..")"
        else gradID = color end
        local x, y = 0, 0;
        if stroke > 0 then
            x, y = 0.5, 0.5;
            width_2, height_2 = width_2 - 1, height_2 - 1
            border = border - 0.5;
        end
        local raw = string.format([[
            <svg width='%s' height='%s'>
                <defs>%s</defs>
                <rect x='%s' y='%s' width='%s' height='%s' rx='%s' ry='%s' fill='%s' fill-opacity='%s' stroke='%s' stroke-width='%s' stroke-opacity='%s' />
            </svg>
        ]], width, height, gradient, x, y, width_2, height_2, border, border, gradID, opacity, strokeColor, stroke, strokeAlpha)
        local svg = createVector(width, height, raw)
        vectors[id] = {
            svgDetails = svg,
            width = width,
            height = height
        }
    end
    return vectors[id]
end

function mainPanel(id, dados)
    if not id or not dados then return end
    if vectors[id] then vectors[id] = nil end
    if not vectors[id] then
        local width, height = dados.w or 1, dados.h or 1
        local color = dados.color or '#FFFFFF'
        local raw = string.format([[
        <svg width="%s" height="%s" viewBox="0 0 534 108" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 0H534V93C534 101.284 527.284 108 519 108H15C6.71573 108 0 101.284 0 93V0Z" fill="%s" fill-opacity="0.8"/>
        </svg>
        ]], width, height, color)
        local svg = createVector(width, height, raw)
        vectors[id] = {
            svgDetails = svg,
            width = width,
            height = height
        }
    end
    return vectors[id]
end

function movePanel(id, dados)
    if not id or not dados then return end
    if vectors[id] then vectors[id] = nil end
    if not vectors[id] then
        local width, height = dados.w or 1, dados.h or 1
        local color = dados.color or '#FFFFFF'
        local raw = string.format([[
        <svg width="%s" height="%s" viewBox="0 0 534 16" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 15C0 6.71573 6.71573 0 15 0H519C527.284 0 534 6.71573 534 15V16H0V15Z" fill="%s"/>
        </svg>
        ]], width, height, color)
        local svg = createVector(width, height, raw)
        vectors[id] = {
            svgDetails = svg,
            width = width,
            height = height
        }
    end
    return vectors[id]
end