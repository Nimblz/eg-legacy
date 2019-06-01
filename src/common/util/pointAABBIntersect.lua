return function(point,aabbpos,aabbsize)
    if point.X > aabbpos.X + (aabbsize.X/2) then return false end
    if point.X < aabbpos.X - (aabbsize.X/2) then return false end
    if point.Y > aabbpos.Y + (aabbsize.Y/2) then return false end
    if point.Y < aabbpos.Y - (aabbsize.Y/2) then return false end
    if point.Z > aabbpos.Z + (aabbsize.Z/2) then return false end
    if point.Z < aabbpos.Z - (aabbsize.Z/2) then return false end

    return true
end