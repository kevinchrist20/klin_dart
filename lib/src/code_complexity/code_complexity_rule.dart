import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/error/error.dart' as error;

class CodeComplexityRule  extends DartLintRule {
  CodeComplexityRule() : super(code: _code);

  static const _lintName = 'code_complexity';
  static final _code = LintCode(
    name: _lintName,
    problemMessage:
        'Code complexity is too high. Consider refactoring.',
    correctionMessage:
        'Refactor the code to reduce complexity.',
    uniqueName: _lintName,
    errorSeverity: error.ErrorSeverity.WARNING,
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    // TODO: implement run
  }
}