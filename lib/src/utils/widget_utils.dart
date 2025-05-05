import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

/// Extensions for widget-related checks on ClassElement
extension WidgetClassChecks on ClassElement {
  /// Checks if this class is a widget
  bool isWidget() {
    // Direct check for core Flutter widgets
    if (isFlutterWidgetByName()) {
      return true;
    }

    // Check if it has a build method that returns a widget type
    if (hasBuildMethod()) {
      return true;
    }

    // Check if it has a createState method (StatefulWidget)
    if (hasCreateStateMethod()) {
      return true;
    }

    // Check superclass
    final supertype = this.supertype;
    if (supertype != null && supertype.element is ClassElement) {
      return (supertype.element as ClassElement).isWidget();
    }

    return false;
  }

  /// Checks if this class is a Flutter widget by name
  bool isFlutterWidgetByName() {
    final widgetBaseClasses = [
      'StatelessWidget',
      'StatefulWidget',
      'Widget',
      'PreferredSizeWidget',
      'RenderObjectWidget',
      'Text',
      'Container',
      'Row',
      'Column',
      // Add more common widget classes as needed
    ];

    if (widgetBaseClasses.contains(name)) {
      final libraryPath = library.source.uri.toString();
      return libraryPath.contains('flutter');
    }

    return false;
  }

  /// Checks if this class has a build method that takes a BuildContext
  bool hasBuildMethod() {
    return methods.any((method) =>
        method.name == 'build' &&
        method.parameters[0].type
            .getDisplayString(withNullability: false)
            .contains('BuildContext'));
  }

  /// Checks if this class has a createState method that returns a State with a build method
  bool hasCreateStateMethod() {
    return methods.any((method) =>
        method.name == 'createState' &&
        method.returnType.element is ClassElement &&
        (method.returnType.element as ClassElement).hasBuildMethod());
  }
}

/// Extensions for widget-related checks on DartType
extension WidgetTypeChecks on DartType {
  /// Checks if this type is a widget type
  bool isWidget() {
    final element = this.element;
    if (element is ClassElement) {
      return element.isWidget();
    }
    return false;
  }
}
