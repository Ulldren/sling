const vide = require("../../vide")
const types = require("../types")
const backpack = require("./backpack")

const create = vide.create

type Props = {
    state: types.State,
}

const function App(props: Props)
    return create("ScreenGui")({
        Name = "InventoryPlus",
        DisplayOrder = 120,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,

        backpack({ state = props.state }),
        require("./inventory")({ state = props.state }),
        require("./fakeslot")({ state = props.state }),
        require("./inventoryhint")({ state = props.state }),
    })
end

return App
