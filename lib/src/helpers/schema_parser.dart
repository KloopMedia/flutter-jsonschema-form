// import '../models/models.dart';
// import 'helpers.dart';
//
// List<dynamic> serialize(Map<String, dynamic> schema, Map<String, dynamic>? uiSchema) {
//   if (schema.isNotEmpty) {
//     final model = _createModelFromSchema(
//       id: '#',
//       schema: schema,
//       uiSchema: uiSchema,
//       path: null,
//       isRequired: false,
//     );
//     return [model];
//   }
//   return [];
// }
//
// FieldModel _createModelFromSchema({
//   required String id,
//   required Map<String, dynamic> schema,
//   Map<String, dynamic>? uiSchema,
//   required path,
//   required bool isRequired,
// }) {
//   final type = getFieldType(schema);
//   final newPath = addPath(path, id, type);
//
//   return _createField(
//     id: id,
//     fieldType: type,
//     widgetType: ,
//     path: newPath,
//     isRequired: isRequired,
//   );
// }
//
// FieldModel _createField({
//   required String id,
//   required PathModel path,
//   String? title,
//   String? description,
//   required FieldType fieldType,
//   required WidgetModel widgetType,
//   List? enumItems,
//   List? enumNames,
//   bool isRequired = false,
//   dynamic defaultValue,
//   bool? disabled,
//   bool? readOnly,
//   FormatType? format,
// }) {
//   final title = schema['title'];
//   description = schema['description'];
//   enumItems = schema['enum'];
//   enumNames = schema['enumNames'];
//   defaultValue = schema['default'];
//   disabled = uiSchema?['ui:disabled'];
//   readOnly = uiSchema?['ui:readonly'];
//   format = decodeFormatType(schema['format']);
//
//   switch (fieldType) {
//     case FieldType.string:
//       return TextFieldModel(
//         id: id,
//         title: title,
//         description: description,
//         widgetType: widgetType,
//         enumItems: enumItems,
//         enumNames: enumNames,
//         path: path,
//         isRequired: isRequired,
//         defaultValue: defaultValue,
//         disabled: disabled,
//         readOnly: readOnly,
//         format: format,
//       );
//     case FieldType.number:
//     case FieldType.integer:
//       return NumberFieldModel(
//         id: id,
//         title: title,
//         description: description,
//         fieldType: fieldType,
//         widgetType: widgetType,
//         enumItems: enumItems,
//         enumNames: enumNames,
//         path: path,
//         isRequired: isRequired,
//         defaultValue: defaultValue,
//         disabled: disabled,
//         readOnly: readOnly,
//       );
//     case FieldType.boolean:
//       return BooleanFieldModel(
//         id: id,
//         title: title,
//         description: description,
//         widgetType: widgetType,
//         enumNames: enumNames,
//         path: path,
//         isRequired: isRequired,
//         defaultValue: defaultValue,
//         disabled: disabled,
//         readOnly: readOnly,
//       );
//     default:
//       return TextFieldModel(
//         id: id,
//         title: title,
//         description: description,
//         widgetType: widgetType,
//         enumItems: enumItems,
//         enumNames: enumNames,
//         path: path,
//         isRequired: isRequired,
//         defaultValue: defaultValue,
//         disabled: disabled,
//         readOnly: readOnly,
//         format: format,
//       );
//   }
// }
