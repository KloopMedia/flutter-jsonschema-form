import '../helpers/helpers.dart';
import 'models.dart';

class NumberFieldModel extends FieldModel {
  final num? defaultValue;
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
    this.defaultValue,
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

  @override
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
      defaultValue: defaultValue,
    );
  }

  get dropdownItems => getDropdownItems<num>();

  get radioItems => getRadioItems<num>();
}
