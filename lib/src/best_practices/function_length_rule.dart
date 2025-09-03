import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:klin_dart/src/utils/ast_node_extensions.dart';

class FunctionLengthRule extends DartLintRule {
  /// The default maximum number of lines allowed in a function.
  static const _defaultMaxLines = 50;
  static const buildMethodMaxLines = 100;

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
        reporter: reporter,
        lineInfo: resolver.lineInfo,
      );
    });

    context.registry.addMethodDeclaration((node) {
      _checkFunctionLength(
        node,
        node.body,
        reporter: reporter,
        lineInfo: resolver.lineInfo,
      );
    });

    context.registry.addFunctionExpression((node) {
      _checkFunctionLength(
        node,
        node.body,
        reporter: reporter,
        lineInfo: resolver.lineInfo,
      );
    });
  }

  void _checkFunctionLength(
    AstNode node,
    AstNode body, {
    required ErrorReporter reporter,
    required LineInfo lineInfo,
  }) {
    final startLine = lineInfo.getLocation(body.offset).lineNumber;
    final endLine = lineInfo.getLocation(body.end).lineNumber;
    final length = endLine - startLine + 1;

    if (node.isWidgetBuildMethod() && length > FunctionLengthRule.buildMethodMaxLines) {
      reporter.atNode(
        node,
        code,
        arguments: [length.toString(), FunctionLengthRule.buildMethodMaxLines.toString()],
      );
      return;
    } 
    
    if (length > maxLines) {
      reporter.atNode(
        node,
        code,
        arguments: [length.toString(), maxLines.toString()],
      );
    }
  }
}
