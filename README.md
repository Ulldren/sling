<p align="center">
  <p align="center">
    <img alt="Sling" src="docs/public/logo.svg" height="100">
  </p>
  <h1 align="center"><b>Sling</b></h1>
  <p align="center">
    A modern and reactive backpack UI for Roblox.
  </p>
</p>

<div align="center">

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/encodedlux/sling/CI.yml?style=for-the-badge&branch=main&logo=github)
[![GitHub Release](https://img.shields.io/github/v/release/encodedlux/sling?style=for-the-badge&logo=github)](https://github.com/encodedlux/sling/releases/latest)
[![Docs](https://img.shields.io/badge/docs-online-blue?style=for-the-badge&logo=gitbook)](https://encodedlux.github.io/sling/)
[![Sling Demo](https://img.shields.io/badge/Try_in_roblox-blue?style=for-the-badge&logo=roblox)](https://www.roblox.com/games/128963890251413)
[![GitHub License](https://img.shields.io/github/license/encodedlux/sling?style=for-the-badge)](LICENSE)

</div>

## About

Sling is a modern and reactive backpack UI designed for Roblox experiences. It replaces the default backpack system, giving you complete freedom to customize the interface however you want, dynamically categorize inventory items, and use or create custom themes.

<img alt="Sling Preview" src="docs/public/computer-inventory.png" width="100%">
<img alt="Sling Phone" src="docs/public/phone-inventory.png" width="74%">
<img alt="Sling Portrait" src="docs/public/portrait-inventory.png" width="24%">

---

## Features
* [**Custom Categorization** 🎒](https://encodedlux.github.io/sling/tut/crash-course/3-category) - Group your inventory items into tab categories (e.g., Weapons, Potions, Resources) using simple, custom declarative predicate functions.
* [**Custom Themes** 🎨](https://encodedlux.github.io/sling/tut/crash-course/4-themes) - Customize theme properties, switch between predefined themes (default and light), or define your own.
* [**Subscribe to Events** 🔔](https://encodedlux.github.io/sling/tut/crash-course/5-events) - Track when the player interacts with their backpack, equips items, or when items are added/removed.
* [**Manage Hotbar** 🔢](https://encodedlux.github.io/sling/tut/crash-course/6-hotbar) - Track when the user rearranges items and programmatically set which items should be placed in the hotbar.

---

## Installation

### Github Releases

1. Download the `sling.rbxm` model file from the [Github Releases](https://github.com/encodedlux/sling/releases/latest).
2. Open Roblox Studio and create a new place or open an existing place.
3. In the Explorer window, insert **Sling** into **ReplicatedStorage**.
4. Select the **Sling** model file you downloaded from GitHub.

**Sling** uses [RunContext](https://devforum.roblox.com/t/live-script-runcontext/1938784) to run anywhere, so you do not need to move it from Workspace, though it is recommended to parent it to **ReplicatedStorage** for better practices and organization.

### Wally

Add **Sling** to your `wally.toml` dependencies:
```toml
[dependencies]
sling = "encodedlux/sling@0.1.2"
```
Then, run `wally install` in your project folder.

---

## Documentation

- See the [documentation](https://encodedlux.github.io/sling/) for more about Sling. Follow the guides of usage and customization to get the most out of Sling.

## Credits

- Heavily inspired off [Satchel](https://github.com/ryanlua/satchel). This project started with the idea of creating a more practical and customizable version of the backpack system by using [Vide](https://github.com/centau/vide).

---

## License

Sling is licensed under the MIT License - see the [LICENSE](LICENSE) for details.