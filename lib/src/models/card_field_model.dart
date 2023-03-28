import '../helpers/helpers.dart';
import 'models.dart';

class CardFieldModel extends FieldModel {
  final List<dynamic> fields;
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;

  @override
  copyWith({String? id, PathModel? path}) {}

  const CardFieldModel({
    required String id,
    String? title,
    String? description,
    required this.schema,
    required this.uiSchema,
    required PathModel path,
    required this.fields,
  }) : super.init(
        id: id,
        title: title,
        description: description,
        fieldType: FieldType.object,
        path: path,
        isRequired: false,
        widgetType: const CardWidgetModel(),
        disabled: false,
        readOnly: false,
      );
}