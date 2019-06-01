local pointAABBIntersect = require(script.Parent:WaitForChild("pointAABBIntersect"))

return function(point, part)
    local transformedPoint = part.CFrame:PointToObjectSpace(point)

    return pointAABBIntersect(transformedPoint,Vector3.new(0,0,0),part.Size)
end