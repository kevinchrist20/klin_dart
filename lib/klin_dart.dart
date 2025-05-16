import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/best_practices/avoid_hardcoded_strings_in_widgets.dart';
import 'package:klin_dart/src/best_practices/avoid_string_literals_in_logic.dart';
import 'package:klin_dart/src/cognitive_complexity/cognitive_complexity_rule.dart';

PluginBase createPlugin() => _KlinLinter();

class _KlinLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    return [
      AvoidHardcodedStringsInWidgetsRule(),
      AvoidStringLiteralsInLogicRule(),
      CognitiveComplexityRule()
    ];
  }
}

// CognitiveComplexityLintRule
// [cognitive_complexity] 2025-05-15T12:28:29.228325 Cognitive Complexity: 6 for _incrementComplexity
// [cognitive_complexity] 2025-05-15T12:28:29.229429 Cognitive Complexity: 8 for analyzeCollectedMethods
// [cognitive_complexity] 2025-05-15T12:28:29.263585 Cognitive Complexity: 11 for calculateScore

// CognitiveComplexityRule
// [cognitive_complexity] 2025-05-16T09:42:01.738358 Method: _incrementComplexity - Complexity: 8
// [cognitive_complexity] 2025-05-16T09:42:01.739480 Method: _isInMethodInvocation - Complexity: 6
// [cognitive_complexity] 2025-05-16T09:42:01.739579 Method: analyzeCollectedMethods - Complexity: 9
// [cognitive_complexity] 2025-05-16T09:42:01.765647 Method: checkRecordType - Complexity: 6
// [cognitive_complexity] 2025-05-16T09:42:01.774118 Method: calculateScore - Complexity: 10