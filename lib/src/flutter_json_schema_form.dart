import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'bloc/form_bloc/form_bloc.dart' as bloc;
import 'helpers/helpers.dart';

typedef ChangeFormCallback = Function(Map<String, dynamic> formData, String path);
typedef SubmitFormCallback = Function(Map<String, dynamic> formData);
typedef ValidationWarningCallback = void Function();

class FlutterJsonSchemaForm extends StatefulWidget {
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic>? formData;
  final ChangeFormCallback? onChange;
  final SubmitFormCallback? onSubmit;
  final ValidationWarningCallback? onValidationFailed;
  final Reference? storage;
  final bool disabled;

  const FlutterJsonSchemaForm({
    Key? key,
    required this.schema,
    this.uiSchema,
    this.formData,
    this.onChange,
    this.onSubmit,
    this.onValidationFailed,
    this.storage,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<FlutterJsonSchemaForm> createState() => _FlutterJsonSchemaFormState();
}

class _FlutterJsonSchemaFormState extends State<FlutterJsonSchemaForm> {
  late List<dynamic> fields;
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
  void initState() {
    fields = FormSerializer.serialize(widget.schema, widget.uiSchema);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc.FormBloc(
        formKey: _formKey,
        formData: widget.formData,
        storage: widget.storage,
        disabled: widget.disabled,
        onChangeCallback: widget.onChange,
        onSubmitCallback: widget.onSubmit,
        onValidationCallback: widget.onValidationFailed,
      ),
      child: Form(
        formKey: _formKey,
        fields: fields,
        disabled: widget.disabled,
      ),
    );
  }
}

class Form extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final List fields;
  final bool disabled;

  const Form({
    Key? key,
    required this.formKey,
    required this.fields,
    required this.disabled
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FormBuilder(
            key: formKey,
            clearValueOnUnregister: true,
            child: FormConstructor(fields: fields),
          ),
          if (!disabled) ElevatedButton(
            onPressed: () {
              context.read<bloc.FormBloc>().add(bloc.SubmitFormEvent());
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
