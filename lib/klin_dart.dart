import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _KlinLinter();

class _KlinLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    // TODO: implement getLintRules
    throw UnimplementedError();
  }
}