# Luau DI

A lightweight dependency injection container for Roblox that automatically
resolves service dependencies, detects circular references, and manages
service lifecycles.

Built for Roblox projects following the Dependency Inversion Principle (DIP)
and SOLID architecture.

## Features

- Automatic dependency resolution via constructor injection
- Singleton and Transient lifetimes
- Circular dependency detection — both statically (before construction) and
  at runtime
- Dependency graph validation and topological ordering
- Deterministic lifecycle management (`Init` / `Start` in dependency order)
- `Dispose` support for resource cleanup
- Isolated containers via `LuauDI.new()` (ideal for tests and scopes)
- Zero runtime dependencies, framework agnostic
- Fully typed (`--!strict`)

## Installation

### Wally

```toml
[dependencies]
LuauDI = "certblip/luau-di@1.0.0"
```

### Rojo

Clone the repository and point Rojo at `src`:

```json
{
    "tree": {
        "$className": "DataModel",

        "ReplicatedStorage": {
            "Packages": {
                "LuauDI": {
                    "$path": "src"
                }
            }
        }
    }
}
```

## Registering services

A service is a table with a `Name`, a `Constructor`, and optionally a
`Lifetime` (defaults to `"Singleton"`) and a `Dependencies` list.

```lua
local DI = require(ReplicatedStorage.Packages.LuauDI)

DI:Register({
    Name = "DatabaseService",
    Lifetime = "Singleton",
    Dependencies = {},
    Constructor = function(resolve)
        return {}
    end,
})

DI:Register({
    Name = "InventoryService",
    Lifetime = "Singleton",
    Dependencies = { "DatabaseService" },
    Constructor = function(resolve)
        local Database = resolve("DatabaseService")
        local self = {}
        return self
    end,
})
```

Declaring `Dependencies` lets the container validate the whole graph — and
catch circular references — *before* any service is constructed. It is
optional: dependencies pulled in via `resolve(...)` are still detected at
runtime.

## Resolving services

```lua
DI:Initialize() -- resolves singletons and runs Init()/Start() in order

local InventoryService = DI:Get("InventoryService")
InventoryService:AddItem(player.UserId, "Sword")
```

## Auto-loading a folder

```lua
DI:Load(ReplicatedStorage.Services) -- recursively registers + validates
DI:Initialize()
```

## Isolated containers

The default `DI` is a shared container. For tests or independent scopes,
create isolated ones:

```lua
local LuauDI = require(ReplicatedStorage.Packages.LuauDI)

local container = LuauDI.new()
container:Register({ ... })
container:Initialize()
```

## Lifecycle

Services may implement any of these optional methods:

- `Init()` — called in dependency order (dependencies first).
- `Start()` — called after every service has finished `Init()`.
- `Dispose()` — called by `DI:Dispose()` / `DI:Clear()` in reverse order.

## Project structure

```text
src/
├── Core/
│   ├── DIContainer.lua
│   ├── DependencyGraph.lua
│   ├── Lifecycle.lua
│   ├── Resolver.lua
│   └── ServiceLoader.lua
├── Interfaces/
├── Types/
└── init.lua

demo/
docs/
test/
```

## Roadmap

- Scoped services
- Interface injection
- Attribute auto registration
- Async initialization
- Service profiling
- Hot reloading

## License

Licensed under the MIT License.
