import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;
import '../widgets.dart';

class TextWidget extends StatefulWidget {
  final TextFieldModel model;

  const TextWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
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
          final value = state.formData[id];
          if (widgetType == WidgetType.select) {
            return DropdownButtonFormField<String>(
                value: value,
                decoration: decoration,
                onChanged: (String? newValue) {
                  onChange(context, newValue);
                },
                items: widget.model.dropdownItems);
          } else if (widgetType == WidgetType.textarea) {
            return TextFormField(
              initialValue: value,
              decoration: decoration,
              minLines: 4,
              maxLines: 10,
              onChanged: (newValue) {
                onChange(context, newValue);
              },
            );
          } else {
            return TextFormField(
              initialValue: value,
              decoration: decoration,
              onChanged: (newValue) {
                onChange(context, newValue);
              },
            );
          }
        },
      ),
    );
  }
}
