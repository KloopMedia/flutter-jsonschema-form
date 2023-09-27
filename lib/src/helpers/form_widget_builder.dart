import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart' hide FormBuilderRadioGroup;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../bloc/bloc.dart';
import '../models/models.dart';
import '../widgets/link_widget.dart';
import '../widgets/widgets.dart';
import 'helpers.dart';

class FormWidgetBuilder<T> extends StatelessWidget {
  final String id;
  final WidgetModel widgetType;
  final dynamic value;
  final void Function(dynamic value) onChange;
  final List<DropdownMenuItem<T>>? dropdownItems;
  final List<FormBuilderFieldOption<T>>? radioItems;
  final List? enumItems;
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
    this.enumItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgetModel = widgetType;
    final theme = const TextStyle().copyWith(color: disabled ? Colors.grey : null);

    if (widgetModel is SelectWidgetModel) {
      return FormBuilderDropdown<T>(
        name: id,
        initialValue: value,
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        items: dropdownItems!,
        enabled: !disabled,
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
        enabled: !disabled,
        onChanged: onChange,
        physics: const NeverScrollableScrollPhysics(),
      );
    } else if (widgetModel is TextAreaWidgetModel) {
      return FormBuilderTextField(
        name: id,
        initialValue: value,
        decoration: decoration,
        minLines: widgetModel.rows ?? 4,
        maxLines: widgetModel.rows,
        keyboardType: TextInputType.multiline,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        onChanged: onChange,
        readOnly: disabled,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        style: theme,
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
        readOnly: disabled,
        style: theme,
      );
    } else if (widgetModel is FileWidgetModel) {
      final storage = context.read<FormBloc>().storage;
      if (storage == null) {
        return const Text('Error: Pass firebase storage reference to form!');
      }
      final privacyPath = widgetModel.private ? 'private' : 'public';
      final privateStorage = storage.storage.ref('$privacyPath/${storage.fullPath}');
      return FileFormField(
        name: id,
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        initialValue: value,
        storage: privateStorage,
        onChanged: onChange,
        allowMultiple: widgetModel.multiple,
        enabled: !disabled,
      );
    } else if (widgetModel is AudioWidgetModel) {
      return AudioFormField(
        name: id,
        initialValue: widgetModel.url,
        decoration: decoration,
      );
    } else if (widgetModel is RecorderWidgetModel) {
      final storage = context.read<FormBloc>().storage;
      if (storage == null) {
        return const Text('Error: Pass firebase storage reference to form!');
      }
      final privacyPath = widgetModel.private ? 'private' : 'public';
      final privateStorage = storage.storage.ref('$privacyPath/${storage.fullPath}');
      return RecorderFormField(
        name: id,
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        initialValue: value,
        storage: privateStorage,
        onChanged: onChange,
        enabled: !disabled,
      );
    } else if (widgetModel is LinkWidgetModel) {
      return LinkFormField(
        name: id,
        initialValue: value,
        decoration: decoration,
      );
    } else if (widgetModel is WebhookTriggerWidgetModel) {
      return WebhookTriggerFormField(
        name: id,
        label: widgetModel.label,
      );
    } else if (widgetModel is ParagraphWidgetModel) {
      return ParagraphField(
        name: id,
        decoration: decoration,
        initialValue: value,
        paragraph: widgetModel.paragraph,
      );
    } else if (widgetModel is AutocompleteWidgetModel) {
      List<String> options;
      try {
        options = enumItems?.cast<String>() ?? [];
      } catch (e) {
        options = [];
      }
      return AutocompleteField(
        name: id,
        decoration: decoration,
        initialValue: value,
        options: options,
        onChanged: onChange,
      );
    } else if (widgetModel is ImageWidgetModel) {
      return ImageField<T>(
        name: id,
        initialValue: value,
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(),
        ]),
        images: widgetModel.images,
        text: widgetModel.text,
        options: radioItems!,
        enabled: !disabled,
        onChanged: onChange,
      );
    } else {
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

  DateTime? getFormattedDateTime(String? value) {
    if (value == null) return null;
    final day = value.substring(0, 2);
    final year = value.substring(6, 10);
    final addedYear = value.replaceRange(0, 2, year);
    final formattedString = addedYear.replaceRange(8, 12, day);
    return DateTime.tryParse(formattedString);
  }

  @override
  Widget build(BuildContext context) {
    final theme = const TextStyle().copyWith(color: disabled ? Colors.grey : null);

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
          readOnly: disabled,
          style: theme,
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
          readOnly: disabled,
          style: theme,
        );
      case FormatType.file:
        return FormBuilderTextField(
          name: id,
        );
      case FormatType.date:
        return FormBuilderDateTimePicker(
          name: id,
          initialValue: getFormattedDateTime(value),
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
          style: theme,
        );
      case FormatType.dateTime:
        return FormBuilderDateTimePicker(
          name: id,
          initialValue: getFormattedDateTime(value),
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
          style: theme,
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
    final theme = const TextStyle().copyWith(color: disabled ? Colors.grey : null);

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
          readOnly: disabled,
          style: theme,
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
          readOnly: disabled,
          style: theme,
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
          readOnly: disabled,
          style: theme,
        );
      case FieldType.boolean:
        return Transform.scale(
          scale: 1.15,
          alignment: Alignment.centerLeft,
          child: FormBuilderCheckbox(
            name: id,
            title: Text(title!, style: const TextStyle(fontSize: 14)),
            initialValue: value,
            validator: FormBuilderValidators.compose([
              if (isRequired) FormBuilderValidators.required(),
            ]),
            onChanged: onChange,
            enabled: !disabled,
            contentPadding: const EdgeInsets.only(right: 30),
          ),
        );
      default:
        return const Text('Error');
    }
  }
}
