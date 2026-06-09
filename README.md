# Sling

A modern and reactive backpack system for Roblox, built using [Vide](https://github.com/centau/vide).

![Sling Preview](docs/public/inventory-preview.png)

---

## Installation

### Github Releases

1. Download the `Sling.rbxm` model file from the [Github Releases](https://github.com/encodedlux/sling/releases).
2. Open Roblox Studio and create a new place or open an existing place.
3. In the Explorer window, insert **Sling** into **ReplicatedStorage**.
4. Select the **Sling** model file you downloaded from GitHub.

**Sling** uses [RunContext](https://devforum.roblox.com/t/live-script-runcontext/1938784) to run anywhere, so you do not need to move it from Workspace, though it is recommended to parent it to **ReplicatedStorage** for better practices and organization.

### Wally

Add **Sling** to your `wally.toml` dependencies:
```toml
[dependencies]
sling = "encodedlux/sling@0.1.0"
```
Then, run `wally install` in your project folder.

---

## Documentation

- See the [documentation](https://encodedlux.github.io/sling/) for more about Sling. Follow the guides of usage and customization to get the most out of Sling.

## Credits

- Heavily inspired off [Satchel](https://github.com/ryanlua/satchel) by [ryanlua](https://github.com/ryanlua). This project started with the idea of creating a more practical and customizable version of the backpack system by using [Vide](https://github.com/centau/vide).

---

## License

Sling is licensed under the MIT License - see the [LICENSE](LICENSE) for details.