import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart' hide GroupedRadio;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../radio_widget/grouped_radio.dart';

/// Field to select one value from a list of Radio Widgets
class YoutubeRadioWidget<T> extends FormBuilderFieldDecoration<T> {
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
  final String videoId;
  final bool alternativeTheme;
  final bool showCorrectResponses;
  final dynamic correctAnswer;

  /// Creates field to select one value from a list of Radio Widgets
  YoutubeRadioWidget({
    required this.videoId,
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
    this.alternativeTheme = false,
    this.showCorrectResponses = false,
    this.correctAnswer,
  }) : super(
          builder: (FormFieldState<T?> field) {
            final state = field as _VideoRadioWidgetState<T>;

            return InputDecorator(
              decoration: state.decoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideoContainer(
                    videoId: videoId,
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
  FormBuilderFieldDecorationState<YoutubeRadioWidget<T>, T> createState() =>
      _VideoRadioWidgetState<T>();
}

class _VideoRadioWidgetState<T> extends FormBuilderFieldDecorationState<YoutubeRadioWidget<T>, T> {}

class VideoContainer extends StatefulWidget {
  final String videoId;

  const VideoContainer({super.key, required this.videoId});

  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(iframeAllowFullscreen: true),
        initialData: InAppWebViewInitialData(data: """
      <iframe width="100%" height="97%" src="https://www.youtube.com/embed/${widget.videoId}" title="YouTube video player" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
      """),
      ),
    );
  }
}
