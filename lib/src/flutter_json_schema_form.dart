import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'bloc/form_bloc/form_bloc.dart' as bloc;
import 'helpers/helpers.dart';

typedef ChangeFormCallback = Function(Map<String, dynamic> formData, String path);
typedef SubmitFormCallback = Function(Map<String, dynamic> formData);
typedef ValidationWarningCallback = void Function();
typedef WebhookTriggerCallback = void Function();

class FlutterJsonSchemaForm extends StatefulWidget {
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic>? formData;
  final ChangeFormCallback? onChange;
  final SubmitFormCallback? onSubmit;
  final ValidationWarningCallback? onValidationFailed;
  final WebhookTriggerCallback? onWebhookTrigger;
  final Reference? storage;
  final bool disabled;
  final Text? submitButtonText;
  final Text? addFileText;
  final PageStorageKey? pageStorageKey;

  const FlutterJsonSchemaForm({
    Key? key,
    required this.schema,
    this.uiSchema,
    this.formData,
    this.onChange,
    this.onSubmit,
    this.onValidationFailed,
    this.onWebhookTrigger,
    this.storage,
    this.disabled = false,
    this.submitButtonText,
    this.addFileText,
    this.pageStorageKey,
  }) : super(key: key);

  @override
  State<FlutterJsonSchemaForm> createState() => _FlutterJsonSchemaFormState();
}

class _FlutterJsonSchemaFormState extends State<FlutterJsonSchemaForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    } else {
      print('SUBMIT ERROR ${_formKey.currentState?.value}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = FormSerializer.serialize(widget.schema, widget.uiSchema);

    return BlocProvider(
      create: (context) => bloc.FormBloc(
        formKey: _formKey,
        formData: widget.formData,
        storage: widget.storage,
        disabled: widget.disabled,
        onChangeCallback: widget.onChange,
        onSubmitCallback: widget.onSubmit,
        onValidationCallback: widget.onValidationFailed,
        onWebhookTriggerCallback: widget.onWebhookTrigger,
        addFileText: widget.addFileText,
      ),
      child: Form(
        formKey: _formKey,
        fields: fields,
        disabled: widget.disabled,
        submitButtonText: widget.submitButtonText,
        pageStorageKey: widget.pageStorageKey,
      ),
    );
  }
}

class Form extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final PageStorageKey? pageStorageKey;
  final List fields;
  final bool disabled;
  final Text? submitButtonText;

  const Form({
    Key? key,
    required this.formKey,
    required this.fields,
    required this.disabled,
    this.submitButtonText,
    this.pageStorageKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        key: pageStorageKey,
        child: Column(
          children: [
            FormBuilder(
              key: formKey,
              clearValueOnUnregister: true,
              child: FormConstructor(fields: fields),
            ),
            if (!disabled)
              ElevatedButton(
                onPressed: () {
                  context.read<bloc.FormBloc>().add(bloc.SubmitFormEvent());
                },
                child: submitButtonText ?? const Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }
}
