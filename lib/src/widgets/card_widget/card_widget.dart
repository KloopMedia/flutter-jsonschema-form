import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/src/helpers/form_constructor.dart';

import '../../models/card_field_model.dart';
import '../../models/models.dart';

class CardWidget extends StatefulWidget {
  final CardFieldModel model;

  const CardWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  late int index;
  late List modelFields;

  @override
  void initState() {
    index = 0;
    modelFields = widget.model.fields;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final field = modelFields[index];

    return Center(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              width: 300.0,
              color: const Color.fromRGBO(168, 210, 219, 1),
              child: FormConstructor(fields: [field]),
            ),
            Row(children: [
              const SizedBox(width: 10.0),
              Container(
                padding: const EdgeInsets.all(4.0),
                color: const Color.fromRGBO(69, 123, 157, 1),
                child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        index++;
                        if (index == modelFields.length) index = 0;
                      });
                    }),
              ),
            ]),
          ]),
    );
  }
}