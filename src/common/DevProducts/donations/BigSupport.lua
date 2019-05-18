return {
    id = "bigsupport",
    name = "Big Support (100R)",
    productId = 467033474,
    onSale = true,

    order = 101,

    onProductPurchase = (function(player, server)
        -- Do nothing, this is a donation

        return true -- Successful
    end)
}