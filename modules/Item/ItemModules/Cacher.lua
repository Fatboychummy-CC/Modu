--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Item/ItemModules/Cacher.lua

This module controls all item caching
]]

local cache = {}
local cacheLocation = false
local funcs = {}
--[[cache structure:
  {
    minecraft:item = {
      [damage 1] = "Item Name",
      [damage 2] = "Other Item Name"
    },
    ...
  }
]]
--[[cacheFile structure:
  minecraft:item
   1: Item Name
   2: Other Item Name
  minecraft:item2
   1: Another name
]]
local cached = 0

local function dp()
  cached = cached + 1

  if cached > 10000 then
    os.queueEvent("MODU_ANTI_YIELD") os.pullEvent("MODU_ANTI_YIELD")
    cached = 0
  end
end

local function cacheInv(inv)
  for i = 1, inv.size() do
    local meta = inv.getItemMeta(i)
    if meta then
      local disp = meta.displayName
      local damage = meta.damage
      local name = meta.name
      funcs.manualCacheEntry(name, damage, disp)
      dp()
    end
  end
end

local function cacheAllInvs(invTypes)
  local tps = {"minecraft:chest", "minecraft:shulker_box"}
  local all = peripheral.getNames()

  for i = #all, 1, -1 do

    local f = true
    for o = 1, #tps do
      if peripheral.getType(all[i]) == tps[o] then
        f = false
        break
      end
      dp()
    end
    if f then
      table.remove(all, i)
    end

  end

  for i = 1, #all do
    cacheInv(peripheral.wrap(all[i]))
  end

end

local function saveCache()
  local cacheFile = {}
  local index = 1
  for k, v in pairs(cache) do

    cacheFile[index] = k
    index = index + 1
    for k2, v2 in pairs(v) do
      cacheFile[index] = " " .. tostring(k2) .. ": " .. tostring(v2)
      index = index + 1
      dp()
    end
  end

  local h = io.open(shell.dir() .. "/" .. cacheLocation, "w")
  if h then
    h:write(table.concat(cacheFile, '\n')):close()
  else
    error("Failed to open " .. cacheLocation .. " for writing.")
  end
end

local function loadCache()
  local h = io.open(shell.dir() .. "/" .. cacheLocation, "r")
  local cacheFile = {}
  if h then
    local i = 1
    for line in h:lines() do
      cacheFile[i] = line
      i = i + 1
      dp()
    end
    h:close()

    local key = "unsorted"
    for i = 1, #cacheFile do
      local line = cacheFile[i]
      local a = line:match("^%S+:.+$")
      local b, c = line:match("^ (%d+): (.+)")
      if b then
        if key then
          cache[key][tonumber(b)] = c
        end
      elseif a then
        cache[a] = {}
        key = a
      end
      dp()
    end
  else
    return false, "Failed to open filehandle."
  end
  return true
end

function funcs.go(modules, vars)

end

function funcs.manualCacheEntry(name, damage, itemName)
  if type(cache[name]) == "table" then
    cache[name][damage] = itemName
  else
    cache[name] = {}
    cache[name][damage] = itemName
  end
  saveCache()
end

function funcs.getCache()
  return cache
end

function funcs.help()
  return {
    "Usages:",
    "  cache update",
    "  cache add <minecraft:itemName> <damage> <\"Item Name\">",
    "  cache get <minecraft:itemName> [damage]",
    "  cache get <\"Item Name\">",
    "  cache <delete/remove/rm/del> <minecraft:itemName> <damage>",
    "  cache <delete/remove/rm/del> <\"Item Name\">",
    ";;verbose",
    "  cache update:",
    "    Forces an update to the cache (reads through all connected "
          .. "inventories and caches.)",
    "",
    "  cache add <minecraft:itemName> <damage> <\"Item Name\">:",
    "    Manually adds (or updates) an item's registered cache value.",
    "",
    "  cache get <minecraft:itemName> [damage]:",
    "    Displays the current name set to a cache registration.",
    "",
    "  cache get <\"Item Name\">:",
    "    Displays the current cache registration given to a name."
  }
end

function funcs.getInstant()
  return "cache"
end

function funcs.getInfo()
  return "Allows the user indirect access to the cache, to update or "
          .. " view item names."
end

function funcs.init(data)
  if type(data.cacheSaveLocation) ~= "string" then
    return false, "Missing init data entry, 'cacheSaveLocation'"
  end
  cacheLocation = data.cacheSaveLocation

  if not loadCache() then
    cacheAllInvs()
    saveCache()
  end

  return true
end

return funcs
