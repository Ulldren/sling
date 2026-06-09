# Themes

Sling offers a powerful, flexible theme system that lets you customize the styling, colors, and layout properties of your backpack.

## Predefined Themes
Sling comes with a dark theme (`default`) and a light theme (`light`) built-in.

:::tabs
== Dark Theme (Default)
![Default Dark Theme](/dark-theme.png)

== Light Theme
![Light Theme](/light-theme.png)
:::

To apply a predefined theme:

```luau
-- Switch to the light theme
sling.setTheme(sling.themes.light)

-- Switch to the default dark theme
sling.setTheme(sling.themes.default)
```

## Custom Themes
You can define your own custom theme by passing a config table matching the `ThemeConfig` structure. Any properties left blank will fall back to the default theme settings.

![Custom Ristretto Theme](/custom-theme.png)

Here is how you would define and apply a custom theme (like the *Ristretto* theme pictured above):

```luau
local ristretto: sling.ThemeConfig = {
	backgroundColor = Color3.fromHex("#2c2525"),
	slotEquipStrokeColor = Color3.fromHex("#e4b9b9"),
	searchStrokeColor = Color3.fromHex("#e4b9b9"),
	textColor = Color3.fromHex("#e4b9b9"),
	fontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
}

sling.setTheme(ristretto)
```