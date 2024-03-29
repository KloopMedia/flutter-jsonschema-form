import 'complex_field_model.dart';

abstract class ArrayField extends ComplexField {
  ArrayField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
  });
}
