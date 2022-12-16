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

  bool get isField => _type == WrapperType.field;

  bool get isSection => _type == WrapperType.section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) FieldTitle(title: title!, isRequired: isRequired, type: _type),
          if (isField && description != null) const SizedBox(height: 4),
          if (description != null) FieldDescription(description: description!),
          if (isField) const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class FieldTitle extends StatelessWidget {
  final String title;
  final bool isRequired;
  final WrapperType type;

  const FieldTitle({Key? key, required this.title, required this.isRequired, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style =
        type == WrapperType.section ? theme.textTheme.headlineLarge : theme.textTheme.headlineSmall;
        // type == WrapperType.section ? theme.textTheme.headline6 : theme.textTheme.titleMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            style: style,
            children: <TextSpan>[
              if (isRequired) const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        if (type == WrapperType.section) const Divider(thickness: 2),
      ],
    );
  }
}

class FieldDescription extends StatelessWidget {
  final String description;

  const FieldDescription({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextStyle textStyle =
        theme.useMaterial3 ? theme.textTheme.bodyMedium! : theme.textTheme.bodyText2!;
    final Color? color =
        theme.useMaterial3 ? theme.textTheme.bodySmall!.color : theme.textTheme.caption!.color;

    return Text(description, style: textStyle.copyWith(color: color));
  }
}
