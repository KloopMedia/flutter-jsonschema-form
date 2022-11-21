import '../helpers/helpers.dart';
import 'models.dart';

class NumberFieldModel extends FieldModel {
  final num? defaultValue;

  const NumberFieldModel({
    required String id,
    required String? title,
    required String? description,
    required FieldType fieldType,
    required WidgetModel widgetType,
    required List? enumItems,
    required List? enumNames,
    required PathModel path,
    required bool isRequired,
    required bool? disabled,
    required bool? readOnly,
    required this.defaultValue,
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
          disabled: disabled ?? false,
          readOnly: readOnly ?? false,
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
      disabled: disabled,
      readOnly: readOnly,
    );
  }

  get dropdownItems => getDropdownItems<num>();

  get radioItems => getRadioItems<num>();
}
