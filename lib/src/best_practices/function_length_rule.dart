import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/error/error.dart' as error;

class FunctionLengthRule extends DartLintRule {
  /// The default maximum number of lines allowed in a function.
  static const _defaultMaxLines = 50;

  /// The configurable maximum number of lines allowed.
  final int maxLines;

  FunctionLengthRule({this.maxLines = _defaultMaxLines})
      : super(
          code: LintCode(
            name: 'function_length',
            problemMessage:
                'Function is too long ({0} lines). Maximum allowed is {1} lines.',
            correctionMessage:
                'Consider refactoring this function into smaller, more focused functions.',
            errorSeverity: error.ErrorSeverity.WARNING,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionDeclaration((node) {
      _checkFunctionLength(
        node,
        node.functionExpression.body,
        reporter,
        resolver.lineInfo,
      );
    });

    context.registry.addMethodDeclaration((node) {
      _checkFunctionLength(
        node,
        node.body,
        reporter,
        resolver.lineInfo,
      );
    });

    context.registry.addFunctionExpression((node) {
      _checkFunctionLength(
        node,
        node.body,
        reporter,
        resolver.lineInfo,
      );
    });
  }

  void _checkFunctionLength(
    AstNode node,
    AstNode body,
    ErrorReporter reporter,
    LineInfo lineInfo,
  ) {
    final startLine = lineInfo.getLocation(body.offset).lineNumber;
    final endLine = lineInfo.getLocation(body.end).lineNumber;
    final length = endLine - startLine + 1;

    if (length > maxLines) {
      reporter.atNode(
        node,
        code,
        arguments: [length.toString(), maxLines.toString()],
      );
    }
  }
}
