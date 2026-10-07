local lctrla = false
local mode = {}
local numbers = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}

function dxDrawEditBox(text, x, y, w, h, password, maxCharacter, element, color, tipo, fonte, posGui)
	if tipo then
		mode[element] = tipo
	end
	if not getElementData(element, "text") then setElementData(element, "text", "") end
	local getText = getElementData(element, "text") or setElementData(element, "text", "")
	local state = getElementData(element, "state") or setElementData(element, "state", false)
	local character = getElementData(element, "maximum") or setElementData(element, "maximum", maxCharacter)
	if lctrla then
		if (getElementData(element, "state") == true) then
			if #getElementData(element, "text") > character then
				dxDrawRectangle(x + 5, y + 5, w, h - 10, tocolor(173, 216, 230, 150), posGui)
			else
				local tamanho = math.min(dxGetTextWidth(password and string.gsub(getElementData(element, "text"), ".", "•") or getElementData(element, "text"), 1, fonts[fonte]), w)
				dxDrawRectangle(x + 5, y + 5, tamanho, h - 10, tocolor(173, 216, 230, 150), posGui)
			end
		end
	end
	if (#getElementData(element, "text") == 0) then
		dxDrawText(text, x + 10, y, x + w - 10, y + h, color, 1, fonts[fonte], "left", "center", true, false, posGui)
	end
	
	if eye then
		if (dxGetTextWidth(password and getElementData(element, "text") or getElementData(element, "text"), 1, fonts[fonte]) <= w - 10) then
			dxDrawText(password and getElementData(element, "text") or getElementData(element, "text"), x + 5, y, x + w - 10, y + h, tocolor(255, 255, 255, 255), 1, fonts[fonte], "left", "center", true, false, posGui)
		else
			dxDrawText(password and getElementData(element, "text") or getElementData(element, "text"), x + 5, y, x + w - 10, y + h, tocolor(255, 255, 255, 255), 1, fonts[fonte], "right", "center", true, false, posGui)
		end
	else
		if (dxGetTextWidth(password and string.gsub(getElementData(element, "text"), ".", "•") or getElementData(element, "text"), 1, fonts[fonte]) <= w - 10) then
			dxDrawText(password and string.gsub(getElementData(element, "text"), ".", "•") or getElementData(element, "text"), x + 5, y, x + w - 10, y + h, color, 1, fonts[fonte], "left", "center", true, false, posGui)
		else
			dxDrawText(password and string.gsub(getElementData(element, "text"), ".", "•") or getElementData(element, "text"), x + 5, y, x + w - 10, y + h, color, 1, fonts[fonte], "right", "center", true, false, posGui)
		end
	end
	
	if (getElementData(element, "state") == true) then
		if (dxGetTextWidth(password and string.gsub(getElementData(element, "text"), ".", "•") or getElementData(element, "text"), 1, fonts[fonte]) <= w - 10) then
			if eye then
				dxDrawLine(x + 5 + dxGetTextWidth(password and getElementData(element, "text") or getElementData(element, "text"), 1, fonts[fonte]), y + 5, x + 5 + dxGetTextWidth(password and getElementData(element, "text") or getElementData(element, "text"), 1, fonts[fonte]), y + h - 5, tocolor(255, 255, 255, math.abs(math.sin(getTickCount() / 255) * 255)), 1, posGui)
			else
				dxDrawLine(x + 5 + dxGetTextWidth(password and string.gsub(getElementData(element, "text"), ".", "•") or getElementData(element, "text"), 1, fonts[fonte]), y + 5, x + 5 + dxGetTextWidth(password and string.gsub(getElementData(element, "text"), ".", "•") or getElementData(element, "text"), 1, fonts[fonte]), y + h - 5, tocolor(255, 255, 255, math.abs(math.sin(getTickCount() / 255) * 255)), 1, posGui)
			end
		else
			dxDrawLine(x + w - 10, y + 5, x + w - 10, y + h - 5, tocolor(255, 255, 255, math.abs(math.sin(getTickCount() / 255) * 255)), 1, posGui)
		end
	end
	if (cursorPosition(x, y, w, h)) then
		setElementData(element, "mouseState", "hovered")
	else
		setElementData(element, "mouseState", "normal")
	end
end

function dxClickElement(button, state, cx, cy)
	if not isEventHandlerAdded("onClientRender", root, painel.functions["dx"]) then return end
	lctrla = false
	if (button == "left") and (state == "down") then
		local buttonId = false
		for id, element in ipairs(getElementsByType("dxButton")) do
			if (getElementData(element, "mouseState") == "hovered") then
				buttonId = id
			end
		end
		if (buttonId) then
			if (isElement(getElementsByType("dxButton")[buttonId])) then
				setElementData(getElementsByType("dxButton")[buttonId], "mouseState", "clicked")
			end
		end
	end
	if (button == "left") and (state == "down") then
		local editBoxId = false
		for id, element in ipairs(getElementsByType("SS:MDPM")) do
			if (getElementData(element, "mouseState") == "hovered") then
				editBoxId = id
			elseif (getElementData(element, "mouseState") == "normal") then
				if (getElementData(element, "state") == true) then
					guiSetInputMode("allow_binds")
					setElementData(element, "state", false)
				end
			end
		end
		if (editBoxId) then
			if (isElement(getElementsByType("SS:MDPM")[editBoxId])) then
				if (getElementData(getElementsByType("SS:MDPM")[editBoxId], "state") == false) then
					guiSetInputMode("no_binds")
					setElementData(getElementsByType("SS:MDPM")[editBoxId], "state", true)
				end
			end
		end
	end
	if (button == "left") and (state == "down") then
		local checkBoxId = false
		for id, element in ipairs(getElementsByType("dxCheckBox")) do
			if (getElementData(element, "mouseState") == "hovered") then
				checkBoxId = id
			end
		end
		if (checkBoxId) then
			if (isElement(getElementsByType("dxCheckBox")[checkBoxId])) then
				if (getElementData(getElementsByType("dxCheckBox")[checkBoxId], "state") == true) then
					setElementData(getElementsByType("dxCheckBox")[checkBoxId], "state", false)
				else
					setElementData(getElementsByType("dxCheckBox")[checkBoxId], "state", true)
				end
			end
		end
	end
	if (button == "left") then
		for _, element in ipairs(getElementsByType("dxGridList")) do
			if (getElementData(element, "mouseState") == "hovered") then
				local barCount = getElementData(element, "barCount")
				local barList = getElementData(element, "barList")
				if (#barList > barCount) then
					local x = getElementData(element, "x")
					local y = getElementData(element, "y")
					local w = getElementData(element, "w")
					local h = getElementData(element, "h")
					local scrollOffset = getElementData(element, "scrollOffset")
					local scrollY = getElementData(element, "scrollY")
					local scrollSpace = #barList > barCount and 11 or 0
					local size = barCount / #barList
					local scrollList = scrollOffset / #barList
					if (state == "down") then
						if (cx >= x + w - scrollSpace) and (cx <= x + w - scrollSpace + 3) and (cy >= y + scrollList * h) and (cy <= y + scrollList * h + size * h) then
							setElementData(element, "scrollAlpha", 255)
							setElementData(element, "scrollAttached", true)
							local mouseOffset = y + scrollY * (1 - size) * h
							setElementData(element, "scrollAttachedOffset", cy - mouseOffset)
						end
					end
				end
				if (state == "up") and not (getElementData(element, "scrollAttached")) then
					setElementData(element, "selected", {getElementData(element, "barAttached")[1], getElementData(element, "barAttached")[2] or ""})
				end
			end
			if (state == "up") then
				setElementData(element, "scrollAttached", false)
				setElementData(element, "scrollAlpha", 150)
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), dxClickElement)

