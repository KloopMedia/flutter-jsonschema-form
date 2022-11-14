import 'package:flutter/material.dart';

enum WrapperType {
  section,
  field,
}

class FieldWrapper extends StatelessWidget {
  final String? title;
  final String? description;
  final bool isRequired;
  final Widget child;
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
    this.isRequired = false,
    required this.child,
  }) : _type = WrapperType.section;

  @override
  Widget build(BuildContext context) {
    Widget? titleWidget = title != null
        ? Text.rich(
            TextSpan(
              text: title,
              style: _type == WrapperType.section ? Theme.of(context).textTheme.headline6 : null,
              children: <TextSpan>[
                if (isRequired) const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
              ],
            ),
          )
        : null;
    Widget? descriptionWidget = description != null ? Text(description!) : null;

    if (_type == WrapperType.section) {
      return Column(
        children: [
          ListTile(
            title: titleWidget,
            subtitle: descriptionWidget,
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(thickness: 2),
          child,
        ],
      );
    }

    return Column(
      children: [
        ListTile(
          title: titleWidget,
          subtitle: descriptionWidget,
          contentPadding: EdgeInsets.zero,
        ),
        child,
      ],
    );
  }
}
