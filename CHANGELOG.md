# Changelog

## 1.2.0

- **Configurable rule limits**: All rule thresholds are now customisable in `analysis_options.yaml` — no more hardcoded values.
  - `class_length`: `max_lines` (default 300), `stateful_widget_max_lines` (default 500)
  - `file_length`: `max_lines` (default 500)
  - `function_length`: `max_lines` (default 50), `build_method_max_lines` (default 100)
  - `cognitive_complexity`: `medium_threshold` (default 10), `high_threshold` (default 15)
- **Tests**: Added full unit-test coverage for all six lint rules.

## 1.0.0

- Initial stable release
- Core functionality implemented
- Documentation completed
- All tests passing

## 1.1.0

- **Dependencies**: Updated `analyzer` and `custom_lint_builder` versions.
- **IDE Support**: Fixed lints not displaying correctly in JetBrains IDEs.
- **Class Length Rule**: Improved handling for `StatefulWidget` and related classes.
- **Function Length Rule**: Special handling added for Flutter `build` methods.
- **File Length Rule**: Now excludes `import` statements from line count.
