import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkFormField extends StatelessWidget {
  final String name;
  final InputDecoration decoration;
  final dynamic initialValue;

  const LinkFormField({
    Key? key,
    required this.name,
    required this.decoration,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      initialValue: initialValue,
      builder: (field) {
        return InputDecorator(
          decoration: decoration.copyWith(errorText: field.errorText),
          child: InkWell(
            child: Text(
              initialValue,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue),
            ),
            onTap: () => launchUrl(Uri.parse(initialValue)),
          ),
        );
      },
    );
  }
}
