-- get text size, but no wrapping. 1 px of padding at end.

local TextService = game:GetService("TextService")

local INF_SIZE = Vector2.new(math.huge,math.huge)

return function (text,font,size)
    font = font or Enum.Font.SourceSans
    size = size or 12
    local textSize = TextService:GetTextSize(text,size,font,INF_SIZE)
    return Vector3.new(textSize.X + 1, textSize.Y)
end