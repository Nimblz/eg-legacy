local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))

local Logger = PizzaAlpaca.GameModule:extend("Logger")

local LOG_FORMAT_STRING = "[%s][%s]: %s"

local logtype = {
    OUTPUT = 1,
    WARNING = 2,
    SEVERE = 3,
}

local logtypeNames = {
    [logtype.OUTPUT] = "OUTPUT",
    [logtype.WARNING] = "WARNING",
    [logtype.SEVERE] = "SEVERE",
}

local printFuncs = {
    [logtype.OUTPUT] = print,
    [logtype.WARNING] = warn,
    [logtype.SEVERE] = function(msg)
        -- Todo: send this to a webserver so nim can review it
        error(msg,3) -- delicious red text.
    end
}

function Logger:create() -- constructor, fired on instantiation, core will be nil.
    self.logtype = logtype
end

function Logger:createLogger(module)
    local logger = {}
    logger.logtype = logtype

    function logger:log(msg,severity)
        severity = severity or logtype.OUTPUT
        printFuncs[severity or logtype.OUTPUT](LOG_FORMAT_STRING:format(
            tostring(module),
            tostring(logtypeNames[severity]),
            tostring(msg))
        )
    end

    return logger
end

return Logger