import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'bloc/form_bloc/form_bloc.dart' as bloc;
import 'helpers/helpers.dart';

typedef ChangeFormCallback = Function(Map<String, dynamic> formData, String path);
typedef SubmitFormCallback = Function(Map<String, dynamic> formData);

class FlutterJsonSchemaForm extends StatefulWidget {
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic>? formData;
  final ChangeFormCallback? onChange;
  final SubmitFormCallback? onSubmit;
  final Reference? storage;

  const FlutterJsonSchemaForm({
    Key? key,
    required this.schema,
    this.uiSchema,
    this.formData,
    this.onChange,
    this.onSubmit,
    this.storage,
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
        onChangeCallback: widget.onChange,
        onSubmitCallback: widget.onSubmit,
      ),
      child: Form(
        formKey: _formKey,
        fields: fields,
      ),
    );
  }
}

class Form extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final List fields;

  const Form({Key? key, required this.formKey, required this.fields}) : super(key: key);

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
          ElevatedButton(
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
