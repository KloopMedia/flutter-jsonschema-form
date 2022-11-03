import '../models/models.dart';
import 'helpers.dart';

class FormSerializer {
  static List<FieldModel> mapJsonToFields(
    Map<String, dynamic> schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    Map<String, dynamic> fieldMap = schema;
    List<FieldModel> fields = [];
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

  static FieldModel _createModelFromSchema({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic> uiSchema,
    required PathModel path,
  }) {
    final type = decodeFieldType(schema['type']);
    final newPath = PathModel([...path.path, PathItem(id, type)]);
    switch (type) {
      case FieldType.object:
        final dependencies = parseSchemaDependencies(schema['dependencies'], uiSchema, newPath);
        return SectionModel(
          id: id,
          fields: mapJsonToFields(schema['properties'], uiSchema, newPath),
          path: newPath,
          dependencies: dependencies,
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
          widgetType: decodeWidgetType(uiSchema['ui:widget']),
          enumItems: schema['enum'],
          enumNames: schema['enumNames'],
          path: newPath,
        );
      default:
        throw Exception("Model not implemented for type $type");
    }
  }

  static ArrayModel _createArrayModel({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic> uiSchema,
    required PathModel path,
  }) {
    final items = schema['items'];
    final itemsUi = uiSchema['items'];
    if (items is List) {
      final fields = _createFixedArrayFields(items, itemsUi, path);
      return ArrayModel.fixed(id: id, items: fields, path: path);
    } else if (items is Map<String, dynamic>) {
      final itemType = _createModelFromSchema(id: '', schema: items, uiSchema: uiSchema, path: path)
          as TextFieldModel;
      return ArrayModel.dynamic(id: id, itemType: itemType, path: path);
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
      return _createModelFromSchema(id: index.toString(), schema: field, uiSchema: ui, path: path);
    }).toList();
    return fields;
  }

  static List<DependencyModel> parseSchemaDependencies(
      Map<String, dynamic>? schema, Map<String, dynamic>? uiSchema, PathModel path) {
    if (schema == null) {
      return [];
    }
    List<DependencyModel> deps = [];
    for (final field in schema.entries) {
      final id = field.key;
      final value = field.value;
      if (value.containsKey('oneOf')) {
        List<Map<String, dynamic>> dependencies = value['oneOf'];
        for (final dependency in dependencies) {
          Map<String, dynamic> fields = dependency['properties'];
          final Map<String, dynamic> condition = fields.remove(id);
          final List<dynamic> conditionValues = condition['enum'];
          for (final item in fields.entries) {
            deps.add(
              DependencyModel(
                parentId: id,
                values: conditionValues,
                field: _createModelFromSchema(
                  id: item.key,
                  schema: item.value,
                  uiSchema: uiSchema?[item.key] ?? {},
                  path: path,
                ),
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
