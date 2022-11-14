import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;
import '../../widgets/widgets.dart';
import '../fields.dart';

class TextField extends StatefulWidget {
  final TextFieldModel model;

  const TextField({Key? key, required this.model}) : super(key: key);

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
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
    return FieldWrapper(
      title: title,
      description: description,
      isRequired: isRequired,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        buildWhen: (previous, current) {
          final previousValue = getFormDataByPath(previous.formData, path);
          final currentValue = getFormDataByPath(current.formData, path);
          return previousValue != currentValue;
        },
        builder: (context, state) {
          final data = getFormDataByPath(state.formData, path);
          final value = data ?? defaultValue;
          if (widgetType == WidgetType.select) {
            return SelectWidget<String>(
              value: value,
              items: widget.model.dropdownItems,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          } else if (widgetType == WidgetType.radio) {
            return RadioWidget<String>(
              value: value,
              items: widget.model.radioItems,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          } else if (widgetType == WidgetType.textarea) {
            return TextWidget(
              value: value,
              textArea: true,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          } else {
            return TextWidget(
              value: value,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          }
        },
      ),
    );
  }
}
