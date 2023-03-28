import 'package:flutter_json_schema_form/src/models/widget_model.dart';

import '../models/models.dart';
import 'helpers.dart';

class FormSerializer {
  static List<dynamic> serialize(Map<String, dynamic> schema, Map<String, dynamic>? uiSchema) {
    if (schema.isNotEmpty) {
      final model = _createModelFromSchema(
        id: '#',
        schema: schema,
        uiSchema: uiSchema,
        path: null,
        isRequired: false,
      );
      return [model];
    }
    return [];
  }

  static List<FieldModel> mapSchemaToFields(
    Map<String, dynamic> schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    if (!schema.containsKey('properties')) {
      return [];
    }
    Map<String, dynamic> fieldMap = schema['properties'];
    final required = getRequiredFields(schema);
    List<FieldModel> fields = fieldMap.entries.map((field) {
      final isRequired = required.contains(field.key);
      return _createModelFromSchema(
        id: field.key,
        schema: field.value,
        uiSchema: uiSchema?[field.key],
        path: path,
        isRequired: isRequired,
      );
    }).toList();
    return fields;
  }

  static FieldModel _createModelFromSchema({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic>? uiSchema,
    required PathModel? path,
    required bool isRequired,
  }) {
    final type = getFieldType(schema);
    PathModel newPath;
    if (path == null) {
      newPath = const PathModel.empty();
    } else {
      newPath = path.add(id, type);
    }
    switch (type) {
      case FieldType.object:
        final requiredFields = getRequiredFields(schema);
        final fields = createSectionFieldList(schema, uiSchema, newPath);
        final widgetType = decodeWidgetType(uiSchema?['ui:widget']);
        if (widgetType == WidgetType.card) {
          return CardFieldModel(
            id: id,
            fields: fields,
            path: newPath,
            schema: schema,
            uiSchema: uiSchema,
            title: schema['title'],
            description: schema['description'],
          );
        }
        return SectionModel(
          id: id,
          fields: fields,
          path: newPath,
          required: requiredFields,
          title: schema['title'],
          description: schema['description'],
        );
      case FieldType.array:
        return _createArrayModel(
          id: id,
          schema: schema,
          uiSchema: uiSchema,
          path: newPath,
        );
      case FieldType.string:
      case FieldType.number:
      case FieldType.integer:
      case FieldType.boolean:
        return FieldModel(
          id: id,
          title: schema['title'],
          description: schema['description'],
          fieldType: type,
          widgetType: WidgetModel.fromUiSchema(uiSchema),
          enumItems: schema['enum'],
          enumNames: schema['enumNames'],
          path: newPath,
          isRequired: isRequired,
          defaultValue: schema['default'],
          disabled: uiSchema?['ui:disabled'],
          readOnly: uiSchema?['ui:readonly'],
          format: decodeFormatType(schema['format']),
        );
      default:
        throw Exception("Model doesn't exist for type $type");
    }
  }

  static ArrayModel _createArrayModel({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic>? uiSchema,
    required PathModel path,
  }) {
    final items = schema['items'];
    final itemsUi = uiSchema?['items'] ?? [];
    final String? title = schema['title'];
    final String? description = schema['description'];

    if (items is List) {
      final fields = _createFixedArrayFields(items, itemsUi, path);
      return ArrayModel.fixed(
        id: id,
        items: fields,
        path: path,
        title: title,
        description: description,
      );
    } else if (items is Map<String, dynamic>) {
      final itemType = _createModelFromSchema(
        id: '',
        schema: items,
        uiSchema: uiSchema,
        path: path,
        isRequired: true,
      );
      return ArrayModel.dynamic(
        id: id,
        itemType: itemType,
        path: path,
        title: title,
        description: description,
      );
    } else {
      throw Exception('Incorrect type of items in $id');
    }
  }

  static List<FieldModel> _createFixedArrayFields(List items, List itemsUi, PathModel path) {
    final fields = items.mapWithIndex((item, index) {
      final field = item as Map<String, dynamic>;
      Map<String, dynamic> ui;
      try {
        ui = itemsUi[index];
      } on RangeError {
        ui = {};
      }
      return _createModelFromSchema(
          id: index.toString(), schema: field, uiSchema: ui, path: path, isRequired: true);
    }).toList();
    return fields;
  }

