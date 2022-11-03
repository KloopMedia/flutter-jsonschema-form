import '../helpers/helpers.dart';
import 'models.dart';

class Section extends Field {
  final List<Field> fields;
  final List<Dependency> dependencies;

  Section({
    required String id,
    String? title,
    String? description,
    FieldType? type,
    required PathModel path,
    required this.fields,
    required this.dependencies,
  }) : super(
          id: id,
          title: title,
          description: description,
          fieldType: type,
          path: path,
        );

  factory Section.fromJson(Map<String, dynamic> schema, Map<String, dynamic> uiSchema) {
    final type = decodeFieldType(schema['type']);
    final path = PathModel([]);
    final dependencies = FormSerializer.parseSchemaDependencies(schema['dependencies'], uiSchema, path);
    return Section(
      id: "#",
      title: schema['title'],
      description: schema['description'],
      type: type,
      fields: FormSerializer.mapJsonToFields(schema['properties'], uiSchema, path),
      path: path,
      dependencies: dependencies,
    );
  }
}
