import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AutocompleteField extends StatefulWidget {
  final String name;
  final InputDecoration decoration;
  final String? Function(dynamic value)? validator;
  final List<String> options;
  final String? initialValue;
  final void Function(dynamic value) onChanged;

  const AutocompleteField({
    Key? key,
    required this.name,
    this.initialValue,
    this.decoration = const InputDecoration(),
    this.validator,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AutocompleteField> createState() => _AutocompleteFieldState();
}

class _AutocompleteFieldState extends State<AutocompleteField> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: widget.name,
      validator: widget.validator,
      initialValue: widget.initialValue,
      builder: (field) {
        return Autocomplete(
          initialValue: TextEditingValue(text: widget.initialValue ?? ''),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return widget.options;
            }
            return widget.options.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            widget.onChanged(selection);
          },
        );
      },
    );
  }
}
