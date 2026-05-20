import 'package:analyzer/error/error.dart' as error;
import 'package:test/test.dart';
import 'package:klin_dart/src/cognitive_complexity/cognitive_complexity_rule.dart';

import 'test_utils.dart';

// Complexity scores used by the visitor:
//   if/for/while/switch/try at nesting level N: +1 (base) + N (nesting penalty)
//   outermost && or || chain: +1

void main() {
  group('CognitiveComplexityRule', () {
    test('does not report a function with complexity at or below mediumThreshold',
        () async {
      final rule = CognitiveComplexityRule(config: {'medium_threshold': 2, 'high_threshold': 5});
      // Single if → complexity 1, which is NOT > 2 → no report
      final file = writeToTempFile('''
int simple(int x) {
  if (x > 0) {
    return x;
  }
  return 0;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name.startsWith('cognitive_complexity')),
        isEmpty,
      );
    });

    test('reports a WARNING for complexity above mediumThreshold but below highThreshold',
        () async {
      final rule = CognitiveComplexityRule(config: {'medium_threshold': 2, 'high_threshold': 5});
      // Double-nested if:
      //   outer if at level 0 → +1
      //   inner if at level 1 → +2
      //   total = 3 → 3 > 2 and 3 < 5 → WARNING
      final file = writeToTempFile('''
int mediumComplex(int a, int b) {
  if (a > 0) {
    if (b > 0) {
      return a + b;
    }
  }
  return 0;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      final complexityErrors = errors
          .where((e) => e.errorCode.name.startsWith('cognitive_complexity'))
          .toList();
      expect(complexityErrors, hasLength(1));
      expect(
        complexityErrors.first.errorCode.errorSeverity,
        error.ErrorSeverity.WARNING,
      );
    });

    test('reports an ERROR for complexity at or above highThreshold', () async {
      final rule = CognitiveComplexityRule(config: {'medium_threshold': 2, 'high_threshold': 5});
      // Triple-nested if:
      //   outer if at level 0 → +1
      //   middle if at level 1 → +2
      //   inner if at level 2 → +3
      //   total = 6 → 6 >= 5 → ERROR
      final file = writeToTempFile('''
int highComplex(int a, int b, int c) {
  if (a > 0) {
    if (b > 0) {
      if (c > 0) {
        return a + b + c;
      }
    }
  }
  return 0;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      final complexityErrors = errors
          .where((e) => e.errorCode.name.startsWith('cognitive_complexity'))
          .toList();
      expect(complexityErrors, hasLength(1));
      expect(
        complexityErrors.first.errorCode.errorSeverity,
        error.ErrorSeverity.ERROR,
      );
    });

    test('respects custom mediumThreshold', () async {
      // With a very low threshold, even a single if triggers a warning
      final rule = CognitiveComplexityRule(config: {'medium_threshold': 0, 'high_threshold': 10});
      final file = writeToTempFile('''
int withOneIf(int x) {
  if (x > 0) {
    return x;
  }
  return 0;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name.startsWith('cognitive_complexity')),
        isNotEmpty,
      );
    });

    test('checks all functions in a file independently', () async {
      final rule = CognitiveComplexityRule(config: {'medium_threshold': 2, 'high_threshold': 5});
      // Two functions: one simple, one complex
      final file = writeToTempFile('''
int simple(int x) {
  return x;
}

int complex(int a, int b) {
  if (a > 0) {
    if (b > 0) {
      return a + b;
    }
  }
  return 0;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      final complexityErrors = errors
          .where((e) => e.errorCode.name.startsWith('cognitive_complexity'))
          .toList();
      // Only the complex function should be reported
      expect(complexityErrors, hasLength(1));
      expect(complexityErrors.first.errorCode.name, contains('complex'));
    });
  });
}
