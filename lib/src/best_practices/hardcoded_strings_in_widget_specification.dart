import 'package:analyzer/dart/ast/ast.dart';

class HardcodedStringsInWidgetSpecification {
  HardcodedStringsInWidgetSpecification();

  bool isSatisfiedBy(AstNode element) {
    final result = element is! Directive && element is! StringLiteral && element is! CompilationUnit;

    print("Analysis $element - type: ${element.runtimeType} marked as $result");

    return result;
  }
}