import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart' hide GroupedRadio;

import '../image_viewer_widget/image_field.dart';
import '../radio_widget/grouped_radio.dart';

/// Field to select one value from a list of Radio Widgets
class ImageRadioWidget<T> extends FormBuilderFieldDecoration<T> {
  final Axis wrapDirection;
  final Color? activeColor;
  final Color? focusColor;
  final Color? hoverColor;
  final ControlAffinity controlAffinity;
  final double wrapRunSpacing;
  final double wrapSpacing;
  final List<FormBuilderFieldOption<T>> options;
  final List<T>? disabled;
  final MaterialTapTargetSize? materialTapTargetSize;
  final OptionsOrientation orientation;
  final TextDirection? wrapTextDirection;
  final VerticalDirection wrapVerticalDirection;
  final Widget? separator;
  final WrapAlignment wrapAlignment;
  final WrapAlignment wrapRunAlignment;
  final WrapCrossAlignment wrapCrossAxisAlignment;
  final ScrollPhysics? physics;
  final List<String> images;
  final bool alternativeTheme;
  final bool showCorrectResponses;
  final dynamic correctAnswer;

  /// Creates field to select one value from a list of Radio Widgets
  ImageRadioWidget({
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.decoration,
    super.key,
    required super.name,
    required this.options,
    super.initialValue,
    this.activeColor,
    this.controlAffinity = ControlAffinity.leading,
    this.disabled,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.orientation = OptionsOrientation.wrap,
    this.separator,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapDirection = Axis.horizontal,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.wrapSpacing = 0.0,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.restorationId,
    this.physics,
    required this.images,
    this.alternativeTheme = false,
    this.showCorrectResponses = false,
    this.correctAnswer,
  }) : super(
          builder: (FormFieldState<T?> field) {
            final state = field as _ImageRadioWidgetState<T>;

            return InputDecorator(
              decoration: state.decoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageRow(
                    images: images,
                  ),
                  GroupedRadio<T>(
                    activeColor: activeColor,
                    controlAffinity: controlAffinity,
                    disabled:
                        state.enabled ? disabled : options.map((option) => option.value).toList(),
                    focusColor: focusColor,
                    hoverColor: hoverColor,
                    materialTapTargetSize: materialTapTargetSize,
                    onChanged: (value) {
                      state.didChange(value);
                    },
                    options: options,
                    orientation: orientation,
                    separator: separator,
                    value: state.value,
                    wrapAlignment: wrapAlignment,
                    wrapCrossAxisAlignment: wrapCrossAxisAlignment,
                    wrapDirection: wrapDirection,
                    wrapRunAlignment: wrapRunAlignment,
                    wrapRunSpacing: wrapRunSpacing,
                    wrapSpacing: wrapSpacing,
                    wrapTextDirection: wrapTextDirection,
                    wrapVerticalDirection: wrapVerticalDirection,
                    physics: physics,
                    showAlternativeTheme: alternativeTheme,
                    showCorrectResponses: showCorrectResponses,
                    correctAnswer: correctAnswer,
                  ),
                ],
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<ImageRadioWidget<T>, T> createState() =>
      _ImageRadioWidgetState<T>();
}

class _ImageRadioWidgetState<T>
    extends FormBuilderFieldDecorationState<ImageRadioWidget<T>, T> {}
