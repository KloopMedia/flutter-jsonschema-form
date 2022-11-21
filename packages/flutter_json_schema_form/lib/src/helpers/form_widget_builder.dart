import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import 'helpers.dart';

class FormWidgetBuilder<T> extends StatelessWidget {
  final String id;
  final WidgetModel widgetType;
  final dynamic value;
  final void Function(dynamic value) onChange;
  final List<DropdownMenuItem<T>>? dropdownItems;
  final List<FormBuilderFieldOption<T>>? radioItems;
  final bool disabled;
  final bool readOnly;
  final bool isRequired;

  const FormWidgetBuilder({
    Key? key,
    required this.id,
    required this.widgetType,
    required this.value,
    required this.onChange,
    this.dropdownItems,
    this.radioItems,
    required this.readOnly,
    required this.disabled,
    required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetModel = widgetType;

    if (widgetModel is SelectWidgetModel) {
      return FormBuilderDropdown<T>(
        name: id,
        initialValue: value,
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        items: dropdownItems!,
        onChanged: onChange,
      );
    } else if (widgetModel is RadioWidgetModel) {
      return FormBuilderRadioGroup<T>(
        name: id,
        initialValue: value,
        decoration: decoration,
        orientation: OptionsOrientation.vertical,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
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
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        onChanged: onChange,
        enabled: !disabled,
      );
    } else if (widgetModel is PasswordWidgetModel) {
      return FormBuilderTextField(
        name: id,
        initialValue: value,
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        keyboardType: TextInputType.visiblePassword,
        onChanged: onChange,
        enabled: !disabled,
      );
    }
    // else if (widgetModel is FileWidgetModel) {
    //   return FormBuilderFilePicker(name: id);
    // }
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
  final bool disabled;
  final bool readOnly;
  final bool isRequired;

  const TextFormatWidgetBuilder({
    Key? key,
    required this.type,
    required this.id,
    required this.value,
    required this.onChange,
    required this.disabled,
    required this.readOnly,
    required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case FormatType.email:
        return FormBuilderTextField(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
          keyboardType: TextInputType.emailAddress,
          onChanged: onChange,
          enabled: !disabled,
        );
      case FormatType.uri:
        return FormBuilderTextField(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            FormBuilderValidators.url(),
          ]),
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
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
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
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
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
  final String? title;
  final bool disabled;
  final bool readOnly;
  final bool isRequired;

  const DefaultWidgetBuilder({
    Key? key,
    required this.id,
    required this.fieldType,
    required this.value,
    required this.onChange,
    this.title,
    required this.readOnly,
    required this.disabled,
    required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (fieldType) {
      case FieldType.string:
        return FormBuilderTextField(
          name: id,
          initialValue: value,
          decoration: decoration,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
          onChanged: onChange,
        );
      case FieldType.number:
        return FormBuilderTextField(
          name: id,
          initialValue: value?.toString(),
          decoration: decoration,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ]),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChange,
        );
      case FieldType.integer:
        return FormBuilderTextField(
          name: id,
          initialValue: value?.toString(),
          decoration: decoration,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
            FormBuilderValidators.integer(),
          ]),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChange,
        );
      case FieldType.boolean:
        return FormBuilderCheckbox(
          name: id,
          title: Text(title!),
          initialValue: value,
          validator: FormBuilderValidators.compose([
            if (isRequired) FormBuilderValidators.required(),
          ]),
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
