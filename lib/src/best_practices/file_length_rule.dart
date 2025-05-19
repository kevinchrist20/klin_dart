import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/error/error.dart' as error;

class FileLengthRule extends DartLintRule {
  /// The default maximum number of lines allowed in a file.
  static const _defaultMaxLines = 500;

  /// The configurable maximum number of lines allowed.
  final int maxLines;

  FileLengthRule({this.maxLines = _defaultMaxLines})
      : super(
          code: LintCode(
            name: 'file_length',
            problemMessage:
                'File is too long ({0} lines). Maximum allowed is {1} lines.',
            correctionMessage:
                'Consider breaking this file into multiple files.',
            errorSeverity: error.ErrorSeverity.WARNING,
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      final lineInfo = resolver.lineInfo;
      final totalLines = lineInfo.lineCount;

      if (totalLines > maxLines) {
        reporter.atNode(
          node,
          code,
          arguments: [totalLines.toString(), maxLines.toString()],
        );
      }
    });
  }
}
