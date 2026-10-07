server = {
    functions = {},
}

addEventHandler("onResourceStart", resourceRoot, function()
    lang = config["main"]["language"]
    server.functions["onResourceStart"]()
end)