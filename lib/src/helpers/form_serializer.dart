import '../models/models.dart';
import 'helpers.dart';

class FormSerializer {
  static List<dynamic> serialize(Map<String, dynamic> schema, Map<String, dynamic>? uiSchema) {
    if (schema.isNotEmpty) {
      final model = createModelFromSchema(
        id: '#',
        schema: schema,
        uiSchema: uiSchema,
        path: null,
        isRequired: false,
        dependency: null,
      );
      return [model];
    }
    return [];
  }

  static List<BaseModel> mapSchemaToFields(
    Map<String, dynamic> schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    if (!schema.containsKey('properties')) {
      return [];
    }
    Map<String, dynamic> fieldMap = schema['properties'];
    final required = getRequiredFields(schema);
    List<BaseModel> fields = fieldMap.entries.map((field) {
      final isRequired = required.contains(field.key);
      return createModelFromSchema(
        id: field.key,
        schema: field.value,
        uiSchema: uiSchema?[field.key],
        path: path,
        isRequired: isRequired,
        dependency: null,
      );
    }).toList();
    return fields;
  }

  static BaseModel createModelFromSchema({
    required String id,
    required Map<String, dynamic> schema,
    required Map<String, dynamic>? uiSchema,
    required PathModel? path,
    required bool isRequired,
    required DependencyModel? dependency,
  }) {
    final type = getFieldType(schema);
    final newPath = addPath(path, id, type);
    final widget = WidgetModel.fromUiSchema(uiSchema);

    switch (type) {
      case FieldType.object:
        final requiredFields = getRequiredFields(schema);
        final fields = createSectionFieldList(schema, uiSchema, newPath);
        return SectionModel(
          id: id,
          fields: fields,
          path: newPath,
          required: requiredFields,
          title: schema['title'],
          description: schema['description'],
          dependency: null,
        );
      case FieldType.array:
        return ArrayModel.fromSchema(
          id: id,
          schema: schema,
          uiSchema: uiSchema,
          path: newPath,
          dependency: dependency,
        );
      case FieldType.string:
        return TextFieldModel.fromSchema(
            id: id,
            path: newPath,
            schema: schema,
            uiSchema: uiSchema,
            isRequired: isRequired,
            widget: widget,
            dependency: dependency,
            format: decodeFormatType(schema['format']));
      case FieldType.number:
      case FieldType.integer:
        return NumberFieldModel.fromSchema(
          id: id,
          path: newPath,
          schema: schema,
          uiSchema: uiSchema,
          isRequired: isRequired,
          widget: widget,
          dependency: dependency,
        );
      case FieldType.boolean:
        return BooleanFieldModel(
          id: id,
          title: schema['title'],
          description: schema['description'],
          widget: WidgetModel.fromUiSchema(uiSchema),
          enumNames: schema['enumNames'],
          path: newPath,
          isRequired: isRequired,
          defaultValue: schema['default'],
          disabled: uiSchema?['ui:disabled'],
          readOnly: uiSchema?['ui:readonly'],
          dependency: dependency,
        );
      default:
        throw Exception("Model doesn't exist for type $type");
    }
  }

  static List<dynamic> createSectionFieldList(
    Map<String, dynamic> schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    final fields = mapSchemaToFields(schema, uiSchema, path);
    final dependencies = parseSchemaDependencies(schema, uiSchema, path);
    final order = getOrder(uiSchema);
    // final sorted = sortFields(fields, dependencies, order);
    // return sorted;
    return [...fields, ...dependencies];
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

  // static List<dynamic> sortFields(
  //     List<BaseModel> fields, List<DependencyModel> dependencies, List<String>? order) {
  //   if (order == null) {
  //     return fields;
  //   }
  //   final List<dynamic> allFields = [...fields, ...dependencies];
  //   final Map<String, List> fieldSchema = {};
  //   for (var field in allFields) {
  //     final schemaFields = fieldSchema[field.id] ?? [];
  //     fieldSchema[field.id] = [...schemaFields, field];
  //   }
  //   final other = fieldSchema.keys.where((element) => !order.contains(element));
  //   var orderSchema = List.of(order);
  //   if (order.contains('*')) {
  //     final wildCardIndex = order.indexOf('*');
  //     orderSchema.insertAll(wildCardIndex, other);
  //     orderSchema.remove('*');
  //   } else {
  //     orderSchema.addAll(other);
  //   }
  //   List<dynamic> sortedFields = [];
  //   for (var element in orderSchema) {
  //     final schemaFields = fieldSchema[element];
  //     if (schemaFields != null) {
  //       for (var field in schemaFields) {
  //         sortedFields.add(field);
  //       }
  //     }
  //   }
  //   for (var dependency in dependencies) {
  //     if (!order.contains(dependency.id)) {
  //       final index = fields.indexWhere((field) => field.id == dependency.parentId);
  //       if (!index.isNegative) {
  //         sortedFields.insert(index + 1, dependency);
  //       }
  //     }
  //   }
  //   return sortedFields;
  // }

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

  static List<BaseModel> parseSchemaDependencies(
    Map<String, dynamic>? schema,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    if (schema == null || !schema.containsKey('dependencies')) {
      return [];
    }
    final Map<String, dynamic> fieldMap = schema['dependencies'];

    return fieldMap.entries
        .map((field) => _parseDependencySchema(field, uiSchema, path))
        .expand((e) => e)
        .toList();
  }

  static Iterable<BaseModel> _parseDependencySchema(
    MapEntry<String, dynamic> field,
    Map<String, dynamic>? uiSchema,
    PathModel path,
  ) {
    final id = field.key;
    final value = field.value;
    if (value.containsKey('oneOf')) {
      List<Map<String, dynamic>> dependencySchemaList = (value['oneOf'] as List<dynamic>).cast();
      return dependencySchemaList
          .map((dependency) => _parseSubDependencySchema(id, path, dependency, uiSchema).toList())
          .expand((e) => e);
    }
    return [];
  }

  static Iterable<BaseModel> _parseSubDependencySchema(
    String id,
    PathModel path,
    Map<String, dynamic> schema,
    Map<String, dynamic>? uiSchema,
  ) {
    Map<String, dynamic> fields = Map.of(schema['properties']);

    final Map<String, dynamic>? conditionField = fields.remove(id);
    final List<dynamic> displayConditions = conditionField?['enum'] ?? [];

    final required = getRequiredFields(schema);

    return fields.entries.map((field) {
      final isRequired = required.contains(field.key);
      final ui = uiSchema?[field.key];
      return _createFieldWithDependency(id, path, field, ui, isRequired, displayConditions);
    });
  }

  static BaseModel _createFieldWithDependency(
    String id,
    PathModel path,
    MapEntry<String, dynamic> field,
    Map<String, dynamic>? uiSchema,
    bool isRequired,
    List conditions,
  ) {
    final dependency = DependencyModel(
      parentId: id,
      parentPath: path.add(id, null),
      values: conditions,
    );

    return createModelFromSchema(
      id: field.key,
      schema: field.value,
      uiSchema: uiSchema,
      path: path,
      isRequired: isRequired,
      dependency: dependency,
    );
  }
}

// extension Flatten<T extends Object> on Iterable<T> {
//   Iterable<T> flatten() {
//     Iterable<T> _flatten(Iterable<T> list) sync* {
//       for (final value in list) {
//         if (value is List<T>) {
//           yield* _flatten(value);
//         } else {
//           yield value;
//         }
//       }
//     }
//
//     return _flatten(this);
//   }
// }
