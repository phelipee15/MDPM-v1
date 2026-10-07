--[[
»»————-　♡　————-«« »»————-　♡　————-«« »»————-　♡　————-«« »»————-　♡　————-««» »————-　♡　————-«« »»————-　♡　————-««
             __                  ___                                         _      ______
            /\ \                /\_ \      __                              /' \    /\  ___\
    _____   \ \ \___       __   \//\ \    /\_\    _____      __      __   /\_, \   \ \ \__/
   /\ '__`\  \ \  _ `\   /'__`\   \ \ \   \/\ \  /\ '__`\  /'__`\  /'__`\ \/_/\ \   \ \___``\
   \ \ \L\ \  \ \ \ \ \ /\  __/    \_\ \_  \ \ \ \ \ \L\ \/\  __/ /\  __/    \ \ \   \/\ \L\ \
    \ \ ,__/   \ \_\ \_\\ \____\   /\____\  \ \_\ \ \ ,__/\ \____\\ \____\    \ \_\   \ \____/
     \ \ \/     \/_/\/_/ \/____/   \/____/   \/_/  \ \ \/  \/____/ \/____/     \/_/    \/___/
      \ \_\                                         \ \_\
       \/_/                                          \/_/

# Discord: phelipee15
# Copyright (C) 2024 phelipee15
»»————-　♡　————-«« »»————-　♡　————-«« »»————-　♡　————-«« »»————-　♡　————-««»»————-　♡　————-«« »»————-　♡　————-««
--]]

config = { 
    ["main"] = { -- // Main global configs
        ["mdpm"] = true, -- Initialize the MDPM by default (true or false)
        ["cmd"] = "mdpm", -- Command to open/close the panel
        ["bind"] = "F7", -- Bind to open/close the pane
        ["language"] = "en", -- Panel language
    },
    ["options"] = {
        ["texture"] = "centro", -- Texture name of the speaker center
        ["strobo"] = "rgb", -- Texture name of the strobo
        ["distance"] = {default = 80, limit = {10, 100}}, -- Speaker distance
    },
    ["frequencies"] = { -- Speaker frequencies
        ["low"] = 0.005,
        ["mid"] = 0.01,
        ["high"] = 0.015,
    },
    ["lata"] = 0.005, -- Vehicle can frequency
    ["dummys"] = {1}, -- 0 (hood), 1 (trunk), 2 (front left), 3 (front right), 4 (rear left), 5 (rear right)
    ["color"] = function() -- // Function for the panel color
        return {0, 81, 242, 255}; -- Return the values in RGBA
    end,
    ["notify"] = function(player, text, type, side)
        if not isElement(player) then return end
        if side == "client" then
            exports["[ss]notify"]:add(text, type)
        elseif side == "server" then
            exports["[ss]notify"]:add(player, text, type)
        end
    end,
}

frequencies = { -- Custom frequency for the speakers (default = "mid")
    [2880] = "low",
    [2242] = "high",
}

translate = { -- // Panel translations
    ["pt-BR"] = {
        ["title"] = "Painel MDPM",
        ["url"] = "URL",
        ["play"] = "Tocar",
        ["stop"] = "Parar",
        ["distance"] = "Distância",
        ["radio_on"] = "Radio [ON]",
        ["radio_off"] = "Radio [OFF]",
        ["err_vehicle"] = "Você precisar estar em um veículo",
        ["err_radio_on"] = "Você não pode ligar a rádio",
        ["err_radio_off"] = "Você não pode desligar a rádio",
        ["err_station"] = "Você não pode mudar a estação de rádio",
        ["err_url_panel"] = "Informe a URL.",
        ["err_url_console"] = "Use: /setradio [url da música]",
        ["err_distance"] = "Valores de Distância válidos:",
    },
    ["en"] = {
        ["title"] = "MDPM Panel",
        ["url"] = "URL",
        ["play"] = "Play",
        ["stop"] = "Stop",
        ["distance"] = "Distance",
        ["radio_on"] = "Radio [ON]",
        ["radio_off"] = "Radio [OFF]",
        ["err_vehicle"] = "You need to be in a vehicle",
        ["err_radio_on"] = "You cannot turn on the radio",
        ["err_radio_off"] = "You cannot turn off the radio",
        ["err_station"] = "You cannot change the radio station",
        ["err_url_panel"] = "Provide the URL.",
        ["err_url_console"] = "Use: /setradio [music URL]",
        ["err_distance"] = "Valid Distance values:",
    },
    ["es"] = {
        ["title"] = "Panel MDPM",
        ["url"] = "URL",
        ["play"] = "Reproducir",
        ["stop"] = "Detener",
        ["distance"] = "Distancia",
        ["radio_on"] = "Radio [ENCENDIDA]",
        ["radio_off"] = "Radio [APAGADA]",
        ["err_vehicle"] = "Necesitas estar en un vehículo",
        ["err_radio_on"] = "No puedes encender la radio",
        ["err_radio_off"] = "No puedes apagar la radio",
        ["err_station"] = "No puedes cambiar la estación de radio",
        ["err_url_panel"] = "Proporcione la URL.",
        ["err_url_console"] = "Use: /setradio [URL de la música]",
        ["err_distance"] = "Valores de distancia válidos:",
    },
    ["de"] = {
        ["title"] = "MDPM-Panel",
        ["url"] = "URL",
        ["play"] = "Abspielen",
        ["stop"] = "Stopp",
        ["distance"] = "Entfernung",
        ["radio_on"] = "Radio [EIN]",
        ["radio_off"] = "Radio [AUS]",
        ["err_vehicle"] = "Du musst in einem Fahrzeug sein",
        ["err_radio_on"] = "Du kannst das Radio nicht einschalten",
        ["err_radio_off"] = "Du kannst das Radio nicht ausschalten",
        ["err_station"] = "Du kannst den Radiosender nicht wechseln",
        ["err_url_panel"] = "Gib die URL ein.",
        ["err_url_console"] = "Benutze: /setradio [Musik-URL]",
        ["err_distance"] = "Gültige Entfernungswerte:",
    },
}