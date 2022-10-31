import '../helpers/helpers.dart';
import 'models.dart';

class Array extends Field {
  final bool isFixed;
  final List<Field>? items;
  final Field? itemType;

  Array.dynamic({
    required String id,
    String? title,
    String? description,
    FieldType? fieldType,
    WidgetType? widgetType,
    this.itemType,
    required PathModel path,
  })  : isFixed = false,
        items = null,
        super(
          id: id,
          title: title,
          description: description,
          fieldType: fieldType,
          widgetType: widgetType,
          path: path,
        );

  Array.fixed({
    required String id,
    String? title,
    String? description,
    FieldType? fieldType,
    WidgetType? widgetType,
    required this.items,
    required PathModel path,
  })  : itemType = null,
        isFixed = true,
        super(
          id: id,
          title: title,
          description: description,
          fieldType: fieldType,
          widgetType: widgetType,
          path: path,
        );
}
