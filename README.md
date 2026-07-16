# DependencyInjection

A lightweight dependency injection container for Roblox.

Automatically resolves service dependencies, detects circular references, and manages service lifetimes.

## Features

- Constructor Injection
- Singleton Services
- Circular Dependency Detection
- Automatic Service Resolution
- Dependency Graph
- Lifecycle Management
- Framework Agnostic
- Typed Luau Support

---

## Example

```lua
local Inventory = resolve("InventoryService")
```

No manual require statements.

The container resolves everything automatically.

---

## Installation

Clone the repository

```bash
git clone https://github.com/USERNAME/DependencyInjection.git
```

or install using Wally.

---

## Project Structure

```
src/
demo/
docs/
test/
```

---

## Example Services

```
DatabaseService
InventoryService
EconomyService
PlayerService
```

---

## Roadmap

- Scoped Services
- Transient Services
- Interface Injection
- Attribute Auto Registration
- Async Initialization
- Service Profiling
- Hot Reloading

---

## License

MIT
