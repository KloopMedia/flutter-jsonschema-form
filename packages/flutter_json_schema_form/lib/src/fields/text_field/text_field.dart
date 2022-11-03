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

  void onChange(BuildContext context, value) {
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, value, path));
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper(
      title: title,
      description: description,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        // buildWhen: (previousState, currentState) {
        //   return previousState.formData[id] != currentState.formData[id];
        // },
        builder: (context, state) {
          final value = getFormDataByPath(state.formData, path);
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
