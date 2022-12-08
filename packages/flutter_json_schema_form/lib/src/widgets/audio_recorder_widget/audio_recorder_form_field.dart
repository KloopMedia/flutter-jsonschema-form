import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/widgets/audio_recorder_widget/audio_recorder_widget.dart';

import '../../bloc/bloc.dart';

class AudioRecorderFormField extends StatefulWidget {
  final String name;
  final InputDecoration decoration;
  final String? Function(dynamic value)? validator;
  final dynamic initialValue;
  final Reference storage;
  final void Function(String? value) onChanged;

  const AudioRecorderFormField({
    Key? key,
    required this.name,
    required this.decoration,
    this.validator,
    this.initialValue,
    required this.storage,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AudioRecorderFormField> createState() => _AudioRecorderFormFieldState();
}

class _AudioRecorderFormFieldState extends State<AudioRecorderFormField> {
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
              onChanged: (String? value) {
                field.didChange(value);
                widget.onChanged(value);
              },
            ),
            child: const AudioRecorderWidget(),
          ),
        );
      },
    );
  }
}
