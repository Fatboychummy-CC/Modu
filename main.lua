--[[FATFILE
4
https://raw.githubusercontent.com/fatboychummy/Modu/Master/Modu.lua
]]

--
---------------------START: CHANGEABLE---------------------
---------------------END: CHANGEABLE---------------------

---------------------START: Initialization---------------------

local modules = {}
local controller

local function initializeAll()
  local initData = require("data.InitData")
  local nModules = require("data.ModulesRequired")

  local function initialize(mod)
    local ok, err = mod.init(initData)
    if not ok then
      error(err)
    end
  end

  for i = 1, #nModules do
    modules[nModules[i]] = require(nModules[i])
    modules[nModules[i]]._initialized = false
    initialize(modules[nModules[i]])
  end
  controller = require(nModules.controller)
  controller.init(initData)

  for k, v in pairs(modules) do print(k, v) end
end
---------------------END: Initialization---------------------

---------------------START: Data Functions---------------------

-- Deep copy.  Returns a clone of the table inputted.
local function dCopy(tbl)
  local copy = {}

  for k, v in pairs(tbl) do
    if type(v) == "table" then
      copy[k] = dCopy(v)
    else
      copy[k] = v
    end
  end

  return copy
end

local function blblb()
  print("blblb")
end
---------------------END: Data Functions---------------------

---------------------START: MAIN---------------------
local function main()
  initializeAll()
  controller.go(modules)
end
---------------------END: MAIN---------------------

---------------------START: Pcall---------------------
local ok, err = pcall(main)

if not ok then
  if controller then
    if err ~= "Terminated" then
      pcall(controller.err,err)
      error(err, -1)
    else
      pcall(controller.terminate)
      error("Modu has been terminated.", -1)
    end
  else
    error(err, -1)
  end
end
---------------------END: Pcall---------------------
