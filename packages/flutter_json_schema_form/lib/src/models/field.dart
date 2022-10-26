import '../helpers/helpers.dart';

abstract class Field {
  String? id;
  String? title;
  String? description;
  FieldType? fieldType;
  WidgetType? widgetType;

  Field({
    this.id,
    this.title,
    this.description,
    this.fieldType,
    this.widgetType,
  });

  String? get fieldTitle => title ?? id;

  set setId(String id) => this.id = id;
}
