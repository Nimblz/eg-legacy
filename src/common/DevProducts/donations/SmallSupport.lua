return {
    id = "smallsupport",
    name = "Support (30R)",
    productId = 467030266,
    onSale = true,

    order = 100,

    onProductPurchase = (function(player, server)
        -- Do nothing, this is a donation

        return true -- Successful
    end)
}