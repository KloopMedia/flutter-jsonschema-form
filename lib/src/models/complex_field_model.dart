import 'field_model.dart';

abstract class ComplexField extends Field {
  ComplexField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
  });
}
