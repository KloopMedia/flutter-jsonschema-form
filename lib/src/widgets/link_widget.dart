import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkFormField extends StatelessWidget {
  final String name;
  final InputDecoration decoration;
  final dynamic initialValue;

  const LinkFormField({
    Key? key,
    required this.name,
    required this.decoration,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: decoration,
      child: InkWell(
        child: Text(
          initialValue,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.blue),
        ),
        onTap: () => launchUrl(Uri.parse(initialValue)),
      ),
    );
  }
}