  static List<dynamic> createSectionFieldList(
    Map<String, dynamic> schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    final fields = mapSchemaToFields(schema, uiSchema, path);
    final dependencies = parseSchemaDependencies(schema, uiSchema, path);
    final order = getOrder(uiSchema);
    final sorted = sortFields(fields, dependencies, order);
    return sorted;
  }

  static List<String> getRequiredFields(Map<String, dynamic> schema) {
    if (schema.containsKey('required')) {
      return (schema['required'] as List<dynamic>).cast();
    } else {
      return [];
    }
  }

  static List<String> getOrder(Map<String, dynamic>? uiSchema) {
    if (uiSchema == null || !uiSchema.containsKey('ui:order')) {
      return [];
    }
    return (uiSchema['ui:order'] as List<dynamic>).cast();
  }

  static FieldType getFieldType(Map<String, dynamic> schema) {
    return decodeFieldType(schema['type']);
  }

  static List<dynamic> sortFields(
      List<FieldModel> fields, List<DependencyModel> dependencies, List<String>? order) {
    if (order == null) {
      return fields;
    }
    final List<dynamic> allFields = [...fields, ...dependencies];
    final Map<String, List> fieldSchema = {};
    for (var field in allFields) {
      final schemaFields = fieldSchema[field.id] ?? [];
      fieldSchema[field.id] = [...schemaFields, field];
    }
    final other = fieldSchema.keys.where((element) => !order.contains(element));
    var orderSchema = List.of(order);
    if (order.contains('*')) {
      final wildCardIndex = order.indexOf('*');
      orderSchema.insertAll(wildCardIndex, other);
      orderSchema.remove('*');
    } else {
      orderSchema.addAll(other);
    }
    List<dynamic> sortedFields = [];
    for (var element in orderSchema) {
      final schemaFields = fieldSchema[element];
      if (schemaFields != null) {
        for (var field in schemaFields) {
          sortedFields.add(field);
        }
      }
    }
    for (var dependency in dependencies) {
      if (!order.contains(dependency.id)) {
        final index = fields.indexWhere((field) => field.id == dependency.parentId);
        if (!index.isNegative) {
          sortedFields.insert(index + 1, dependency);
        }
      }
    }
    return sortedFields;
  }

  static List<dynamic> insertDependencies(
    List<FieldModel> fields,
    List<DependencyModel> dependencies,
  ) {
    final newFields = List.from(fields);
    for (var dependency in dependencies) {
      final index = fields.indexWhere((field) => field.id == dependency.parentId);
      if (!index.isNegative) {
        newFields.insert(index + 1, dependency);
      }
    }
    return newFields;
  }

  static List<DependencyModel> parseSchemaDependencies(
    Map<String, dynamic>? schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    if (schema == null || !schema.containsKey('dependencies')) {
      return [];
    }
    final Map<String, dynamic> fieldMap = schema['dependencies'];

    List<DependencyModel> deps = [];
    for (final field in fieldMap.entries) {
      final id = field.key;
      final value = field.value;
      if (value.containsKey('oneOf')) {
        List<Map<String, dynamic>> dependencies = (value['oneOf'] as List<dynamic>).cast();
        for (final dependency in dependencies) {
          Map<String, dynamic> fields = Map.of(dependency['properties']);
          final Map<String, dynamic>? condition = fields.remove(id);
          final List<dynamic> conditionValues = condition?['enum'] ?? [];
          final required = getRequiredFields(dependency);
          for (final item in fields.entries) {
            final depField = _createModelFromSchema(
              id: item.key,
              schema: item.value,
              uiSchema: uiSchema?[item.key],
              path: path,
              isRequired: required.contains(item.key),
            );
            deps.add(
              DependencyModel(
                id: depField.id,
                parentId: id,
                parentPath: path.add(id, null),
                values: conditionValues,
                field: depField,
              ),
            );
          }
        }
      }
    }
    return deps;
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
