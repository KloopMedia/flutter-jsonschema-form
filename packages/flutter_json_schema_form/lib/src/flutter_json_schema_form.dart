import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/form_bloc.dart';
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

  @override
  void initState() {
    model = SectionModel.fromJson(widget.schema, widget.uiSchema ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormBloc(formData: widget.formData, onChangeCallback: widget.onChange),
      child: SingleChildScrollView(
        child: SectionField(model: model),
      ),
    );
  }
}
