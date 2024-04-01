import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OverrideFormBuilderLocalizationsKy extends FormBuilderLocalizationsImplEn {
  OverrideFormBuilderLocalizationsKy();

  static const LocalizationsDelegate<FormBuilderLocalizationsImpl> delegate =
  FormLocalizationsDelegateKy();

  static const List<Locale> supportedLocales = [Locale('ky')];

  // Override a field and return your translation.
  @override
  String get requiredErrorText => 'Бул жер бош болбошу керек.';
}

class FormLocalizationsDelegateKy extends LocalizationsDelegate<FormBuilderLocalizationsImpl> {
  const FormLocalizationsDelegateKy();

  @override
  Future<FormBuilderLocalizationsImpl> load(Locale locale) {
    final instance = OverrideFormBuilderLocalizationsKy();
    // IMPORTANT!! must to invoke setCurrentInstance()
    FormBuilderLocalizations.setCurrentInstance(instance);
    return SynchronousFuture<FormBuilderLocalizationsImpl>(instance);
  }

  @override
  bool isSupported(Locale locale) =>
      OverrideFormBuilderLocalizationsKy.supportedLocales.contains(locale);

  @override
  bool shouldReload(FormLocalizationsDelegateKy old) => false;
}