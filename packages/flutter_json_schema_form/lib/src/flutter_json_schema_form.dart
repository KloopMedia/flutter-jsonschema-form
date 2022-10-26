import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/form_bloc.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

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
  late Section model;

  @override
  void initState() {
    model = Section.fromJson(widget.schema, widget.uiSchema ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormBloc(formData: widget.formData, onChangeCallback: widget.onChange),
      child: SingleChildScrollView(
        child: SectionWidget(model: model),
      ),
    );
  }
}
