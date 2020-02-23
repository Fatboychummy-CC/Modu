--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/master/main.lua

This is main.lua, I'd assume you know that this is the program itself.
]]


---------------------START: Initialization---------------------

local modules = {}
local moduleData
local controller

local function initialize()
  moduleData = require("data.ModulesRequired")
end

local function initializeModules(nModules)
  local initData = require("data.InitData")
  local ars = {}
  modules = {}

  local function initialize(mod)
    local ok, err = mod.init(initData)
    if not ok then
      error(err)
    end
    return ok, err
  end

  local function printInit(m, c, t, b)
    local function write(d)
      term.setCursorPos(1, 1)
      io.write("Initializing...")
      io.write("                                                              ")
      term.setCursorPos(17, 1)
      io.write(m)
      term.setCursorPos(1, 2)
      io.write("                                                              ")
      term.setCursorPos(1, 2)
      io.write("Initialized " .. tostring(c) .. "/" .. tostring(t)
                  .. " modules" .. string.rep(".", d) .. "\n")
    end

    if b then
      write(1)
    else
      while true do
        for i = 1, 5 do
          write(i)
          os.sleep(1)
        end
      end
    end
  end


  term.clear()
  for i = 1, #nModules do
    modules[nModules[i]] = require(nModules[i])
    modules[nModules[i]]._initialized = false

    local function a()
      local ok, comb = initialize(modules[nModules[i]])
      if type(comb) == "function" then
        ars[#ars + 1] = comb
      end
    end
    local function b()
      printInit(nModules[i], i, #nModules)
    end
    parallel.waitForAny(a, b)
    printInit("", i, #nModules, true)
  end
  controller = require(moduleData.controller)
  controller.init(initData)

  return ars
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
  local function go()
    controller.go(modules)
  end

  initialize()
  local ars = initializeModules(moduleData.modules)
  parallel.waitForAll(go, table.unpack(ars))
end
---------------------END: MAIN---------------------

---------------------START: Pcall---------------------
local ok, err = pcall(main)

if not ok then
  if controller then
    if err ~= "Terminated" and err ~= "Modu halted." then
      initializeModules(moduleData.limpModules)
      pcall(controller.err,err)
      local ok, err = pcall(controller.go, modules, true)
      if not ok then
        pcall(controller.warn, "Failed to start Limp Mode. Check the console"
                              .. " for details")
      end
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
