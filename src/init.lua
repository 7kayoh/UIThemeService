-- UIThemeService.lua
-- @7kayoh

local CollectionService = game:GetService("CollectionService")

local UIThemeService = {}
UIThemeService._FALLBACK_COLOR = Color3.new()
UIThemeService._FALLBACK_TRANSPARENCY = 0
UIThemeService._THEME = {}

function UIThemeService.apply(object: Instance, dataName: string, colorProperty: string?, transparencyProperty: string?)
    CollectionService:AddTag(object, "UIThemeServiceLinked")
    CollectionService:AddTag(object, "t" .. dataName)
    object:SetAttribute(dataName .. "Color", colorProperty)
    object:SetAttribute(dataName .. "Transparency", transparencyProperty)

    local item = UIThemeService._THEME[dataName] or {}

    item.Color = item.Color or UIThemeService._FALLBACK_COLOR
    item.Transparency = item.Transparency or UIThemeService._FALLBACK_TRANSPARENCY

    if colorProperty and object[colorProperty] then
        object[colorProperty] = item.Color
    end

    if transparencyProperty and object[transparencyProperty] then
        object[transparencyProperty] = item.Transparency
    end
end

function UIThemeService.newTheme(themeData: {any})
    -- theme data example:
    --[[
        ["ItemName"] = {
            Color = Color3.fromRGB(200, 200, 200),
            Transparency = 0.5
        }
    --]]
    UIThemeService._THEME = themeData
    for _, object in ipairs(CollectionService:GetTagged("UIThemeServiceLinked")) do
        for name, value in pairs(UIThemeService._THEME) do
            print(name, value)
            if CollectionService:HasTag(object, "t" .. name) then
                local color = object:GetAttribute(name .. "Color")
                local transparency = object:GetAttribute(name .. "Transparency")

                value = value or {}
                value.Color = value.Color or UIThemeService._FALLBACK_COLOR
                value.Transparency = value.Transparency or UIThemeService._FALLBACK_TRANSPARENCY

                if color and object[color] then
                    object[color] = value.Color
                end
    
                if transparency and object[transparency] then
                    object[transparency] = value.Transparency
                end
            end
        end
    end
end

return UIThemeService