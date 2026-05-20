import 'package:test/test.dart';
import 'package:klin_dart/src/best_practices/class_length_rule.dart';

import 'test_utils.dart';

void main() {
  group('ClassLengthRule', () {
    test('reports a class that exceeds maxLines', () async {
      final rule = ClassLengthRule(maxLines: 5);
      // Class body spans 9 lines → 9 > 5 → should report
      final file = writeToTempFile('''
class Foo {
  int a = 1;
  int b = 2;
  int c = 3;
  int d = 4;
  int e = 5;
  int f = 6;
  int g = 7;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'class_length'),
        hasLength(1),
      );
    });

    test('does not report a class within maxLines', () async {
      final rule = ClassLengthRule(maxLines: 10);
      final file = writeToTempFile('''
class Foo {
  int a = 1;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'class_length'),
        isEmpty,
      );
    });

    test('uses statefulWidgetMaxLines for State subclasses instead of maxLines',
        () async {
      // maxLines is small but statefulWidgetMaxLines is large — the State class
      // should only be checked against statefulWidgetMaxLines.
      final rule = ClassLengthRule(maxLines: 5, statefulWidgetMaxLines: 50);
      // MyScreenState extends State → isStatefulWidgetClass() = true
      final file = writeToTempFile('''
class State {}
class MyScreenState extends State {
  int a = 1;
  int b = 2;
  int c = 3;
  int d = 4;
  int e = 5;
  int f = 6;
  int g = 7;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      // Should NOT trigger: class is ~11 lines which is < statefulWidgetMaxLines 50
      expect(
        errors.where((e) => e.errorCode.name == 'class_length'),
        isEmpty,
      );
    });

    test('reports a State subclass that exceeds statefulWidgetMaxLines',
        () async {
      final rule = ClassLengthRule(maxLines: 50, statefulWidgetMaxLines: 5);
      final file = writeToTempFile('''
class State {}
class MyScreenState extends State {
  int a = 1;
  int b = 2;
  int c = 3;
  int d = 4;
  int e = 5;
  int f = 6;
  int g = 7;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'class_length'),
        hasLength(1),
      );
    });

    test('does not report a State subclass within statefulWidgetMaxLines',
        () async {
      final rule = ClassLengthRule(maxLines: 5, statefulWidgetMaxLines: 50);
      final file = writeToTempFile('''
class State {}
class MyScreenState extends State {
  int a = 1;
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'class_length'),
        isEmpty,
      );
    });
  });
}
