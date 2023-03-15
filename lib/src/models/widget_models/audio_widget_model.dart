import 'widget_model.dart';

class AudioWidgetModel extends WidgetModel {
  final bool private;
  final String? url;

  AudioWidgetModel(Map<String, dynamic>? options)
      : private = getOption<bool>(options, 'private') ?? false,
        url = getOption<String>(options, 'default');
}