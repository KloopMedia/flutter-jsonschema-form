import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

enum WrapperType {
  section,
  field,
}

class FieldWrapper extends StatelessWidget {
  final String? title;
  final String? description;
  final bool isRequired;
  final Widget? child;
  final WrapperType _type;

  const FieldWrapper({
    Key? key,
    this.title,
    this.description,
    required this.isRequired,
    required this.child,
  })  : _type = WrapperType.field,
        super(key: key);

  const FieldWrapper.section({
    super.key,
    this.title,
    this.description,
    this.child,
  })  : _type = WrapperType.section,
        isRequired = false;

  bool get isField => _type == WrapperType.field;

  bool get isSection => _type == WrapperType.section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    final titleTheme = isSection ? theme.titleLarge : theme.titleMedium;
    final descriptionTheme = theme.bodyMedium!.copyWith(color: theme.bodySmall!.color);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            SelectionArea(
              child: Linkify(
                text: title! + (isRequired ? '*' : ''),
                onOpen: (link) async {
                  if (!await launchUrl(Uri.parse(link.url))) {
                    throw Exception('Could not launch ${link.url}');
                  }
                },
              ),
            ),
          if (isSection && title != null) const Divider(thickness: 2),
          if (isField && description != null) const SizedBox(height: 4),
          if (description != null) Text(description!, style: descriptionTheme),
          if (isField) const SizedBox(height: 8),
          if (child != null) child!,
        ],
      ),
    );
  }
}
