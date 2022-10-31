import 'package:json_annotation/json_annotation.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class Section extends Field {
  final List<Field> fields;

  Section({
    required String id,
    String? title,
    String? description,
    FieldType? type,
    required PathModel path,
    required this.fields,
  }) : super(
          id: id,
          title: title,
          description: description,
          fieldType: type,
          path: path,
        );

  factory Section.fromJson(Map<String, dynamic> schema, Map<String, dynamic> uiSchema) {
    final type = $enumDecodeNullable(typeEnumMap, schema['type']);
    final path = PathModel([]);
    return Section(
      id: "\$root",
      title: schema['title'],
      description: schema['description'],
      type: type,
      fields: FormSerializer.mapJsonToFields(schema['properties'], uiSchema, path),
      path: path,
    );
  }
}
