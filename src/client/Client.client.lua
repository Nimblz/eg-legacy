local PlayerScripts = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("common")
local Lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = Lib:WaitForChild("pizzaalpaca")
local PizzaAlpaca_Object = PizzaAlpaca:WaitForChild("object")
local PizzaAlpaca_Module = PizzaAlpaca:WaitForChild("module")

local PRINT_DEBUG = true

-- Create new modulemanager with debug prints on
local ModuleManager = require(PizzaAlpaca_Object:WaitForChild("ModuleManager")).new(PRINT_DEBUG)

-- Adds all child modules in an instance to the loading queue. This is not recursive.
ModuleManager:AddModuleDirectory(PizzaAlpaca_Module)
ModuleManager:AddModuleDirectory(PlayerScripts:WaitForChild("module"))
ModuleManager:AddModuleDirectory(Common:WaitForChild("module"))

-- After all modules are added, load them, init them, then start them.
ModuleManager:LoadAllModules()
ModuleManager:InitAllModules()
ModuleManager:StartAllModules()