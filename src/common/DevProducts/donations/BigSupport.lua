return {
    name = script.Name,
    productId = 467033474,
    onSale = true,

    onProductPurchase = (function(player, server)
        -- Do nothing, this is a donation

        return true -- Successful
    end)
}