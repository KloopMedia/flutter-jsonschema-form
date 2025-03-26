import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

class GroupedRadio<T> extends StatefulWidget {
  /// A list of string that describes each checkbox. Each item must be distinct.
  final List<FormBuilderFieldOption<T>> options;

  /// A list of string which specifies automatically checked checkboxes.
  /// Every element must match an item from itemList.
  final T? value;

  /// Specifies which radio option values should be disabled.
  /// If this is null, then no radio options will be disabled.
  final List<T>? disabled;

  /// Specifies the orientation of the elements in itemList.
  final OptionsOrientation orientation;

  /// Called when the value of the checkbox group changes.
  final ValueChanged<T?> onChanged;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  final Color? activeColor;

  /// Configures the minimum size of the tap target.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// The color for the checkbox's Material when it has the input focus.
  final Color? focusColor;

  /// The color for the checkbox's Material when a pointer is hovering over it.
  final Color? hoverColor;

  //.......................WRAP ORIENTATION.....................................

  /// The direction to use as the main axis.
  ///
  /// For example, if [wrapDirection] is [Axis.horizontal], the default, the
  /// children are placed adjacent to one another in a horizontal run until the
  /// available horizontal space is consumed, at which point a subsequent
  /// children are placed in a new run vertically adjacent to the previous run.
  final Axis wrapDirection;

  /// How the children within a run should be placed in the main axis.
  ///
  /// For example, if [wrapAlignment] is [WrapAlignment.center], the children in
  /// each run are grouped together in the center of their run in the main axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapRunAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  ///  * [wrapCrossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment wrapAlignment;

  /// How much space to place between children in a run in the main axis.
  ///
  /// For example, if [wrapSpacing] is 10.0, the children will be spaced at least
  /// 10.0 logical pixels apart in the main axis.
  ///
  /// If there is additional free space in a run (e.g., because the wrap has a
  /// minimum size that is not filled or because some runs are longer than
  /// others), the additional free space will be allocated according to the
  /// [wrapAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapSpacing;

  /// How the runs themselves should be placed in the cross axis.
  ///
  /// For example, if [wrapRunAlignment] is [WrapAlignment.center], the runs are
  /// grouped together in the center of the overall [Wrap] in the cross axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapAlignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [wrapCrossAxisAlignment], which controls how the children within each run
  ///    are placed relative to each other in the cross axis.
  final WrapAlignment wrapRunAlignment;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [wrapRunSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// If there is additional free space in the overall [Wrap] (e.g., because
  /// the wrap has a minimum size that is not filled), the additional free space
  /// will be allocated according to the [wrapRunAlignment].
  ///
  /// Defaults to 0.0.
  final double wrapRunSpacing;

  /// How the children within a run should be aligned relative to each other in
  /// the cross axis.
  ///
  /// For example, if this is set to [WrapCrossAlignment.end], and the
  /// [wrapDirection] is [Axis.horizontal], then the children within each
  /// run will have their bottom edges aligned to the bottom edge of the run.
  ///
  /// Defaults to [WrapCrossAlignment.start].
  ///
  /// See also:
  ///
  ///  * [wrapAlignment], which controls how the children within each run are placed
  ///    relative to each other in the main axis.
  ///  * [wrapRunAlignment], which controls how the runs are placed relative to each
  ///    other in the cross axis.
  final WrapCrossAlignment wrapCrossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If the [wrapDirection] is [Axis.horizontal], this controls order in which the
  /// children are positioned (left-to-right or right-to-left), and the meaning
  /// of the [wrapAlignment] property's [WrapAlignment.start] and
  /// [WrapAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], and either the
  /// [wrapAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], or
  /// there's more than one child, then the [wrapTextDirection] (or the ambient
  /// [Directionality]) must not be null.
  ///
  /// If the [wrapDirection] is [Axis.vertical], this controls the order in which
  /// runs are positioned, the meaning of the [wrapRunAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [wrapCrossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.vertical], and either the
  /// [wrapRunAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [wrapCrossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [wrapTextDirection] (or the ambient [Directionality]) must not be null.
  final TextDirection? wrapTextDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// If the [wrapDirection] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [wrapAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.vertical], and either the [wrapAlignment]
  /// is either [WrapAlignment.start] or [WrapAlignment.end], or there's
  /// more than one child, then the [wrapVerticalDirection] must not be null.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], this controls the order in which
  /// runs are positioned, the meaning of the [wrapRunAlignment] property's
  /// [WrapAlignment.start] and [WrapAlignment.end] values, as well as the
  /// [wrapCrossAxisAlignment] property's [WrapCrossAlignment.start] and
  /// [WrapCrossAlignment.end] values.
  ///
  /// If the [wrapDirection] is [Axis.horizontal], and either the
  /// [wrapRunAlignment] is either [WrapAlignment.start] or [WrapAlignment.end], the
  /// [wrapCrossAxisAlignment] is either [WrapCrossAlignment.start] or
  /// [WrapCrossAlignment.end], or there's more than one child, then the
  /// [wrapVerticalDirection] must not be null.
  final VerticalDirection wrapVerticalDirection;

  final Widget? separator;

  final ControlAffinity controlAffinity;

  final ScrollPhysics? physics;

  final bool showAlternativeTheme;

  final bool showCorrectResponses;

  final dynamic correctAnswer;

  const GroupedRadio({
    super.key,
    required this.options,
    required this.orientation,
    required this.onChanged,
    this.value,
    this.disabled,
    this.activeColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.wrapDirection = Axis.horizontal,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapSpacing = 0.0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
    this.separator,
    this.controlAffinity = ControlAffinity.leading,
    this.physics,
    this.showAlternativeTheme = false,
    this.showCorrectResponses = false,
    this.correctAnswer,
  });

  @override
  State<GroupedRadio<T?>> createState() => _GroupedRadioState<T>();
}

class _GroupedRadioState<T> extends State<GroupedRadio<T?>> {
  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (int i = 0; i < widget.options.length; i++) {
      Widget button;
      if (widget.showCorrectResponses) {
        button = _buildCorrectResponses(i);
      } else if (widget.showAlternativeTheme) {
        button = _buildAlternativeRadioButton(i);
      } else {
        button = _buildRadioButton(i);
      }
      widgetList.add(button);
    }