function dxCharacterElement(button)
	if (isChatBoxInputActive()) or (isConsoleActive()) or (isMainMenuActive()) then
		return
	end
	for _, element in ipairs(getElementsByType("SS:MDPM")) do
		if (getElementData(element, "state") == true) then
			if mode[element] == "number" then
				for i, v in ipairs(numbers) do
					if tonumber(button) == v then
						break;
					elseif #numbers == i then
						return;
					end
				end
			end
			if not element then return end
			if lctrla then setElementData(element, "text", button) end
			lctrla = false
			if (#getElementData(element, "text") < getElementData(element, "maximum")) then
				setElementData(element, "text", getElementData(element, "text")..button)
			end
		end
	end
end
addEventHandler("onClientCharacter", getRootElement(), dxCharacterElement)

local backspace = false
function dxKeyElement(button, press)
	if (isChatBoxInputActive()) or (isConsoleActive()) or (isMainMenuActive()) then
		return
	end
	for _, element in ipairs(getElementsByType("SS:MDPM")) do
		if (getElementData(element, "state") == true) then
			if (button == "backspace") then
				backspace = press
				if (press) then
					setTimer(function()
						if backspace then
							dxKeyElement("backspace", true)
						end
					end, 150, 1)
					if lctrla then
						if (#getElementData(element, "text") > 0) then
							setElementData(element, "text", string.sub(getElementData(element, "text"), 1, #getElementData(element, "text") - #getElementData(element, "text")))
						end
						lctrla = false
					else
						if (#getElementData(element, "text") > 0) then
							setElementData(element, "text", string.sub(getElementData(element, "text"), 1, #getElementData(element, "text") - 1))
						end
					end
				end
			elseif (button == "a") then
				if getKeyState("lctrl") then
					if isTimer(Timer) then return end
					local Timer = setTimer(function() end, 500, 1)
					lctrla = not lctrla
				end
			elseif (button == "c") then
				if getKeyState("lctrl") then
					setClipboard(getElementData(element, "text"))
					lctrla = not lctrla
				end
			elseif (button == "enter") then
				if (getElementData(element, "state") == true) then
					guiSetInputMode("allow_binds")
					setElementData(element, "state", false)
				end
			end
		end
	end
end
addEventHandler("onClientKey", getRootElement(), dxKeyElement)

addEventHandler("onClientPaste", root, function(text)
	for _, element in ipairs(getElementsByType("SS:MDPM")) do
		if (getElementData(element, "state") == true) then
			local texto = getElementData(element, "text") or ""
			if lctrla then
				setElementData(element, "text", text)
				lctrla = false
			else
				setElementData(element, "text", texto..""..text)
			end
		end
	end
end)

function cursorPosition(x, y, width, height)
    if(not isCursorShowing()) then
        return false
    end
    local sx, sy = guiGetScreenSize()
    local cx, cy = getCursorPosition()
    local cx, cy =(cx*sx),(cy*sy)
    if(cx >= x and cx <= x + width) and(cy >= y and cy <= y + height) then
        return true
    else
        return false
    end
end