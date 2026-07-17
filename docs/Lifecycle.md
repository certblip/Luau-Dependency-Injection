# Service Lifecycle

Every service follows the same startup sequence.

```
Register

↓

Validate

↓

Construct

↓

Init()

↓

Start()
```

## Constructor

Executed once when the service is first resolved.

Use constructors to receive dependencies.

Avoid expensive work.

---

## Init

Called after every service has been instantiated.

Use Init for:

- Loading configuration
- Connecting signals
- Creating caches

---

## Start

Called after every Init has completed.

Use Start for:

- Starting loops
- Background tasks
- External communication

This guarantees every dependency is fully initialized.
