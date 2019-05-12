--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/Item.lua

This module is the main module
]]

local funcs = {}

local inv = require("modules.Core.ItemModules.Inventory")

function funcs.go(modules, vars)

end

function funcs.help()
  return {
    "Usage:",
    "  get <item> <count> [damage]",
    "  get <item> <count> <true>"
    "",
    "  get minecraft:iron_ingot 32",
    "    transfers 32 iron ingots to the player's inventory.",
    "",
    "  get minecraft:dye 32 4",
    "    transfers lapis lazuli to your inventory.",
    "",
    "  get \"lapis lazuli\" 10 true",
    "    transfers an item via it's screen name.  Note that this is very slow.",
    "",
    "  This module accepts the following as numbers: \"all\" and \"every\".",
    "  Example:",
    "    get minecraft:dye all",
    "  Will grab every single item in the storage network named minecraft:dye."
      .. " This is the similar to:",
    "    get \"lapis lazuli\" all true",
    "  As the above will grab all items named \"lapis lazuli\"."
  }
end

function funcs.getInstant()
  return "get"
end

function funcs.getInfo()
  return "Retrieves items from a storage network and sends them to the user."
end

function funcs.init(data)
  return true
end

return funcs
