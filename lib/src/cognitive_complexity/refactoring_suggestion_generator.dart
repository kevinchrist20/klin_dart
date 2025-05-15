import 'package:klin_dart/src/cognitive_complexity/config.dart';

/// Utility class to generate refactoring suggestions based on code metrics
class RefactoringSuggestionGenerator {
  static void generateSuggestions(MethodComplexityMetrics metrics) {
    List<String> suggestions = [];

    if (metrics.cognitiveComplexity > 10) {
      suggestions.add("Consider breaking '${metrics.name}' into multiple smaller ${metrics.type}s with single responsibilities.");
      suggestions.add("Refactor complex conditional logic into separate helper ${metrics.type}s with descriptive names.");
    }

    if (metrics.nestingLevel > 3) {
      suggestions.add("Reduce nesting depth (currently at level ${metrics.nestingLevel}) by using early returns or guard clauses.");
      suggestions.add("Extract deeply nested code into well-named helper ${metrics.type}s.");
    }

    if (metrics.numberOfParameters > 4) {
      suggestions.add("Reduce the number of parameters (currently ${metrics.numberOfParameters}) by grouping related parameters into objects.");
      suggestions.add("Consider using the Builder pattern to make parameter passing more readable.");
    }

    if (metrics.cognitiveComplexity > 8) {
      suggestions.add("Use more descriptive variable names to improve readability.");
      suggestions.add("Add comments to explain complex logic or business rules.");
      suggestions.add("Look for repeated code patterns that could be extracted into reusable functions.");
    }

    metrics.refactoringSuggestions = suggestions;
  }
}
