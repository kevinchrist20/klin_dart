# Skill: avoid_string_literals_in_logic

## Overview

**Rule name:** `avoid_string_literals_in_logic`  
**Severity:** Warning  
**Category:** Best Practices

Flags raw string literals used inside conditions, comparisons, or other logic constructs. Relying on hardcoded strings in logic leads to fragile code that is difficult to refactor and prone to subtle typo-driven bugs (primitive obsession).

## When It Triggers

This rule fires when a string literal appears in a **logic context**, such as:

- Equality comparisons (`==`, `!=`) inside an `if`, ternary, `while`, or `switch` expression
- Switch-case pattern values
- Assignments to variables whose name contains a domain keyword (`status`, `type`, `role`, `level`, `plan`, `membership`, `category`)
- Arguments to method invocations whose name contains `check`, `update`, `change`, `set`, `compare`, or `is`
- Named parameters whose name contains `type` or `status`

Blank/whitespace-only strings are ignored.

## Bad Examples

```dart
// ❌ String literal in an equality check
if (status == 'active') { ... }

// ❌ String literal in a switch case
switch (role) {
  case 'admin': ...
  case 'user': ...
}

// ❌ String literal assigned to a logic-driving variable
final state = 'loading';
```

## Good Examples

```dart
// ✅ Use an enum for status values
enum UserStatus { active, inactive }

if (status == UserStatus.active) { ... }

// ✅ Use named constants
const String kRoleAdmin = 'admin';
const String kRoleUser  = 'user';

switch (role) {
  case kRoleAdmin: ...
  case kRoleUser: ...
}

// ✅ Enum-based state
enum LoadState { loading, loaded, error }
final state = LoadState.loading;
```

## How to Fix

Replace raw string literals in logic with:

- **Enums** — Model a closed set of possible values as a Dart `enum`. This gives exhaustiveness checking and removes all magic strings at once.
- **Constants** — When an enum is not appropriate, define `const String` or `const` values in a shared constants file.

## Configuration

This rule is enabled with a fixed `WARNING` severity and currently has no configurable options.

## Why This Matters

- **Typo prevention** — A misspelled string compiles silently but fails at runtime; a wrong enum value is caught immediately by the compiler.
- **Refactoring safety** — Renaming a constant or enum value is a single, IDE-assisted change; hunting down string literals scattered across the codebase is error-prone.
- **Expressiveness** — Enums and constants communicate intent far more clearly than opaque string literals.
