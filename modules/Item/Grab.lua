--[[FATFILE
1
https://raw.githubusercontent.com/Fatboychummy-CC/Modu/master/modules/Item/Grab.lua

This module is the main purpose of Modu: to send items to the user.
]]

local funcs = {}

local inv, cacher, manip, pInv

function funcs.go(modules, vars)
  local interactor = modules["Core.Interaction.PlayerInteraction"]
  local tell = interactor.tell
  print(textutils.serialize(vars))
  local item = vars[2]
  local count = vars[3]
  local damage = vars[4]
  count = tonumber(count)
  damage = tonumber(damage)

  if not item then
    tell("Expected item name.")
    return
  end

  if vars.flags['s'] then
    tell("Caching... This may take some time depending on the attached "
          .. "network.")
    local h = cacher.scan()
    tell("Done. Added " .. tostring(h) .. " new item(s).")
  end

  if count then
    if not damage then
      -- cacher.calculateReverseCache()
      local rCache = cacher.getReverseCache()
      local itm = rCache[string.lower(item)]
      if itm then
        damage = itm.d
        item = itm.i
      else
        tell("No cache hit, try using the flag 's' to force a cache update.")
        return
      end
    end
    tell("Sending items.")
    local ctn = inv.grabItemsFromAll(pInv(), count, item, damage)
    tell("Found " .. tostring(ctn) .. "/" .. tostring(count) .. " items.")
  else
    tell("Expected item count.")
    return
  end

end

function funcs.help()
  return {
    "Usage:",
    "  get <item> <count> [damage]",
    ";;verbose",
    "  get minecraft:iron_ingot 32",
    "    transfers 32 iron ingots to the player's inventory.",
    "",
    "  get minecraft:dye 32 4",
    "    transfers lapis lazuli to your inventory.",
    "",
    "  get \"lapis lazuli\" 10",
    "    transfers an item via it's screen name.",
    "",
    "If a damage value is supplied, then Modu will only search via"
      .. " modname:itemname and damage, otherwise it will only search "
      .. "\"Via the full name\"",
    "",
    "Flags:",
    "  s: Scan and update the cache before searching."
  }
end

function funcs.getInstant()
  return "get"
end

function funcs.getInfo()
  return "Retrieves items from a storage network and sends them to the user."
end

function funcs.init(data)
  inv = require("modules.Item.ItemModules.Inventory")
  cacher = require("modules.Item.ItemModules.Cacher")
  manip = require("modules.Item.ItemModules.Manipulators")
  pInv = manip.getFunctionFromManip("getInventory")

  return true
end

return funcs
