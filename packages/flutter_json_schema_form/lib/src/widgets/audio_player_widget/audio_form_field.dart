import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/widgets/audio_player_widget/audio_player_widget.dart';

class AudioFormField extends StatefulWidget {
  final String name;
  final InputDecoration decoration;
  final String? Function(dynamic value)? validator;
  final dynamic initialValue;

  const AudioFormField({
    Key? key,
    required this.name,
    this.initialValue,
    this.decoration = const InputDecoration(),
    this.validator,
  }) : super(key: key);

  @override
  State<AudioFormField> createState() => _AudioFormFieldState();
}

class _AudioFormFieldState extends State<AudioFormField> {
  @override
  Widget build(BuildContext context) {
    print(widget.initialValue);
    return FormBuilderField(
      name: widget.name,
      validator: widget.validator,
      initialValue: widget.initialValue,
      builder: (field) {
        if (widget.initialValue == null) {
          return InputDecorator(
            decoration: widget.decoration.copyWith(errorText: field.errorText),
            child: Container(), // AudioPlayerWidget(url: widget.initialValue),
          );
        }
        return InputDecorator(
          decoration: widget.decoration.copyWith(errorText: field.errorText),
          child: AudioPlayerWidget(url: widget.initialValue),
        );
      },
    );
  }
}
