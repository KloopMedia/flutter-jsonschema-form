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
