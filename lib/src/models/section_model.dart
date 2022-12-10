import '../helpers/helpers.dart';
import 'models.dart';

class SectionModel extends FieldModel {
  final List<dynamic> fields;
  final List<String> required;

  @override
  void copyWith({String? id, PathModel? path}) {}

  const SectionModel({
    required String id,
    String? title,
    String? description,
    required PathModel path,
    required this.fields,
    required this.required,
  }) : super.init(
          id: id,
          title: title,
          description: description,
          fieldType: FieldType.object,
          path: path,
          isRequired: false,
          widgetType: const NullWidgetModel(),
          disabled: false,
          readOnly: false,
        );
}
