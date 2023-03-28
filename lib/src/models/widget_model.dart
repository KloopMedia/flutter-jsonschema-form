import 'package:flutter_json_schema_form/src/helpers/helpers.dart';

abstract class WidgetModel {
  final WidgetType type;

  const WidgetModel({
    required this.type,
  });

  factory WidgetModel.fromUiSchema(Map<String, dynamic>? uiSchema) {
    final WidgetType type = decodeWidgetType(uiSchema?['ui:widget']);
    final Map<String, dynamic>? options = uiSchema?['ui:options'];

    switch (type) {
      case WidgetType.radio:
        return const RadioWidgetModel();
      case WidgetType.select:
        return const SelectWidgetModel();
      case WidgetType.link:
        return const LinkWidgetModel();
      case WidgetType.password:
        return const PasswordWidgetModel();
      case WidgetType.textarea:
        final rows = getOption<int>(options, 'rows');
        return TextAreaWidgetModel(rows: rows);
      case WidgetType.audio:
        final private = getOption<bool>(options, 'private');
        final url = getOption<String>(options, 'default');
        return AudioWidgetModel(private: private, url: url);
      case WidgetType.recorder:
        final private = getOption<bool>(options, 'private');
        return RecorderWidgetModel(private: private);
      case WidgetType.file:
        final private = getOption<bool>(options, 'private');
        final multiple = getOption<bool>(options, 'multiple');
        return FileWidgetModel(private: private, multiple: multiple);
      case WidgetType.webhook:
        final label = getOption(options, 'label');
        return WebhookTriggerWidgetModel(label: label);
      case WidgetType.card:
        return const CardWidgetModel();
        break;
      // case WidgetType.reader:
      //   // TODO: Handle this case.
      //   break;
      default:
        return const NullWidgetModel();
    }
  }
}

class FileWidgetModel extends WidgetModel {
  final bool private;
  final bool multiple;

  const FileWidgetModel({required bool? private, required bool? multiple})
      : private = private ?? false,
        multiple = multiple ?? false,
        super(type: WidgetType.file);
}

class PasswordWidgetModel extends WidgetModel {
  const PasswordWidgetModel() : super(type: WidgetType.password);
}

class LinkWidgetModel extends WidgetModel {
  const LinkWidgetModel() : super(type: WidgetType.link);
}

class AudioWidgetModel extends WidgetModel {
  final bool private;
  final String? url;

  const AudioWidgetModel({required bool? private, required this.url})
      : private = private ?? false,
        super(type: WidgetType.audio);
}

class RecorderWidgetModel extends WidgetModel {
  final bool private;

  const RecorderWidgetModel({required bool? private})
      : private = private ?? false,
        super(type: WidgetType.recorder);
}

class SelectWidgetModel extends WidgetModel {
  const SelectWidgetModel() : super(type: WidgetType.select);
}

class RadioWidgetModel extends WidgetModel {
  const RadioWidgetModel() : super(type: WidgetType.radio);
}

class TextAreaWidgetModel extends WidgetModel {
  final int? rows;

  const TextAreaWidgetModel({this.rows})
      : super(type: WidgetType.textarea);
}

class WebhookTriggerWidgetModel extends WidgetModel {
  final String? label;

  WebhookTriggerWidgetModel({this.label}) : super(type: WidgetType.webhook);
}

class CardWidgetModel extends WidgetModel {
  const CardWidgetModel() : super(type: WidgetType.card);
}

class NullWidgetModel extends WidgetModel {
  const NullWidgetModel({super.type = WidgetType.none});
}

T? getOption<T>(Map<String, dynamic>? options, String property) {
  try {
    return options?[property] as T;
  } catch (_) {
    return null;
  }
}
