import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:klin_dart/src/utils/widget_utils.dart';

/// Extensions for AST nodes to determine their relation to widgets
extension WidgetContextExtensions on AstNode {
  /// Checks if this node is used within a widget context
  bool isInWidgetContext() {
    return isInWidgetConstructor() || isInWidgetProperty();
  }

  /// Checks if this node is part of a widget constructor call
  bool isInWidgetConstructor() {
    final creation = thisOrAncestorOfType<InstanceCreationExpression>();
    if (creation == null) return false;
    
    final constructorElement = creation.constructorName.staticElement;
    if (constructorElement == null) return false;
    
    final classElement = constructorElement.enclosingElement;
    return classElement is ClassElement && classElement.isWidget();
  }

  /// Checks if this node is a parameter to a widget property
  bool isInWidgetProperty() {
    final namedExpression = thisOrAncestorOfType<NamedExpression>();
    if (namedExpression == null) return false;
    
    final parent = namedExpression.parent;
    
    // Check constructor invocation
    if (parent is ArgumentList && parent.parent is InstanceCreationExpression) {
      final creation = parent.parent as InstanceCreationExpression;
      final constructorElement = creation.constructorName.staticElement;
      if (constructorElement?.enclosingElement is ClassElement) {
        return (constructorElement!.enclosingElement as ClassElement).isWidget();
      }
    }
    
    // Check method invocation
    if (parent is ArgumentList && parent.parent is MethodInvocation) {
      final invocation = parent.parent as MethodInvocation;
      final targetType = invocation.target?.staticType;
      return targetType != null && targetType.isWidget();
    }
    
    return false;
  }
}
