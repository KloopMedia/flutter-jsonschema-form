import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import 'helpers.dart';

class FormWidgetBuilder<T> extends StatelessWidget {
  final String id;
  final WidgetModel widgetType;
  final dynamic value;
  final void Function(dynamic value) onChange;
  final String? Function(dynamic value)? validator;
  final List<DropdownMenuItem<T>>? dropdownItems;
  final List<FormBuilderFieldOption<T>>? radioItems;
  final bool disabled;
  final bool readOnly;

  const FormWidgetBuilder({
    Key? key,
    required this.id,
    required this.widgetType,
    required this.value,
    required this.onChange,
    this.validator,
    this.dropdownItems,
    this.radioItems,
    required this.readOnly,
    required this.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetModel = widgetType;

    if (widgetModel is SelectWidgetModel) {
      return FormBuilderDropdown<T>(
        name: id,
        initialValue: value,
        decoration: decoration,
        validator: validator,
        items: dropdownItems!,
        onChanged: onChange,
      );
    } else if (widgetModel is RadioWidgetModel) {
      return FormBuilderRadioGroup<T>(
        name: id,
        initialValue: value,
        decoration: decoration,
        orientation: OptionsOrientation.vertical,
        validator: validator,
        options: radioItems!,
        onChanged: onChange,
      );
    } else if (widgetModel is TextAreaWidgetModel) {
      return FormBuilderTextField(
        name: id,
        initialValue: value,
        decoration: decoration,
        minLines: widgetModel.rows,
        maxLines: widgetModel.rows,
        keyboardType: TextInputType.multiline,
        validator: validator,
        onChanged: onChange,
        enabled: !disabled,
      );
    } else if (widgetModel is PasswordWidgetModel) {
      return FormBuilderTextField(
        name: id,
        initialValue: value,
        decoration: decoration,
        validator: validator,
        keyboardType: TextInputType.visiblePassword,
        onChanged: onChange,
        enabled: !disabled,
      );
    }
    // else if (widgetModel is AudioWidgetModel) {}
    // else if (widgetModel is FileWidgetModel) {}
    else {
      return const Text('Error');
    }
  }
}

class TextFormatWidgetBuilder extends StatelessWidget {
  final FormatType type;
  final String id;
  final dynamic value;
  final void Function(dynamic value) onChange;
  final String? Function(dynamic value)? validator;
  final bool disabled;
  final bool readOnly;

  const TextFormatWidgetBuilder({
    Key? key,
    required this.type,
    required this.id,
    this.value,
    required this.onChange,
    this.validator,
    required this.disabled,
    required this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case FormatType.email:
        return FormBuilderTextField(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: validator,
          keyboardType: TextInputType.emailAddress,
          onChanged: onChange,
          enabled: !disabled,
        );
      case FormatType.uri:
        return FormBuilderTextField(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: validator,
          keyboardType: TextInputType.url,
          onChanged: onChange,
          enabled: !disabled,
        );
      case FormatType.file:
        return FormBuilderTextField(
          name: id,
        );
      case FormatType.date:
        return FormBuilderDateTimePicker(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: validator,
          keyboardType: TextInputType.datetime,
          format: DateFormat('dd-MM-yyyy'),
          inputType: InputType.date,
          enabled: !disabled,
          onChanged: (value) {
            if (value != null) {
              final date = DateFormat('dd-MM-yyyy').format(value);
              onChange(date);
            } else {
              onChange(null);
            }
          },
        );
      case FormatType.dateTime:
        return FormBuilderDateTimePicker(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: validator,
          keyboardType: TextInputType.datetime,
          format: DateFormat('dd-MM-yyyy HH:mm'),
          enabled: !disabled,
          onChanged: (value) {
            if (value != null) {
              final date = DateFormat('dd-MM-yyyy HH:mm').format(value);
              onChange(date);
            } else {
              onChange(null);
            }
          },
        );
    }
  }
}

class DefaultWidgetBuilder extends StatelessWidget {
  final String id;
  final FieldType fieldType;
  final dynamic value;
  final void Function(dynamic value) onChange;
  final String? Function(dynamic value)? validator;
  final String? title;
  final bool disabled;
  final bool readOnly;

  const DefaultWidgetBuilder({
    Key? key,
    required this.id,
    required this.fieldType,
    required this.value,
    required this.onChange,
    this.validator,
    this.title,
    required this.readOnly,
    required this.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (fieldType) {
      case FieldType.string:
        return FormBuilderTextField(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: validator,
          onChanged: onChange,
        );
      case FieldType.number:
      case FieldType.integer:
        return FormBuilderTextField(
          name: id,
          initialValue: value?.toString(),
          decoration: decoration,
          validator: validator,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChange,
        );
      case FieldType.boolean:
        return FormBuilderCheckbox(
          name: id,
          title: Text(title!),
          initialValue: value,
          validator: validator,
          onChanged: onChange,
        );
      default:
        return const Text('Error');
    }
  }
}

String parseDateTime(DateTime date, TimeOfDay time) {
  String year = date.year.toString();
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');
  String hour = time.hour.toString().padLeft(2, '0');
  String minute = time.minute.toString().padLeft(2, '0');

  return '$day-$month-$year $hour:$minute';
}

String parseDate(DateTime date) {
  String year = date.year.toString();
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');

  return '$day-$month-$year';
}
