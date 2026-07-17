# Circular Dependencies

Circular dependencies occur when services directly or indirectly depend on themselves.

## Example

```
InventoryService

↓

DatabaseService

↓

EconomyService

↓

InventoryService
```

Without detection this causes infinite recursion.

Luau DI validates the dependency graph before startup.

Attempting to resolve the example above throws:

```text
Circular dependency detected involving 'InventoryService'
```

Resolve circular dependencies by extracting shared logic into a separate service.
