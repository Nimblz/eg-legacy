local FuncUtils = {}

function FuncUtils.isFunc(x)
	return type(x) == "function"
end

function FuncUtils.callOnAll(tbl,funcName,...)
	assert(type(tbl) == "table", "expected table in arg 1")
	assert(type(funcName) == "string", "expected function in arg 2")

	for name,module in pairs(tbl) do
		if FuncUtils.isFunc(module[funcName]) then
			print(name,"-",funcName)
			module[funcName](module,...)
		end
	end
end

return FuncUtils