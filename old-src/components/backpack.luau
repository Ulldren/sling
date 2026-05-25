const vide = require("../../vide")
const types = require("../types")
const hotbar = require("./hotbar")

const create = vide.create

type Props = {
    state: types.State,
}

const function backpack(props: Props)
    return create("Frame")({
        Name = "Backpack",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        hotbar({ state = props.state }),
    })
end

return backpack
