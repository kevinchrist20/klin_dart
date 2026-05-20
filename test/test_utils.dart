import 'dart:io';

/// Writes [content] to a temporary `.dart` file and returns the [File].
/// Each call creates its own temp directory so tests don't interfere.
File writeToTempFile(String content) {
  final tempDir = Directory.systemTemp.createTempSync('klin_dart_test_');
  return File('${tempDir.path}/test.dart')..writeAsStringSync(content);
}
