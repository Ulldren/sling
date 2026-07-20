# Server Authoritative

Under Roblox's **Server Authority** model, client-side actions (like shifting tool parents or calling `Humanoid:EquipTool()`) are rejected by the server to prevent inventory exploits.

Sling supports Server Authority out of the box through `setEquipHandler`. This lets you delegate tool equipping and unequipping to your own network and server scripts.

## Setting Up the Client Handler

Using `setEquipHandler`, you can override Sling's default client-side equipping and call your own RemoteEvent instead.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipToolRemote = ReplicatedStorage:WaitForChild("EquipTool") :: RemoteEvent

Sling.setEquipHandler(function(tool)
    -- Fire the remote to the server
    -- 'tool' is nil when unequipping
    EquipToolRemote:FireServer(tool)
end)
```

## Setting Up the Server Validator

On the server, you listen to the remote, validate that the player actually owns the tool, and physically equip/unequip the tool.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipToolRemote = Instance.new("RemoteEvent")
EquipToolRemote.Name = "EquipTool"
EquipToolRemote.Parent = ReplicatedStorage

EquipToolRemote.OnServerEvent:Connect(function(player: Player, tool: Tool?)
    local character = player.Character
    if not character then
        return
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return
    end

    if tool then
        humanoid:EquipTool(tool)
    else
        humanoid:UnequipTools()
    end
end)
```

## Instant Visual Feedback (Prediction)

Sling's UI updates automatically by watching character child replication events. The UI will instantly transition the active slot selection on click while the server processes and replicates the physics change, ensuring a lag-free experience for the player.
