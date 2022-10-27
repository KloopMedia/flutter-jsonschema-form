import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/helpers.dart';
import '../models/models.dart';
import '../bloc/bloc.dart' as bloc;
import 'widgets.dart';

class TextWidget extends StatefulWidget {
  final TextFieldModel model;

  const TextWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  final decoration = const InputDecoration(
    isDense: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0),
    ),
  );

  void onChange(BuildContext context, value) {
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(widget.model.id!, value));
  }

  Widget buildTextWidget(value) {
    if (widget.model.widgetType == WidgetType.select) {
      return DropdownButtonFormField<String>(
          value: value,
          decoration: decoration,
          onChanged: (String? newValue) {
            onChange(context, newValue);
          },
          items: widget.model.dropdownItems);
    } else if (widget.model.widgetType == WidgetType.textarea) {
      return TextFormField(
        decoration: decoration,
        minLines: 4,
        maxLines: 10,
        onChanged: (newValue) {
          onChange(context, newValue);
        },
      );
    } else {
      return TextFormField(
        initialValue: value ?? '',
        decoration: decoration,
        onChanged: (newValue) {
          onChange(context, newValue);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper(
      title: widget.model.fieldTitle,
      description: widget.model.description,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        builder: (context, state) {
          final value = state.formData[widget.model.id];
          return buildTextWidget(value);
        },
      ),
    );
  }
}
