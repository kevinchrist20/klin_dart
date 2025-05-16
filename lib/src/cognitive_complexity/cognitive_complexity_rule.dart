import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:klin_dart/src/cognitive_complexity/cognitive_complexity_visitor.dart';
import 'package:klin_dart/src/cognitive_complexity/config.dart';

class CognitiveComplexityRule extends DartLintRule {
  static const _lintName = 'cognitive_complexity';

  CognitiveComplexityRule()
      : super(
          code: LintCode(
            name: _lintName,
            problemMessage: "",
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      final visitor = MethodVisitor();
      node.visitChildren(visitor);

      final methodMetrics = visitor.analyzeCollectedMethods();

      for (final entry in methodMetrics.entries) {
        final metrics = entry.value;
        final complexity = metrics.cognitiveComplexity;

        if (complexity > ComplexityCategory.medium.value) {
          reporter.atToken(
            metrics.token,
            LintCode(
              name: _lintName,
              problemMessage: metrics.riskAssessment,
              uniqueName: '${_lintName}_${metrics.name}',
              errorSeverity: complexity >= ComplexityCategory.high.value
                  ? error.ErrorSeverity.ERROR
                  : error.ErrorSeverity.WARNING,
            ),
          );
        }
      }
    });
  }
}
