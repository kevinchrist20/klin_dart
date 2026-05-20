import 'package:test/test.dart';
import 'package:klin_dart/src/best_practices/avoid_hardcoded_strings_in_widgets.dart';

import 'test_utils.dart';

// The rule uses type-based widget detection. To avoid requiring Flutter as a
// dependency, tests define a minimal "fake" widget class that satisfies the
// isWidget() check: a class with a `build(BuildContext context)` method causes
// hasBuildMethod() to return true, which makes isWidget() return true.

void main() {
  group('AvoidHardcodedStringsInWidgetsRule', () {
    test('reports a string literal inside a widget constructor', () async {
      final rule = AvoidHardcodedStringsInWidgetsRule();
      final file = writeToTempFile('''
class BuildContext {}
class Widget {}

class FakeWidget {
  final String? label;
  FakeWidget({this.label});
  Widget build(BuildContext context) => Widget();
}

void main() {
  FakeWidget(label: 'hardcoded text');
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'avoid_hardcoded_strings_in_ui'),
        hasLength(1),
      );
    });

    test('does not report an empty string inside a widget constructor', () async {
      final rule = AvoidHardcodedStringsInWidgetsRule();
      final file = writeToTempFile('''
class BuildContext {}
class Widget {}

class FakeWidget {
  final String? label;
  FakeWidget({this.label});
  Widget build(BuildContext context) => Widget();
}

void main() {
  FakeWidget(label: '');
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'avoid_hardcoded_strings_in_ui'),
        isEmpty,
      );
    });

    test('does not report a string literal outside a widget context', () async {
      final rule = AvoidHardcodedStringsInWidgetsRule();
      final file = writeToTempFile('''
void main() {
  final message = 'hello world';
  print(message);
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'avoid_hardcoded_strings_in_ui'),
        isEmpty,
      );
    });

    test('does not report a string in a plain (non-widget) class constructor',
        () async {
      final rule = AvoidHardcodedStringsInWidgetsRule();
      // PlainClass has no build(BuildContext) method, so isWidget() = false
      final file = writeToTempFile('''
class PlainClass {
  final String label;
  PlainClass({required this.label});
}

void main() {
  PlainClass(label: 'not a widget');
}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'avoid_hardcoded_strings_in_ui'),
        isEmpty,
      );
    });
  });
}
