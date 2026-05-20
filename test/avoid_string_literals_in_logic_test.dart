import 'package:test/test.dart';
import 'package:klin_dart/src/best_practices/avoid_string_literals_in_logic.dart';

import 'test_utils.dart';

void main() {
  group('AvoidStringLiteralsInLogicRule', () {
    test('reports a string literal used in an equality comparison inside an if',
        () async {
      final rule = AvoidStringLiteralsInLogicRule();
      final file = writeToTempFile('''
void check(String status) {
  if (status == 'active') {
    print(status);
  }
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where(
            (e) => e.errorCode.name == 'avoid_string_literals_in_logic'),
        hasLength(1),
      );
    });

    test('reports a string in an inequality comparison inside an if', () async {
      final rule = AvoidStringLiteralsInLogicRule();
      final file = writeToTempFile('''
void check(String status) {
  if (status != 'pending') {
    print(status);
  }
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where(
            (e) => e.errorCode.name == 'avoid_string_literals_in_logic'),
        hasLength(1),
      );
    });

    test('reports a string passed to a named parameter containing "type"',
        () async {
      final rule = AvoidStringLiteralsInLogicRule();
      final file = writeToTempFile('''
void process({required String type}) {}

void main() {
  process(type: 'admin');
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where(
            (e) => e.errorCode.name == 'avoid_string_literals_in_logic'),
        hasLength(1),
      );
    });

    test('reports a string passed to a named parameter containing "status"',
        () async {
      final rule = AvoidStringLiteralsInLogicRule();
      final file = writeToTempFile('''
void updateOrder({required String status}) {}

void main() {
  updateOrder(status: 'shipped');
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where(
            (e) => e.errorCode.name == 'avoid_string_literals_in_logic'),
        hasLength(1),
      );
    });

    test('does not report a string passed to print()', () async {
      final rule = AvoidStringLiteralsInLogicRule();
      final file = writeToTempFile('''
void main() {
  print('hello world');
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where(
            (e) => e.errorCode.name == 'avoid_string_literals_in_logic'),
        isEmpty,
      );
    });

    test('does not report a regular string variable assignment', () async {
      final rule = AvoidStringLiteralsInLogicRule();
      final file = writeToTempFile('''
void main() {
  final greeting = 'Hello, world!';
  print(greeting);
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where(
            (e) => e.errorCode.name == 'avoid_string_literals_in_logic'),
        isEmpty,
      );
    });

    test('does not report an empty string', () async {
      final rule = AvoidStringLiteralsInLogicRule();
      final file = writeToTempFile('''
void check(String value) {
  if (value == '') {
    print('empty');
  }
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where(
            (e) => e.errorCode.name == 'avoid_string_literals_in_logic'),
        isEmpty,
      );
    });
  });
}
