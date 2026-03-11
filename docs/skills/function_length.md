# Skill: function_length

## Overview

**Rule name:** `function_length`  
**Severity:** Warning  
**Category:** Best Practices

Enforces a maximum number of lines for functions, methods, and function expressions. Overly long functions are harder to read, test, and maintain. This rule encourages developers to break logic into smaller, single-purpose units.

## Thresholds

| Context | Default maximum |
|---------|----------------|
| Regular functions and methods | **50 lines** |
| Widget `build` methods | **100 lines** |

The higher limit for `build` methods acknowledges that Flutter widget trees are inherently verbose, while still preventing runaway UI code.

## When It Triggers

The rule measures the line span from the opening brace of a function/method body to its closing brace. It is applied to:

- Top-level function declarations
- Class method declarations
- Anonymous function expressions (unless used as a direct argument in a method invocation)

## Bad Examples

```dart
// ❌ A regular method exceeding 50 lines
class OrderService {
  Future<void> processOrder(Order order) async {
    // ... 60 lines of mixed logic ...
  }
}

// ❌ A build method exceeding 100 lines
@override
Widget build(BuildContext context) {
  return Scaffold(
    // ... 120 lines of widget tree ...
  );
}
```

## Good Examples

```dart
// ✅ Break logic into focused helpers
class OrderService {
  Future<void> processOrder(Order order) async {
    await _validateOrder(order);
    await _applyDiscounts(order);
    await _saveOrder(order);
  }

  Future<void> _validateOrder(Order order) async { ... }
  Future<void> _applyDiscounts(Order order) async { ... }
  Future<void> _saveOrder(Order order) async { ... }
}

// ✅ Extract widgets to keep build methods concise
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(context),
    body: _buildBody(context),
  );
}

Widget _buildAppBar(BuildContext context) { ... }
Widget _buildBody(BuildContext context) { ... }
```

## How to Fix

- **Extract helper methods** — Move logically cohesive blocks of code into private methods with descriptive names.
- **Extract widgets** — In Flutter, large `build` methods should be split into smaller private widget-building methods or dedicated `StatelessWidget` / `StatefulWidget` subclasses.
- **Apply the Single Responsibility Principle** — Each function should do one thing and do it well.

## Configuration

The default maximum line counts are defined as constants in the rule implementation:

```dart
static const _defaultMaxLines = 50;        // regular functions
static const buildMethodMaxLines = 100;    // widget build methods
```

These can be adjusted by modifying the rule source or by extending the rule in a custom lint configuration.

## Why This Matters

- **Readability** — Short functions fit on a single screen, making them easy to understand at a glance.
- **Testability** — Smaller functions have fewer execution paths, making unit tests straightforward.
- **Reusability** — Well-named helper methods can often be reused across the codebase.
