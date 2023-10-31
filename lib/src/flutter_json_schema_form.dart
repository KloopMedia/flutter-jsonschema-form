import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'bloc/form_bloc/form_bloc.dart' as bloc;
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
  final Text? submitButtonText;
  final List<String>? addFileText;
  final PageStorageKey? pageStorageKey;
  final List<Widget>? buttons;

  const FlutterJsonSchemaForm({
    Key? key,
    required this.schema,
    this.uiSchema,
    this.formData,
    this.onChange,
    this.onSubmit,
    this.onValidationFailed,
    this.onWebhookTrigger,
    this.storage,
    this.disabled = false,
    this.submitButtonText,
    this.addFileText,
    this.pageStorageKey,
    this.onDownloadFile,
    this.buttons,
  }) : super(key: key);

  @override
  State<FlutterJsonSchemaForm> createState() => _FlutterJsonSchemaFormState();
}

class _FlutterJsonSchemaFormState extends State<FlutterJsonSchemaForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final List<Field> fields;
  late final List<Field> serializedField;

  @override
  void initState() {
    fields = parseSchema(schema: widget.schema, uiSchema: widget.uiSchema);
    serializedField = serializeFields(fields, widget.formData ?? {});
    super.initState();
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        context.read<bloc.FormBloc>().add(bloc.SubmitFormEvent());
      },
      child: widget.submitButtonText ?? const Text('Submit'),
    );
  }

  List<Widget> _buildFormButtons(BuildContext context) {
    final submitButton = _buildSubmitButton(context);
    final buttons = [...widget.buttons ?? [], if (!widget.disabled) submitButton];

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
    return BlocProvider(
      create: (context) => bloc.FormBloc(
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
        addFileText: widget.addFileText,
      ),
      child: FormBuilder(
        key: _formKey,
        child: CustomScrollView(
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
            SliverToBoxAdapter(
              child: Builder(builder: (context) {
                final buttons = _buildFormButtons(context);
                if (buttons.length > 2) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: buttons);
                } else {
                  return Row(children: buttons);
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
