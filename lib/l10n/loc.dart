import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';

extension Localization on BuildContext {
  FlutterJsonSchemaFormLocalizations get loc => FlutterJsonSchemaFormLocalizations.of(this)!;
}
