part of 'form_parser.dart';

FieldType _getFieldType(Map<String, dynamic> schema) {
  final maybeObject = schema.containsKey("properties") ? "object" : null;
  return decodeFieldType(schema['type'] ?? maybeObject);
}

List<String> _getRequiredFields(Map<String, dynamic> schema) {
  if (schema.containsKey('required')) {
    return (schema['required'] as List<dynamic>).cast();
  } else {
    return [];
  }
}

List<String> _getOrder(Map<String, dynamic>? uiSchema) {
  if (uiSchema == null || !uiSchema.containsKey('ui:order')) {
    return [];
  }
  return (uiSchema['ui:order'] as List<dynamic>).cast();
}

Map<String, dynamic>? _getDependencies(Map<String, dynamic> schema) {
  if (schema['dependencies'] != null) {
    return Map.from(schema['dependencies']);
  } else {
    return null;
  }
}

List<Field> _parsePropertiesFields(
  Map<String, dynamic> properties,
  List<String> required,
  PathModel path, {
  Map<String, dynamic>? uiSchema,
  Dependency? dependency,
}) {
  final List<Field> subFields = [];

  for (final entry in properties.entries) {
    final id = entry.key;
    final subSchema = entry.value;

    final subField = parseSchema(
      id: id,
      schema: subSchema,
      path: path,
      dependency: dependency,
      isRequired: required.contains(id),
      uiSchema: uiSchema?[id],
    );
    subFields.addAll(subField);
  }

  return subFields;
}

List<Field> _parseDependenciesFields(
  Map<String, dynamic> dependencies,
  PathModel path,
  List<Field> propertyFields, {
  Map<String, dynamic>? uiSchema,
}) {
  final List<Field> subFields = [];

  for (final entry in dependencies.entries) {
    final dependencyParentId = entry.key;
    final List<Map<String, dynamic>> variants = entry.value['oneOf'];
    for (final variant in variants) {
      final Map<String, dynamic> properties = Map.of(variant['properties']);

      final dependencyParentPath = path.add(dependencyParentId, FieldType.object);
      final List<dynamic> conditions = properties.remove(dependencyParentId)?['enum'] ?? [];
      final objectFromProperties = {...variant, "properties": properties};

      Field? parentField;
      try {
        parentField = propertyFields.firstWhere((element) => element.id == dependencyParentId);
      } catch (e) {
        parentField = null;
      }

      final dependency = Dependency(
        parentId: dependencyParentId,
        parentPath: dependencyParentPath,
        conditions: conditions,
        parentDependency: parentField?.dependency,
      );

      if (properties.isNotEmpty) {
        final parsedDependencies = parseSchema(
          schema: objectFromProperties,
          path: path,
          dependency: dependency,
          uiSchema: uiSchema,
        );
        subFields.addAll(parsedDependencies);
      }
    }
  }

  return _unwrapDependencies(subFields);
}

Map<String, List<Field>> _createOrderMap(List<Field> fields) {
  final Map<String, List<Field>> orderMap = {};
  for (var field in fields) {
    orderMap.putIfAbsent(field.id, () => []).add(field);
  }
  return orderMap;
}

List<Field> _sortFields(
  List<Field> objectFields,
  List<Field> dependencyFields,
  List<String>? order,
) {
  final fields = [...objectFields, ...dependencyFields];

  if (order == null || order.isEmpty) {
    return fields;
  }

  final orderMap = _createOrderMap(fields);

  /// Fields not included in ui:order.
  final other = orderMap.keys.where((element) => !order.contains(element));

  var orderSchema = List.of(order);
  if (order.contains('*')) {
    final wildCardIndex = order.indexOf('*');
    orderSchema.insertAll(wildCardIndex, other);
    orderSchema.remove('*');
  } else {
    orderSchema.addAll(other);
  }
  List<Field> sortedFields = [];
  for (var element in orderSchema) {
    final schemaFields = orderMap[element];
    if (schemaFields != null) {
      sortedFields.addAll(schemaFields);
    }
  }
  for (var dependency in dependencyFields) {
    if (!order.contains(dependency.id)) {
      final index = objectFields.indexWhere((field) => field.id == dependency.dependency?.parentId);
      if (index >= 0) {
        sortedFields.insert(index + 1, dependency);
      }
    }
  }
  return sortedFields;
}

List<Field> _unwrapDependencies(List<Field> dependencies) {
  return dependencies.expand((element) {
    if (element is Section) {
      return element.fields;
    }
    return [element];
  }).toList();
}

Map<String, dynamic>? _uiSchemaAtIndex(Map<String, dynamic>? uiSchema, String id, int index) {
  final _uiSchema = uiSchema?[id];
  try {
    return _uiSchema != null ? _uiSchema[index] : null;
  } on RangeError {
    return null;
  }
}
