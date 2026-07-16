# Luau DI

A lightweight dependency injection container for Roblox that automatically resolves service dependencies, detects circular references, and manages service lifecycles.

Built for large-scale Roblox projects following the Dependency Inversion Principle (DIP) and SOLID architecture.

## Features

- Automatic dependency resolution
- Constructor injection
- Singleton services
- Circular dependency detection
- Dependency graph validation
- Service lifecycle management
- Lazy initialization
- Zero runtime dependencies
- Framework agnostic
- Typed Luau support

## Installation

### Wally

```toml
[dependencies]
LuauDI = "certblip/luau-di@1.0.0"
```

### Rojo

Clone the repository.

```bash
git clone https://github.com/certblip/luau-di.git
```

Add the project to your `default.project.json`.

```json
{
    "tree": {
        "$className": "DataModel",

        "ReplicatedStorage": {
            "Packages": {
                "LuauDI": {
                    "$path": "luau-di/src"
                }
            }
        }
    }
}
```

Or, if you use Wally:

```bash
wally install
rojo serve
```

## Basic Example

```lua
local DI = require(ReplicatedStorage.Packages.LuauDI)

local InventoryService = DI:Get("InventoryService")

InventoryService:AddItem(player, "Sword")
```

## Registering Services

```lua
DI:Register("DatabaseService", DatabaseService)
DI:Register("InventoryService", InventoryService)
DI:Register("EconomyService", EconomyService)
```

## Constructor Injection

```lua
return {
    Name = "InventoryService",

    Create = function(resolve)

        local Database = resolve("DatabaseService")

        local self = {}

        return self
    end
}
```

No manual `require()` calls are needed between services.

## Project Structure

```text
src/
├── Core/
│   ├── DIContainer.lua
│   ├── DependencyGraph.lua
│   ├── Lifecycle.lua
│   ├── Resolver.lua
│   └── ServiceLoader.lua
│
├── Interfaces/
├── Types/
└── init.lua

demo/

docs/

test/
```

## Roadmap

- Scoped services
- Transient services
- Interface injection
- Attribute auto registration
- Async initialization
- Service profiling
- Hot reloading

## License

This project is licensed under the MIT License.
