import 'package:flutter_json_schema_form/src/helpers/helpers.dart';
import 'package:flutter_json_schema_form/src/models/models.dart';
import 'package:flutter_json_schema_form/src/models/widget_models/null_widget_model.dart';

abstract class WidgetModel {
  WidgetModel();

  static const _widgetEnumMap = {
    WidgetType.select: 'select',
    WidgetType.textarea: 'textarea',
    WidgetType.radio: 'radio',
    WidgetType.audio: 'audio',
    WidgetType.link: ['customlink', 'link'],
    WidgetType.password: 'password',
    WidgetType.file: ['customfile', 'file'],
    WidgetType.recorder: 'recorder',
    WidgetType.webhook: 'webhook',
  };

  static WidgetType _decodeWidgetType(String? type) =>
      enumDecodeNullable(_widgetEnumMap, type) ?? WidgetType.none;

  factory WidgetModel.fromUiSchema(Map<String, dynamic>? uiSchema) {
    final widget = _decodeWidgetType(uiSchema?['ui:widget']);
    final options = uiSchema?['options'];

    switch (widget) {
      case WidgetType.radio:
        return RadioWidgetModel();
      case WidgetType.select:
        return SelectWidgetModel();
      case WidgetType.textarea:
        return TextAreaWidgetModel(options);
      case WidgetType.audio:
        return AudioWidgetModel(options);
      case WidgetType.link:
        return LinkWidgetModel();
      case WidgetType.password:
        return PasswordWidgetModel();
      case WidgetType.file:
        return FileWidgetModel(options);
      case WidgetType.recorder:
        return RecorderWidgetModel(options);
      case WidgetType.webhook:
        return WebhookTriggerWidgetModel(options);
      default:
        return NullWidgetModel();
    }
  }
}

T? getOption<T>(Map<String, dynamic>? options, String property) {
  try {
    return options?[property] as T;
  } catch (_) {
    return null;
  }
}
