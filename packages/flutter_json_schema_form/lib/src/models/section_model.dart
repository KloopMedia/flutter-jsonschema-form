import '../helpers/helpers.dart';
import 'models.dart';

class SectionModel extends FieldModel {
  final List<FieldModel> fields;
  final List<DependencyModel> dependencies;
  final List<String> required;
  final List<String>? order;

  const SectionModel({
    required String id,
    String? title,
    String? description,
    FieldType? type,
    required PathModel path,
    required this.fields,
    required this.dependencies,
    required this.required,
    this.order,
  }) : super.init(
          id: id,
          title: title,
          description: description,
          fieldType: type,
          path: path,
          isRequired: false,
        );

  factory SectionModel.fromJson(Map<String, dynamic> schema, Map<String, dynamic> uiSchema) {
    final type = decodeFieldType(schema['type']);
    const path = PathModel([]);
    final dependencies =
        FormSerializer.parseSchemaDependencies(schema, uiSchema, path);
    final required = FormSerializer.getRequiredFields(schema);
    return SectionModel(
      id: "#",
      title: schema['title'],
      description: schema['description'],
      type: type,
      fields: FormSerializer.mapJsonToFields(schema, uiSchema, path),
      path: path,
      dependencies: dependencies,
      required: required,
      order: uiSchema['ui:order'],
    );
  }
}
