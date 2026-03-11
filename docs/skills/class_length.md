# Skill: class_length

## Overview

**Rule name:** `class_length`  
**Severity:** Warning  
**Category:** Best Practices

Prevents classes from growing beyond a configurable line limit. Excessively long classes are a symptom of violating the Single Responsibility Principle — they tend to accumulate unrelated logic over time and become difficult to understand, test, and modify.

## Thresholds

| Context | Default maximum |
|---------|----------------|
| Regular classes | **200 lines** |
| `StatefulWidget` classes | **300 lines** |

`StatefulWidget` subclasses receive a higher allowance because they naturally contain both the widget shell and the associated `State` class code.

## When It Triggers

The rule measures the total line span of a class declaration — from the opening `class` keyword to the closing brace. It fires when that span exceeds the applicable threshold.

## Bad Examples

```dart
// ❌ A service class that has grown to 250 lines by accumulating
//    unrelated responsibilities (data access, formatting, validation, etc.)
class UserService {
  // ... 250 lines of mixed concerns ...
}

// ❌ A StatefulWidget whose State class contains 350 lines
//    of interleaved lifecycle, UI, and business logic
class DashboardPage extends StatefulWidget { ... }
class _DashboardPageState extends State<DashboardPage> {
  // ... 350 lines ...
}
```

## Good Examples

```dart
// ✅ Each class has a single, well-defined responsibility
class UserRepository {
  // Data access only — well under 200 lines
}

class UserValidator {
  // Validation logic only
}

class UserFormatter {
  // Display formatting only
}

// ✅ Extract business logic from a StatefulWidget's State
class DashboardPage extends StatefulWidget { ... }
class _DashboardPageState extends State<DashboardPage> {
  // Delegates complex logic to a dedicated controller/bloc
}

class DashboardController {
  // Business and state management logic, separately testable
}
```

## How to Fix

- **Apply the Single Responsibility Principle** — Identify distinct concerns inside the class and extract each into its own class.
- **Use mixins** — Share reusable behaviour across classes without duplicating code.
- **Introduce controllers, repositories, or services** — In Flutter, move business logic and data access out of widgets and into dedicated classes.
- **Extract sub-widgets** — If a `StatefulWidget` is long because of a complex widget tree, extract portions into separate `StatelessWidget` classes.

## Configuration

The default thresholds are defined as constants in the rule implementation:

```dart
static const _defaultMaxLines        = 200;  // regular classes
static const _statefulWidgetMaxLines = 300;  // StatefulWidget subclasses
```

The `maxLines` parameter can be overridden when constructing the rule, allowing projects to tune the threshold to their standards.

## Why This Matters

- **Maintainability** — Smaller classes are easier to navigate and reason about.
- **Testability** — Focused classes with few dependencies are straightforward to unit test.
- **Collaboration** — Shorter files produce smaller, less conflicting diffs in version control.
- **Design quality** — Class length is often a reliable indicator of design problems; enforcing a limit encourages better architecture from the start.
