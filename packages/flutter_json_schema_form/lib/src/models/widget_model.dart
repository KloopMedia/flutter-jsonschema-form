import 'package:flutter_json_schema_form/src/helpers/helpers.dart';

abstract class WidgetModel {
  final WidgetType type;
  final bool disabled;
  final bool readOnly;

  const WidgetModel({
    required this.type,
    this.disabled = false,
    this.readOnly = false,
  });

  factory WidgetModel.fromUiSchema(Map<String, dynamic>? uiSchema) {
    final type = decodeWidgetType(uiSchema?['ui:widget']);
    switch (type) {
      case WidgetType.radio:
        return RadioModel(type: type);
      case WidgetType.select:
        return SelectModel(type: type);
      case WidgetType.textarea:
        return TextAreaModel(type: type);
      // case WidgetType.audio:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.link:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.password:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.email:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.date:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.dateTime:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.file:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.card:
      //   // TODO: Handle this case.
      //   break;
      // case WidgetType.reader:
      //   // TODO: Handle this case.
      //   break;
      case WidgetType.none:
        return const NullModel();
    }
  }
}

class NullModel extends WidgetModel {

  const NullModel({super.type = WidgetType.none});
}

class SelectModel extends WidgetModel {
  const SelectModel({
    super.type = WidgetType.select,
    super.disabled,
    super.readOnly,
  });
}

class RadioModel extends WidgetModel {
  const RadioModel({
    super.type = WidgetType.radio,
    super.disabled,
    super.readOnly,
  });
}

class TextAreaModel extends WidgetModel {
  final int rows;

  const TextAreaModel({
    this.rows = 4,
    super.type = WidgetType.textarea,
    super.disabled,
    super.readOnly,
  });
}


