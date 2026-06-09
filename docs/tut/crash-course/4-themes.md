# Themes

## Predefined Themes
Sling comes with a dark theme (`default`) and a light theme (`light`).

```luau
-- Switch to the light theme
sling.setTheme(sling.themes.light)

-- Switch to the default dark theme
sling.setTheme(sling.themes.default)
```

## Custom Themes
You can also define your own custom theme by passing a config table matching the `ThemeConfig` structure:

```luau
local customWoodTheme = {
    backgroundColor = Color3.fromHex("#492a17"),
    textColor = Color3.fromHex("#e09e74"),
    slotTextColor = Color3.fromHex("#ffffff"),
} :: sling.ThemeConfig

sling.setTheme(customWoodTheme)
```