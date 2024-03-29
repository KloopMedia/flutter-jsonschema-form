import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../bloc/bloc.dart' as bloc;
import '../helpers/helpers.dart';
import '../widgets/widgets.dart';
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
  Widget getField(BuildContext context, value) {
    final isCorrect = checkFieldAnswer(context, value);
    final disabled = context.read<bloc.FormBloc>().disabled;
    final readOnly = !enabled || disabled;

    return FormBuilderTextField(
      name: id,
      initialValue: value ?? defaultValue,
      decoration: showCorrectFieldDecoration(isCorrect),
      validator: FormBuilderValidators.compose([
        if (this.required) FormBuilderValidators.required(),
      ]),
      onChanged: (value) => onChange(context, value),
      readOnly: readOnly,
      // style: theme,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      buildWhen: (previous, current) => shouldRebuildBloc(this, previous, current),
      builder: (context, state) {
        if (!shouldRenderDependency(state.formData)) {
          return const SizedBox.shrink();
        }

        final value = getFormDataByPath(state.formData, path);
        final isCorrect = checkFieldAnswer(context, value);
        final widget = widgetType != null ? getWidget(context, value) : getField(context, value);

        return FieldWrapper(
          key: Key(id),
          title: title ?? id,
          description: description,
          isRequired: this.required,
          child: CorrectAnswerWrapper(
            isCorrect: isCorrect,
            child: Theme(
              data: ThemeData(
                radioTheme: RadioThemeData(
                  fillColor: MaterialStateProperty.resolveWith(
                    (Set states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.black;
                    },
                  ),
                ),
              ),
              child: widget,
            ),
          ),
        );
      },
    );
  }
}
