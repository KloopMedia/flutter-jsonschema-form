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
  String selectedValue = "";

  final decoration = const InputDecoration(
    isDense: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget field;
    if (widget.model.widgetType == WidgetType.select) {
      field = DropdownButtonFormField(
          decoration: decoration,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
          items: widget.model.dropdownItems);
    } else if (widget.model.widgetType == WidgetType.textarea) {
      field = TextFormField(
        decoration: decoration,
        // expands: true,
        minLines: 4,
        maxLines: 10,
      );
    } else {
      field = BlocBuilder<bloc.FormBloc, bloc.FormState>(
        builder: (context, state) {
          final value = state.formData[widget.model.id];
          return TextFormField(
            initialValue: value ?? '',
            decoration: decoration,
          );
        },
      );
    }

    return FieldWrapper(
      title: widget.model.fieldTitle,
      description: widget.model.description,
      child: field,
    );
  }
}
