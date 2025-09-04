import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:klin_dart/src/utils/ast_node_extensions.dart';

class ClassLengthRule extends DartLintRule {
  /// The default maximum number of lines allowed in a class.
  static const _defaultMaxLines = 200;

  static const _statefulWidgetMaxLines = 300;

  /// The configurable maximum number of lines allowed.
  final int maxLines;

  ClassLengthRule({this.maxLines = _defaultMaxLines})
      : super(
          code: LintCode(
            name: 'class_length',
            problemMessage:
                'Class is too long ({0} lines). Maximum allowed is {1} lines.',
            correctionMessage:
                'Consider breaking this class into smaller, more focused classes.',
            errorSeverity: error.ErrorSeverity.WARNING,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final lineInfo = resolver.lineInfo;
      final startLine = lineInfo.getLocation(node.offset).lineNumber;
      final endLine = lineInfo.getLocation(node.end).lineNumber;
      final length = endLine - startLine + 1;

      if(node.isStatefulWidgetClass()) {
        if(length > _statefulWidgetMaxLines) {
          reporter.atNode(
            node,
            code,
            arguments: [length.toString(), _statefulWidgetMaxLines.toString()],
          );
        }
        return;
      }

      if (length > maxLines) {
        reporter.atNode(
          node,
          code,
          arguments: [length.toString(), maxLines.toString()],
        );
      }
    });
  }
}
