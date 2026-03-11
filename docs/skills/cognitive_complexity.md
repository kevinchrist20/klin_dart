# Skill: cognitive_complexity

## Overview

**Rule name:** `cognitive_complexity`  
**Severity:** Warning (medium complexity) / Error (high complexity)  
**Category:** Code Quality

Measures how difficult a function or method is to mentally understand. Unlike cyclomatic complexity, cognitive complexity penalises deeply nested control flow more heavily, reflecting how human readers actually experience reading code. Functions that are hard to understand are more likely to contain bugs and are harder to maintain or test.

## Complexity Categories

| Score range | Category | Severity |
|-------------|----------|----------|
| 0 – 10 | 🟢 Low | No report |
| 11 – 15 | 🟡 Medium | **Warning** |
| > 15 | 🔴 High | **Error** |

## Scoring Rules

The visitor increments complexity for each of the following constructs:

| Construct | Base increment | Nesting bonus |
|-----------|---------------|---------------|
| `if` statement | +1 | +1 per nesting level |
| `for` loop | +1 | +1 per nesting level |
| `while` loop | +1 | +1 per nesting level |
| `switch` statement | +1 | +1 per nesting level |
| `try` / `catch` block | +1 | +1 per nesting level |
| Logical operator sequence (`&&` / `\|\|`) | +1 | — |
| Nested function expression (non-callback) | +2 | — |
| `break` statement | +1 | — |
| `continue` statement | +1 | — |
| `throw` expression | +1 | — |

**Nesting bonus:** Each control structure that is already inside another control structure adds an extra point for every level of nesting, reflecting the extra mental effort required to track context.

**Callback exclusion:** Anonymous functions passed directly as arguments to method calls (e.g., `.map(...)`, `.forEach(...)`) do not incur the nested-function penalty, because they are idiomatic and readable in Dart/Flutter.

## When It Triggers

The rule visits every `MethodDeclaration` and `FunctionDeclaration` in the file. After all scoring is complete, it reports a warning or error at the function/method name token if the total score exceeds the medium threshold (10).

## Bad Examples

```dart
// ❌ High complexity — deeply nested conditionals and loops
void processItems(List<Item> items) {
  for (final item in items) {           // +1 (nesting: 0)
    if (item.isActive) {                // +1, +1 nesting bonus (nesting: 1)
      if (item.type == 'special') {     // +1, +2 nesting bonus (nesting: 2)
        for (final sub in item.subs) {  // +1, +3 nesting bonus (nesting: 3)
          try {                         // +1, +4 nesting bonus (nesting: 4)
            process(sub);
          } catch (e) {
            throw Exception(e);         // +1
          }
        }
      }
    }
  }
}
// Score: 1+2+3+4+5+1 = 16 → ❌ Error
```

## Good Examples

```dart
// ✅ Refactored into focused helpers — each with a low complexity score
void processItems(List<Item> items) {
  items.where((i) => i.isActive).forEach(_processActiveItem);
}

void _processActiveItem(Item item) {
  if (item.type == 'special') {
    item.subs.forEach(_processSubItem);
  }
}

void _processSubItem(SubItem sub) {
  try {
    process(sub);
  } catch (e) {
    throw Exception(e);
  }
}
```

## How to Fix

- **Extract methods** — Move nested or complex blocks into well-named private helper methods to reduce nesting depth.
- **Early returns / guard clauses** — Use early `return` or `throw` at the top of a function to handle edge cases and eliminate nesting.
- **Flatten conditional logic** — Replace nested `if`/`else` chains with maps, switch expressions, or polymorphism.
- **Use higher-order functions** — Dart's collection methods (`where`, `map`, `fold`, `forEach`) often eliminate explicit loops entirely.
- **Limit boolean operator chains** — Break complex boolean expressions into well-named boolean variables or helper methods.

## Configuration

Complexity thresholds are defined as an enum in `config.dart`:

```dart
enum ComplexityCategory {
  low(0),
  medium(10),
  high(15);
}
```

Adjust these values to tune the sensitivity of the rule for your project.

## Why This Matters

- **Bug density** — Studies have shown that complex code has a higher incidence of defects.
- **Review quality** — Reviewers struggle to fully reason about highly complex methods, so bugs survive longer in them.
- **Onboarding** — New team members can understand and contribute to low-complexity code faster.
- **Refactoring confidence** — Simple, well-understood functions are much safer to change.
