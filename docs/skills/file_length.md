# Skill: file_length

## Overview

**Rule name:** `file_length`  
**Severity:** Warning  
**Category:** Best Practices

Warns when a Dart source file contains more total lines, excluding `import` directives, than a configurable threshold. Overly large files are a sign that a single file is carrying too many responsibilities, making it harder to navigate, review, and maintain.

## Threshold

| Default maximum |
|----------------|
| **500 lines** (excluding import statements) |

Import directives are excluded from the count because they are boilerplate and do not represent meaningful logic or UI code.

## When It Triggers

The rule counts the total lines in the file and then subtracts the line span of every `import` directive. If the adjusted count exceeds the configured maximum, a warning is reported on the compilation unit.

## Bad Examples

```dart
// ❌ A 600-line file that mixes models, UI helpers, and business logic

// models.dart  (620 non-import lines)
class UserModel { ... }
class OrderModel { ... }
class ProductModel { ... }
// ... dozens more classes and helpers ...
```

## Good Examples

```dart
// ✅ Split by responsibility into focused, smaller files

// user_model.dart       (~40 lines)
// order_model.dart      (~50 lines)
// product_model.dart    (~45 lines)
// order_repository.dart (~80 lines)
```

## How to Fix

- **Split by feature** — Group related code into feature-specific files or directories (e.g., `features/orders/`, `features/users/`).
- **Split by layer** — Separate models, repositories, view-models, and widgets into distinct files.
- **Extract utilities** — Move standalone helper functions and extension methods into dedicated utility files.
- **One public symbol per file** — A common convention is to have exactly one top-level class, enum, or function per file, mirroring how many other ecosystems structure their code.

## Configuration

The threshold is configurable per project via `analysis_options.yaml`:

```yaml
custom_lint:
  rules:
    - file_length:
        max_lines: 500   # default: 500
```

Lower the value for stricter projects or raise it for files that are intentionally large (e.g., generated code wrappers).

## Why This Matters

- **Navigation** — Smaller files are faster to scan and easier to search within.
- **Code review** — Pull requests that touch large files are harder to review confidently.
- **Conflict reduction** — Splitting code across files reduces merge conflicts when multiple developers work in parallel.
- **Discoverability** — A file that does one thing has a clear, predictable name — making it easy for new contributors to find what they need.
