import 'package:flutter_json_schema_form/src/models/field_models/base_model.dart';

import '../../helpers/helpers.dart';
import '../models.dart';

class SectionModel extends BaseModel {
  final List<dynamic> fields;
  final List<String> required;

  SectionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.path,
    required super.dependency,
    required this.fields,
    required this.required,
  }) : super(fieldType: FieldType.object);

  @override
  BaseModel copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
