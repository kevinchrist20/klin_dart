# 🧠 KlinDart

KlinDart is a collection of opinionated custom lint rules for Dart and Flutter projects. It focuses on improving code **readability**, **maintainability**, and **scalability** by enforcing architectural and stylistic best practices.

## ✨ Features

| Rule Name                        | Description |
|----------------------------------|-------------|
| `avoid_hardcoded_strings_in_ui` | Discourages hardcoded string literals directly inside widgets to improve localization readiness. |
| `avoid_string_literals_in_logic` | Flags string literals used in conditions, comparisons, or logic—suggests constants or enums instead. |
| `cognitive_complexity`           | Warns about methods/functions that are too complex to easily understand or maintain. |
| `function_length`                | Enforces a maximum function/method size to encourage smaller, testable units. |
| `class_length`                   | Prevents overly long classes that may violate single-responsibility principle. |
| `file_length`                    | Warns about files that exceed a configurable number of lines. Useful for splitting concerns. |

## 🚀 Installation

To use KlinDart in your project:

### 1. Add dependency to your linter package

```yaml
# pubspec.yaml
dependencies:
  custom_lint: any

dev_dependencies:
  klin_dart:
    git:
      url: https://github.com/kevinchrist20/klin_dart

```

### 2. Enable it in analysis_options.yaml

```yaml
# analysis_options.yaml
include: package:custom_lint/analysis_options.yaml
analyzer:
  plugins:
    - custom_lint

```

## 📖 Philosophy

Clean code is not just about writing less code — it's about writing the right code in the right place.
KlinDart helps enforce practices that scale with your team, reduce bugs, and increase developer confidence across Dart and Flutter codebases.
The rules are designed to be opinionated yet flexible, allowing you to adapt them to your project's specific needs.

## 📌 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
MIT — feel free to fork and adapt to your team's needs.

## 👥 Contributing

We welcome contributions! If you have suggestions, bug reports, or feature requests, please open an issue or submit a pull request.
Please ensure that your code adheres to the existing style and includes tests where applicable.
We also encourage you to write documentation for any new features or changes you make.
