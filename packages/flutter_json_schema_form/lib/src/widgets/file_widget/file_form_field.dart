import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/bloc/bloc.dart';

import 'file_widget.dart';

class FileFormField extends StatefulWidget {
  final String name;
  final InputDecoration decoration;
  final String? Function(dynamic value)? validator;
  final dynamic initialValue;
  final Reference storage;
  final bool allowMultiple;
  final void Function(String? value) onChanged;

  const FileFormField({
    Key? key,
    required this.name,
    required this.storage,
    required this.onChanged,
    this.initialValue,
    this.decoration = const InputDecoration(),
    this.validator,
    this.allowMultiple = false,
  }) : super(key: key);

  @override
  State<FileFormField> createState() => _FileFormFieldState();
}

class _FileFormFieldState extends State<FileFormField> {
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
              allowMultiple: widget.allowMultiple,
              onChanged: (String? value) {
                field.didChange(value);
                widget.onChanged(value);
              },
            ),
            child: const FileWidget(),
          ),
        );
      },
    );
  }
}