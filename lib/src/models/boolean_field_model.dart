import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../bloc/bloc.dart' as bloc;
import '../helpers/helpers.dart';
import '../widgets/field_wrapper.dart';
import 'models.dart';

class BooleanField extends ValueField<bool> {
  BooleanField({
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
  BooleanField copyWith({String? id, PathModel? path, bool? defaultValue}) {
    return BooleanField(
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
  Widget getField(BuildContext context, value) {
    return Transform.scale(
      scale: 1.15,
      alignment: Alignment.centerLeft,
      child: FormBuilderCheckbox(
        name: id,
        title: Text(title ?? id, style: const TextStyle(fontSize: 14)),
        initialValue: value ?? defaultValue,
        validator: FormBuilderValidators.compose([
          if (this.required) FormBuilderValidators.required(),
        ]),
        onChanged: (value) => onChange(context, value),
        contentPadding: const EdgeInsets.only(right: 30),
      ),
    );
  }

  @override
  Widget build() {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      builder: (context, state) {
        if (!shouldRenderDependency(dependency, state.formData)) {
          return const SizedBox.shrink();
        }

        final value = getFormDataByPath(state.formData, path);

        if (widgetType != null) {
          return FieldWrapper(
            title: title,
            description: description,
            isRequired: this.required,
            child: getWidget(context, value),
          );
        }

        return getField(context, value);
      },
    );
  }

  @override
  bool? valueTransformer(value) {
    return value is bool ? value : bool.tryParse(value);
  }
}
