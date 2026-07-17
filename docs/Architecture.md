# Architecture

Luau DI is designed around inversion of control (IoC), allowing services to remain loosely coupled while the container manages object creation.

## Components

```
DIContainer
    │
    ├── Resolver
    ├── DependencyGraph
    ├── Lifecycle
    └── ServiceLoader
```

### DIContainer

The central registry responsible for:

- Registering services
- Resolving dependencies
- Creating instances
- Managing service lifetimes

---

### Resolver

Provides dependency lookup for constructors.

Instead of manually requiring services:

```lua
local Database = require(...)
```

services receive dependencies through constructor injection.

```lua
local Database = resolve("DatabaseService")
```

---

### DependencyGraph

Records every dependency requested during construction.

The graph is validated before startup to detect cycles.

---

### Lifecycle

Controls startup order.

```
Register
↓

Validate

↓

Instantiate

↓

Init()

↓

Start()
```

Every service is initialized before any service starts.

---

### ServiceLoader

Automatically registers every ModuleScript inside a folder.
