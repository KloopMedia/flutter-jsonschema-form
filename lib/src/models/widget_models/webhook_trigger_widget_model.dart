import 'widget_model.dart';

class WebhookTriggerWidgetModel extends WidgetModel {
  final String? label;

  WebhookTriggerWidgetModel(Map<String, dynamic>? options)
      : label = getOption<String>(options, 'label');
}
