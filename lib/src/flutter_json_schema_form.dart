import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/l10n/form_localization_ky.dart';
import 'package:flutter_json_schema_form/l10n/loc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../l10n/generated/flutter_json_schema_form_localizations.dart';
import 'bloc/form_bloc/form_bloc.dart';
import 'helpers/helpers.dart';
import 'models/models.dart';

typedef ChangeFormCallback = Function(Map<String, dynamic> formData, String path);
typedef SubmitFormCallback = Function(Map<String, dynamic> formData);
typedef ValidationWarningCallback = void Function(String? error);
typedef WebhookTriggerCallback = void Function();
typedef DownloadFileCallback = Future<String?> Function(String url, String? filename, int? bytes);

class FlutterJsonSchemaForm extends StatefulWidget {
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic>? formData;
  final ChangeFormCallback? onChange;
  final SubmitFormCallback? onSubmit;
  final ValidationWarningCallback? onValidationFailed;
  final WebhookTriggerCallback? onWebhookTrigger;
  final DownloadFileCallback? onDownloadFile;
  final Reference? storage;
  final bool disabled;
  final PageStorageKey? pageStorageKey;
  final List<Widget>? extraButtons;
  final Map<String, dynamic>? correctFormData;
  final bool showCorrectFields;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool hideSubmitButton;
  final String? submitButtonText;
  final bool hideFinalScore;
  final Locale locale;
  final bool alternativeTheme;
  final bool showAlternativeCorrectFields;

  /// Supported locales: English, Russian, Kyrgyz, Ukrainian
  const FlutterJsonSchemaForm({
    super.key,
    required this.schema,
    this.uiSchema,
    this.formData,
    this.onChange,
    this.onSubmit,
    this.onValidationFailed,
    this.onWebhookTrigger,
    this.storage,
    this.disabled = false,
    this.pageStorageKey,
    this.onDownloadFile,
    this.extraButtons,
    this.correctFormData,
    this.showCorrectFields = false,
    this.locale = const Locale('en'),
    this.shrinkWrap = false,
    this.physics,
    this.submitButtonText,
    this.hideSubmitButton = false,
    this.hideFinalScore = false,
    this.alternativeTheme = false,
    this.showAlternativeCorrectFields = false,
  });

  @override
  State<FlutterJsonSchemaForm> createState() => FlutterJsonSchemaFormState();

  FormBloc get formBloc => (key as GlobalKey<FlutterJsonSchemaFormState>).currentState!.formBloc;
}

class FlutterJsonSchemaFormState extends State<FlutterJsonSchemaForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final List<Field> fields;
  late final List<Field> serializedField;
  late final FormBloc formBloc;

  @override
  void initState() {
    fields = parseSchema(schema: widget.schema, uiSchema: widget.uiSchema);
    serializedField = serializeFields(fields, widget.formData ?? {});
    formBloc = FormBloc(
      fields: serializedField,
      formKey: _formKey,
      formData: widget.formData,
      storage: widget.storage,
      disabled: widget.disabled,
      onChangeCallback: widget.onChange,
      onSubmitCallback: widget.onSubmit,
      onValidationCallback: widget.onValidationFailed,
      onWebhookTriggerCallback: widget.onWebhookTrigger,
      onDownloadFileCallback: widget.onDownloadFile,
      correctFormData: widget.correctFormData,
      showCorrectFields: widget.showCorrectFields,
      alternativeTheme: widget.alternativeTheme,
      showAlternativeCorrectFields: widget.showAlternativeCorrectFields,
    );
    super.initState();
  }

  int? _calculateFormScore(BuildContext context) {
    final correctFormData = widget.correctFormData;
    if (correctFormData == null || correctFormData.isEmpty) {
      return null;
    }

    final correctAnswersTotalSize = correctFormData.length;
    var correctAnswerCount = 0;

    for (var field in serializedField) {
      if (field is ValueField) {
        final formData = widget.formData ?? {};
        final value = getFormDataByPath(formData, field.path);
        final isCorrect = field.checkFieldAnswer(context, value) ?? false;
        if (isCorrect) {
          correctAnswerCount += 1;
        }
      }
    }

    final score = (correctAnswerCount * 100 / correctAnswersTotalSize).round();

    return score;
  }

  void handleSubmit(BuildContext context) {
    context.read<FormBloc>().add(SubmitFormEvent());
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: theme.primary,
        foregroundColor:
            Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
      ),
      onPressed: () => handleSubmit(context),
      child: Text(widget.submitButtonText ?? context.loc.submit),
    );
  }

  List<Widget> _buildFormButtons(BuildContext context) {
    final submitButton = _buildSubmitButton(context);
    final buttons = [
      ...widget.extraButtons ?? [],
      if (!widget.disabled && !widget.hideSubmitButton) submitButton
    ];

    List<Widget> wrappedButtons = [];
    for (var i = 0; i < buttons.length; i++) {
      final double start = i == 0 ? 0 : 5;
      final double end = i == buttons.length - 1 ? 0 : 5;
      final paddingVertical = EdgeInsets.only(top: start, bottom: end);
      final paddingHorizontal = EdgeInsets.only(left: start, right: end);
      final isColumn = buttons.length > 2;

      wrappedButtons.add(
        Expanded(
          flex: isColumn ? 0 : 1,
          child: Container(
            padding: isColumn ? paddingVertical : paddingHorizontal,
            height: 52,
            child: buttons[i],
          ),
        ),
      );
    }

    return wrappedButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: widget.locale,
      delegates: const [
        ...FlutterJsonSchemaFormLocalizations.localizationsDelegates,
        FormBuilderLocalizations.delegate,
        FormLocalizationsDelegateKy(),
      ],
      child: BlocProvider(
        create: (context) => formBloc,
        child: FormBuilder(
          key: _formKey,
          child: CustomScrollView(
            key: widget.pageStorageKey,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final field = serializedField[index];
                    return field.build(context);
                  },
                  childCount: serializedField.length,
                ),
              ),
              Builder(
                builder: (context) {
                  if (!widget.hideFinalScore &&
                      widget.showCorrectFields &&
                      widget.correctFormData != null &&
                      widget.correctFormData!.isNotEmpty) {
                    final value = _calculateFormScore(context);

                    return SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: correctContainerDecoration,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.error_outline),
                            ),
                            Text(
                              "${context.loc.quiz_score} $value",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8.0),
                  child: Builder(builder: (context) {
                    final buttons = _buildFormButtons(context);
                    if (buttons.length > 2) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: buttons,
                      );
                    } else {
                      return Row(children: buttons);
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
