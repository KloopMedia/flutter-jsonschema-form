import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'flutter_json_schema_form_localizations_en.dart';
import 'flutter_json_schema_form_localizations_ky.dart';
import 'flutter_json_schema_form_localizations_ru.dart';
import 'flutter_json_schema_form_localizations_uk.dart';

/// Callers can lookup localized strings with an instance of FlutterJsonSchemaFormLocalizations
/// returned by `FlutterJsonSchemaFormLocalizations.of(context)`.
///
/// Applications need to include `FlutterJsonSchemaFormLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/flutter_json_schema_form_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FlutterJsonSchemaFormLocalizations.localizationsDelegates,
///   supportedLocales: FlutterJsonSchemaFormLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the FlutterJsonSchemaFormLocalizations.supportedLocales
/// property.
abstract class FlutterJsonSchemaFormLocalizations {
  FlutterJsonSchemaFormLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FlutterJsonSchemaFormLocalizations? of(BuildContext context) {
    return Localizations.of<FlutterJsonSchemaFormLocalizations>(context, FlutterJsonSchemaFormLocalizations);
  }

  static const LocalizationsDelegate<FlutterJsonSchemaFormLocalizations> delegate = _FlutterJsonSchemaFormLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('ky'),
    Locale('uk')
  ];

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @select_file_start.
  ///
  /// In en, this message translates to:
  /// **'Select file'**
  String get select_file_start;

  /// No description provided for @select_file_end.
  ///
  /// In en, this message translates to:
  /// **' to upload'**
  String get select_file_end;

  /// No description provided for @file_upload_success.
  ///
  /// In en, this message translates to:
  /// **'File was uploaded successfully'**
  String get file_upload_success;

  /// No description provided for @answer_correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get answer_correct;

  /// No description provided for @answer_wrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get answer_wrong;

  /// No description provided for @quiz_score.
  ///
  /// In en, this message translates to:
  /// **'Percentage of correct answers:'**
  String get quiz_score;
}

class _FlutterJsonSchemaFormLocalizationsDelegate extends LocalizationsDelegate<FlutterJsonSchemaFormLocalizations> {
  const _FlutterJsonSchemaFormLocalizationsDelegate();

  @override
  Future<FlutterJsonSchemaFormLocalizations> load(Locale locale) {
    return SynchronousFuture<FlutterJsonSchemaFormLocalizations>(lookupFlutterJsonSchemaFormLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ky', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_FlutterJsonSchemaFormLocalizationsDelegate old) => false;
}

FlutterJsonSchemaFormLocalizations lookupFlutterJsonSchemaFormLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return FlutterJsonSchemaFormLocalizationsEn();
    case 'ky': return FlutterJsonSchemaFormLocalizationsKy();
    case 'ru': return FlutterJsonSchemaFormLocalizationsRu();
    case 'uk': return FlutterJsonSchemaFormLocalizationsUk();
  }

  throw FlutterError(
    'FlutterJsonSchemaFormLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
