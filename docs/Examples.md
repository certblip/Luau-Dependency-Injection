# Examples

## Registering

A service definition is a table. You can register it inline or from a module.

```lua
DI:Register({
    Name = "DatabaseService",
    Lifetime = "Singleton",
    Dependencies = {},
    Constructor = function(resolve)
        return {}
    end,
})
```

Or register a definition returned by a module:

```lua
local DatabaseService = require(script.DatabaseService)
DI:Register(DatabaseService)
```

---

## Loading a folder (recursive)

```lua
DI:Load(script.Services)
```

---

## Resolving

```lua
local Inventory = DI:Get("InventoryService")
```

---

## Constructor injection

```lua
Constructor = function(resolve)
    local Database = resolve("DatabaseService")
    -- ...
end
```

---

## Lifetimes

Use the string directly, or the exported `Lifetime` table:

```lua
Lifetime = "Singleton"
Lifetime = "Transient"

-- or
local LuauDI = require(ReplicatedStorage.Packages.LuauDI)
Lifetime = LuauDI.Lifetime.Singleton
```

---

## Isolated container (tests)

```lua
local LuauDI = require(ReplicatedStorage.Packages.LuauDI)

local container = LuauDI.new()
container:Register({ ... })
container:Initialize()
```
