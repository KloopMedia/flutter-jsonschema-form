import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/bloc/bloc.dart';

class WebhookTriggerFormField extends StatefulWidget {
  final String name;
  final InputDecoration decoration;
  final bool enabled;

  const WebhookTriggerFormField({
    Key? key,
    required this.name,
    this.decoration = const InputDecoration(),
    this.enabled = true,
  }) : super(key: key);

  @override
  State<WebhookTriggerFormField> createState() => _WebhookTriggerFormFieldState();
}

class _WebhookTriggerFormFieldState extends State<WebhookTriggerFormField> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: widget.name,
      builder: (field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(errorText: field.errorText),
          child: ElevatedButton(
            onPressed: () {
              context.read<FormBloc>().onWebhookTriggerCallback!();
            },
            child: const Text('Webhook'),
          ),
        );
      },
    );
  }
}
