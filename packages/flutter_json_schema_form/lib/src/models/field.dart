import '../helpers/helpers.dart';
import 'models.dart';

abstract class Field {
  String id;
  String? title;
  String? description;
  FieldType? fieldType;
  WidgetType? widgetType;
  PathModel path;

  Field({
    required this.id,
    this.title,
    this.description,
    this.fieldType,
    this.widgetType,
    required this.path,
  });

  String? get fieldTitle => title ?? id;

  set setId(String id) => this.id = id;
}
