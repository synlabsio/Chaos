--[[ Temporary init system to determine loading processes and how to accomplish seamless reload of environment.
Mudlet is a highly efficient and capable client and we want to take full advantage of that :) ]]

-- DETERMINE PROFILE INSTALLATION STATUS (Raises init event with second arg to signal a reload rather than an initialisation.)

if chaos then
    chaos.cprint.warn("Existing profile loaded. Press CTRL+F5 to force a reload.")
    raiseEvent("chaos init completed", true)
    return
end


-- INITIALISE ENVIRONMENT PATHS

local path = package.path
local cpath = package.cpath
local homedir = getMudletHomeDir().."/profile/"
local luadir = string.format("%s/%s", homedir, [[?.lua]])
package.path = string.format("%s;%s", path, luadir)
package.cpath = string.format("%s;%s", cpath, luadir)


-- DEFINE NAMESPACE AND CHILDREN

chaos = {}

local modules = {
    "affs",
    "autopath",
    "bals",
    "can",
    "cprint",
    "debug",
    "defs",
    "fsm",
    "gmcp",
    "pdb",
    "pve",
    "pvp",
    "queue",
    "timers",
    "ui",
    "util"
}

for _, module in ipairs(modules) do
    chaos[module] = nil
    package.loaded[module] = nil
end

for _, module in ipairs(modules) do
    chaos[module] = require(module)
end


-- Load persistent Lua configuration tables.

local confs = {
    "pdb",
    "affs"
}

package.path = path
package.cpath = cpath


-- EXTERNAL DEPENDENCIES

local deps = {
    ui = [[https://github.com/DigitalWarzone/zGUI/blob/main/zGUI.mpackage]],
    walker = [[https://github.com/demonnic/demonnicAutoWalker/releases/download/v3.1/demonnicAutoWalker.mpackage]],
    walkmetrics = [[https://github.com/demonnic/autoWalkVis/releases/download/v1.0.0/AutoWalkVisualizer.mpackage]],
    wttr = [[https://github.com/demonnic/MudletWTTR/releases/download/v1.0.0/MudletWTTR.mpackage]],
    recog = [[https://github.com/demonnic/recoginator/releases/download/v1.0/Recoginator.mpackage]],
    mdk = [[https://github.com/demonnic/MDK/releases/download/v2.5.0/MDK.mpackage]],
    repl = [[https://github.com/demonnic/REPLet/releases/download/v1.1.0/REPLet.mpackage]]
}


-- Profile dependencies loaded at this point. Display this info to the user and raise completion event.

chaos.cprint.info(" >>> Chaos fully initialised.", "green")
raiseEvent("chaos init completed")