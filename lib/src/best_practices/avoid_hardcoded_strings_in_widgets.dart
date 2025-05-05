import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/utils/widget_utils.dart';

class AvoidHardcodedStringsInWidgetsRule extends DartLintRule {
  AvoidHardcodedStringsInWidgetsRule() : super(code: _code);

  static const _lintName = 'avoid_hardcoded_strings_in_ui';

  static final _code = LintCode(
    name: _lintName,
    problemMessage:
        'Avoid using hardcoded string literals in UI widgets. This practice makes localization difficult and tightly couples UI to raw text.',
    correctionMessage:
        'Move display text to localization files or constants. This improves maintainability and prepares the app for internationalization.',
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
      // Skip empty strings
      final value = node.stringValue;
      if (value == null || value.trim().isEmpty) return;

      // Skip imports and other directives
      if (node.thisOrAncestorOfType<Directive>() != null) return;

      // Check if the string is a parameter to a widget constructor
      if (_isStringInWidgetConstructor(node)) {
        reporter.atNode(node, code);
        return;
      }

      // Check if the string is a named parameter/property in a widget context
      if (_isStringAsWidgetProperty(node)) {
        reporter.atNode(node, code);
        return;
      }
    });
  }

  bool _isStringInWidgetConstructor(StringLiteral node) {
    // Get the instance creation expression this string is part of
    final creation = node.thisOrAncestorOfType<InstanceCreationExpression>();
    if (creation == null) return false;

    // Get the constructor's static element
    final constructorElement = creation.constructorName.staticElement;
    if (constructorElement == null) return false;

    // Get the class that contains this constructor
    final classElement = constructorElement.enclosingElement;
    if (classElement is! ClassElement) return false;

    // Check if this class is a widget
    return classElement.isWidget();
  }

  bool _isStringAsWidgetProperty(StringLiteral node) {
    // Check if this string is part of a named expression
    final namedExpression = node.thisOrAncestorOfType<NamedExpression>();
    if (namedExpression == null) return false;

    // If this is a named argument to a function call or constructor...
    final parent = namedExpression.parent;

    if (parent is ArgumentList && parent.parent is InstanceCreationExpression) {
      final creation = parent.parent as InstanceCreationExpression;
      final constructorElement = creation.constructorName.staticElement;
      if (constructorElement?.enclosingElement is ClassElement) {
        return (constructorElement!.enclosingElement as ClassElement).isWidget();
      }
    }

    // For method invocations on widgets
    if (parent is ArgumentList && parent.parent is MethodInvocation) {
      final invocation = parent.parent as MethodInvocation;
      final targetType = invocation.target?.staticType;
      if (targetType != null) {
        return targetType.isWidget();
      }
    }

    return false;
  }
}
