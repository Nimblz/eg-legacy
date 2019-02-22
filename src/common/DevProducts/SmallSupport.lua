return {
    name = script.Name,
    productId = 467030266,

    onProductPurchase = (function(player, server, product)
        -- Do nothing, this is a donation

        return true -- Successful
    end)
}