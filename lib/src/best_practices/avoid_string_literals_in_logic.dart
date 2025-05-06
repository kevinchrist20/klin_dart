import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

class AvoidStringLiteralsInLogicRule extends DartLintRule {
  AvoidStringLiteralsInLogicRule() : super(code: _code);

  static const _lintName = 'avoid_string_literals_in_logic';

  static final _code = LintCode(
    name: _lintName,
    problemMessage:
        'Avoid using raw string literals in logic or conditions. This can lead to fragile code and primitive obsession.',
    correctionMessage:
        'Define constants or use enums instead of hardcoded strings in logic checks or assignments.',
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
      final parent = node.parent;

      if (parent == null) return;

      // Binary comparison: if (x == 'someString')
      if (parent is BinaryExpression && _isEqualityOperator(parent.operator)) {
        // add file name to the message
        if (_isInsideLogicContext(parent)) {
          print('ParentType: ${parent.runtimeType}: ${parent.operator} ${node.stringValue}');
          reporter.atNode(node, code);
        }
      }

      // switch (value) { case 'someString': ... }
      if (parent is SwitchCase && _isInsideLogicContext(parent)) {
        reporter.atNode(node, code);
      }

      // assignment: role = 'admin'
      if (parent is AssignmentExpression) {
        final lhs = parent.leftHandSide;
        if (_isDomainVariable(lhs)) {
          reporter.atNode(node, code);
        }
      }

      // passed as argument to function: checkStatus('active')
      if (parent is ArgumentList) {
        final method = parent.thisOrAncestorOfType<MethodInvocation>();
        if (method != null && _shouldUseEnumInstead(method)) {
          reporter.atNode(node, code);
        }
      }
    });
  }

  bool _isEqualityOperator(Token token) =>
      token.type == TokenType.EQ_EQ || token.type == TokenType.BANG_EQ;

  bool _isInsideLogicContext(AstNode node) =>
      node.thisOrAncestorMatching((n) =>
          n is IfStatement ||
          n is ConditionalExpression ||
          n is WhileStatement ||
          n is SwitchStatement) !=
      null;

  bool _isDomainVariable(Expression expression) {
    final name = expression.toString().toLowerCase();
    const domainKeywords = [
      'status',
      'type',
      'role',
      'level',
      'plan',
      'membership',
      'category',
    ];
    return domainKeywords.any((keyword) => name.contains(keyword));
  }

  bool _shouldUseEnumInstead(MethodInvocation method) {
    final name = method.methodName.name.toLowerCase();
    const riskyMethods = [
      'check',
      'update',
      'change',
      'set',
      'compare',
      'is',
    ];
    return riskyMethods.any((r) => name.contains(r));
  }
}
