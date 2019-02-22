local MarketplaceService = game:GetService("MarketplaceService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("remote")
local common = ReplicatedStorage:WaitForChild("common")

local DevProducts = require(common:WaitForChild("DevProducts"))

local supportEvent = remote:WaitForChild("SupportClicked")

local Cashier = {}

MarketplaceService.ProcessReceipt = (function(info)
	return Enum.ProductPurchaseDecision.NotProcessedYet
end)

supportEvent.OnServerEvent:connect(function(player,id)
    assert(id and type(id) == "number")

	MarketplaceService:PromptProductPurchase(player,id or 467033474)
end)

return Cashier