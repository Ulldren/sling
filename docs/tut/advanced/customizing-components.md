# Customizing Components

While custom themes let you easily adjust colors, fonts, sizes, and corner radiuses, you might sometimes want to change the actual layout, structure, or behavior of the user interface. 

To customize Sling beyond standard themes, you can modify its UI components directly.

## Where to Find Components

All interface components are written as declarative Luau modules using [Vide](https://github.com/centau/vide) and are located in the [components](https://github.com/encodedlux/sling/tree/main/src/ui/components) directory:

* **[backpack.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/backpack.luau):** The main wrapper frame that positions both the inventory and the hotbar on the screen.
* **[hotbar.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/hotbar.luau):** Renders the quick-access hotbar slots at the bottom.
* **[inventory.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/inventory.luau):** Renders the main inventory overlay panel, including the search bar, category tabs, and item grid.
* **[slot.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/slot.luau):** Renders individual item slots, handling hover states, icons, visual borders, and numbers.
* **[tooltip.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/tooltip.luau):** Renders the hover description for tools.
* **[gamepadHints.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/gamepadHints.luau):** Renders visual key guidance indicators at the top of the inventory for controller/console players.
* **[categorybar.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/categorybar.luau):** Renders the category tabs for the inventory.
* **[searchbar.luau](https://github.com/encodedlux/sling/tree/main/src/ui/components/searchbar.luau):** Renders the search bar for the inventory.