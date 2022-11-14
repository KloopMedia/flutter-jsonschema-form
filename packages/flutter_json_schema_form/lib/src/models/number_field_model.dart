import '../helpers/helpers.dart';
import 'models.dart';

class NumberFieldModel extends FieldModel {
  const NumberFieldModel({
    required String id,
    String? title,
    String? description,
    FieldType? fieldType,
    WidgetType? widgetType,
    List? enumItems,
    List? enumNames,
    required PathModel path,
    required bool isRequired,
  }) : super.init(
          id: id,
          title: title,
          description: description,
          fieldType: fieldType,
          widgetType: widgetType,
          path: path,
          enumItems: enumItems,
          enumNames: enumNames,
          isRequired: isRequired,
        );

  NumberFieldModel copyWith({String? id, PathModel? path}) {
    return NumberFieldModel(
      id: id ?? this.id,
      title: title,
      description: description,
      fieldType: fieldType,
      widgetType: widgetType,
      path: path ?? this.path,
      enumItems: enumItems,
      enumNames: enumNames,
      isRequired: isRequired,
    );
  }

  get dropdownItems => getDropdownItems<double>();

  get radioItems => getRadioItems<double>();
}
