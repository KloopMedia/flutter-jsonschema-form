import 'package:json_annotation/json_annotation.dart';

import '../helpers/helpers.dart';
import 'models.dart';

class Section extends Field {
  final List<Field> fields;

  Section({
    String? id,
    String? title,
    String? description,
    FieldType? type,
    required this.fields,
  }) : super(
          id: id,
          title: title,
          description: description,
          fieldType: type,
        );

  factory Section.fromJson(Map<String, dynamic> json, Map<String, dynamic> ui) {
    return Section(
      title: json['title'],
      description: json['description'],
      type: $enumDecodeNullable(typeEnumMap, json['type']),
      fields: FormSerializer.mapJsonToFields(json['properties'], ui),
    );
  }
}
