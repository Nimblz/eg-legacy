local ReplicatedStorage = game:GetService("ReplicatedStorage")

local component = script.Parent
local common = ReplicatedStorage:WaitForChild("common")
local lib = ReplicatedStorage:WaitForChild("lib")

local Assets = require(common:WaitForChild("Assets"))
local Dictionary = require(common:WaitForChild("Dictionary"))
local Roact = require(lib:WaitForChild("Roact"))

local AssetButton = require(component:WaitForChild("AssetButton"))
local AssetGrid = Roact.Component:extend("AssetGrid")

function AssetGrid:shouldUpdate(nextProps)
    local newAssets = nextProps.assets

    local function find(assetId)
        for _,v in pairs(self.props.assets) do
            if v == assetId then
                return true
            end
        end
        return false
    end

    for _,assetId in pairs(newAssets) do
        if not find(assetId) then return true end
    end

    return false
end

function AssetGrid:render()
    local containerType = self.props.containerType or "Frame"
    local containerProps = self.props.containerProps
    local layoutProps = self.props.layoutProps
    local paddingProps = self.props.paddingProps
    local assets = self.props.assets or {}
    local assetElementType = self.props.assetElementType or AssetButton
    local assetElementProps = self.props.assetElementProps

    local padding
    if paddingProps then
        padding = Roact.createElement("UIPadding", paddingProps)
    end

    local assetElements = {}

    for idx,assetId in pairs(assets) do
        local asset = Assets.byId[assetId] or Assets.byId["fedora"]
        assetElements[assetId] = Roact.createElement(assetElementType, Dictionary.merge({
            asset = asset,
            LayoutOrder = idx,
        }, assetElementProps))
    end

    local children = Dictionary.merge(self.props[Roact.Children], {
        layout = Roact.createElement("UIGridLayout", Dictionary.merge({
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, layoutProps)),

        padding = padding,
    }, assetElements)

    return Roact.createElement(containerType, containerProps, children)
end

return AssetGrid