import 'package:flutter/material.dart';

enum WrapperType {
  section,
  field,
}

class FieldWrapper extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget child;
  final WrapperType _type;

  const FieldWrapper({
    Key? key,
    this.title,
    this.description,
    required this.child,
  })  : _type = WrapperType.field,
        super(key: key);

  const FieldWrapper.section({
    super.key,
    this.title,
    this.description,
    required this.child,
  }) : _type = WrapperType.section;

  @override
  Widget build(BuildContext context) {
    Widget? titleWidget = title != null
        ? Text(
            title!,
            style: _type == WrapperType.section ? Theme.of(context).textTheme.headline6 : null,
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
