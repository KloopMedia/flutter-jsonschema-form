import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class CheckboxWidget extends StatefulWidget {
  final String? title;
  final String? description;
  final bool? value;
  final WidgetOnChangeCallback<bool> onChange;

  const CheckboxWidget({
    Key? key,
    required this.value,
    required this.onChange,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  late var _isActive = widget.value;
  late final _title = widget.title;
  late final _description = widget.description;
  late final Widget? _titleWidget = _title != null ? Text(_title!) : null;
  late final Widget? _descriptionWidget = _description != null ? Text(_description!) : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CheckboxListTile(
        title: _titleWidget,
        subtitle: _descriptionWidget,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        value: _isActive ?? false,
        onChanged: (newValue) {
          setState(() {
            _isActive = newValue;
          });
          widget.onChange(newValue);
        },
      ),
    );
  }
}
