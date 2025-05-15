import 'package:analyzer/dart/ast/token.dart';

class MethodComplexityMetrics {
  final String name;
  final String type; // 'method' or 'function'
  int cognitiveComplexity = 0;
  int nestingLevel = 0;
  int numberOfParameters = 0;
  int lineCount = 0;
  String complexityCategory = '';
  String riskAssessment = '';
  List<String> refactoringSuggestions = [];
  Token token;

  MethodComplexityMetrics(this.name, this.type, this.token);
}
