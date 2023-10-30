import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../bloc/bloc.dart' as bloc;
import '../helpers/helpers.dart';
import '../widgets/field_wrapper.dart';
import 'models.dart';

class NumberField extends ValueField<num> {
  NumberField({
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
  NumberField copyWith({String? id, PathModel? path, num? defaultValue}) {
    return NumberField(
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
    return FormBuilderTextField(
      name: id,
      initialValue: value is num ? value.toString() : value ?? defaultValue?.toString(),
      decoration: decoration,
      validator: FormBuilderValidators.compose([
        if (this.required) FormBuilderValidators.required(),
        if (type == FieldType.number) FormBuilderValidators.numeric(),
        if (type == FieldType.integer) FormBuilderValidators.integer(),
      ]),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) => onChange(context, value),
      // style: theme,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      builder: (context, state) {
        if (!shouldRenderDependency(state.formData)) {
          return const SizedBox.shrink();
        }

        final value = getFormDataByPath(state.formData, path);

        return FieldWrapper(
          key: Key(id),
          title: title ?? id,
          description: description,
          isRequired: this.required,
          child: widgetType != null ? getWidget(context, value) : getField(context, value),
        );
      },
    );
  }

  @override
  num? valueTransformer(value) {
    return value is num ? value : num.tryParse(value);
  }
}
