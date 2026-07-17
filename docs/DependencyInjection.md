# Dependency Injection

Dependency Injection is a design pattern where objects receive their dependencies from an external container instead of creating them manually.

## Without DI

```lua
local Database = require(...)
```

Problems:

- Tight coupling
- Difficult testing
- Hard to replace implementations
- Circular dependency issues

---

## With DI

```lua
local Database = resolve("DatabaseService")
```

The container is responsible for constructing the dependency.

---

## Constructor Injection

```lua
return {

    Name = "InventoryService",

    Constructor = function(resolve)

        local Database = resolve("DatabaseService")

        local self = {}

        return self

    end

}
```

Constructor injection is the recommended pattern for all services.
