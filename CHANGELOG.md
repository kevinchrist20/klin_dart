# Changelog

## 1.3.1

- **Default limits updated**:
  - `class_length.max_lines`: 300 -> 500
  - `file_length.max_lines`: 500 -> 700
  - `function_length.max_lines`: 50 -> 75
  - `function_length.build_method_max_lines`: 100 -> 150

## 1.3.0

- **Cognitive complexity fix**: Nesting penalty now correctly accumulates `1 + currentNestingLevel` per nested construct (previously only added a flat `+1` bonus regardless of depth). Deeply nested code will now score higher and trigger warnings/errors more accurately.
- **Class length defaults corrected**: `max_lines` default updated from 200 → 300; `stateful_widget_max_lines` default updated from 300 → 500.
- **Refactor**: Rule constructors now accept a nullable `Map<String, Object?>?` config map instead of individual named parameters, aligning with how `custom_lint_builder` passes YAML configuration.
- **Config parsing**: All threshold values are now parsed with `int.tryParse`, handling both integer and string representations from `analysis_options.yaml`.
- **Docs**: Added `docs/skills/` with Markdown reference files for all six lint rules.

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