    switch (widget.orientation) {
      case OptionsOrientation.vertical:
        return Container(
          width: double.infinity,
          padding: widget.showCorrectResponses ? EdgeInsets.all(8) : null,
          decoration: widget.showCorrectResponses
              ? BoxDecoration(color: Color(0xFFEFF1F1), borderRadius: BorderRadius.circular(15))
              : null,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: widget.physics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetList,
            ),
          ),
        );
      case OptionsOrientation.horizontal:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: widget.physics,
          child: Row(children: widgetList),
        );
      case OptionsOrientation.wrap:
      default:
        return SingleChildScrollView(
          physics: widget.physics,
          child: Wrap(
            spacing: widget.wrapSpacing,
            runSpacing: widget.wrapRunSpacing,
            textDirection: widget.wrapTextDirection,
            crossAxisAlignment: widget.wrapCrossAxisAlignment,
            verticalDirection: widget.wrapVerticalDirection,
            alignment: widget.wrapAlignment,
            direction: Axis.horizontal,
            runAlignment: widget.wrapRunAlignment,
            children: widgetList,
          ),
        );
    }
  }

  Widget _buildRadioButton(int index) {
    final option = widget.options[index];
    final optionValue = option.value;
    final isOptionDisabled = true == widget.disabled?.contains(optionValue);
    final control = Transform.scale(
      scale: 1.15,
      alignment: Alignment.centerLeft,
      child: Radio<T?>(
        groupValue: widget.value,
        activeColor: widget.activeColor,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        materialTapTargetSize: widget.materialTapTargetSize,
        value: optionValue,
        onChanged: isOptionDisabled
            ? null
            : (T? selected) {
                widget.onChanged(selected);
              },
      ),
    );

    final label = GestureDetector(
      onTap: isOptionDisabled
          ? null
          : () {
              widget.onChanged(optionValue);
            },
      child: Transform.scale(scale: 1.13, alignment: Alignment.centerLeft, child: option),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.controlAffinity == ControlAffinity.leading) control,
            if (kIsWeb) const SizedBox(width: 5),
            Flexible(child: Padding(padding: const EdgeInsets.only(right: 25), child: label)),
            if (widget.controlAffinity == ControlAffinity.trailing) control,
            if (widget.orientation != OptionsOrientation.vertical &&
                widget.separator != null &&
                index != widget.options.length - 1)
              widget.separator!,
          ],
        ),
        if (widget.orientation == OptionsOrientation.vertical &&
            widget.separator != null &&
            index != widget.options.length - 1)
          widget.separator!,
      ],
    );
  }

  Widget _buildAlternativeRadioButton(int index) {
    final option = widget.options[index];
    final optionValue = option.value;
    final activeColor = Color(0xFFC1C8FD);
    final activeBorderColor = Color(0xFF5E81FB);
    final defaultColor = Color(0xFFEFEFFF);
    final disabledColor = Color(0xFFEFF1F1);
    final disabledBorderColor = Color(0xFFC6C5D0);
    final isSelected = optionValue == widget.value;
    final isOptionDisabled = true == widget.disabled?.contains(optionValue);

    int textLength;
    try {
      textLength = (option.child as Text).data!.length;
    } catch (e) {
      textLength = 0;
    }

    final label = GestureDetector(
      onTap: isOptionDisabled
          ? null
          : () {
              widget.onChanged(optionValue);
            },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: isOptionDisabled ? disabledBorderColor : activeBorderColor,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isOptionDisabled
              ? disabledColor
              : isSelected
                  ? activeColor
                  : defaultColor,
          boxShadow: isOptionDisabled
              ? null
              : [
                  BoxShadow(
                    color: activeBorderColor, // Hex color code
                    offset: Offset(0, 1), // Horizontal and vertical offsets
                    blurRadius: 0, // The blur radius
                    spreadRadius: 0, // The spread radius
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: DefaultTextStyle.merge(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            child: option,
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCorrectResponses(int index) {
    final option = widget.options[index];
    final optionValue = option.value;
    final activeColor = Color(0xFFDBF1C9);
    final defaultColor = Color(0xFFEFF1F1);
    final activeFontColor = Color(0xFF207413);
    final isCorrect = optionValue == widget.correctAnswer;

    final label = Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCorrect ? activeColor : defaultColor,
      ),
      child: Wrap(
        children: [
          Icon(
            isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isCorrect ? Color(0xFF4A9627) : Color(0xFFFF897D),
          ),
          SizedBox(width: 8),
          Text(
            (option.child as Text).data.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isCorrect ? activeFontColor : Colors.black,
            ),
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        SizedBox(height: 8),
      ],
    );
  }
}
