import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json_schema_form/src/widgets/checkbox_widget.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;
import '../../widgets/widgets.dart';
import '../fields.dart';

class BooleanField extends StatefulWidget {
  final BooleanFieldModel model;

  const BooleanField({Key? key, required this.model}) : super(key: key);

  @override
  State<BooleanField> createState() => _BooleanFieldState();
}

class _BooleanFieldState extends State<BooleanField> {
  late final id = widget.model.id;
  late final path = widget.model.path;
  late final title = widget.model.fieldTitle;
  late final description = widget.model.description;
  late final type = widget.model.fieldType;
  late final widgetType = widget.model.widgetType;
  late final isRequired = widget.model.isRequired;
  late final defaultValue = widget.model.defaultValue;

  void onChange(BuildContext context, value) {
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, value, path));
  }

  @override
  void initState() {
    if (defaultValue != null) {
      final formData = context.read<bloc.FormBloc>().state.formData;
      final value = getFormDataByPath(formData, path);
      if (value == null) {
        onChange(context, defaultValue);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      buildWhen: (previous, current) {
        final previousValue = getFormDataByPath(previous.formData, path);
        final currentValue = getFormDataByPath(current.formData, path);
        return previousValue != currentValue;
      },
      builder: (context, state) {
        final data = getFormDataByPath(state.formData, path);
        final value = data ?? defaultValue;

        if (widgetType == WidgetType.select) {
          return FieldWrapper(
            title: title,
            description: description,
            isRequired: isRequired,
            child: SelectWidget<bool>(
              value: value,
              items: widget.model.dropdownItems,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            ),
          );
        } else if (widgetType == WidgetType.radio) {
          return FieldWrapper(
            title: title,
            description: description,
            isRequired: isRequired,
            child: RadioWidget<bool>(
              value: value,
              items: widget.model.getRadioItems(),
              onChange: (newValue) {
                onChange(context, newValue);
              },
            ),
          );
        } else {
          return CheckboxWidget(
            title: title,
            description: description,
            value: value,
            onChange: (newValue) {
              onChange(context, newValue);
            },
          );
        }
      },
    );
  }
}
