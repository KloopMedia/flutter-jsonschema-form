import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../bloc/bloc.dart';
import 'recorder_widget.dart';

class RecorderFormField extends StatefulWidget {
  final String name;
  final InputDecoration decoration;
  final String? Function(dynamic value)? validator;
  final dynamic initialValue;
  final Reference storage;
  final bool enabled;
  final void Function(String? value) onChanged;

  const RecorderFormField({
    Key? key,
    required this.name,
    required this.decoration,
    this.validator,
    this.initialValue,
    required this.storage,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<RecorderFormField> createState() => _RecorderFormFieldState();
}

class _RecorderFormFieldState extends State<RecorderFormField> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: widget.name,
      validator: widget.validator,
      initialValue: widget.initialValue,
      builder: (field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(errorText: field.errorText),
          child: BlocProvider(
            create: (context) => FileBloc(
              value: widget.initialValue,
              storage: widget.storage,
              allowMultiple: false,
              enabled: widget.enabled,
              onChanged: (String? value) {
                field.didChange(value);
                widget.onChanged(value);
              },
            ),
            child: const RecorderWidget(),
          ),
        );
      },
    );
  }
}
