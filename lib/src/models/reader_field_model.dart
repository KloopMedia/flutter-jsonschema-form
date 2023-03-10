import '../helpers/helpers.dart';
import 'models.dart';

class ReaderFieldModel extends FieldModel {

  @override
  void copyWith({String? id, PathModel? path}) {}

  ReaderFieldModel ({
    required String id,
    String? title,
    String? description,
    required FieldType fieldType,
    required WidgetModel widgetType,
    required PathModel path,
    bool? isRequired,
    bool? disabled,
    bool? readOnly,
  })  : super.init(
        id: id,
        title: title,
        description: description,
        fieldType: fieldType,
        widgetType: widgetType,
        path: path,
        isRequired: false,
        disabled: true,
        readOnly: true,
      );

}
