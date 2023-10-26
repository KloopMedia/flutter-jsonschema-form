import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../bloc/bloc.dart' as bloc;
import '../widgets/field_wrapper.dart';
import '../helpers/helpers.dart';
import 'models.dart';

class StringField extends ValueField<String> {
  StringField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    super.defaultValue,
    super.enumValues,
    super.enumNames,
    super.enabled = true,
    super.required = false,
    super.widgetType,
  });

  @override
  StringField copyWith({String? id, PathModel? path, String? defaultValue}) {
    return StringField(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type,
      title: title,
      description: description,
      defaultValue: defaultValue ?? this.defaultValue,
      dependency: dependency,
      enumValues: enumValues,
      enumNames: enumNames,
      enabled: enabled,
      required: this.required,
    );
  }

  @override
  String? valueTransformer(value) {
    return value.isNotEmpty ? value : null;
  }

  @override
  Widget build() {
    return FieldWrapper(
      key: Key(id),
      title: title ?? id,
      description: description,
      isRequired: this.required,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        builder: (context, state) {
          final value = getFormDataByPath(state.formData, path);

          if (widgetType != null) {
            return FormWidgetBuilder(
              id: id,
              widgetType: widgetType!,
              value: value,
              onChange: (value) => onChange(context, value),
              disabled: !enabled,
              isRequired: this.required,
              readOnly: false,
              enumItems: enumValues,
              dropdownItems: getDropdownItems(),
              radioItems: getRadio(),
            );
          }

          return FormBuilderTextField(
            name: id,
            initialValue: value ?? defaultValue,
            decoration: decoration,
            validator: FormBuilderValidators.compose([
              if (this.required) FormBuilderValidators.required(),
            ]),
            onChanged: (value) => onChange(context, value),
            // style: theme,
          );
        },
      ),
    );
  }
}
