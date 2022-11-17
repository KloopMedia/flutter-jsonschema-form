import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'bloc/form_bloc.dart' as bloc;
import 'models/models.dart';
import 'fields/fields.dart';

typedef ChangeFormCallback = Function(Map<String, dynamic> formData);

class FlutterJsonSchemaForm extends StatefulWidget {
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic>? formData;
  final ChangeFormCallback? onChange;

  const FlutterJsonSchemaForm({
    Key? key,
    required this.schema,
    this.uiSchema,
    this.formData,
    this.onChange,
  }) : super(key: key);

  @override
  State<FlutterJsonSchemaForm> createState() => _FlutterJsonSchemaFormState();
}

class _FlutterJsonSchemaFormState extends State<FlutterJsonSchemaForm> {
  late SectionModel model;
  final _formKey = GlobalKey<FormBuilderState>();

  void submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  @override
  void initState() {
    model = SectionModel.fromJson(widget.schema, widget.uiSchema ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc.FormBloc(
        formData: widget.formData,
        onChangeCallback: widget.onChange,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              clearValueOnUnregister: true,
              child: SectionField(model: model),
            ),
            ElevatedButton(onPressed: submit, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
