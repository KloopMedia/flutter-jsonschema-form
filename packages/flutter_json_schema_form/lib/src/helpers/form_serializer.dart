import 'package:json_annotation/json_annotation.dart';

import '../models/models.dart';
import 'helpers.dart';

class FormSerializer {
  static List<Field> mapJsonToFields(Map<String, dynamic> schema, Map<String, dynamic>? uiSchema) {
    Map<String, dynamic> fieldMap = schema;
    List<Field> fields = [];
    for (var field in fieldMap.entries) {
      Map<String, dynamic> lui = uiSchema != null ? uiSchema[field.key] ?? {} : {};
      fields.add(createModelFromSchema(field.key, field.value, lui));
    }
    return fields;
  }

  static Field createModelFromSchema(
    String id,
    Map<String, dynamic> schema,
    Map<String, dynamic> ui,
  ) {
    return _getModelFromSchema(id: id, schema: schema, uiSchema: ui);
  }

  static Array _createArrayModel({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic> uiSchema,
  }) {
    final items = schema['items'];
    final itemsUi = uiSchema['items'];
    if (items is List) {
      final fields = _createFixedArrayFields(items, itemsUi);
      return Array.fixed(id: id, items: fields);
    } else if (items is Map<String, dynamic>) {
      final itemType = createModelFromSchema('1', items, uiSchema) as TextFieldModel;
      return Array.dynamic(id: id, itemType: itemType);
    } else {
      throw Exception('Incorrect type of items in $id');
    }
  }

  static List<Field> _createFixedArrayFields(List items, List itemsUi) {
    final fields = items.mapWithIndex((e, index) {
      final field = e as Map<String, dynamic>;
      Map<String, dynamic> ui;
      try {
        ui = itemsUi[index];
      } catch (e) {
        ui = {};
      }
      return createModelFromSchema(index.toString(), field, ui) as TextFieldModel;
    }).toList();
    return fields;
  }

  static Field _getModelFromSchema({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic> uiSchema,
  }) {
    final type = $enumDecodeNullable(typeEnumMap, schema['type']);
    switch (type) {
      case FieldType.object:
        return Section(id: id, fields: mapJsonToFields(schema['properties'], uiSchema));
      case FieldType.array:
        return _createArrayModel(id: id, schema: schema, uiSchema: uiSchema);
      case FieldType.string:
        return TextFieldModel(
          id: id,
          title: schema['title'],
          description: schema['description'],
          fieldType: type,
          widgetType: $enumDecodeNullable(widgetEnumMap, uiSchema['ui:widget']),
          enumOptions: schema['enum'],
          enumNames: schema['enumNames'],
        );
      case FieldType.number:

      case FieldType.integer:

      case FieldType.boolean:

      default:
        return Section(fields: []);
    }
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
