import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/utils/ast_extensions.dart';

class AvoidHardcodedStringsInWidgetsRule extends DartLintRule {
  AvoidHardcodedStringsInWidgetsRule() : super(code: _code);

  static const _lintName = 'avoid_hardcoded_strings_in_ui';

  static final _code = LintCode(
    name: _lintName,
    problemMessage: 'Avoid hardcoded string literals in widget trees. '
        'This makes localization harder and may indicate primitive obsession if used in logic.',
    correctionMessage:
        'Extract the string to a localization file (for UI) or use enums/constants (for logic).',
    uniqueName: _lintName,
    errorSeverity: error.ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addStringLiteral((node) {
      final value = node.stringValue;
      if (value == null || value.trim().isEmpty) return;

      // Avoid triggering on import/export directives
      if (node.thisOrAncestorOfType<Directive>() != null) return;

      // Only report if it's in a widget-related scope
      if (!node.isWithinWidget) return;

      // Also make sure it's passed into a widget constructor (can be custom widget too)
      final creation = node.thisOrAncestorOfType<InstanceCreationExpression>();
      if (creation == null || !creation.isWidgetClass) return;

      reporter.atNode(node, code);
    });
  }
}
