import '../models/models.dart';
import 'helpers.dart';

part 'form_parser_helpers.dart';

List<Field> parseSchema({
  String id = "#",
  required Map<String, dynamic> schema,
  Map<String, dynamic>? uiSchema,
  PathModel path = const PathModel.empty(),
  Dependency? dependency,
  bool? isRequired,
}) {
  if (schema.isEmpty) {
    return [];
  }

  final type = _getFieldType(schema);
  final newPath = id == "#" ? path : path.add(id, type);

  final String? title = schema['title'];
  final String? description = schema['description'];

  if (type == FieldType.object) {
    final List<String> required = _getRequiredFields(schema);
    final propertyFields = _parsePropertiesFields(
      schema['properties'],
      required,
      newPath,
      uiSchema: uiSchema,
      dependency: dependency,
    );

    final dependencies = _getDependencies(schema);

    final List<Field> dependencyFields = dependencies != null
        ? _parseDependenciesFields(dependencies, newPath, propertyFields, uiSchema: uiSchema)
        : [];

    final order = _getOrder(uiSchema);
    final subFields = _sortFields(propertyFields, dependencyFields, order);

    return [
      Section(
        id: id,
        path: path,
        type: type,
        fields: subFields,
        dependency: dependency,
        title: title,
        description: description,
      ),
    ];
  } else if (type == FieldType.array) {
    final items = schema['items'];

    if (items is List) {
      final List<Field> subFields = items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final ui = _uiSchemaAtIndex(uiSchema, id, index);
        return parseSchema(id: index.toString(), schema: item, uiSchema: ui, path: newPath).first;
      }).toList();

      return [
        StaticArray(
          id: id,
          path: path,
          type: type,
          fields: subFields,
          title: title,
          description: description,
        )
      ];
    } else if (items is Map<String, dynamic>) {
      final field = parseSchema(schema: items, uiSchema: uiSchema?[id], path: newPath).first;
      return [
        DynamicArray(
          id: id,
          path: newPath,
          type: type,
          field: field,
          title: title,
          description: description,
        )
      ];
    } else {
      throw Exception('Incorrect type of items in $id');
    }
  } else {
    return [
      ValueField.fromSchema(
        id: id,
        path: newPath,
        type: type,
        dependency: dependency,
        isRequired: isRequired ?? false,
        widget: getWidgetModelFromUiSchema(uiSchema),
        schema: schema,
      ),
    ];
  }
}
