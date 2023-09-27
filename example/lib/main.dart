import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';

import 'schema/schema.dart';

void main() {
  final schema = ImageSchema();
  runApp(MyApp(schema: schema));
}

class MyApp extends StatefulWidget {
  final Schema? schema;

  const MyApp({super.key, this.schema});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Map<String, dynamic> _formData = widget.schema?.formData ?? {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: FlutterJsonSchemaForm(
          schema: widget.schema?.formSchema ?? {},
          uiSchema: widget.schema?.uiSchema,
          formData: _formData,
          onChange: (data, path) {
            print(data);
            setState(() {
              _formData = data;
            });
          },
        ),
      ),
    );
  }
}
