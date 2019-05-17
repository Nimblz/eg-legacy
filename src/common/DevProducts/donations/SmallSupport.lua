return {
    name = script.Name,
    productId = 467030266,
    onSale = true,

    onProductPurchase = (function(player, server)
        -- Do nothing, this is a donation

        return true -- Successful
    end)
}