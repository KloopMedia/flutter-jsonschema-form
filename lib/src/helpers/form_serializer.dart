import '../models/models.dart';
import 'helpers.dart';

List<Field> serializeFields(List<Field> fields, Map<String, dynamic> formData) {
  final List<Field> serializedFields = [];

  for (final field in fields) {
    if (field is Section) {
      if (field.hasDependency) {
        final parentValue = getFormDataByPath(formData, field.dependency!.parentPath);
        if (field.dependency!.conditions.contains(parentValue)) {
          if (field.hasTitleOrDescription) {
            serializedFields.add(field);
          }
          serializedFields.addAll(serializeFields(field.fields, formData));
        }
      } else {
        if (field.hasTitleOrDescription) {
          serializedFields.add(field);
        }
        serializedFields.addAll(serializeFields(field.fields, formData));
      }
    } else if (field is DynamicArray) {
      serializedFields.add(field);
    } else if (field is StaticArray) {
      serializedFields.add(field);
      serializedFields.addAll(serializeFields(field.fields, formData));
    } else if (field is ValueField) {
      if (field.hasDependency) {
        final parentValue = getFormDataByPath(formData, field.dependency!.parentPath);
        if (field.dependency!.conditions.contains(parentValue)) {
          serializedFields.add(field);
        }
      } else {
        serializedFields.add(field);
      }
    }
  }

  return serializedFields;
}
