import 'flutter_json_schema_form_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class FlutterJsonSchemaFormLocalizationsEn extends FlutterJsonSchemaFormLocalizations {
  FlutterJsonSchemaFormLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get submit => 'Submit';

  @override
  String get select_file_start => 'Select file';

  @override
  String get select_file_end => ' to upload';

  @override
  String get file_upload_success => 'File was uploaded successfully';

  @override
  String get answer_correct => 'Correct';

  @override
  String get answer_wrong => 'Wrong';

  @override
  String get quiz_score => 'Percentage of correct answers:';
}
