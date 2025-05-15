import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:klin_dart/src/cognitive_complexity/config.dart';
import 'package:klin_dart/src/cognitive_complexity/refactoring_suggestion_generator.dart';

/// AST visitor that collects method declarations and calculates complexity.
class MethodVisitor extends RecursiveAstVisitor<void> {
  Map<String, MethodComplexityMetrics> methodMetrics = {};

  MethodDeclaration? currentMethod;
  FunctionDeclaration? currentFunction;
  int currentNestingLevel = 0;

  MethodVisitor();

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final methodNode = node.thisOrAncestorOfType<MethodDeclaration>();

    final metrics = MethodComplexityMetrics(
      node.name.toString(),
      'method',
      methodNode?.beginToken ?? node.name,
    );
    metrics.numberOfParameters = node.parameters?.parameters.length ?? 0;

    methodMetrics[node.name.toString()] = metrics;
    currentMethod = node;
    currentFunction = null; // Clear any function context
    super.visitMethodDeclaration(node);
    currentMethod = null;
    currentNestingLevel = 0;
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final functionNode = node.thisOrAncestorOfType<FunctionDeclaration>();
    final metrics = MethodComplexityMetrics(
      node.name.toString(),
      'function',
      functionNode?.beginToken ?? node.name,
    );

    // Get parameters from the function's expression
    if (node.functionExpression.parameters != null) {
      metrics.numberOfParameters =
          node.functionExpression.parameters!.parameters.length;
    }

    methodMetrics[node.name.toString()] = metrics;
    currentFunction = node;
    currentMethod = null; // Clear any method context
    super.visitFunctionDeclaration(node);
    currentFunction = null;
    currentNestingLevel = 0;
  }

  // ------------------------
  // Control structures
  // ------------------------

  @override
  void visitIfStatement(IfStatement node) {
    _incrementComplexity(1);

    if (currentNestingLevel > 0) {
      _incrementComplexity(currentNestingLevel);
    }

    currentNestingLevel++;
    super.visitIfStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitForStatement(ForStatement node) {
    _incrementComplexity(1);
    if (currentNestingLevel > 0) {
      _incrementComplexity(currentNestingLevel);
    }
    currentNestingLevel++;
    super.visitForStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _incrementComplexity(1);
    if (currentNestingLevel > 0) {
      _incrementComplexity(currentNestingLevel);
    }
    currentNestingLevel++;
    super.visitWhileStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _incrementComplexity(1);
    if (currentNestingLevel > 0) {
      _incrementComplexity(currentNestingLevel);
    }
    currentNestingLevel++;
    super.visitSwitchStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitTryStatement(TryStatement node) {
    _incrementComplexity(1);
    if (currentNestingLevel > 0) {
      _incrementComplexity(currentNestingLevel);
    }
    currentNestingLevel++;
    super.visitTryStatement(node);
    currentNestingLevel--;
  }

  // ------------------------
  // Boolean Operators
  // ------------------------
  @override
  void visitBinaryExpression(BinaryExpression node) {
    if (node.operator.type.lexeme == '&&' ||
        node.operator.type.lexeme == '||') {
      _incrementComplexity(1);
    }
    super.visitBinaryExpression(node);
  }

  // ------------------------
  // Jump Statements
  // ------------------------
  @override
  void visitFunctionExpression(FunctionExpression node) {
    if (_isInMethodInvocation(node)) {
      super.visitFunctionExpression(node);
      return;
    }

    if (currentMethod != null || currentFunction != null) {
      _incrementComplexity(2); // Higher penalty for nested functions

      currentNestingLevel++;
      super.visitFunctionExpression(node);
      currentNestingLevel--;
    } else {
      super.visitFunctionExpression(node);
    }
  }

  @override
  void visitBreakStatement(BreakStatement node) {
    _incrementComplexity(1);
    super.visitBreakStatement(node);
  }

  @override
  void visitContinueStatement(ContinueStatement node) {
    _incrementComplexity(1);
    super.visitContinueStatement(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    _incrementComplexity(1);
    super.visitThrowExpression(node);
  }

  void _incrementComplexity(int amount) {
    if (currentMethod != null) {
      var metrics = methodMetrics[currentMethod!.name.toString()]!;
      metrics.cognitiveComplexity += amount;

      if (currentNestingLevel > metrics.nestingLevel) {
        metrics.nestingLevel = currentNestingLevel;
      }
    } else if (currentFunction != null) {
      var metrics = methodMetrics[currentFunction!.name.toString()]!;
      metrics.cognitiveComplexity += amount;

      if (currentNestingLevel > metrics.nestingLevel) {
        metrics.nestingLevel = currentNestingLevel;
      }
    }
  }

  /// Determines if a function expression is used as an argument in a method call
  bool _isInMethodInvocation(FunctionExpression node) {
    var parent = node.parent;

    // Handle direct parent as method invocation
    if (parent is ArgumentList && parent.parent is MethodInvocation) {
      return true;
    }

    // Handle parent as expression in argument list
    if (parent is Expression &&
        parent.parent is ArgumentList &&
        parent.parent?.parent is MethodInvocation) {
      return true;
    }

    if (parent is FunctionDeclaration) {
      return true;
    }

    return false;
  }

  /// Process collected methods and generate analysis results
  Map<String, MethodComplexityMetrics> analyzeCollectedMethods() {
    for (var entry in methodMetrics.entries) {
      _categorizeComplexity(entry.value);
      RefactoringSuggestionGenerator.generateSuggestions(entry.value);
    }

    return methodMetrics;
  }

  /// Categorize complexity and set risk assessment
  void _categorizeComplexity(MethodComplexityMetrics metrics) {
    if (metrics.cognitiveComplexity > 15) {
      metrics.complexityCategory = "High";
      metrics.riskAssessment =
          "❌ High Complexity (Score: ${metrics.cognitiveComplexity}) - Refactor recommended!";
    } else if (metrics.cognitiveComplexity > 8) {
      metrics.complexityCategory = "Medium";
      metrics.riskAssessment =
          "⚠️ Medium Complexity (Score: ${metrics.cognitiveComplexity}) - Consider simplifying this ${metrics.type}";
    } else {
      metrics.complexityCategory = "Low";
      metrics.riskAssessment =
          "✅ Low Complexity (Score: ${metrics.cognitiveComplexity}) - Everything looks good!";
    }
  }
}
