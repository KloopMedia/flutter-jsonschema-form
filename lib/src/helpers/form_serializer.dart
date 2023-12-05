import '../models/models.dart';

List<Field> serializeFields(List<Field> fields, Map<String, dynamic> formData) {
  final List<Field> serializedFields = [];

  for (final field in fields) {
    if (field is Section) {
      if (field.hasTitleOrDescription) {
        serializedFields.add(field);
      }
      serializedFields.addAll(serializeFields(field.fields, formData));
    } else if (field is DynamicArray) {
      serializedFields.add(field);
    } else if (field is StaticArray) {
      serializedFields.add(field);
      serializedFields.addAll(serializeFields(field.fields, formData));
    } else if (field is ValueField) {
      serializedFields.add(field);
    }
  }

  return serializedFields;
}
