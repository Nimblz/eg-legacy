local MarketplaceService = game:GetService("MarketplaceService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("remote")

local supportEvent = remote:WaitForChild("SupportClicked")


MarketplaceService.ProcessReceipt = function()
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

supportEvent.OnServerEvent:connect(function(player,id)
    assert(id and type(id) == "number")

	MarketplaceService:PromptProductPurchase(player,id or 467033474)
end)