import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';

class FixedArray extends StatelessWidget {
  final List<Field> items;
  const FixedArray({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(fields: items, dependencies: const []);
  }
}
