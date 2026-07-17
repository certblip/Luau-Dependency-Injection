# Examples

## Registering

```lua
DI:Register(DatabaseService)
```

---

## Loading

```lua
DI:Load(script.Services)
```

---

## Resolving

```lua
local Inventory = DI:Get("InventoryService")
```

---

## Constructor Injection

```lua
Constructor = function(resolve)

    local Database = resolve("DatabaseService")

end
```

---

## Singleton

```lua
Lifetime.Singleton
```

---

## Transient

```lua
Lifetime.Transient
```
