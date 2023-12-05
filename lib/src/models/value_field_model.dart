import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../bloc/bloc.dart' as bloc;
import '../helpers/helpers.dart';
import 'models.dart';

abstract class ValueField<T> extends Field {
  final T? defaultValue;
  final List<T>? enumValues;
  final List<String>? enumNames;
  final bool enabled;
  final bool required;
  final WidgetModel? widgetType;

  ValueField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    this.defaultValue,
    this.enumValues,
    this.enumNames,
    this.enabled = true,
    this.required = false,
    this.widgetType,
  });

  factory ValueField.fromSchema({
    required String id,
    required PathModel path,
    required FieldType type,
    required WidgetModel? widget,
    required Dependency? dependency,
    required bool isRequired,
    required Map<String, dynamic> schema,
  }) {
    final String? title = schema['title'];
    final String? description = schema['description'];
    final defaultValue = schema['default'];

    List<T>? enumValues = schema['enum'];
    try {
      enumValues = List.from(schema['enum']);
    } catch (e) {
      enumValues = null;
    }

    List<String>? enumNames;
    try {
      enumNames = List.from(schema['enumNames']);
    } catch (e) {
      enumNames = null;
    }

    final widgetType = widget == null && enumValues != null ? const SelectWidgetModel() : widget;

    switch (type) {
      case FieldType.string:
        return StringField(
          id: id,
          path: path,
          type: type,
          widgetType: widgetType,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: enumNames,
          enumValues: enumValues?.cast(),
        ) as ValueField<T>;
      case FieldType.number:
      case FieldType.integer:
        return NumberField(
          id: id,
          path: path,
          type: type,
          widgetType: widgetType,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: enumNames,
          enumValues: enumValues?.cast(),
        ) as ValueField<T>;
      case FieldType.boolean:
        final isMultiChoice = widgetType is SelectWidgetModel || widgetType is RadioWidgetModel;

        return BooleanField(
          id: id,
          path: path,
          type: type,
          widgetType: widgetType,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: isMultiChoice ? enumNames ?? const ["Yes", "No"] : null,
          enumValues: isMultiChoice ? const [true, false] : null,
        ) as ValueField<T>;
      default:
        throw Exception('Type [$type] not supported');
    }
  }

  @override
  ValueField copyWith({String? id, PathModel? path, T? defaultValue});

  Widget getWidget(BuildContext context, value) {
    final isCorrect = checkFieldAnswer(context, value);
    final disabled = context.read<bloc.FormBloc>().disabled;
    final readOnly = !enabled || disabled;

    return FormWidgetBuilder(
      id: id,
      widgetType: widgetType!,
      value: value,
      onChange: (value) => onChange(context, value),
      disabled: readOnly,
      isRequired: this.required,
      readOnly: false,
      enumItems: enumValues,
      dropdownItems: getDropdownItems(),
      radioItems: getRadioItems(),
      decoration: showCorrectFieldDecoration(isCorrect),
    );
  }

  Widget getField(BuildContext context, value);

  bool? checkFieldAnswer(BuildContext context, dynamic value) {
    /// Check then need to check answers.
    final showCorrectAnswer = context.read<bloc.FormBloc>().showCorrectFields;
    if (!showCorrectAnswer) {
      return null;
    }

    /// Check if correctFormData is present and not empty.
    final correctFormData = context.read<bloc.FormBloc>().correctFormData;
    if (correctFormData == null || correctFormData.isEmpty) {
      return null;
    }

    /// Check if correctFormData contains value at path.
    final correctValue = getFormDataByPath(correctFormData, path);
    if (correctValue == null) {
      return null;
    }

    return correctValue == value;
  }

  T? valueTransformer(dynamic value);

  void onChange(BuildContext context, dynamic value) {
    var transformedValue = valueTransformer(value);
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, transformedValue, path));
  }

  List<DropdownMenuItem<T>> getDropdownItems() {
    final options = enumValues ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<DropdownMenuItem<T>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);

      String name;
      try {
        final enumName = names[index].toString();
        if (enumName.isNotEmpty) {
          name = enumName;
        } else {
          name = value.toString();
        }
      } catch (_) {
        name = value.toString();
      }
      return DropdownMenuItem(value: value, child: Text(name));
    });
    return items;
  }

  List<FormBuilderFieldOption<T>> getRadioItems() {
    final options = enumValues ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<FormBuilderFieldOption<T>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);
      String name;
      try {
        final enumName = names[index].toString();
        if (enumName.isNotEmpty) {
          name = enumName;
        } else {
          name = value.toString();
        }
      } catch (_) {
        name = value.toString();
      }
      return FormBuilderFieldOption(value: value, child: Text(name));
    });
    return items;
  }
}

T _parseValue<T>(dynamic value) {
  try {
    if (T == num) {
      return num.parse(value) as T;
    } else {
      return value;
    }
  } catch (e) {
    return null as T;
  }
}
