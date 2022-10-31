import '../models/models.dart';
import 'helpers.dart';

class FormSerializer {
  static List<Field> mapJsonToFields(
    Map<String, dynamic> schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    Map<String, dynamic> fieldMap = schema;
    List<Field> fields = [];
    for (var field in fieldMap.entries) {
      Map<String, dynamic> ui = uiSchema != null ? uiSchema[field.key] ?? {} : {};
      fields.add(_createModelFromSchema(
        id: field.key,
        schema: field.value,
        uiSchema: ui,
        path: path,
      ));
    }
    return fields;
  }

  static Field _createModelFromSchema({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic> uiSchema,
    required PathModel path,
  }) {
    final type = decodeFieldType(schema['type']);
    final newPath = PathModel([...path.path, PathItem(id, type)]);
    switch (type) {
      case FieldType.object:
        return Section(
          id: id,
          fields: mapJsonToFields(schema['properties'], uiSchema, newPath),
          path: newPath,
        );
      case FieldType.array:
        return _createArrayModel(
          id: id,
          schema: schema,
          uiSchema: uiSchema,
          path: newPath,
        );
      case FieldType.string:
        return TextFieldModel(
          id: id,
          title: schema['title'],
          description: schema['description'],
          fieldType: type,
          widgetType: decodeWidgetType(uiSchema['ui:widget']),
          enumOptions: schema['enum'],
          enumNames: schema['enumNames'],
          path: newPath,
        );
      case FieldType.number:

      case FieldType.integer:

      case FieldType.boolean:

      default:
        throw Exception("Model not implemented for type $type");
    }
  }

  static Array _createArrayModel({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic> uiSchema,
    required PathModel path,
  }) {
    final items = schema['items'];
    final itemsUi = uiSchema['items'];
    if (items is List) {
      final fields = _createFixedArrayFields(items, itemsUi, path);
      return Array.fixed(id: id, items: fields, path: path);
    } else if (items is Map<String, dynamic>) {
      final itemType = _createModelFromSchema(id: '', schema: items, uiSchema: uiSchema, path: path)
          as TextFieldModel;
      return Array.dynamic(id: id, itemType: itemType, path: path);
    } else {
      throw Exception('Incorrect type of items in $id');
    }
  }

  static List<Field> _createFixedArrayFields(List items, List itemsUi, PathModel path) {
    final fields = items.mapWithIndex((e, index) {
      final field = e as Map<String, dynamic>;
      Map<String, dynamic> ui;
      try {
        ui = itemsUi[index];
      } catch (e) {
        ui = {};
      }
      return _createModelFromSchema(id: index.toString(), schema: field, uiSchema: ui, path: path);
    }).toList();
    return fields;
  }
}

extension on Iterable {
  Iterable<T> mapWithIndex<T, E>(T Function(E e, int i) toElement) sync* {
    int index = 0;
    for (var value in this) {
      yield toElement(value, index);
      index++;
    }
  }
}
