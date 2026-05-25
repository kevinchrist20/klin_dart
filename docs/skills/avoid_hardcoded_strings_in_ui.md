# Skill: avoid_hardcoded_strings_in_ui

## Overview

**Rule name:** `avoid_hardcoded_strings_in_ui`  
**Severity:** Warning  
**Category:** Best Practices

Discourages the use of hardcoded string literals directly inside widget trees. Hardcoded strings tightly couple the UI to raw text values, making the app harder to localize and maintain.

## When It Triggers

This rule fires when a non-empty string literal appears inside a widget context — for example, as the `data` argument of a `Text` widget, inside `AppBar(title: ...)`, or any other place within a widget's `build` tree.

String literals in import directives and blank/whitespace-only strings are ignored.

## Bad Examples

```dart
// ❌ Hardcoded string in a Text widget
Text('Welcome back!')

// ❌ Hardcoded string in AppBar title
AppBar(title: Text('Home'))

// ❌ Hardcoded string in a button label
ElevatedButton(
  onPressed: () {},
  child: Text('Submit'),
)
```

## Good Examples

```dart
// ✅ Use a localization key
Text(AppLocalizations.of(context)!.welcomeBack)

// ✅ Use a named constant
const String kHomeTitle = 'Home';
AppBar(title: Text(kHomeTitle))

// ✅ Use an l10n generated class
ElevatedButton(
  onPressed: () {},
  child: Text(context.l10n.submit),
)
```

## How to Fix

Move all display text out of the widget tree and into one of the following:

- **Localization files** — Use Flutter's `intl` / `flutter_localizations` packages and `AppLocalizations` (or equivalent) to manage translatable strings.
- **Constants** — Define string constants in a dedicated `constants.dart` file or as `static const` values inside the relevant class.

## Configuration

This rule is enabled with a fixed `WARNING` severity and currently has no configurable options.

## Why This Matters

- **Localization readiness** — Moving strings out of widgets is the first step toward supporting multiple languages.
- **Consistency** — Centralised text management makes wording changes fast and safe.
- **Maintainability** — Avoids scattered magic strings that are hard to find and update.
