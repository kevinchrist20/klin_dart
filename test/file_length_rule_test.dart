import 'package:test/test.dart';
import 'package:klin_dart/src/best_practices/file_length_rule.dart';

import 'test_utils.dart';

void main() {
  group('FileLengthRule', () {
    test('reports a file that exceeds maxLines', () async {
      final rule = FileLengthRule(maxLines: 5);
      final file = writeToTempFile('''
void a() {}
void b() {}
void c() {}
void d() {}
void e() {}
void f() {}
void g() {}
void h() {}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'file_length'),
        hasLength(1),
      );
    });

    test('does not report a file within maxLines', () async {
      final rule = FileLengthRule(maxLines: 20);
      final file = writeToTempFile('''
void a() {}
void b() {}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'file_length'),
        isEmpty,
      );
    });

    test('excludes import lines from the line count', () async {
      // Without exclusion: 4 imports + 4 functions = 8+ lines > 5.
      // With exclusion: only 4 function lines are counted → 4 NOT > 5 → no report.
      final rule = FileLengthRule(maxLines: 5);
      final file = writeToTempFile('''
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
void a() {}
void b() {}
void c() {}
void d() {}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      expect(
        errors.where((e) => e.errorCode.name == 'file_length'),
        isEmpty,
      );
    });

    test('error message contains actual and max line counts', () async {
      final rule = FileLengthRule(maxLines: 3);
      final file = writeToTempFile('''
void a() {}
void b() {}
void c() {}
void d() {}
void e() {}
void f() {}
''');
      final errors = await rule.testAnalyzeAndRun(file);
      final fileLengthErrors =
          errors.where((e) => e.errorCode.name == 'file_length').toList();
      expect(fileLengthErrors, hasLength(1));
      expect(fileLengthErrors.first.message, contains('3'));
    });
  });
}
