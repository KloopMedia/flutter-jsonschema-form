import 'package:flutter_json_schema_form/src/helpers/helpers.dart';

abstract class WidgetModel {
  final WidgetType type;

  const WidgetModel({
    required this.type,
  });

  factory WidgetModel.fromUiSchema(Map<String, dynamic>? uiSchema) {
    if (uiSchema == null) {
      return const NullWidgetModel();
    }
    final type = decodeWidgetType(uiSchema['ui:widget']);
    final Map<String, dynamic>? options = uiSchema['ui:options'];

    switch (type) {
      case WidgetType.radio:
        return const RadioWidgetModel();
      case WidgetType.select:
        return const SelectWidgetModel();
      case WidgetType.link:
        return const LinkWidgetModel();
      case WidgetType.password:
        return const PasswordWidgetModel();
      case WidgetType.email:
        return const EmailWidgetModel();
      case WidgetType.date:
        return const DateWidgetModel();
      case WidgetType.dateTime:
        return const DateTimeWidgetModel();
      case WidgetType.textarea:
        final rows = getOption<int>(options, 'rows');
        return TextAreaWidgetModel(rows: rows);
      case WidgetType.audio:
        final private = getOption<bool>(options, 'private');
        return AudioWidgetModel(private: private);
      case WidgetType.file:
        final private = getOption<bool>(options, 'private');
        final multiple = getOption<bool>(options, 'multiple');
        return FileWidgetModel(private: private, multiple: multiple);
      // case WidgetType.card:
      //   // TODO: Handle this case.
      //   break;
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

class DateTimeWidgetModel extends WidgetModel {
  const DateTimeWidgetModel() : super(type: WidgetType.dateTime);
}

class DateWidgetModel extends WidgetModel {
  const DateWidgetModel() : super(type: WidgetType.date);
}

class EmailWidgetModel extends WidgetModel {
  const EmailWidgetModel() : super(type: WidgetType.email);
}

class PasswordWidgetModel extends WidgetModel {
  const PasswordWidgetModel() : super(type: WidgetType.password);
}

class LinkWidgetModel extends WidgetModel {
  const LinkWidgetModel() : super(type: WidgetType.link);
}

class AudioWidgetModel extends WidgetModel {
  final bool private;

  const AudioWidgetModel({required bool? private})
      : private = private ?? false,
        super(type: WidgetType.audio);
}

class SelectWidgetModel extends WidgetModel {
  const SelectWidgetModel() : super(type: WidgetType.select);
}

class RadioWidgetModel extends WidgetModel {
  const RadioWidgetModel() : super(type: WidgetType.radio);
}

class TextAreaWidgetModel extends WidgetModel {
  final int rows;

  const TextAreaWidgetModel({int? rows})
      : rows = rows ?? 4,
        super(type: WidgetType.textarea);
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
