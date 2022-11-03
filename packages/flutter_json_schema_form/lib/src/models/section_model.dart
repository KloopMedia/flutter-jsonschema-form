import '../helpers/helpers.dart';
import 'models.dart';

class SectionModel extends FieldModel {
  final List<FieldModel> fields;
  final List<DependencyModel> dependencies;

  const SectionModel({
    required String id,
    String? title,
    String? description,
    FieldType? type,
    required PathModel path,
    required this.fields,
    required this.dependencies,
  }) : super.init(
          id: id,
          title: title,
          description: description,
          fieldType: type,
          path: path,
        );

  factory SectionModel.fromJson(Map<String, dynamic> schema, Map<String, dynamic> uiSchema) {
    final type = decodeFieldType(schema['type']);
    const path = PathModel([]);
    final dependencies = FormSerializer.parseSchemaDependencies(schema['dependencies'], uiSchema, path);
    return SectionModel(
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
