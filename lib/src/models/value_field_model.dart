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
    final title = schema['title'];
    final description = schema['description'];
    final defaultValue = schema['default'];
    final enumValues = schema['enum'];
    final enumNames = schema['enumNames'];
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
          enumValues: enumValues,
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
          enumValues: enumValues,
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

  T? valueTransformer(dynamic value);

  void onChange(BuildContext context, dynamic value) {
    var transformedValue = valueTransformer(value);
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, transformedValue, path));
  }

  List<DropdownMenuItem<T>> getDropdownItems<T>() {
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

  List<Map<String, dynamic>> getRadioItems<T>() {
    final options = enumValues ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);
      String name;
      try {
        name = names[index].toString();
      } catch (_) {
        name = value.toString();
      }
      return {'value': value, 'name': name};
    });
    return items;
  }

  List<FormBuilderFieldOption<T>> getRadio<T>() {
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
