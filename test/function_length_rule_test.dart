import 'package:test/test.dart';
import 'package:klin_dart/src/best_practices/function_length_rule.dart';

import 'test_utils.dart';

void main() {
  group('FunctionLengthRule', () {
    test('reports a function that exceeds maxLines', () async {
      final rule = FunctionLengthRule(config: {'max_lines': 3});      
      final file = writeToTempFile('''
void longFunction() {
  int a = 1;
  int b = 2;
  int c = 3;
  int d = 4;
  int e = 5;
  int f = 6;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      // A top-level function fires both addFunctionDeclaration and
      // addFunctionExpression, so at least one error is expected.
      expect(
        errors.where((e) => e.errorCode.name == 'function_length'),
        isNotEmpty,
      );
    });

    test('does not report a function within maxLines', () async {
      final rule = FunctionLengthRule(config: {'max_lines': 20});
      final file = writeToTempFile('''
void shortFunction() {
  int a = 1;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'function_length'),
        isEmpty,
      );
    });

    test('uses buildMethodMaxLines for Widget.build() methods', () async {
      // maxLines is very small, but buildMethodMaxLines is generous.
      // The build() method should not trigger even though it exceeds maxLines.
      final rule = FunctionLengthRule(config: {'max_lines': 3, 'build_method_max_lines': 50});
      // isWidgetBuildMethod() matches methods named 'build' returning 'Widget'
      final file = writeToTempFile('''
class Widget {}
class BuildContext {}

class MyWidget {
  Widget build(BuildContext context) {
    int a = 1;
    int b = 2;
    int c = 3;
    int d = 4;
    int e = 5;
    return Widget();
  }
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'function_length'),
        isEmpty,
      );
    });

    test('reports a build() method that exceeds buildMethodMaxLines', () async {
      final rule = FunctionLengthRule(config: {'max_lines': 50, 'build_method_max_lines': 3});
      final file = writeToTempFile('''
class Widget {}
class BuildContext {}

class MyWidget {
  Widget build(BuildContext context) {
    int a = 1;
    int b = 2;
    int c = 3;
    int d = 4;
    int e = 5;
    return Widget();
  }
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'function_length'),
        hasLength(1),
      );
    });

    test('reports a method that exceeds maxLines', () async {
      final rule = FunctionLengthRule(config: {'max_lines': 3});
      final file = writeToTempFile('''
class Foo {
  void longMethod() {
    int a = 1;
    int b = 2;
    int c = 3;
    int d = 4;
    int e = 5;
  }
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'function_length'),
        hasLength(1),
      );
    });
  });
}
