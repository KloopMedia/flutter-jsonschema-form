import 'widget_model.dart';

class RecorderWidgetModel extends WidgetModel {
  final bool private;

  RecorderWidgetModel(Map<String, dynamic>? options)
      : private = getOption<bool>(options, 'private') ?? false;
}