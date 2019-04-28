--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Core/Item.lua

This module is the main module
]]

local funcs = {}

function funcs.go(modules, vars)

end

function funcs.help()
  return {
    "Usage:",
    "  get <item> <count> [damage]",
    "",
    "  get minecraft:iron_ingot 32",
    "    transfers 32 iron ingots to the player's inventory.",
    "",
    "Note that this uses the item IDs, rather than full names.",
    "For example, lapis lazuli is actually \"get minecraft:dye 1 4\""
  }
end

function funcs.getInstant()
  return "get"
end

function funcs.init(data)
  return true
end

return funcs
