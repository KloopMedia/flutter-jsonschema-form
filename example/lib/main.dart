import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';

import 'schema/schema.dart';

void main() {
  final schema = BigSchema();
  runApp(MyApp(schema: schema));
}

class MyApp extends StatefulWidget {
  final Schema? schema;

  const MyApp({super.key, this.schema});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Map<String, dynamic> formData = widget.schema?.formData ?? {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: FlutterJsonSchemaForm(
          schema: widget.schema?.formSchema ?? {},
          uiSchema: widget.schema?.uiSchema,
          formData: formData,
          onChange: (data, path) {
            setState(() {
              formData = data;
            });
          },
        ),
      ),
    );
  }
}
