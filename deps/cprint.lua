local cprint = {}

cprint.info = function (args) cecho("\n<sienna>[<coral>cHa0s<sienna>]<coral>: <SeaGreen>Info: <slate_grey>"..args:title()) end
cprint.warn = function (args) cecho("\n<sienna>[<coral>cHa0s<sienna>]<coral>: <LightGoldenrod>WARN: <slate_grey>"..args:title()) end
cprint.error = function (args) cecho("\n<sienna>[<coral>cHa0s<sienna>]<coral>: <firebrick>ERROR: <slate_grey>"..args:title()) end
cprint.debug = function (args) cecho("\n<sienna>[<coral>cHa0s<sienna>]<coral>: <royal_blue>DEBUG: <slate_grey>"..args:title()) end

return cprint