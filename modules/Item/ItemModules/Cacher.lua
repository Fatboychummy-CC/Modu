--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/modules/Item/ItemModules/Cacher.lua

This module controls all item caching
]]

local cache = {}
local reverseCache = {}
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
  local new = 0
  for i = 1, inv.size() do
    local meta = inv.getItemMeta(i)
    if meta then
      local disp = meta.displayName
      local damage = meta.damage
      local name = meta.name
      if type(cache[name]) ~= "table"
         or type(cache[name][damage]) ~= "string" then
        funcs.manualCacheEntry(name, damage, disp)
        new = new + 1
      end
      dp()
    end
  end
  return new
end

local function cacheAllInvs(invTypes)
  local tps = {"minecraft:chest", "minecraft:shulker_box"}
  invTypes = invTypes or {}
  for i = 1, #invTypes do
    tps[#tps + 1] = invTypes[i]
  end

  local all = peripheral.getNames()
  local new = 0

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
    new = new + cacheInv(peripheral.wrap(all[i]))
  end

  return new
end

local function calculateReverseCache()
  reverseCache = {}
  for k, v in pairs(cache) do
    for k2, v2 in pairs(v) do
      reverseCache[string.lower(v2)] = {d = k2, i = k}
    end
  end
  --[[

  {
    name = {
      d = damage,
      i = mod:itemname
    }
  }

  ]]
end

local function saveCache()
  calculateReverseCache()
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
  local interactor = modules["Core.Interaction.PlayerInteraction"]
  local tell = interactor.tell
  local command = vars[2]

  local function typeAssert(tps, got, arg)
    got = type(got)
    for i = 1, #tps do
      if tps[i] == got then
        return false
      end
    end
    local types = table.concat(tps, " or ")
    tell("Expected " .. tostring(types) .. ", got " .. got .. ". (arg "
          .. tostring(arg) .. ")")
    return true
  end

  if vars.flags['c'] then
    tell("Clearing the Cache")
    cache = {}
    saveCache()
  end

  if command == "update" then

    tell("Updating Cache...")
    local new = cacheAllInvs()
    tell(new == 1 and "Done, created 1 new entry."
        or "Done, created " .. tostring(new) .. " new entries.")

  elseif command == "add" then

    local iName = vars[3]
    local damage = tonumber(vars[4])
    local name = vars[5]
    if typeAssert({"string"}, iName, 1) then
      return
    end
    if typeAssert({"number"}, damage, 2) then
      return
    end
    if typeAssert({"string"}, name, 3) then
      return
    end
    funcs.manualCacheEntry(iName, damage, name)

  elseif command == "get" then

    local iName = vars[3]
    local damage = tonumber(vars[4])
    if typeAssert({"string"}, iName, 1) then
      return
    end
    if typeAssert({"number", "nil"}, damage, 2) then
      return
    end

    if cache[iName] then
      if damage then
        local name = cache[iName][damage]
        if name then
          tell("That is registered to " .. tostring(name) .. ".")
        else
          tell("This item is not registered to a name.")
        end
      else

        local names = {}
        for k, v in pairs(cache[iName]) do
          names[#names + 1] = tostring(k) .. " " .. tostring(v)
        end
        table.sort(names, function(a, b)
          if tonumber(a:match("%d+")) < tonumber(b:match("%d+")) then
            return true
          else
            return false
          end
        end)

        tell("This item has the following damage values/names:")
        for i = 1, #names do
          tell(names[i]:match("%d+").. ": " .. names[i]:match(" .+"))
        end
      end
    else
      local b = reverseCache[iName]
      if b then
        tell("This item is registered to:")
        tell(tostring(b.i) .. " with damage " .. tostring(b.d))
      end
    end

  elseif command == "delete" then

    local iName = vars[3]
    local damage = tonumber(vars[4])
    if typeAssert({"string"}, iName, 1) then
      return
    end
    if typeAssert({"number", "nil"}, damage, 2) then
      return
    end

    local a = cache[iName]
    local b = reverseCache[iName]
    if a then
      if damage then
        cache[iName][damage] = nil
      else
        cache[iName] = nil
      end
    elseif b then
      cache[b.i][b.d] = nil
      saveCache()
    else
      tell("No cache hits.")
    end

  else

    tell("Unknown command: " .. tostring(command))

  end

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

function funcs.scan(extras)
  return cacheAllInvs(extras)
end

function funcs.getCache()
  return cache
end

function funcs.getReverseCache()
  return reverseCache
end

function funcs.help()
  return {
    "Usages:",
    "  cache update [-c]",
    "  cache add <minecraft:itemName> <damage> <\"Item Name\">",
    "  cache get <minecraft:itemName> [damage]",
    "  cache get <\"Item Name\">",
    "  cache delete <minecraft:itemName> <damage>",
    "  cache delete <\"Item Name\">",
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
    "    Displays the current cache registration given to a name.",
    "",
    "Flags:",
    "  c: Clears the cache."
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
  else
    calculateReverseCache()
  end

  return true
end

return funcs
