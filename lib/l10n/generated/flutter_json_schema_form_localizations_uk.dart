import 'flutter_json_schema_form_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class FlutterJsonSchemaFormLocalizationsUk extends FlutterJsonSchemaFormLocalizations {
  FlutterJsonSchemaFormLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get submit => 'Надіслати';

  @override
  String get select_file_start => 'Виберіть файл';

  @override
  String get select_file_end => ' для завантаження';

  @override
  String get file_upload_success => 'Файл успішно завантажено';

  @override
  String get answer_correct => 'Правильно';

  @override
  String get answer_wrong => 'Неправильно';

  @override
  String get quiz_score => 'Відсоток правильних відповідей:';
}
